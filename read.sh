rm .a
cd ~/Desktop/カルテ
clear
manu(){
  echo --------------仕事を始めます------------------
  echo 終了方法：左上のバツを押せば絶対消えます
  echo
  echo 使用方法：画面に出てくる通りに入力する
  echo 間違えた：何も入力せずエンターで1つ前に戻る
  echo 注意　　：カルテ読込後に行う事
  echo
}
manu

manua(){
  clear
  echo ----------------マニュアル--------------------
  echo 終了方法：左上のバツを押せば絶対消えます
  echo
  echo 使用方法：画面に出てくる通りに入力します
  echo 
  echo 間違えた：何も入力せずエンターで1つ前に戻る
  echo 
  echo 注意　　：カルテを全て読み込んだ後に行う事
  echo 
  echo 表示が変：日本語を消すとたまに文字が残ります
  echo 実際には消えているのでそのまま入力して下さい
  echo 
  echo 作業後　：エクセルに貼り付ける文が完成してます
  echo 
  echo 連絡先　rorensu2236@gmail.com
  echo ----------------------------------------------
  echo "　　　　【　エンターを押すと閉じます　】　　　　"
  read waitingnow
  clear
  about
}

about(){
  now="1"
  echo ------------------ 操作方法 ------------------
  echo 【エンターキー:１つ前に戻る】
  echo 【end   　　　:終了する】
  echo 【status　　　:現在の状況を見る】
  echo 【manual　　　:マニュアルを表示します】
  echo ""
}

status(){
  echo ""
  echo ""
  echo --------------------------
  date
  echo 読み込み枚数：$allMai
  echo カルテ数：$allCount
  echo --------------------------
  read waiting
  clear
  about
}

allCount=0
allMai=0
now=1
excell=`date +%Y.%m.%d`
while : 
do
about
  while : 
  do
    case "$now" in
      "1" ) 
      echo -n カルテ番号：
      read num
      if [ "$num" = "" ]; then
        now="1"
        clear
        about
      else
        now="2"
      fi
      if [ "$num" = "end" ]; then
        break
      fi

      if [ "$num" = "status" ]; then
        status
        now="1"
      fi
      if [ "$num" = "manual" ]; then
        manua
        now="1"
      fi
      ;;
      
      "2" ) 
      echo -n 苗字：
      read firstName
      if [ "$firstName" = "" ]; then
        now="1"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="3"
      fi
      ;;

      "3" ) 
      echo -n ペットの名前：
      read secondName
      if [ "$secondName" = "" ]; then
        now="2"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="4"
      fi
      ;;
      
      "4" )
      echo -n マスターシート日付：
      read day
      if [ "$day" = "" ]; then
        now="3"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="5"
      fi
      ;;
      
      "5" ) 
      echo -n カルテ枚数：
      read mai
      if [ "$mai" = "" ]; then
        now="4"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="6"
      fi
      ;;
      
      "6" ) 
      echo -n 最終来院日：
      read final
      if [ "$final" = "" ]; then
        now="5"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="7"
      fi
      ;;
      
      "7" ) 
      echo ———パターンを選んでください———
      echo 1 通常 同意書
      echo 2 通常 病理   同意書
      echo 3 その他のパターン
      echo ————————————————————————
      echo -n パターン：
      read pt
      if [ "$pt" = "" ]; then
        now="6"
        echo "【       ↓  ↓  ↓  打ち直します  ↓  ↓  ↓     】"
      else
        now="8"
      fi
      ;;
      
      "8" ) break ;;
    esac
  done


file=$(ls |find *.pdf| wc -l)
pdf=".pdf"
dou=" 同意書・その他"
byou="病理・手術・麻酔"

printf "%s\t%s %s %s 同意書・その他\t%s\t1\t%s\n" $num $firstName $secondName $day $mai $final | pbcopy
echo -e "$num\t$firstName $secondName $day ~同意書・その他\t$mai\t1\t$final" >> .a
cat .a |pbcopy
mv 001.pdf "$num $firstName $secondName $day$pdf"
if [ $pt = 1 ]; then
  echo “通常　　同意書　　で処理します”
  mv 002.pdf "$num $firstName $secondName $dou$pdf"
elif [ $pt = 2 ]; then
  echo ”通常　　病理　　同意書　で処理します”
  mv 002.pdf "$num $firstName $secondName $byou$pdf"
  mv 003.pdf "$num $firstName $secondName $dou$pdf"
else
 file=$(expr $file + 1)
 for (( i = 2 ; i < $file ; i++ ))
 do
   if [ $i -gt 9 ] ;then
    qlmanage -p 0$i.pdf "$@" >& /dev/null&
  else
    qlmanage -p 00$i.pdf "$@" >& /dev/null&
  fi
  clear
  echo ------------------------------
  if [ $i -gt 9 ] ;then
    echo 0$i.pdfのファイル名を変更します
  else
    echo 00$i.pdfのファイル名を変更します
  fi
  echo 以下に入力してください
  echo ------------------------------
  echo -n $num $firstName $secondName
  read input
  killall qlmanage
  if [ "$input" = "" ]; then
    echo 再入力
    i=$i-1
    continue
  fi
  if [ $i -gt 9 ] ;then
    before=0$i.pdf
  else
    before=00$i.pdf
  fi
  echo " "
  echo " "
  echo " "
  echo " "
  echo " "
  echo ----------------------------
  echo このファイル名で良いですか？
  echo ----------------------------
  echo " "
  echo "$num $firstName $secondName $input$pdf"
  echo " "
  echo OK=エンター
  echo NG=他のボタンを押してから エンター
  read flg
  if [ "$flg" = "" ]; then
    mv $before "$num $firstName $secondName $input$pdf"
  else
   i=$i-1
   continue
 fi
done
fi
mkdir "$num $firstName $secondName"
mv $num*.pdf "$num $firstName $secondName"
cd "$num $firstName $secondName"
allCount=$(expr $allCount + 1)
allMai=$(expr $allMai + $mai)
clear
echo "————— $num $firstName $secondName が完成—————"
ls -F | grep -v /
cd ../
echo ————————————————————————————————————
done
clear
echo ----------------スコア-----------------
echo カルテ数：$allCount
echo 枚数   ：$allMai
echo お疲れ様でした
echo --------------------------------------
read
killall Terminal
