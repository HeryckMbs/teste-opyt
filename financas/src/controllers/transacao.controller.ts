import { Transacao } from '@/interfaces/transacao.interface';
import { TransacaoService } from '@/services/transacao.service';
import { NextFunction, Request, Response } from 'express';
import { Container } from 'typedi';

export class TransacaoController {
  public service = Container.get(TransacaoService);

  public getTransacaos = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const user = parseInt(req.query.user as string);
      const dtInicio = req.query.dtInicio as string;
      const dtFim = req.query.dtFim as string;
      const ordenacao = req.query.ordenacao as string;

      const categoria = req.query.categoria != null ? parseInt(req.query.categoria as string) : null;
      const transacoes: Transacao[] = await this.service.getAllTransacao(user, dtInicio, dtFim, categoria,ordenacao);

      res.status(200).json({ data: transacoes, message: 'findAll' });
    } catch (error) {
      next(error);
    }
  };

  public findTransacaoCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const user = parseInt(req.query.user as string);
      const ano = parseInt(req.query.ano as string);
      const transacoes = await this.service.getTransacaoCategory(user,ano);

      res.status(200).json({ data: transacoes, message: 'findAll' });
    } catch (error) {
      next(error);
    }
  };

  public getSaldoReceitaDespesaAno = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const user = parseInt(req.query.user as string);
      const ano = parseInt(req.query.ano as string);

      const transacoes = await this.service.getSaldoReceitaDespesaAno(user, ano);

      res.status(200).json({ data: transacoes, message: 'findAll' });
    } catch (error) {
      next(error);
    }
  };

  public getTransacaoById = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const categoriaId = Number(req.params.id);
      const categoria: Transacao = await this.service.getTransacaoById(categoriaId);

      res.status(200).json({ data: categoria, message: 'findOne' });
    } catch (error) {
      next(error);
    }
  };

  public createTransacao = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const transacaoData: Transacao = req.body;
      const transacao: Transacao = await this.service.createTransacao(transacaoData);

      res.status(201).json({ data: transacao, message: 'created' });
    } catch (error) {
      next(error);
    }
  };
  public getSaldoTransacao = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = Number(req.params.id);
      const ano = parseInt(req.query.ano as string);

      const saldo: Number = await this.service.getSaldo(userId,ano);

      res.status(201).json({ data: saldo, message: 'saldoTotal' });
    } catch (error) {
      console.log(error);
      next(error);
    }
  };
  public getSaldoReceita = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = Number(req.params.id);
      const ano = parseInt(req.query.ano as string);

      const saldo: Number = await this.service.getSaldoReceita(userId,ano);

      res.status(201).json({ data: saldo, message: 'saldoTotal' });
    } catch (error) {
      next(error);
    }
  };
  public getSaldoDespesa = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = Number(req.params.id);
      const ano = parseInt(req.query.ano as string);

      const saldo: Number = await this.service.getSaldoDespesas(userId,ano);

      res.status(201).json({ data: saldo, message: 'saldoTotal' });
    } catch (error) {
      next(error);
    }
  };
}
