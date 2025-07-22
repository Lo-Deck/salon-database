#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~New Salon In Town~~~"

MAIN_MENU () {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;") 
  echo "$SERVICES_LIST" | while IFS="|" read SERVICE_ID NAME;
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  # if [[ -z $SERVICE_ID_SELECTED || ! $SERVICE_ID_SELECTED =~ ^[0-9]$ ]]
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Ce n'est pas un numéro de service valide."
  else

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_NAME ]]
    then
      MAIN_MENU "Not available"
    else

      echo -e "\nPlease enter your phone number"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nCreate New Customer"
        echo -e "\nEnter your name"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
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

      echo -e "\nI have put you down for a '$SERVICE_NAME' at '$SERVICE_TIME', '$CUSTOMER_NAME'."

    fi
    # SERVICE_MENU $SERVICE_ID_SELECTED "$SERVICE_NAME"

  fi

}

# SERVICE_MENU () {

#     SERVICE_ID=$1
#     SERVICE_NAME=$2

#     echo -e "\nPlease enter your phone number"
#     read CUSTOMER_PHONE

    # if [[ $CUSTOMER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]] 
    # then

      # CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
      # if [[ -z $CUSTOMER_NAME ]]
      # then
      #   echo -e "\nCreate New Customer"
      #   echo -e "\nEnter your name"
      #   read CUSTOMER_NAME
      #   INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      # fi

    # else
    #   MAIN_MENU "Wrong phone number use format (555-555-5555)"
    # fi  




    # CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

    # echo -e "\nPlease enter a date for your appointment format(10:30)"

    # read SERVICE_TIME

    # if [[ $SERVICE_TIME =~ ^[0-9]{2}:[0-9]{2}$ ]]
    # then
    #   INSERT_APPOINT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
    # else
    #   MAIN_MENU "Please enter a date for your appointment format(10:30)"
    # fi

    # SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")

    # echo -e "\nI have put you down for a '$SERVICE_NAME' at '$SERVICE_TIME', '$CUSTOMER_NAME'."


# }




MAIN_MENU
