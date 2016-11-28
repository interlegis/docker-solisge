#!/bin/bash
SAGU_PSQL_USERNAME=postgres
SAGU_PSQL_DATABASE=solisge
SAGU_PSQL_PASSWORD=sagupw
if [ ! -z $SAGU_PSQL_PASSWORD ]; then
  SAGU_PSQL_PASSWORD=$POSTGRESQL_ENV_POSTGRESQL_PASSWORD
fi

echo "Configuring database connection..."
sed -i "s/password=postgres/password=${SAGU_PSQL_PASSWORD}/g" /instalador/properties/build-db.properties 
sed -i "s/ip=localhost/ip=postgresql/g" /instalador/properties/build-db.properties 
sed -i "s/<host>localhost<\/host>/<host>postgresql<\/host>/g" /var/www/solisge/miolo20/etc/miolo.conf 
sed -i "s/<host>localhost<\/host>/<host>postgresql<\/host>/g" /var/www/solisge/miolo25/etc/miolo.conf 
sed -i "s/<host>localhost<\/host>/<host>postgresql<\/host>/g" /var/www/solisge/miolo26/etc/miolo.conf 
sed -i "s/<password>postgres<\/password>/<password>${SAGU_PSQL_PASSWORD}<\/password>/g" /var/www/solisge/miolo20/etc/miolo.conf 
sed -i "s/<password>postgres<\/password>/<password>${SAGU_PSQL_PASSWORD}<\/password>/g" /var/www/solisge/miolo25/etc/miolo.conf 
sed -i "s/<password>postgres<\/password>/<password>${SAGU_PSQL_PASSWORD}<\/password>/g" /var/www/solisge/miolo26/etc/miolo.conf 

psqlcheck() {
  # Wait for PostgreSQL to be available...
  COUNTER=20
  export PGPASSWORD=$SAGU_PSQL_PASSWORD
  until psql -h postgresql -p 5432 -U $SAGU_PSQL_USERNAME -lqt 2>/dev/null; do
    echo "WARNING: PostgreSQL still not up. Trying again..."
    sleep 10
    let COUNTER-=1
    if [ $COUNTER -lt 1 ]; then
      echo "ERROR: PostgreSQL connection timed out. Aborting."
      exit 1
    fi
  done
  exists=`psql -h postgresql -p 5432 -U $SAGU_PSQL_USERNAME -lqt | grep ${SAGU_PSQL_DATABASE}`
  if [ "$exists" != "0" ]; then
    echo -n "Database does not exist. Importing SAGU (SOLISGE) schema..."
    cd /instalador && \
    tar zxvf /var/www/solisge/miolo20/modules/basic/sql/sagu.sql.tar.gz && \
    createdb -h postgresql -p 5432 -U $SAGU_PSQL_USERNAME $SAGU_PSQL_DATABASE 2>/dev/null && \
    psql --quiet -h postgresql -p 5432 -U $SAGU_PSQL_USERNAME -f sagu.sql $SAGU_PSQL_DATABASE 2>/dev/null && \
    echo " OK."
    
    echo -n "Running syncdb..."
    php /var/www/solisge/miolo20/modules/basic/classes/sconsolesyncdb.php 2>/dev/null && \
    echo " OK."
  fi
}

psqlcheck

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
