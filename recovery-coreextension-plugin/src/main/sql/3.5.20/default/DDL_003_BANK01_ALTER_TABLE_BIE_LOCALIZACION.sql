--/*
--##########################################
--## AUTOR=RAFA
--## FECHA_CREACION=20150505
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1241
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo en BIE_LOCALIZACION
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;




--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN



DBMS_OUTPUT.PUT_LINE('[START]  tabla BIE_LOCALIZACION');

EXECUTE IMMEDIATE 'select count(1) from ALL_TAB_COLUMNS where COLUMN_NAME=''DD_TVI_ID'' and TABLE_NAME=''BIE_LOCALIZACION'' and owner = ''' || v_schema || '''' into v_table_count;

if v_table_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.BIE_LOCALIZACION... Ya existe');
else 

EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION  ADD  DD_TVI_ID NUMBER (16,0)';

EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION ADD CONSTRAINT FK_TVI_BIE_LOC FOREIGN KEY
(
  DD_TVI_ID 
)
REFERENCES '|| v_schema_MASTER ||'.DD_TVI_TIPO_VIA
(
  DD_TVI_ID 
)';



	DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION ADD  DD_TVI_ID ... OK');

end if;


EXECUTE IMMEDIATE 'select count(1) from ALL_TAB_COLUMNS where COLUMN_NAME=''DD_CIC_ID'' and TABLE_NAME=''BIE_LOCALIZACION'' and owner = ''' || v_schema || '''' into v_table_count;

if v_table_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.BIE_LOCALIZACION... Ya existe');
else 

EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION ADD  DD_CIC_ID NUMBER (16)';

EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION ADD CONSTRAINT FK_CIC_ID_BIE_LOC FOREIGN KEY
(
  DD_CIC_ID 
)
REFERENCES '|| v_schema_MASTER ||'.DD_CIC_CODIGO_ISO_CIRBE
(
  DD_CIC_ID 
)';

	DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION ADD COLUMN  DD_CIC_ID ... OK');

end if;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT