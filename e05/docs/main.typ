#set text(font: "Atkinson Hyperlegible")
#set par(justify: true)
= Documentation
\
== About the system
This is the documentation for the simple Twitter-like _BackEnd_ mechanism of the user database by using *NestJS* framework. So the main logic used here are written using *TypeScript* and using *SQLite* as the relational database management (RDBMS). By using the *NestJS*,  there are some important change in our understanding, of course I cannot explain all of the NestJS stuff here because the lack of time and there is a fully explained documentation about the NestJS itself that you can access on https://docs.nestjs.com/. The main objective of this system is to make sure the server is serving CRUD(Create, Read, Update, and Delete) mechanism for user and its relation. We used _pnpm_(performant node package manager) to gain more advantages and efficiency by hard-linked files, _pnpm_ claimed that it can work up to 2x faster. 

== MVC
In this task we are implementing the MVC(Model, Controller, View) concept to represent the UI so we are not only think about the back but we also have to think about the front. But then what is MVC? Well...

By technical MVC can be defined as architectural patterns in object-oriented software design. Or we can say that MVC just like a separation system between data, process, and the display of a software. 

What is the point of this? Correct, it make our system more easy to maintain and more secure. 
- Controller ==> process
- Model ==> data
- View ==> display
#image("img/mvc.jpg")

=== Why MVC?
- Code Organization and Structure
- Code Organization and Structure
- Separation of Logic and Views
- Code Maintenance
- Implementation of OOP Concepts
- Used by Many Web Application Frameworks (WAFs)

As we have mentioned before that this concept is not only used for the _BackEnd_ methods but also used in many _FrontEnd_ framework.

==== Pre requisite
- pnpm  (performant node package manager)
- code editor


== Entity & Database Design
Because we are going to make a simple Twitter-like mechanism so the main entity on this database is *User*, *Posts*, and *Likes* which contain attribute as following:

+ *Posts*

  Posts here have 4 main attributes including the dependencies to their user according to the test file:
  - id (integer) _auto increment_
  - title (string)
  - content (string)
  - authorId (integer) _relation: user_

  
The expected output for this system is CRUD for the posts and replies. 

== API Endpoints and Method
In this task we will use ORM(object relational mapping) method to simplify our work and we are going to make a simple Prisma posts and reply mechanism. In this case the posts are the mode that have replies. So the CRUD endpoints will be like these:

+ *Posts*
  - GET /posts $arrow$ get all posts that stored on the database
  - GET /posts/:id $arrow$ get a post according to the id
  - POST /posts $arrow$ register multiple posts to database
  - PATCH /posts/:id $arrow$ update a post according to the id
  - DELETE /posts/:id $arrow$ delete a post according to the id


By using ORM it is easy enough to handle the database request because it have been configured by the framework, our main job is to make sure that the request handled correctly and give the expected response. 

== Data Validation Rules
Each entity has data that sent from the _end-user_ request must be validated by the _BackEnd_ logic so that the output data give the expected result. In NestJS we are using 3 types of concept that implemented in this assignment: providers, controllers, and modules. 

1. *Controllers*
Simply, controllers are responsible for handling the *incoming requests* and *sending response* to the client. It is just like the responsibility of native API, or we can say this is the waitress in a restaurant. It takes the *request* from costumer and sent it to the chef and sending back the *response*, but in this case _json_ format not a delicious hamburger.  

#image("img/image (1).png")

2. *Providers*
Providers in this context is about it can be injected as a dependency, allowing objects form various relationships with each other. This is just like "wiring up" one component in a class to other file in folder structure. From the name it's _provide_ just like chef in a restaurant.

#image("img/image.png")

3. *Modules*
Every Nest application has at least one module, the root module, which serves the starting point for Nest. We can say every module responsible for its components on its own resources and simply the root modules/app module is the headquarter.
#image("img/image (2).png")

By using the NestJS framework we can use the DTO(Data Transfer Object) to securely send data to _BackEnd_ and isolate some important layer so that the sensitive property did not get exposed. With DTO we can easily execute the CRUD method from the requested endpoints. 

== Error and Data Handling 
By using NestJS we don't need to worry about the error and handling because it is already configured an we just need to use it correctly. Prisma ORM is new kind of ORM, it uses the Prisma schema to define application models in a declarative way so that we just need to handle one type of db file.

  
*Prisma*

  By using Prisma ORM we can minimize the migration problems of traditional ORMs such as bloated model instances, mixing business with storage logic to prevent lack of type-safety or unpredictable queries caused e.g. by lazy loading.
  
