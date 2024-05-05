import $ivy.`org.apache.spark::spark-sql:3.5.1`
import $ivy.`sh.almond::ammonite-spark:0.14.0-RC8`

import org.apache.log4j.{Level, Logger}
Logger.getLogger("org").setLevel(Level.OFF)

import org.apache.spark.sql._
import org.apache.spark.sql.functions._

val spark = {
  AmmoniteSparkSession.builder()
    .master("local[*]")
    .getOrCreate()
}

import spark.implicits._

