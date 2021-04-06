--/*
--######################################### 
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20210329
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7986
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar descripciones
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-7986';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_CONFIG_SUPLIDOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

	V_NUM_TABLAS NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(42,443,2,16),
		T_TIPO_DATA(42,444,2,16),
		T_TIPO_DATA(42,443,2,18),
		T_TIPO_DATA(42,444,2,18)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = '||V_TMP_TIPO_DATA(1)||' 
					AND DD_SCR_ID = '||V_TMP_TIPO_DATA(2)||' AND DD_TGA_ID = '||V_TMP_TIPO_DATA(3)||' 
					AND DD_STG_ID = '||V_TMP_TIPO_DATA(4)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS = 0 THEN

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (SUP_ID,DD_CRA_ID,DD_SCR_ID,DD_TGA_ID,DD_STG_ID,USUARIOCREAR,FECHACREAR) VALUES (
							'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,'||V_TMP_TIPO_DATA(1)||','||V_TMP_TIPO_DATA(2)||','||V_TMP_TIPO_DATA(3)||',
							'||V_TMP_TIPO_DATA(4)||', '''||V_USU||''',SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO REGISTRO CON DD_CRA_ID = '||V_TMP_TIPO_DATA(1)||',DD_SCR_ID = '||V_TMP_TIPO_DATA(2)||',
							DD_TGA_ID = '||V_TMP_TIPO_DATA(3)||' Y DD_STG_ID = '||V_TMP_TIPO_DATA(4)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE REGISTRO CON DD_CRA_ID = '||V_TMP_TIPO_DATA(1)||',DD_SCR_ID = '||V_TMP_TIPO_DATA(2)||',
							DD_TGA_ID = '||V_TMP_TIPO_DATA(3)||' Y DD_STG_ID = '||V_TMP_TIPO_DATA(4)||'');

		END IF;

	END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;