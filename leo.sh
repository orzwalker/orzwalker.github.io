#!/bin/bash
current_path=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd current_path
git add .
git commit -m "auto commit"
git push origin master 
echo "push successful"

