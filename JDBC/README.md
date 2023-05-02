## Student Info:
Name: Sibi suriyanarayan Tiruchirapalli venketaramani
Section: 05

## Data Generation

Much of the data generation was through the aid of ChatGpt, which was allowed by the professor:
- See: https://docs.google.com/document/d/1W6SOwYxfAOkp9uRpBRfH3VKYVjkD9aEoWgnn4MrvBBE/edit?usp=sharing

However I still had to format the data myself so that it was acceptable for MySQL to use

Data for students table:
- To generate the students table, I asked chat gpt the following question: "Please generate 
    random 100 names"
- I did that query twice to get 100 first and last names
- For student ids, I just auto_incremented from 1-100

Data for departments table:
- I simply made table of 6 (since we are working with 6 departments) and randomly chose myself the campuses each department was on

Data for classes table:
- I asked chat gpt the following query for each department: 
    "Give me 25 course titles from an English/Math/Physics/Computer Science/Chemistry/Biology major"
- This gave me a total of 150 randomly generated classes (6 deps x 25 classes each = 150 total classes)
- Additionally, for each of the 25 classes, I requested a random credit count from chatgpt like so:
    "Randomly select either the number 3 or the number 4, for 25 trials and give me the output of each trial."

Data for majors and minors table:
- I asked chat gpt the following query: 
    "Choose randomly amongst "Bio", "Chem", "CS", "Eng", "Math", and "Phys" for 100 trials."
- This way each student was randomly assigned a major and minor

Data for isTaking table:
- I created a stored procedure to essentially generate a schedule where each student takes 2 classes for their major and 2 for their minor

Data for hasTaken table:
- I created a stored procedure to essentially take random classes from the classes table depending on the given major
- Then I made the table like so:

Freshman:
0-7 classes
Assume all major classes

Sophomore:
8-14 classes
Assume 4 minor classes

Junior:
15-22 classes
Assume 8 minor classes

Senior:
23-30 classes
Assume 12 minor classes

All the sql code I used for data generation is provided in this zipfile. Please reference them at your leisure.
