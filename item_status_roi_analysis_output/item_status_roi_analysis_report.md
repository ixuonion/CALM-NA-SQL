# Item 状态切换与 ROI 出价调整分析报告

- 输入文件：`/Users/bytedance/Downloads/sample_item_id_with_ROI_target.csv`
- 输出目录：`/Users/bytedance/Documents/trae_projects/CALM_NA_SQL/item_status_roi_analysis_output`
- 主分析口径：解析状态与 ROI 数组成功、剔除重复 `item_id`、剔除状态数组同一日期存在多个不同状态的记录。
- 同一日期 ROI 存在多个目标值时，按数组顺序取该日期最后一个目标值；该问题在数据质量统计中单独披露。
- 状态区间耗时按自然日差计算：区间开始日到下一次状态切换日的日期差；未观察到切换的右删失区间不纳入切换耗时均值。
- ROI 降低分组按阶段内相对阶段首个 ROI target 的最大降幅划分：<5%、5%-<10%、10%-<20%、>=20%。

## 1. 数据质量与样本保留

| item | rows | pct |
| --- | --- | --- |
| CSV 原始行数 | 100,000 | 1.0000 |
| 重复 item_id 涉及行数 | 52 | 0.0005 |
| 重复 item_id 数 | 26 | 0.0003 |
| 状态数组解析失败行数 | 0 | 0.0000 |
| ROI 数组解析失败行数 | 29 | 0.0003 |
| 状态数组同日重复行数 | 11,977 | 0.1198 |
| 状态数组同日多状态行数 | 11,129 | 0.1113 |
| ROI 数组同日重复行数 | 11,658 | 0.1166 |
| ROI 数组同日多目标值行数 | 9,099 | 0.0910 |
| 主分析保留 item/行数 | 88,831 | 0.8883 |

说明：状态数组同日多状态占比用于判断是否可剔除；本次主结果已剔除这些记录。ROI 同日多目标值未剔除，使用日期内最后值。

主分析样本按账号组分布：

| account_group | items |
| --- | --- |
| Affiliate | 77,355 |
| Marketing/Official | 11,469 |
| Other/Unknown | 7 |

Exploring 指标纳入/排除原因：

| reason | rows |
| --- | --- |
| included | 74,213 |
| first_observed_status_not_exploring | 11,513 |
| still_exploring_at_last_observation | 3,105 |

## 2. 整体平均耗时

| metric | n | mean | median | std | p25 | p75 | ci95_low | ci95_high |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1. Exploring -> 任意其他状态 | 74,213 | 2.570 | 3.000 | 1.520 | 1.000 | 3.000 | 2.559 | 2.581 |
| 2. OP -> Underperforming/Ineligible | 27,932 | 7.857 | 7.000 | 5.259 | 3.000 | 12.000 | 7.796 | 7.919 |
| 3. 连续 OP 阶段 | 35,818 | 7.136 | 6.000 | 5.183 | 3.000 | 11.000 | 7.083 | 7.190 |
| 4a. Outstanding 日期数/全部 item | 88,831 | 1.741 | 0.000 | 3.771 | 0.000 | 1.000 | 1.717 | 1.766 |
| 4b. Outstanding 日期数/有 Outstanding 的 item | 25,066 | 6.172 | 5.000 | 4.801 | 2.000 | 9.000 | 6.112 | 6.231 |

右删失区间统计：

| episode_type | total_episodes | completed_episodes | censored_episodes |
| --- | --- | --- | --- |
| OP | 87,229 | 35,818 | 51,411 |
| Underperforming | 31,430 | 10,173 | 21,257 |

## 3. 按账号类型分组差异：Affiliate vs Marketing/Official

检验同时给出 Welch t-test 与 Mann-Whitney U test；样本量充足时优先看非参数检验的稳健方向，并结合均值差异解释业务量级。

| metric | n_a | mean_a | n_b | mean_b | mean_diff_b_minus_a | pct_diff_b_vs_a | welch_t_p | mannwhitney_p | sample_warning |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1. Exploring -> 任意其他状态 | 65,284 | 2.548 | 8,929 | 2.730 | 0.181 | 7.114 | 0.000 | 0.005 |  |
| 2. OP -> Underperforming/Ineligible | 24,822 | 7.954 | 3,110 | 7.086 | -0.867 | -10.906 | 0.000 | 0.000 |  |
| 3. 连续 OP 阶段 | 30,446 | 7.402 | 5,372 | 5.629 | -1.773 | -23.952 | 0.000 | 0.000 |  |
| 4. Outstanding 日期数/全部 item | 77,355 | 1.818 | 11,469 | 1.226 | -0.592 | -32.570 | 0.000 | 0.000 |  |

其中 `mean_diff_b_minus_a` 为 Marketing/Official - Affiliate。

## 4. Exploring 周期 ROI 降低分组对 Exploring 切换耗时的影响

