DROP SEQUENCE S_ADC_ADECUACIONES_CNT;

ALTER TABLE ADC_ADECUACIONES_CNT DROP PRIMARY KEY CASCADE;

DROP TABLE ADC_ADECUACIONES_CNT CASCADE CONSTRAINTS PURGE;