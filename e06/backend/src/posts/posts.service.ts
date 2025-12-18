import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) {}
  async findAll() {
    return await this.prisma.post.findMany({
      where: {
        replyToId: null,
      },
      orderBy: {
        createdAt: 'desc',
      },
      include:{
        replies: true,
        _count: {
          select: {
            replies: true,
          }
        }
      }
    });
  }

  async findOne(id: string) {
    return await this.prisma.post.findUnique({
      where: { id },
      include: {
        replies: true,
        replyTo: true,
      }
    });
  }

  async create(data: CreatePostDto){
    return await this.prisma.post.create({
      data,
    });
  }

  async update(data: UpdatePostDto, id: string) {
    return await this.prisma.post.update({
      where: { id },
      data,
    });
  }

  async remove(id: string) {
    return await this.prisma.post.delete({
      where: { id },
    });
  }
}
