## :bulb: Introduction

In this new blog post, we build on the [infrastructure](https://github.com/theodorecurtil/kafka_101) and the [Kafka producer](https://github.com/theodorecurtil/kafka_sales_producer) introduced in the first two blog posts of our **Kafka 101 Tutorial** series. We simulate a company receiving sales events from its many physical stores inside its Kafka infrastructure, and we introduce the basic [Apache Flink](https://flink.apache.org/) architecture to do streaming analytics on top of these sales events.

Specifically, for this use case we will aggregate sales events per store and provide the total sales amount per store per time window. The output stream of aggregated sales will then be fed back to the Kafka infrastructure - and the new data type registered in the schema registry - for downstream applications. We do a time based aggregation as this is a basic example of time based analytics one can do with Apache Flink. For this first Flink based blog post, we will be using the Flink SQL API. In a future blog post, we will look at the more powerful Java API.

