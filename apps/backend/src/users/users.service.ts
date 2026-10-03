import { ConflictException, Injectable, NotFoundException } from "@nestjs/common";
import { Prisma } from "@files-system/database";
import * as bcrypt from "bcryptjs";
import { PrismaService } from "../prisma/prisma.service";
import { CreateUserDto } from "./dto/create-user.dto";

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateUserDto) {
    try {
      return await this.prisma.user.create({
        data: {
          email: dto.email,
          firstName: dto.firstName,
          lastName: dto.lastName,
          passwordHash: await bcrypt.hash(dto.password, 10),
          status: "ACTIVE", // use the same value your seeders use
        },
        omit: { passwordHash: true },
      });
    } catch (e) {
      if (
        e instanceof Prisma.PrismaClientKnownRequestError &&
        e.code === "P2002"
      ) {
        throw new ConflictException("Email already in use");
      }
      throw e;
    }
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({
      where: { userId: id },
      omit: { passwordHash: true }
    });
    if (!user) throw new NotFoundException(`User ${id} not found`);
    return user;
  }
}