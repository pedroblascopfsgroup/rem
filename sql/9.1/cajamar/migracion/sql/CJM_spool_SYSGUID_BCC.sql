SET TERMOUT OFF HEADING OFF FEEDBACK OFF ECHO OFF PAGESIZE 0 LINESIZE 200
SPOOL dat/sysguid_pks_BCC.dat
SELECT   
    GUID_ID|| ';' || 
    GUID_SYSGUID|| ';' || 
    GUID_ASU_ID_EXTERNO|| ';' || 
    GUID_DES|| ';' || 
    GUID_DD_TPO_CODIGO|| ';' || 
    GUID_BIE_CODIGO_INTERNO|| ';' || 
    GUID_CNT_CONTRATO|| ';' || 
    TRIM(GUID_TAP_CODIGO)|| ';' || 
    TRIM(GUID_DD_PCO_PEP_CODIGO)|| ';' || 
    TRIM(GUID_DD_TFA_CODIGO)|| ';' || 
    TRIM(GUID_PCO_DOC_PDD_DESC)|| ';' || 
    TRIM(GUID_DD_PCO_DTD_CODIGO)
FROM CM01.TMP_GUID_BCC
ORDER BY GUID_DES DESC;
SPOOL OFF;
set echo on heading on feedback on termout on

EXIT;
