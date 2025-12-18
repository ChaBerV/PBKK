import { IsNotEmpty, IsNumber } from "class-validator";

export class CreateLikeDto {
  @IsNotEmpty()
  @IsNumber()
  userId: number;

  @IsNumber()
  @IsNotEmpty()
  postId: number;
}
