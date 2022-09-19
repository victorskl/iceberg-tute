install:
	@pip install -r requirements.txt

pyspark:
	@pyspark \
		--packages org.apache.iceberg:iceberg-spark-runtime-3.2_2.12:0.14.1 \
		--conf "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions" \
		--conf "spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog" \
		--conf "spark.sql.catalog.spark_catalog.type=hive" \
		--conf "spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog" \
		--conf "spark.sql.catalog.local.type=hadoop" \
		--conf "spark.sql.catalog.local.warehouse=$PWD/warehouse" \
		--conf "spark.sql.defaultCatalog=local"

start:
	@jupyter-lab

clean:
	@rm -rf warehouse/*db
