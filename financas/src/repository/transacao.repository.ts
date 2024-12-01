import connectionSource from '@/database';
import { TransacaoEntity } from '@/entities/transacao.entity';
import { Repository } from 'typeorm';

export class TransacaoRepository {
  constructor() {
    this.setConnection();
  }
  public repository: Repository<TransacaoEntity>;
  async setConnection() {
    if (!connectionSource.isInitialized) {
      await connectionSource.initialize();
    }
    this.repository = connectionSource.getRepository(TransacaoEntity)
  }
}
