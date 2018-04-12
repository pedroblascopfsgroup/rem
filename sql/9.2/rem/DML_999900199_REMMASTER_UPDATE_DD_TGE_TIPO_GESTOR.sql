--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20180404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3924
--## PRODUCTO=NO
--## Finalidad: Actualización en la tabla TGE para borrar el gestor 'Gestoría recovery' de manera lógica.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE.
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TGE_TIPO_GESTOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_COD_GESTOR VARCHAR2(30 CHAR) := 'GESTREC'; -- Vble. auxiliar.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-3924'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.


BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********');
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si el gestor existe y no se encuentra borrado.
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE DD_TGE_CODIGO = '''||V_TEXT_COD_GESTOR||''' and BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT('[INFO] El gestor existe y no está borrado, se procede a su borrado lógico...');
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' SET BORRADO = 1, USUARIOBORRAR = '||V_USU_MODIFICAR||', FECHABORRAR = sysdate WHERE DD_TGE_CODIGO = '''||V_TEXT_COD_GESTOR||'''';
		DBMS_OUTPUT.PUT_LINE('OK');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] El gestor no existe o ya se encuentra borrado.');
	END IF;

	DBMS_OUTPUT.PUT_LINE('[END] Finalizado.');


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT