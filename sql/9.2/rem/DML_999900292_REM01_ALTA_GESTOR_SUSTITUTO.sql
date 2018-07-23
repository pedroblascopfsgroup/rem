--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1357
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestor sustituto
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
	PL_OUTPUT VARCHAR2(20000 CHAR);

BEGIN

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','avegasg','jgarciamoz','18/07/18','30/07/18',PL_OUTPUT); 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','edilien','sbertomeu','03/09/18','14/09/18',PL_OUTPUT); 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','egomezme','bmorant','03/09/18','13/09/18',PL_OUTPUT); 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','egomezme','slopez','13/08/18','17/08/18',PL_OUTPUT); 
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','ksteiert','mperezd','23/07/18','02/08/18',PL_OUTPUT); 

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
