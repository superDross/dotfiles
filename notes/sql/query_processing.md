# Logical Query Processing

## Processing Order

The order in which one clause parses the data to another clause:

1. From/Join
2. Where
3. Group By
4. Having
5. Select Order By
6. Offset/Fetch

### 1. Source Data (FROM/JOIN)

Getting the dataset of interest.

`FROM` can accept a table, a view, a function or a subquery.

### Join Order

The join processing order follows the following order regardless of what type is used.

1. __Cartesian Product (Cross Join)__

   Every join, begins with each row from one set is paired with each row from another. The resulting set
   consists of all columns from both sources.

2. __Qualification (Inner/Outer)__

   Each row from the cartesian product, is evaluated using the conditional given with the `ON` keyword.
   Only rows that evaluate to True remain.

3. __Reservations (Left/Right/Full Outer Joins)__

   All rows that failed to qualify are reintroduced into the join result.

### 2. Row Filter (WHERE)

Some conditions can be done at the joining stage and it is generally more efficient.

```sql
SELECT *              SELECT *
FROM A                FROM A
INNER JOIN B          INNER JOIN B
  ON A.X = B.X          ON A.X = B.X
  AND A.X > 1         WHERE A.X > 1;
```

The results are the same but the first query is the most efficient because it only
their logical processing is different; the first query goes through fewer.

#### Nulls

Never use `A.X != NULL` instead `A.X IS NOT NULL` does work.

### 3. Grouping (GROUP BY)

Unlike the previous two clauses, which treats each value individually, we must treat
many rows as a single group.

After the dataset is grouped, columns not grouped can only selected via an aggregate function.

#### Nulls

Aggregate functions ignore `Null`.

All `Null`s in a column are treated as a single group in `GROUP BY`.

### 4. Group Filter (GROUP BY)

Stuff












## Visually Processing Order

```sql
/*
  city  | country | population 
--------+---------+------------
Paris   | France  |    8908081 
--------+---------+------------
Lyon    | France  |     488050 
--------+---------+------------
Berlin  | Germany |    8175133 
--------+---------+------------
Munich  | Germany |    1307402 
--------+---------+------------
Canillo | Andorra |     201741 
--------+---------+------------
Craiova |         |    2148271 
*/


SELECT
  country, SUM (population)
FROM
  city
WHERE
  country IS NOT NULL
GROUP BY country
HAVING count(country) >= 2;
```

The processing order of the above query is displayed below:

```
        FROM                     WHERE                   GROUP BY                HAVING                  SELECT
                                                                                                   
  country | population     country | population     country | population    country | population    country |   sum
 ---------+------------   ---------+------------   ---------+------------  ---------+------------  ---------+---------
  France  |    8908081     France  |    8908081     France  |    8908081    France  |    8908081    France  | 9396131
 ---------+------------   ---------+------------            |     488050            |     488050   ---------+------------
  France  |     488050     France  |     488050    ---------+------------  ---------+------------   Germany | 9482535
 ---------+------------   ---------+------------    Germany |    8175133    Germany |    8175133   
  Germany |    8175133     Germany |    8175133             |    1307402            |    1307402   
 ---------+------------   ---------+------------   ---------+------------ 
  Germany |    1307402     Germany |    1307402     Andorra |     201741   
 ---------+------------   ---------+------------
  Andorra |     201741     Andorra |     201741 
 ---------+------------
          |    2148271
```
