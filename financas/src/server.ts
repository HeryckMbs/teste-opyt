import { App } from '@/app';
import { AuthRoute } from '@routes/auth.route';
import { UserRoute } from '@routes/users.route';
import { ValidateEnv } from '@utils/validateEnv';
import { CategoriaRoute } from './routes/categoria.route';
import { TransacaoRoute } from './routes/transacao.route';

ValidateEnv();

const app = new App([
    new AuthRoute(),
    new UserRoute(),
    new CategoriaRoute(),
    new TransacaoRoute()
    ]);

app.listen();
