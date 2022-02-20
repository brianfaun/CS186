import difflib
import os
import shutil
import argparse
import subprocess

has_alternate_solutions = {'q2iii'}
sqlite = "sqlite3"
defaultdb = "lahman.db"
# If you're on windows/older versions of mac we'll use
# the sqlite file in your proj1 directory
for name in ('sqlite', 'sqlite3', 'sqlite3.exe'):
    if os.path.exists(name):
        sqlite = "./" + name
        print("Using `{}` to run tests.".format(sqlite))
        break

queries = [
    ("SELECT * FROM q0;", "q0"),
    ("SELECT * FROM q1i ORDER BY namefirst, namelast, birthyear;", "q1i"),
    ("SELECT * FROM q1ii ORDER BY namefirst, namelast, birthyear;", "q1ii"),
    ("SELECT birthyear, ROUND(avgheight, 4), count FROM q1iii;", "q1iii"),
    ("SELECT birthyear, ROUND(avgheight, 4), count FROM q1iv;", "q1iv"),
    ("SELECT * FROM q2i;", "q2i"),
    ("SELECT * FROM q2ii;", "q2ii"),
    ("SELECT * FROM q2iii;", "q2iii"),
    ("SELECT playerid, namefirst, namelast, yearid, ROUND(slg, 4) FROM q3i;", "q3i"),
    ("SELECT playerid, namefirst, namelast, ROUND(lslg, 4) FROM q3ii;", "q3ii"),
    ("SELECT namefirst, namelast, ROUND(lslg, 4) FROM q3iii ORDER BY namefirst, namelast;", "q3iii"),
    ("SELECT yearid, min, max, ROUND(avg, 4) FROM q4i;", "q4i"),
    ("SELECT * FROM q4ii WHERE binid <> 9;", "q4ii_bins_0_to_8"),
    ("""WITH max_salary AS (SELECT MAX(salary) AS salary FROM salaries)
        SELECT binid, low,
            ((CASE WHEN high >= salary THEN '' ELSE 'not ' END) ||
                    'at least ' || salary) AS high, count
        FROM q4ii, max_salary WHERE binid = 9;""", "q4ii_bin_9"),
    ("SELECT yearid, mindiff, maxdiff, ROUND(avgdiff, 4) FROM q4iii;", "q4iii"),
    ("SELECT * FROM q4iv ORDER BY yearid, playerid;", "q4iv"),
    ("SELECT team, ROUND(diffAvg, 4) FROM q4v ORDER BY team;", "q4v")
]

def make_diff(expected_output_path, your_output_path, diff_path):
    with open(expected_output_path, 'rt') as f:
        expected_lines = f.read().splitlines()
    with open(your_output_path, 'rt') as f:
        your_lines = f.read().splitlines()
    match = True
    diff_lines = []
    for line in difflib.ndiff(your_lines, expected_lines):
        if not line.startswith('? '):
            if line[:2] in ('- ', '+ '):
                if line[2:].strip():
                    match = False
                else:
                    continue
            diff_lines.append(line)
    with open(diff_path, 'wt') as f:
        f.write("\n".join(diff_lines))
    return match

def remake_dir(path):
    if os.path.exists(path):
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.remove(path)
    os.mkdir(path)

def test_query(query, test_name, expected_output, data, has_alt=False):
    your_output_path = os.path.join("your_output", "{}.txt".format(test_name))
    expected_output_path = os.path.join(expected_output, "{}.txt".format(test_name))
    diff_path = os.path.join("diffs", "{}.txt".format(test_name))

    with open(your_output_path, 'wt') as f:
        try:
            subprocess.run([sqlite, data, "-header", "-list", query], stdout=f, stderr=f, check=True)
        except subprocess.CalledProcessError:
            print("ERROR {} see your_output/{}.txt".format(test_name, test_name))
            return False

    with open(your_output_path, 'wt') as f:
        subprocess.run([sqlite, data, "-header", "-list", query], stdout=f)

    if not make_diff(expected_output_path, your_output_path, diff_path):
        if has_alt:
            alt_result = test_query(query, test_name + '-alt', expected_output, data, has_alt=False)
            if alt_result:
                return True
        if 'alt' not in test_name:
            print("FAIL {} see diffs/{}.txt".format(test_name, test_name))
        return False
    else:
        print("PASS {}".format(test_name))
        return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Run the tests for Project 1')
    parser.add_argument('-q', '--question', default="all")
    parser.add_argument('-d', '--data', default=defaultdb)
    parser.add_argument('--file', default="proj1.sql")
    parser.add_argument('--expected', default="expected_output")

    args = parser.parse_args()

    if not os.path.exists(args.data):
        print("Could not find `{}` in the current directory. Have you unzipped the dataset?".format(args.data))
        exit(1)


    subprocess.run([sqlite, args.data, ".read {}".format(args.file)])

    remake_dir("your_output")
    remake_dir("diffs")

    passed = True
    ran_any = False
    for query, test_name in queries:
        if args.question in ('4ii', 'q4ii') and test_name.startswith('q4ii_'):
            pass
        elif args.question not in ('all', test_name, test_name[1:]):
            continue
        ran_any = True
        result = test_query(query, test_name, args.expected, args.data, test_name in has_alternate_solutions)
        passed &= result
        if not result and args.question != 'all':
            print("Query used: `{}`".format(query))
    if not ran_any:
        print("WARNING: No such question `{}`".format(args.question))
        exit(0)
    if passed:
        print("SUCCESS: Your queries passed tests on this dataset")
        exit(0)
    exit(1)
