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

// Add default value to all node properties
MATCH (p:Person)
WHERE NOT exists(p.born)
SET p.born = 0

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



// CREATE NODES

// Add label to an existing node
MATCH (m:Movie)
WHERE m.title = 'Batman Begins'
SET m:Fantasy
RETURN labels(m)

// Create multiple nodes
CREATE
(:Person {name: 'Michael Caine', born: 1933}),
(:Person {name: 'Liam Neeson', born: 1952}),
(:Person {name: 'Katie Holmes', born: 1978}),
(:Person {name: 'Benjamin Melniker', born: 1913})

// Create nodes with labels and properties
CREATE (m:Movie:Action {title: 'Batman Begins'})
RETURN m

// Upsert a Node
MERGE (m:Movie {title: 'Sunshine'})
RETURN m

// Delete Nodes
MATCH (m:Movie)
WHERE m.title = "Batman Begins"
DELETE (m)

// Delete node & associated relationships
MATCH (p:Person)
WHERE p.name = 'Liam Neeson'
DETACH DELETE  p

// Get properties of an node
MATCH (m:Movie)
WHERE m.title = "Batman Begins"
RETURN properties(m)

// Remove label from nodes
MATCH (label:Action)
WHERE label.title = "Batman Begins"
REMOVE label:Action

// Set property on an existing node
MATCH (m:Movie)
WHERE m.title = 'Batman Begins'
SET m.released = 2005, m.lengthInMinutes = 140
RETURN m

// Set property using a map
MATCH (m:Movie)
WHERE m.title = 'Batman Begins'
SET  m = {title: 'Batman Begins',
          released: 2005,
          lengthInMinutes: 140,
          videoFormat: 'DVD',
          grossMillions: 206.5}
RETURN m


// Update properties
MATCH (m:Movie)
WHERE m.title = 'Batman Begins'
SET  m += { grossMillions: 300,
            awards: 66}
RETURN m

// Upsert and set properties only if node does not exist
MERGE (a:Person {name: 'Sir Michael Caine'})
ON CREATE SET a.birthPlace = 'London',
              a.born = 1934
RETURN a

// Upsert and set properties only if node exists
MERGE (a:Person {name: 'Sir Michael Caine'})
ON MATCH SET a.birthPlace = 'UK'
RETURN a

// Create a relationship between existing nodes
MATCH (p:Person), (m:Movie)
WHERE m.title = 'Batman Begins' AND p.name ENDS WITH 'Caine'
MERGE (p)-[:ACTED_IN]->(m)
RETURN p, m



// CONSTRAINTS

// Print all constraints
CALL db.constraints()

// Create constraint on movie title
CREATE CONSTRAINT UniqueMovieTitleConstraint ON (m:Movie)
ASSERT m.title IS UNIQUE

// Create a constraint on a relationship
CREATE CONSTRAINT ActedInRolesExistConstraint
ON ()-[r:ACTED_IN]-()
ASSERT r.roles IS NOT NULL

// Remove constraint
DROP CONSTRAINT ExistsMovieTagline

// Create existence constraint on tagline
// NOTE: only available on enterprise edition
CREATE CONSTRAINT ExistsMovieTagline ON (m:Movie)
ASSERT m.tagline IS NOT NULL

// Constraint key with multiple properties
// NOTE: only available on enterprise edition
CREATE CONSTRAINT UniqueNameBornConstraint
ON (p:Person) ASSERT (p.name, p.born) IS NODE KEY


// RELATIONSHIPS

// CASE to set relationship properties

MATCH (p:Person)-[rel:ACTED_IN]->(m:Movie)
WHERE m.title = 'Forrest Gump'
SET rel.roles =
CASE p.name
  WHEN 'Tom Hanks' THEN ['Forrest Gump']
  WHEN 'Robin Wright' THEN ['Jenny Curran']
  WHEN 'Gary Sinise' THEN ['Lieutenant Dan Taylor']
END

//create a relationship with properties
MATCH (a:Person), (m:Movie)
WHERE a.name = 'Katie Holmes' AND m.title = 'Batman Begins'
CREATE (a)-[rel:ACTED_IN {roles: ['Rachel','Rachel Dawes']}]->(m)
RETURN a.name, rel, m.title

// Create multiple realtionships to same node
MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
MATCH (p:Person)
WHERE p.name = 'Tom Hanks' OR p.name = 'Robin Wright' OR p.name = 'Gary Sinise'
CREATE (p)-[r:ACTED_IN]->(m)
RETURN p, r, m

// Create Multiple Relationships
MATCH (a:Person {name: 'Liam Neeson'}),
      (m:Movie {title: 'Batman Begins'}),
      (p:Person {name: 'Benjamin Melniker'})
CREATE (a)-[:ACTED_IN]->(m),
       (p)-[:PRODUCED]->(m)
RETURN a, m, p

// Create nodes and relationships
MATCH (m:Movie {title: 'Batman Begins'})
CREATE (a:Person {name: 'Gary Oldman', born: 1958})-[:ACTED_IN]->(m)
RETURN a, m

// Create relationship
MATCH (a:Person), (m:Movie)
WHERE a.name = 'Michael Caine' AND m.title = 'Batman Begins'
CREATE (a)-[:ACTED_IN]->(m)
RETURN a, m

// Remove relationship properties
MATCH (p:Person {name: "Christian Bale"})-[r:ACTED_IN]-(m:Movie {title: "RescueDawn"})
REMOVE r.roles
RETURN p, r, m

// Set relatinship properties
MATCH (p:Person {name: "Christian Bale"})-[r:ACTED_IN]-(m:Movie {title: "RescueDawn"})
SET r.roles = ["unknown", "someone"]
RETURN p, r, m
