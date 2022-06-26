#########Starter Portion######################################
#this code installs and loads the following packages if they are not already on your system
#gapminder (gives access to a dataset)
#dplyr (data manipulation in R)
#ggplot2 (charts/graphs in R)
if(!require("gapminder")) { install.packages("gapminder"); require("gapminder") }
if(!require("dplyr")) { install.packages("dplyr"); require("dplyr") }
if(!require("ggplot2")) { install.packages("ggplot2"); require("ggplot2") }

#this code assigns the gapminder table to gap, which will put the dataframe on your local system
gap <- gapminder 

#this code changes the data type of the country column (from factors to stings)
gap$country <- as.character(gap$country)




### 1. Evaluate each of the following expressions in R
  # 137 + 614
  # 39 – 81
  # 17 ×14
  # 107 ÷12
  # 134
  # Calculate the remainder of 1783 ÷23

137 + 614
39 - 81
17 * 14
107 / 12
13 ^ 4
1783 %% 23



### 2. Install and load the ggthemes package
install.packages('ggthemes')
library('ggthemes')



### 3. Using a loop of your choice, perform the following actions
  # a) Print “Emory Rocks!” to the console 10 times
for (x in 1:10) {
  print('Emory Rocks')
}
  # b) Print the names of the countries in rows 610-615 in the gap table
  #    (the table that was hardcoded and called gap in the starter script).
for (x in 610:615) {
  print(gap[x, ])
}

gap[610:615, ]



### 4. Set a to be a random number between 1 and 10. Then write an if else statement 
  #    that prints even if a is even and odd if a is odd.
a <- sample(1:10, 1)
if (a %% 2 == 0) {
  sprintf('%s: a is even.', a)
} else {
  cat(a, ': a is odd.')
}

# other expresssion for concatenation
cat(a, ': a is odd.')
print(paste(a, ': a is odd.'))

  #    Now, using the ifelse function, create a string that stores the value to be printed. 
  #    Then print the string to the console.
result <- ifelse(a %% 2 == 0, paste(a, ': a is even.'), paste(a, ': a is odd.'))
result



### 5. Write a function that does the following: taking in a single argument x, it should return 
  # “positive” if x is a positive number, “negative” if x is a negative number, 
  # “0” if x is equal to 0, and “Error: Not a number” if x is not a number. 
  # Test your function with at least one number and one non-number.

#if else
num_examiner <- function(num) {
  if (!is.numeric(num)) {
    print('Error: Not a number')
  } else if (num < 0) {
    print('negative')
  } else if (num > 0) {
    print('positive')
  } else {
    print('0')
  }
}

num_examiner(3)
num_examiner(-5.3)
num_examiner('num')


# trycatch (doesn't work)
num_examiner1 <- function(num) {
  result = tryCatch({
    if (num < 0) {
      print('negative')
    } else if (num > 0) {
      print('positive')
    } else {
      print('0')
    }},
    error = function(e) {
      if (!is.numeric(num)) {
        print('Not a number')
      }
    },
    finally = {}
  )
}

num_examiner1(3)
num_examiner1(-5.3)
num_examiner1('num')



### 6. Create a copy of the gap table called “copy”. Confirm that copy and gap are the exact same.

# with same memory address
copy <- gap
identical(copy, gap)
tracemem(copy) == tracemem(gap)

# with diffrent memory address
copy1 <- as_tibble(data.frame(gap))
identical(copy1, gap)
tracemem(copy1) == tracemem(gap)



### 7. Calculate summary statistics (mean, median, min, max, etc.) of the population column 
  #    of the gap table.
summary(gap$pop)



### 8. Create a simple linear regression model calculating GDP per capita as a function 
  #    of life expectancy using the gap table. Interpret anything relevant from the output 
  #    of the model. Additionally, calculate the correlation between these two values.
gap %>% 
  ggplot(aes(lifeExp)) +
  geom_histogram()

# plot to explore relationship
gap %>% 
  ggplot(aes(lifeExp, gdpPercap)) +
  geom_point()
