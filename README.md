# Apache Iceberg tute

```
conda create -n iceberg-tute python=3.12
conda activate iceberg-tute

pip install -r requirements.txt

which pyspark

pyspark --help

pyspark \
    --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.6.0 \
    --conf "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions" \
    --conf "spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog" \
    --conf "spark.sql.catalog.spark_catalog.type=hive" \
    --conf "spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog" \
    --conf "spark.sql.catalog.local.type=hadoop" \
    --conf "spark.sql.catalog.local.warehouse=warehouse" \
    --conf "spark.sql.defaultCatalog=local"
```


## PySpark Shell

```
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.5.1
      /_/

Using Python version 3.12.4 (main, Jun 18 2024 10:07:17)
Spark context Web UI available at http://localhost:4040
Spark context available as 'sc' (master = local[*], app id = local-1722671099470).
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
        │   ├── 00002-2-3e21ec80-2f4c-44cd-a714-26023af64037-0-00001.parquet
        │   ├── 00002-34-ab370d28-f091-498d-831c-67935dadabed-0-00001.parquet
        │   ├── 00004-36-ab370d28-f091-498d-831c-67935dadabed-0-00001.parquet
        │   ├── 00004-4-3e21ec80-2f4c-44cd-a714-26023af64037-0-00001.parquet
        │   ├── 00007-39-ab370d28-f091-498d-831c-67935dadabed-0-00001.parquet
        │   ├── 00007-7-3e21ec80-2f4c-44cd-a714-26023af64037-0-00001.parquet
        │   ├── 00009-41-ab370d28-f091-498d-831c-67935dadabed-0-00001.parquet
        │   ├── 00009-9-3e21ec80-2f4c-44cd-a714-26023af64037-0-00001.parquet
        │   ├── 00011-11-3e21ec80-2f4c-44cd-a714-26023af64037-0-00001.parquet
        │   └── 00011-43-ab370d28-f091-498d-831c-67935dadabed-0-00001.parquet
        └── metadata
            ├── 4cd38843-d0cd-4ebd-ab4f-4f3d43581ff9-m0.avro
            ├── dbae0478-c7b1-45ca-b5ae-fab559d313f9-m0.avro
            ├── snap-2597526915951714765-1-4cd38843-d0cd-4ebd-ab4f-4f3d43581ff9.avro
            ├── snap-2637002532996365912-1-dbae0478-c7b1-45ca-b5ae-fab559d313f9.avro
            ├── v1.metadata.json
            ├── v2.metadata.json
            └── version-hint.text

5 directories, 17 files
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


## Notes

- Key takeaway notes 
  - Need meta store for `Iceberg Catalog`
    - such as Hive meta store (as in example above) 
    - Glue Catalog, DynamoDB or some RDBMS/RDS through JDBC Catalog
  - Tables are stored in where `warehouse` config flag point to... 
    - typically, object store like S3 
    - hence, "Iceberg tables over Data Lake" or, _Iceberg Data Lake!_

### Re-Spin

```
rm -rf warehouse/*db
```

### AWS

- https://iceberg.apache.org/docs/latest/aws/
- [Using Iceberg tables with Athena](https://docs.aws.amazon.com/athena/latest/ug/querying-iceberg.html)
- [Using Iceberg table with EMR](https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-iceberg.html)
- [Build an Apache Iceberg data lake using Amazon Athena, Amazon EMR, and AWS Glue](https://aws.amazon.com/blogs/big-data/build-an-apache-iceberg-data-lake-using-amazon-athena-amazon-emr-and-aws-glue/)


### Related

- https://github.com/victorskl/deltalake-tute
- https://github.com/victorskl/hudi-tute
