# Loja Faculdade — WooCommerce

Loja ecommerce em **WordPress + WooCommerce** construída como trabalho da
aula prática. Entrega tudo já instalado e configurado: 8 produtos publicados
(3 em português com dados completos, estoque e dimensões), uma categoria
(`Rosto`), frete fixo de R$ 5,00 para o Brasil, três métodos de pagamento
(COD, Transferência e PayPal), impostos desativados, logo customizada e o
tema **Botiga** como visual da loja.

## Tecnologias

- WordPress 6.9 (pt-BR)
- WooCommerce 10.7
- Tema Botiga 2.4
- PHP 8.0+ (testado em 8.3)
- MySQL 8 / MariaDB 10.5+ (dump usa `utf8mb4_unicode_520_ci`)

## O que está neste repositório

```
.
├── database/
│   └── woocommerce_db.sql     # dump completo (WP + Woo + produtos + PayPal)
├── wp-admin/                  # core do WordPress
├── wp-includes/               # core do WordPress
├── wp-*.php                   # bootstrap do core (wp-load, wp-login, etc.)
├── index.php                  # front controller do WP
├── wp-content/
│   ├── plugins/               # woocommerce, woocommerce-paypal-payments, akismet
│   ├── themes/                # botiga (ativo) + storefront + temas default
│   └── uploads/               # imagens de produto e logo
├── wp-config-sample.php       # template (copie para wp-config.php)
├── .gitignore
└── README.md
```

O core do WP, plugins e tema estão **versionados**. O estado "instalado e
configurado" (plugins ativos, produtos, categoria, PayPal, frete, logo)
mora no dump SQL em `database/woocommerce_db.sql`. O dump já traz
`CREATE DATABASE IF NOT EXISTS woocommerce_db` + `USE woocommerce_db`
no topo, então **o banco é sempre criado/selecionado como
`woocommerce_db`**, independente do cliente (phpMyAdmin, DBeaver, CLI).
Cada tabela também tem `DROP TABLE IF EXISTS`, o que permite reimportar
por cima pra atualizar o estado sem deixar sujeira. Só o `wp-config.php`
(com credenciais) e caches de runtime ficam fora do git.

---

## Passo a passo — XAMPP (forma oficial da entrega)

Este é o fluxo que bate com o enunciado: pasta em `htdocs/woocommerce/`
e banco `woocommerce_db`.

### 1. Instale o XAMPP

Baixe em <https://www.apachefriends.org/download.html> e instale.

### 2. Copie o projeto para `htdocs/woocommerce/`

Copie **todo o conteúdo desta pasta** (core do WP + `wp-content/` +
`database/` + `wp-config-sample.php`) para dentro de:

