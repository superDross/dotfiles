# MongoDB

A NoSQL database; one that does not use SQL so a structured rows, columns, tables db.

It uses documents to stored data (instead of rows) which are stored in collections.

So its a NoSQL document database that uses JSON as documents.

## Structure

They call keys fields.

Documents are a way to organise data as a set of field-value pairs (they are JSON format):

```json
{
  <field> : <value>,
}
```

BSON is a binary representation of JSON that is is used to store to JSON documents.

Collection is multiple documents (multiple field-value pairs):

```json
{
  "name": "Jimmy"
}

{
  "name": "David"
}
```

A database is therefore multiple collections.

## Atlas

Mongo's attempt to get some of that sweet sweet cloud service money

## Exporting / Importing

Get sales collection from `sample_supplies` collection in JSON format:

```sh
mongoexport
  --uri="mongodb+srv://admin:admin@cluster0.mcq1b.mongodb.net/sample_supplies"
  --collection=sales
  --out=sales.json
```

Get data in BSON format and store locally:

```sh
mongodump
  --uri="mongodb+srv://admin:admin@cluster0.mcq1b.mongodb.net/sample_weatherdata"
```

Import the JSON collection into your local mongo instance:

```sh
mongoimport
  --drop sales.json
```

Import the BSON db data into your local mongo instance:

```sh
mongorestore
  --db sample_weatherdata
  dump/smaple_weatherdata
```

## Mongo Shell

The db you are connected to:

```mongo
db
```

List all dbs:

```mongo
show dbs
```

To connect to (or create) a specific database:

```mongo
use <database>
```

Drop a collection:

```
db.places.drop()
```

### Find

Print 20 random documents in the collection:

```mongo
db.zips.find( {} )
```

Print a single doc:

```
db.user.findOne()
```

As above but only print the state key/values in the document only:

```
db.user.findOne({}, {state: 1, _id: 0})
```

Find entries with New York state in zips collection in your current database:

```mongo
db.zips.find( {"state": "NY"} )

# get counts
db.zips.find( {"state": "NY"} ).count()
```

Query nested document:

```
db.companies.find(
  {"acquisition.price_currency_code": "USD"}
)
```

The above also works with document keys containing arrays of docs.

### Insert

create new collection and add data to it:

```
db.user.insert({"name": "david"})
```

Insert many records:

```
db.user.insertMany([
 {"name": "jim", "age": 99},
 {"name": "jaz", "age": 71}
 ])
```

Insert many but do **NOT** stop inserting upon failure, fail then continue inserting

```
db.places.insert([
      {"_id": 1, "pet": "mouse"}, 
      {"_id": 1, "pet": "rat"}, 
      {"_id": 2, "pet": "dog"}
    ], 
  {"ordered": false}
)
```


### Update

Update record with name david in user collection, by adding a new key/value:

```
db.user.update(
  {"name": "david"},
  {$set: {"nicknames": ["jimbo"]}}
)
```

Update an array:

```
db.user.update(
  {"name": "david"},
  {$push: {"nicknames": "jammy"}}
)
```

**NOTE**: also able to use `updateMany`


### Delete

Delete Jim:

```
db.user.deleteOne({"name": "jim"})
```

**NOTE**: also able to use `updateMany`


### Operators

There are other operators like $set, $push, $inc, $or, $ne, $exp, $lt, $gt

Find all birth years equal to 1998:

```
db.trips.find({"birth year": 1998}).count()
```

Get properties few type house and have a changing table:

```
// is the default operator
db.listingsAndReviews.find({property_type: "House", amenities: "Changing table"}).count()

db.listingsAndReviews.find({ $and: [{property_type: "House"}, {amenities: "Changing table"}]}).count()
```

Find all birth years greater than 1998 but less than 2005:

```
// works as the $and is the default operator
db.trips.find({"birth year": {"$gt": 1998, "$lt": 2005}}).count()
```

Return the documents that do not contain the two given values for result key:

```
 db.inspections.find({$nor: [{result: "No Violation Issued"}, {result: "Violation Issued"}]})
```

#### Chaining Operators

Get routes with destinatoin or src airport KZN and has an airplane of CR2 or A81

```js
db.routes.find({ "$and": [ { "$or" :[ { "dst_airport": "KZN" },
                                    { "src_airport": "KZN" }
                                  ] },
                          { "$or" :[ { "airplane": "CR2" },
                                     { "airplane": "A81" } ] }
                         ]})
```

### Aggregation

Aggregation is operations group values form multiple documents together allowing various operations to be goruped on the data.

Mongo uses a data pipeline approach.

$expr; use aggregation of expressions

$expr allows us to use variables and conditional statements

$expr is used to compare two fields. The number of companies that have the same permalink as their `twitter_username`

```
// we have to use $ for the document keys
db.companies.find({
  "$expr": {"$eq": ["$permalink", "$twitter_username"]}
  }).count()
```

Match the given criteria and project the given fields:

```js
db.listingsAndReviews.aggregate([
  { "$match": { "amenities": "Wifi" } },
  { "$project": { "price": 1,
                  "address": 1,
                  "_id": 0 }}
])
```

Group by address.country and count the number of distinct values across all documents:

```
db.listingsAndReviews.aggregate([
  { "$project": { "address": 1, "_id": 0 }},
  { "$group": { "_id": "$address.country",
                "count": { "$sum": 1 } } }
])
```

### Sort and Limit

Sort by population (lowest first) and limit to 2 results:

```js
db.zips.find().sort({"pop": 1}).limit(2)
```

To get highest first use `{"pop": -1}`

### Upsert

Update and insert a document.

We should only do it if we want to insert OR update an existing record if there.

```
db.collection.updateOne({"name": "jimmy"}, {"upsert": true})
```


### Array Operators

All entries must have internet, wifi, kitchen etc. in the amenities array and has 20 elements within the array:
```
db.listingsAndReviews.find({ "amenities": {
                                  "$size": 20,
                                  "$all": [ "Internet", "Wifi",  "Kitchen",
                                           "Heating", "Family/kid friendly",
                                           "Washer", "Dryer", "Essentials",
                                           "Shampoo", "Hangers",
                                           "Hair dryer", "Iron",
                                           "Laptop friendly workspace" ]
                                         }
                            }).pretty()
```


Find any score values in the array of scores that are greater than 85:

```
db.grades.find({ "scores": { "$elemMatch": { "score": { "$gt": 85 } } } })

// this also works
db.grades.find({ "scores.score": { "$gt": 85 } })
```
              

### Indexing

Indexes optimise queries.

Create an index in a collection for the birth year fo the trips collection.

```
// we can use multiple fields
db.trips.createIndex({ "birth year": 1 })
```


