import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateLikeDto } from './dto/create-like.dto';
import { UpdateLikeDto } from './dto/update-like.dto';
import { Like } from './entities/like.entity';
import { User } from '../users/entities/user.entity';
import { Post } from '../posts/entities/post.entity';

@Injectable()
export class LikesService {
  constructor(
    @InjectRepository(Like)
    private readonly likeRepository: Repository<Like>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Post)
    private readonly postrepository: Repository<Post>,
  ) {}

  async create(createLikeDto: CreateLikeDto): Promise<Like> {
    const user = await this.userRepository.findOneBy({ id: createLikeDto.userId });
    const post = await this.postrepository.findOneBy({ id: createLikeDto.postId });

    if(!user || !post){
      throw new NotFoundException(`User or Post not found`);
    }

    const like = await this.likeRepository.create(createLikeDto);
    return await this.likeRepository.save(like);
  }

  async findAll(): Promise<Like[]> {
    return await this.likeRepository.find({ relations: ['post'], });
  }

  async findOne(id: number): Promise<Like> {
    const like = await this.likeRepository.findOne({
      where: {id},
      relations: ['user', 'post'],
    })

    if(!like){
      throw new NotFoundException(`Like not found`);
    }

    return like;
  }

  async update(id: number, updateLikeDto: UpdateLikeDto): Promise<Like> {
    const like = await this.findOne(id);

    if(updateLikeDto.userId){
      const user = await this.userRepository.findOneBy({ id: updateLikeDto.userId });
      if(!user){
        throw new NotFoundException(`User not found`);
      }
      like.user = user;
    }

    if(updateLikeDto.postId){
      const post = await this.postrepository.findOneBy({ id: updateLikeDto.postId });
      if(!post){
        throw new NotFoundException(`Post not found`);
      }
      like.post = post
    }

    return this.likeRepository.save(like);
  }

  async remove(id: number): Promise<void> {
    const del = await this.findOne(id);
    await this.likeRepository.remove(del);
  }
}
