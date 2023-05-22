#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

GAMES=games.csv

GET_ID () {
  team_id=$($PSQL "select team_id from teams where name='$1';")
  if [[ -z $team_id ]]
  then
    result=$($PSQL "insert into teams(name) values('$1');")
    team_id=$($PSQL "select team_id from teams where name='$1';")
  fi
  echo $team_id
} 

echo $($PSQL "truncate games, teams;")

cat $GAMES | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $year != year ]]
  then
    winner_id=$(GET_ID "$winner")
    opponent_id=$(GET_ID "$opponent")
    
    echo $winner_id
    echo $opponent_id

    echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);")
  fi
done