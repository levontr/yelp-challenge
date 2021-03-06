#!/bin/sh
set -e

dataset_path=${1}
extract_dir="/yelp-dataset-extracted"
mkdir -p $extract_dir
echo "tar -xzvf $dataset_path -C $extract_dir"
tar -xzvf $dataset_path -C $extract_dir
path_in_hdfs="/input"
all_files=$(python put_to_hdfs.py $extract_dir $path_in_hdfs)
echo $all_files
spark-submit  --master yarn-cluster --executor-memory 1g  --class com.ny.challenge.JsonToParquet --name JSONPARQUET challenge-1.0.jar -Dspark.input.path="$all_files" -Dspark.output.path="/output"