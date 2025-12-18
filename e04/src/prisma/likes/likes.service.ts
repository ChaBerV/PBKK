import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreateLikeDto } from './dto/create-like.dto';
import { UpdateLikeDto } from './dto/update-like.dto';
import { connect } from 'http2';

@Injectable()
export class LikesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createLikeDto: CreateLikeDto) {
    return this.prisma.like.create({
      data: {
        user: { connect: {id: createLikeDto.userId} },
        post: { connect: {id: createLikeDto.postId} },
      }, 
    });
  }

  async findAll() {
    return this.prisma.like.findMany({
      include: {
        user: true,
        post: true,
      },
    });
  }

  async findOne(id: number) {
    return this.prisma.like.findUnique({
      where: { id },
      include: {
        user: true,
        post: true,
      },
    });
  }

  async update(id: number, updateLikeDto: UpdateLikeDto) {
    return this.prisma.like.update({
      where: { id },
      data: {
        ...(updateLikeDto.userId && {
          user: { connect: {id: updateLikeDto.userId} },
        }),
        ...(updateLikeDto.postId && {
          post: { connect: {id: updateLikeDto.postId} },
        }),
      },
    });
  }

  async remove(id: number) {
    return this.prisma.like.delete({
      where: { id },
    });
  }
}
