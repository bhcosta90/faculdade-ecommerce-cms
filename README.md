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
│   ├── languages/             # traduções pt-BR
│   ├── fonts/                 # fontes do WP
│   └── uploads/               # imagens de produto e logo
├── setup.sh                   # automação para Valet/Herd/Linux
├── wp-config-sample.php       # template (copie para wp-config.php)
├── .gitignore
└── README.md
```

O core do WP, plugins e tema estão **versionados**. O estado "instalado e
configurado" (plugins ativos, produtos, categoria, PayPal, frete, logo)
mora no dump SQL em `database/woocommerce_db.sql`. Só o `wp-config.php`
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

### 6. Gere o `wp-config.php`

Dentro de `htdocs/woocommerce/`, copie o arquivo de exemplo:

```bash
cp wp-config-sample.php wp-config.php
```

No Windows, duplique o arquivo pelo Explorer e renomeie para
`wp-config.php`. As credenciais padrão do XAMPP (`root` sem senha e
banco `woocommerce_db`) já estão configuradas no sample — não precisa
editar.

### 7. Abra a loja

Acesse <http://localhost/woocommerce> no navegador. A loja já abre
pronta, com produtos, categoria, frete e PayPal configurados.

### 8. Entre no painel admin

Acesse <http://localhost/woocommerce/wp-admin> e faça login:

| Usuário | Senha |
|---------|-------|
| `admin` | `admin` |

---

## Alternativa — Valet / Herd / Linux (com script)

Para quem não usa XAMPP (ex.: Laravel Valet + Takeout, Herd, Linux com
MySQL nativo), rode o `setup.sh` da raiz do projeto:

```bash
./setup.sh                          # defaults: banco woocommerce_db, URL http://localhost/woocommerce
./setup.sh http://loja.test         # cria banco, importa dump E reescreve URL
DB_USER=root DB_PASSWORD=secret ./setup.sh http://loja.test
```

O script:

1. Detecta o cliente `mysql` no PATH (ou cai em container do Takeout se
   achar um `TO--mysql-*` rodando).
2. Cria o banco `woocommerce_db` com o collation correto.
3. Importa `database/woocommerce_db.sql`.
4. Gera `wp-config.php` a partir do sample.
5. Se você passar uma URL como argumento e tiver WP-CLI, roda
   `wp search-replace` pra ajustar todas as URLs do site.

Depois é só apontar seu servidor pra esta pasta (`valet link
woocommerce`, adicionar o site no Herd, etc.) e abrir a URL.

> **Não use `php -S` puro:** ele não reescreve URLs pra `index.php`,
> então permalinks do WP quebram. Use Apache/Nginx.

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

**Abriu e caiu na tela "Instalar WordPress"**
O banco ainda não tem os dados do dump. Volte ao passo 5 ou confirme que
o `wp-config.php` aponta pro banco `woocommerce_db` correto.

**404 ou redireciona pra outra URL**
O `siteurl` no banco não bate com a URL que você está acessando. O dump
vem com `http://localhost/woocommerce`. Se você acessa por outra URL,
rode:

```bash
wp search-replace 'http://localhost/woocommerce' 'http://sua-url-local'
```

Sem WP-CLI, instale o plugin **Better Search Replace** (WP Admin →
Ferramentas → Better Search Replace). Um `UPDATE` só em `siteurl`/`home`
**não** resolve — deixa imagens, menus e links em posts apontando pro
domínio antigo.

**CSS ou permalinks quebrados**
WP Admin → **Configurações → Links Permanentes → Salvar**. Regenera o
`.htaccess`.

**Recriar o dump a partir do estado atual** (normaliza URL pra
`http://localhost/woocommerce` antes de exportar):

```bash
wp search-replace 'http://SITE-ATUAL' 'http://localhost/woocommerce' \
    --export=database/woocommerce_db.sql --all-tables
```

---

## Credenciais padrão

| Onde | Usuário | Senha |
|------|---------|-------|
| WordPress Admin | `admin` | `admin` |
| MySQL (default XAMPP) | `root` | *(vazio)* |

⚠️ Credenciais de **ambiente de desenvolvimento**. Troque antes de expor
em qualquer rede.
