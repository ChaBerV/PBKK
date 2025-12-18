#set text(font: "Atkinson Hyperlegible")
#set par(justify: true)
= Documentation
\
== About the system
This is the documentation for the simple _BackEnd_ mechanism of the user database by using *NestJS* framework. So the main logic used here are written using *TypeScript* and using *SQLite* as the relational database management (RDBMS). Because we are using framework, there are some important change in our understanding, of course I cannot explain all of the NestJS stuff here because the lack of time and there is a fully explained documentation about the NestJS itself that you can access on https://docs.nestjs.com/. The main objective of this system is to make sure the server is serving CRUD(Create, Read, Update, and Delete) mechanism for user. We used _pnpm_(performant node package manager) to gain more advantages and efficiency by hard-linked files, _pnpm_ claimed that it can work up to 2x faster. 
==== Pre requisite
- pnpm  (performant node package manager)
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
+ *isAdmin* is a *boolean* datatype that stored as *integer* in SQLite, 0 is for *false* and 1 is for *true*.
+ *createdAt* is a *datetime* datatype that stored as a *text* in SQLite, so that we have to convert the _datetime_ format into _ISOString_.
+ *updatedAt* have the same datatype and storing mechanism on SQLite, the difference between *createdAt* and *updatedAt* is where the User get updated the _datetime_ of update must be stored but the _datetime_ of create must be constant.

== API Endpoints and Method
We used few API endpoints for this simple system:
- GET /users $arrow$ get all users that stored on the database
- GET /users/:id $arrow$ get a user according to the id
- POST /users $arrow$ register multiple users to database
- PUT /users/:id $arrow$ update a user according to the id
- DELETE /users/:id $arrow$ delete a user according to the id
By using NestJS it is easy enough to handle the method routing because it have been configured by the framework, our main job is to make sure that the request handled correctly and give the expected response. 

== User Validation Rules
User data that sent from the _end-user_ request must be validated by the _BackEnd_ logic so that the output data give the expected result. In NestJS we are using 3 types of concept that implemented in this assignment: providers, controllers, and modules.

1. *Controllers*
Simply, controllers are responsible for handling the *incoming requests* and *sending response* to the client. It is just like the responsibility of native API, or we can say this is the waitress in a restaurant. It takes the *request* from costumer and sent it to the chef and sending back the *response*, but in this case _json_ format not a delicious hamburger.  

#image("image (1).png")

2. *Providers*
Providers in this context is about it can be injected as a dependency, allowing objects form various relationships with each other. This is just like "wiring up" one component in a class to other file in folder structure. From the name it's _provide_ just like chef in a restaurant.

#image("image.png")

3. *Modules*
Every Nest application has at least one module, the root module, which serves the starting point for Nest. We can say every module responsible for its components on its own resources and simply the root modules/app module is the headquarter.
#image("image (2).png")

There are some validation including the attribute validation that have to be done:
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

== Error and Data Handling 
By using NestJS we don't need to worry about the handling because it is already configured an we just need to use it correctly. And about the CRUD schematics we can easily using the command `nest generate resources <name>`. The main component for CRUD mechanism:
- User data transfer object(dto) files
  DTOs are classes that define how data should be sent and validated when coming in from the client.
  - They ensure the request body follows the expected format.
  - Validation rules (e.g., IsString, IsNumber, IsBoolean) help catch invalid inputs early.
  - Example: create-user.dto.ts checks that name is a non-empty string, age is a number between 0 and 150, and isAdmin is a boolean.
- User entities
  Entities represent the actual data structure stored in the application or database.
  - They define the properties of a User (e.g., id, name, age, isAdmin, createdAt, updatedAt).
  - Entities may contain methods, like updating timestamps when a record changes.
- User modules
  Modules as explained before act as the main organizer of related code in NestJS.
  - A UserModule bundles together everything related to Users (controllers, services, and providers).
  - It makes the application modular and easy to maintain
  - User controllers 
    - Controllers handle incoming HTTP requests (e.g., GET /users, POST /users).
    - They receive data from the client, pass it to the service layer, and return a response
  - User services
    - Services contain the business logic of the application.
    - They interact with the database (or in-memory data) and apply rules.
  


==== GET /users
This API method is just about *taking/getting* all data from users no matter what is the id, so the error handling for this method is only for the *database error* with the condition of _internal server error_. We can implement this by using user.controller.ts and user.service.ts like this:

`users.controller.ts`

`@Get()
  findAll() {
    return this.usersService.findAll();
  }`

`users.service.ts`

`findAll(): User[] {
    return this.users;
  }
`

==== GET /users/:id
This API method is about *taking/getting* a user data according to the id. The main error handling is for the user that is *not exist* on the database, the rest is error from database. By using Nest we can easily implement it like before.

==== POST /users
This API method is about *creating/registering* new users. There are few steps for handling the error. Because we must to validate the user so we make the user validation in the `create-user.dto.ts` like this:

`import { IsString, IsNotEmpty, MaxLength, IsNumber, Min, max, Max, IsBoolean } from 'class-validator';
export class CreateUserDto {
    @IsString({ message: 'Name must be a string' })
    @IsNotEmpty({ message: 'Name is required and must be a non-empty string' })
    @MaxLength(100, { message: 'Name must be 100 characters or less' })
    name: string;

    // Age must be a number
    @IsNumber({}, { message: 'Age must be a number' })
    // Age is between 0 and 150
    @Min(0, { message: 'Age must be between 0 and 150' })
    @Max(150, { message: 'Age must be between 0 and 150' })
    age: number;

    @IsBoolean({ message: 'isAdmin must be a boolean value' })
    isAdmin: boolean = false;
}
`

==== PUT /users/:id
This API method is about *updating* a user data from the database. So we need to select the specific user according to the id, the steps are same as the POST method but in additional we need to ensure the user is exist on the database. In this system I just copy down the `create-user.dto.ts`.

==== DELETE /users/:id
This API method is about *deleting/removing* a user data from the database. So we need to select the specific user to delete according to the id. Because of that we need to ensure first whether the user is exist on the database or no.

==== Default 404
For another method that requested which cannot provided by the server will automatically responded with this default 404 not found.

== Testing
For the testing, we used the provided testing framework like vitest and supertest. Here we are not using framework to build the website, but we also clarify that we are using framework to test it. We use vitest because yes, it fast. Also we can used the useful VS Code extension like _thunder client_.

== How to Run
To run your server locally you can simply use the command `Nest start` and `Nest start --watch` to start dev mode. You can test it by running the command `pnpm test:e2e`.

== References
https://pnpm.io/id/

https://pnpm.io/id/motivation

https://vitest.dev/guide/

https://www.npmjs.com/package/supertest

https://docs.nestjs.com/