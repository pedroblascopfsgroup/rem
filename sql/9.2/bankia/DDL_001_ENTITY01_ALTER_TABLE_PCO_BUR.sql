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
	
    DBMS_OUTPUT.PUT_LINE('[START] Modificamos la tabla PCO_BUR_ENVIO');	

    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_ENVIO' and UPPER(column_name) = 'USUARIOCREAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO MODIFY USUARIOCREAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO.USUARIOCREAR modificado');
    END IF;	
	
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_ENVIO' and UPPER(column_name) = 'USUARIOMODIFICAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO.USUARIOMODIFICAR modificado');
    END IF;		
	
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_BUROFAX' and UPPER(column_name) = 'USUARIOCREAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_BUROFAX MODIFY USUARIOCREAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_BUROFAX.USUARIOCREAR modificado');
    END IF;	
	
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_BUROFAX' and UPPER(column_name) = 'USUARIOMODIFICAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_BUROFAX MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_BUROFAX.USUARIOMODIFICAR modificado');
    END IF;		
	
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_ENVIO_INTEGRACION' and UPPER(column_name) = 'USUARIOCREAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION MODIFY USUARIOCREAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION.USUARIOCREAR modificado');
    END IF;	
	
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_columns WHERE UPPER(table_name) = 'PCO_BUR_ENVIO_INTEGRACION' and UPPER(column_name) = 'USUARIOMODIFICAR';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION.USUARIOMODIFICAR modificado');
    END IF;	

    BEGIN
	
		SELECT COUNT(1) INTO V_NUM_TABLAS FROM ALL_TAB_COLUMNS WHERE UPPER(table_name) = 'PCO_BUR_ENVIO_INTEGRACION' and UPPER(column_name) = 'PCO_BUR_FEC_ACUSE' AND NULLABLE = 'N' ;
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION MODIFY PCO_BUR_FEC_ACUSE NULL';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION.PCO_BUR_FEC_ACUSE modificado');
		ELSE
		  DBMS_OUTPUT.PUT_LINE('[INFO] Campo ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION.PCO_BUR_FEC_ACUSE NULLABLE no encontrado');									
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
	