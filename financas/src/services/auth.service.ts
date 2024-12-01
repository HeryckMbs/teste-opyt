import { compare, hash } from 'bcrypt';
import { sign } from 'jsonwebtoken';
import {  Service,  } from 'typedi';
import { EntityRepository } from 'typeorm';
import { SECRET_KEY } from '@config';
import { HttpException } from '@/exceptions/httpException';
import { DataStoredInToken, TokenData } from '@interfaces/auth.interface';
import { User } from '@interfaces/users.interface';
import { UserRepository } from '@/repository/user.repository';


const createToken = (user: User): TokenData => {
  const dataStoredInToken: DataStoredInToken = { id: user.id };
  const secretKey: string = SECRET_KEY;
  const expiresIn: number = 60 * 60;

  return { expiresIn, token: sign(dataStoredInToken, secretKey, { expiresIn }) };
}




@Service()
@EntityRepository()
export class AuthService  {
  private repositoryClass: UserRepository
 
  constructor(){
    this.repositoryClass = new UserRepository();
  }
  public async signup(userData: User): Promise<User> {
    const findUser: User = await this.repositoryClass.repository.findOne({ where: { email: userData.email } });
    if (findUser) throw new HttpException(409, `Email ${userData.email} já existe`);

    const hashedPassword = await hash(userData.password, 10);
    const createUserData: User = await  this.repositoryClass.repository.create({ ...userData, password: hashedPassword }).save();
    return createUserData;
  }

  public async login(userData: User): Promise<Object> {
    const findUser: User = await  this.repositoryClass.repository.findOne({
      where: { email: userData.email }, });
    if (!findUser) throw new HttpException(409, `Email ${userData.email} não encontrado`);

    const isPasswordMatching: boolean = await compare(userData.password, findUser.password);
    if (!isPasswordMatching) throw new HttpException(409, "Senha incorreta");

    const tokenData = createToken(findUser);

    return {
      ...tokenData,
      id:findUser.id,
      name: findUser.name
    };
  }

  public async logout(userData: User): Promise<User> {
    const findUser: User = await  this.repositoryClass.repository.findOne({ where: { email: userData.email, password: userData.password } });
    if (!findUser) throw new HttpException(409, "Usuário não existe");

    return findUser;
  }
}
