#!/bin/bash

file="$1"
id=$(echo $file | grep -o '[1-2]*\d\d\d')
prefix=${id}_coast
name=$(echo $file | grep -o '[a-zæøåA-ZÆØÅ]*_UTM\d\d');
if [ ${#id} -lt 4 ]
  then 
    id="0$id";
fi

unzip -uq $file "${id}_N50_Arealdekke.sos"
sosi2osm "${id}_N50_Arealdekke.sos" kyst.lua ${prefix}.osm
python waySimplifyer.py ${prefix}.osm ${prefix}.osm
python emptyRemover.py ${prefix}.osm ${prefix}.osm
python coastCorrector.py ${prefix}.osm ${prefix}.osm
python removeExcessiveNodes.py ${prefix}.osm ${prefix}.osm .1
python splitterOsm.py ${prefix}.osm ${prefix}_part --keepAdjacentWays
zip -q "/Users/torsteinibo/Google Drive/TopoImport/${id}_${name}.zip" ${prefix}*.osm
rm ${prefix}.osm
rm ${prefix}*.osm
rm "${id}_N50_Arealdekke.sos"