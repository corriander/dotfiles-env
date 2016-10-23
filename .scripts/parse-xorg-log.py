#!/usr/bin/python
"""Parse the contents of Xorg.0.log

I don't find seconds-since-boot to be particularly helpful in trying
to diagnose issues. This simple script reads the contents of
Xorg.0.log and adds human-readable timestamps.
"""

import os
import re
import datetime


LOG_PATH = '/var/log/Xorg.0.log'


# Get time of last modification.
mtime = datetime.datetime.fromtimestamp(os.stat(LOG_PATH).st_mtime)

# Parse the log
with open(LOG_PATH, 'r') as log:
    records = [line.strip() for line in log]


tdelta_pattern = re.compile(r'^\[([^\]]+)\]')

latest_tdelta = int(float(tdelta_pattern.search(records[-1]).groups()[0]))


for r in records:
    try:
        tdelta_str = tdelta_pattern.search(r).groups()[0]
    except AttributeError:
        # Some information is printed without '^[elapsed_time]'
        print(r)
        continue
    tdelta = int(float(tdelta_str))
    offset = latest_tdelta - tdelta
    tstamp = mtime - datetime.timedelta(seconds=offset)
    print(r.replace(tdelta_str, tstamp.strftime('%Y-%m-%d %H:%M:%S')))
