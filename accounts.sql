-- MH Konten erstellen
SET @contact_id := 1;
SELECT @iban := id FROM civicrm_option_value WHERE name='IBAN';

-- ROLLBACK:
-- DELETE FROM civicrm_bank_account_reference WHERE civicrm_bank_account_reference.ba_id IN (SELECT id FROM civicrm_bank_account WHERE contact_id=@contact_id);
-- DELETE FROM FROM civicrm_bank_account WHERE contact_id=@contact_id;

-- Ing Belgium account
INSERT INTO civicrm_bank_account (`description`, `created_date`, `modified_date`, `data_raw`, `data_parsed`, `contact_id`) 
                          VALUES ('Ing Belgium', NOW(), NOW(), '{}', '{"country": "BE", "BIC": "BBRUBEBB", "name": "Ing Belgium"}', @contact_id);
SET @kto := LAST_INSERT_ID();     
-- replace with real IBAN:
INSERT INTO civicrm_bank_account_reference (`reference`, `reference_type_id`, `ba_id`)
                                    VALUES ("BEXXXXXXXXXXXXXX", @iban, @kto);

