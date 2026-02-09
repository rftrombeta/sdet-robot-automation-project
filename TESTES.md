# Documentação de Testes - ServeRest

## Visão Geral

Projeto de automação de testes da API ServeRest com Robot Framework. Contém suítes completas de testes para validação de endpoints de autenticação, produtos e usuários.

## Suítes de Testes

- **[Login](serveRest/tests/api/login/TESTES.md)** - Validação de autenticação e geração de tokens
- **[Produtos](serveRest/tests/api/produtos/TESTES.md)** - CRUD (Create, Read, Update, Delete) de produtos
- **[Usuários](serveRest/tests/api/usuarios/TESTES.md)** - CRUD de usuários e gerenciamento de contas

## Início Rápido

### 1. Configurar Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2. Instalar Dependências

```bash
pip install -r requirements.txt
```

### 3. Executar Testes

```bash
# Executar all testes
robot serveRest/tests/

# Executar suíte específica
robot serveRest/tests/api/login/
robot serveRest/tests/api/produtos/
robot serveRest/tests/api/usuarios/

# Com geração de relatório detalhado
robot -d logs serveRest/tests/
```

## Relatórios

Após executar os testes, os relatórios são gerados em `logs/`:

- **`report.html`** - Relatório executivo com gráficos e resumo
- **`log.html`** - Log detalhado de cada teste executado
- **`output.xml`** - Arquivo XML bruto (para integração CI/CD)

Abra `logs/report.html` no navegador para visualizar resultados.

## Filtros de Execução

Você pode executar testes específicos usando tags:

```bash
# Apenas testes de login
robot --include login serveRest/tests/

# Apenas cenários 001 e 002
robot --include "001 or 002" serveRest/tests/

# Excluir testes de exclusão (DELETE)
robot --exclude delete serveRest/tests/
```
