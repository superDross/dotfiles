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

$expr is used to compare two fields. The number of companies that have the same permalink as their `twitter_username`

```
db.companies.find({
  "$expr": {"$eq": ["$permalink", "$twitter_username"]}
  }).count()
```

Find all birth years equal to 1998:

```
db.trips.find({"birth year": 1998}).count()
```

Find all birth years greater than 1998:

```
db.trips.find({"birth year": {"$gt": 1998}}).count()
```

Get properties few type house and have a changing table:

```
db.listingsAndReviews.find({ $and: [{property_type: "House"}, {amenities: "Changing table"}]}).count()
```
