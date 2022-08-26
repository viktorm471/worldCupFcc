#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
 echo $($PSQL "TRUNCATE teams, games")
cat games_test.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != 'year' ]]
  then
    if [[ $ROUND == "Eighth-Final" ]]
    then
      RESULT_INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
        if [[ $RESULT_INSERT_TEAM == 'INSERT 0 1' ]]
          then 
          echo INSERT SUCCESSFUL
          else 
          echo THE TEAM ALREADY EXISTS
        fi
      RESULT_INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $RESULT_INSERT_TEAM == "INSERT 0 1" ]]
          then 
          echo INSERT SUCCESSFUL
          else 
          echo THE TEAM ALREADY EXISTS
        fi
    fi

  fi
done

cat games_test.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INSERT == "INSERT 0 1" ]]
          then 
          echo INSERT SUCCESSFUL AT GAMES
          else 
          echo THE GAME ALREADY EXISTS
        fi
  fi
done
