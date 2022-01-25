# 1. SQL -> Higher Than 75 Marks

"""
Query the Name of any student in STUDENTS who scored higher than Marks.

Order your output by the last three characters of each name.

If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.),
secondary sort them by ascending ID.
"""

# Answer
"""
SELECT name FROM students
WHERE marks > 75
ORDER BY SUBSTR(name, LENGTH(name)-2, 3), id;
"""

# 2. Counting Closed Paths

"""
Some numbers are formed with closed paths.

The digits 0, 4, 6 and 9 each have 1 closed path, and 8 has 2.

None of the other numbers is formed with a closed path.

Given a number, determine the total number of closed paths in all of its digits combined.

Example

number = 649578
The digits with closed paths are 6, 4, 9 and 8. The total number of closed paths is 1 + 1 + 1 + 2 = 5.

Function Description
Complete the function closedPaths in the editor below.

closedPaths has the following parameter(s):
int number: an integer
Returns:
int: the number of closed paths in number

Constraints
• 1 ≤ number ≤ 109
"""


def closed_paths(number):
    points = {"6": 1, "4": 1, "9": 1, "8": 2}
    return sum(points.get(num, 0) for num in str(number))


assert closed_paths(649578) == 5


# 3. concat strings (seems odd)

"""
String Sorting Concatenation

For example, given:

firstString = one, secondString = two, thirdString = three

concatenated in lexicographical order, the result = onethreetwo.

Function Description

Complete the function compareStrings in the editor below. The function must return a string.

compareStrings has the following parameter(s):

    firstString: a string
    secondString: a string
    thirdString: a string

Input Format

The first line contains the first string
The second line contains the second string
The third line contains the third string

Constraints

    1 ≤ |firstString|, |secondString|, |thirdString| ≤ 105
    Each of the strings consists of lowercase English characters, ascii[a-z].

Output Format

Output will be a concatenated string

Sample Input 0

hack
hacker
hackerrank

Sample Output 0

hackhackerhackerrank

Sample Input 1

klmno abcde fghij

Sample Output 1

abcdefghijklmno

Sample Input 2

ab
ac
aa

Sample Output 2

aaabac
"""


def compareStrings(firstString, secondString, thirdString):
    return "".join(sorted([firstString, secondString, thirdString]))


assert compareStrings("one", "two", "three") == "onethreetwo"
assert compareStrings("hack", "hacker", "hackerrank") == "hackhackerhackerrank"
assert compareStrings("klmno", "abcde", "fghij") == "abcdefghijklmno"
assert compareStrings("ab", "ac", "aa") == "aaabac"

# 4. fibonacci function with n


def fibonacci(n):

    if n <= 0:
        return 0
    elif n == 1:
        return 1

    first = 0
    second = 1

    for _ in range(2, n + 1):
        next_num = first + second
        first = second
        second = next_num

    return next_num


assert fibonacci(10) == 55


# 5. Price Check

"""
Price Check - popular question.

There is a shop with old-style cash registers.

Rather than scanning items and pulling the price from a database, the price of each item is typed in manually.

This method sometimes leads to errors. Given a list of items and their correct prices,
compare the prices to those entered when each item was sold.

Determine the number of errors in selling prices

E.g.

products = ['eggs, 'milk, 'cheese]
productPrices = [2.89, 3.29, 5.79]
productSold = ['eggs, eggs, cheese ' milk']
soldPrice = [2.89, 2.99, 5.97, 3.29]

Return the number of items sold at incorrect prices.
"""


def priceCheck(products, productsPrices, productSold, soldPrice):

    price_map = {prod: price for prod, price in zip(products, productPrices)}

    incorrect_prices = 0

    for product, sold_price in zip(productSold, soldPrice):
        if sold_price != price_map.get(product):
            incorrect_prices += 1

    return incorrect_prices


products = ["eggs", "milk", "cheese"]
productPrices = [2.89, 3.29, 5.79]
productSold = ["eggs", "eggs", "cheese", "milk"]
soldPrice = [2.89, 2.99, 5.97, 3.29]

assert priceCheck(products, productPrices, productSold, soldPrice) == 2
