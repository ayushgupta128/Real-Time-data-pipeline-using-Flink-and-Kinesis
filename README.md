# Real-Time-data-pipeline-using-Flink-and-Kinesis"

Dataset Description

The Dataset used is taken from kaggle website https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents

This Project uses the US car accidents dataset which includes a few of the following fields:

Severity
Start_Time
End_Time
Location
Description
City
State

Tech Stack:

➔ Languages-
SQL, Python3

➔ Services -
AWS S3, AWS Glue, AWS Athena, AWS Cloud9, Apache Flink, Amazon Kinesis, Amazon SNS, AWS Lambda, Amazon CloudWatch, Grafana, Apache Zepplin

* Data is cleaned, filtered and ingested to kinesis Data stream-1 from AWS cloud9 environment.
* Flink is used to process the data using KDA(Kinesis Data Analytics) and data is pushed into new data stream-2.
* A Kinesis Evenet Trigger is applied to a Lambda Function and  Severe accident cases are then reported using AWS Kinesis and events is sent to CloudWatch from where Dashboards can be created.

* To Avoid Single Point of Failure Data from Kinesis data stream is stored in AWS S3 Raw Layer using AWS Firehose.
* AWS Glue is used to create data catalogs and databases on top of data streams.

![Architecture_on_AWS](https://user-images.githubusercontent.com/127664338/225127667-c296f94a-2570-452b-80f2-4b2e31453d6e.jpg)