# linear regressino model
life_gdp_lm <- lm(lifeExp ~ gdpPercap, data = gap)
summary(life_gdp_lm)
# correlation
cor(gap$lifeExp, gap$gdpPercap)

# plot to explore log relationship
gap %>% 
  ggplot(aes(lifeExp, log(gdpPercap))) +
  geom_point()
# log linear regression model
life_gdpLog_lm <- lm(lifeExp ~ log(gdpPercap), data = gap)
summary(life_gdpLog_lm)
# log correlation
cor(gap$lifeExp, log(gap$gdpPercap))



### 9. Using ggplot, create a line graph of population over time for Afghanistan. 
  #    Be sure to properly label your axis and title your graph.
gap %>% 
  filter(country == 'Afghanistan') %>% 
  ggplot(aes(year, pop)) +
  geom_line() +
  labs(
    title = 'population over time for Afghanistan',
    y = 'population'
  )



### 10. Load in the ‘Workers’ & ‘Title’ sheets from the MSBA SQL Tables file from 
  #     the SQL assignment.
library('readxl')
workers <- read_excel('/Users/angie/Desktop/MSBA SQL Tables.xlsx', sheet = 'Workers')
title <- read_excel('/Users/angie/Desktop/MSBA SQL Tables.xlsx', sheet = 'Title')



### 11. Join the Workers and Title tables together
worker_title <- workers %>% 
  inner_join(title, by = c('Worker_ID' = 'Worker_Ref_ID'))



### 12. Calculate the number of unique Worker Title-Department combinations present in the data.
worker_title %>% 
  count(Worker_Title, Department) %>% 
  nrow()



### 13. Perform the following manipulations to the joined table
  #  a) Create a full name column that contains a worker’s full name
worker_title <- worker_title %>% 
  mutate(Worker_Name = paste(First_Name,  Last_Name))

  #  b) Filter the table to only include employees who joined prior to August 2019
worker_title <- worker_title %>% 
  filter(Joining_Date < '2019-08-01')

  #  c) Order the table by Salary, least to greatest
worker_title <- worker_title %>% 
  arrange(Salary)

  #  d) Remove all columns except full name, Salary, Title, and department
worker_title <- worker_title %>% 
  select(Worker_Name, Salary, Worker_Title, Department)



### 14. Save the manipulated table as a CSV to your computer

# base R - write.csv
write.csv(worker_title, '/Users/angie/Desktop/worker_title.csv', row.names = FALSE)

# readr - write_csv
library('readr')
write_csv(worker_title, '/Users/angie/Desktop/worker_title_1.csv')

# data.table - fwrite
library('data.table')
fwrite(worker_title, '/Users/angie/Desktop/worker_title_2.csv')



### BONUS: 
### The excel file BonusFile.csv contains a transformed version of the gap table 
  # from this assignment. Perform the necessary %>%  data manipulation to transform the 
  # gap table into the table as it appears in the excel file. The following tips may prove useful.
    # GDP = gdpPercap * pop
    # Finland is not present in the Excel file
    # relativePop is a countries’ population divided by the countries’ max population in the dataset
gap_edit <- gap %>% 
  filter(country != 'Finland') %>% 
  mutate(GDP = pop * gdpPercap) %>% 
  group_by(country) %>% 
  mutate(relativePop = pop / max(pop)) %>% 
  ungroup() %>% 
  filter(year %in% c(1997, 2002)) %>% 
  subset(select = -c(lifeExp, pop, gdpPercap))

gap_trans <- read_csv('/Users/angie/Desktop/BonusFinal.csv')
gap_trans <- gap_trans[,-1]

# identity check
identical(gap_edit, gap_trans)

str(gap_edit)
str(gap_trans)
# different size

# show difference
gap_edit %>% 
  anti_join(gap_trans, by = 'country')



### DOUBLE BONUS: 
### Write your code to perform the bonus in such a way that it can be performed 
  # with a single click of the run button (hint: the pipe operator (%>%) will be 
  # essential to performing this)

# same as Bonus





