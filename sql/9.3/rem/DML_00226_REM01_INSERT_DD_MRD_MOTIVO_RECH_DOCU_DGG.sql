--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10692
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRD_MOTIVO_RECH_DOCU_DGG los datos añadidos en T_ARRAY_DATA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10692';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRD_MOTIVO_RECH_DOCU_DGG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- PARTIDA_PRESUPUESTARIA   DD_TGA_CODIGO  DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('F04', '1','WHERE NOT EXISTS (SELECT 1 FROM "#TOKEN_Schema#".GPV_GASTOS_PROVEEDOR GPV JOIN "#TOKEN_Schema#".GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID JOIN (SELECT GLDACT_AUX.GLD_ENT_ID ,GLDACT_AUX.GLD_ID, GLDACT_AUX.ENT_ID, GLDACT_AUX.GLD_PARTICIPACION_GASTO, GLDACT_AUX.GLD_REFERENCIA_CATASTRAL FROM "#TOKEN_Schema#".GLD_ENT GLDACT_AUX LEFT JOIN "#TOKEN_Schema#".DD_ENT_ENTIDAD_GASTO ENT ON GLDACT_AUX.DD_ENT_ID = ENT.DD_ENT_ID WHERE GLDACT_AUX.BORRADO = 0 AND ENT.DD_ENT_CODIGO = ''''ACT'''') GLDACT ON GLD.GLD_ID = GLDACT.GLD_ID JOIN "#TOKEN_Schema#".ACT_ACTIVO ACT ON ACT.ACT_ID = GLDACT.ENT_ID WHERE ACT.ACT_NUM_ACTIVO = AUX.T_ID_ACTIVO AND GPV.GPV_NUM_GASTO_GESTORIA = AUX.T_ID_GASTO_GESTORIA AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#) AND AUX.ID_ACTIVO is not null AND AUX.ID_GASTO_GESTORIA is not null')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE
        DD_MRD_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND PROCESO_VALIDAR  = '''||V_TMP_TIPO_DATA(2)||'''
        AND QUERY_ITER = '''||V_TMP_TIPO_DATA(3)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET 
                      QUERY_ITER = '''||V_TMP_TIPO_DATA(3)||'''
                      , USUARIOMODIFICAR = '''||V_ITEM||'''
                      , FECHAMODIFICAR = SYSDATE
                      WHERE
                        DD_MRD_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' 
                        AND PROCESO_VALIDAR  = '''||V_TMP_TIPO_DATA(2)||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');
   

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
