import { BadRequestException, Module } from '@nestjs/common';
import { UploadController } from './upload.controller';
import { MulterModule } from '@nestjs/platform-express';
import multer from 'multer';
import { extname } from 'path';

@Module({
  imports: [
    MulterModule.register({
      storage: multer.diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
          const extn = extname(file.originalname);
          cb(null, `${file.fieldname}-${uniqueSuffix}${extn}`);
        },
      }),
      fileFilter: (req, file, cb) => {
        if(!file.mimetype.match(/\/(jpg|jpeg|png|gif|webp)$/)){
          return cb(new BadRequestException('Only image files are allowed!'), false);
        }
        cb(null, true);
      },
      limits: { fileSize: 5 * 1024 * 1024 },
    }),
  ],
  controllers: [UploadController],
})
export class UploadModule {}
