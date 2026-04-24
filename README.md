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
por cima pra atualizar o estado sem deixar sujeira. Ficam fora do git
apenas o `wp-config.php` (credenciais), o `.htaccess` gerado pelo WP e
caches/arquivos de runtime.

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

### 4. Importe o dump

Acesse <http://localhost/phpmyadmin/>, clique em **Importar** no menu
superior → *Escolher arquivo* → selecione
`htdocs/woocommerce/database/woocommerce_db.sql` → *Executar*.

Não precisa criar o banco antes: o dump traz
`CREATE DATABASE IF NOT EXISTS woocommerce_db` + `USE woocommerce_db`,
então o phpMyAdmin cria e seleciona o banco sozinho e popula todas as
tabelas do WordPress + WooCommerce com os plugins ativados, produtos,
categoria, frete e configuração do PayPal.

> **Reimportar por cima?** Tudo bem. O dump usa `DROP TABLE IF EXISTS`
> em todas as tabelas — a reimportação funciona como *update*,
> sobrescrevendo o estado atual pelo do dump.

### 5. Gere o `wp-config.php`

Dentro de `htdocs/woocommerce/`, copie o arquivo de exemplo:

```bash
cp wp-config-sample.php wp-config.php
```

No Windows, duplique o arquivo pelo Explorer e renomeie para
`wp-config.php`. As credenciais padrão do XAMPP (`root` sem senha e
banco `woocommerce_db`) já estão configuradas no sample — não precisa
editar.

### 6. (Opcional) Ajuste a URL do site

O dump vem com `http://localhost/woocommerce` como URL canônica (é o
case do enunciado, com XAMPP em `htdocs/woocommerce`). Se você serve
por outra URL — Laravel Valet (`http://woocommerce.test`), Herd,
domínio local customizado etc. — rode no phpMyAdmin (aba **SQL** do
banco `woocommerce_db`) ou em qualquer cliente MySQL:

```sql
UPDATE wp_options
   SET option_value = 'http://sua-url-local'
 WHERE option_name IN ('siteurl', 'home');
```

Troque `http://sua-url-local` pela URL do seu servidor (ex.:
`http://woocommerce.test`). Isso basta pro WordPress carregar no
endereço novo. Se depois você notar imagens, menus ou links em posts
ainda apontando pra `http://localhost/woocommerce`, rode o fluxo
completo com o plugin **Better Search Replace** (ver *Troubleshooting*)
— um `UPDATE` direto não mexe em strings serializadas.

### 7. Abra a loja

Acesse <http://localhost/woocommerce> (ou a URL que você definiu no
passo 6). A loja já abre pronta, com produtos, categoria, frete e
PayPal configurados.

### 8. Entre no painel admin

Acesse <http://localhost/woocommerce/wp-admin> e faça login:

| Usuário | Senha |
|---------|-------|
| `admin` | `admin` |

---

## Alternativa — DBeaver (ou outro cliente MySQL)

Se preferir não usar phpMyAdmin, o dump pode ser importado por qualquer
cliente MySQL. Exemplo com **DBeaver**:

1. Garanta que o servidor MySQL do XAMPP esteja rodando e conecte nele
   no DBeaver.
2. Abra um editor SQL na conexão → *Execute SQL Script* → selecione
   `database/woocommerce_db.sql` → *Start*. O próprio dump cria o banco
   `woocommerce_db` (`CREATE DATABASE IF NOT EXISTS` + `USE` no topo),
   então não precisa criar antes.
3. Siga do passo 5 em diante do fluxo XAMPP (gerar `wp-config.php`).

> **Não use `php -S` puro pra servir:** ele não reescreve URLs pra
> `index.php`, então os permalinks do WP quebram. Use o Apache do
> XAMPP (ou Nginx).

---

## Checklist do exercício

- [x] WordPress + WooCommerce instalados (pt-BR)
- [x] Banco de dados com dump `.sql` reprodutível (`woocommerce_db`)
- [x] 3 produtos completos (título, descrição, preço, estoque,
      dimensões, imagem) + 5 extras simples
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
vazia) ou "Instalar WordPress"**
O WP está conectando num banco diferente de `woocommerce_db` (o dump
sempre importa nesse nome). Abra o `wp-config.php` e confirme que
`DB_NAME` é exatamente `woocommerce_db`. Se o dump não foi importado
ainda, volte ao passo 4.

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
