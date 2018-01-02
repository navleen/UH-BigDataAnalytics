import org.apache.spark.ml.regression.LinearRegression
import org.apache.spark.ml.regression.LinearRegressionModel
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.SQLContext;
import org.apache.spark.ml.linalg.VectorUDT;
import org.apache.spark.ml.feature.VectorAssembler;
import org.apache.spark.ml.linalg.Vectors;
import org.apache.spark.ml.Pipeline
val lines = sc.textFile("/home/navleen/Downloads/n/gammamatrix.csv")
val header = lines.first
lines.count
case class Auction(I: Double, j: Double, v: Double)
val noheader = lines.filter(_ != header)
val auctions = noheader.map(_.split(",")).map(r => Auction(r(0).toDouble, r(1).toDouble, r(2).toDouble))
val df = auctions.toDF
df.printSchema
val assembler = new VectorAssembler()
.setInputCols(Array("I","j","v"))
.setOutputCol("Feature")
val lr = new LinearRegression()
.setMaxIter(10)
.setRegParam(0.3)
.setElasticNetParam(0.8)
.setFeaturesCol("Feature")
.setLabelCol("v")
val pipeline = new Pipeline().setStages(Array(assembler,lr))

val model = pipeline.fit(df)
val lrModel = model.stages(1).asInstanceOf[LinearRegressionModel]
println(s"Coefficients: ${lrModel.coefficients} Intercept: ${lrModel.intercept}")
val trainingSummary = lrModel.summary
println(s"numIterations: ${trainingSummary.totalIterations}")
println(s"objectiveHistory: [${trainingSummary.objectiveHistory.mkString(",")}]")
trainingSummary.residuals.show()
println(s"RMSE: ${trainingSummary.rootMeanSquaredError}")
println(s"r2: ${trainingSummary.r2}")
