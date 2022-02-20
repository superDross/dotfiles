-- DATA STRUCTURES

-- type coercion is valid in Lua
gross = "1" + 1

-- `+` is used for arithmetic while `..` is used for string concatenation
concat = "Hello there " .. "friend!"

-- tables are dicts that double up as lists
dict = {
  ["a"] = 1,
  ["b"] = 2,
  ["c"] = 3,
}
one = dict["a"]

-- iterate over a table
for key, value in pairs(dict) do
  print(key, value)
end

-- using ipairs() for integer values
list = {1, 2, 3}
for _, value in ipairs(list) do
  print(value)
end

-- unpacking
one, two, three = list

-- we can mix, by default the key value are the same value
print("Mixed")
mixed = {1, 2, ["C"] = 3}
for key, value in pairs(mixed) do
  print(key, value)
end

-- strings index: statement[12:-1]
statement = "Hello there friend!"
friend = string.sub(statement, 13, -2)



-- FUNCTIONS
function say_hi(name)
  if name == "Jimmy" then
    return "Go away Jimmy!"
  else
    return "Hi my name is " .. name
  end
end
say_hi('Jimmy')



-- CLASSES
Person = {}
Person.__index = Person

function Person:create(name, age, gender)
  local obj = {}
  setmetatable(obj, Person)
  obj.name = name
  obj.age = age
  obj.gender = gender
  return obj
end

function Person:say_name()
  print("Hello my name is " .. self.name)
end

-- create and use an Person
james = Person:create("James", 29, "male")
james:say_name()
