import { IsNotEmpty } from 'class-validator';
import { BaseEntity, Entity, PrimaryGeneratedColumn, Column, Unique, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { Categoria } from '@/interfaces/categoria.interface';
import { TransacaoEntity } from './transacao.entity';

@Entity('categorias')
export class CategoriaEntity extends BaseEntity implements Categoria  {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsNotEmpty()
  nome: string;

  @Column()
  @IsNotEmpty()
  tipo: string;

  
  @Column()
  @CreateDateColumn()
  created_at: Date;

  @Column()
  @UpdateDateColumn()
  updated_at: Date;


  @OneToMany(() => TransacaoEntity,(entity) => entity.categoria, { onDelete: 'RESTRICT' })
  transacoes?: TransacaoEntity;

}
