import { Router } from 'express';
import { UserController } from '@controllers/users.controller';
import { CreateUserDto } from '@dtos/users.dto';
import { Routes } from '@interfaces/routes.interface';
import { ValidationMiddleware } from '@middlewares/validation.middleware';
import { AuthMiddleware } from '@/middlewares/auth.middleware';
import { CategoriaController } from '@/controllers/categoria.controller';

export class CategoriaRoute implements Routes {
  public path = '/categorias';
  public router = Router();
  public controller = new CategoriaController();

  constructor() {
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get(`${this.path}`,AuthMiddleware, this.controller.getCategorias);
    this.router.get(`${this.path}/:id(\\d+)`,AuthMiddleware, this.controller.getCategoriaById);

  }
}
