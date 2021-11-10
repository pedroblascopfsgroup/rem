--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14231
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
	V_TAP_ID NUMBER(16);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OFR_OFERTAS_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14231';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(800);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	    T_TIPO_DATA(107671, 107671),
		T_TIPO_DATA(107673, 107673),
		T_TIPO_DATA(107674, 107674),
		T_TIPO_DATA(107675, 107675),
		T_TIPO_DATA(107676, 107676),
		T_TIPO_DATA(107677, 107677),
		T_TIPO_DATA(107678, 107678),
		T_TIPO_DATA(107679, 107679),
		T_TIPO_DATA(107680, 107680),
		T_TIPO_DATA(107681, 107681),
		T_TIPO_DATA(107682, 107682),
		T_TIPO_DATA(107683, 107683),
		T_TIPO_DATA(107693, 107693),
		T_TIPO_DATA(108729, 108729),
		T_TIPO_DATA(108730, 108730),
		T_TIPO_DATA(110161, 110161),
		T_TIPO_DATA(113987, 113987),
		T_TIPO_DATA(127436, 127436),
		T_TIPO_DATA(130836, 130836),
		T_TIPO_DATA(132862, 132862)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL VALOR CON OFR_ID '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y OFR_NUM_OFERTA_CAIXA '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
						OFR_CAIXA_ID, OFR_ID, OFR_NUM_OFERTA_CAIXA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '||V_TMP_TIPO_DATA(1)||','||TRIM(V_TMP_TIPO_DATA(2))||', 0, '''||V_USUARIO||''',SYSDATE,0 '||
					  ' FROM DUAL';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

          END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
