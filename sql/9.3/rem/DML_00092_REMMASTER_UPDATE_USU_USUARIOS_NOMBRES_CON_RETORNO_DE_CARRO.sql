--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6624
--## PRODUCTO=NO
--##
--## Finalidad:	remplaza caracter retorno de carro del nombre de los usuarios
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-6624';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_NOMBRE LIKE ''%''|| CHR(13) ||''%'' OR USU_APELLIDO1 LIKE ''%''|| CHR(13) ||''%'' OR USU_APELLIDO2 LIKE ''%''|| CHR(13) ||''%'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_NOMBRE = REPLACE(USU_NOMBRE, CHR(13)), 
					USU_APELLIDO1 = REPLACE(USU_APELLIDO1, CHR(13)), 
					USU_APELLIDO2 = REPLACE(USU_APELLIDO2, CHR(13)),
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE 
					WHERE USU_NOMBRE LIKE ''%''|| CHR(13) ||''%'' OR USU_APELLIDO1 LIKE ''%''|| CHR(13) ||''%'' OR USU_APELLIDO2 LIKE ''%''|| CHR(13) ||''%'' ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' usuarios actualizados');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ningun usuario para actualizar.');
		
	END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ');


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
