--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2817
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en GEH_GESTOR_ENTIDAD_HIST los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST';
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-2817';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --GESTORES ANTERIORES      --GESTORES NUEVOS                             
        T_TIPO_DATA('SBOINM',                 'HAYASBOINM'		),
        T_TIPO_DATA('SBOFIN',                 'HAYASBOFIN' 		),
        T_TIPO_DATA('GCBOINM',                 'HAYAGBOINM'  	),
        T_TIPO_DATA('GCBOFIN',                 'HAYAGBOFIN'  	)
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_SDE_SUBTIPO_DOC_EXP -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Comprobamos el dato a insertar
     
      V_SQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' GEH '||
      			' INNER JOIN '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID '||
      			' WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
      			
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
      
        
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'] ');
      
      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' GEH '||
      				' SET GEH.DD_TGE_ID = (SELECT TGE.DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE WHERE TGE.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' '||
              							' ) '||
      				' WHERE GEH.DD_TGE_ID = (SELECT TGE2.DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR TGE2 WHERE TGE2.DD_TGE_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' '||
              									' )';
      
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
     
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

     --Si no existe
     ELSE

        
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL TIPO DE GESTOR '|| TRIM(V_TMP_TIPO_DATA(1)) ||' ESTA BIEN ASIGNADO');

     END IF;
    END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

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
