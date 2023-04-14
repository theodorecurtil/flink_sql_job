## :bulb: Introduction

In this new blog post, we build on the [infrastructure](https://github.com/theodorecurtil/kafka_101) and the [Kafka producer](https://github.com/theodorecurtil/kafka_sales_producer) introduced in the first two blog posts of our **Kafka 101 Tutorial** series. We simulate a company receiving sales events from its many physical stores inside its Kafka infrastructure, and we introduce the basic [Apache Flink](https://flink.apache.org/) architecture to do streaming analytics on top of these sales events.

Specifically, for this use case we will aggregate sales events per store and provide the total sales amount per store per time window. The output stream of aggregated sales will then be fed back to the Kafka infrastructure - and the new data type registered in the schema registry - for downstream applications. We do a time based aggregation as this is a basic example of time based analytics one can do with Apache Flink. For this first Flink based blog post, we will be using the Flink SQL API. In a future blog post, we will look at the more powerful Java API.

## :whale2: Requirements

To get this project running, you will just need minimal requirements: having [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed on your computer.

The versions I used to build the project are

```bash
## Docker
docker --version
> Docker version 23.0.3, build 3e7cbfdee1

## Docker Compose
docker-compose --version
> Docker Compose version 2.17.2
```

If your versions are different, it should not be a big problem. Though, some of the following might raise warnings or errors that you should debug on your own.

## :factory: Infrastructure

We will start by getting the infrastructure up and running on our local computer. To do so, nothing simpler! Simply type the following commands in

```bash
## Clone the repo
git clone https://github.com/theodorecurtil/flink_sql_job.git

## cd to the repo
cd flink_sql_job

## docker-compose the infra
docker-compose up -d
```

This will bring up the Kafka infrastructure we are familiar with, as well as the Kafka sales producer we introduced in our latest blog post. The producer starts producing immediately at a frequency of 1 message per second. You can check that everything is running properly by navigating to the Confluent Control Center UI on [localhost:9021](http://localhost:9021/clusters). Then go to the `Topics` tab and click the **SALES** topic. This is the topic the Kafka producer is producing to. You should see something similar to the following.

![](./pictures/topic-sales.png)