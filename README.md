# slack_history_keeper

An application that scrapes Slack chat and saves history.

## Requirements
* Declare an environment variable called `SLACK_TOKEN` with a string value of your Slack Api token.
* Declare an environment variable called `SLACK_DB_URI` with the URI of your mongo database that will store the messages.

## Usage
* Make sure you call `pub get` or `pub upgrade` in all 3 directories [`frontend`, `backend`, `shared`]. 
* To start the backend, `cd backend/` and `dart bin/main.dart`. This fetches and prints chat logs of all channels associated with the slack token provided. It also starts a REST Api exposing some end points used by the frontend.
* To start the front end, in another terminal, `cd frontend/` and `pub serve`.
* You can then access the app via Dartium @ `http://localhost:8080` or with Chrome (but it'll take longer to compile Dart code to JS) to the same address.


