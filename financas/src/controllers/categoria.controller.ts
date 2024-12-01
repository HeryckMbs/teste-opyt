import { NextFunction, Request, Response } from 'express';
import { Container } from 'typedi';

import { CategoriaService } from '@/services/categoria.service';
import { Categoria } from '@/interfaces/categoria.interface';

export class CategoriaController {
  public service = Container.get(CategoriaService);

  public getCategorias = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        const tipo = String(req.query.tipo);

      const categorias: Categoria[] = await this.service.findAllCategoria(tipo);

      res.status(200).json({ data: categorias, message: 'findAll' });
    } catch (error) {
      next(error);
    }
  };

  public getCategoriaById = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const categoriaId = Number(req.params.id);
      const categoria: Categoria = await this.service.findCategoriaById(categoriaId);

      res.status(200).json({ data: categoria, message: 'findOne' });
    } catch (error) {
      next(error);
    }
  };

}
