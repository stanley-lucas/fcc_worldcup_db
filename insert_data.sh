#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
    if [[ $YEAR != "year" ]]
    then
        #get winner_id
        WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

        #get opponent_id
        OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    
        #if not found
        if [[ -z $WINNER_ID ]]
        then 
            INSERT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
            if [[ $INSERT_TEAM == "INSERT 0 1" ]]
            then
                WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
                echo "Inserted team: $WINNER"
            fi
        fi
        
        if [[ -z $OPPONENT_ID ]]
        then
            INSERT_TEAM="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"
            if [[ $INSERT_TEAM == "INSERT 0 1" ]]
            then
                OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
                echo "Inserted team: $OPPONENT"
            fi
        fi
        
        #insert games
        echo "$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES ($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID) ")"

    fi
done