- Windows: `C:\xampp\htdocs\woocommerce\`
- macOS: `/Applications/XAMPP/htdocs/woocommerce/`
- Linux: `/opt/lampp/htdocs/woocommerce/`

### 3. Suba o Apache e o MySQL

Abra o **XAMPP Control Panel** e clique em *Start* em **Apache** e em
**MySQL**.

### 4. Crie o banco `woocommerce_db`

Acesse <http://localhost/phpmyadmin/>, clique em **New** na lateral
esquerda, use o nome **`woocommerce_db`** e clique em *Criar*.

### 5. Importe o dump

Ainda no phpMyAdmin, selecione o banco `woocommerce_db` → aba
**Importar** → *Escolher arquivo* → selecione
`htdocs/woocommerce/database/woocommerce_db.sql` → *Executar*.

Isso popula todas as tabelas do WordPress + WooCommerce já com os
plugins ativados, produtos, categoria, frete e configuração do PayPal.

> **Importando num banco que já tem WP?** Tudo bem. O dump derruba as
> tabelas dele e recria (`DROP TABLE IF EXISTS` em todas), então a
> importação funciona como *update* — sobrescreve o estado atual pelo
> do dump sem precisar de banco vazio.

### 6. Gere o `wp-config.php`

Dentro de `htdocs/woocommerce/`, copie o arquivo de exemplo:

```bash
cp wp-config-sample.php wp-config.php
```

No Windows, duplique o arquivo pelo Explorer e renomeie para
`wp-config.php`. As credenciais padrão do XAMPP (`root` sem senha e
banco `woocommerce_db`) já estão configuradas no sample — não precisa
editar.

> Se você usou um nome de banco diferente no passo 4 (ex.: `ecommerce`),
> abra o `wp-config.php` e ajuste o `DB_NAME` pra bater. **Esse é o
> erro mais comum:** o WP conecta num banco diferente do que recebeu o
> dump, mostra a tela "adicionar seu primeiro produto" no admin e
> parece que o dump não trouxe nada.

### 7. Abra a loja

Acesse <http://localhost/woocommerce> no navegador. A loja já abre
pronta, com produtos, categoria, frete e PayPal configurados.

### 8. Entre no painel admin

Acesse <http://localhost/woocommerce/wp-admin> e faça login:

| Usuário | Senha |
|---------|-------|
| `admin` | `admin` |

---

## Alternativa — DBeaver (ou outro cliente MySQL)

Se preferir não usar phpMyAdmin, o dump pode ser importado por qualquer
cliente MySQL. Exemplo com **DBeaver**:

1. Garanta que o servidor MySQL do XAMPP esteja rodando.
2. No **Database Navigator**, clique com o botão direito na conexão →
   *Create New Database* → nome `woocommerce_db` → *OK*.
3. Clique com o botão direito no banco criado → *Tools* → *Execute SQL
   Script* → selecione `database/woocommerce_db.sql` → *Start*.
4. Siga do passo 6 em diante do fluxo XAMPP (gerar `wp-config.php`
   apontando pro banco que você acabou de criar).

> **Não use `php -S` puro pra servir:** ele não reescreve URLs pra
> `index.php`, então os permalinks do WP quebram. Use o Apache do
> XAMPP (ou Nginx).

---

## Checklist do exercício

- [x] WordPress + WooCommerce instalados (pt-BR)
- [x] Banco de dados com dump `.sql` reprodutível (`woocommerce_db`)
- [x] 3 produtos completos (título, descrição, preço, estoque,
      dimensões, imagem)
- [x] 1 categoria nova criada (`Rosto`) com imagem e descrição
- [x] Métodos de pagamento configurados (COD, Transferência, PayPal)
- [x] Impostos desativados
- [x] Frete fixo R$ 5,00 para o Brasil
- [x] Logo customizada
- [x] Página inicial personalizada (hero + destaques + diferenciais)
- [x] Tema Botiga como visual da loja

---

## Troubleshooting

**Admin abriu na tela "adicione seu primeiro produto" (lista de produtos
vazia)**
O WP conectou num banco diferente do que recebeu o dump. Confirme que o
`DB_NAME` no `wp-config.php` é exatamente o banco onde você importou o
`.sql`. Ajuste, salve e dê F5.

**Abriu e caiu na tela "Instalar WordPress"**
O banco ainda não tem os dados do dump. Volte ao passo 5 ou confirme que
o `wp-config.php` aponta pro banco correto.

**404 ou redireciona pra outra URL**
O `siteurl` no banco não bate com a URL que você está acessando. O dump
vem com `http://localhost/woocommerce`. Se você acessa por outra URL,
instale o plugin **Better Search Replace** (WP Admin → Ferramentas →
Better Search Replace) e troque `http://localhost/woocommerce` pela sua
URL em todas as tabelas. Um `UPDATE` só em `siteurl`/`home` **não**
resolve — deixa imagens, menus e links em posts apontando pro domínio
antigo.

**CSS ou permalinks quebrados**
WP Admin → **Configurações → Links Permanentes → Salvar**. Regenera o
`.htaccess`.

---

## Credenciais padrão

| Onde | Usuário | Senha |
|------|---------|-------|
| WordPress Admin | `admin` | `admin` |
| MySQL (default XAMPP) | `root` | *(vazio)* |

⚠️ Credenciais de **ambiente de desenvolvimento**. Troque antes de expor
em qualquer rede.
