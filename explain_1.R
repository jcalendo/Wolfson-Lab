library(tidyverse)

# Let's create a simple example so you can see what's going on
grades <- tribble(~Student_ID, ~Midterm,
                  "JG",          84, 
                  "DC",          92,
                  "AB",          90,
                  "TB",          76,
                  "CK",          98)


## Why are you using two "grades" dataframes in this command? How are they both different? 

# Think about this expression from the inside out. 
# What would something like grades[1, 1] do? grades[  , 1] or grades[1,  ]? 

(grades[1, 1])
(grades[ , 1])
(grades[1, ])

# grades[1, 1] would select the value in the grades data frame in the first row,
# first column. grades[ , 1] would select the entire first column and grades[1, ] 
# would select the entire first row. So when we say grades[expression1, expression2] 
# we are subsetting/selecting rows and columns from the grades data frame according
# to the rules we apply in expression1 or expression2. expression1 defines what rules 
# are applied to select rows from the data frame and expression2 defines what rules are
# applied to select columns from the data frame.


## What does [order (-grades$Midterm),] mean ?

# This brings us to [order(-grades$Midterm), ]. Remember, the basic format to 
# select data from a data frame (df) is df[rows, columns]. 'rows' in this case 
# is equal to order(-grades$Midterm). 

# Again, let's work from the inside out. -grades$Midterm selects the Midterm 
# column from the grades data frame. This returns the values with their signs
# flipped, which when sorted, returns the descending order.

(-grades$Midterm)

# The order() function is then applied to the Midterm grades. Remember, the 
# order function returns a list of indices. This list of indices defines the 
# order of the rows we wish to pull from the data frame. 

(order(-grades$Midterm))
(order(grades$Midterm, decreasing = TRUE))  # this does the same thing, just more typing

# From the output:
# 5 2 3 1 4
# we can see the highest grade is in the 5th position of the original Midterm
# grades, the lowest grade is in the 4th position.

# Now we want to re-create the data frame where the highest grade is at the top
# and the lowest grade is at the bottom. To do this we subset the grades data frame
# again, now using the indeces returned by the expression above. 

# remember: grades[rows, columns]
# rows = order(-grades$Midterm)
# -grades$Midterm = 5, 2, 3, 1, 4
(grades[order(-grades$Midterm), ])

# behind the scenes this is saying to R
# grades[5, ]
# then grades[2, ]
# then grades[3, ]
# and so on and combine into a single data frame

# we can assign this full expression back to grades to then create a data frame
# that is sorted by Midterm grade
grades <- grades[order(-grades$Midterm), ]


## How come you did not use "grades" before the order(), similar to the command that is mentioned initially ( grades <- grades[order(-grades$Midterm), ]  )?

# Now since the data frame is sorted we need to create a new column using the
# order function to assign a rank to each student. Remember, the order function
# returns indeces so the only way to have the order function return a list like
# 1, 2, 3, 4, ... is to have your list in order from highest to lowest.

# see what order(-grades$Midterm) returns now
(order(-grades$Midterm))

# 1 2 3 4 5, because the highest grade is now at the first index of Midterm
# and the lowest is at the 5th. The only thing left to do is create a new 
# column in the dataframe for the new rank. We do this by assigning the 
# new column and then telling R how we want to fill that column. In this case
# by the order(-grades$Midterm) function

grades$new_rank <- order(-grades$Midterm)

# take a look at the final answer
View(grades)
