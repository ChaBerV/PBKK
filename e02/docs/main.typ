#set text(font: "Atkinson Hyperlegible")
#set par(justify: true)
= Documentation
\
== About the system
This is the documentation for the simple _BackEnd_ mechanism of the user database without using any framework. So the main logic used here are written using raw *TypeScript* and using *SQLite* as the relational database management (RDBMS). There are no framework mechanism is used to build the _BackEnd_ system, but of course we used some useful *testing* framework and tools/packages to helps develop the test cases for the objective of this _BackEnd_ system. The main objective of this system is to make sure the server is serving CRUD(Create, Read, Update, and Delete) mechanism for user. We used _pnpm_(performant node package manager) to gain more advantages and efficiency by hard-linked files, _pnpm_ claimed that it can work up to 2x faster.
==== Pre requisite
- pnpm  (performant node package manager)
- supertest
- vitest
- code editor


== Entity & Database Design
The main entity on this database is *User* which contain attribute as following:
- id
- name
- age
- isAdmin
- createdAt
- updatedAt

The expected output for this system is only for the users CRUD. Here are the details about the entity's attributes.
+ *id* is the _primary key_ for the users, the type of this data is *integer* and it expected will be _auto-incremented_ by the system that we build.
+ *name* for the users is *string* that stored as *text* datatype and cannot assigned for the fix length, this causes we have to handle the input so that the name for one user is not too long.
+ *age* stored as *integer* datatype in SQLite and no extra requirements.
+ *isAdmin* is a *boolean* datatype that stored as *integer* in SQLite, 0 is for *false* and 1 is for *true*, this cause us to handle the conversion of 0 and 1 request from Type Script to an integer that can stored in SQLite and we also have to handle the conversion database response from integer to boolean. 
+ *createdAt* is a *datetime* datatype that stored as a *text* in SQLite, so that we have to convert the _datetime_ format into _ISOString_.
+ *updatedAt* have the same datatype and storing mechanism on SQLite, the difference between *createdAt* and *updatedAt* is where the User get updated the _datetime_ of update must be stored but the _datetime_ of create must be constant.

== API Endpoints
We used few API endpoints for this simple system:
- GET /users $arrow$ get all users that stored on the database
- GET /users/:id $arrow$ get a user according to the id
- POST /users $arrow$ register multiple users to database
- PUT /users/:id $arrow$ update a user according to the id
- DELETE /users/:id $arrow$ delete a user according to the id

== User Validation Rules
User data that sent from the _end-user_ request must be validated by the _BackEnd_ logic so that the output data give the expected result. There are some validation including the attribute validation that have to be done:
- *Request body*
  - We should validate that the request are sending the valid request body(in this case as a json) so that the data is safely stored on the database.
- *Name*
  - The main validation of user's name is to check whether the name is exists or no in the request and have to be a *string*. The task here needs that the name contain *100 characters* or *less* so we need to make the error condition if the name is more than 100 characters.  
- *Age*
  - The main validation of user's age is to check wether the age is exist or no in the request and it is have to be a *number/integer*. Here is some additional validation for negative and age that more than 150 years.
- *isAdmin*
  - There are two main validation for the isAdmin value:
    + _isAdmin_ have to be exist.
    + _isAdmin_ have to be a boolean.
    It is easy to handle the condition for number 1, but it a little bit tricky for the condition number 2. It because the SQLite rdbms could not store the boolean datatype as boolean, instead it use integer to store a boolean so we not only validate the boolean value but here we have to assign the true and false from the integer response from db which that case will be described in _Error Handling_ segment.

== Error Handling
In this segment we will explain the error handling for each API method that used on this system. Here are the explanation of error handling for each API method.

==== GET /users
This API method is just about *taking/getting* all data from users no matter what is the id, so the error handling for this method is only for the *database error* with the condition of _internal server error_.

==== GET /users/:id
This API method is about *taking/getting* a user data according to the id. The main error handling is for the user that is *not exist* on the database, the rest is error from database.

==== POST /users
This API method is about *creating/registering* new users. There are few steps for handling the error.
+ We need to validate the *request body* so there are no errors occurred because of missing data.
+ We need to handle the error for the _non-json_ data that are sent from the *request body* from the instance of _syntax error_.
+ We need to handle for the *database error*.

==== PUT /users/:id
This API method is about *updating* a user data from the database. So we need to select the specific user according to the id, the steps are same as the POST method but in additional we need to ensure the user is exist on the database.

==== DELETE /users/:id
This API method is about *deleting/removing* a user data from the database. So we need to select the specific user to delete according to the id. Because of that we need to ensure first whether the user is exist on the database or no.

==== Default 404
For another method that requested which cannot provided by the server will automatically responded with this default 404 not found.

== Testing
For the testing, we used the provided testing framework like vitest and supertest. Here we are not using framework to build the website, but we also clarify that we are using framework to test it. We use vitest because yes, it fast. Also we can used the useful VS Code extension like _thunder client_.

== How to Run
There are 3 files here that we can run in order to test the capability of the system: *index.ts*, *server.ts*, and *server.test.ts*. Here are the explanation:
- index.ts
Run the command `pnpm tsx .\src\index.ts` and the server will running on the decided port. And then use _thunder client_ or another API interaction software to test the methods.

- server.ts
Run the command `pnpm tsx .\src\server` and the server will start creating the database file but it will not affect our code.

- server.test.ts
To run this file we need to use `vitest`, by running the command `pnpm vitest .\src\server.test.ts` we will get the auto tester for the server. In this file contain around 40+ test cases for the server to be tested, to get passed all of the testcase we need to ensure that no test case missed even a single typo.

== References
https://pnpm.io/id/

https://pnpm.io/id/motivation

https://vitest.dev/guide/

https://www.npmjs.com/package/supertest
