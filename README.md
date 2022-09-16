# Apache Iceberg tute

```
conda create -n iceberg-tute python=3.10
conda activate iceberg-tute

pip install -r requirements.txt

which pyspark

pyspark --help

pyspark \
    --packages org.apache.iceberg:iceberg-spark-runtime-3.2_2.12:0.14.1 \
    --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
    --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
    --conf spark.sql.catalog.spark_catalog.type=hive \
    --conf spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog \
    --conf spark.sql.catalog.local.type=hadoop \
    --conf spark.sql.catalog.local.warehouse=$PWD/warehouse \
    --conf spark.sql.defaultCatalog=local
```


## PySpark Shell

```
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.3.0
      /_/

Using Python version 3.10.6 (main, Aug 22 2022 20:41:54)
Spark context Web UI available at http://localhost:4041
Spark context available as 'sc' (master = local[*], app id = local-1663251309510).
SparkSession available as 'spark'.
>>>
```

- Observe http://localhost:4040


## Iceberg Table

_... while at PySpark Shell, continue to create "Iceberg Table" like so:_

```
>>> data = spark.range(0, 5)

>>> data
DataFrame[id: bigint]

>>> type(data)
<class 'pyspark.sql.dataframe.DataFrame'>

>>> data.writeTo("local.mydb.mytbl").create()

>>> df = spark.table("local.mydb.mytbl")

>>> type(df)
<class 'pyspark.sql.dataframe.DataFrame'>

>>> df
DataFrame[id: bigint]

>>> df.printSchema()
root
 |-- id: long (nullable = true)

>>> df.count()
5

>>> df.show()
+---+
| id|
+---+
|  0|
|  1|
|  2|
|  3|
|  4|
+---+

>>> spark.sql("SELECT count(*) from local.mydb.mytbl").show()
+--------+
|count(1)|
+--------+
|       5|
+--------+

>>> spark.sql("SELECT * from local.mydb.mytbl").show()
+---+
| id|
+---+
|  0|
|  1|
|  2|
|  3|
|  4|
+---+

>>> data = spark.range(5, 10)

>>> data.show()
+---+
| id|
+---+
|  5|
|  6|
|  7|
|  8|
|  9|
+---+

>>> data.writeTo("local.mydb.mytbl").replace()

>>> df = spark.table("local.mydb.mytbl")

>>> df.count()
5

>>> df.show()
+---+
| id|
+---+
|  5|
|  6|
|  7|
|  8|
|  9|
+---+

>>> spark.sql("SELECT count(*) from local.mydb.mytbl").show()
+--------+
|count(1)|
+--------+
|       5|
+--------+

>>> spark.sql("SELECT * FROM local.mydb.mytbl").show()
+---+
| id|
+---+
|  5|
|  6|
|  7|
|  8|
|  9|
+---+

>>> exit()
```

```
$ tree warehouse
warehouse
└── mydb
    └── mytbl
        ├── data
        │   ├── 00000-0-8dd45eb1-0879-4fb2-8315-aeed4b35869e-00001.parquet
        │   ├── 00000-12-1b79371f-a8b4-49b1-8ab2-c7c1975480b5-00001.parquet
        │   ├── 00001-1-f47f7557-72a4-44b5-8f3a-568a3e63d5e3-00001.parquet
        │   ├── 00001-13-b80ed809-da28-436b-83bc-84651636d1ac-00001.parquet
        │   ├── 00002-14-5def7e30-93de-4448-b138-d881f6a98833-00001.parquet
        │   ├── 00002-2-93709ad7-8a86-4377-85d8-34a306ebc541-00001.parquet
        │   ├── 00003-15-d8ffaabd-c7ba-4bec-be1f-564d5dd9ed79-00001.parquet
        │   └── 00003-3-4b240d2d-f5da-49a2-8226-1f391b43e737-00001.parquet
        └── metadata
            ├── 4331caf9-e4f7-4808-b3eb-b990377668da-m0.avro
            ├── 7a5fb14a-bc9c-4f3b-bb8f-52f48a0c6d55-m0.avro
            ├── snap-5363510897792107688-1-4331caf9-e4f7-4808-b3eb-b990377668da.avro
            ├── snap-9070834845967735565-1-7a5fb14a-bc9c-4f3b-bb8f-52f48a0c6d55.avro
            ├── v1.metadata.json
            ├── v2.metadata.json
            └── version-hint.text

4 directories, 15 files
```

Reading:

- https://iceberg.apache.org/spec/

## Quickstart Notebook

```
$ jupyter-lab
(CTRL + C)
```

- Go to http://localhost:8888/lab
- Open [quickstart.ipynb](quickstart.ipynb) in JupyterLab
- Execute each Notebook cells (_Shift + Enter_) -- one by one to observe

REF:

- https://iceberg.apache.org/spark-quickstart/
- https://iceberg.apache.org/docs/latest/getting-started/

## Notes

- Key takeaway notes 
  - Need meta store for `Iceberg Catalog`
    - such as Hive meta store (as in example above) 
    - Glue Catalog, DynamoDB or some RDBMS/RDS through JDBC Catalog
  - Tables are stored in where `warehouse` config flag point to... 
    - typically, object store like S3 
    - hence, "Iceberg tables over Data Lake" or, _Iceberg Lake!_

### Re-Spin

```
rm -rf warehouse/*db
```

### Alternative

- https://github.com/victorskl/deltalake-tute
