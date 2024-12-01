import { table } from "console";
import { MigrationInterface, QueryRunner ,Table} from "typeorm";

export class CreateCategoria1733016233990 implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        // Criando a tabela de categoria
 await queryRunner.createTable(
     new Table({
       name: 'categorias',
       columns: [
         {
           name: 'id',
           type: 'int',
           isPrimary: true,
           isGenerated: true,
           generationStrategy: 'increment',
         },
         {
           name: 'nome',
           type: 'varchar',
           isNullable: false,
         },
         {
           name: 'tipo',
           type: 'varchar',
           isNullable: false,
         },
         {
           name: 'created_at',
           type: 'timestamp',
           default: 'CURRENT_TIMESTAMP',
         },
         {
           name: 'updated_at',
           type: 'timestamp',
           default: 'CURRENT_TIMESTAMP',
           onUpdate: 'CURRENT_TIMESTAMP',
         },
       ],
     }),
   );
 }

 public async down(queryRunner: QueryRunner): Promise<void> {
     await queryRunner.dropTable('categorias');

 }
}
