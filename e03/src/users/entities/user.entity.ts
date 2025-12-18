export class User {
    id: number;
    name: string;
    age: number;
    isAdmin: boolean;
    createdAt: string;
    updatedAt: string;
    
    constructor(id: number, name: string, age: number, isAdmin: boolean = false){
        const now = new Date().toISOString();

        this.id = id;
        this.age = age;
        this.name = name;
        this.isAdmin = isAdmin;
        this.createdAt = now;
        this.updatedAt = now;
    }
    updateTimestamp(){
        this.updatedAt = new Date().toISOString();
    }
}
