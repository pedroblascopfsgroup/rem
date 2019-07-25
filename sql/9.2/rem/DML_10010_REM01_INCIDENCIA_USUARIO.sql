--/*
--##########################################
--## AUTOR=Sergio Salt Moya
--## FECHA_CREACION=20190728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7219
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el grupo de usuarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_APELLIDO1 LIKE ''%APELLIDO%'' OR USU_APELLIDO2 LIKE ''%APELLIDO%''' ;
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
	IF V_NUM_TABLAS > 0 THEN
		V_SQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_APELLIDO1 = NULL, USU_APELLIDO2 = NULL , USUARIOMODIFICAR = ''HREOS-7219'' WHERE USU_APELLIDO1 LIKE ''%APELLIDO%'' OR USU_APELLIDO2 LIKE ''%APELLIDO%''';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] USUARIO NO ENCONTRADO ');
	END IF;
   COMMIT;
   
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
