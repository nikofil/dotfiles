#!/usr/bin/python3
from __future__ import print_function
import datetime
import dateutil.parser
import pickle
import os
import os.path
import json
import subprocess
import sys
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/calendar']
DT = datetime.timedelta(hours=8)
TOKEN_PICKLE = '/var/lib/gcalendar/calendar_token.pickle'
CACHED_EVENTS = '/var/lib/gcalendar/calendar_events.json'
CREDS_JSON = '/var/lib/gcalendar/credentials.json'

def event_list(now, until):
    """Shows basic usage of the Google Calendar API.
    Prints the start and name of the next 10 events on the user's calendar.
    """
    old_stdout = sys.stdout
    try:
        with open(os.devnull, "w") as devnull:
            sys.stdout = devnull
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
                                         maxResults=10, singleEvents=True, orderBy='startTime'
                                        ).execute().get('items', [])
    finally:
        sys.stdout = old_stdout

def get_calendar_strs():
    # Call the Calendar API
    dt_now = datetime.datetime.utcnow()
    now = dt_now.isoformat() + 'Z'
    cur = dateutil.parser.parse(now)
    until = (datetime.datetime.utcnow() + DT).isoformat() + 'Z'
    if (dt_now.second < 30 and dt_now.minute % 4 == 0) or not os.path.isfile(CACHED_EVENTS):
        events = event_list(now, until)
        with open(CACHED_EVENTS, 'w') as fcache:
            json.dump(events, fcache)
    else:
        with open(CACHED_EVENTS, 'r') as fcache:
            events = json.load(fcache)

    if not events:
        return (None, None, None)
    else:
        started = []
        future = None
        just_started = None
        for event in events:
            if event.get('transparency') == 'transparent' or any(i.get('self') and i.get('responseStatus') == 'declined' for i in event.get('attendees', [])):
                continue
            summary = event.get('summary')
            # print(json.dumps(event, indent=4))
            if summary is None or summary == 'Working from office':
                continue
            startTime = event.get('start', {}).get('dateTime')
            endTime = event.get('end', {}).get('dateTime')
            if endTime is not None and dateutil.parser.parse(endTime) <= cur:
                continue
            if startTime is not None:
                start = dateutil.parser.parse(startTime)
                if start < cur:
                    started.append(summary)
                    if start > cur - datetime.timedelta(seconds=10):
                        just_started = summary
                else:
                    future = (summary, start-cur)
                    break
            else:
                started.append(summary)
        cur_event = ' > '.join(started) or None
        if future is not None:
            summary, delta = future
            if len(summary) > 40:
                summary = summary[:40] + '…'
            secs = delta.seconds + 59
            hours = secs // 3600
            mins = (secs%3600) // 60
            if hours == 0:
                next_event = '{} in {}m'.format(summary, mins)
            else:
                next_event = '{} in {}h{}m'.format(summary, hours, mins)
        else:
            next_event = None
        return (cur_event, next_event, just_started)


if __name__ == '__main__':
    cur_evt, next_evt, just_started = get_calendar_strs()
    if cur_evt:
        print(cur_evt, end='')
        if next_evt:
            print(' | ', end='')
    if next_evt:
        print(next_evt, end='')
    if just_started:
        subprocess.Popen(['notify-send', '-t', '10000', 'Current event', just_started])
    print()
