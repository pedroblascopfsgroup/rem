/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20151030
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=BKREC-706
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

    /*  tabla PLD_PETICION_LIQUIDACION_DEUDA <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP INDEX tabla PLD_PETICION_LIQUIDACION_DEUDA -- IDX_PLD_PCO_LIQ_ID');
	
    
    V_NUM_TABLAS := 0;
    V_SQL:= 'select count(*) from all_indexes where index_name=''IDX_PLD_PCO_LIQ_ID'' and table_name=''PLD_PETICION_LIQUIDACION_DEUDA'' and table_owner = ''' || V_ESQUEMA_MIN || '''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
    IF (V_NUM_TABLAS=1) THEN
       EXECUTE IMMEDIATE('DROP INDEX IDX_PLD_PCO_LIQ_ID ');
	   DBMS_OUTPUT.PUT_LINE('Índice IDX_PLD_PCO_LIQ_ID borrado');
	ELSE
	   DBMS_OUTPUT.PUT_LINE('Índice IDX_PLD_PCO_LIQ_ID no encontrado');
    END IF;
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit
