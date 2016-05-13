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

    /*tabla DD_PCO_BFR_RESULTADO*/

  DBMS_OUTPUT.PUT_LINE('[INI] INSERT EN '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO '); 

					 
  EXECUTE IMMEDIATE 'INSERT INTO  '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO (DD_PCO_BFR_ID, DD_PCO_BFR_CODIGO, DD_PCO_BFR_DESCRIPCION, DD_PCO_BFR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR,FECHACREAR,DD_PCO_BFR_NOTIFICADO) 
                     VALUES ('||V_ESQUEMA||'.S_DD_PCO_BFR_RESULTADO.NEXTVAL,''99'', ''No Admitido Correos'', ''No Admitido Correos'', ''00'', ''INICIAL'',SYSDATE,0) ' ;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] INSERT EN '||V_ESQUEMA||'.DD_PCO_BFR_RESULTADO ');
  

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit