import { IsNotEmpty, IsNumber, IsString, MinLength } from "class-validator";

export class CreatePostDto {
  @IsNotEmpty()
  @IsString()
  @MinLength(2)
  title: string;
  
  @IsNotEmpty()
  @IsString()
  @MinLength(2)
  content: string;

  @IsNotEmpty()
  @IsNumber()
  authorId: number;
}
