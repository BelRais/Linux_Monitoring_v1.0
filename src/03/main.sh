#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Не верный ввод параметров. При запуске $0. Пожалуйста введите 4 числа."
    exit 0
fi
if [[ ($1 = $2) || ($3 = $4) ]]; then
    echo "Пожалуйста не используйте один и тот же цвет для фона и шрифта."
    exit 0
fi

#----------color_map----------#

white_text="\033[37m"
white_fon="\033[47m"

red_text="\033[31m"
red_fon="\033[41m"

green_text="\033[32m"
green_fon="\033[42m"

blue_text="\033[34m"
blue_fon="\033[44m"

purple_text="\033[35m"
purple_fon="\033[45m"

black_text="\033[30m"
black_fon="\033[40m"
#----------number_decoder_for_color----------#

# export тут нужен для команды ENVIRON, чтобы он видел в авк данную переменную
# да, можно было через awk -v, но я для себя сделал через 2 метода на будущее.

case $1 in
    1 ) export label_fon=$white_fon;;
    2 ) export label_fon=$red_fon;;
    3 ) export label_fon=$green_fon;;
    4 ) export label_fon=$blue_fon;;
    5 ) export label_fon=$purple_fon;;
    6 ) export label_fon=$black_fon;;
esac

case $2 in
    1 ) export label_text=$white_text;;
    2 ) export label_text=$red_text;;
    3 ) export label_text=$green_text;;
    4 ) export label_text=$blue_text;;
    5 ) export label_text=$purple_text;;
    6 ) export label_text=$black_text;;
esac

case $3 in
    1 ) export rezult_fon=$white_fon;;
    2 ) export rezult_fon=$red_fon;;
    3 ) export rezult_fon=$green_fon;;
    4 ) export rezult_fon=$blue_fon;;
    5 ) export rezult_fon=$purple_fon;;
    6 ) export rezult_fon=$black_fon;;
esac

case $4 in
    1 ) export rezult_text=$white_text;;
    2 ) export rezult_text=$red_text;;
    3 ) export rezult_text=$green_text;;
    4 ) export rezult_text=$blue_text;;
    5 ) export rezult_text=$purple_text;;
    6 ) export rezult_text=$black_text;;
esac

echo -e "${label_fon}${label_text}HOSTNAME = ${rezult_fon}${rezult_text}$HOSTNAME\033[0m"
echo -e "${label_fon}${label_text}TIMEZONE = ${rezult_fon}${rezult_text}$(cat /etc/timezone)\033[0m"
echo -e "${label_fon}${label_text}USER = ${rezult_fon}${rezult_text}$USER\033[0m"
echo -e "${label_fon}${label_text}OS = ${rezult_fon}${rezult_text}$(lsb_release -d | awk -F '\t' '{print $2}')\033[0m"
echo -e "${label_fon}${label_text}DATE = ${rezult_fon}${rezult_text}$(date +'%d %B %Y %X')\033[0m" #data -- help
echo -e "${label_fon}${label_text}UPTIME = ${rezult_fon}${rezult_text}$(uptime -p)\033[0m"
echo -e "${label_fon}${label_text}UPTIME_SEC = ${rezult_fon}${rezult_text}$(uptime -p | awk '/^up / {print ($2*60+$4)*60}')\033[0m"
echo -e "$(ifconfig | awk -v rezult_fon="$rezult_fon" -v rezult_text="$rezult_text" -v label_fon="$label_fon" -v label_text=$label_text '/inet / {mask_count++; printf("%s%sIP_%d = %s%s%s\033[0m\n",label_fon,label_text,mask_count,rezult_fon,rezult_text,$2)}')"
echo -e "$(ifconfig | awk '/netmask/ {mask_count++; printf("%s%sMASK_%d = %s%s%s\033[0m\n",ENVIRON["label_fon"],ENVIRON["label_text"],mask_count,ENVIRON["rezult_fon"],ENVIRON["rezult_text"],$4)}')"
echo -e "${label_fon}${label_text}GATEWAY = ${rezult_fon}${rezult_text}$(ip route | awk '/default via / {print $3}')\033[0m"
echo -e "${label_fon}${label_text}RAM_TOTAL = ${rezult_fon}${rezult_text}$(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $2/1024/1024)}')\033[0m"
echo -e "${label_fon}${label_text}RAM_USED = ${rezult_fon}${rezult_text}$(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $3/1024/1024)}')\033[0m"
echo -e "${label_fon}${label_text}RAM_FREE = ${rezult_fon}${rezult_text}$(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $4/1024/1024)}')\033[0m"
echo -e "${label_fon}${label_text}SPACE_ROOT = ${rezult_fon}${rezult_text}$(df / | awk 'NR==2 {printf("%.3f MB", $2/1024)}')\033[0m"
echo -e "${label_fon}${label_text}SPACE_ROOT_USED = ${rezult_fon}${rezult_text}$(df / | awk 'NR==2 {printf("%.3f MB", $3/1024)}')\033[0m"
echo -e "${label_fon}${label_text}SPACE_ROOT_FREE = ${rezult_fon}${rezult_text}$(df / | awk 'NR==2 {printf("%.3f MB", $4/1024)}')\033[0m"

#chmod 777 parametrs.sh
#./parametrs.sh
#echo -e "${label_fon}${green_text}hieee"
#echo -e "\033[31mhieee\033[0m"