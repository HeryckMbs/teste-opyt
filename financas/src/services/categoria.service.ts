import { EntityRepository } from 'typeorm';
import {  Service } from 'typedi';
import { HttpException } from '@/exceptions/httpException';
import { Categoria } from '@/interfaces/categoria.interface';
import { CategoriaEntity } from '@/entities/categoria.entity';
import { CategoriaRepository } from '@/repository/category.repository';

@Service()
@EntityRepository()
export class CategoriaService {
  private repositoryClass: CategoriaRepository;
  constructor() {
    this.repositoryClass = new CategoriaRepository();
  }
  public async findAllCategoria(tipo: String): Promise<Categoria[]> {
    let whereClause: any = {
      where: {
        tipo,
      },
    };
    if (tipo == undefined || tipo == '') {
      whereClause = {};
    }
    const categorias: CategoriaEntity[] = await this.repositoryClass.repository.find(whereClause);
    return categorias;
  }

  public async findCategoriaById(categoriaId: number): Promise<Categoria> {
    const categoria: Categoria = await this.repositoryClass.repository.findOne({ where: { id: categoriaId } });
    if (!categoria) throw new HttpException(409, "User doesn't exist");

    return categoria;
  }

  //   public async createUser(userData: User): Promise<User> {
  //     const findUser: User = await UserEntity.findOne({ where: { email: userData.email } });
  //     if (findUser) throw new HttpException(409, `This email ${userData.email} already exists`);

  //     const hashedPassword = await hash(userData.password, 10);
  //     const createUserData: User = await UserEntity.create({ ...userData, password: hashedPassword }).save();

  //     return createUserData;
  //   }

  //   public async updateUser(userId: number, userData: User): Promise<User> {
  //     const findUser: User = await UserEntity.findOne({ where: { id: userId } });
  //     if (!findUser) throw new HttpException(409, "User doesn't exist");

  //     const hashedPassword = await hash(userData.password, 10);
  //     await UserEntity.update(userId, { ...userData, password: hashedPassword });

  //     const updateUser: User = await UserEntity.findOne({ where: { id: userId } });
  //     return updateUser;
  //   }

  //   public async deleteUser(userId: number): Promise<User> {
  //     const findUser: User = await UserEntity.findOne({ where: { id: userId } });
  //     if (!findUser) throw new HttpException(409, "User doesn't exist");

  //     await UserEntity.delete({ id: userId });
  //     return findUser;
  //   }
}
