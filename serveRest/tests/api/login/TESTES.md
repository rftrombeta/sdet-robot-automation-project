# Suíte de Testes: Login

## Descrição

Suíte dedicada à validação do endpoint de autenticação (LOGIN) da API ServeRest.

Contém casos de teste para:
- Autenticação bem-sucedida de usuários
- Validação de credenciais incorretas (senha e email)
- Geração e validação de tokens de autorização

## Arquivo de Teste

- **`postLogin.robot`** - Casos de teste para o endpoint `POST /login`

## Casos de Teste

### Cenário POST-LOGIN-01: Login com sucesso
**Tag:** `001` `login`

- Cria um usuário comum
- Realiza login com credenciais válidas
- Valida resposta com token de autorização
- Extrai e armazena o token para uso em testes subsequentes

### Cenário POST-LOGIN-02: Login com senha incorreta
**Tag:** `002` `login`

- Cria um usuário comum
- Tenta fazer login com senha incorreta
- Valida mensagem de erro apropriada

### Cenário POST-LOGIN-03: Login com email incorreto
**Tag:** `003` `login`

- Cria um usuário comum
- Tenta fazer login com email não registrado
- Valida mensagem de erro correspondente

## Fluxo de Dados

1. **@Setup**: Um usuário comum é criado via `POST /usuarios`
2. **Teste**: Login é realizado com as credenciais do usuário criado
3. **Validação**: Resposta é validada, e o token é extraído para uso subsequente
4. **@Teardown**: Limpeza de dados (se configurado)

## Notas Importantes

- O token gerado no Cenário POST-LOGIN-01 é essencial para testes de endpoints protegidos
- Cookies de sessão podem ser requeridos em testes integrados com sistema web
