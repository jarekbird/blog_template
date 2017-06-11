from __future__ import print_function
import sys
import json
import pdb
import os
from handler import Handler
try:
    from config.config_loader import ConfigLoader
except(ImportError):
    from os.path import dirname, abspath
    project_path = dirname(dirname(os.getcwd()))
    sys.path.append(project_path)
    from config.config_loader import ConfigLoader

print('Loading function')

def main(event, context):
    handler = Handler()
    return handler.get(event, context)

if __name__ == "__main__":
    class Event:
        def __getitem__(self, key):
            e = {
            'key1': 'value1',
            'key2': 'value2',
            'key3': 'value3',
                }
            return e[key]
    context = 'context'
    event = Event()
    print(main(event, context))
