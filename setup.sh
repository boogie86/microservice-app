#!/bin/bash
set -e
service mysql start
mysql < /docker-entrypoint-initdb.d/initdb.sql
echo Setup script was executed!