== CRUD implementation

As we have discussed before, there is a slight difference between these two kind of ORM on their data transfer handling. On type ORM we need to initialize the entity one by one so that it can be used by the controllers and providers, it just like a database model that declared in a typescript file. On Prisma we need to initialize the db by using the schema.prisma. For more information on Prisma implementation you can follow this #link("https://docs.nestjs.com/recipes/prisma")[ #underline[link]. ] For reference, here is the source code from schema.prisma:

`
// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

// Looking for ways to speed up your queries, or scale easily with your serverless or edge functions?
// Try Prisma Accelerate: https://pris.ly/cli/accelerate-init

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite"
  url      = "file:./dev.db"
}

model Post {
  id         String   @id @default(uuid())
  posterName String
  content    String
  replyToId  String? // Optional - null if it's not a reply
  updatedAt  DateTime @updatedAt
  createdAt  DateTime @default(now())

  // Reply relationships
  replyTo Post?  @relation("PostReplies", fields: [replyToId], references: [id])
  replies Post[] @relation("PostReplies")

  @@map("posts")
}

`
=== Prisma Db Migration

A migration in Prisma is created with the command `npx prisma migrate dev`. This generates a new migration file that contains the SQL instructions required to update the database schema. Each migration is versioned and stored inside the /prisma/migrations folder, so developers can easily track the history of schema changes over time. This approach prevents inconsistencies between the application models and the actual database. 

If the database structure is already different from the migration history (a situation called drift), Prisma will notify the developer and may require a reset using `npx prisma migrate reset`. This command drops the current database, applies all migration files again, and ensures the schema is fully aligned. 

Compared to TypeORM, where entities are scattered across multiple files and migrations are often generated from those entities, Prisma simplifies the process by having a single declarative schema file. This makes migrations easier to manage, reduces the chance of error, and improves collaboration since every change is explicitly recorded in the schema and the migration history.

==== GET 
This API method is about *taking/getting* all data from users no matter what is the id, so the error handling for this method is only for the *database error* with the condition of _internal server error_. We can implement this by using controller.ts and service.tsORM we need to declare the db models first so it can be imported by the corresponding DTO and services. 

*Prisma*

==== GET by id
This API method is about *taking/getting* data according to the id. The main error handling is for the user that is *not exist* on the database, the rest is error from database. By using Nest we can easily implement it like before.

==== POST 
This API method is about *creating/registering* new users, posts or likes. Before data sent, we must to validate the user so we make the user validation in the `create-user.dto.ts`, `create-posts.dto.ts`, `create-likes.dto.ts`.

==== PATCH 
This API method is about *updating* a data from the database. So we need to select the specific data according to the id, the steps are same as the POST method but in additional we need to ensure the data is exist on the database. 

==== DELETE 
This API method is about *deleting/removing* a data from the database. So we need to select the specific data to delete according to the id. Because of that we need to ensure first whether the data is exist on the database or no.

==== Default 404
For another method that requested which cannot provided by the server will automatically responded with this default 404 not found.

== Testing
For the testing, we used the provided testing framework like vitest and supertest. Here we are not using framework to build the website, but we also clarify that we are using framework to test it. We use vitest because yes, it fast. Also we can used the useful VS Code extension like _thunder client_.

== How to Run
To run your server locally you can simply use the command `Nest start` and `Nest start --watch` to start dev mode. You can test it by running the command `pnpm test:e2e`.

== Conclusion
The conclusion is type ORM and Prisma ORM are very useful and it depends on what you need. They have their own helpful feature and for Prisma may have something great that type ORM doesn't but type is perfectly good for beginner like me. For simple CRUD implementation type ORM is still recommended like using a few entity but if we start to build a bigger or more complex project we may should start using Prisma ORM because of its resource effectivity and efficiency.  

== References
https://pnpm.io/id/

https://pnpm.io/id/motivation

https://vitest.dev/guide/

https://www.npmjs.com/package/supertest

https://docs.nestjs.com/

https://www.freecodecamp.org/news/what-is-an-orm-the-meaning-of-object-relational-mapping-database-tools/

https://www.prisma.io/dataguide/types/relational/what-is-an-orm

https://youtube.com/playlist?list=PLFIM0718LjIVEh_d-h5wAjsdv2W4SAtkx&si=2qILbPprntkh1FHE