import { Injectable, ForbiddenException } from '@nestjs/common';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { PrismaService } from '../prisma.service';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) {}

  create(data: CreatePostDto, authorId: string) {
    // TODO: Implement post creation
    // - Create a new post with data and authorId
    // - Include author (username only), replyTo, and replies in the response
    // - For replyTo: include id, content, and author's username
    // - For replies: include id, content, createdAt, and author's username, ordered by createdAt asc
    throw new Error('Not implemented');
  }

  findAll() {
    // TODO: Implement finding all posts
    // - Fetch all posts from the database
    // - Include author (username only), replyTo, and replies in the response
    // - For replyTo: include id, content, and author's username
    // - For replies: include id, content, createdAt, and author's username, ordered by createdAt asc
    // - Order posts by createdAt desc
    throw new Error('Not implemented');
  }

  findOne(id: string) {
    // TODO: Implement finding a single post
    // - Find a post by its id
    // - Include author (username only), replyTo, and replies in the response
    // - For replyTo: include id, content, and author's username
    // - For replies: include id, content, createdAt, and author's username, ordered by createdAt asc
    throw new Error('Not implemented');
  }

  async update(id: string, data: UpdatePostDto, userId: string) {
    // TODO: Implement post update
    // - Find the post by id
    // - Throw ForbiddenException if post not found
    // - Verify the post belongs to the user (authorId === userId)
    // - Throw ForbiddenException if user is not the author
    // - Update the post with the new data
    // - Include author (username only), replyTo, and replies in the response
    // - For replyTo: include id, content, and author's username
    // - For replies: include id, content, createdAt, and author's username, ordered by createdAt asc
    throw new Error('Not implemented');
  }

  async remove(id: string, userId: string) {
    // TODO: Implement post deletion
    // - Find the post by id
    // - Throw ForbiddenException if post not found
    // - Verify the post belongs to the user (authorId === userId)
    // - Throw ForbiddenException if user is not the author
    // - Delete the post from the database
    throw new Error('Not implemented');
  }
}
