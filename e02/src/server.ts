import http from "node:http";
import url from "node:url";
import Database from "better-sqlite3";
import path from "node:path";


// Database setup
const dbPath = path.join(process.cwd(), "users.db");
let db: Database.Database;

// Initialize database
const initDatabase = () => {
  db = new Database(dbPath);

  db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL, 
      age INTEGER NOT NULL, 
      isAdmin BOOLEAN NOT NULL, 
      createdAt DATETIME DEFAULT CURRENT_TIMESTAMP, 
      updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // TODO: Create indexes for better performance
  db.exec(`
    CREATE INDEX IF NOT EXISTS idx_uid ON users (id);
    CREATE INDEX IF NOT EXISTS idx_uname ON users (name);
    CREATE INDEX IF NOT EXISTS idx_uage ON users (age);
  `);
};

type User = {
  id: number;
  name: string;
  age: number;
  isAdmin: boolean;
  createdAt: string;
  updatedAt: string;
};

export const createMyServer = (): http.Server => {
  // Initialize database
  initDatabase();

  const validateUser = (data: any): { valid: boolean; errors: string[] } => {
    const errors: string[] = [];
    const age = Number(data.age);
    if(!data || Object.keys(data).length === 0){
      errors.push("Request body is required")
      return { valid: false, errors };
    }

    if(!data.name || typeof data.name !== "string" || data.name.trim().length === 0){
      // console.log("Name: ", data.name, "Age: ", data.age, "Is admin?", data.isAdmin);
      errors.push("Name is required and must be a non-empty string");
    } else if(data.name.length > 100){
      errors.push("Name must be 100 characters or less");
    }

    if(data.age === undefined || data.age === null){
      errors.push("Age is required");
    }

    if((age < 0 || age > 150) || !Number.isInteger(age)){
      errors.push("Age must be a valid integer between 0 and 150")
    }

    if(typeof data.isAdmin !== "boolean"){
      errors.push("isAdmin must be a boolean value");
    }

    if(data.isAdmin === null || data.isAdmin === undefined){
      errors.push("isAdmin is required");
    }

    if (typeof data.isAdmin === "string") {
      if (data.isAdmin === "true" || data.isAdmin === "1") data.isAdmin = true;
      else if (data.isAdmin === "false" || data.isAdmin === "0") data.isAdmin = false;
    }

    return { valid: errors.length === 0, errors};
  }

  const server = http.createServer((req, res) => {
    // CORS headers
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
    res.setHeader("Access-Control-Allow-Headers", "Content-Type");

    // Handle preflight request
    if(req.method === "OPTIONS"){
      res.writeHead(200);
      res.end();
      return;
    }

    const methods = req.method;
    const parsedURL = url.parse(req.url || "", true);
    const paths = parsedURL.pathname;

    console.log(`${methods} ${paths}`);

    // READ - GET /users - get all users
    if (methods === "GET" && paths === "/users"){
      try {
        const getUsers = db.prepare ("SELECT * FROM users").all() as User[];

        const normalizedUsers = getUsers.map((u) => ({
          ...u,
          isAdmin: Boolean(u.isAdmin),
        }));
        console.log("Raw DB users:", getUsers);

        res.writeHead(200, { "content-type": "application/json" });
        res.end(JSON.stringify(normalizedUsers));
      }catch (error){
        console.log(`Database error: `, error);
        res.writeHead(500, { "content-type": "application/json" });
        res.end(JSON.stringify({ error: "Internal Server Error" }));
      }
      return;
    }

    // READ - GET /users/:id - get user by id
    if (methods === "GET" && paths?.startsWith("/users/")){
      const id = parseInt(paths.split("/")[2]);

      if(isNaN(id)){
        res.writeHead(400, {"content-type": "application/json"});
        res.end(JSON.stringify({ error: "Invalid user ID" }));
        return;
      }

      try{
        const user = db.prepare("SELECT * FROM users WHERE id = ?").get(id) as User | undefined;
        if(user){
          user.isAdmin = Boolean(user.isAdmin);
          res.writeHead(200, { "content-type": "application/json" });
          res.end(JSON.stringify(user));
        }else{
            res.writeHead(404, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "User not found" }));
          }
      }catch (error){
        res.writeHead(500, { "content-type": "application/json" });
        res.end(JSON.stringify({ error: "Internal Server Error" }));
      }
      return;
    }

    // Create - POST /users
    if(methods === "POST" && paths?.startsWith("/users")){
      let body = "";

      req.on("data", (chunk) => {
        body += chunk.toString();
      });

      req.on("end", () => {
        try{
          const data = body ? JSON.parse(body) : {};
          console.log("JSON parsed: ", data);
          const validation = validateUser(data);
          if(!validation.valid){
            res.writeHead(400, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Validation failed", details: validation.errors, }));
            return;
          }
          const isAdminValue = data.isAdmin === true || data.isAdmin === "true" || data.isAdmin === "1" ? 1 : 0;

          console.log("Inserting user: ", data.name, data.age, isAdminValue);
          const now = new Date().toISOString();
          const result = db.prepare("INSERT INTO users (name, age, isAdmin, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)").run(data.name.trim(), data.age, isAdminValue, now, now);

          const newUser = {
            id: result.lastInsertRowid as number,
            name: data.name.trim(),
            age: data.age,
            isAdmin: Boolean(isAdminValue),
            createdAt: now,
            updatedAt: now
          };

          res.writeHead(201, { "content-type": "application/json" });
          res.end(JSON.stringify(newUser));
        }catch (error){
          if(error instanceof SyntaxError){
            res.writeHead(400, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Invalid JSON" }));
          }else{
            console.log("Database error: ", error);
            res.writeHead(500, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Internal Server Error" }));
          }
        }
      });
      return;
    }

    // UPDATE - PUT /users/:id
    if(methods === "PUT" && paths?.startsWith("/users/")){
      const id = parseInt(paths.split("/")[2]);

      // Validate id
      if(isNaN(id)){
        res.writeHead(400, { "content-type": "application/json" });
        res.end(JSON.stringify({ error: "Invalid user ID" }));
        return;
      }

      let body = "";

      req.on("data", (chunk) => {
        body += chunk.toString();
      });

      req.on("end", () => {
        try{
          // Check if the user exists
          const existUser = db.prepare("SELECT * FROM users WHERE id = ?").get(id) as User | undefined;

          if(!existUser){
            res.writeHead(404, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "User not found" }));
            return;
          }

          const data = body ? JSON.parse(body) : undefined;
          const validation = validateUser(data);

          if(!validation.valid){
            res.writeHead(400, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Validation failed", details: validation.errors }));
            return;
          }
          const isAdminValue = data.isAdmin === true || data.isAdmin === "true" || data.isAdmin === "1" ? 1 : 0;


          db.prepare("UPDATE users SET name = ?, age = ?, isAdmin = ?, updatedAt = ? WHERE id = ?").run(data.name.trim(), data.age, isAdminValue, new Date().toISOString(), id);

          const updatedUser = {
            id: id,
            name: data.name.trim(),
            age: data.age, 
            isAdmin: Boolean(isAdminValue),
            createdAt: existUser.createdAt,
            updatedAt: new Date().toISOString()
          };

          res.writeHead(200, { "content-type": "application/json" });
          res.end(JSON.stringify(updatedUser));
        }catch (error){
          if(error instanceof SyntaxError){
            res.writeHead(400, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Invalid JSON" }));
          }else{
            res.writeHead(500, { "content-type": "application/json" });
            res.end(JSON.stringify({ error: "Internal Server Error" }));
          }
        }
      });
      
      return;
    }

    // DELETE - DELETE /users/:id
    if(methods === "DELETE" && paths?.startsWith("/users/")){
      const id = parseInt(paths.split("/")[2]);

      if(isNaN(id)){
        res.writeHead(400, { "content-type": "application/json" });
        res.end(JSON.stringify({ error: "Invalid user ID" }));
        return;
      }

      try{
        const data = db.prepare("SELECT * FROM users WHERE id = ?").get(id) as User | undefined;

        if(data){
          db.prepare("DELETE FROM users WHERE id = ?").run(id);
          res.writeHead(200, { "content-type": "application/json" });
          res.end(
            JSON.stringify({ message: "User deleted", user: { ...data, isAdmin: Boolean(data.isAdmin) }, })
          );
        }else{
          res.writeHead(404, { "content-type": "application/json" });
          res.end(JSON.stringify({ error: "User not found" }));
        }
      }catch (error){
        console.log("Database error: ", error);
        res.writeHead(500, {"content-type": "application/json"});
        res.end(JSON.stringify({ error: "Internal server error" }));
      }
      return;
    }

    res.writeHead(404, { "content-type": "application/json" });
    res.end(JSON.stringify({ error: "Not found" }))
  });

  return server;
};

export const resetMyServerData = () => {
  try {
    if (db) {
      db.prepare("DELETE FROM users").run();
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'users'").run();
      console.log("Database reset completed");
    }
  } catch (error) {
    console.error("Error resetting database:", error);
  }
};

// Clean up database connection on process exit
process.on("exit", () => {
  if (db) {
    db.close();
  }
});

process.on("SIGINT", () => {
  if (db) {
    db.close();
  }
  process.exit(0);
});

process.on("SIGTERM", () => {
  if (db) {
    db.close();
  }
  process.exit(0);
});
