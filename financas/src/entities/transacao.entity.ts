import { IsNotEmpty } from 'class-validator';
import { BaseEntity, Entity, PrimaryGeneratedColumn, Column, Unique, CreateDateColumn, UpdateDateColumn, OneToOne, JoinColumn } from 'typeorm';
import { User } from '@interfaces/users.interface';
import { CategoriaEntity } from './categoria.entity';
import { Transacao } from '@/interfaces/transacao.interface';
import { UserEntity } from './users.entity';

@Entity('transacaoes')
export class TransacaoEntity extends BaseEntity implements Transacao  {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsNotEmpty()
  valor: number;

  @Column()
  @IsNotEmpty()
  descricao: string;

  @Column()
  @IsNotEmpty()
  tipo: string;

  @Column()
  @IsNotEmpty()
  competencia: Date;
  
  @OneToOne(() =>CategoriaEntity)
  @JoinColumn({ name: 'categoria_id' })
  categoria: CategoriaEntity;

  @OneToOne(() =>UserEntity)
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column()
  @CreateDateColumn()
  created_at: Date;

  @Column()
  @UpdateDateColumn()
  updated_at: Date;
}
