# slack_history_keeper

An application that scrapes Slack chat and saves history.

## Requirements
Declare an environment variable called `SLACK_TOKEN` with a string value of your Slack Api token.
Declare an environment variable called `SLACK_DB_URI` with the URI of your mongo database that will store the messages.

## Usage
This is fetch and print chat logs of the general channel : 

`dart bin/main.dart`
