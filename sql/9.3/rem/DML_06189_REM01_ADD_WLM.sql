--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20221221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-19101
--## PRODUCTO=NO
--## Finalidad: Añadir matricula del CIF
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_LETRAS_TABLA VARCHAR2(2400 CHAR) := 'SDE';
	V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'DD_TDO_TIPO_DOC_ENTIDAD'; 
	V_LETRAS_TABLA2 VARCHAR2(2400 CHAR) := 'TDO';
	V_TIQUET VARCHAR2(2400 CHAR) := 'HREOS-19101';
	V_FUN VARCHAR2(30 CHAR):= 'FUN_VER_DOCUMENTOS_IDENTIDAD';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      	T_TIPO_DATA('0878')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
          V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.WLM_WHITE_LIST_MATRICULAS 
				WHERE DD_TDO_ID = (select DD_TDO_ID from '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD where DD_TDO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0)
			 	AND FUN_ID = (select FUN_ID from '||V_ESQUEMA_M||'.FUN_FUNCIONES where FUN_DESCRIPCION = '''||V_FUN||''' AND BORRADO = 0) AND BORRADO = 0';
		  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 	
		 
	      IF V_NUM_TABLAS = 0 THEN				
	      
			 DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO');
		   	 V_MSQL := '  INSERT INTO  '||V_ESQUEMA||'.WLM_WHITE_LIST_MATRICULAS (WLM_ID, FUN_ID, DD_TDO_ID, USUARIOCREAR, FECHACREAR, BORRADO)
		                    SELECT '||V_ESQUEMA||'.S_WLM_WHITE_LIST_MATRICULAS.NEXTVAL,
		                    (SELECT FUN_ID from '||V_ESQUEMA_M||'.FUN_FUNCIONES where FUN_DESCRIPCION = '''||V_FUN||'''),
							(SELECT DD_TDO_ID from '||V_ESQUEMA||'.DD_TDO_TIPO_DOC_ENTIDAD where DD_TDO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
		            		 ''HREOS-19101'', SYSDATE, 0
		                    FROM DUAL';
		                    
		      DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                    
		  EXECUTE IMMEDIATE V_MSQL;
		 END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
