#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

while :
do
  SERVICES=$($PSQL "select service_id, name from services order by service_id;")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_NAME ]]
  then
    echo -e "\n\I could not find that service. What would you like today?\n"
    continue
  fi

  echo "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
  else
    CUSTOMER_NAME=$($PSQL "select name from customers where customer_id = $CUSTOMER_ID;")
  fi

  echo "What time would you like your appointment to be at,$CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_TIME_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  echo "I have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g' ) at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g' )."
  break
done
