# SQL 讲解计划

## Summary

目标：对文件 `CALM*NA 字段大全.sql` 从第一行到最后一行做完整讲解，既解释业务含义，也解释 SQL/表达式逻辑。

交付方式：
- 按文件中的实际模块顺序讲解。
- 先说明这份文件的用途和组织方式，再逐段解释每个指标/分类规则。
- 对空白段落明确指出“当前只有标题，没有具体 SQL 口径”。

## Current State Analysis

已确认该文件位于：
- `/Users/bytedance/Documents/trae_projects/CALM_NA_SQL/CALM*NA 字段大全.sql`

已确认文件总长度约 388 行，结构上不是一条完整可执行 SQL，而是一个“字段/指标/分组口径说明集合”，由注释标题加表达式组成。

已确认存在 4 个一级模块：
1. `CALM Team X Shop TTS Dataset (Full Snapshot)`
2. `CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)`
3. `Shop M10n GMV Max Session Stat(Adv timezone,TikTok&Pangle&Toko)`
4. `[AC,Joined] Product Commission Setup (UTC0, Global)`

已确认二级主题主要包括：
- `Sales Team Breakdown`
- `PGM/LGM Rev & GMV Shares`
- `Products`
- `Promotion US`
- `Promotion SEA`
- `Revenue & Cost`

已确认关键事实：
- 光标所在的 `-- Promotion Daily&Promotion&Others SEA` 是注释标题，不是 SQL 逻辑。
- `Promotion US` 和 `Promotion SEA` 下的三个子标题目前都是空白，没有对应表达式。
- 文件中的主要可解释内容集中在：
  - 各数据集下的 `CALM Region`
  - 各数据集下的 `Region Breakdown by OB/ENT/SMB`
  - PGM/LGM 的 GMV 或 Revenue Share 计算
  - 产品类型 `Gmax/Non-Gmax`
  - `ACA Revenue Share% (Dual Commission Enabled Only)`

## Proposed Changes

说明：本任务不修改业务文件，执行阶段仅输出讲解说明。

执行时按以下顺序输出说明：

1. 文件定位与阅读方式
- 说明这不是完整查询语句，而是字段口径字典/表达式清单。
- 解释注释层级含义：`------` 为数据集层级，`----` 为主题层级，`--` 为具体指标或字段口径。

2. 第一模块讲解：`CALM Team X Shop TTS Dataset (Full Snapshot)`
- 解释 `PGM GMV Share` 与 `LGM GMV Share` 的分子、分母、税额处理、为什么 US 特殊处理税。
- 解释 `PGM Rev Share & LGM Rev Share` 段落前的提示注释，说明该表无法按某些内容维度精细拆分。
- 解释 `CALM Region` 如何把 EU 进一步拆成 `UK`、`EU_others`、`Others`。
- 解释 `Region Breakdown by OB/ENT/SMB` 的多层 `CASE`，说明不同区域/国家如何映射为 `ENT`、`SMB`、`CNOB`、`KROB`、`Others`。

3. 第二模块讲解：`CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)`
- 说明该模块和第一模块在业务上相近，但字段名不同。
- 对比讲解 `Sales Team Breakdown` 中使用的字段差异，例如 `[Daily Latest GBS Direct First GBS - 1]`、`owner_calm_direct_first_combi_sea` 等。
- 解释 `PGM Rev Share`、`LGM Rev Share` 的逻辑：基于 `payment_1d` 按投放/内容类型归类。
- 解释 `Gmax/Non-Gmax` 如何通过 `like '%ROI2%'` 将产品分为 ROI2 或默认 ROI1。
- 明确指出 `Promotion US` / `Promotion SEA` 的 6 个子标题当前无实现。

4. 第三模块讲解：`Shop M10n GMV Max Session Stat(Adv timezone,TikTok&Pangle&Toko)`
- 解释该模块只提供 `Sales Team Breakdown` 相关逻辑。
- 说明它与前两个模块的区域拆分思路相同，但改用了 `owner_gbs_direct_first_split_sea` 等字段。
- 对每个区域分支给出业务含义，而不只做语法翻译。

5. 第四模块讲解：`[AC,Joined] Product Commission Setup (UTC0, Global)`
- 解释 `CALM Region` 与 `Region Breakdown by OB/ENT/SMB` 的分类逻辑。
- 指出与第三模块相比，部分国家分支使用的字段来源不同，例如 BR/MX 分支使用 `owner_gbs_direct_first_split_sea`。
- 解释 `ACA Revenue Share% (Dual Commission Enabled Only)`：
  - 分子是同时存在 affiliate commission rate 与 ad commission rate 的 `shop_dollar_cost_1d`
  - 分母是全部 `shop_dollar_cost_1d`
  - 业务意义是“双佣金启用样本”成本占整体成本的比例

6. 全文件总结
- 总结重复出现的设计模式：区域映射、团队归属映射、按内容类型分摊收入、按产品名归类。
- 点出文件中的空白口径区和潜在注意点，例如字段名在不同模块之间并不一致，不能直接互换理解。

## Assumptions & Decisions

- 用户要解释的是整份文件，而不是光标所在单行。
- 用户希望“业务含义 + SQL 逻辑”一起讲，而不是只做语法翻译。
- 讲解时默认不假设底层表结构、ETL 来源或 BI 工具上下文，除非文件中已有明示。
- 对空白 Promotion 段落，执行时会如实说明“暂无 SQL”，不会臆造规则。
- 若发现同类逻辑在不同模块字段名不同，执行时会做横向对比，帮助用户理解复用模式。

## Verification

执行前或执行时应核对：
- 讲解覆盖全部 4 个一级模块。
- 讲解覆盖全部非空表达式段落。
- 明确指出 Promotion 相关段落为空白。
- 每一类 `CASE` 都同时说明“判断条件”和“最终业务标签”。
- 每一类 `sum()/sum()` 指标都说明分子、分母和业务意义。
