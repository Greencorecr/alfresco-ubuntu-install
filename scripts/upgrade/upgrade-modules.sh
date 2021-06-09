#!/bin/bash
# -------
# Script for install of Alfresco
#
# Copyright 2013-2017 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

/opt/alfresco/alfresco-service.sh servicestop


export ALF_HOME=/opt/alfresco
export ALF_DATA_HOME=$ALF_HOME/alf_data
export CATALINA_HOME=$ALF_HOME/tomcat
export ALF_USER=alfresco
export ALF_GROUP=$ALF_USER
export APTVERBOSITY="-qq -y"
export TMP_INSTALL=/tmp/alfrescoinstall


cd /tmp/
wget https://github.com/Greencorecr/alfresco-ubuntu-install/blob/master/modules/transformador.tar.xz
tar xf transformador.tar.xz
mv usr/local/bin/transformador /usr/local/bin/
mv /usr/local/bin/transformador/transformador.service /etc/init.d/transformador

sudo nohup /opt/alfresco/alfresco-service.sh servicestart
