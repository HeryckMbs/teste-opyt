import connectionSource from '@/database';
import { CategoriaEntity } from '@/entities/categoria.entity';
import { Repository } from 'typeorm';

export class CategoriaRepository {
  constructor() {
    this.setConnection();
  }
  public repository: Repository<CategoriaEntity>;
  async setConnection() {
    
    if (!connectionSource.isInitialized) {
      await connectionSource.initialize();
    }
    this.repository = connectionSource.getRepository(CategoriaEntity)
  }
}
