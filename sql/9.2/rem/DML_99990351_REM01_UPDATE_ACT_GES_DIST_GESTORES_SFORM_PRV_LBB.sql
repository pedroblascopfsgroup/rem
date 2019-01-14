--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1571
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_GES_DIST_GESTORES. Cambia  psanchez por abenavides
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'REMVIP-1571'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
			
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                                 SET   T1.USERNAME = ''abenavides''
                                     , T1.NOMBRE_USUARIO = (SELECT USU_NOMBRE FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''abenavides'')
                                     , T1.USUARIOMODIFICAR = ''REMVIP-1571''
                                     , T1.FECHAMODIFICAR = SYSDATE
                                 WHERE T1.TIPO_GESTOR = ''SFORM''
                                   AND T1.COD_CARTERA = 8';
			
			EXECUTE IMMEDIATE V_SQL;
		
		ELSE
	
			DBMS_OUTPUT.PUT_LINE('[ERROR]: LA TABLA '||V_TEXT_TABLA||' NO EXISTE');

		END IF;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]:  '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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

EXIT;
