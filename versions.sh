#!/bin/bash
# Developed by Carlos Bayarrri
# versions

echo "PACKAGES"

echo "Apache2"
apache2 -v

echo "Tomcat9"
echo "Not yet"

echo "PostgreSQL"
psql --version

echo "PostGIS"
echo "Not yet"

echo "GDAL"
echo "Not yet"

echo "PIP"
pip -V

echo "NODEJS"
node -v

echo "NPM"
npm -v

echo "ANGULAR"
ng version | grep "Angular CLI"

echo "Putty"
echo "Not yet"

echo "PGAdmin3"
pgadmin3 -v

echo "FileZilla"
filezilla -v

echo "Visual Studio Code"
code -v

