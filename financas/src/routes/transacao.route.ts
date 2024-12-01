import { Router } from 'express';
import { Routes } from '@interfaces/routes.interface';
import { ValidationMiddleware } from '@middlewares/validation.middleware';
import { AuthMiddleware } from '@/middlewares/auth.middleware';
import { TransacaoController } from '@/controllers/transacao.controller';
import { CreateTransacaoDto } from '@/dtos/transacao.dto';

export class TransacaoRoute implements Routes {
  public path = '/transacao';
  public router = Router();
  public controller = new TransacaoController();

  constructor() {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post(`${this.path}`, AuthMiddleware, ValidationMiddleware(CreateTransacaoDto), this.controller.
    createTransacao);
    this.router.get(`${this.path}`,AuthMiddleware, this.controller.getTransacaos);
    this.router.get(`${this.path}/saldo-total/:id`,AuthMiddleware, this.controller.getSaldoTransacao);
    this.router.get(`${this.path}/findTransacaoCategory`,AuthMiddleware, this.controller.findTransacaoCategory);
    this.router.get(`${this.path}/find-saldo-anual`,AuthMiddleware, this.controller.getSaldoReceitaDespesaAno);
    
    this.router.get(`${this.path}/saldo-despesa/:id`, this.controller.getSaldoDespesa);
    this.router.get(`${this.path}/saldo-receita/:id`, this.controller.getSaldoReceita);
  }
}
