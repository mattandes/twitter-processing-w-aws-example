from __future__ import print_function

import base64
import json
import boto3

print('Loading function')

def lambda_handler(event, context):
    output = []

    for record in event['records']:
        
        dict_data = base64.b64decode(record['data']).decode('utf-8').strip()
        print(dict_data)
        
        # Create client for Amazon comprehend API
        comprehend = boto3.client(service_name='comprehend')

        # Send request to detect sentiment of the message
        sentiment_all = comprehend.detect_sentiment(Text=dict_data, LanguageCode='en')

        # Capture the detected sentiment
        sentiment = sentiment_all['Sentiment']
        print(sentiment)

        # Capture the confidence score of the detected sentiment and store as a percentage
        confidence = round(sentiment_all['SentimentScore'][sentiment.capitalize()] * 100, 2)
        
        # Create data object for output
        data_record = {
            'message': dict_data,
            'sentiment': sentiment,
            'confidence': confidence
        }
        print(data_record)
        
        # Create output record
        output_record = {
            'recordId': record['recordId'],
            'result': 'Ok',
            'data': base64.b64encode(json.dumps(data_record).encode('utf-8')).decode('utf-8')
        }
        print(output_record)
        
        # Append to output object
        output.append(output_record)

    print(output)
    return {'records': output}