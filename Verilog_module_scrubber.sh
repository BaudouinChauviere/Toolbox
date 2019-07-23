#!/bin/sh

# Script not used anymore but kept because it is interesting 

file_name=`basename $1`
#set $file_name = `basename $1 _top.v` 
temp="config_${file_name}"
tmp='var.tmp'
dest=`echo $temp | sed -r "s/_top.v/.cfg/"`
dest_uniq=`echo $temp | sed -r "s/_top.v/_unique_bloc.cfg/"`

#MIB
grep "(" $1 | sed '/^\./d' | sed -r "s/^(module \w*|\w*).*/\1/g" | sed "s/module //g" | sed '1d' | sed -r '2,$s/^/ /g' > $dest
#grep "(" $1 | sed -r "s/^(module \w*|\w*).*/\1/g" | sed "s/module //g" | sed '1d' | sed -r '2,$s/^/ /g' > $dest

##echo $tmp
#unique names
grep "(" $1 | sed '/^\./d' | sed -r "s/^(module \w*|\w*).*/\1/g" | sed "s/module //g" | sed '1d' | sed -r '2,$s/^/ /g' | sed 's/$/ \\/g' > $tmp
uniq $tmp > $dest_uniq
