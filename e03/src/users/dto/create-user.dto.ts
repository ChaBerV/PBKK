import { IsString, IsNotEmpty, MaxLength, IsNumber, Min, max, Max, IsBoolean } from 'class-validator';
export class CreateUserDto {
    @IsString({ message: 'Name must be a string' })
    @IsNotEmpty({ message: 'Name is required and must be a non-empty string' })
    @MaxLength(100, { message: 'Name must be 100 characters or less' })
    name: string;

    // Age must be a number
    @IsNumber({}, { message: 'Age must be a number' })
    // Age is between 0 and 150
    @Min(0, { message: 'Age must be between 0 and 150' })
    @Max(150, { message: 'Age must be between 0 and 150' })
    age: number;

    @IsBoolean({ message: 'isAdmin must be a boolean value' })
    isAdmin: boolean = false;
}
