# CodeBook
## Coursera - John Hopkins - DataScience course 03 - Getting and Cleaning Data

### Description
Everything related to the project can be found in the attached README.md file.

### Steps


Before running the script, be sure to select "./course03/week04_Project" as 
the default working directory (depending on IDE).


1. Check if the data has previously been downloaded, if so skip, otherwise:
  - download
  - extract
  - cleanup zip file
2. Read the data into separate dataframes
  - the colums names have been guessed using the instructions that came with the
    data and inspecting the data using the str() and names() functions
3. Merge the data from the training and testing data sets
  - 70% of subjects were assigned to the training group
  - 30% of subjects were assigned to the testing group
  - I have used the bind_rows() function as it was a vertical bind
4. Merge the three separate datasets: X, Y and Subject
  - This time I used the cbind() function as it was an horizontal bind, where
    the number of columns would increase but not the rows.
    It wasn't necessary to add a column name for the binding as the data was
    merged by INDICES, and they had the same length
5. Extract only the columns that contain averages and standard deviations
  - I have selected the rows using a substring 
6. Replace the numerical values of the activityEnum column with the labels from 
  the activities dataset
  - it contains just two columns with an enumeration (1-6) and the associated 
  activity name
7. Rename the column names
  - Two columns were renamed by hand with the rename() function
  - The rest of the columns were renames using gsub() 
8. Get the summary of the data by subject and activity
  - I used the powerful summarise() function from dplyr after having created 
    two groups (SubjectID and Activity) using dplyr's group_by() function