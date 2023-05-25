PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="select atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, type, atomic_mass from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number = $1;"
else
  QUERY="select atomic_number, symbol, name, melting_point_celsius, boiling_point_celsius, type, atomic_mass from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol = '$1' or name = '$1';"
fi
RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME MELTING_POINT BOILING_POINT TYPE ATOMIC_MASS <<< $RESULT
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
