
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.graphx.GraphLoader
import org.apache.spark.graphx.lib.ShortestPaths
import scala.util.hashing.{ MurmurHash3 => MH3 }
import org.apache.spark.graphx.Graph
import org.apache.spark.rdd.RDD
import org.apache.spark.graphx.VertexId
import org.apache.spark.SparkContext._
import org.apache.spark._
import org.apache.spark.graphx._
import org.apache.spark.rdd.RDD
import org.apache.spark.graphx.lib.ShortestPaths
import org.apache.spark.SparkConf
import org.apache.spark.graphx.GraphLoader
import scala.util.hashing.{ MurmurHash3 => MH3 }
import org.apache.spark.graphx.Graph
import org.apache.spark.graphx.VertexId

object GraphFromFile {
  def main(args: Array[String]) {

    //create SparkContext
    val sparkConf = new SparkConf().setAppName("Csv2Graph").setMaster("local[*]")
    val sc = new SparkContext(sparkConf)

    // read your file
    val csvFile = "/home/navleen/Downloads/sample_latestforscala.csv"
    val file = sc.textFile(csvFile);

    val edges: RDD[Edge[String]] = file.map { line =>
        val fields = line.split(",")
        Edge(fields(0).toLong, fields(1).toLong, fields(2))
      }

    edges.collect().foreach(println)

    // create a graph
    val graph : Graph[Any, String] = Graph.fromEdges(edges, 0)

    // you can see your graph
    graph.triplets.collect.foreach(println)
    // calculate shortest path
    val result = ShortestPaths.run(graph, Seq(5))
    val shortestPath = result.vertices.filter({case(vId, _) => vId == 1}).first._2.get(5)
  }
} 
