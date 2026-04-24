<?php
/**
 * wp-config-sample.php
 *
 * Copie este arquivo para `wp-config.php` e ajuste as credenciais do banco
 * diretamente nas constantes abaixo, ou exporte as variáveis de ambiente
 * WORDPRESS_DB_NAME / WORDPRESS_DB_USER / WORDPRESS_DB_PASSWORD /
 * WORDPRESS_DB_HOST antes de servir o site.
 */

// ** Database settings ** //
define('DB_NAME',     getenv('WORDPRESS_DB_NAME')     ?: 'woocommerce_db');
define('DB_USER',     getenv('WORDPRESS_DB_USER')     ?: 'root');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: '');
define('DB_HOST',     getenv('WORDPRESS_DB_HOST')     ?: '127.0.0.1');
define('DB_CHARSET',  'utf8mb4');
define('DB_COLLATE',  '');

/**
 * Chaves e salts — GERE NOVAS em https://api.wordpress.org/secret-key/1.1/salt/
 * Não reutilize as strings deste sample em produção.
 */
define('AUTH_KEY',         'troque-isto');
define('SECURE_AUTH_KEY',  'troque-isto');
define('LOGGED_IN_KEY',    'troque-isto');
define('NONCE_KEY',        'troque-isto');
define('AUTH_SALT',        'troque-isto');
define('SECURE_AUTH_SALT', 'troque-isto');
define('LOGGED_IN_SALT',   'troque-isto');
define('NONCE_SALT',       'troque-isto');

$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

if (!defined('WP_DEBUG')) {
    define('WP_DEBUG', filter_var(getenv('WORDPRESS_DEBUG'), FILTER_VALIDATE_BOOLEAN));
}

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
