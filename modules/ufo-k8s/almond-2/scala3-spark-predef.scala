import $ivy.`org.scala-lang.modules::scala-xml:2.3.0`
import $ivy.`org.apache.spark:spark-sql_2.13:3.5.1`
import $ivy.`sh.almond:ammonite-spark_2.13:0.14.0-RC8`

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

