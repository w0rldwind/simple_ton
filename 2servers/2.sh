#!/bin/bash
#Настройки
msig=
depool=
sign=msig.keys.json

#Проверка соединения с фронтом
txs=$(./tonos-cli run $msig getTransactions {} --abi SafeMultisigWallet.abi.json)
checkconn=$(echo $txs | grep -o "Succeeded")

if [ "$checkconn" = 'Succeeded' ]
then
  #Проверка ожидающих подтверждения транзакций
  checktx=$(echo $txs | grep -o "id")
  if [ "$checktx" = 'id' ]
  then  
    #Парсим ответ. Используем id транзакций, адрес получателя и сумму
    tx=$(echo $txs | grep -oP '(?<="id": ")[^"]*')
    dest=$(echo "$txs" | grep -oP '(?<="dest": ")[^"]*')
    value=$(echo "$txs" | grep -oP '(?<="value": ")[^"]*')
    txq=$(echo ${#tx[@]})

    #Цикл проверки транзакций
    for ((i=1; i<=txq; i++)); do
      #Номер транзакции
      let "n=0+$i"
      #Строка 0+
      let "q=-1+$i"

      #Конвертирование hex в dex
      value[$q]=$(printf '%x' ${value[$q]})
      value[$q]=$((16#${value[$q]}))
      value[$q]=$(bc -l <<< "scale=2; ${value[$q]}/1000000000")

      #Подтверждение транзакции, если она на адрес депула
      if [ "$depool" = "${dest[$q]}" ]
      then
        conf=$(./tonos-cli call $msig confirmTransaction '{"transactionId":"'${tx[$q]}'"}' --abi SafeMultisigWallet.abi.json --sign $sign)
        check=$(echo $conf | grep -o "Succeeded")
        if [ "$check" = 'Succeeded' ]
        then
          echo $(date +'%d.%m.%Y %H:%M:%S') Транзакция "${tx[$q]}" на адрес депула, "${value[$q]}" TON... Выполнена! >> confirms.log
        else
          echo $(date +'%d.%m.%Y %H:%M:%S') Транзакция "${tx[$q]}" на адрес депула, "${value[$q]}" TON... Ошибка! см. errors.log >> confirms.log
          echo $(date +'%d.%m.%Y %H:%M:%S') $conf >> errors.log
        fi
      fi
    done
  fi
else
  echo $(date +'%d.%m.%Y %H:%M:%S') Ошибка Tonos-cli см. errors.log >> confirms.log
  echo $(date +'%d.%m.%Y %H:%M:%S') $txs >> errors.log
fi
