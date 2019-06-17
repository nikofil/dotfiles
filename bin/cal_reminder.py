#!/usr/bin/python
from __future__ import print_function
import datetime
import dateutil.parser
import pickle
import os
import os.path
import json
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
DT = datetime.timedelta(hours=8)
TMP_DIR = '/tmp/gcalendar'
TOKEN_PICKLE = os.path.join(TMP_DIR, 'calendar_token.pickle')
CACHED_EVENTS = os.path.join(TMP_DIR, 'calendar_events.json')
CREDS_JSON = '/var/lib/gcalendar/credentials.json'

def event_list(now, until):
    """Shows basic usage of the Google Calendar API.
    Prints the start and name of the next 10 events on the user's calendar.
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(TOKEN_PICKLE):
        with open(TOKEN_PICKLE, 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDS_JSON, SCOPES)
            creds = flow.run_local_server()
        # Save the credentials for the next run
        with open(TOKEN_PICKLE, 'wb') as token:
            pickle.dump(creds, token)
    service = build('calendar', 'v3', credentials=creds)
    return service.events().list(calendarId='primary', timeMin=now, timeMax=until,
        maxResults=10, singleEvents=True, orderBy='startTime').execute().get('items', [])

def get_calendar_strs():
    # Call the Calendar API
    if not os.path.isdir(TMP_DIR):
        os.mkdir(TMP_DIR)
    dt_now = datetime.datetime.utcnow()
    now = dt_now.isoformat() + 'Z'
    cur = dateutil.parser.parse(now)
    until = (datetime.datetime.utcnow() + DT).isoformat() + 'Z'
    if (dt_now.second == 0 and dt_now.minute % 10 == 0) or not os.path.isfile(CACHED_EVENTS):
        events = event_list(now, until)
        with open(CACHED_EVENTS, 'w') as fcache:
            json.dump(events, fcache)
    else:
        with open(CACHED_EVENTS, 'r') as fcache:
            events = json.load(fcache)

    if not events:
        return (None, None)
    else:
        started = []
        future = None
        for event in events:
            summary = event.get('summary')
            if summary is None:
                continue
            startTime = event.get('start', {}).get('dateTime')
            endTime = event.get('end', {}).get('dateTime')
            if endTime is not None and dateutil.parser.parse(endTime) <= cur:
                continue
            if startTime is not None:
                start = dateutil.parser.parse(startTime)
                if start < cur:
                    started.append(summary)
                else:
                    future = (summary, start-cur)
                    break
            else:
                started.append(summary)
        cur_event = ' > '.join(started) or None
        if future is not None:
            summary, delta = future
            secs = delta.seconds
            hours = secs // 3600
            mins = (secs%3600 + 59) // 60
            if hours == 0:
                next_event = '{} in {}m'.format(summary, mins)
            else:
                next_event = '{} in {}h{}m'.format(summary, hours, mins)
        else:
            next_event = None
        return (cur_event, next_event)
