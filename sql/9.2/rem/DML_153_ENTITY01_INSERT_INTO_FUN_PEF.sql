--/*
--##########################################
--## AUTOR=Alvaro Valero
--## FECHA_CREACION=20190805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7367
--## PRODUCTO=NO
--##
--## Finalidad:	Añade en la tabla FUN_PEF dos nuevas asignaciones
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
  V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_LINES NUMBER(16); -- Vble. para validar la existencia de los registros.   
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'FUN_PEF'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  V_TEXT_TABLA_PEF VARCHAR2(2400 CHAR) := 'PEF_PERFILES';
  V_TEXT_TABLA_FUN VARCHAR2(2400 CHAR) := 'FUN_FUNCIONES';
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_ID_PEF NUMBER(16);
  V_ID_FUN NUMBER(16);
  V_USU VARCHAR2(2400 CHAR) := 'HREOS-7367';

  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      
    -- TAP_ID, TCP_ACTIVADA, TCP_PERMITIDA
    T_TIPO_DATA('AUTOTRAMOFR', 'AUTORIZAR_TRAMITACION_OFERTA'),
    T_TIPO_DATA('HAYASUPER', 'AUTORIZAR_TRAMITACION_OFERTA')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	-- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS = 1 THEN 

    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
    
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      V_MSQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PEF||' WHERE PEF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_MSQL INTO V_ID_PEF;

      V_MSQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA_FUN||' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_MSQL INTO V_ID_FUN;

      IF V_ID_PEF IS NOT NULL AND V_ID_FUN IS NOT NULL THEN
        --Comprobamos si los datos ya existen
        V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          WHERE PEF_ID = '||V_ID_PEF||'
          AND FUN_ID = '||V_ID_FUN||'
          AND BORRADO = 0 ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_LINES;

        IF V_NUM_LINES = 0 THEN

          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
              'FP_ID,
              PEF_ID,
              FUN_ID,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO)' ||
            'SELECT '|| V_ID || ',
              '|| V_ID_PEF ||',
              '||V_ID_FUN||',
              '''||V_USU||'''
              , SYSDATE
              ,0 
              FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO PARA FP: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' ');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: DATOS YA REGISTRADOS'); 
        END IF;
      ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN LAS CLAVES AJENAS'); 
      END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');
  ELSE 
    DBMS_OUTPUT.PUT_LINE('[FIN]: LA TABLA '||V_TEXT_TABLA||' NO EXISTE');
  END IF;

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
