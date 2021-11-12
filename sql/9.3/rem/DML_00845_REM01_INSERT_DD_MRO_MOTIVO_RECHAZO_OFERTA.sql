--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14531
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza o inserta en DD_MRO_MOTIVO_RECHAZO_OFERTA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR); -- Vble principal para consulta
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(40 CHAR) := 'DD_MRO_MOTIVO_RECHAZO_OFERTA'; -- Vble. Nombre de la tabla
    V_USUARIO VARCHAR(40 CHAR) := 'HREOS-14531'; -- Usuario (Artefacto)
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Valores a insertar en DD_MRO_MOTIVO_RECHAZO_OFERTA
    TYPE T_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_DATA;

    V_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      --     DD_MRO_CODIGO  DD_MRO_DESCRIPCION  DD_MRO_DESCRIPCION_LARGA
      T_DATA('916',         'RECHAZADA PENDIENTE RECOMENDACIÓN INTERNA',         'RECHAZADA PENDIENTE RECOMENDACIÓN INTERNA')
    );
    V_TMP_DATA T_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.'|| TRIM(V_TABLA)||'... Empezando a escribir datos');
    -- LOOP Insertando valores en DD_MRO_MOTIVO_RECHAZO_OFERTA
    FOR I IN V_DATA.FIRST .. V_DATA.LAST
      LOOP
      V_TMP_DATA := V_DATA(I);
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'|| TRIM(V_TABLA)||' WHERE DD_MRO_CODIGO = '''||TRIM(V_TMP_DATA(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe updatea, si no inserta
			IF V_NUM_TABLAS > 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| TRIM(V_TABLA)||'... Ya existe '''|| TRIM(V_TMP_DATA(2))||'''');
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'|| TRIM(V_TABLA)||
						' SET DD_MRO_DESCRIPCION = '''|| TRIM(V_TMP_DATA(2))||''', DD_MRO_DESCRIPCION_LARGA = '''|| TRIM(V_TMP_DATA(3))||''', VERSION = VERSION + 1, USUARIOMODIFICAR = '''|| TRIM(V_USUARIO)||''''||
            ', FECHAMODIFICAR = SYSDATE, BORRADO = 0,DD_MRO_VENTA=1 , DD_MRO_ALQUILER=1 WHERE DD_MRO_CODIGO = ''' || TRIM(V_TMP_DATA(1))||'''  ';
				DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO REGISTRO CON EL CÓDIGO:  '''|| TRIM(V_TMP_DATA(1))||''', DONDE SE HA CAMBIADO: '''||TRIM(V_TMP_DATA(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| TRIM(V_TABLA)||'... No existe el registro con el código: '''|| TRIM(V_TMP_DATA(1))||'''');
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'|| TRIM(V_TABLA)||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
        
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| TRIM(V_TABLA)||' (' ||
						'DD_MRO_ID,  DD_TRO_ID ,DD_MRO_CODIGO, DD_MRO_DESCRIPCION, DD_MRO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DD_MRO_VENTA,DD_MRO_ALQUILER)' ||
						'SELECT '|| V_ENTIDAD_ID || ',  (SELECT DD_TRO_ID FROM '|| V_ESQUEMA ||'.DD_TRO_TIPO_RECHAZO_OFERTA WHERE DD_TRO_CODIGO = ''D'')     ,'''|| TRIM(V_TMP_DATA(1))||''','''||TRIM(V_TMP_DATA(2))||''','''||TRIM(V_TMP_DATA(3))||''','||
						'0, '''|| TRIM(V_USUARIO)||''',SYSDATE,0,1,1 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''|| TRIM(V_TMP_DATA(2))||''','''||TRIM(V_TMP_DATA(3))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'|| TRIM(V_TABLA)||'... Datos escritos');

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
  	