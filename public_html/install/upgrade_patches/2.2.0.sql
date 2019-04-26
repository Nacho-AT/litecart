CREATE TABLE IF NOT EXISTS `lc_attribute_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(32) NOT NULL,
  `date_updated` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lc_attribute_groups_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `language_code` varchar(2) COLLATE utf8_swedish_ci NOT NULL,
  `name` varchar(64) COLLATE utf8_swedish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_group` (`group_id`,`language_code`),
  KEY `group_id` (`group_id`)
  KEY `language_code` (`language_code`),
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lc_attribute_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `date_updated` datetime NOT NULL,
  `date_created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lc_attribute_values_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value_id` int(11) NOT NULL,
  `language_code` varchar(2) COLLATE utf8_swedish_ci NOT NULL,
  `name` varchar(64) COLLATE utf8_swedish_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attribute_value` (`value_id`,`language_code`),
  KEY `value_id` (`value_id`),
  KEY `language_code` (`language_code`)
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
INSERT INTO `lc_attribute_groups`
(id, date_updated, date_created)
SELECT id, date_updated, date_created FROM `lc_product_groups`;
-- --------------------------------------------------------
INSERT INTO `lc_attribute_groups_info`
(id, group_id, language_code, name)
SELECT id, product_group_id, language_code, name FROM `lc_product_groups_info`;
-- --------------------------------------------------------
INSERT INTO `lc_attribute_values`
(id, group_id, date_updated, date_created)
SELECT id, product_group_id, date_updated, date_created FROM `lc_product_groups_values`;
-- --------------------------------------------------------
INSERT INTO `lc_attribute_values_info`
(id, value_id, language_code, name)
SELECT id, product_group_value_id, language_code, name FROM `lc_product_groups_values_info`;
-- --------------------------------------------------------
CREATE TABLE `lc_categories_filters` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`category_id` INT NOT NULL,
	`select_multiple` TINYINT NOT NULL,
	`attribute_group_id` INT NOT NULL,
  `priority` INT(11) NOT NULL AFTER `attribute_group_id`,
	INDEX `category_id` (`category_id`),
	PRIMARY KEY (`id`),
	UNIQUE INDEX `attribute_filter` (`category_id`, `attribute_group_id`)
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
CREATE TABLE `lc_categories_images` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`category_id` INT(11) NOT NULL,
	`filename` VARCHAR(256) NOT NULL,
	`checksum` CHAR(32) NOT NULL,
	`priority` TINYINT(2) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `category_id` (`category_id`)
) ENGINE=MyISAM;
-- --------------------------------------------------------
INSERT INTO `lc_categories_images` (category_id, filename) (
  SELECT id, image FROM `lc_categories`
  WHERE image != ''
);
-- --------------------------------------------------------
ALTER TABLE `lc_customers`
ADD COLUMN `num_logins` INT NOT NULL AFTER `password_reset_token`,
ADD COLUMN `last_ip` VARCHAR(39) NOT NULL AFTER `num_logins`,
ADD COLUMN `last_host` VARCHAR(64) NOT NULL AFTER `last_ip`,
ADD COLUMN `last_agent` VARCHAR(256) NOT NULL AFTER `last_host`,
ADD COLUMN `date_login` DATETIME NOT NULL AFTER `last_agent`;
-- --------------------------------------------------------
ALTER TABLE `lc_orders`
ADD COLUMN `shipping_tracking_url` VARCHAR(256) NOT NULL AFTER `shipping_tracking_id`,
ADD COLUMN `user_agent` VARCHAR(256) NOT NULL AFTER `client_ip`,
ADD COLUMN `domain` VARCHAR(64) NOT NULL AFTER `user_agent`;
-- --------------------------------------------------------
ALTER TABLE `lc_modules`
ADD COLUMN `date_pushed` DATETIME NOT NULL AFTER `last_log`;
-- --------------------------------------------------------
DELETE FROM `lc_settings`
WHERE `key` = 'job_error_reporter:last_run';
-- --------------------------------------------------------
INSERT INTO `lc_settings` (`setting_group_key`, `title`, `description`, `key`, `value`, `function`, `priority`, `date_updated`, `date_created`) VALUES
('email', 'Send Emails', 'Wheither or not the platform should deliver outgoing emails.', 'email_status', '1', 'toggle("y/n")', '1', NOW(), NOW());
-- --------------------------------------------------------
ALTER TABLE `lc_sold_out_statuses` ADD COLUMN `hidden` TINYINT(1) NOT NULL AFTER `id`;
-- --------------------------------------------------------
ALTER TABLE `lc_sold_out_statuses` ADD INDEX `hidden` (`hidden`), ADD INDEX `orderable` (`orderable`);
-- --------------------------------------------------------
ALTER TABLE `lc_pages`
ADD COLUMN `parent_id` INT(11) NOT NULL AFTER `status`,
ADD INDEX `parent_id` (`parent_id`);
-- --------------------------------------------------------
CREATE TABLE `lc_products_attributes` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`product_id` INT NOT NULL,
	`group_id` INT NOT NULL,
	`value_id` INT NOT NULL,
	`custom_value` VARCHAR(256) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id` (`id`, `product_id`, `group_id`, `value_id`),
	INDEX `product_id` (`product_id`),
	INDEX `group_id` (`group_id`),
	INDEX `value_id` (`value_id`)
) ENGINE=MyISAM DEFAULT;
-- --------------------------------------------------------
ALTER TABLE `lc_products_info`
CHANGE COLUMN `attributes` `technical_data` TEXT NOT NULL AFTER `description`
ADD FULLTEXT INDEX `name` (`name`),
ADD FULLTEXT INDEX `short_description` (`short_description`),
ADD FULLTEXT INDEX `description` (`description`);
-- --------------------------------------------------------
ALTER TABLE `lc_users`
ADD COLUMN `email` VARCHAR(128) NOT NULL AFTER `username`,
CHANGE COLUMN `date_blocked` `date_valid_from` DATETIME NOT NULL AFTER `total_logins`,
CHANGE COLUMN `date_expires` `date_valid_to` DATETIME NOT NULL AFTER `date_valid_from`,
CHANGE COLUMN `last_ip` `last_ip` VARCHAR(39) NOT NULL AFTER `permissions`,
CHANGE COLUMN `last_host` `last_host` VARCHAR(128) NOT NULL AFTER `last_ip`,
ADD INDEX `status` (`status`),
ADD INDEX `username` (`username`),
ADD INDEX `email` (`email`);
-- --------------------------------------------------------
ALTER TABLE `lc_orders`
ADD COLUMN `starred` TINYINT(1) NOT NULL AFTER `uid`,
ADD COLUMN `reference` VARCHAR(128) NOT NULL AFTER `payment_transaction_id`;
-- --------------------------------------------------------
ALTER TABLE `lc_orders_items`
CHANGE COLUMN `sku` `sku` VARCHAR(32) NOT NULL AFTER `name`,
ADD COLUMN `gtin` VARCHAR(32) NOT NULL AFTER `sku`,
ADD COLUMN `taric` VARCHAR(32) NOT NULL AFTER `gtin`,
ADD COLUMN `dim_x` DECIMAL(11,4) NOT NULL AFTER `weight_class`,
ADD COLUMN `dim_y` DECIMAL(11,4) NOT NULL AFTER `dim_x`,
ADD COLUMN `dim_z` DECIMAL(11,4) NOT NULL AFTER `dim_y`,
ADD COLUMN `dim_class` VARCHAR(2) NOT NULL AFTER `dim_z`;
-- --------------------------------------------------------
ALTER TABLE `lc_order_statuses` ADD COLUMN `keywords` VARCHAR(256) NOT NULL AFTER `color`;
-- --------------------------------------------------------
UPDATE `lc_currencies` SET `value` = 1 / `value`;
-- --------------------------------------------------------
UPDATE `lc_orders` SET currency_value = 1 / currency_value;
-- --------------------------------------------------------
DELETE FROM `lc_translations` WHERE code = 'terms_cookies_acceptance';
-- --------------------------------------------------------
ALTER TABLE `lc_tax_rates`
ADD COLUMN `rule_companies_with_tax_id` TINYINT(1) NOT NULL AFTER `tax_id_rule`,
ADD COLUMN `rule_companies_without_tax_id` TINYINT(1) NOT NULL AFTER `rule_companies_with_tax_id`,
ADD COLUMN `rule_individuals_with_tax_id` TINYINT(1) NOT NULL AFTER `rule_companies_without_tax_id`,
ADD COLUMN `rule_individuals_without_tax_id` TINYINT(1) NOT NULL AFTER `rule_individuals_with_tax_id`;
-- --------------------------------------------------------
UPDATE `lc_tax_rates` SET rule_companies_with_tax_id = 1 WHERE customer_type IN ('both', 'companies') AND tax_id_rule IN ('both', 'with');
-- --------------------------------------------------------
UPDATE `lc_tax_rates` SET rule_companies_without_tax_id = 1 WHERE customer_type IN ('both', 'companies') AND tax_id_rule IN ('both', 'without');
-- --------------------------------------------------------
UPDATE `lc_tax_rates` SET rule_individuals_with_tax_id = 1 WHERE customer_type IN ('both', 'individuals') AND tax_id_rule IN ('both', 'with');
-- --------------------------------------------------------
UPDATE `lc_tax_rates` SET rule_individuals_without_tax_id = 1 WHERE customer_type IN ('both', 'individuals') AND tax_id_rule IN ('both', 'without');
-- --------------------------------------------------------
ALTER TABLE `lc_tax_rates`
DROP COLUMN `customer_type`,
DROP COLUMN `tax_id_rule`;
-- --------------------------------------------------------
ALTER TABLE `lc_categories`
DROP COLUMN `dock`;
-- --------------------------------------------------------
DELETE FROM `lc_settings` WHERE `key` = 'seo_links_enabled';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'text()' WHERE `function` IN ('input()', 'smallinput()', 'smalltext()');
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'country()' WHERE `function` = 'countries()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'currency()' WHERE `function` = 'currencies()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'timezone()' WHERE `function` = 'timezones()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'language()' WHERE `function` = 'languages()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'zone()' WHERE `function` = 'zones()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'weight_class()' WHERE `function` = 'weight_classes()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'length_class()' WHERE `function` = 'length_classes()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'tax_class()' WHERE `function` = 'tax_classes()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'quantity_unit()' WHERE `function` = 'quantity_units()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'sold_out_status()' WHERE `function` = 'sold_out_statuses()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'delivery_status()' WHERE `function` = 'delivery_statuses()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'number()' WHERE `function` = 'int()';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'template("admin")' WHERE `function` = 'templates("admin")';
-- --------------------------------------------------------
UPDATE `lc_settings` SET `function` = 'template("catalog")' WHERE `function` = 'templates("catalog")';
