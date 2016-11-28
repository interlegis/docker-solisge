#!/bin/bash

FILESDIR=/var/solisge-files
ROOTDIR=/var/www/solisge
mkdir -p $FILESDIR
cd $ROOTDIR
DATADIRS='miolo25/modules/gnuteca3/misc/scripts/client
miolo25/modules/gnuteca3/html/files
miolo25/html/files
miolo25/var
miolo20/cliente
miolo20/var
miolo20/modules/protocol/html/files
miolo20/modules/basic/upload
miolo20/modules/basic/documents
miolo20/modules/basic/html/files
miolo20/modules/residency/html/files
miolo20/modules/admin/html/files
miolo20/modules/institutional/html/files
miolo20/modules/controlCopies/html/files
miolo20/modules/services/html/files
miolo20/modules/academic/html/files
miolo20/modules/resmedica/html/files
miolo20/modules/humanResources/html/files
miolo20/modules/finance/html/files
miolo20/modules/selectiveProcess/html/files
miolo20/modules/training/html/files
miolo20/modules/sagu2/html/files
miolo20/modules/accountancy/html/files
miolo20/modules/research/html/files
miolo26/html/files
miolo26/var'

for datadir in $DATADIRS; do 
  cd $FILESDIR
  echo -n "Creating $FILESDIR/$datadir ..." && \
  mkdir -p $FILESDIR/$datadir && rmdir $FILESDIR/$datadir && echo " OK."
  echo -n "Moving $ROOTDIR/$datadir to $FILESDIR ..." && \
  cp -a $ROOTDIR/$datadir $FILESDIR/$datadir && \
  rm -rf $ROOTDIR/$datadir && \
  ln -s $FILESDIR/$datadir $ROOTDIR/$datadir && echo " OK."
  #echo -n "Fixing permissions..." && \
  #chown -R www-data:www-data $FILESDIR/$datadir && echo " OK."
done
