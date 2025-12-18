import Database from 'better-sqlite3';
import { Injectable } from '@nestjs/common';

@Injectable()
export class DatabaseService {
  private db: Database.Database;

  constructor() {
    this.db = new Database('user.db');
    this.initDB();
  }

  private initDB() {
    this.db.exec(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        isAdmin BOOLEAN NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    `);

    this.db.exec(`
      CREATE INDEX IF NOT EXISTS idx_uid ON users (id);
      CREATE INDEX IF NOT EXISTS idx_uname ON users (name);
      CREATE INDEX IF NOT EXISTS idx_uage ON users (age);
    `);
  }

  resetData() {
    this.db.exec(`DELETE FROM users`);
    this.db.exec(`DELETE FROM sqlite_sequence WHERE name='users'`);
  }
}
