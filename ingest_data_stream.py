import boto3
import csv
import json
import dateutil.parser as parser
from time import sleep
from datetime import datetime


# AWS Settings
region='ap-south-1'
s3 = boto3.client('s3', region_name = region)
s3_resource = boto3.resource('s3', region_name = region)
kinesis_client = boto3.client('kinesis', region_name=region)

# Env. variables; 
kinesis_stream_name = 'us-accidents-data-stream-1'
streaming_partition_key = 'Severity'


# Simulationg the stream data and pushing the records to kinesis Data stream using Boto3 SDK
def stream_data_simulator(input_s3_bucket, input_s3_key):
  s3_bucket = input_s3_bucket
  s3_key = input_s3_key
  
  # Read CSV Lines and split the file into lines
  csv_file = s3_resource.Object(s3_bucket, s3_key)
  s3_response = csv_file.get()
  lines = s3_response['Body'].read().decode('utf-8').split('\n')
  
  for row in csv.DictReader(lines):
      try:
          # Convert to JSON, to make it easier to work in Kinesis Analytics
          print(row)
          line_json = json.dumps(row)
          json_load = json.loads(line_json)
          
          # Simple date casting:
          start_time_raw = parser.parse(json_load['Start_Time'])
          start_time_iso = start_time_raw.isoformat()
          json_load.update({'Start_Time':start_time_iso})
          
          end_time_raw = parser.parse(json_load['End_Time'])
          end_time_iso = end_time_raw.isoformat()
          json_load.update({'End_Time':end_time_iso})
          
          weather_time_raw = parser.parse(json_load['Weather_Timestamp'])
          weather_time_iso = weather_time_raw.isoformat()
          json_load.update({'Weather_Timestamp':weather_time_iso})
          
          # Adding dummy transaction timestamp to track the pushed time of record into kinesis stream:
          json_load['Txn_Timestamp'] = datetime.now().isoformat()
          
          # Write to Kinesis Streams:
          response = kinesis_client.put_record(StreamName=kinesis_stream_name,Data=json.dumps(json_load, indent=4),PartitionKey=str(json_load[streaming_partition_key]))
          print(response)
          
          # Adding a temporary pause, for demo-purposes:
          sleep(0.5)
          
          
      except Exception as e:
          print('Error: {}'.format(e))

# Run stream:
for i in range(0, 3):
  stream_data_simulator(input_s3_bucket="us-accidents-raw", input_s3_key="raw_us_accidents/US_Accidents_Dec21_updated.csv")
