import { INestApplication, ValidationPipe } from "@nestjs/common";

export function initApp(app: INestApplication<any>){
    app.enableCors();
    app.useGlobalPipes(new ValidationPipe({}));
}