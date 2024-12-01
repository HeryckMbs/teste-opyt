import connectionSource  from "@/database";
import { CategoriaEntity } from "@/entities/categoria.entity";
import { getRepository } from 'typeorm';


const seed = async () => {
  if (!connectionSource.isInitialized) {
    await connectionSource.initialize();
  }

  const repository = connectionSource.getRepository(CategoriaEntity)
    const categorias: { nome: string; tipo: "receita" | "despesa" }[] = [
        // Receitas
        { nome: "Salário", tipo: "receita" },
        { nome: "Freelance", tipo: "receita" },
        { nome: "Investimentos", tipo: "receita" },
        { nome: "Aluguel de Imóveis", tipo: "receita" },
        { nome: "Vendas de Produtos", tipo: "receita" },
        { nome: "Rendimentos", tipo: "receita" },
        { nome: "Outros", tipo: "receita" },
      
        // Despesas
        { nome: "Alimentação", tipo: "despesa" },
        { nome: "Transporte", tipo: "despesa" },
        { nome: "Habitação", tipo: "despesa" },
        { nome: "Educação", tipo: "despesa" },
        { nome: "Saúde", tipo: "despesa" },
        { nome: "Lazer", tipo: "despesa" },
        { nome: "Serviços Públicos", tipo: "despesa" },
        { nome: "Roupas", tipo: "despesa" },
        { nome: "Viagens", tipo: "despesa" },
        { nome: "Assinaturas e Streaming", tipo: "despesa" },
        { nome: "Dívidas", tipo: "despesa" },
        { nome: "Impostos", tipo: "despesa" },
        { nome: "Outros", tipo: "despesa" },
      ];
      
  for (const categoria of categorias) {
    const user = repository.create(categoria);
    await repository.save(user);
  }

  console.log("Seed completed!");
};

seed().catch((error) => {
  console.error("Error seeding database:", error);
});