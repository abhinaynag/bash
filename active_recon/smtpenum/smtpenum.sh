#!/bin/bash
filedir="/root/Desktop/scripts/active_recon/smtpenum/"
ifile=$filedir/usernames.txt
tip="localhost"
for usr in cat($ifile); do
	echo "VRFY" | nc -nv $tip 2>/dev/null | grep ^"250"
done
