# Suíte de Testes: Usuários

## Descrição

Suíte dedicada à validação dos endpoints de gerenciamento de **Usuários** da API ServeRest.

Contém casos de teste para operações CRUD (Create, Read, Update, Delete):
- Listagem de todos os usuários cadastrados
- Busca de usuário por ID
- Criação de novos usuários
- Atualização de dados de usuário
- Exclusão/desativação de usuário

## Arquivos de Teste

- **`getUsuarios.robot`** - Casos de teste para `GET /usuarios`
- **`postUsuarios.robot`** - Casos de teste para `POST /usuarios`
- **`putUsuarios.robot`** - Casos de teste para `PUT /usuarios/{id}`
- **`deleteUsuarios.robot`** - Casos de teste para `DELETE /usuarios/{id}`

## Casos de Teste

### GET - Consulta de Usuários

#### Cenário GET-USUARIOS-01: Consultar todos os usuarios cadastrados
**Tag:** `001` `usuarios`

- Realiza request GET para `/usuarios`
- Valida lista de usuários retornada
- Verifica estrutura de resposta

#### Cenário GET-USUARIOS-02: Buscar usuário por ID
**Tag:** `002` `usuarios`

- Cria um usuário comum
- Consulta o usuário específico pelo ID retornado no cadastro
- Valida que os dados retornados correspondem ao usuário criado

#### Cenário GET-USUARIOS-03: Não buscar usuário com ID maior que o permitido
**Tag:** `003` `usuarios`

- Tenta consultar usuário com ID inválido (maior que permitido)
- Valida que retorna erro 400 ou 404

#### Cenário GET-USUARIOS-04: Não buscar usuário com ID menor que o permitido
**Tag:** `004` `usuarios`

- Tenta consultar usuário com ID formato inválido (muito curto)
- Valida resposta de erro apropriada

#### Cenário GET-USUARIOS-05: Não buscar usuário com ID inexistente
**Tag:** `005` `usuarios`

- Tenta consultar usuário com ID válido mas inexistente
- Valida mensagem de erro "Usuário não encontrado"

### POST - Criação de Usuários

- Validação de criação com dados válidos
- Validação de campos obrigatórios (nome, email, password, administrador)
- Validação de email duplicado
- Validação de formato de email
- Retorno do ID de usuário criado

### PUT - Atualização de Usuários

- Atualização de informações de usuário existente
- Validação de usuário não encontrado
- Validação de email já registrado em outro usuário
- Validação de campos obrigatórios

### DELETE - Exclusão de Usuários

- Exclusão bem-sucedida de usuário
- Tentativa de exclusão de usuário inexistente
- Validação de usuário autenticado (se requerido)

## Fluxo de Dados

1. **@Setup**: Inicializa conexão com API, autentica se necessário
2. **GET Tests**: Consulta usuários já cadastrados
3. **POST Tests**: Cria novos usuários e valida respostas
4. **PUT Tests**: Atualiza usuários criados
5. **DELETE Tests**: Remove usuários de teste
6. **@Teardown**: Limpeza de dados criados nos testes

## Estrutura de Dados - Usuário

```json
{
  "_id": "string (ID único MongoDB, gerado automaticamente)",
  "nome": "string (obrigatório, mínimo 3 caracteres)",
  "email": "string (obrigatório, email válido e único)",
  "password": "string (obrigatório, mínimo 6 caracteres)",
  "administrador": "string (sim/não, padrão: não)"
}
```

## Validações Importantes

| Campo | Validação |
|-------|-----------|
| `nome` | Mínimo 3 caracteres |
| `email` | Formato de email válido, único no banco |
| `password` | Mínimo 6 caracteres |
| `administrador` | Valores: "sim" ou "não" |
| `_id` | ID MongoDB válido (24 caracteres hexadecimais) |

## Notas de Execução

- Testes de POST/PUT/DELETE podem falhar se a API não tiver permissão de escrita
- Email deve ser único; utilize email aleatório ou limpe BD entre testes
- Alguns testes requerem usuário com privilégio de administrador
- Dados sensíveis (passwords) não devem ser logados em relatórios públicos

## Troubleshooting

| Erro | Possível Causa | Solução |
|------|---------------|---------| 
| Email duplicado | Dados de teste não foram limpos | Limpar BD antes dos testes |
| ID inválido | Formato de ID incorreto | Verificar formato MongoDB ObjectId |
| Usuário não encontrado | ID inexistente | Usar ID de usuário criado no mesmo teste |
