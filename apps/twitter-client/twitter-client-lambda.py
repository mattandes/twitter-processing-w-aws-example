#!/usr/bin/env python3

import boto3
import json
import time
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

# Create AWS SSM client for retrieving config values
ssm_client = boto3.client('ssm')

# Retrieve authentication values from SSM
access_token = ssm_client.get_parameter(Name='/twitter-processing-example/twitter_access_token', WithDecryption=True)['Parameter']['Value']
access_token_secret = ssm_client.get_parameter(Name='/twitter-processing-example/twitter_access_token_secret', WithDecryption=True)['Parameter']['Value']
consumer_key = ssm_client.get_parameter(Name='/twitter-processing-example/twitter_consumer_key', WithDecryption=True)['Parameter']['Value']
consumer_secret = ssm_client.get_parameter(Name='/twitter-processing-example/twitter_consumer_secret', WithDecryption=True)['Parameter']['Value']

# Create Kinesis Firehose client
client = boto3.client('firehose')

# This is a basic listener that just prints received tweets and put them into Kinesis Firehose stream.
class FirehoseListener(StreamListener):
  def __init__(self, time_limit=10):
    self.start_time = time.time()
    self.limit = time_limit
    super(FirehoseListener, self).__init__()

  def on_data(self, data):
    # Since we're testing we only want to collect Tweets for short period of time and them stop listener
    if (time.time() - self.start_time) < self.limit:
      # Send record to firehose
      client.put_record(DeliveryStreamName='twitter-processing-example-stream',Record={'Data': json.loads(data)["text"]})
      print(json.loads(data)["text"])
      return True
    else:
      return False

  def on_error(self, status):
    print(status)


def lambda_handler(event, context):
  # Setup Twitter Auth
  auth = OAuthHandler(consumer_key, consumer_secret)
  auth.set_access_token(access_token, access_token_secret)

  # Create listener for stream
  l = FirehoseListener()

  # Create stream and listen for filtered tweets
  stream = Stream(auth, l)
  stream.filter(track=['stimulus'])