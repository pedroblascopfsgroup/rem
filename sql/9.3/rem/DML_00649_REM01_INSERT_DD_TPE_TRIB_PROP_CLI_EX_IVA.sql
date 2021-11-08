--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14380
--## PRODUCTO=NO
--##
--## Finalidad: DML add valores al diccionario DD_TPE_TRIB_PROP_CLI_EX_IVA
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
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_TEXT_TABLA VARCHAR2(30):= 'DD_TPE_TRIB_PROP_CLI_EX_IVA'; -- Vble. del nombre de la tabla
    V_ID NUMBER(16); -- Vble.auxiliar para sacar un ID.
    V_ID2 NUMBER(16); -- Vble.auxiliar para sacar un ID.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                --CODIGO    DESCRIPCION
	    T_TIPO_DATA('30',	'IVA repercutido 0% (Inv.Suj.Psvo)'),
        T_TIPO_DATA('33',	'IGIC repercutido 0% (Inv.Suj.Psvo)'),
        T_TIPO_DATA('2H',	'IVA repercutido alquileres con retención 21%'),
        T_TIPO_DATA('2J',	'IVA repercutido alquileres sin retención 21%'),
        T_TIPO_DATA('HA',	'IGIC repercutido ventas 7%'),
        T_TIPO_DATA('R0',	'IVA repercutido ventas 0% (ITP)'),
        T_TIPO_DATA('R2',	'IVA repercutido alquileres 0% (viviendas)'),
        T_TIPO_DATA('R1',	'IVA repercutido ventas 4%'),
        T_TIPO_DATA('R3',	'IVA repercutido alquileres 4%'),
        T_TIPO_DATA('R8',	'IVA repercutido ventas 10%'),
        T_TIPO_DATA('R4',	'IVA repercutido alquiler 10%'),
        T_TIPO_DATA('R9',	'IVA repercutido ventas 21%'),
        T_TIPO_DATA('R5',	'IVA repercutido prestación de servicios 21%'),
        T_TIPO_DATA('RH',	'IPSI repercutido ventas 4% Melilla'),
        T_TIPO_DATA('RI',	'IPSI repercutido alquileres 4% Melilla'),
        T_TIPO_DATA('RM',	'IGIC repercutido ventas 7,0%'),
        T_TIPO_DATA('RN',	'IGIC repercutido alquileres 7,0%'),
        T_TIPO_DATA('RP',	'IGIC repercutido alquileres 6,5%'),
        T_TIPO_DATA('RS',	'IGIC Repercutido 0% (alquiler viviendas)'),
        T_TIPO_DATA('RV',	'IPSI Rep Ceuta 6%'),
        T_TIPO_DATA('RX',	'sin efecto fiscal'),
        T_TIPO_DATA('RY',	'IPSI repercutido 0% (ITP)'),
        T_TIPO_DATA('RZ',	'No sujeto IVA'),
        T_TIPO_DATA('WA',	'IGIC Repercutido 0% (ITP ventas)')

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
					WHERE DD_TPE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_TPE_ID,
              DD_TPE_CODIGO,
              DD_TPE_DESCRIPCION,
              DD_TPE_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              0,
              ''HREOS-14380'',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

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
