import { table } from 'console';
import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class CreateTransacao1733016237149 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    // Criando a tabela de transações
    await queryRunner.createTable(
      new Table({
        name: 'transacaoes',
        columns: [
          {
            name: 'id',
            type: 'int',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
          },
          {
            name: 'valor',
            type: 'decimal',
            precision: 10,
            scale: 2,
            isNullable: false,
          },
          {
            name: 'descricao',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'tipo',
            type: 'varchar',
            isNullable: false,
          },
          { name: 'competencia', type: 'timestamp', isNullable: false },

          {
            name: 'categoria_id',
            type: 'int',
            isNullable: false,
          },
          {
            name: 'user_id',
            type: 'int',
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
    // Adicionando a chave estrangeira para categoria
    await queryRunner.createForeignKey(
      'transacaoes',
      new TableForeignKey({
        columnNames: ['categoria_id'],
        referencedTableName: 'categorias',
        referencedColumnNames: ['id'],
        onDelete: 'RESTRICT',
      }),
    );

    // Adicionando a chave estrangeira para user
    await queryRunner.createForeignKey(
      'transacaoes',
      new TableForeignKey({
        columnNames: ['user_id'],
        referencedTableName: 'users',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('transacaoes');
    const foreignKeys = table.foreignKeys.filter(fk => fk.columnNames.indexOf('categoria_id') !== -1 || fk.columnNames.indexOf('user_id') !== -1);

    await queryRunner.dropForeignKeys('transacaoes', foreignKeys);

    await queryRunner.dropTable('transacaoes');
  }
}
