--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3293
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USD_USUARIOS_DESPACHOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_CHARS VARCHAR2(5 CHAR):= 'USD';
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3293';
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');
	--Comprobar el dato a insertar.
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||
			'USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''B97600001'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	     
      DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE, ACTUALIZAMOS!');
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET DES_ID = (SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''PTEC'')), '||
      ''||V_TEXT_CHARS||'_GESTOR_DEFECTO = 1, '||V_TEXT_CHARS||'_SUPERVISOR = 1, VERSION = 0, USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE, BORRADO = 0 WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''B97600001'')';
   	  EXECUTE IMMEDIATE V_MSQL;
   	  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
    ELSE
   	-- Si no existe se inserta.
   	DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE, INSERTAMOS!');
   	  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
   	  EXECUTE IMMEDIATE V_MSQL INTO V_ID;
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                  ''||V_TEXT_CHARS||'_ID, USU_ID, DES_ID, '||V_TEXT_CHARS||'_GESTOR_DEFECTO, '||V_TEXT_CHARS||'_SUPERVISOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                  'SELECT '||V_ID||', (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''B97600001''), '||
				  '(SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''PTEC'')), '||
				  '1, 1, 0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

   END IF;
   COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
