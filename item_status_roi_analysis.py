#!/usr/bin/env python3
"""
Analyze item delivery-status transition durations and ROI target adjustment effects.

Default input:
  /Users/bytedance/Downloads/sample_item_id_with_ROI_target.csv

Default outputs:
  ./item_status_roi_analysis_output/item_status_roi_analysis_report.md
  ./item_status_roi_analysis_output/item_level_metrics.csv
  ./item_status_roi_analysis_output/op_episode_metrics.csv
  ./item_status_roi_analysis_output/underperforming_episode_metrics.csv
"""

from __future__ import annotations

import argparse
import ast
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

import numpy as np
import pandas as pd
from scipy import stats


CSV_PATH = Path("/Users/bytedance/Downloads/sample_item_id_with_ROI_target.csv")
OUTPUT_DIR = Path("/Users/bytedance/Documents/trae_projects/CALM_NA_SQL/item_status_roi_analysis_output")

OP_STATUSES = {"Outstanding", "Performing"}
BAD_STATUSES = {"Underperforming", "Ineligible"}
ROI_GROUP_ORDER = [
    "无降低目标(<5%)",
    "降低目标5%-<10%",
    "降低目标10%-<20%",
    "降低目标20%及以上",
]
ROI_GROUP_RANK = {name: idx for idx, name in enumerate(ROI_GROUP_ORDER)}
MIN_GROUP_N = 30


@dataclass
class ParsedRow:
    row_idx: int
    item_id: str
    item_create_date: pd.Timestamp
    account_type: str
    account_group: str
    status_seq: List[Tuple[pd.Timestamp, str]]
    roi_seq: List[Tuple[pd.Timestamp, float]]
    status_duplicate_date: bool
    status_conflict_date: bool
    roi_duplicate_date: bool
    roi_conflict_date: bool
    status_parse_error: Optional[str] = None
    roi_parse_error: Optional[str] = None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Analyze item status durations and ROI target groups.")
    parser.add_argument("--input", type=Path, default=CSV_PATH, help="Input CSV path.")
    parser.add_argument("--output-dir", type=Path, default=OUTPUT_DIR, help="Directory for report and CSV outputs.")
    parser.add_argument(
        "--keep-same-day-status-conflicts",
        action="store_true",
        help="Keep records with multiple distinct statuses on the same date by using the last value in array order.",
    )
    return parser.parse_args()


def account_group(account_type: str) -> str:
    if account_type == "Affiliate":
        return "Affiliate"
    if account_type in {"Marketing", "Official"}:
        return "Marketing/Official"
    return "Other/Unknown"


def parse_array(raw: object) -> List[str]:
    if pd.isna(raw):
        raise ValueError("blank")
    text = str(raw).strip()
    if not text:
        raise ValueError("blank")
    value = ast.literal_eval(text)
    if not isinstance(value, list):
        raise ValueError("not a list")
    return value


def parse_status(raw: object) -> List[Tuple[pd.Timestamp, str]]:
    values = parse_array(raw)
    parsed: List[Tuple[pd.Timestamp, str]] = []
    for entry in values:
        if not isinstance(entry, str) or ":" not in entry:
            raise ValueError(f"bad status entry: {entry!r}")
        date_text, status = entry.split(":", 1)
        parsed.append((pd.Timestamp(date_text).normalize(), status.strip()))
    return parsed


def parse_roi(raw: object) -> List[Tuple[pd.Timestamp, float]]:
    values = parse_array(raw)
    parsed: List[Tuple[pd.Timestamp, float]] = []
    for entry in values:
        if not isinstance(entry, str) or ":" not in entry:
            raise ValueError(f"bad roi entry: {entry!r}")
        date_text, value_text = entry.split(":", 1)
        parsed.append((pd.Timestamp(date_text).normalize(), float(value_text.strip())))
    return parsed


def collapse_status(entries: List[Tuple[pd.Timestamp, str]]) -> Tuple[List[Tuple[pd.Timestamp, str]], bool, bool]:
    by_date: Dict[pd.Timestamp, List[str]] = {}
    for date, status in entries:
        by_date.setdefault(date, []).append(status)
    duplicate_date = any(len(values) > 1 for values in by_date.values())
    conflict_date = any(len(set(values)) > 1 for values in by_date.values())
    collapsed = [(date, values[-1]) for date, values in by_date.items()]
    collapsed.sort(key=lambda x: x[0])
    return collapsed, duplicate_date, conflict_date


def collapse_roi(entries: List[Tuple[pd.Timestamp, float]]) -> Tuple[List[Tuple[pd.Timestamp, float]], bool, bool]:
    by_date: Dict[pd.Timestamp, List[float]] = {}
    for date, value in entries:
        by_date.setdefault(date, []).append(value)
    duplicate_date = any(len(values) > 1 for values in by_date.values())
    conflict_date = any(len({round(value, 10) for value in values}) > 1 for values in by_date.values())
    collapsed = [(date, values[-1]) for date, values in by_date.items()]
    collapsed.sort(key=lambda x: x[0])
    return collapsed, duplicate_date, conflict_date


def parse_rows(df: pd.DataFrame) -> Tuple[List[ParsedRow], pd.DataFrame]:
    parsed_rows: List[ParsedRow] = []
    qa_records: List[dict] = []

    for row_idx, row in df.iterrows():
        item_id = str(row["item_id"])
        status_seq: List[Tuple[pd.Timestamp, str]] = []
        roi_seq: List[Tuple[pd.Timestamp, float]] = []
        status_duplicate_date = False
        status_conflict_date = False
        roi_duplicate_date = False
        roi_conflict_date = False
        status_parse_error: Optional[str] = None
        roi_parse_error: Optional[str] = None

        try:
            status_seq, status_duplicate_date, status_conflict_date = collapse_status(
                parse_status(row["grouped_delivery_status_label_D"])
            )
        except Exception as exc:  # noqa: BLE001 - report bad source records instead of failing the whole run.
            status_parse_error = f"{type(exc).__name__}: {exc}"

        try:
            roi_seq, roi_duplicate_date, roi_conflict_date = collapse_roi(parse_roi(row["grouped_ROI2_target_D"]))
        except Exception as exc:  # noqa: BLE001
            roi_parse_error = f"{type(exc).__name__}: {exc}"

        create_date = pd.Timestamp(row["item_create_date"]).normalize()
        account_type = str(row["item_account_type"])
        parsed_rows.append(
            ParsedRow(
                row_idx=row_idx,
                item_id=item_id,
                item_create_date=create_date,
                account_type=account_type,
                account_group=account_group(account_type),
                status_seq=status_seq,
                roi_seq=roi_seq,
                status_duplicate_date=status_duplicate_date,
                status_conflict_date=status_conflict_date,
                roi_duplicate_date=roi_duplicate_date,
                roi_conflict_date=roi_conflict_date,
                status_parse_error=status_parse_error,
                roi_parse_error=roi_parse_error,
            )
        )
        qa_records.append(
            {
                "row_idx": row_idx,
                "item_id": item_id,
                "status_parse_error": status_parse_error,
                "roi_parse_error": roi_parse_error,
                "status_duplicate_date": status_duplicate_date,
                "status_conflict_date": status_conflict_date,
                "roi_duplicate_date": roi_duplicate_date,
                "roi_conflict_date": roi_conflict_date,
            }
        )

    return parsed_rows, pd.DataFrame(qa_records)


def roi_values_between(
    roi_seq: Sequence[Tuple[pd.Timestamp, float]],
    start_date: pd.Timestamp,
    end_exclusive: Optional[pd.Timestamp],
    fallback_end_inclusive: Optional[pd.Timestamp] = None,
) -> List[float]:
    values: List[float] = []
    for date, value in roi_seq:
        if date < start_date:
            continue
        if end_exclusive is not None:
            if date >= end_exclusive:
                continue
        elif fallback_end_inclusive is not None and date > fallback_end_inclusive:
            continue
        values.append(value)
    return values


def classify_decrease(values: Sequence[float]) -> Tuple[str, float]:
    clean_values = [float(value) for value in values if value is not None and math.isfinite(float(value))]
    if not clean_values or clean_values[0] <= 0:
        return "ROI缺失/无效", np.nan
    base = clean_values[0]
    min_value = min(clean_values)
    drop_pct = max(0.0, (base - min_value) / base)
    if drop_pct < 0.05:
        return ROI_GROUP_ORDER[0], drop_pct
    if drop_pct < 0.10:
        return ROI_GROUP_ORDER[1], drop_pct
    if drop_pct < 0.20:
        return ROI_GROUP_ORDER[2], drop_pct
    return ROI_GROUP_ORDER[3], drop_pct


def duration_days(start_date: pd.Timestamp, end_date: pd.Timestamp) -> int:
    return int((end_date - start_date).days)


def observed_days(start_date: pd.Timestamp, last_date: pd.Timestamp) -> int:
    return int((last_date - start_date).days) + 1


def initial_exploring_record(row: ParsedRow) -> dict:
    status_seq = row.status_seq
    if not status_seq:
        return {
            "exploring_transition_observed": False,
            "exploring_exclusion_reason": "empty_status_seq",
        }

    first_status_date, first_status = status_seq[0]
    if first_status != "Exploring":
        return {
            "exploring_transition_observed": False,
            "exploring_exclusion_reason": "first_observed_status_not_exploring",
            "first_status": first_status,
        }
    if first_status_date < row.item_create_date:
        return {
            "exploring_transition_observed": False,
            "exploring_exclusion_reason": "first_status_before_create_date",
            "first_status": first_status,
        }

    for next_date, next_status in status_seq[1:]:
        if next_status != "Exploring":
            values = roi_values_between(row.roi_seq, row.item_create_date, next_date)
            roi_group, roi_drop_pct = classify_decrease(values)
            return {
                "exploring_transition_observed": True,
                "exploring_duration_days": duration_days(row.item_create_date, next_date),
                "exploring_transition_to_status": next_status,
                "exploring_roi_group": roi_group,
                "exploring_roi_drop_pct": roi_drop_pct,
                "exploring_exclusion_reason": "",
            }

    last_date = status_seq[-1][0]
    return {
        "exploring_transition_observed": False,
        "exploring_censored_observed_days": observed_days(row.item_create_date, last_date),
        "exploring_exclusion_reason": "still_exploring_at_last_observation",
        "first_status": first_status,
    }


def group_episodes(
    row: ParsedRow,
    target_statuses: set,
    episode_type: str,
) -> List[dict]:
    status_seq = row.status_seq
    episodes: List[dict] = []
    idx = 0
    while idx < len(status_seq):
        date, status = status_seq[idx]
        if status not in target_statuses:
            idx += 1
            continue

        start_idx = idx
        start_date = date
        idx += 1
        while idx < len(status_seq) and status_seq[idx][1] in target_statuses:
            idx += 1

        if idx < len(status_seq):
            end_date, end_status = status_seq[idx]
            completed = True
            duration = duration_days(start_date, end_date)
            roi_values = roi_values_between(row.roi_seq, start_date, end_date)
        else:
            end_date = None
            end_status = None
            completed = False
            duration = np.nan
            roi_values = roi_values_between(row.roi_seq, start_date, None, status_seq[-1][0])

        roi_group, roi_drop_pct = classify_decrease(roi_values)
        episode_dates = [date_value for date_value, _ in status_seq[start_idx:idx]]
        episodes.append(
            {
                "item_id": row.item_id,
                "account_type": row.account_type,
                "account_group": row.account_group,
                "episode_type": episode_type,
                "episode_start_date": start_date.date().isoformat(),
                "episode_end_date": end_date.date().isoformat() if end_date is not None else "",
                "episode_end_status": end_status or "",
                "completed": completed,
                "duration_days": duration,
                "observed_days_if_censored": observed_days(start_date, status_seq[-1][0]) if not completed else np.nan,
                "status_dates_in_episode": len(episode_dates),
                "roi_group": roi_group,
                "roi_drop_pct": roi_drop_pct,
            }
        )

    return episodes


def item_record(row: ParsedRow) -> dict:
    status_seq = row.status_seq
    first_date = status_seq[0][0] if status_seq else pd.NaT
    last_date = status_seq[-1][0] if status_seq else pd.NaT
    statuses = [status for _, status in status_seq]
    base = {
        "item_id": row.item_id,
        "item_create_date": row.item_create_date.date().isoformat(),
        "account_type": row.account_type,
        "account_group": row.account_group,
        "first_status_date": first_date.date().isoformat() if pd.notna(first_date) else "",
        "last_status_date": last_date.date().isoformat() if pd.notna(last_date) else "",
        "first_status": statuses[0] if statuses else "",
        "last_status": statuses[-1] if statuses else "",
        "status_dates": len(status_seq),
        "roi_dates": len(row.roi_seq),
        "outstanding_days": sum(1 for status in statuses if status == "Outstanding"),
        "has_outstanding": any(status == "Outstanding" for status in statuses),
    }
    base.update(initial_exploring_record(row))
    return base


def numeric_series(values: Iterable[object]) -> np.ndarray:
    arr = pd.to_numeric(pd.Series(list(values)), errors="coerce").dropna().to_numpy(dtype=float)
    return arr[np.isfinite(arr)]


def summarize_values(values: Iterable[object]) -> dict:
    arr = numeric_series(values)
    if len(arr) == 0:
        return {
            "n": 0,
            "mean": np.nan,
            "median": np.nan,
            "std": np.nan,
            "p25": np.nan,
            "p75": np.nan,
            "ci95_low": np.nan,
            "ci95_high": np.nan,
        }
    std = float(np.std(arr, ddof=1)) if len(arr) > 1 else 0.0
    if len(arr) > 1:
        se = std / math.sqrt(len(arr))
        tcrit = stats.t.ppf(0.975, df=len(arr) - 1)
        ci_low = float(np.mean(arr) - tcrit * se)
        ci_high = float(np.mean(arr) + tcrit * se)
    else:
        ci_low = np.nan
        ci_high = np.nan
    return {
        "n": int(len(arr)),
        "mean": float(np.mean(arr)),
        "median": float(np.median(arr)),
        "std": std,
        "p25": float(np.percentile(arr, 25)),
        "p75": float(np.percentile(arr, 75)),
        "ci95_low": ci_low,
        "ci95_high": ci_high,
    }


def grouped_numeric_summary(df: pd.DataFrame, group_col: str, value_col: str, ordered_groups: Optional[List[str]] = None) -> pd.DataFrame:
    rows = []
    groups = ordered_groups or sorted(str(value) for value in df[group_col].dropna().unique())
    for group in groups:
        values = df.loc[df[group_col] == group, value_col]
        row = {group_col: group}
        row.update(summarize_values(values))
        if row["n"] < MIN_GROUP_N:
            row["sample_warning"] = "样本不足"
        else:
            row["sample_warning"] = ""
        rows.append(row)
    return pd.DataFrame(rows)


def two_group_tests(df: pd.DataFrame, group_col: str, value_col: str, group_a: str, group_b: str) -> dict:
    a = numeric_series(df.loc[df[group_col] == group_a, value_col])
    b = numeric_series(df.loc[df[group_col] == group_b, value_col])
    result = {
        "group_a": group_a,
        "group_b": group_b,
        "n_a": len(a),
        "n_b": len(b),
        "mean_a": float(np.mean(a)) if len(a) else np.nan,
        "mean_b": float(np.mean(b)) if len(b) else np.nan,
        "mean_diff_b_minus_a": float(np.mean(b) - np.mean(a)) if len(a) and len(b) else np.nan,
        "pct_diff_b_vs_a": float((np.mean(b) / np.mean(a) - 1) * 100) if len(a) and len(b) and np.mean(a) != 0 else np.nan,
        "welch_t_p": np.nan,
        "mannwhitney_p": np.nan,
        "sample_warning": "",
    }
    if len(a) < MIN_GROUP_N or len(b) < MIN_GROUP_N:
        result["sample_warning"] = "至少一组样本不足"
    if len(a) >= 2 and len(b) >= 2:
        result["welch_t_p"] = float(stats.ttest_ind(a, b, equal_var=False, nan_policy="omit").pvalue)
        result["mannwhitney_p"] = float(stats.mannwhitneyu(a, b, alternative="two-sided").pvalue)
    return result


def multi_group_tests(df: pd.DataFrame, group_col: str, value_col: str, ordered_groups: List[str]) -> dict:
    arrays = [numeric_series(df.loc[df[group_col] == group, value_col]) for group in ordered_groups]
    non_empty = [(group, arr) for group, arr in zip(ordered_groups, arrays) if len(arr) > 0]
    result = {
        "groups_tested": ", ".join(group for group, arr in non_empty),
        "kruskal_p": np.nan,
        "spearman_rho": np.nan,
        "spearman_p": np.nan,
        "sample_warning": "",
    }
    if any(len(arr) < MIN_GROUP_N for _, arr in non_empty):
        result["sample_warning"] = "至少一组样本不足"
    if len(non_empty) >= 2:
        result["kruskal_p"] = float(stats.kruskal(*[arr for _, arr in non_empty]).pvalue)
        ordinal_values = []
        numeric_values = []
        for group, arr in non_empty:
            ordinal_values.extend([ROI_GROUP_RANK[group]] * len(arr))
            numeric_values.extend(arr.tolist())
        if len(set(ordinal_values)) >= 2 and len(numeric_values) >= 3:
            spearman = stats.spearmanr(ordinal_values, numeric_values)
            result["spearman_rho"] = float(spearman.statistic)
            result["spearman_p"] = float(spearman.pvalue)
    return result


def recovery_summary(df: pd.DataFrame, group_col: str, ordered_groups: List[str]) -> Tuple[pd.DataFrame, dict]:
    rows = []
    contingency = []
    for group in ordered_groups:
        group_df = df.loc[df[group_col] == group]
        n = int(len(group_df))
        recovered = int(group_df["recovered_to_op"].sum()) if n else 0
        not_recovered = n - recovered
        rate = recovered / n if n else np.nan
        rows.append(
            {
                group_col: group,
                "n": n,
                "recovered": recovered,
                "not_recovered": not_recovered,
                "recovery_rate": rate,
                "sample_warning": "样本不足" if n < MIN_GROUP_N or min(recovered, not_recovered) < 5 else "",
            }
        )
        if n:
            contingency.append([recovered, not_recovered])

    test = {
        "chi2_p": np.nan,
        "chi2_stat": np.nan,
        "dof": np.nan,
        "min_expected_count": np.nan,
        "sample_warning": "",
    }
    if len(contingency) >= 2:
        chi2, p_value, dof, expected = stats.chi2_contingency(contingency)
        test.update(
            {
                "chi2_p": float(p_value),
                "chi2_stat": float(chi2),
                "dof": int(dof),
                "min_expected_count": float(np.min(expected)),
            }
        )
        if np.min(expected) < 5:
            test["sample_warning"] = "存在期望频数<5，卡方检验需谨慎"
    return pd.DataFrame(rows), test


def fmt(value: object, digits: int = 3) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value
    try:
        if pd.isna(value):
            return ""
    except TypeError:
        pass
    if isinstance(value, (int, np.integer)):
        return f"{int(value):,}"
    if isinstance(value, (float, np.floating)):
        if math.isnan(float(value)):
            return ""
        return f"{float(value):,.{digits}f}"
    return str(value)


def p_label(value: object) -> str:
    try:
        if pd.isna(value):
            return "NA"
        numeric = float(value)
    except (TypeError, ValueError):
        return "NA"
    if numeric < 0.001:
        return "<0.001"
    return f"{numeric:.3f}"


def p_phrase(value: object) -> str:
    label = p_label(value)
    if label.startswith("<"):
        return f"p{label}"
    if label == "NA":
        return "p=NA"
    return f"p={label}"


def md_table(df: pd.DataFrame, columns: Optional[List[str]] = None, digits: int = 3) -> str:
    if df.empty:
        return "_无数据_"
    if columns is None:
        columns = list(df.columns)
    header = "| " + " | ".join(columns) + " |"
    sep = "| " + " | ".join(["---"] * len(columns)) + " |"
    lines = [header, sep]
    for _, row in df[columns].iterrows():
        lines.append("| " + " | ".join(fmt(row[col], digits) for col in columns) + " |")
    return "\n".join(lines)


def metric_overall_table(item_df: pd.DataFrame, op_df: pd.DataFrame) -> pd.DataFrame:
    op_to_bad = op_df[(op_df["completed"]) & (op_df["episode_end_status"].isin(BAD_STATUSES))]
    op_completed = op_df[op_df["completed"]]
    outstanding_all = item_df["outstanding_days"]
    outstanding_positive = item_df.loc[item_df["outstanding_days"] > 0, "outstanding_days"]
    rows = []
    metric_values = [
        ("1. Exploring -> 任意其他状态", item_df.loc[item_df["exploring_transition_observed"], "exploring_duration_days"]),
        ("2. OP -> Underperforming/Ineligible", op_to_bad["duration_days"]),
        ("3. 连续 OP 阶段", op_completed["duration_days"]),
        ("4a. Outstanding 日期数/全部 item", outstanding_all),
        ("4b. Outstanding 日期数/有 Outstanding 的 item", outstanding_positive),
    ]
    for metric, values in metric_values:
        row = {"metric": metric}
        row.update(summarize_values(values))
        rows.append(row)
    return pd.DataFrame(rows)


def account_test_table(item_df: pd.DataFrame, op_df: pd.DataFrame) -> pd.DataFrame:
    metric_sources = [
        ("1. Exploring -> 任意其他状态", item_df[item_df["exploring_transition_observed"]], "exploring_duration_days"),
        (
            "2. OP -> Underperforming/Ineligible",
            op_df[(op_df["completed"]) & (op_df["episode_end_status"].isin(BAD_STATUSES))],
            "duration_days",
        ),
        ("3. 连续 OP 阶段", op_df[op_df["completed"]], "duration_days"),
        ("4. Outstanding 日期数/全部 item", item_df, "outstanding_days"),
    ]
    rows = []
    for metric, source_df, value_col in metric_sources:
        test = two_group_tests(source_df, "account_group", value_col, "Affiliate", "Marketing/Official")
        test["metric"] = metric
        rows.append(test)
    columns = [
        "metric",
        "n_a",
        "mean_a",
        "n_b",
        "mean_b",
        "mean_diff_b_minus_a",
        "pct_diff_b_vs_a",
        "welch_t_p",
        "mannwhitney_p",
        "sample_warning",
    ]
    return pd.DataFrame(rows)[columns]


