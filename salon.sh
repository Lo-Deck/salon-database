#!/bin/bash

echo -e "\n~~~New Salon In Town~~~"

MAIN_MENU () {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  echo -e "\nChoose your new haircut"

  echo -e "\n1) Haircut Man\n2) Haircut Woman\n3) Haircut Kid\n"

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1)MEN;;
    2)WOMEN;;
    3)KID;;
    4)EXIT;;
    *)MAIN_MENU "Invalid choice. Please enter 1, 2, 3";; 
  esac

  # if [[ -z $SERVICE_CHOICE ]]
  # then
  #   MAIN_MENU "Make a choice. Please enter 1, 2, 3"
  # else
  # fi  

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
        $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      fi

    else
      MAIN_MENU "Wrong phone number use format (555-555-5555)"
    fi    

    # Customer_name = OK => Create appointment

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

    echo -e "\nPlease enter a date for your appointment format(10:30)"

    read SERVICE_TIME

    if [[ $SERVICE_TIME =~ ^[0-9]{2}:[0-9]{2}$ ]]
    then
      $($PSQL "INSERT INTO appointments(customer_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_TIME')")
    else
      MAIN_MENU "Please enter a date for your appointment format(10:30)"
    fi






}

MEN() {

}

WOMEN() {

}

KID() {

}

EXIT() {
  echo -e "\nThank you for visiting New Salon In Town. Goodbye!\n"
  exit 0
}



