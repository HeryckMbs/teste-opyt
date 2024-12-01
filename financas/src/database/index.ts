import { DataSource } from 'typeorm';

const connectionSource = new DataSource({
  migrationsTableName: 'migrations',
  type: 'mariadb',
  username: 'refactorian',
  password: 'refactorian',
  host: 'db',
  port: 3306,
  database: 'refactorian',
  synchronize: false,
  logging: false,
  entities: ['/app/src/entities/*.entity{.ts,.js}'],
  migrations: ['/app/src/database/migrations/*{.ts,.js}'],
});
export default connectionSource;
