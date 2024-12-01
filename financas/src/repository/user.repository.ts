import connectionSource from '@/database';
import { UserEntity } from '@/entities/users.entity';
import { Repository } from 'typeorm';

export class UserRepository {
  constructor() {
    this.setConnection();
  }
  public repository: Repository<UserEntity>;
  async setConnection() {
    if (!connectionSource.isInitialized) {
      await connectionSource.initialize();
    }
    this.repository = connectionSource.getRepository(UserEntity)

  }
}
