# Suíte de Testes: Produtos

## Descrição

Suíte dedicada à validação dos endpoints de gerenciamento de **Produtos** da API ServeRest.

Contém casos de teste para operações CRUD (Create, Read, Update, Delete):
- Listagem de todos os produtos
- Busca de produto por ID
- Criação de novos produtos
- Atualização de produtos existentes
- Exclusão de produtos

## Arquivos de Teste

- **`getProdutos.robot`** - Casos de teste para `GET /produtos`
- **`postProdutos.robot`** - Casos de teste para `POST /produtos`
- **`putProdutos.robot`** - Casos de teste para `PUT /produtos/{id}`
- **`deleteProdutos.robot`** - Casos de teste para `DELETE /produtos/{id}`

## Casos de Teste

### GET - Consulta de Produtos

#### Cenário GET-PRODUTO-01: Consultar todos os produtos cadastrados
**Tag:** `001` `produtos`

- Realiza request GET para `/produtos`
- Valida status HTTP 200
- Verifica se `quantidade` corresponde ao tamanho da lista de produtos
- Valida estrutura do primeiro produto (nome, preço, descrição, quantidade, _id)

#### Cenário GET-PRODUTO-02: Buscar produto por ID
**Tag:** `002` `produtos`

- Lista todos os produtos
- Extrai ID do primeiro produto
- Busca o produto específico por ID
- Valida dados retornados

### POST - Criação de Produtos

- Validação de criação com dados válidos
- Validação de campos obrigatórios
- Validação de tipos de dados (preço como número, quantidade como inteiro)

### PUT - Atualização de Produtos

- Atualização de informações de produto
- Validação de produto não encontrado
- Validação de dados inválidos

### DELETE - Exclusão de Produtos

- Exclusão bem-sucedida de produto
- Tentativa de exclusão de produto inexistente
- Validação de resposta após exclusão

## Fluxo de Dados

1. **@Setup**: Cria usuário autenticado (necessário para POST/PUT/DELETE)
2. **GET Tests**: Consulta produtos já cadastrados
3. **POST Tests**: Cria novos produtos e valida respostas
4. **PUT Tests**: Atualiza produtos criados
5. **DELETE Tests**: Remove produtos criados
6. **@Teardown**: Limpeza de dados criados nos testes

## Estrutura de Dados - Produto

```json
{
  "_id": "string (ID único MongoDB)",
  "nome": "string (obrigatório)",
  "preco": "number (obrigatório)",
  "descricao": "string (obrigatório)",
  "quantidade": "number (obrigatório)",
  "imagem": "string (opcional)"
}
```

## Notas Importantes

- Uma conta de administrador pode ser necessária para POST/PUT/DELETE
- Validar se a API está com dados limpos antes de executar testes de criação
- Os testes de exclusão são destrutivos; usar com cuidado em produção
