-- mysql --default-character-set=UTF8 -p -u civicrm civicrm

-- save mode & disable backslashes
SET @@sql_mode=CONCAT_WS(',', @@sql_mode, 'NO_BACKSLASH_ESCAPES');

-- See types
SELECT id, name, description, enabled, weight, plugin_type_id, plugin_class_id FROM civicrm_bank_plugin_instance order by weight;
UPDATE civicrm_bank_plugin_instance SET config='' WHERE id=;

-- Update campaigns:
-- UPDATE `civicrm_campaign` SET `external_identifier` = LEFT(`name`,4) WHERE `external_identifier` IS NULL;

-- enable backslashes

-- Gather the types
SELECT @type_importer := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.value=1
    AND civicrm_option_group.name='civicrm_banking.plugin_classes';

SELECT @type_matcher := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.value=2
    AND civicrm_option_group.name='civicrm_banking.plugin_classes';

SELECT @type_exporter := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.value=3
    AND civicrm_option_group.name='civicrm_banking.plugin_classes';



-- IMPORTERS

SELECT @plugin_class := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.name='importer_xml'
    AND civicrm_option_group.name='civicrm_banking.plugin_types';
INSERT INTO civicrm_bank_plugin_instance (`plugin_type_id`, `plugin_class_id`, `name`, `description`, `enabled`, `weight`, `config`, `state`)
  VALUES (@type_importer, @plugin_class, 'CAMT.53 (XML) Importer', 'Imports XML files', 1, 100, '{}', '{}');


-- ANALYSERS

SELECT @plugin_class := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.name='analyser_regex'
    AND civicrm_option_group.name='civicrm_banking.plugin_types';
INSERT INTO civicrm_bank_plugin_instance (`plugin_type_id`, `plugin_class_id`, `name`, `description`, `enabled`, `weight`, `config`, `state`)
  VALUES (@type_matcher, @plugin_class, 'SEPA Status codes', 'Looks SEPA status codes', 1, 35, '{}', '{}');

-- MATCHERS

-- SELECT @plugin_class := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
--   WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
--     AND civicrm_option_value.name='matcher_contribution'
--     AND civicrm_option_group.name='civicrm_banking.plugin_types';
-- INSERT INTO civicrm_bank_plugin_instance (`plugin_type_id`, `plugin_class_id`, `name`, `description`, `enabled`, `weight`, `config`, `state`)
--   VALUES (@type_matcher, @plugin_class, 'Contribution by invoice ID', 'suggestes contributions proposed by invoice analyser', 1, 61, '{}', '{}');

SELECT @plugin_class := civicrm_option_value.id FROM civicrm_option_value, civicrm_option_group 
  WHERE civicrm_option_value.option_group_id = civicrm_option_group.id 
    AND civicrm_option_value.name='matcher_default'
    AND civicrm_option_group.name='civicrm_banking.plugin_types';
INSERT INTO civicrm_bank_plugin_instance (`plugin_type_id`, `plugin_class_id`, `name`, `description`, `enabled`, `weight`, `config`, `state`)
  VALUES (@type_matcher, @plugin_class, 'Default Options', 'Provides the user with some default processing options.', 1, 100, '{}', '{}');
