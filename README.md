# SQL random match generator

Simple and fully SQL solution to generate random matches from a list of players.

**player** table contains the list of players with name and year of birth;

**pair** table manage mate relationships between the players;

**mateGenerator** is the procedure that creates relationships between players and insert them in the pair table;

**match** is a view showing the names of the drawn players and their age difference.

# Istructions

Import SQL file and execute only this two queries:

``` sql
CALL mateGenerator();

SELECT * FROM `match` ORDER BY `differenceAge`;
```

Enjoy &#128521;

:star: **If you liked what I did, if it was useful to you or if it served as a starting point for something more magical let me know with a star** :green_heart:
