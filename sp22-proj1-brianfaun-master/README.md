# Brian Faun Spring 2022 CS186 Project 1 - SQL Implementation


This is my implementation of the CS186 Project 1: SQL:

**Task 1: Basics**
i. In the people table, find the namefirst, namelast and birthyear for all players with weight greater than 300 pounds.
ii. Find the namefirst, namelast and birthyear of all players whose namefirst field contains a space. Order the results by namefirst, breaking ties with namelast both in ascending order
iii. From the people table, group together players with the same birthyear, and report the birthyear, average height, and number of players for each birthyear. Order the results by birthyear in ascending order.
Note: Some birth years have no players; your answer can simply skip those years. In some other years, you may find that all the players have a NULL height value in the dataset (i.e. height IS NULL); your query should return NULL for the height in those years.
iv. Following the results of part iii, now only include groups with an average height > 70. Again order the results by birthyear in ascending order.

**Task 2: Hall of Fame Schools**
i. Find the namefirst, namelast, playerid and yearid of all people who were successfully inducted into the Hall of Fame in descending order of yearid. Break ties on yearid by playerid (ascending).
ii. Find the people who were successfully inducted into the Hall of Fame and played in college at a school located in the state of California. For each person, return their namefirst, namelast, playerid, schoolid, and yearid in descending order of yearid. Break ties on yearid by schoolid, playerid (ascending). For this question, yearid refers to the year of induction into the Hall of Fame.
Note: a player may appear in the results multiple times (once per year in a college in California).
iii. Find the playerid, namefirst, namelast and schoolid of all people who were successfully inducted into the Hall of Fame -- whether or not they played in college. Return people in descending order of playerid. Break ties on playerid by schoolid (ascending). (Note: schoolid should be NULL if they did not play in college.)

**Task 3: SaberMetrics**
i. Find the playerid, namefirst, namelast, yearid and single-year slg (Slugging Percentage) of the players with the 10 best annual Slugging Percentage recorded over all time. A player can appear multiple times in the output. For example, if Babe Ruth’s slg in 2000 and 2001 both landed in the top 10 best annual Slugging Percentage of all time, then we should include Babe Ruth twice in the output. For statistical significance, only include players with more than 50 at-bats in the season. Order the results by slg descending, and break ties by yearid, playerid (ascending).
Baseball note: Slugging Percentage is not provided in the database; it is computed according to a simple formula you can calculate from the data in the database.
SQL note: You should compute slg properly as a floating point number---you'll need to figure out how to convince SQL to do this!
Data set note: The online documentation batting mentions two columns 2B and 3B. On your local copy of the data set these have been renamed H2B and H3B respectively (columns starting with numbers are tedious to write queries on).
Data set note: The column H o f the batting table represents all hits = (# singles) + (# doubles) + (# triples) + (# home runs), not just (# singles) so you’ll need to account for some double-counting
If a player played on multiple teams during the same season (for example anderma02 in 2006) treat their time on each team separately for this calculation
ii. Following the results from Part i, find the playerid, namefirst, namelast and lslg (Lifetime Slugging Percentage) for the players with the top 10 Lifetime Slugging Percentage. Lifetime Slugging Percentage (LSLG) uses the same formula as Slugging Percentage (SLG), but it uses the number of singles, doubles, triples, home runs, and at bats each player has over their entire career, rather than just over a single season.
Note that the database only gives batting information broken down by year; you will need to convert to total information across all time (from the earliest date recorded up to the last date recorded) to compute lslg. Order the results by lslg (descending) and break ties by playerid (ascending)
Note: Make sure that you only include players with more than 50 at-bats across their lifetime.
iii. Find the namefirst, namelast and Lifetime Slugging Percentage (lslg) of batters whose lifetime slugging percentage is higher than that of San Francisco favorite Willie Mays.
You may include Willie Mays' playerid in your query (mayswi01), but you may not include his slugging percentage -- you should calculate that as part of the query. (Test your query by replacing mayswi01 with the playerid of another player -- it should work for that player as well! We may do the same in the autograder.)
Note: Make sure that you still only include players with more than 50 at-bats across their lifetime.
Just for fun: For those of you who are baseball buffs, variants of the above queries can be used to find other more detailed SaberMetrics, like Runs Created or Value Over Replacement Player. Wikipedia has a nice page on baseball statistics; most of these can be computed fairly directly in SQL.
Also just for fun: SF Giants VP of Baseball Operations, Yeshayah Goldfarb, suggested the following:
Using the Lahman database as your guide, make an argument for when MLBs “Steroid Era” started and ended. There are a number of different ways to explore this question using the data.
(Please do not include your "just for fun" answers in your solution file! They will break the autograder.)

**Task 4: Salaries**
i. Find the yearid, min, max and average of all player salaries for each year recorded, ordered by yearid in ascending order.
ii. For salaries in 2016, compute a histogram. Divide the salary range into 10 equal bins from min to max, with binids 0 through 9, and count the salaries in each bin. Return the binid, low and high boundaries for each bin, as well as the number of salaries in each bin, with results sorted from smallest bin to largest.
Note: binid 0 corresponds to the lowest salaries, and binid 9 corresponds to the highest. The ranges are left-inclusive (i.e. [low, high)) -- so the high value is excluded. For example, if bin 2 has a high value of 100000, salaries of 100000 belong in bin 3, and bin 3 should have a low value of 100000.
Note: The high value for bin 9 may be inclusive).
Note: The test for this question is broken into two parts. Use python3 test.py -q 4ii_bins_0_to_8 and python3 test.py -q 4ii_bin_9 to run the tests
Hidden testing advice: we will be testing the case where a bin has zero player salaries in it. The correct behavior in this case is to display the correct binid, low and high with a count of zero, NOT just excluding the bin altogether.
Some useful information:
You may find it helpful to use the provided helper table containing all the possible binids. We'll only be testing with these possible binid's (there aren't any hidden tests using say, 100 bins) so using the hardcoded table is fine
If you want to take the floor of a positive float value you can do CAST (some_value AS INT)
iii. Now let's compute the Year-over-Year change in min, max and average player salary. For each year with recorded salaries after the first, return the yearid, mindiff, maxdiff, and avgdiff with respect to the previous year. Order the output by yearid in ascending order. (You should omit the very first year of recorded salaries from the result.)
iv. In 2001, the max salary went up by over $6 million. Write a query to find the players that had the max salary in 2000 and 2001. Return the playerid, namefirst, namelast, salary and yearid for those two years. If multiple players tied for the max salary in a year, return all of them.
Note on notation: you are computing a relational variant of the argmax for each of those two years.
v. Each team has at least 1 All Star and may have multiple. For each team in the year 2016, give the teamid and diffAvg (the difference between the team's highest paid all-star's salary and the team's lowest paid all-star's salary).
Note: Due to some discrepancies in the database, please draw your team names from the All-Star table (so use allstarfull.teamid in the SELECT statement for this).
