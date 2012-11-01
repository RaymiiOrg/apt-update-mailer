#!/bin/bash
#Copyright (c) 2012 Remy van Elst
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


if [ -f /etc/lsb-release ]; then
    TYPE="UBUNTU"
elif [ -f /etc/debian_version ]; then
    TYPE="DEBIAN"
fi

case ${TYPE} in
    "UBUNTU")
        VERSION=`grep "DISTRIB_CODENAME" /etc/lsb-release | awk -F = '{ print $2 }'`   
        ;;
    "DEBIAN")
        VERSION="Debian `cat /etc/debian_version`"
        ;;    
esac


HOSTNAME=`hostname`
EMAIL="you@yourdomain.com"
SUBJECT="Updates for host ${HOSTNAME}"
DATE=`date +%d.%m.%Y`
AVAIL_UPD=`apt-get -s upgrade | awk '/[0-9]+ upgraded,/ {print $1}'`

function mailupdates {

echo -e "--- Updates for host: ${HOSTNAME} ---"
echo -e "Date: ${DATE} \n\n"

echo -n "Total updates available: "
apt-get -s upgrade | awk '/[0-9]+ upgraded,/ {print $1}'
echo -e "\n\n"

for i in `aptitude search ~U | cut -c 5- | awk '{ print $1  }'`; do 
    echo "-- Package: ${i} --"
    apt-cache policy ${i} | grep 'Installed\|Candidate'
    if [ $TYPE="UBUNTU" ]; then
        echo "Package Information: http://packages.ubuntu.com/${VERSION}/${i}"
    fi
    echo -e "-- End package ${i} --\n"
done

}


if [[ ${AVAIL_UPD} == 0 ]]; then
    #echo "No updates available for host $HOSTNAME on date ${DATE}" | mail -s "${SUBJECT}" ${EMAIL}
    sleep 1
else
    mailupdates | mail -s "${SUBJECT}" ${EMAIL}
fi
