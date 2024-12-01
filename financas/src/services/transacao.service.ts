import { EntityRepository, Repository } from 'typeorm';
import { Service } from 'typedi';
import { HttpException } from '@/exceptions/httpException';
import { Between } from 'typeorm';

import { TransacaoEntity } from '@/entities/transacao.entity';
import { Transacao } from '@/interfaces/transacao.interface';
import { TransacaoRepository } from '@/repository/transacao.repository';
import { formatarDataParaBanco } from '@/utils/formatter';

@Service()
@EntityRepository()
export class TransacaoService {
  private repositoryClass: TransacaoRepository;
  constructor() {
    this.repositoryClass = new TransacaoRepository();
  }

  public async getAllTransacao(idUser: number, dtInicio: string, dtFim: string, categoria: number | null, ordenacao: string): Promise<Transacao[]> {
    const dataInicio = formatarDataParaBanco(dtInicio);
    const dataFim = formatarDataParaBanco(dtFim);
    const whereCategoria = categoria != 0 ? { categoria: { id: categoria } } : undefined;
    let orderClause = {};
    let order = ''
    if(['valor_desc','data_desc'].includes(ordenacao)){
      order = 'DESC';
    }else{
      order = 'ASC';
    }

    if(['valor_desc','valor_asc'].includes(ordenacao)){
      orderClause['valor'] = order;
    }else{
      orderClause['competencia'] = order;
    }
    console.log(orderClause);
    const transacaos: TransacaoEntity[] = await this.repositoryClass.repository.find({
      relations: {
        categoria: true,
      },
      where: {
        user: {
          id: idUser,
        },
        competencia: Between(dataInicio, dataFim),
        ...whereCategoria,
      },
      order: orderClause
    });
    return transacaos;
  }

  public async getSaldoReceitaDespesaAno(idUser: number, ano: number): Promise<Object> {
    try {
      const totalReceitasPorMes = await this.repositoryClass.repository
        .createQueryBuilder('transacaoes')
        .select('MONTH(transacaoes.competencia)', 'mes')
        .addSelect('SUM(transacaoes.valor)', 'valor')
        .where('transacaoes.tipo = :tipo', { tipo: 'receita' })
        .andWhere('transacaoes.user_id = :idUser', { idUser })
        .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })
        .groupBy('mes')
        .orderBy('mes', 'ASC')
        .getRawMany();
      const totalDespesasPorMes = await this.repositoryClass.repository
        .createQueryBuilder('transacaoes')
        .select('MONTH(transacaoes.competencia)', 'mes')
        .addSelect('SUM(transacaoes.valor)', 'valor')
        .where('transacaoes.tipo = :tipo', { tipo: 'despesa' })
        .andWhere('transacaoes.user_id = :idUser', { idUser })
        .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })
        .groupBy('mes')
        .orderBy('mes', 'ASC')
        .getRawMany();

      return {
        despesas: totalDespesasPorMes,
        receitas: totalReceitasPorMes,
      };
    } catch (e) {
      console.log(e);
      return [];
    }
  }

  public async getTransacaoCategory(idUser: number, ano: number): Promise<Object[]> {
    try {
  
      const result = await this.repositoryClass.repository
        .createQueryBuilder('transacaoes')
        .leftJoin('transacaoes.categoria', 'categoria')
        .select('categoria.nome', 'categoria')
        .addSelect('SUM(transacaoes.valor)', 'valor')
        .addSelect(`SUM(transacaoes.valor) / (SELECT SUM(valor) FROM transacaoes WHERE user_id = :idUser) * 100`, 'percentual')
        .where('transacaoes.user_id = :idUser', { idUser })
        .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })
        .groupBy('categoria.id')
        .getRawMany();

      return result;
    } catch (e) {
      console.log(e);
      return [];
    }
  }

  public async getTransacaoById(transacaoId: number): Promise<Transacao> {
    const transacao: Transacao = await this.repositoryClass.repository.findOne({ where: { id: transacaoId } });
    if (!transacao) throw new HttpException(409, "User doesn't exist");

    return transacao;
  }

  public async createTransacao(transacaoData: Transacao): Promise<Transacao> {
    const createTransacaoData: Transacao = await this.repositoryClass.repository
      .create({
        ...transacaoData,

        competencia: new Date(formatarDataParaBanco(transacaoData.competencia as string)),
      })
      .save();
    return createTransacaoData;
  }

  public async getSaldo(userId: Number, ano: number): Promise<Number> {
    const saldo: Number = await this.repositoryClass.repository
      .createQueryBuilder('transacaoes')
      .select("SUM(CASE WHEN tipo = 'receita' THEN valor ELSE 0 END) - SUM(CASE WHEN tipo = 'despesa' THEN valor ELSE 0 END)", 'saldo')
      .where('transacaoes.user_id = :userId', { userId })
      .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })

      .getRawOne();
    return saldo;
  }

  public async getSaldoReceita(userId: Number, ano: number): Promise<Number> {
    const saldo: Number = await this.repositoryClass.repository
      .createQueryBuilder('transacaoes')
      .select("SUM(CASE WHEN tipo = 'receita' THEN valor ELSE 0 END)", 'totalReceitas')
      .where('transacaoes.user_id = :userId', { userId })
      .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })

      .getRawOne();
    return saldo;
  }

  public async getSaldoDespesas(userId: Number, ano: number): Promise<Number> {
    const saldo: Number = await this.repositoryClass.repository
      .createQueryBuilder('transacaoes')
      .select("SUM(CASE WHEN tipo = 'despesa' THEN valor ELSE 0 END)", 'totalDespesas')
      .where('transacaoes.user_id = :userId', { userId })
      .andWhere('YEAR(transacaoes.competencia) = :ano', { ano: ano })

      .getRawOne();
    return saldo;
  }
}
