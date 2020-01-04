from pprint import pprint

import requests

# BASIC USAGE
token = "cefc64349c70d5eb15606a1ecf5cf6281efab56b"
headers = {"Authorization": f"Token {token}"}

api_url = "https://api.github.com"
graphql_url = f"{api_url}/graphql"


# returns schema for all api stuff
# inspect the schema to find query terms that we need to use to get what we want
schema = requests.get(graphql_url, headers=headers)
pprint(schema.content)


# get repo names and forkcount for freecodecamp/freecodecamp repo
query = """{
  repository (name: "freecodecamp", owner: "freecodecamp") {
    name
    forkCount
  }
}
"""

result = requests.post(graphql_url, json={"query": query}, headers=headers)
print(result.json())
# returned_content = {
#     "data": {"repository": {"name": "freeCodeCamp", "forkCount": 23085}}
# }


# REST EXAMPLE
def rest_get(appendage_url=""):
    codecamp_url = f"{api_url}/repos/freecodecamp/freecodecamp/pulls/36735"
    if appendage_url:
        codecamp_url += appendage_url
    result = requests.get(codecamp_url, headers=headers)
    return result.json()


# 3 requests
pprint(rest_get("/commits"))
pprint(rest_get("/comments"))
pprint(rest_get("/reviews"))


# GRAPHQL EXAMPLE
query = """{
  repository(owner: "freecodecamp", name: "freecodecamp") {
    pullRequest(number: 36735) {
      commits(first: 10) {
        nodes {
            commit {
              id
            }
        }
      }
      comments(first: 10) {
        nodes {
            body
        }
      }
      reviews(first: 10) {
        nodes {
          id
        }
      }
    }
  }
}"""

# 1 request
result = requests.post(graphql_url, json={"query": query}, headers=headers)
