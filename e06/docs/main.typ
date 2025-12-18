#set text(font: "Atkinson Hyperlegible")
#set par(justify: true)
= Documentation
== About the System
This documentation outlines the backend architecture for a simple Twitter-like application. The system is built using the NestJS framework on a TypeScript foundation. For the database, it utilizes SQLite as the Relational Database Management System (RDBMS), managed via the Prisma ORM.

The primary objective is to provide a robust CRUD (Create, Read, Update, Delete) API for managing posts and their relationships (replies).

This project uses pnpm (performant node package manager) to manage dependencies, leveraging its speed and efficiency.

== Core Architecture: NestJS Fundamentals
Instead of a traditional MVC (Model-View-Controller) pattern that renders HTML, this NestJS application follows a modern decoupled architecture. The "View" is the JSON data sent to a separate frontend client. The core concepts are:

Controllers: Responsible for handling incoming HTTP requests and sending responses. They act as the "waitress" in a restaurant, taking an order (request) from the client and returning the dish (response).

Providers (Services): Contain the actual business logic. They are the "chef" responsible for processing the request, interacting with the database, and preparing the data to be returned.

Modules: Act as the "headquarters." They organize the application structure by grouping related controllers and providers into logical units. Every NestJS application has at least one root module (AppModule).

*Prerequisite*

- pnpm (performant node package manager)

- Code Editor (e.g., VS Code)

== Database and Data Model (Prisma)
We use Prisma as our Object-Relational Mapper (ORM). It simplifies database interactions by allowing us to work with a single, declarative schema.prisma file, which serves as the single source of truth for our database structure.

*Post Model*

Based on the schema.prisma file, our primary model is Post. It's designed to handle both original posts and replies through a self-referencing relationship.


`// schema.prisma
  model Post {
    id         String   @id @default(uuid())
    posterName String
    content    String
    replyToId  String?  // Optional: null if not a reply
  
    updatedAt  DateTime @updatedAt
    createdAt  DateTime @default(now())
  
    // Self-relation for replies
    replyTo    Post?    @relation("PostReplies", fields: [replyToId], references: [id])
    replies    Post[]   @relation("PostReplies")
  
    @@map("posts")
  }
`
- replyToId: This field links a post to its parent post. If it's null, it's a top-level post.

- replyTo & replies: These fields create the relationship, allowing us to easily query for a post's parent or all of its direct replies.

*Prisma Migration*

Prisma simplifies database schema changes.

- npx prisma migrate dev: This command generates a new SQL migration file based on changes in your schema.prisma and applies it to the database. All migrations are versioned and stored in the prisma/migrations folder.

- npx prisma migrate reset: This command is used if the database and migration history get out of sync. It drops the database and re-applies all migrations from the beginning.

API Endpoints
The following CRUD endpoints are provided for the Post entity:

GET /posts → Get all posts stored in the database.

GET /posts/:id → Get a specific post by its ID.

POST /posts → Create a new post (or a reply if replyToId is provided).

PATCH /posts/:id → Update an existing post by its ID.

DELETE /posts/:id → Delete a post by its ID.

== Data Validation (DTOs)
To ensure data integrity and security, we use Data Transfer Objects (DTOs). A DTO is a class that defines the shape of data expected in an incoming request (e.g., for creating or updating a post).

By using DTOs with NestJS's built-in ValidationPipe, we can automatically validate incoming JSON payloads. This ensures that:

Required fields (like posterName and content) are present.

Data types are correct (e.g., content must be a string).

Sensitive properties are not exposed.

== Error Handling
NestJS provides a built-in exception layer for handling errors consistently. Prisma also provides specific error codes for common database issues.

- GET /posts: The primary error handled here is a generic Internal Server Error if the database connection fails.

- GET /posts/:id: If a post with the specified ID is not found, the server will respond with a 404 Not Found error.

- POST /posts: Handles validation errors from the DTO (e.g., missing content) with a 400 Bad Request. Also handles database errors.

- PATCH /posts/:id: Similar to POST, but also includes a 404 Not Found check to ensure the post exists before attempting to update it.

- DELETE /posts/:id: Includes a 404 Not Found check to ensure the post exists before deletion.

- Default 404: Any request to an undefined route will automatically receive a 404 Not Found response.

== Testing
End-to-End (e2e) testing for this application is handled using Vitest (a fast test runner) and Supertest (for simulating HTTP requests to the NestJS server). This allows us to test the full request-response cycle of our API endpoints.

*Run Backend*
Start the server (dev mode):

`nest start --watch`

*Run Frontend*

`pnpm dev`

== Conclusion
Both Prisma and other ORMs (like TypeORM) are powerful tools. For this project, Prisma was chosen for its excellent developer experience, type safety, and efficient migration system based on a single schema.prisma file. While other ORMs might be suitable for simpler CRUD operations, Prisma's declarative schema and efficiency make it a strong choice for projects that are expected to grow in complexity.

== References
https://pnpm.io/id/

https://pnpm.io/id/motivation

https://vitest.dev/guide/

https://www.npmjs.com/package/supertest

https://docs.nestjs.com/

https://www.freecodecamp.org/news/what-is-an-orm-the-meaning-of-object-relational-mapping-database-tools/

https://www.prisma.io/dataguide/types/relational/what-is-an-orm

https://youtube.com/playlist?list=PLFIM0718LjIVEh_d-h5wAjsdv2W4SAtkx&si=2qILbPprntkh1FHE