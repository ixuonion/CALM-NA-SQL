-- ============================================================
-- SG root.virtual_ad_general_mix：超大查询低延迟配置
-- 目标：单任务优先、快速扩容、完整读取、不跳过坏文件
-- ============================================================

-- 执行引擎与配置保护
set tqs.query.engine.type=sparkCli;
set tqs.pbo.overwrite.enabled=false;

-- Driver
-- 实际运行未出现 Driver OOM，20G 已足够
set spark.driver.memory=20g;
set spark.driver.cores=4;

-- Executor
-- 实际任务无 Spill、无 OOM，20G 堆内存足够
-- 缩小容器可以提高节点可放置性和 executor 拉起速度
set spark.executor.memory=20g;
set spark.executor.memoryOverhead=4g;
set spark.executor.cores=4;

-- SG 队列长期 CPU 饱和，不使用双倍 VCore
set spark.vcore.boost.ratio=1;

-- 动态资源
-- 当前超大扫描任务约 14193 个 Scan Tasks
-- 1500 executor 对应最多约 6000 个 Task slots
set spark.dynamicAllocation.enabled=true;
set spark.dynamicAllocation.minExecutors=100;
set spark.dynamicAllocation.initialExecutors=1000;
set spark.dynamicAllocation.maxExecutors=1500;

-- 加速动态扩容
set spark.dynamicAllocation.schedulerBacklogTimeout=1s;
set spark.dynamicAllocation.sustainedSchedulerBacklogTimeout=1s;
set spark.dynamicAllocation.executorIdleTimeout=60s;

-- 文件读取异常重试
-- SG 源表存在临时 Parquet footer 读取异常
-- 提高 Task 重试次数，不跳过文件，保证结果完整
set spark.task.maxFailures=8;

-- 推测执行
-- 当前扫描 Task P50 约 90 秒，少量长尾可达到 5–8 分钟
set spark.speculation=true;
set spark.speculation.quantile=0.8;
set spark.speculation.multiplier=1.5;

-- 异常节点隔离
set spark.blacklist.enabled=true;

-- Shuffle
-- SG 当前 Adhoc 任务默认已关闭 HDFS Shuffle
set spark.shuffle.hdfs.enabled=false;
set spark.shuffle.io.maxRetries=3;
set spark.shuffle.io.retryWait=5s;
set spark.shuffle.highlyCompressedMapStatusThreshold=5000;

-- Shuffle 初始分区
-- 当前 SQL Shuffle 很小，1000 足够；AQE 会继续向下合并
set spark.sql.shuffle.partitions=1000;

-- AQE
set spark.sql.adaptive.enabled=true;
set spark.sql.adaptive.coalescePartitions.enabled=true;
set spark.sql.adaptive.coalescePartitions.parallelismFirst=false;
set spark.sql.adaptive.advisoryPartitionSizeInBytes=134217728;
set spark.sql.adaptive.maxNumPostShufflePartitions=1000;
set spark.sql.adaptive.localShuffleReader.enabled=true;

-- Join 倾斜处理
set spark.sql.adaptive.skewJoin.enabled=true;
set spark.sql.adaptive.skewJoin.skewedPartitionFactor=5;
set spark.sql.adaptive.skewJoin.skewedPartitionThresholdInBytes=268435456;
set spark.sql.adaptive.forceOptimizeSkewedJoin=true;

-- 多文件并发扫描
-- 当前每个 Task 平均读取约 14 个文件
-- 从 4 路开始，不建议直接使用 10 路
set spark.sql.concurrentFileScan.enabled=true;
set spark.sql.concurrentFileScan.maxParallelism=4;

-- 保证完整性：不跳过读取异常文件
set spark.sql.files.ignoreCorruptFiles=false;

-- 输出详细 Shuffle 统计，便于后续诊断
set spark.shuffle.statistics.verbose=true;
