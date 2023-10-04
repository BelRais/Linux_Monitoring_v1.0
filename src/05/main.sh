#!/bin/bash
start_time=$(date +%s.%N)
start_time_s=$(echo "scale=1; $start_time" | bc)
chmod 777 main.sh

#/var/log/
if [ $# -ne 1 ]; then
    echo "Не верный ввод параметров. При запуске $0. Пожалуйста введите 1 путь."
    exit 0
fi
if [[ $(find "$1" 2>/dev/null) ]]; then
    if [[ $1 =~ /$ ]]; then
        export path="$1"
    else
        echo "Не забываем по условию задания знак / в конце адреса"
        exit 1
    fi
else
    echo "Введите существующий путь"
    exit 1
fi

#-----------for_1_step------------#
total_folders=0
total_folders=$(find $path -type d | wc -l)

#-----------for_2_step------------#

#top_5=$(du -h --max-depth=1 $path | sort -hr | head -n 5 | awk '// {count++; printf("%d - %s, %s\n",count, $2, $1)}')
top_5=$(du -h --max-depth=1 $path | sort -hr | head -n 5 | awk '// {count++; unit=$1; value=$1;
if ($1 ~/[0-9]+[M]/) {unit="MB"; value=$1} 
else if ($1 ~/[0-9]+[K]/) {unit="KB"; value=$1}
else if ($1 ~/[0-9]+[G]/) {unit="GB"; value=$1}
else if ($1 ~/[0-9]+[T]/) {unit="TB"; value=$1}
else if ($1 ~/[0-9]+[P]/) {unit="PB"; value=$1}
else if ($1 ~/[0-9]+[E]/) {unit="EB"; value=$1}
else if ($1 ~/[0-9]+[Z]/) {unit="ZB"; value=$1}
else if ($1 ~/[0-9]+[Y]/) {unit="YB"; value=$1}
printf("%d - %s, %.0f %s\n", count, $2, value, unit)}')

#-----------for_3_step------------#

total_file=$(find $path -type f | wc -l)

#-----------for_4_step------------#

count_conf=$(find $path -name *.conf | wc -l)
count_txt=$(find $path -name *.txt | wc -l)
count_exe=$(find $path -type f -executable | wc -l)
count_log=$(find $path -name *.log | wc -l)
count_tgz=$(find $path -name *.zip \
-o -name *.rar \
-o -name *.tar \
-o -name *.tar.gz \
-o -name *.tar.bz2 \
-o -name *.7z \
-o -name *.iso \
-o -name *.cab \
-o -name *.gz \
-o -name *.bz2 | wc -l)
count_simv=$(find $path -type l | wc -l)

#-----------for_5_step------------#

top_10_file=$(find $path -type f -exec du -h {} + | sort -hr | head -n 10 | awk '// {count++; unit=$1; value=$1;
if ($1 ~/[0-9]+[M]/) {unit="MB"; value=$1} 
else if ($1 ~/[0-9]+[K]/) {unit="KB"; value=$1}
else if ($1 ~/[0-9]+[G]/) {unit="GB"; value=$1}
else if ($1 ~/[0-9]+[T]/) {unit="TB"; value=$1}
else if ($1 ~/[0-9]+[P]/) {unit="PB"; value=$1}
else if ($1 ~/[0-9]+[E]/) {unit="EB"; value=$1}
else if ($1 ~/[0-9]+[Z]/) {unit="ZB"; value=$1}
else if ($1 ~/[0-9]+[Y]/) {unit="YB"; value=$1}
split($2,exts,".");
ext = exts[length(exts)];
printf("%d - %s, %.0f %s, %s\n", count, $2, value, unit, ext)}')

#-----------for_6_step------------#

top_10_exe=$(find $path -type f -executable -exec du -h {} + | sort -hr | head -n 10 | awk '// {count++; unit=$1; value=$1;
if ($1 ~/[0-9]+[M]/) {unit="MB"; value=$1} 
else if ($1 ~/[0-9]+[K]/) {unit="KB"; value=$1}
else if ($1 ~/[0-9]+[G]/) {unit="GB"; value=$1}
else if ($1 ~/[0-9]+[T]/) {unit="TB"; value=$1}
else if ($1 ~/[0-9]+[P]/) {unit="PB"; value=$1}
else if ($1 ~/[0-9]+[E]/) {unit="EB"; value=$1}
else if ($1 ~/[0-9]+[Z]/) {unit="ZB"; value=$1}
else if ($1 ~/[0-9]+[Y]/) {unit="YB"; value=$1}
printf("%d - %s, %.0f %s, ", count, $2, value, unit)}')

top_10_exe_part_2=$(find $path -type f -executable -exec md5sum {} + | sort -hr | head -n 10 | awk '// {
printf("%s\n", $1)}')

#-----------echo_part-------------#
echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):
$top_5"
echo "Total number of files = $total_file"
echo "Number of:
Configuration files (with the .conf extension) = $count_conf
Text files = $count_txt
Executable files = $count_exe
Log files (with the extension .log) = $count_log
Archive files = $count_tgz
Symbolic links = $count_simv"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):
$top_10_file"
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)
${top_10_exe}${top_10_exe_part_2}"
end_time=$(date +%s.%N)
end_time_s=$(echo "scale=1; $end_time" | bc)
runtime=$(echo "($end_time_s - $start_time_s)" | bc) 
runtime_s=$(echo $runtime | sed 's/\./\,/g' | awk '// {printf("%.1f\n", $1)}')
echo "Script execution time (in seconds) = $runtime_s"