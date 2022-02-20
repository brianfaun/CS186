-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era) AS
    SELECT MAX(era)
    FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear) AS
    SELECT namefirst, namelast, birthyear
    FROM people as p
    WHERE p.weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear) AS
    SELECT namefirst, namelast, birthyear
    FROM people as p
    WHERE p.namefirst LIKE '% %'
    ORDER BY namefirst, namelast
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count) AS
    SELECT birthyear, AVG(height), count(*)
    FROM people as p
    GROUP BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count) AS
    SELECT birthyear, AVG(height) as avgheight1, count(*)
    FROM people as p
    GROUP BY birthyear
    HAVING AVG(height) > 70
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid) AS
    SELECT namefirst, namelast, f.playerid, f.yearid
    FROM people p, halloffame f
    WHERE p.playerid = f.playerid
    AND inducted = 'Y'
    ORDER BY yearid DESC, f.playerid
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid) AS
    SELECT q.namefirst, q.namelast, q.playerid, s.schoolid, q.yearid
    FROM q2i q, schools s, collegeplaying c
    WHERE s.schoolid = c.schoolid
    AND q.playerid = c.playerid
    AND s.schoolstate = 'CA'
    ORDER BY q.yearid DESC, s.schoolid, q.playerid
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid) AS
    SELECT p.playerid, namefirst, namelast, schoolid
    FROM people p INNER JOIN halloffame f
    ON p.playerid = f.playerid
    LEFT OUTER JOIN collegeplaying c
    ON p.playerid = c.playerid
    WHERE inducted = 'Y'
    ORDER BY p.playerid DESC, schoolid
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg) AS
    SELECT p.playerid, namefirst, namelast, yearid, (b.H + b.H2B + 2 * b.H3B + 3 * b.HR) * 1.0 / b.AB as slg
    FROM people p, batting b
    WHERE p.playerid = b.playerid
    AND b.AB > 50
    ORDER BY slg DESC, yearid, p.playerid
    LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg) AS
    SELECT p.playerid, namefirst, namelast, (SUM(b.H) + SUM(b.H2B) + 2 * SUM(b.H3B) + 3 * SUM(b.HR)) * 1.0 / SUM(b.AB) as lslg
    FROM people p, batting b
    WHERE p.playerid = b.playerid
    GROUP BY p.playerid
    HAVING SUM(b.AB) > 50
    ORDER BY lslg DESC, p.playerid
    LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg) AS
    SELECT namefirst, namelast, (SUM(b.H) + SUM(b.H2B) + 2 * SUM(b.H3B) + 3 * SUM(b.HR)) * 1.0 / SUM(b.AB) as lslg
    FROM people p, batting b
    WHERE p.playerid = b.playerid
    GROUP BY p.playerid
    HAVING SUM(B.AB > 50)
    AND lslg > 0.5575
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg) AS
    SELECT s.yearid, MIN(salary), MAX(salary), AVG(salary)
    FROM salaries s, teams t
    WHERE s.yearid = t.yearid
    GROUP BY s.yearid
    ORDER BY s.yearid
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count) AS
    WITH range AS (
        SELECT MIN(salary) AS lowest, MAX(salary) AS highest, CAST (((MAX(salary) - MIN(salary))/10) AS INT) AS bucket FROM salaries where yearid = 2016
    )
    SELECT binid, lowest + binid * bucket, lowest + (binid + 1) * bucket, count(*)
    FROM binids b, salaries s, range
    WHERE (salary between lowest + binid * bucket and lowest + (binid + 1) * bucket)
    AND yearid = 2016
    GROUP BY binid
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff) AS
    WITH last AS (
        SELECT (yearid + 1) AS adjusted, MIN(salary) AS low, MAX(salary) AS high, AVG(salary) AS aver
        FROM salaries
        GROUP BY adjusted
    ),
        now AS (
        SELECT yearid, MIN(salary) AS low, MAX(salary) AS high, AVG(salary) AS aver
        FROM salaries
        GROUP BY yearid
    )
    SELECT n.yearid, (n.low - l.low) AS mindiff, (n.high - l.high) AS maxdiff, (n.aver - l.aver) AS avgdiff
    FROM last l, now n
    WHERE l.adjusted = n.yearid
    ORDER BY n.yearid
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid) AS
    SELECT p.playerid, namefirst, namelast, MAX(salary), yearid
    FROM people p, salaries s
    WHERE p.playerid = s.playerid
    AND yearid = 2000
    GROUP BY yearid
    HAVING MAX(salary) >=
        ( SELECT MAX(salary)
        FROM people p2, salaries s2
        WHERE p2.playerid = s2.playerid
        GROUP BY yearid)

    UNION

    SELECT p.playerid, namefirst, namelast, MAX(salary), yearid
    FROM people p, salaries s
    WHERE p.playerid = s.playerid
    AND yearid = 2001
    GROUP BY yearid
    HAVING MAX(salary) >=
           ( SELECT MAX(salary)
             FROM people p2, salaries s2
             WHERE p2.playerid = s2.playerid
             GROUP BY yearid)
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
    SELECT a.teamid, (MAX(salary) - MIN(salary)) as diffAvg
    FROM allstarfull a, salaries s
    WHERE a.playerid = s.playerid
    AND a.yearid = s.yearid
    AND a.yearid = 2016
    GROUP BY a.teamid
;

