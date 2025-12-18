import { Transform } from "class-transformer";
import { IsNotEmpty, IsNumber, IsString, MinLength } from "class-validator";

export class CreatePostDto {
    @IsNotEmpty()
    @IsString()
    title: string;

    @IsNotEmpty()
    @IsString()
    content: string;

    @IsNotEmpty()
    @IsNumber()
    // @Transform(({ value }) => parseInt(value))
    authorId: number; 
}
