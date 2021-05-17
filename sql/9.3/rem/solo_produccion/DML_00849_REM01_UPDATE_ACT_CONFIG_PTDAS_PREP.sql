--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9713
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-9713';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_GLD VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
          T_TIPO_DATA(13895475),
          T_TIPO_DATA(13914758),
          T_TIPO_DATA(13914759),
          T_TIPO_DATA(13914898),
          T_TIPO_DATA(13914899),
          T_TIPO_DATA(13915052),
          T_TIPO_DATA(13915085),
          T_TIPO_DATA(13915102),
          T_TIPO_DATA(13915285)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_GLD||' ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
    V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

      V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' T1 USING (
              SELECT DISTINCT GLD_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' GLD 
              JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID AND GPV.BORRADO = 0
              WHERE GPV.GPV_NUM_GASTO_HAYA = '||V_TMP_TIPO_DATA(1)||') T2
              ON (T1.GLD_ID = T2.GLD_ID)
              WHEN MATCHED THEN UPDATE SET
              T1.GLD_CPP_BASE = ''004'', T1.GLD_APARTADO_BASE = ''05'', T1.GLD_CAPITULO_BASE = ''15'',
              T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
      EXECUTE IMMEDIATE V_MSQL;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO REGISTRO EN '||V_TEXT_TABLA_GLD||' PARA GASTO '||V_TMP_TIPO_DATA(1)||'');

    ELSE

      DBMS_OUTPUT.PUT_LINE('[INFO] GASTO '||V_TMP_TIPO_DATA(1)||' ESTA BORRADO O NO EXISTE');

    END IF;

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
