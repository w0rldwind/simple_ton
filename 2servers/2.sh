#Настройки
msig=
depool=
sign=msig.keys.json

#Проверка ожидающих подтверждения транзакций
txs=$(./tonos-cli run $msig getTransactions {} --abi SafeMultisigWallet.abi.json)
checkconn=$(echo $txs | grep -o "Succeeded")

if [ "$checkconn" = 'Succeeded' ]
then
 #Парсим ответ. Используем id транзакций, адрес получателя и сумму
 tx=$(echo $txs | grep -oP '(?<="id": ")[^"]*')
 dest=$(echo "$txs" | grep -oP '(?<="dest": ")[^"]*')
 value=$(echo "$txs" | grep -oP '(?<="value": ")[^"]*')

 txa=($tx)
 txq=$(echo ${#txa[@]})

 desta=($dest)
 valuea=($value)

 #Цикл проверки транзакций
 for ((i=1; i<=txq; i++)); do
  #echo tx$i
  #номер транзакции
  let "n=0+$i"
  #строка 0+
  let "q=-1+$i"

  #Конвертирование hex в dex
  valuea[$q]=$(printf '%x' ${valuea[$q]})
  valuea[$q]=$((16#${valuea[$q]}))
  valuea[$q]=$(bc -l <<< "scale=2; ${valuea[$q]}/1000000000")

  #Подтверждение транзакции, если она на адрес депула
  if [ "$depool" = "${desta[$q]}" ]
  then
   conf=$(./tonos-cli call $msig confirmTransaction '{"transactionId":"'${txa[$q]}'"}' --abi SafeMultisigWallet.abi.json --sign $sign)
   check=$(echo $conf | grep -o "Succeeded")
   if [ "$check" = 'Succeeded' ]
   then
    echo $(date +'%d.%m.%Y %H:%M:%S') Транзакция "${txa[$q]}" на адрес депула, "${valuea[$q]}" TON... Выполнена! >> confirm.log
   else
    echo $(date +'%d.%m.%Y %H:%M:%S') Транзакция "${txa[$q]}" на адрес депула, "${valuea[$q]}" TON... Ошибка! см. errors.log >> confirm.log
    echo $(date +'%d.%m.%Y %H:%M:%S') $conf >> errors.log
   fi
  fi

 done
else
 echo $(date +'%d.%m.%Y %H:%M:%S') Ошибка Tonos-cli см. errors.log >> confirm.log
 echo $(date +'%d.%m.%Y %H:%M:%S') $txs >> errors.log
fi
