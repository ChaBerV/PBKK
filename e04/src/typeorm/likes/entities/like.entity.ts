import { Post } from '../../posts/entities/post.entity';
import { User } from '../../users/entities/user.entity';
import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity('likes')
export class Like {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, (user) => user.likes, {onDelete: 'CASCADE'})
  @JoinColumn({ name: 'userId' })
  user: User;

  @ManyToOne(() => Post, (post) => post.likes, {onDelete: 'CASCADE'})
  @JoinColumn({ name: 'postId' })
  post: Post;

  @Column()
  userId: number;

  @Column()
  postId: number;
}
