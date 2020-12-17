#!/bin/bash
# -------
# Script for install of Postgresql to be used with Alfresco
#
# Copyright 2013-2016 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

export ALFRESCODB=alfresco
export ALFRESCOUSER=alfresco

#echo
#echo "--------------------------------------------"
#echo "This script will install PostgreSQL."
#echo "and create alfresco database and user."
#echo "You may be prompted for sudo password."
#echo "--------------------------------------------"
#echo

#read -e -p "Install PostgreSQL database? [y/n] " -i "n" installpg
installpg=y
if [ "$installpg" = "y" ]; then
  sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install postgresql-9.6 -y
  sudo service postgresql start
  #echo
  #echo "You will now set the default password for the postgres user."
  #echo "This will open a psql terminal, enter:"
  #echo
  #echo "\\password postgres"
  #echo
  #echo "and follow instructions for setting postgres admin password."
  #echo "Press Ctrl+D or type \\q to quit psql terminal"
  #echo "START psql --------"
  ##sudo -u postgres psql postgres
  #echo "END psql --------"
  #echo
fi

#read -e -p "Create Alfresco Database and user? [y/n] " -i "n" createdb
createdb=y
if [ "$createdb" = "y" ]; then
  sudo -u postgres psql -U postgres postgres << DBCREATE
CREATE USER 'alfresco' WITH PASSWORD 'alfresco';
CREATE DATABASE alfresco OWNER alfresco ENCODING 'utf8';
GRANT ALL PRIVILEGES ON DATABASE alfresco TO alfresco;
DBCREATE
  #echo
  #echo "Remember to update alfresco-global.properties with the alfresco database password"
  #echo
fi

cat << EOF | sudo tee /etc/postgresql/9.6/main/pg_hba.conf
local all alfresco trust
host all all 127.0.0.1/32 trust
local all postgres peer
EOF

sudo service postgresql restart
sudo service nginx start
sudo /opt/alfresco/alfresco-service.sh servicestart

#echo
#echo "You must update postgresql configuration to allow password based authentication"
#echo "(if you have not already done this)."
#echo
#echo "Add the following to pg_hba.conf or postgresql.conf (depending on version of postgresql installed)"
#echo "located in folder /etc/postgresql/<version>/main/"
#echo
#echo "host all all 127.0.0.1/32 password"
#echo
#echo "After you have updated, restart the postgres server: sudo service postgresql restart"
#echo
