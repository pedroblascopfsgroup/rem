--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2774
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en ACT_GES_DIST_GESTORES los gestores sareb de Cataluña
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
    V_COUNT NUMBER(10);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-2774'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION EN '||V_TEXT_TABLA);

			
		V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
				  'SET COD_TIPO_COMERZIALZACION=null,
				   USUARIOMODIFICAR = '|| V_USU_MODIFICAR ||' ,
				   FECHAMODIFICAR = SYSDATE '||
				  'WHERE TIPO_GESTOR=''GFORM''
				   AND COD_CARTERA = 3
				   AND COD_PROVINCIA IN (8,17,25,43)
				   AND USERNAME = ''vmoreno''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TIPO_GESTOR = ''GFORM'' AND USERNAME = ''osanz'' AND COD_CARTERA = ''3'' AND COD_PROVINCIA  = ''28'' ' INTO V_COUNT;
		   
		   IF V_COUNT = 0 THEN
		  
		  	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
		 			  ID
					, TIPO_GESTOR
					, COD_CARTERA
					, COD_PROVINCIA
					, USERNAME
					, NOMBRE_USUARIO
					, USUARIOCREAR
					, FECHACREAR
		 			) VALUES (
		 			  S_'||V_TEXT_TABLA||'.NEXTVAL
		 			, ''GFORM''
		 			, 3
					, 28
		 			, ''osanz''
		 			, ''Oscar Sanz Gomez''
		 			, '||V_USU_MODIFICAR||'
		 			, SYSDATE
		 			)
				  ';
				  DBMS_OUTPUT.PUT_LINE(V_SQL);
			  EXECUTE IMMEDIATE V_SQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TEXT_TABLA);
		  ELSE
		  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario osanz ya existia en '||V_TEXT_TABLA);
		  END IF;
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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
