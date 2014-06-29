#!/usr/bin/python
__author__ = 'wnoble'
#
#general logic:
# count number of params
#  if no params then check for services file in the following order
#    ~/.svcstat /usr/local/etc/svcstat.conf
#    if not found error
#  if one param, assume that's a file of services to check.
#    check to see if that file exists
#      if it doesn't, assume it's a processname
#
# The format of the services file:
#PrettyName,StringToFindInProcessList
#
#  The PrettyName is the name that's displayed to the user. No other handling is done to it.
#
#  The StringToFindInProcessList is the literal regex string we'll use to determine
#  how many processes this service has.
##
#
# Program Logic:
#  Check to see if load is low enough that we should proceed.
#
#  Grab copy of processlist.
#
#  for each pretty name service
#    check processlist for a match for servicename
#      if we find a match
#        count number of matches
#      display match status and number
#      If we do not find a match
#      display prettyname and not running
import sys
import os
import fileinput
#
import re
import subprocess
from subprocess import Popen, PIPE
from optparse import OptionParser

#uname = os.uname()
#print uname[0]
def debug(message):
    if hasattr(parser, 'options'):
        if options.debug == True:
            print message


def main():
    parser = OptionParser(usage="%prog [-f] [-q]", version="%prog 1.0")
    parser.add_option("-f", "--file", action='store', type='string',
        dest="filename", default='/usr/local/etc/svcstat.conf',
        help="use the specified file for services to check", metavar="FILE")
    parser.add_option("-d", "--debug",
        action="store_true", dest="debug", default=False,
        help="Enable debugging")

    (options, args) = parser.parse_args()
    #were we given options?
    if len(args) >1:
        debug ("We were given arguments", options)

#    if len(sys.argv) > 1:
#        debug 'We were given an argument: ', sys.argv(1)

    else:
        debug('we were not given an argument. Checking for files')
        homedir=os.path.expanduser('~')
        homefile = os.path.join(homedir ,'./svcstat')
        if os.path.isfile(homefile):
            debug('we found the file at ~/.svcstat')
            parsefile(homefile)
        elif os.path.isfile('/usr/local/etc/svcstat.conf'):
            debug('we found the file at /usr/local/etc/svcstat.conf')
            parsefile('/usr/local/etc/svcstat.conf')
        else:
           print 'we were not given a process to search for as an argument, and no config files are present. failing'
           exit()

def parsefile(filepath):

    myfile = open(filepath)
    for line in myfile:
        line = line.rstrip('\n')
        elements = line.split(",")
        if len(elements) == 2:
            service, checkstring = elements
        else:
            service = elements[0]; checkstring = ''
        find_procs(service,checkstring)
    myfile.close()

def find_procs(service_name,svc_string):
#    pass
    if svc_string == "":
        svc_string = service_name
    debug("Service: "+service_name)
    debug("String:  "+svc_string)
    if is_running(svc_string):
        status = 'Running'
    else:
        status = 'Not Running'

    print service_name+": "+status

def is_running(proc_string):
    uname = os.uname()
    if uname[0] == 'Darwin':
        cmd = "ps axO command | tail -n +2"
    elif uname[0] == 'Linux':
        cmd = "ps axo command | tail -n +2"
    else:
        print "We only support Darwin and Linux systems, not "+ uname[0]
        exit()
    p = Popen(cmd, shell=True, stdout=PIPE, stdin=PIPE)
    p.stdin.close()
    if p.wait() != 0:
        print "There were some errors"
    out = p.stdout.read()
    if re.search(proc_string, out):
        return True
    return False


if __name__ == '__main__':
  main()
