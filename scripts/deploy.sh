#!/bin/bash

# simple deployment script

/usr/local/bin/puppet module install jriviere-windows_ad
/usr/local/bin/puppet module install trlinkin-domain_membership
/usr/local/bin/puppet module install puppetlabs-stdlib
/usr/local/bin/puppet module install opentable-windowsfeature

./classifier.sh
