#!/bin/bash

echo "Set permissions on /srv/teamspeak3"
chown -R teamspeak3:teamspeak3 /srv/teamspeak3

echo "Running Teamspeak as teamspeak3"
sudo -u teamspeak3 /opt/teamspeak3/ts3server_minimal_runscript.sh $@
