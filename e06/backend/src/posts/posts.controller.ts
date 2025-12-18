import { Controller, Get, Param, Post, Body, Delete, Put } from '@nestjs/common';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';

@Controller('posts')
export class PostsController {
  constructor(private readonly postservice: PostsService) {}

  @Get()
  findAll() {
    return this.postservice.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.postservice.findOne(id);
  }

  @Post()
  create(@Body() createPostDto: CreatePostDto) {
    return this.postservice.create(createPostDto);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updatePostDto: UpdatePostDto) {
    return this.postservice.update(updatePostDto, id);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.postservice.remove(id);
  }
}
