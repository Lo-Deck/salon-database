#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~New Salon In Town~~~"

MAIN_MENU () {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;") 
  echo "$SERVICES_LIST" | while IFS="|" read SERVICE_ID SERVICE_NAME;
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  if [[ -z $SERVICE_ID_SELECTED || ! $SERVICE_ID_SELECTED =~ ^[1-4]$ ]]
  then
    MAIN_MENU "Ce n'est pas un numéro de service valide."
  else
    SERVICE_MENU $SERVICE_ID_SELECTED "$SERVICE_NAME"
  fi



}

SERVICE_MENU () {

    SERVICE_ID=$1
    # SERVICE_NAME=$2

    echo -e "\nPlease enter your phone number"
    read CUSTOMER_PHONE

    if [[ $CUSTOMER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]] 
    then

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nCreate New Customer"
        echo -e "\nEnter your name"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      fi

    else
      MAIN_MENU "Wrong phone number use format (555-555-5555)"
    fi  


    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

    echo -e "\nPlease enter a date for your appointment format(10:30)"

    read SERVICE_TIME

    if [[ $SERVICE_TIME =~ ^[0-9]{2}:[0-9]{2}$ ]]
    then
      INSERT_APPOINT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
    else
      MAIN_MENU "Please enter a date for your appointment format(10:30)"
    fi

    # SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

    echo -e "\nI have put you down for a '$SERVICE_NAME' at '$SERVICE_TIME', '$SERVICE_NAME'."



}


  # do
  #   echo -e "\nChoose your new haircut"
  #   echo -e "\n1) Haircut Man\n2) Haircut Woman\n3) Haircut Kid\n4) Exit\n"
  #   read SERVICE_CHOICE
  #   if [[ -z $SERVICE_CHOICE || ! $SERVICE_CHOICE =~ ^[1-4]$ ]]
  #   then
  #     MAIN_MENU "Make a choice. Please enter 1, 2, 3"
  #   else
  #   fi  
  # done
  

  # DISPLAY_MENU

  # read SERVICE_ID_SELECTED

  # case $SERVICE_ID_SELECTED in
  #   1)$SERVICE_ID_SELECTED;;
  #   2)$SERVICE_ID_SELECTED;;
  #   3)$SERVICE_ID_SELECTED;;
  #   *)MAIN_MENU "Invalid choice. Please enter 1, 2, 3";; 
  # esac


  # read SERVICE_CHOICE
  # if [[ -z $SERVICE_CHOICE || ! $SERVICE_CHOICE =~ ^[1-4]$ ]]
  # then
  #   MAIN_MENU "Make a choice. Please enter 1, 2, 3"
  # else
  # fi  
  

  #   # Customer_name = OK => Create appointment

  #   CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

  #   echo -e "\nPlease enter a date for your appointment format(10:30)"

  #   read SERVICE_TIME

  #   if [[ $SERVICE_TIME =~ ^[0-9]{2}:[0-9]{2}$ ]]
  #   then
  #     $($PSQL "INSERT INTO appointments(customer_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_TIME')")
  #   else
  #     MAIN_MENU "Please enter a date for your appointment format(10:30)"
  #   fi

  #   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

  #   echo -e "/nI have put you down for a '$SERVICE_NAME' at '$SERVICE_TIME', '$SERVICE_NAME'."






# DISPLAY_MENU() {

#   if [[ $1 ]]
#   then
#     echo -e "\n$1"
#   fi

#   SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;") 
#   echo "$SERVICES_LIST" | while IFS="|" read SERVICE_ID SERVICE_NAME;
#   do
#     echo "$SERVICE_ID) $SERVICE_NAME"
#   done
#   echo -e "4) exit"
# }

# WOMEN() {

# }

# KID() {

# }

# EXIT() {
#   echo -e "\nThank you for visiting New Salon In Town. Goodbye!\n"
#   exit 0
# }





MAIN_MENU
