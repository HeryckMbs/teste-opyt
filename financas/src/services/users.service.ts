import { hash } from 'bcrypt';
import { EntityRepository, Repository } from 'typeorm';
import { Service } from 'typedi';
import { HttpException } from '@/exceptions/httpException';
import { User } from '@interfaces/users.interface';
import { UserRepository } from '@/repository/user.repository';

@Service()
@EntityRepository()
export class UserService {
  private repositoryClass: UserRepository;

  constructor() {
    this.repositoryClass = new UserRepository();
  }
  public async findAllUser(): Promise<User[]> {
    const users: User[] = await this.repositoryClass.repository.find();
    return users;
  }

  public async findUserById(userId: number): Promise<User> {
    const findUser: User = await this.repositoryClass.repository.findOne({ where: { id: userId } });
    if (!findUser) throw new HttpException(409, "Usuário não existe");

    return findUser;
  }

  public async createUser(userData: User): Promise<User> {
    const findUser: User = await this.repositoryClass.repository.findOne({ where: { email: userData.email } });
    if (findUser) throw new HttpException(409, `Email ${userData.email} já registrado`);

    const hashedPassword = await hash(userData.password, 10);
    const createUserData: User = await this.repositoryClass.repository.create({ ...userData, password: hashedPassword }).save();

    return createUserData;
  }

  public async updateUser(userId: number, userData: User): Promise<User> {
    const findUser: User = await this.repositoryClass.repository.findOne({ where: { id: userId } });
    if (!findUser) throw new HttpException(409, "Usuário não existe");

    const hashedPassword = await hash(userData.password, 10);
    await this.repositoryClass.repository.update(userId, { ...userData, password: hashedPassword });

    const updateUser: User = await this.repositoryClass.repository.findOne({ where: { id: userId } });
    return updateUser;
  }

  public async deleteUser(userId: number): Promise<User> {
    const findUser: User = await this.repositoryClass.repository.findOne({ where: { id: userId } });
    if (!findUser) throw new HttpException(409, "Usuário não existe");

    await this.repositoryClass.repository.delete({ id: userId });
    return findUser;
  }
}