| exploring_roi_group | n | mean | median | std | p25 | p75 | sample_warning |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 无降低目标(<5%) | 67,688 | 2.497 | 3.000 | 1.507 | 1.000 | 3.000 |  |
| 降低目标5%-<10% | 2,677 | 3.316 | 3.000 | 1.060 | 3.000 | 4.000 |  |
| 降低目标10%-<20% | 1,675 | 3.420 | 3.000 | 1.254 | 3.000 | 4.000 |  |
| 降低目标20%及以上 | 1,482 | 3.592 | 3.000 | 1.609 | 3.000 | 4.000 |  |

整体差异检验：

| groups_tested | kruskal_p | spearman_rho | spearman_p | sample_warning |
| --- | --- | --- | --- | --- |
| 无降低目标(<5%), 降低目标5%-<10%, 降低目标10%-<20%, 降低目标20%及以上 | 0.000 | 0.208 | 0.000 |  |

## 5. OP 阶段 ROI 降低分组对连续 OP 耗时的影响

| roi_group | n | mean | median | std | p25 | p75 | sample_warning |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 无降低目标(<5%) | 29,420 | 6.452 | 5.000 | 4.962 | 2.000 | 10.000 |  |
| 降低目标5%-<10% | 2,223 | 9.872 | 9.000 | 4.932 | 6.000 | 13.000 |  |
| 降低目标10%-<20% | 2,070 | 10.666 | 10.000 | 4.948 | 7.000 | 15.000 |  |
| 降低目标20%及以上 | 1,921 | 10.799 | 10.000 | 4.927 | 7.000 | 14.000 |  |

整体差异检验：

| groups_tested | kruskal_p | spearman_rho | spearman_p | sample_warning |
| --- | --- | --- | --- | --- |
| 无降低目标(<5%), 降低目标5%-<10%, 降低目标10%-<20%, 降低目标20%及以上 | 0.000 | 0.299 | 0.000 |  |

## 6. Underperforming 阶段 ROI 降低分组与回到 OP 的关系

回到 OP 定义：Underperforming 连续区间结束后的下一个状态为 Outstanding 或 Performing。仍处于 Underperforming 的右删失区间不纳入主恢复率计算。

| roi_group | n | recovered | not_recovered | recovery_rate | sample_warning |
| --- | --- | --- | --- | --- | --- |
| 无降低目标(<5%) | 9,127 | 5,754 | 3,373 | 0.630 |  |
| 降低目标5%-<10% | 306 | 165 | 141 | 0.539 |  |
| 降低目标10%-<20% | 278 | 138 | 140 | 0.496 |  |
| 降低目标20%及以上 | 285 | 167 | 118 | 0.586 |  |

恢复率卡方检验：

| chi2_stat | dof | chi2_p | min_expected_count | sample_warning |
| --- | --- | --- | --- | --- |
| 31.912 | 3 | 0.000 | 104.904 |  |

## 7. 主要结论

- 状态数组同日多状态记录占 11.13%，不是极低比例；主分析按要求剔除后保留 88.83% 样本，结论需理解为干净日粒度样本上的结果。
- 整体上，Exploring 切换到任意其他状态平均 2.57 天（n=74,213）；OP 切到 Underperforming/Ineligible 平均 7.86 天；连续 OP 阶段平均 7.14 天；全部 item 的 Outstanding 日期数均值为 1.74 天。
- 账号类型差异显著：Marketing/Official 的 Exploring 切换耗时比 Affiliate 长 0.18 天（Mann-Whitney p=0.005），但连续 OP 阶段短 1.77 天（p<0.001），Outstanding 总日期数也低 0.59 天（p<0.001）。
- Exploring 周期内 ROI target 降低幅度越大，Exploring 平均耗时越长：<5% 组 2.50 天，>=20% 组 3.59 天；Kruskal p<0.001，Spearman rho=0.208。
- OP 阶段 ROI target 降低幅度越大，连续 OP 平均耗时也更长：<5% 组 6.45 天，>=20% 组 10.80 天；Kruskal p<0.001，Spearman rho=0.299。
- Underperforming 阶段降 ROI target 并未表现出更高的回到 OP 概率：<5% 组恢复率 63.0%，5%-<10% 为 53.9%，10%-<20% 为 49.6%，>=20% 为 58.6%；组间差异显著（卡方 p<0.001），但方向不是“降低越多恢复越好”。
- 上述结果来自观察性数据，ROI target 调整可能是状态变化后的运营动作或与 item 质量共同相关，不能直接解释为因果影响。

## 8. 可复现输出文件

- `item_level_metrics.csv`：item 级指标，包括 Exploring 切换耗时和 Outstanding 日期数。
- `op_episode_metrics.csv`：Outstanding/Performing 连续阶段明细。
- `underperforming_episode_metrics.csv`：Underperforming 连续阶段明细及是否回到 OP。
