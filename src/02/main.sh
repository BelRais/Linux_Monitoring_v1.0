#!/bin/bash

chmod 777 parametrs.sh
./parametrs.sh
echo -n "Записать данные в файл? (ответить Y/N) "
read kra
if [[ "$kra" = "y" || "$kra" = "Y" ]]; then
   file_name=$(date +"%d_%m_%y_%H_%M_%S".status)
   ./parametrs.sh > $file_name
   echo "Файл записан как $file_name"
fi

