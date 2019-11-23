
#!/bin/bash
#------------------------------------------echo
 
read -t 20 -p "name:" name
echo -e "\n"
 
#------------------------------------------hanshu
 
 
#------------------------------------------color
 
function echo_color(){
   if [ $1 == "hei" ]; then
      echo -e "\033[30;41m$2\033[0m"
   elif [ $1 == "lv" ]; then
      echo -e "\033[32;41m$2\033[0m"
   elif [ $1 == "huang" ]; then
      echo -e "\033[33;41m$2\033[0m"
   elif [ $1 == "lan" ]; then
      echo -e "\033[34;41m$2\033[0m"
   elif [ $1 == "zi" ]; then
      echo -e "\033[35;41m$2\033[0m"
   elif [ $1 == "lan" ]; then
    echo -e "\033[36;41m$2\033[0m"
   elif [ $1 == "bai" ]; then
      echo -e "\033[37;41m$2\033[0m"
 
   elif [ $1 == "red" ]; then
      echo -e "\033[31;41m$2\033[0m"
   fi
}
 
function echo_color2(){
   case $1 in
   green)
      echo -e "\033[31;42m$2\033[0m"
     ;;
   red)
      echo -e "\033[31;43m$2\033[0m"
     ;;
   *)
      echo -e "\033[31;44m$2\033[0m"
   esac
}
 
#-------------------------------------------- 1
 
for ((a=1;a<5;a++)); do
   for ((b=a;b<5;b++)); do
      echo -ne " "
   done
   for ((c=1;c<=2*a-1;c++)); do
      echo -ne "❤"
   done
   for ((i=1;i<10;i++)); do
      echo -ne "❤"
   done
   for ((y=a;y<5;y++)); do
      echo -ne " "
   done
   for ((w=a;w<5;w++)); do
    echo -ne " "
   done
   for ((u=0;u<2*a-1;u++)); do
      echo -ne "❤"
   done
   for ((o=1;o<10;o++)); do
      echo -ne "❤"
   done
   echo
done
 
 
 
sleep 1
for((i=1;i<4;i++)); do
   for((j=0;j<i;j++)); do
      echo -ne " "
   done
   for((x=1;x<15;x++)); do
      echo -ne "❤"
   done
   for((y=i;y<4;y++)); do
      echo -ne "${name:0:1}"
   done
   for((w=i;w<4;w++)); do
      echo -ne ""
   done
   for((u=0;u<2*i-1;u++)); do
      echo -ne "❤"
   done
   for((H=i;H<8;H++)); do
      echo -ne "❤"
   done
   for((W=i;W<7;W++)); do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
for((a=1;a<=5;a++)); do
   for((b=a;b<=4;b++)); do
      echo -ne " "
   done
   for((c=1;c<=4*a-2;c++)); do
      echo -ne " "
   done
   for((k=1;k<=4*2-(3*a-6);k++)); do
      echo -ne "❤"
   done
   for((k=1;k<=4*2-(3*a-8);k++)); do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
echo
echo
echo
#-------------------------------------------------------------------    2
 
for ((a=1 ;a<=5 ;a++)) ; do
   for((b=a ;b<5 ;b++)) ; do
      echo -ne " "
   done
   for((c=1 ;c<=2*a-1 ;c++)) ; do
      echo -ne "❤"
   done
   for ((i=1 ;i<10 ;i++)) ; do
      echo -ne "❤"
   done
   for ((y=a ;y<5 ;y++)) ; do
      echo -ne " "
   done
   for ((w=a ;w<5 ;w++)) ; do
      echo -ne " "
   done
   for ((u=0 ;u<2*a-1 ;u++)) ; do
      echo -ne "❤"
   done
   for ((o=1 ;o<10 ;o++)) ; do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
for((i=1;i<4;i++)); do
   for((j=0;j<i;j++)); do
   echo -ne " "
   done
   for((x=1;x<15;x++)); do
      echo -ne "❤"
   done
   for((y=i;y<4;y++)); do
      echo -ne "${name:1:1}"
   done
   for((w=i;w<4;w++)); do
      echo -ne ""
   done
   for((u=0;u<2*i-1;u++)); do
      echo -ne "❤"
   done
   for((H=i;H<8;H++)); do
      echo -ne "❤"
   done
   for((W=i;W<7;W++)); do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
for((a=1;a<=5;a++)); do
   for((b=a;b<=4;b++)); do
      echo -ne " "
   done
   for((c=1;c<=4*a-2;c++)); do
      echo -ne " "
   done
   for((k=1;k<=4*2-(3*a-6);k++)); do
      echo -ne "❤"
   done
   for((k=1;k<=4*2-(3*a-8);k++)); do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
echo
echo
echo
#------------------------------------------------------------------   3
for ((a=1 ;a<=5 ;a++)) ; do
   for((b=a ;b<5 ;b++)) ; do
      echo -ne " "
   done
   for((c=1 ;c<=2*a-1 ;c++)) ; do
      echo -ne "❤"
   done
   for ((i=1 ;i<10 ;i++)) ; do
      echo -ne "❤"
   done
   for ((y=a ;y<5 ;y++)) ; do
      echo -ne " "
   done
   for ((w=a ;w<5 ;w++)) ; do
      echo -ne " "
   done
   for ((u=0 ;u<2*a-1 ;u++)) ; do
      echo -ne "❤"
   done
   for ((o=1 ;o<10 ;o++)) ; do
      echo -ne "❤"
   done
  echo
done
 
sleep 1
for((i=1;i<4;i++)); do
   for((j=0;j<i;j++)); do
      echo -ne " "
   done
   for((x=1;x<15;x++)); do
      echo -ne "❤"
   done
   for((y=i;y<4;y++)); do
      echo -ne "${name:2:3}"
   done
   for((w=i;w<4;w++)); do
      echo -ne ""
   done
   for((u=0;u<2*i-1;u++)); do
      echo -ne "❤"
   done
   for((H=i;H<8;H++)); do
      echo -ne "❤"
   done
   for((W=i;W<7;W++)); do
      echo -ne "❤"
   done
   echo
done
 
sleep 1
for((a=1;a<=5;a++)); do
   for((b=a;b<=4;b++)); do
      echo -ne " "
   done
   for((c=1;c<=4*a-2;c++)); do
      echo -ne " "
   done
   for((k=1;k<=4*2-(3*a-6);k++)); do
      echo -ne "❤"
   done
   for((k=1;k<=4*2-(3*a-8);k++)); do
      echo -ne "❤"
   done
   echo
done
 
echo
echo
echo
 
echo_color2 red "  --------------------------         "
echo_color2 red "  浮世万千,吾爱有三,日月与卿         "
echo_color2 red "  日为朝,月为暮,卿为朝朝暮暮         "
echo_color2 red "  ------------ -------------         "
 
echo
echo

