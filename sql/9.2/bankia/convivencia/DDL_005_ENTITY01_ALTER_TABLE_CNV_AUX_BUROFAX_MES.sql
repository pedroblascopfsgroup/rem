/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20160425
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.00
--## INCIDENCIA_LINK=BKREC-1907
--## PRODUCTO=NO
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema minirec*/
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /* Configuracion Esquema recovery_bankia_dwh*/
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /* Configuracion Esquema recovery_bankia_datastage*/

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[START] Modificamos la tabla CNV_AUX_BUROFAX_MES');	

	BEGIN
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM user_tab_cols WHERE UPPER(table_name) = 'CNV_AUX_BUROFAX_MES' and UPPER(column_name) = 'PROCESADO' AND NULLABLE = 'N';
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES MODIFY PROCESADO NULL';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES.PROCESADO modificado a nulable');
		END IF;	
		
    EXCEPTION
    WHEN OTHERS THEN
      NULL ;
    END ;
	
	BEGIN
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM user_tab_cols WHERE UPPER(table_name) = 'CNV_AUX_BUROFAX_MES' and UPPER(column_name) = 'NO_ENVIO' AND NULLABLE = 'N';
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES MODIFY NO_ENVIO NULL';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES.NO_ENVIO modificado a nulable');
		END IF;	
		
    EXCEPTION
    WHEN OTHERS THEN
      NULL ;
    END ;	

    BEGIN
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM user_tab_cols WHERE UPPER(table_name) = 'CNV_AUX_BUROFAX_MES' and UPPER(column_name) = 'CODIGO_POSTAL_DEST' AND NULLABLE = 'N' ;
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES MODIFY CODIGO_POSTAL_DEST NULL';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_BUROFAX_MES.CODIGO_POSTAL_DEST modificado');
		END IF;			
		
    EXCEPTION
    WHEN OTHERS THEN
      NULL ;
    END ;	
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
	