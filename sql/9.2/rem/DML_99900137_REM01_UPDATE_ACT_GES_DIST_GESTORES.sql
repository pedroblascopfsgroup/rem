--/*
--##########################################
--## AUTOR=María Villanueva Mares
--## FECHA_CREACION=20170621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2291
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-2291'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION EN '||V_TEXT_TABLA);
	


			
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
					  'SET NOMBRE_USUARIO=''TECNOTRAMIT GESTION SL. Administración'',
					   USERNAME=''tecnotra02'',
					   USUARIOMODIFICAR = '|| V_USU_MODIFICAR ||' ,
					   FECHAMODIFICAR = SYSDATE '||
					  'WHERE TIPO_GESTOR=''GIAADMT''
					   AND COD_CARTERA =(SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION=''Sareb'')
					   AND COD_PROVINCIA IN (SELECT DD_PRV_ID FROM REMMASTER.DD_PRV_PROVINCIA WHERE DD_PRV_DESCRIPCION IN(''Barcelona'',''Girona'',''Lleida'',''Tarragona''))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       

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