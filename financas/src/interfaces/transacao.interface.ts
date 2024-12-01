import { CategoriaEntity } from "@/entities/categoria.entity";
import { UserEntity } from "@/entities/users.entity";

export interface Transacao {
    id?: number;
    valor: number,
    descricao: string;
    tipo:string;
    categoria: CategoriaEntity;
    user: UserEntity;
    competencia:string|Date;
  }
  