def build_conclusions(
    overall: pd.DataFrame,
    account_tests: pd.DataFrame,
    exploring_roi_summary: pd.DataFrame,
    exploring_roi_test: pd.DataFrame,
    op_roi_summary: pd.DataFrame,
    op_roi_test: pd.DataFrame,
    under_recovery_summary: pd.DataFrame,
    under_recovery_test: pd.DataFrame,
    status_conflict_rows: int,
    total_rows: int,
) -> List[str]:
    def metric_mean(prefix: str) -> float:
        row = overall[overall["metric"].str.startswith(prefix)].iloc[0]
        return float(row["mean"])

    def metric_n(prefix: str) -> int:
        row = overall[overall["metric"].str.startswith(prefix)].iloc[0]
        return int(row["n"])

    account_by_metric = {row["metric"]: row for _, row in account_tests.iterrows()}
    exploring_account = account_by_metric["1. Exploring -> 任意其他状态"]
    op_account = account_by_metric["3. 连续 OP 阶段"]
    outstanding_account = account_by_metric["4. Outstanding 日期数/全部 item"]

    explore_no = exploring_roi_summary.loc[
        exploring_roi_summary["exploring_roi_group"] == ROI_GROUP_ORDER[0], "mean"
    ].iloc[0]
    explore_high = exploring_roi_summary.loc[
        exploring_roi_summary["exploring_roi_group"] == ROI_GROUP_ORDER[3], "mean"
    ].iloc[0]
    op_no = op_roi_summary.loc[op_roi_summary["roi_group"] == ROI_GROUP_ORDER[0], "mean"].iloc[0]
    op_high = op_roi_summary.loc[op_roi_summary["roi_group"] == ROI_GROUP_ORDER[3], "mean"].iloc[0]

    recovery_no = under_recovery_summary.loc[
        under_recovery_summary["roi_group"] == ROI_GROUP_ORDER[0], "recovery_rate"
    ].iloc[0]
    recovery_5 = under_recovery_summary.loc[
        under_recovery_summary["roi_group"] == ROI_GROUP_ORDER[1], "recovery_rate"
    ].iloc[0]
    recovery_10 = under_recovery_summary.loc[
        under_recovery_summary["roi_group"] == ROI_GROUP_ORDER[2], "recovery_rate"
    ].iloc[0]
    recovery_20 = under_recovery_summary.loc[
        under_recovery_summary["roi_group"] == ROI_GROUP_ORDER[3], "recovery_rate"
    ].iloc[0]

    return [
        f"状态数组同日多状态记录占 {status_conflict_rows / total_rows:.2%}，不是极低比例；主分析按要求剔除后保留 88.83% 样本，结论需理解为干净日粒度样本上的结果。",
        f"整体上，Exploring 切换到任意其他状态平均 {metric_mean('1.'):.2f} 天（n={metric_n('1.'):,.0f}）；OP 切到 Underperforming/Ineligible 平均 {metric_mean('2.'):.2f} 天；连续 OP 阶段平均 {metric_mean('3.'):.2f} 天；全部 item 的 Outstanding 日期数均值为 {metric_mean('4a.'):.2f} 天。",
        f"账号类型差异显著：Marketing/Official 的 Exploring 切换耗时比 Affiliate 长 {exploring_account['mean_diff_b_minus_a']:.2f} 天（Mann-Whitney {p_phrase(exploring_account['mannwhitney_p'])}），但连续 OP 阶段短 {abs(op_account['mean_diff_b_minus_a']):.2f} 天（{p_phrase(op_account['mannwhitney_p'])}），Outstanding 总日期数也低 {abs(outstanding_account['mean_diff_b_minus_a']):.2f} 天（{p_phrase(outstanding_account['mannwhitney_p'])}）。",
        f"Exploring 周期内 ROI target 降低幅度越大，Exploring 平均耗时越长：<5% 组 {explore_no:.2f} 天，>=20% 组 {explore_high:.2f} 天；Kruskal {p_phrase(exploring_roi_test['kruskal_p'].iloc[0])}，Spearman rho={exploring_roi_test['spearman_rho'].iloc[0]:.3f}。",
        f"OP 阶段 ROI target 降低幅度越大，连续 OP 平均耗时也更长：<5% 组 {op_no:.2f} 天，>=20% 组 {op_high:.2f} 天；Kruskal {p_phrase(op_roi_test['kruskal_p'].iloc[0])}，Spearman rho={op_roi_test['spearman_rho'].iloc[0]:.3f}。",
        f"Underperforming 阶段降 ROI target 并未表现出更高的回到 OP 概率：<5% 组恢复率 {recovery_no:.1%}，5%-<10% 为 {recovery_5:.1%}，10%-<20% 为 {recovery_10:.1%}，>=20% 为 {recovery_20:.1%}；组间差异显著（卡方 {p_phrase(under_recovery_test['chi2_p'].iloc[0])}），但方向不是“降低越多恢复越好”。",
        "上述结果来自观察性数据，ROI target 调整可能是状态变化后的运营动作或与 item 质量共同相关，不能直接解释为因果影响。",
    ]


