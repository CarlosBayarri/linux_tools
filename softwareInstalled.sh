#!/bin/bash
# Developed by Carlos Bayarri
# softwareInstalled
# This script allow us to build all the software needed for the system

echo "System:"
lsb_release -a
echo "Kernel info: "
uname -a
echo ""
echo " --- Command Line Interface --- "
# Building for APACHE
echo "Searching apache2..."
{
dpkg --get-selections | grep apache2 > /dev/null;
} || {
echo "Not installed!"
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install apache2; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

# Building for TOMCAT
echo "Searching Tomcat9..."
{
ps -ef | grep tomcat > /dev/null;
} || {
echo "Service not found..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install tomcat9; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

# Building for GEOSERVER
echo "Searching geoserver..."
{
sudo find /opt/tomcat9/webapps/ -name geoserver -type d
} || {
echo "Not found"
}

# Building for POSTGRESQL
echo "Searching postgres..."
{
dpkg --get-selections | grep postgres > /dev/null;
} || {
echo "Not installed!"
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install postgres postgres-contrib; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
# Building for POSTGIS
echo "Searching postgis..."
{
dpkg --get-selections | grep postgis > /dev/null;
} || {
echo "Not installed!"
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[yn]* ) sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable; sudo apt-get update; sudo apt-get install postgis; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
    esac
done
}
# Building for GDAL
echo "Searching Gdal..."
{
dpkg --get-selections | grep gdal > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[Yy]* ) sudo apt-get install gdal-bin; break;;
	[Nn]* ) break;;
	* ) echo "Please asnwer yes or no.";;
    esac
done
}
# Building for PIP
echo "Searching PIP..."
{
dpkg --get-selections | grep python-pip > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[Yy]* ) sudo apt-get install python-pip python-dev build-essential; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
    esac
done
}
# Building for NODEJS
echo "Searching NODEJS..."
{
dpkg --get-selections | grep nodejs > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install nodejs; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

# Building for NPM
echo "Searching NPM..."
{
dpkg --get-selections | grep npm > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install npm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
# Building for ANGULAR
echo "Searching ANGULAR..."
{
ng --version > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) npm install -g @angular/cli; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

echo ""
echo " --- Graphical User Interface --- "
# Building for PUTTY
echo "Searching Putty..."
{
dpkg --get-selections | grep putty > /dev/null;
} || {
echo "Not installed..."
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) sudo apt-get install putty; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no."
    esac
done
}
# Building for PGADMIN3
echo "Searching pgadmin3..."
{
dpkg --get-selections | grep pgadmin3 > /dev/null;
} || {
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[Yy]* ) sudo apt-get install pgadmin3; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
    esac
done
}
# Building for FILEZILLA
echo "Searching filezilla..."
{
dpkg --get-selections | grep filezilla > /dev/null;
} || {
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[Yy]* ) sudo apt-get install filezilla; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
    esac
done
}
# Building for VISUAL CODE STUDIO
echo "Searching Visual Code Studio..."
{
dpkg --get-selections | grep -w code > /dev/null;
} || {
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
	[Yy]* ) sudo apt-get install code; break;;
	[Nn]* ) break;;
	* ) echo "Please answer yes or no.";;
    esac
done
}
# Building for NODE

# Building for NPM

# Building for ANGULAR

echo ""
echo "Done!"
notify-send 'Software' 'Done!' -i face-smile -t 2500














