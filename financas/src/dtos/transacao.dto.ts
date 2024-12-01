import { Categoria } from '@/interfaces/categoria.interface';
import { User } from '@/interfaces/users.interface';
import { IsEmail, IsString, IsNotEmpty, MinLength, MaxLength, IsNumber, IsObject } from 'class-validator';

export class CreateTransacaoDto {
  @IsString()
  @IsNotEmpty()
  public descricao: string;

  @IsString()
  @IsNotEmpty()
  public tipo: string;

  @IsObject()
  @IsNotEmpty()
  public categoria: Categoria;

  @IsObject()
  @IsNotEmpty()
  public user: User;
  
  @IsNumber()
  @IsNotEmpty()
  public valor: number;
}

export class UpdateTransacaoDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(9)
  @MaxLength(32)
  public password: string;
}
