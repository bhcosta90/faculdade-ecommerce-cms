# Loja Faculdade — WooCommerce

Loja ecommerce em **WordPress + WooCommerce** construída como trabalho da
aula prática de ecommerce. Vem com 8 produtos publicados (3 em português com
dados completos, estoque e dimensões), uma categoria nova (`Rosto`), frete
fixo de R$ 5,00 para todo o Brasil, três métodos de pagamento e o tema
Botiga customizado.

## Tecnologias

- WordPress 6.9 (pt-BR)
- WooCommerce 10.7
- Tema Botiga 2.4
- PHP 8.3
- MySQL 8 (compatível com MariaDB do XAMPP também)

## O que está neste repositório

```
.
├── database/
│   └── loja-faculdade.sql     # dump inicial do banco (produtos, config etc.)
├── wp-content/
│   ├── plugins/               # woocommerce, woocommerce-paypal-payments, akismet
│   ├── themes/                # botiga (ativo) + temas default do WP
│   ├── languages/             # traduções pt-BR
│   ├── fonts/                 # fontes baixadas pelo WP
│   ├── uploads/               # imagens de produto e logo
│   └── index.php              # guard do WordPress
├── wp-config-sample.php       # template de config para setup nativo
├── .gitignore                 # mantém o core do WP e o wp-config.php fora do git
└── README.md
```

O **core do WordPress** (`wp-admin/`, `wp-includes/`, `index.php`, etc.) **não
está versionado** — ele vem do instalador do WP durante o setup. Isso mantém o
repo pequeno e focado no conteúdo.

---

## Subindo o projeto

Funciona em qualquer stack que tenha PHP 8.0+ e MySQL/MariaDB (XAMPP, MAMP,
Local, Laravel Herd/Valet + Takeout, `php -S`, etc.).

1. **Baixe o WordPress** em <https://br.wordpress.org/download/> (ou
   `wp core download --locale=pt_BR`) e extraia os arquivos do core na raiz
   deste repositório. O `.gitignore` já está configurado para manter
   `wp-admin/`, `wp-includes/`, os arquivos `wp-*.php` do core e o
   `wp-config.php` fora do git, mesmo estando em disco.

2. **Crie um banco** vazio no seu MySQL/MariaDB (nome à sua escolha, ex.
   `loja_faculdade`) e importe o dump:

   ```bash
   mysql -u root -p loja_faculdade < database/loja-faculdade.sql
   ```

   No phpMyAdmin: aba *Importar* → selecione o arquivo `.sql` → *Executar*.

3. **Copie** `wp-config-sample.php` para `wp-config.php` e ajuste as
   credenciais (ou defina as variáveis `WORDPRESS_DB_*` no ambiente). Gere
   novos salts em <https://api.wordpress.org/secret-key/1.1/salt/>.

4. **Sirva** a pasta do projeto — escolha uma forma:
   - **XAMPP:** copie a pasta para `htdocs/` e acesse `http://localhost/<pasta>`
   - **Herd / Valet:** `valet link` (ou ponto equivalente no Herd) no diretório
   - **Local / MAMP:** aponte o site para este diretório

   > Evite `php -S` puro: ele não reescreve URLs para `index.php`, então
   > permalinks do WordPress quebram. Use uma stack com Apache/Nginx (XAMPP,
   > Herd, Valet, Local, MAMP).

5. **Ajuste as URLs** se seu site não roda em `http://localhost:8080` (URL do
   dump). Usando WP-CLI:

   ```bash
   wp search-replace 'http://localhost:8080' 'http://seu-endereco-local'
   ```

   Sem WP-CLI, rode dois UPDATE no phpMyAdmin:

   ```sql
   UPDATE wp_options SET option_value='http://seu-endereco' WHERE option_name IN ('siteurl','home');
   ```

   (as URLs em posts/menus serão reescritas quando o WP reconstruir os caches)

---

## Credenciais padrão

| Onde | Usuário | Senha |
|------|---------|-------|
| WordPress Admin | `admin` | `admin` |

⚠️ São credenciais de **ambiente de desenvolvimento**. Troque tudo antes de
expor em qualquer rede.

## Checklist da aula prática

- [x] WordPress + WooCommerce instalados (pt-BR)
- [x] Banco de dados com dump `.sql` reprodutível
- [x] 3 produtos completos (título, descrição, preço, estoque, dimensões, imagem)
- [x] 1 categoria nova criada (`Rosto`) com imagem e descrição
- [x] Método de pagamento configurado (COD, Transferência, PayPal)
- [x] Impostos desativados
- [x] Frete fixo R$ 5,00 para o Brasil
- [x] Logo customizada
- [x] Página inicial personalizada (hero + destaques + diferenciais)
- [x] Tema Botiga como visual da loja

## Dicas

- Depois de importar o SQL, se CSS/permalinks parecerem quebrados: **WP Admin
  → Configurações → Links Permanentes → Salvar**. Isso regenera o `.htaccess`.
- Para recriar o dump a partir do estado atual (normaliza a URL para
  `http://localhost:8080` e exporta o SQL):
  ```bash
  wp search-replace 'http://SITE-ATUAL' 'http://localhost:8080' \
      --export=database/loja-faculdade.sql --all-tables
  ```
