%flink.ssql

DROP TABLE IF EXISTS us_accidents_stream;

CREATE TABLE us_accidents_stream (
  `ID` VARCHAR(50), 
  `Severity` bigint, 
  `Start_Time` TIMESTAMP(3), 
  `End_Time` TIMESTAMP(3), 
  `Start_Lat` VARCHAR(50), 
  `Start_Lng` VARCHAR(50), 
  `End_Lat` VARCHAR(50), 
  `End_Lng` VARCHAR(50), 
  `Distance(mi)` VARCHAR(50), 
  `Description` VARCHAR(500), 
  `Number` VARCHAR(50), 
  `Street` VARCHAR(50), 
  `Side` VARCHAR(50), 
  `City` VARCHAR(50), 
  `County` VARCHAR(50), 
  `State` VARCHAR(50), 
  `Zipcode` VARCHAR(50), 
  `Country` VARCHAR(50), 
  `Timezone` VARCHAR(50), 
  `Airport_Code` VARCHAR(50), 
  `Weather_Timestamp` TIMESTAMP(3), 
  `Temperature(F)` VARCHAR(50), 
  `Wind_Chill(F)` VARCHAR(50), 
  `Humidity(%)` VARCHAR(50), 
  `Pressure(in)` VARCHAR(50), 
  `Visibility(mi)` VARCHAR(50), 
  `Wind_Direction` string, 
  `Wind_Speed(mph)` VARCHAR(50), 
  `Precipitation(in)` VARCHAR(50), 
  `Weather_Condition` VARCHAR(50), 
  `Amenity` VARCHAR(50), 
  `Bump` boolean, 
  `Crossing` boolean, 
  `Give_Way` boolean, 
  `Junction` boolean, 
  `No_Exit` boolean, 
  `Railway` boolean, 
  `Roundabout` boolean, 
  `Station` boolean, 
  `Stop` boolean, 
  `Traffic_Calming` boolean, 
  `Traffic_Signal` boolean, 
  `Turning_Loop` boolean, 
  `Sunrise_Sunset` VARCHAR(50), 
  `Civil_Twilight` VARCHAR(50), 
  `Nautical_Twilight` VARCHAR(50), 
  `Astronomical_Twilight` VARCHAR(50),
  `Txn_Timestamp` TIMESTAMP(3),
  WATERMARK FOR Txn_Timestamp as Txn_Timestamp - INTERVAL '5' SECOND  
)
PARTITIONED BY (Severity)
WITH (
  'connector' = 'kinesis',
  'stream' = 'us-accidents-stream-1',
  'aws.region' = 'ap-south-1',
  'scan.stream.initpos' = 'LATEST',
  'format' = 'json',
  'json.timestamp-format.standard' = 'ISO-8601'
);


/*Option 'IF NOT EXISTS' can be used, to protect the existing Schema */
DROP TABLE IF EXISTS us_accidents_stream_1_results;

CREATE TABLE us_accidents_stream_1_results (
  `ID` VARCHAR(50), 
  `Severity` bigint, 
  `City` VARCHAR(50), 
  `County` VARCHAR(50), 
  `Txn_Timestamp` TIMESTAMP(3)
)
PARTITIONED BY (Severity)
WITH (
  'connector' = 'kinesis',
  'stream' = 'us-accidents-stream-2',
  'aws.region' = 'ap-south-1',
  'format' = 'json',
  'json.timestamp-format.standard' = 'ISO-8601'
);

insert into us_accidents_stream_1_results
select  ID, Severity, City,  County, Txn_Timestamp
from us_accidents_stream where Severity > 3;
