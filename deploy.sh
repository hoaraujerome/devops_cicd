#!/bin/bash

verifyLastCommandSuccess() {
  if [ $? -ne 0 ] 
  then 
    echo "Error" 
    exit 1  
  fi
}

terraform fmt
verifyLastCommandSuccess

terraform validate
verifyLastCommandSuccess

terraform apply