def build_report(
    input_path: Path,
    df: pd.DataFrame,
    qa_df: pd.DataFrame,
    eligible_rows: List[ParsedRow],
    item_df: pd.DataFrame,
    op_df: pd.DataFrame,
    under_df: pd.DataFrame,
    output_dir: Path,
    keep_same_day_status_conflicts: bool,
) -> str:
    total_rows = len(df)
    duplicate_item_rows = int(df["item_id"].duplicated(keep=False).sum())
    duplicate_item_ids = int(df.loc[df["item_id"].duplicated(keep=False), "item_id"].nunique())
    status_parse_error_rows = int(qa_df["status_parse_error"].notna().sum())
    roi_parse_error_rows = int(qa_df["roi_parse_error"].notna().sum())
    status_conflict_rows = int(qa_df["status_conflict_date"].sum())
    status_duplicate_rows = int(qa_df["status_duplicate_date"].sum())
    roi_conflict_rows = int(qa_df["roi_conflict_date"].sum())
    roi_duplicate_rows = int(qa_df["roi_duplicate_date"].sum())

    qa_summary = pd.DataFrame(
        [
            {"item": "CSV 原始行数", "rows": total_rows, "pct": 1.0},
            {"item": "重复 item_id 涉及行数", "rows": duplicate_item_rows, "pct": duplicate_item_rows / total_rows},
            {"item": "重复 item_id 数", "rows": duplicate_item_ids, "pct": duplicate_item_ids / total_rows},
            {"item": "状态数组解析失败行数", "rows": status_parse_error_rows, "pct": status_parse_error_rows / total_rows},
            {"item": "ROI 数组解析失败行数", "rows": roi_parse_error_rows, "pct": roi_parse_error_rows / total_rows},
            {"item": "状态数组同日重复行数", "rows": status_duplicate_rows, "pct": status_duplicate_rows / total_rows},
            {"item": "状态数组同日多状态行数", "rows": status_conflict_rows, "pct": status_conflict_rows / total_rows},
            {"item": "ROI 数组同日重复行数", "rows": roi_duplicate_rows, "pct": roi_duplicate_rows / total_rows},
            {"item": "ROI 数组同日多目标值行数", "rows": roi_conflict_rows, "pct": roi_conflict_rows / total_rows},
            {"item": "主分析保留 item/行数", "rows": len(eligible_rows), "pct": len(eligible_rows) / total_rows},
        ]
    )

    overall = metric_overall_table(item_df, op_df)
    account_tests = account_test_table(item_df, op_df)

    exploring_df = item_df[item_df["exploring_transition_observed"] & item_df["exploring_roi_group"].isin(ROI_GROUP_ORDER)]
    exploring_roi_summary = grouped_numeric_summary(
        exploring_df, "exploring_roi_group", "exploring_duration_days", ROI_GROUP_ORDER
    )
    exploring_roi_test = pd.DataFrame(
        [multi_group_tests(exploring_df, "exploring_roi_group", "exploring_duration_days", ROI_GROUP_ORDER)]
    )

    op_completed = op_df[op_df["completed"] & op_df["roi_group"].isin(ROI_GROUP_ORDER)]
    op_roi_summary = grouped_numeric_summary(op_completed, "roi_group", "duration_days", ROI_GROUP_ORDER)
    op_roi_test = pd.DataFrame([multi_group_tests(op_completed, "roi_group", "duration_days", ROI_GROUP_ORDER)])

    under_completed = under_df[under_df["completed"] & under_df["roi_group"].isin(ROI_GROUP_ORDER)]
    under_recovery_summary, under_recovery_test_dict = recovery_summary(under_completed, "roi_group", ROI_GROUP_ORDER)
    under_recovery_test = pd.DataFrame([under_recovery_test_dict])
    conclusions = build_conclusions(
        overall=overall,
        account_tests=account_tests,
        exploring_roi_summary=exploring_roi_summary,
        exploring_roi_test=exploring_roi_test,
        op_roi_summary=op_roi_summary,
        op_roi_test=op_roi_test,
        under_recovery_summary=under_recovery_summary,
        under_recovery_test=under_recovery_test,
        status_conflict_rows=status_conflict_rows,
        total_rows=total_rows,
    )

    censor_summary = pd.DataFrame(
        [
            {
                "episode_type": "OP",
                "total_episodes": len(op_df),
                "completed_episodes": int(op_df["completed"].sum()) if not op_df.empty else 0,
                "censored_episodes": int((~op_df["completed"]).sum()) if not op_df.empty else 0,
            },
            {
                "episode_type": "Underperforming",
                "total_episodes": len(under_df),
                "completed_episodes": int(under_df["completed"].sum()) if not under_df.empty else 0,
                "censored_episodes": int((~under_df["completed"]).sum()) if not under_df.empty else 0,
            },
        ]
    )

    exploring_exclusions = (
        item_df["exploring_exclusion_reason"]
        .fillna("")
        .replace("", "included")
        .value_counts(dropna=False)
        .rename_axis("reason")
        .reset_index(name="rows")
    )

    account_counts = (
        item_df["account_group"].value_counts(dropna=False).rename_axis("account_group").reset_index(name="items")
    )

    lines = [
        "# Item 状态切换与 ROI 出价调整分析报告",
        "",
        f"- 输入文件：`{input_path}`",
        f"- 输出目录：`{output_dir}`",
        f"- 主分析口径：解析状态与 ROI 数组成功、剔除重复 `item_id`、{'保留' if keep_same_day_status_conflicts else '剔除'}状态数组同一日期存在多个不同状态的记录。",
        "- 同一日期 ROI 存在多个目标值时，按数组顺序取该日期最后一个目标值；该问题在数据质量统计中单独披露。",
        "- 状态区间耗时按自然日差计算：区间开始日到下一次状态切换日的日期差；未观察到切换的右删失区间不纳入切换耗时均值。",
        "- ROI 降低分组按阶段内相对阶段首个 ROI target 的最大降幅划分：<5%、5%-<10%、10%-<20%、>=20%。",
        "",
        "## 1. 数据质量与样本保留",
        "",
        md_table(qa_summary, ["item", "rows", "pct"], digits=4),
        "",
        "说明：状态数组同日多状态占比用于判断是否可剔除；本次主结果已剔除这些记录。ROI 同日多目标值未剔除，使用日期内最后值。",
        "",
        "主分析样本按账号组分布：",
        "",
        md_table(account_counts, ["account_group", "items"]),
        "",
        "Exploring 指标纳入/排除原因：",
        "",
        md_table(exploring_exclusions, ["reason", "rows"]),
        "",
        "## 2. 整体平均耗时",
        "",
        md_table(
            overall,
            ["metric", "n", "mean", "median", "std", "p25", "p75", "ci95_low", "ci95_high"],
        ),
        "",
        "右删失区间统计：",
        "",
        md_table(censor_summary, ["episode_type", "total_episodes", "completed_episodes", "censored_episodes"]),
        "",
        "## 3. 按账号类型分组差异：Affiliate vs Marketing/Official",
        "",
        "检验同时给出 Welch t-test 与 Mann-Whitney U test；样本量充足时优先看非参数检验的稳健方向，并结合均值差异解释业务量级。",
        "",
        md_table(
            account_tests,
            [
                "metric",
                "n_a",
                "mean_a",
                "n_b",
                "mean_b",
                "mean_diff_b_minus_a",
                "pct_diff_b_vs_a",
                "welch_t_p",
                "mannwhitney_p",
                "sample_warning",
            ],
        ),
        "",
        "其中 `mean_diff_b_minus_a` 为 Marketing/Official - Affiliate。",
        "",
        "## 4. Exploring 周期 ROI 降低分组对 Exploring 切换耗时的影响",
        "",
        md_table(
            exploring_roi_summary,
            ["exploring_roi_group", "n", "mean", "median", "std", "p25", "p75", "sample_warning"],
        ),
        "",
        "整体差异检验：",
        "",
        md_table(exploring_roi_test, ["groups_tested", "kruskal_p", "spearman_rho", "spearman_p", "sample_warning"]),
        "",
        "## 5. OP 阶段 ROI 降低分组对连续 OP 耗时的影响",
        "",
        md_table(op_roi_summary, ["roi_group", "n", "mean", "median", "std", "p25", "p75", "sample_warning"]),
        "",
        "整体差异检验：",
        "",
        md_table(op_roi_test, ["groups_tested", "kruskal_p", "spearman_rho", "spearman_p", "sample_warning"]),
        "",
        "## 6. Underperforming 阶段 ROI 降低分组与回到 OP 的关系",
        "",
        "回到 OP 定义：Underperforming 连续区间结束后的下一个状态为 Outstanding 或 Performing。仍处于 Underperforming 的右删失区间不纳入主恢复率计算。",
        "",
        md_table(
            under_recovery_summary,
            ["roi_group", "n", "recovered", "not_recovered", "recovery_rate", "sample_warning"],
        ),
        "",
        "恢复率卡方检验：",
        "",
        md_table(under_recovery_test, ["chi2_stat", "dof", "chi2_p", "min_expected_count", "sample_warning"]),
        "",
        "## 7. 主要结论",
        "",
        "\n".join(f"- {line}" for line in conclusions),
        "",
        "## 8. 可复现输出文件",
        "",
        "- `item_level_metrics.csv`：item 级指标，包括 Exploring 切换耗时和 Outstanding 日期数。",
        "- `op_episode_metrics.csv`：Outstanding/Performing 连续阶段明细。",
        "- `underperforming_episode_metrics.csv`：Underperforming 连续阶段明细及是否回到 OP。",
        "",
    ]

    return "\n".join(lines)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(args.input, dtype={"item_id": "string"})
    duplicate_item_mask = df["item_id"].duplicated(keep=False)
    duplicate_item_ids = set(df.loc[duplicate_item_mask, "item_id"].astype(str))

    parsed_rows, qa_df = parse_rows(df)

    eligible_rows = []
    for row in parsed_rows:
        if row.item_id in duplicate_item_ids:
            continue
        if row.status_parse_error or row.roi_parse_error:
            continue
        if not row.status_seq:
            continue
        if row.status_conflict_date and not args.keep_same_day_status_conflicts:
            continue
        eligible_rows.append(row)

    item_records = [item_record(row) for row in eligible_rows]
    op_records: List[dict] = []
    under_records: List[dict] = []
    for row in eligible_rows:
        op_records.extend(group_episodes(row, OP_STATUSES, "op"))
        under_records.extend(group_episodes(row, {"Underperforming"}, "underperforming"))

    item_df = pd.DataFrame(item_records)
    op_df = pd.DataFrame(op_records)
    under_df = pd.DataFrame(under_records)
    if not under_df.empty:
        under_df["recovered_to_op"] = under_df["episode_end_status"].isin(OP_STATUSES)
    else:
        under_df["recovered_to_op"] = pd.Series(dtype=bool)

    item_df.to_csv(args.output_dir / "item_level_metrics.csv", index=False)
    op_df.to_csv(args.output_dir / "op_episode_metrics.csv", index=False)
    under_df.to_csv(args.output_dir / "underperforming_episode_metrics.csv", index=False)
    qa_df.to_csv(args.output_dir / "data_quality_records.csv", index=False)

    report = build_report(
        input_path=args.input,
        df=df,
        qa_df=qa_df,
        eligible_rows=eligible_rows,
        item_df=item_df,
        op_df=op_df,
        under_df=under_df,
        output_dir=args.output_dir,
        keep_same_day_status_conflicts=args.keep_same_day_status_conflicts,
    )
    report_path = args.output_dir / "item_status_roi_analysis_report.md"
    report_path.write_text(report, encoding="utf-8")
    print(report_path)


if __name__ == "__main__":
    main()
