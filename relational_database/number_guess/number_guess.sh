#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")

if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "insert into users(username) values('$USERNAME');")
  USER_ID=$($PSQL "select user_id from users where username = '$USERNAME';")
else
  GAMES_PLAYED=$($PSQL "select count(*) from games where user_id = $USER_ID;")
  BEST_GAME=$($PSQL "select min(guesses) from games where user_id = $USER_ID;")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

NUMBER=$(( RANDOM % 1000 ))
GUESSES=0
echo -e "\nGuess the secret number between 1 and 1000:"

while [[ $NUMBER -ne $GUESS ]]
do
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  elif [[ $NUMBER -lt $GUESS ]]
  then
    echo -e "\nIt's lower than that, guess again:"
    GUESSES=$(( GUESSES + 1 ))
  elif [[ $NUMBER -gt $GUESS ]]
  then
    echo -e "\nIt's higher than that, guess again:"
    GUESSES=$(( GUESSES + 1 ))
  else
    GUESSES=$(( GUESSES + 1 ))
    echo -e "\nYou guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!"
    INSERT_GAME_RESULT=$($PSQL "insert into games(guesses, user_id) values($GUESSES, $USER_ID);")
  fi
done