#!/bin/bash

inet=$1
if [ "$inet" == "" ]; then
    inet=eth0
fi


profile=$2
if [ "$profile" == "" ]; then
    profile=test
fi

tmp=$3
if [ "$tmp" == "" ]; then
    tmp=java
fi

jmx=$4
if [ "$jmx" == "" ]; then
    jmx=128m
fi

ver=$5
if [ "$ver" == "" ]; then
    ver=1.0.0
fi

logip=$6
if [ "$logip" == "" ]; then
    logip=172.16.45.3:5000
fi

function addNewApp()
{
 allmake add app=$1 ver=$ver profile=$profile ports="$2" template=$tmp inet=$inet jmx=$4 logIpAddress=$logip
}

mkdir -p 01-provider 02-consumer
pushd 01-provider
        addNewApp vp-traffic-monetisation-provider "10010 23010 33010" "" 128m
        addNewApp cmos-security-provider "8095 23010 33010" "" 128m
popd
pushd 02-consumer
        addNewApp vp-traffic-monetisation-consumer "10020 23020 33020" "" 128m
popd

