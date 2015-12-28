/*
--##########################################
--## AUTOR=Alejandro Iñigo
--## FECHA_CREACION=20151215
--## ARTEFACTO=apr_main_integra_liquidacion
--## VERSION_ARTEFACTO=2.13
--## INCIDENCIA_LINK=BKREC-1535
--## PRODUCTO=SI
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


    /*  tabla RCB_RECIBOS_LIQ <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] Comprobamos si existen campos');
	
    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'RCB_RECIBOS_LIQ' AND COLUMN_NAME = 'RCB_IMCGTA_ORIGINAL' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ ADD RCB_IMCGTA_ORIGINAL NUMBER(15,2)';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMCGTA_ORIGINAL añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMCGTA_ORIGINAL ya existente.');
    end if;

    select count(1) into V_NUM_TABLAS from ALL_TAB_COLUMNS where table_name = 'RCB_RECIBOS_LIQ' AND COLUMN_NAME = 'RCB_IMDEUD_ORIGINAL' ;
    if V_NUM_TABLAS = 0 then
        EXECUTE IMMEDIATE ' ALTER TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ ADD RCB_IMDEUD_ORIGINAL NUMBER(15,2)';
        DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMDEUD_ORIGINAL añadida correctamente.');
	else
	  DBMS_OUTPUT.PUT_LINE('COLUMNA '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMDEUD_ORIGINAL ya existente.');
    end if;	  		  	

DBMS_OUTPUT.PUT_LINE('[END] Modificación Tabla RCB_RECIBOS_LIQ');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
