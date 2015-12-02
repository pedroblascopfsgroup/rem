--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20150728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=PRODUCTO-158
--## PRODUCTO=SI
--##
--## Finalidad: Nuevo campo ACU_IMPORTE_COSTAS en ACU_ACUERDO_PROCEDIMIENTOS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** ACU_ACUERDO_PROCEDIMIENTOS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS... Comprobaciones previas');

	-- Comprobamos si ya existe la columna
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACU_USER_PROPONENTE'' and TABLE_NAME=''ACU_ACUERDO_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS.ACU_USER_PROPONENTE... Ya existe');
	ELSE
		----Usuario proponente
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS ADD 
			(ACU_USER_PROPONENTE NUMBER(16))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.ACU_ACUERDO_PROCEDIMIENTOS ADD ACU_USER_PROPONENTE ... OK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ADD (
						CONSTRAINT ACU_USER_PROPONENTE_FK FOREIGN KEY (ACU_USER_PROPONENTE) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TGE_ID_DECISOR_FK... Creando FK');
		
		----Tipo Gestor proponente
		EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS ADD 
			(TIPO_GESTOR_PROPONENTE NUMBER(16))';
		
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.ACU_ACUERDO_PROCEDIMIENTOS ADD TIPO_GESTOR_PROPONENTE ... OK');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ADD (
						CONSTRAINT TIPO_GESTOR_PROPONENTE_FK FOREIGN KEY (TIPO_GESTOR_PROPONENTE) REFERENCES '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR (DD_TGE_ID) ON DELETE SET NULL
						)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.TIPO_GESTOR_PROPONENTE_FK... Creando FK');
		
	END IF;	


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