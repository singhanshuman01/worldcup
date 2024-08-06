#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "truncate teams,games"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  if [[ $WINNER != "winner" ]] #leave first row
  then 

    TEAM1=$($PSQL "select name from teams where name='$WINNER'") #check if the team already exists
    # echo $TEAM1

    if [[ -z $TEAM1 ]] #if team does not exist
    then
      #insert the team name into table
      INSERT=$($PSQL "insert into teams(name) values('$WINNER')")

      if [[ $INSERT="INSERT 0 1" ]]
      then
        echo "Inserted team '$WINNER'"
      fi
    fi

  fi

  if [[ $OPPONENT != "opponent" ]] #leave first row
  then
    #check if the team already exists
    TEAM2=$($PSQL "select name from teams where name='$OPPONENT'")
    # echo $TEAM2
    #if it does not exist in the table
    if [[ -z $TEAM2 ]]
    then  
      #insert the team into table

      INSERT=$($PSQL "insert into teams(name) values('$OPPONENT')")

      if [[ $INSERT="INSERT 0 1" ]]
      then
        echo "Inserted team '$OPPONENT'"
      fi
    
    fi
  
  fi

  if [[ $YEAR != "year" ]]
  then

    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    INSERT=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID)")

    if [[ $INSERT="INSERT 0 1" ]]
    then

      echo "Inserted into games $YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$WINNER_ID,$OPPONENT_ID"
    fi
  
  fi


done