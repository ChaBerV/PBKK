import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';
import { error } from 'console';
import { iterator } from 'rxjs/internal/symbol/iterator';

@Injectable()
export class UsersService {
  private users: User[] = [];
  private nextId = 1;
  

  private checkNan(id: number){
    if(isNaN(id)){
      throw new BadRequestException({ error: 'Bad Request' });
    }
  }
  

  create(createUserDto: CreateUserDto): User {
    const newUser = new User(
      this.nextId++,
      createUserDto.name.trim(),
      createUserDto.age,
      createUserDto.isAdmin,
    );

    this.users.push(newUser);
    return newUser;
  }

  findAll(): User[] {
    return this.users;
  }

  findOne(id: number): User {
    this.checkNan(id);
    const user = this.users.find((user) => user.id === id);

    if(!user){
      throw new NotFoundException({ error: 'User not found' });
    }
    return user;
  }

  update(id: number, updateUserDto: UpdateUserDto): User {
    this.checkNan(id);
    const userIndex = this.users.findIndex((user) => user.id === id);

    if(userIndex === -1){
      throw new NotFoundException({ error: 'User not found' });
    }
    let user = this.users[userIndex];

    if(updateUserDto.name !== undefined){
      user.name = updateUserDto.name.trim();
    }

    if(updateUserDto.age !== undefined){
      user.age = updateUserDto.age;
    }

    if(updateUserDto.isAdmin !== undefined){
      user.isAdmin = updateUserDto.isAdmin;
    }
    user.updatedAt = new Date().toISOString();
    
    return user;
  }

  remove(id: number): { message: string, user: User} {
    this.checkNan(id);
    const userIndex = this.users.findIndex((user) => user.id === id);

    if(userIndex === -1){
      throw new NotFoundException({ error: 'User not found' });
    }

    const deleteUser = this.users.splice(userIndex, 1)[0];
    return { message: 'User deleted', user: deleteUser };
  }

  resetData(): void{
    this.users = [];
    this.nextId = 1;
  }
}
