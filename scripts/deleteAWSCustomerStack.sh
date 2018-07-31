#!/bin/bash
set -e
set -u

## LOAD required customer related vars
SCRIPT_DIR=$( dirname ${BASH_SOURCE[0]} )
. ${SCRIPT_DIR}/../vars.sh


aws cloudformation delete-stack --stack-name "${CUSTOMER_NAME}Stack" 

