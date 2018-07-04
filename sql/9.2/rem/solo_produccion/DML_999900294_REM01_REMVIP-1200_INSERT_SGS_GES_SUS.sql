--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20180704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1200
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(150 CHAR); -- Descripción del estado de la reserva
   V_AUX NUMBER(1); -- Variable auxiliar
   PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN 

#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','Jalmansa','Mdiez','09/07/2018','13/07/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','Jalmansa','Mdiez','20/08/2018','31/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','jalmansa','jsanchezn','17/08/2018','17/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','Mdiez','Jalmansa','23/07/2018','16/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','egalan','fmalvarez','28/02/2018','15/01/2019',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','edilien','sbertomeu','03/09/2018','15/09/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','sbertomeu','edilien','17/09/2018','21/09/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','sbertomeu','csegura','06/08/2018','24/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','bmorant','edilien','13/08/2018','31/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','edilien','sbertomeu','09/07/2018','13/07/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','edilien','sbertomeu','30/07/2018','03/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','egomezme','bmorant','31/07/2018','10/08/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','slopez','edilien','16/07/2018','20/07/2018',PL_OUTPUT);	
	dbms_output.put_line(PL_OUTPUT);
#ESQUEMA#.SP_GESTOR_SUSTITUTO_V2('ALTA','bmorant','egomezme','04/07/2018','13/07/2018',PL_OUTPUT);
	dbms_output.put_line(PL_OUTPUT);


COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_RES;
/
EXIT;
