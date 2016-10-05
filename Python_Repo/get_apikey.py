#!/usr/bin/python

####################################
## User import get_apikey.py      ##
## Example Script from ScaleArc   ##
## No support Provided            ##
####################################

# System imports
import os, time, sys
import getopt, shutil
import json
import urllib2, traceback

def _usage(msg=None):
    """Display the program's usage on stderr and exit
    """
    if msg:
        print >> sys.stderr, msg
    print >> sys.stderr, """
Usage: %s [options]

Options:
    -s               : Scalearc URL
    -u               : ScaleArc User Name
    -p               : ScaleArc Password
    -h               : Display help

    example ./get_apikey.py -s <url> -u username -p password
""" % (os.path.basename(sys.argv[0]))
    sys.exit(1)

def _get_apikey(scalearc,username,password):
    
    """Method to find APIKEY from Remote Host
    """
    apikey = ''
   
    url = str(scalearc)+'/api/system/show_api_key'
    print "Retrieving APIKEY %s" % url

    values = {'username' : str(username),
              'password' : str(password),
              'apikey' : 'abc'}
    url_values = json.dumps(values)

    req = urllib2.Request(url)
    req.add_header('Content-Type', 'application/json')

    try:
        response = json.load(urllib2.urlopen(req,url_values))
        if isinstance(response, dict) and \
        response.get('success') and response.get('data'):
            apikey = response['data']['apikey']
    except:
        print "Error occured while getting apikey for given "\
                " url %s" % traceback.format_exc()
    finally:
        return apikey

def main():

    try:
        opts, args = getopt.getopt(sys.argv[1:],
                        'hds:u:p:',
                        ["help", "scalearc", "username", "password", ])
    
    except:
        _usage("error parsing options")

    # Intialising all input to None
    scalearc = None
    username = None
    password = None

    for opt in opts:
        if opt[0] == '-s' or opt[0] == '--scalearc':
            scalearc = opt[1]
        elif opt[0] == '-u' or opt[0] == '--username':
            username = opt[1]
        elif opt[0] == '-p' or opt[0] == '--password':
            password = opt[1]
        elif opt[0] == '-h' or opt[0] == '--help':
            _usage()

    if scalearc and username and password :
        apikey = _get_apikey(scalearc, username, password)
        print apikey
    else:
        print "Error Retrieving API Key. Please check username and password"

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print "Please provide correct arguments"
        _usage()
    else:
        main()