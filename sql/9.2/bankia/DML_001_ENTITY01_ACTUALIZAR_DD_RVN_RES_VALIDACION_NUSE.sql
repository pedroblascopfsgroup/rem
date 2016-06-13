/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20160401
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=2.10
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

    /*tabla DD_RVN_RES_VALIDACION_NUSE*/

  DBMS_OUTPUT.PUT_LINE('[INI] BORRADO EN '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE ');
  
  EXECUTE IMMEDIATE 'DELETE '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE 
                      WHERE NOT EXISTS ( SELECT ''X'' FROM '||V_ESQUEMA||'.CDD_CRN_RESULTADO_NUSE WHERE CRN_RESULTADO = DD_RVN_CODIGO AND CRN_DESC_RESULT = DD_RVN_DESCRIPCION ) ' ;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] BORRADO EN '||V_ESQUEMA||'.DD_RVN_RES_VALIDACION_NUSE ') ;
  

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit