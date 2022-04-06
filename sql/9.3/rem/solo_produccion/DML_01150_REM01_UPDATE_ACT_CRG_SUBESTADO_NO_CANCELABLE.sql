--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=202200307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11299
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar fechas cédulas de habitabilidad
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11299';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --ID_CARGA     subtipo carga//DD_SCG_DESCRIPCION      
        T_TIPO_DATA('14096738','21'),
        T_TIPO_DATA('14096741','21'),
        T_TIPO_DATA('14096746','21'),
        T_TIPO_DATA('14096742','21'),
        T_TIPO_DATA('14096749','21'),
        T_TIPO_DATA('14096736','21'),
        T_TIPO_DATA('14096745','21'),
        T_TIPO_DATA('14096747','21'),
        T_TIPO_DATA('14096728','21'),
        T_TIPO_DATA('21597669','21'),
        T_TIPO_DATA('27392977','21'),
        T_TIPO_DATA('21736697','21'),
        T_TIPO_DATA('35064485','21'),
        T_TIPO_DATA('41398048','21'),
        T_TIPO_DATA('41398044','21')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' acc
                         WHERE acc.CRG_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'
                         AND acc.BORRADO= 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EL REGISTRO  CRG_ID '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CON SUBESTADO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'');
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
                        SET USUARIOMODIFICAR = '''||V_USUARIO||''' 
                            , FECHAMODIFICAR = SYSDATE '||
                           ', DD_SCG_ID = (SELECT scg.DD_SCG_ID
                                            FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA scg
                                    WHERE scg.DD_SCG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
                                    AND scg.BORRADO= 0) 
                        WHERE CRG_ID = '||TRIM(V_TMP_TIPO_DATA(1))||'
                            AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE EN ACT_CRG_CARGAS');
       ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON CRG_ID:  '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
