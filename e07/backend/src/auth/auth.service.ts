import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../prisma.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  private generateTokens(username: string) {
    // TODO: Implement token generation
    throw new Error('Not implemented');
  }

  private async updateRefreshToken(username: string, refreshToken: string) {
    // TODO: Implement refresh token update
    throw new Error('Not implemented');
  }

  async register(registerDto: RegisterDto) {
    // TODO: Implement user registration
    throw new Error('Not implemented');
  }

  async login(loginDto: LoginDto) {
    // TODO: Implement user login
    throw new Error('Not implemented');
  }

  async refreshToken(refreshTokenDto: RefreshTokenDto) {
    // TODO: Implement token refresh
    throw new Error('Not implemented');
  }

  async logout(username: string) {
    // TODO: Implement user logout
    throw new Error('Not implemented');
  }
}
