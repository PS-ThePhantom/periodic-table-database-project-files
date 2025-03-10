if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

  #check for the element using atomic_number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    QUERY_RESULT=$($PSQL "select * from elements left join properties using(atomic_number) left join types using(type_id) where atomic_number = $1")
  else
    QUERY_RESULT=$($PSQL "select * from elements left join properties using(atomic_number) left join types using(type_id) where symbol = '$1'")

    if [[ -z $QUERY_RESULT ]]
    then
      QUERY_RESULT=$($PSQL "select * from elements left join properties using(atomic_number) left join types using(type_id) where name = '$1'")
    fi
  fi

  if [[ -z $QUERY_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    echo $QUERY_RESULT | while IFS="|" read  TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
