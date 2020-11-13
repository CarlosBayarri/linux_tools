#!/bin/bash

# SERVER SIGNIS
echo "Starting..."
cd signis_osgis
# source bin/activate
# echo "Virtual environment"
loading_message() {
        start=1
        end=$(($1))
        echo -ne '[';
        if [ $end != 100 ]; then
                spaces=100-$end
                for ((i=$start; i<=$end; i++)); do echo -ne '='; done
                for ((i=$start; i<=$spaces; i++)); do echo -ne ' '; done
        else
                for ((i=$start; i<=$end; i++)); do echo -ne =; done
        fi
        echo -ne ']';
	echo -ne '['$end']';
        echo -ne '   '$2;
	sleep 1
}
echo ""
echo "HELLO! I'm a software to start the signis application."
echo "Select an option: "
echo " 0 - Run server"
echo " 1 - Configure and run server"
while :
do
  read OPTION
  case $OPTION in
    0 )  echo "Nice! Let's start running the server...";
	cd signis
	python manage.py runserver;
	break;;
    1 )  echo -ne "I will help you for the configuration.";
	loading_message 00 "Let's start \n"
	loading_message 01  "First, We need Django. \n"
	# Building for DJANGO
	loading_message 02 "Searching django... \n"
	{
	python -c "import django; print(django.get_version())";
	} || {
	loading_message 02 "Not installed! \n"
	while true; do
	    read -p "Do you wish to install this program?" yn
	    case $yn in
		[Yy]* ) pip install django; break;;
		[Nn]* ) break;;
		* ) loading_message 02 "Please answer yes or no. \n";;
	    esac
	done
	}
	loading_message 10 "Software checked! \n"
	cd signis
	cd signis
	# Global conf
	loading_message 10 "For the configuration I need some ideas... \n"
	loading_message 10 "(Don't worry, this is not stored anywhere) \n"
	read -p "What's the postgres user? Write here: " namePostgres;
        read -sp "What's the postgres password? Write here: " passPostgres;
	loading_message 15 "Access configured... \n"
	# Conf database
	while true; do
	    read -p "Do you wish to create a database?" yn
	    case $yn in
		[Yy]* ) loading_message 15 "Nice \n";
			read -p  "The default database name is 'signis_osgis'. Press enter for default value 'signis_osgis' or put another name for the database:" databasePostgres;
			databasePostgres=${databasePostgres:-signis_osgis}
			sudo -u $namePostgres createdb $databasePostgres;
			loading_message 15 "Database $databasePostgres created for user $namePostgres \n";
			break;;
		[Nn]* ) read -p  "Press enter for default value 'signis_osgis' or put another name for your database:" databasePostgres;
			databasePostgres=${databasePostgres:-signis_osgis}
			break;;
		* ) loading_message 15 "Please answer yes or no. \n";;
	    esac
	done
	# Comment
	loading_message 20 "So...the database name is $databasePostgres. Ok! \n";
	# Comment
	# Conf app connection
	while true; do
	    read -p "Do you wish to configure the application connection?" yn
	    case $yn in
		[Yy]* ) loading_message 20 "Configuring application connection... \n";
			sed -i "83s/.*/        'NAME': '$databasePostgres',/" settings.py;
			sed -i "84s/.*/        'USER': '$namePostgres',/" settings.py;
			sed -i "85s/.*/        'PASSWORD': '$passPostgres',/" settings.py;
			loading_message 30 "Application confidured for user $namePostgres \n"
			break;;
		[Nn]* ) break;;
		* ) loading_message 20 "Please answer yes or no. \n";;
	    esac
	done
	# Comment
	loading_message 30 "Well, Djando app has the references. \n"
	loading_message 32 "Let's start with the relations in the new database. \n"
	# Comment
	cd ..
	# Migrate relations
	while true; do
	    read -p "Do you wish to migrate relations?" yn
	    case $yn in
		[Yy]* ) python manage.py migrate;
			break;;
		[Nn]* ) break;;
		* ) loading_message 32 "Please answer yes or no. \n";;
	    esac
	done
	# Comment
	loading_message 35 "The next step is to fill all the tables with the default data. \n"
	# Comment
	while true; do
	    read -p "Do you wish to fill the tables?" yn
	    case $yn in
		[Yy]* ) loading_message 35 "Restoring a backup and filling tables. \n"
			sudo -u $namePostgres psql $databasePostgres < signis_osgis.backup;
			break;;
		[Nn]* ) break;;
		* ) loading_message 35 "Please answer yes or no. \n";;
	    esac
	done
	# Comment
	loading_message 40 "Oh yes! We have to post some layers in to the local geoserver. \n"
	loading_message 40 "I hope you have geoserver. If not, discard the following configuration, install geoserver and post the layers. \n"
	# Comment
	# Conf GEOSERVER
	while true; do
	    read -p "Do you wish to configure GEOSERVER?" yn
	    case $yn in
		[Yy]* ) loading_message 40 "So...tell me something \n";
			read -p "What's the geoserver user? Commonly is admin. Press enter for default or write another: " userGeoserver;
			userGeoserver=${userGeoserver:-admin}
			read -sp "What's the geoserver password? Commonly is geoserver. Press enter for default or write another: " passGeoserver;
			passGeoserver=${passGeoserver:-geoserver}
			loading_message 50 "Access to geoserver \n"
			loading_message 51 "I can create a workspace in geoserver \n"
			read -p "The default workspace name is 'signis_osgis'. Press enter for default or write another:" workspaceGeoserver;
			workspaceGeoserver=${workspaceGeoserver:-signis_osgis}
			curl -u $userGeoserver:$passGeoserver -POST -H 'Content-type:text/xml' -d '<workspace><name>'$workspaceGeoserver'</name></workspace>' http://localhost:8080/geoserver/rest/workspaces;
			loading_message 55 "Workspace created in geoserver! \n";
			loading_message 55  "I can create the store for the vectorial layers \n"
			read -p "The default store name is 'signis_osgis'. Write the same name:" storeGeoserver;
			storeGeoserver=${storeGeoserver:-signis_osgis}
			echo -ne "<dataStore><name>"$storeGeoserver"</name><connectionParameters><host>localhost</host><port>5432</port><database>"$databasePostgres"</database><schema>public</schema><user>"$namePostgres"</user><passwd>"$passPostgres"</passwd><dbtype>postgis</dbtype></connectionParameters></dataStore>" > $storeGeoserver".xml";
			nameFile=$storeGeoserver".xml";
			curl -u $userGeoserver:$passGeoserver -XPOST -T $nameFile -H 'Content-type: text/xml' http://localhost:8080/geoserver/rest/workspaces/$workspaceGeoserver/datastores;
			# echo "Listing store..."
			# curl -u $userGeoserver:$passGeoserver -XGET http://localhost:8080/geoserver/rest/workspaces/$workspaceGeoserver/datastores/$nameFile
			loading_message 57 "Publishing the layer firewalls... \n"
			curl -u $userGeoserver:$passGeoserver -XPOST -H "Content-type: text/xml" -d "<featureType><name>firewalls_firewalls</name></featureType>" http://localhost:8080/geoserver/rest/workspaces/$workspaceGeoserver/datastores/$storeGeoserver/featuretypes
			loading_message 65 "Layer published \n"
			# Store to ImageMosaic
			loading_message 67 "We have to create another store to manage the raster images. \n"
			# read -p "The default store name is 'signis_osgis_model'. Write the same name if you want: " storeModelGeoserver;
			loading_message 68 "Checking... \n"
			sudo chmod 777 -R ../../model/model_data/raster_data
			loading_message 69 "Creating raster style...";
			curl -u $userGeoserver:$passGeoserver -XPOST -H "Content-type: text/xml" -d "<style><name>model_style</name><filename>raster_style.sld</filename></style>" http://localhost:8080/geoserver/rest/styles;
			curl -u $userGeoserver:$passGeoserver -XPUT -H "Content-type: application/vnd.ogc.sld+xml" -d @raster_style.sld http://localhost:8080/geoserver/rest/styles/model_style;
			cd ../../model/model_data/raster_data/signis_osgis_model
			path=$(pwd)
			loading_message 70 "Configuring stores and layers...... \n"
			array=("default_model_january" "default_model_february" "default_model_march" "default_model_april" "default_model_may" "default_model_juny" "default_model_july" "default_model_august" "default_model_september" "default_model_october" "default_model_november" "default_model_december" "own_model")
			boundingBox='<nativeBoundingBox><minx>656449.5752999996</minx><maxx>711524.5752999996</maxx><miny>4376198.7327</miny><maxy>4410048.7327</maxy></nativeBoundingBox><latLonBoundingBox><minx>5.896986867457583</minx><maxx>6.3917340101864095</maxx><miny>36.547343545100034</miny><maxy>36.791244229043</maxy><crs>EPSG:4326</crs></latLonBoundingBox>'
			ite=70
			for i in ${!array[@]}; do
			  	# echo -ne " $i,${array[$i]} "
				curl -u $userGeoserver:$passGeoserver -XPOST -H "Content-Type: text/xml" -d "<coverageStore><name>"${array[$i]}"</name><workspace>signis_osgis</workspace><enabled>true</enabled><type>GeoTIFF</type><url>file:"$path"/"${array[$i]}".tif</url></coverageStore>" http://localhost:8080/geoserver/rest/workspaces/public/coveragestores > /dev/null;
				curl -u $userGeoserver:$passGeoserver -XPOST -H 'Content-type: text/xml' -d '<coverage><name>'${array[$i]}'</name><title>'${array[$i]}'</title><nativeCRS>GEOGCS[&quot;WGS 84&quot;,DATUM[&quot;World Geodetic System 1984&quot;,SPHEROID[&quot;WGS 84&quot;,6378137.0, 298.257223563, AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]],AUTHORITY[&quot;EPSG&quot;,&quot;6326&quot;]],PRIMEM[&quot;Greenwich&quot;, 0.0, AUTHORITY[&quot;EPSG&quot;,&quot;8901&quot;]],UNIT[&quot;degree&quot;, 0.017453292519943295],AXIS[&quot;Geodetic longitude&quot;, EAST],AXIS[&quot;Geodetic latitude&quot;, NORTH],AUTHORITY[&quot;EPSG&quot;,&quot;4326&quot;]]</nativeCRS><srs>EPSG:3857</srs>'$latLonBoundingBox'<projectionPolicy>FORCE_DECLARED</projectionPolicy><dimensions><coverageDimension><name>GRAY_INDEX</name><description>GridSampleDimension[-Infinity,Infinity]</description><range><min>-inf</min><max>inf</max></range><nullValues><double>255.0</double></nullValues><dimensionType><name>UNSIGNED_8BITS</name></dimensionType></coverageDimension></dimensions></coverage>' http://localhost:8080/geoserver/rest/workspaces/$workspaceGeoserver/coveragestores/${array[$i]}/coverages > /dev/null;
				curl -u $userGeoserver:$passGeoserver -XPUT -H "Content-type: text/xml" -d "<layer><defaultStyle><name>model_style</name></defaultStyle></layer>" http://localhost:8080/geoserver/rest/layers/$workspaceGeoserver:${array[$i]} > /dev/null;
				((ite2=$ite+$i*2))
				# echo -ne "###################      ($ite2%)\r"
				# sleep 0.5
			done

			cd ../../../../signis_osgis/signis
			loading_message 94 "Raster image published! \n";
			# gdal_translate ../reclass/siose.tif siose20190108T180000000Z.tif

			break;;
		[Nn]* ) break;;
		* ) loading_message 40 "Please answer yes or no. \n";;
	    esac
	done
	# Comment
	loading_message 95 'Geoserver is configured... \n'
	loading_message 97 "The last step is to configure a superuser to log in. \n"
	# Comment
	# Create superuser
	while true; do
	    read -p "Do you wish to create a super user?" yn
	    case $yn in
		[Yy]* ) python manage.py createsuperuser; break;;
		[Nn]* ) break;;
		* ) echo -ne "Please answer yer or no.";;
	    esac
	done
	# Comment
	loading_message 100 "NICE! \n"
	# Comment
	# Running server
	echo -ne "Running server..."
	python manage.py runserver
	break;;
    * ) echo -ne "Please answer 0 or 1.";;
  esac
done


