############################################################
# Dockerfile to build Teampeak3 container images
# Based on Ubuntu 14.04
############################################################

FROM ubuntu:14.04
MAINTAINER Adam Garstang <adamgarstang@googlemail.com>

# Update the repository sources list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Ensure container is updated
RUN apt-get -y upgrade

# wget required
RUN apt-get -y install wget

# Add teamspeak3 user
RUN adduser --disabled-login --home /opt/teamspeak3 --gecos "Teampeak3 Server" teamspeak3

# Download Teamspeak 3.0.11 to /opt/teamspeak3
RUN wget http://dl.4players.de/ts/releases/3.0.11/teamspeak3-server_linux-amd64-3.0.11.tar.gz -O - | tar xz -C /opt/teamspeak3 --strip-components 1

# Setup persistent data
RUN mkdir -p /srv/teamspeak3
RUN chown -R teamspeak3:teamspeak3 /srv/teamspeak3
RUN ln -s /srv/teamspeak3/ts3server.sqlitedb /opt/teamspeak3/ts3server.sqlitedb

# Setting this up as it's handy for interactive testing (must run explicitly in foreground for docker)
RUN ln -s /opt/teamspeak3/ts3server_startscript.sh /etc/init.d/teamspeak3

ADD /scripts/ /opt/teamspeak3/scripts/
RUN chmod -R 774 /opt/teamspeak3/scripts/

# Ports
EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

# Always Run Teamspeak3 Server
ENTRYPOINT ["/opt/teamspeak3/scripts/runas_teamspeak3.sh"]
CMD ["query_ip_whitelist=/srv/teamspeak3/query_ip_whitelist.txt", "query_ip_blacklist=/srv/teamspeak3/query_ip_blacklist.txt", "logpath=/srv/teamspeak3/logs/", "licensepath=/srv/teamspeak3/", "dbplugin=ts3db_sqlite3"]
