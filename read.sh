clear
echo --------------仕事を始めます------------------
echo 終了方法：左上のバツを押せば絶対消える
echo
echo 使用方法：画面に出てくる通りに入力する
echo 間違えた：何も入力しないでエンターを押せばok
echo 注意　　：パターンの選択はカルテ読込後に行う事
echo
echo どんなボタンを押してもPCは壊れないので安心
echo よくわからなかったらバツ押せば大丈夫
echo 不明点はrorensu2236@gmail.comまで
echo --------------------------------------------
allCount=0
allMai=0
while :
do
echo -n カルテ番号：
read num
if [ "$num" = "" ]; then
   clear
   continue
fi
if [ "$num" = "end" ]; then
  break
fi

echo -n 苗字：
read firstName
if [ "$firstName" = "" ]; then
   clear
   continue
fi

echo -n ペットの名前：
read secondName
if [ "$secondName" = "" ]; then
   clear
   continue
fi

echo -n マスターシート日付：
read day
if [ "$day" = "" ]; then
   clear
   continue
fi

echo -n カルテ枚数：
read mai
if [ "$mai" = "" ]; then
   clear
   continue
fi

echo -n 最終来院日：
read final
if [ "$final" = "" ]; then
   clear
   continue
fi

echo ———パターンを選んでください———
echo 1 通常 同意書
echo 2 通常 病理   同意書
echo 3 その他のパターン
echo ————————————————————————
echo -n パターン：
read pt
if [ "$pt" = "" ]; then
   clear
   continue
fi


file=$(ls |find *.pdf| wc -l)
pdf=".pdf"
dou="同意書・その他"
byou="病理・手術・麻酔"
echo -e "$mai\t1\t$final\t\t$num $firstName $secondName $day" | pbcopy
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
   if [ $file = 2 ]; then
      echo -e "$mai\t1\t$final\t\t$num $firstName $secondName $day\t$file" | pbcopy
   fi
   for (( i = 2 ; i < $file ; i++ ))
   do
      qlmanage -p 00$i.pdf "$@" >& /dev/null&
      clear
      echo ------------------------------
      echo 00$i.pdfのファイル名を変更します
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
      before=00$i.pdf
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
mv *.pdf "$num $firstName $secondName"
cd "$num $firstName $secondName"
allCount=$(expr $allCount + 1)
allMai=$(expr $allMai + $mai)
clear
echo —————以下のファイルが完成しました—————
ls -F | grep -v /
cd ../
echo ————————————————————————————————————
echo 操作方法　
echo 【終了するなら end と入力】
echo 【間違えた時は何も入力しないでエンター】
echo " "
done
clear
echo ----------------スコア-----------------
echo カルテ数：$allCount
echo 枚数   ：$allMai
echo お疲れ様でした
echo --------------------------------------
read
killall Terminal
