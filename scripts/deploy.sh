#!/bin/bash

# simple deployment script

/usr/local/bin/puppet module install puppetlabs-stdlib

./classifier.sh
