SET 'state.backend' = 'rocksdb';
SET 'state.backend.incremental' = 'true';
SET 'execution.checkpointing.mode' = 'EXACTLY_ONCE';
SET 'execution.checkpointing.interval' = '10s';
SET 'execution.checkpointing.min-pause' = '10s';
SET 'sql-client.execution.result-mode'='TABLEAU';
SET 'parallelism.default' = '1';

ADD JAR '/opt/sql-client/lib/flink-sql-connector-kafka-1.16.0.jar';
ADD JAR '/opt/sql-client/lib/flink-sql-avro-confluent-registry-1.16.0.jar';


-- SALES
DROP TABLE IF EXISTS SALES;

CREATE TABLE SALES (
    store_id VARCHAR,
    sale_amount INT,
    sale_ts TIMESTAMP(3),
    WATERMARK FOR sale_ts AS sale_ts - INTERVAL '5' SECOND
    ) WITH (
      'connector' = 'kafka',
      'topic' = 'SALES',
      'properties.bootstrap.servers' = 'kafka_broker:29092',
      'format' = 'avro-confluent',
      'avro-confluent.url' = 'http://schema-registry:8081',
      'properties.group.id' = 'flink-sales',
      'scan.startup.mode' = 'earliest-offset'
);


-- SINK TABLE
CREATE TABLE SALES_AGGREGATE (
    store_id VARCHAR,
    window_start TIMESTAMP(3),
    window_end TIMESTAMP(3),
    aggregated_sales INT,
    PRIMARY KEY (store_id) NOT ENFORCED
    ) WITH (
      'connector' = 'upsert-kafka',
      'topic' = 'SALES_AGGREGATE',
      'properties.bootstrap.servers' = 'kafka_broker:29092',
      'value.format' = 'avro-confluent',
      'value.avro-confluent.url' = 'http://schema-registry:8081',
      'key.format' = 'avro-confluent',
      'key.avro-confluent.url' = 'http://schema-registry:8081'
);


-- QUERY
BEGIN STATEMENT
SET;

INSERT INTO SALES_AGGREGATE

SELECT store_id, window_start, window_end, sum(sale_amount) as aggregated_sales
  FROM TABLE(
    TUMBLE(TABLE SALES, DESCRIPTOR(sale_ts), INTERVAL '60' SECONDS))
  GROUP BY store_id, window_start, window_end;

END;