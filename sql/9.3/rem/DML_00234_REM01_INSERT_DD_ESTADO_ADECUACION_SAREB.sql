--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11930
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EAS_ESTADO_ADECUACION_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('4','SELECCION DE ACTIVOS'),
      T_TIPO_DATA('5','PREPARACION DE PROPUESTA'),
      T_TIPO_DATA('6','DECISION TERRITORIAL'),
      T_TIPO_DATA('7','ENCARGO'),
      T_TIPO_DATA('8','EJECUCION'),
      T_TIPO_DATA('9','DESESTIMADA - MANTENIMIENTO'),
      T_TIPO_DATA('10','DESESTIMADA - SIN CFO'),
      T_TIPO_DATA('11','DESESTIMADA - ESTRATEGIA COMERCIAL'),
      T_TIPO_DATA('12','DESESTIMADA - BLOQUEADA'),
      T_TIPO_DATA('13','DESESTIMADA - ILIQUIDA'),
      T_TIPO_DATA('14','DESESTIMADA - OCUPADA'),
      T_TIPO_DATA('15','DESESTIMADA - MARGEN'),
      T_TIPO_DATA('16','DESESTIMADA - ILEGALIZABLE'),
      T_TIPO_DATA('21','DESESTIMADA - CCPP'),
      T_TIPO_DATA('22','DESESTIMADA - VENTA EN ESTADO ACTUAL'),
      T_TIPO_DATA('23','DESESTIMADA - GESTION URBANISTICA'),
      T_TIPO_DATA('24','DESESTIMADA - CSO MARGEN'),
      T_TIPO_DATA('25','DESESTIMADA - CSO ESTRATEGIA COMERCIAL'),
      T_TIPO_DATA('27','EN GESTION - CCPP'),
      T_TIPO_DATA('17','LICITACION'),
      T_TIPO_DATA('28','LICENCIA'),
      T_TIPO_DATA('18','OBRA'),
      T_TIPO_DATA('19','LEGALIZACION'),
      T_TIPO_DATA('20','FINALIZADA - PDTE CCPP'),
      T_TIPO_DATA('26','FINALIZADA - INCLUIDO CCPP'),
      T_TIPO_DATA('29','PARALIZADA'),
      T_TIPO_DATA('30','PARALIZADA CRISIS SANITARIA'),
      T_TIPO_DATA('31','ESTUDIO SERVICER')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_EAS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: El registro '''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
       ELSE
       	-- Si no existe se inserta.
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
					  DD_EAS_ID,
					  DD_EAS_CODIGO,
					  DD_EAS_DESCRIPCION,
					  DD_EAS_DESCRIPCION_LARGA,
					  VERSION,
					  USUARIOCREAR,
					  FECHACREAR,
					  BORRADO
					  ) VALUES (
					  '||V_ID||',
					  '''||TRIM(V_TMP_TIPO_DATA(1))||''',
					  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
					  '''||TRIM(V_TMP_TIPO_DATA(2))||''',
					  0,
					  ''HREOS-11930'',
					  SYSDATE,
					  0
                      )';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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
