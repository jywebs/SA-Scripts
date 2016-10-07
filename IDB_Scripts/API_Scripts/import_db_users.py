#!/usr/bin/python

####################################
## User import import_db_users.py ##
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
    --scalearc,-s               : Scalearc URL
    --username,-u               : ScaleArc User Name
    --password,-p               : ScaleArc Password
    --cluster-name,-n        : Name of the cluster.
    --csvfile,-f                : Path of the csv file.
    --h, -h                  : Display help
""" % (os.path.basename(sys.argv[0]))
    sys.exit(1)

def _get_apikey(scalearc,username,password):
    
    """Method to find APIKEY from Remote Host
    """
    apikey = ''
   
    print "Retrieving APIKEY %s" % url

    url = 'https'+scalearc+'/api/system/show_api_key'
    values = {'username' : username,
                   'password' : password,
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
    
def _add_users
    
    

def main():

    try:
        opts, args = getopt.getopt(sys.argv[1:],
                        'hdn:',
                        ["help", "scalearc", "username", "password", "cluster-name=",   
                            "cluster-name=", "csvfile=",]
                        )
    except:
        _usage("error parsing options")

    # Intialising all input to None
    scalearc = none
    cluster_name = None
    username = None
    password = None
    csvfile = None

    for opt in opts:
        if opt[0] == '-s' or opt[0] == '--scalearc':
            scalearc = opt[1]
        if opt[0] == '-n' or opt[0] == '--cluster-name':
            cluster_name = opt[1]
        elif opt[0] == '-u' or opt[0] == '--username':
            username = opt[1]
        elif opt[0] == '-p' or opt[0] == '--password'::
            password = opt[1]
        elif opt[0] == '-f' or opt[0] == '--csvfile':
            csvfile = opt[1]
        elif opt[0] == '-h' or opt[0] == '--help':
            _usage()

    if scalearc and cluster_name and username and password and csvfile :
        apikey = _get_apikey(scalearc, username, password)
        if apikey:
            _add_users(apikey, csvfile)
        else:
            print "Error Retrieving API Key. Please check username and password"

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print "Please provide correct arguments"
        _usage()
    else:
        main()


