// QUERY CHEAT SHEET
// download the movie dataset with the below command in the neo4j browser
// :play movie graph


// BASICS

//Display db schema
CALL db.schema.visualization()

//Get all properties
CALL db.propertyKeys()

//Return all nodes
MATCH (n)
RETURN n

// Get relationship from anonymous query
MATCH (p:Person)-[r]-(m:Movie {title: "The Matrix"})
Return p.name, type(r)

// In list
MATCH (p:Person)
WHERE p.born IN [1965, 1970]
return p.name

//Multiple conditions
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.released >= 2003 AND m.released <= 2004
RETURN p.name, m.title, m.released

//Not relationship
MATCH (p:Person)-[:PRODUCED]->(m:Movie)
WHERE NOT ((p)-[:DIRECTED]->(:Movie))
return p.name, m.title

//Property existance
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE exists(m.tagline)
RETURN Distinct m.title, m.tagline

// Query anonymous relations (bidirectional)
MATCH (p:Person)--(m:Movie {title: "The Matrix"})
Return p, m

//Query multiple relations
MATCH (p:Person)-[r:ACTED_IN | DIRECTED]->(m:Movie {title: 'The Matrix'})
RETURN p, r, m

//Return all nodes with a given property
MATCH (p:Person {born: 1970})
RETURN p.name, p.born AS `birth year`

//Return path via a variable
MATCH path=(a:Person)-[:ACTED_IN]->(m:Movie {title: "The Matrix"})
RETURN path  // equivalent to RETURN a, m

//String manipulation
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE toLower(p.name) STARTS WITH 'm' and toLower(m.tagline) CONTAINS 'the'
return p.name, m.title

// Dict manipulation
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)
WHERE a.name = 'Tom Hanks'
RETURN  m {.title, .released}

// use order by & limit to get top 5 youngest actors
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
// TODO: find an expression for 'is not null'
WHERE p.born > 0
RETURN p.name as name, p.born as year_born
ORDER BY year_born DESC
LIMIT 5



// TRAVERSAL

// Get all nodes related via a foreign relationship
MATCH (meg:Person)-[:ACTED_IN]->(m:Movie),
      (d:person)-[:DIRECTED]->(m),
      (other:Person)-[:ACTED_IN]->(m)
WHERE meg.name = 'Meg Ryan'
RETURN m.title as movie, d.name AS director , other.name AS `co-actors`

// Get matches exactly 1-4 nodes away
MATCH p = (m1:Movie)-[*1..4]-(m2:Movie)
WHERE m1.title = 'A Few Good Men' AND
      m2.title = 'The Matrix'
RETURN p

// Get matches exactly 4 nodes away
MATCH p = (m1:Movie)-[*4]-(m2:Movie)
WHERE m1.title = 'A Few Good Men' AND
      m2.title = 'The Matrix'
RETURN p

// Optional match; use null if not matching
MATCH (p:Person)
WHERE p.name STARTS WITH 'James'
OPTIONAL MATCH (p)-[r:REVIEWED]->(m:Movie)
RETURN p.name, type(r), m.title

// Shortest path between 2 nodes
MATCH p = shortestPath((m1:Movie)-[*]-(m2:Movie))
WHERE m1.title = 'A Few Good Men' AND
      m2.title = 'The Matrix'
RETURN p

// Subgraph based on a node property of interest
MATCH paths = (m:Movie)--(p:Person)
WHERE m.title = 'The Replacements'
RETURN paths



// AGGREGATION

// Collect list of rows
MATCH (n:Person)-[:ACTED_IN]->(m:Movie)
RETURN m.title, collect(n.name)

// Count
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
RETURN a.name, d.name, count(m)

// Count and collect
MATCH (a:Person)-[:ACTED_IN]->(m:Movie),
      (d:Person)-[:DIRECTED]->(m)
RETURN a.name, d.name, count(m), collect(m.title) AS `movies for Tom Cruise`

// Size (collect + len)
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
RETURN a.name, d.name, count(m), size(m.title) AS `Number movies for Tom Cruise`



// PROCESSING

// WITH allows pre-processing before returning
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WITH p.name AS actors
RETURN actors

// Preprocess & UNWIND from list to rows
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WITH collect(p) AS actors,
     count(p) AS actor_count,
     m.title AS movie_title
UNWIND actors AS actor
RETURN movie_title, actor_count, actor.name AS actor_name
ORDER BY actor_count, movie_title, actor_name

// SUBQUERY the original query
MATCH (p:Person)
WITH p, size((p)-[:ACTED_IN]->()) AS movies
WHERE movies >= 5
OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)
RETURN p.name, m.title

// SUBQUERY with CALL (does not seem to be used often)
CALL
{
    MATCH (p:Person)-[:REVIEWED]->(m:Movie)
    RETURN  m
}
MATCH (m) WHERE m.released=2000
RETURN m.title, m.released

