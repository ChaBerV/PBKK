import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { initApp } from './app.init';
import * as express from 'express'

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  initApp(app);
  app.use(express.json());
  await app.listen(process.env.PORT ?? 3000);
  console.log("Application is running on: http://localhost:" + (process.env.PORT ?? 3000));
}
bootstrap();
