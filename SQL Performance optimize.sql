-- SQL 性能优化
set tqs.pbo.overwrite.enabled=false;

--基础资源
set spark.driver.memory=20g;
set spark.driver.cores=4;
set spark.executor.memory=60g;
set spark.executor.memoryOverhead=10g;
set spark.executor.cores=4;
set spark.vcore.boost.ratio=1;

--动态executor申请
set spark.dynamicAllocation.minExecutors=5;
set spark.dynamicAllocation.maxExecutors=1500;

-- AQE
set spark.sql.shuffle.partitions = 400;
set spark.sql.adaptive.enabled=true;
set spark.shuffle.statistics.verbose=true;
set spark.sql.adaptive.skewedJoin.enabled=true;
set spark.sql.adaptive.forceOptimizeSkewedJoin=true;