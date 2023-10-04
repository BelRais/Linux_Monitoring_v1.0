#!/bin/bash

#------------Подтягиваем данные с конфига------------#
source conf.conf

#------------Прооверка на количество данных------------#
if [ $# -ge 5 ]; then
    echo "Не верный ввод параметров. При запуске $#. Пожалуйста введите 4 числа или не вводите значения"
    exit 0
fi

#------------Переопределение для удобства------------#
one=$1
one_flag=$1
dva=$2
dva_flag=$2
tre=$3
tre_flag=$3
chatiri=$4
chatiri_flag=$4

#------------Если данных меньше 4 идет переопределение------------#
if [[ "$chatiri" = "" ]]; then
    chatiri=$column2_font_color
    chatiri_flag="default"
fi
if [[ "$tre" = "" ]]; then
    tre=$column2_background
    tre_flag="default"
fi
if [[ "$dva" = "" ]]; then
    dva=$column1_font_color
    dva_flag="default"
fi
if [[ "$one" = "" ]]; then
    one=$column1_background
    one_flag="default"
fi

#------------Если фон равен тексту------------#
if [[ ($one = $dva) || ($tre = $chatiri) ]]; then
    echo "Пожалуйста не используйте один и тот же цвет для фона и шрифта."
    exit 0
fi

#------------блок определения названия------------#
case $one in
    1 ) print_name_1="white";;
    2 ) print_name_1="red";;
    3 ) print_name_1="green";;
    4 ) print_name_1="blue";;
    5 ) print_name_1="purple";;
    6 ) print_name_1="black";;
esac

case $dva in
    1 ) print_name_2="white";;
    2 ) print_name_2="red";;
    3 ) print_name_2="green";;
    4 ) print_name_2="blue";;
    5 ) print_name_2="purple";;
    6 ) print_name_2="black";;
esac

case $tre in
    1 ) print_name_3="white";;
    2 ) print_name_3="red";;
    3 ) print_name_3="green";;
    4 ) print_name_3="blue";;
    5 ) print_name_3="purple";;
    6 ) print_name_3="black";;
esac

case $chatiri in
    1 ) print_name_4="white";;
    2 ) print_name_4="red";;
    3 ) print_name_4="green";;
    4 ) print_name_4="blue";;
    5 ) print_name_4="purple";;
    6 ) print_name_4="black";;
esac

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

case $one in
    1 ) export label_fon=$white_fon;;
    2 ) export label_fon=$red_fon;;
    3 ) export label_fon=$green_fon;;
    4 ) export label_fon=$blue_fon;;
    5 ) export label_fon=$purple_fon;;
    6 ) export label_fon=$black_fon;;
esac

case $dva in
    1 ) export label_text=$white_text;;
    2 ) export label_text=$red_text;;
    3 ) export label_text=$green_text;;
    4 ) export label_text=$blue_text;;
    5 ) export label_text=$purple_text;;
    6 ) export label_text=$black_text;;
esac

case $tre in
    1 ) export rezult_fon=$white_fon;;
    2 ) export rezult_fon=$red_fon;;
    3 ) export rezult_fon=$green_fon;;
    4 ) export rezult_fon=$blue_fon;;
    5 ) export rezult_fon=$purple_fon;;
    6 ) export rezult_fon=$black_fon;;
esac

case $chatiri in
    1 ) export rezult_text=$white_text;;
    2 ) export rezult_text=$red_text;;
    3 ) export rezult_text=$green_text;;
    4 ) export rezult_text=$blue_text;;
    5 ) export rezult_text=$purple_text;;
    6 ) export rezult_text=$black_text;;
esac

#------------main вывод------------#
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
echo ""
#------------последний вывод------------#
echo "Column 1 background = $one_flag ($print_name_1)"
echo "Column 1 font color = $dva_flag ($print_name_2)"
echo "Column 2 background = $tre_flag ($print_name_3)"
echo "Column 2 font color = $chatiri_flag ($print_name_4)"