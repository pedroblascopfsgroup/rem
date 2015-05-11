-- *************************************************************************** --
-- **                   Se actualiza el campo tipo de procedimiento          * -- 
-- *************************************************************************** --

UPDATE DD_TPO_TIPO_PROCEDIMIENTO SET DD_TAC_ID = (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP')
WHERE  DD_TPO_CODIGO='P12';

UPDATE DD_TPO_TIPO_PROCEDIMIENTO SET DD_TAC_ID = (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP')
WHERE  DD_TPO_CODIGO='P13';

