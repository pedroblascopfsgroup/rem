--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20211001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-15428
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_MAN_MOTIVO_ANULACION
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
	
    V_ID NUMBER(16);
    V_ID_DIC NUMBER(16);
    V_COD_DIC VARCHAR2(20 CHAR) := 'A';
    V_TABLA VARCHAR2(50 CHAR):= 'DD_MRO_MOTIVO_RECHAZO_OFERTA';
    V_CHARS VARCHAR2(3 CHAR):= 'MRO';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-15428';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --  CODIGO  			DESCRIPCION  
      T_TIPO_DATA('10', 'Cambio de titulares en la oferta', '1'),
      T_TIPO_DATA('20', 'El cliente se arrepiente', '1'),
      T_TIPO_DATA('30', 'Existe otra oferta', '1'),
      T_TIPO_DATA('40', 'Hipoteca Promotor', '1'),
      T_TIPO_DATA('50', 'Incidencias Registrales', '1'),
      T_TIPO_DATA('60', 'Modificación datos que implica la nueva oferta', '1'),
      T_TIPO_DATA('70', 'Modificación datos', '1'),
      T_TIPO_DATA('80', 'No financiación', '1'),
      T_TIPO_DATA('90', 'No financiación Caixa', '1'),
      T_TIPO_DATA('100',  'Ocupación ilegal del inmueble', '1'),
      T_TIPO_DATA('110',  'Por Error Datos', '1'),
      T_TIPO_DATA('120',  'Rechazado PBC', '1'),
      T_TIPO_DATA('130',  'Rechaz. no aporta documentación en plazo', '1'),
      T_TIPO_DATA('140',  'Incidencias técnicas', '1'),
      T_TIPO_DATA('150',  'Incumplimiento fechas', '1'),
      T_TIPO_DATA('160',  'Rechazada en comité (Servicer)', '1'),
      T_TIPO_DATA('170',  'Rechazado propiedad (BC)', '1'),
      T_TIPO_DATA('180',  'Anulación por recarga oferta', '1'),
      T_TIPO_DATA('190',  'Scoring rechazado', '1'),
      T_TIPO_DATA('200',  'Garantías rechazadas', '1'),
      T_TIPO_DATA('210',  'Oferta en lista de espera alquilado', '1'),
      T_TIPO_DATA('220',  'El cliente se arrepiente', '1'),
      T_TIPO_DATA('230',  'Datos erróneos en la oferta', '1'),
      T_TIPO_DATA('240',  'Modificaciones de clausulas', '1'),
      T_TIPO_DATA('250',  'Inmueble no adecuado', '1'),
      T_TIPO_DATA('260',  'Documento de reserva caducado.', '1'),
      T_TIPO_DATA('270',  'Falta boletines', '1'),
      T_TIPO_DATA('280',  'Incidencia Técnica', '1'),
      T_TIPO_DATA('290',  'Faltan llaves', '1'),
      T_TIPO_DATA('300',  'Condiciones de garantías adicionales', '1'),
      T_TIPO_DATA('310',  'Condiciones de Obligado cumplimiento', '1'),
      T_TIPO_DATA('320',  'Condiciones generales del contrato', '1'),
      T_TIPO_DATA('330',  'Inmueble dado de baja', '1'),
      T_TIPO_DATA('340',  'Falta CEE', '1'),
      T_TIPO_DATA('350',  'Inmueble no adecuado', '1'),
      T_TIPO_DATA('360',  'Cliente ha alquilado otro inmueble', '1'),
      T_TIPO_DATA('370',  'Cliente desestima por zona', '1'),
      T_TIPO_DATA('380',  'Cliente desestima por precio', '1')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = CONCAT('''||TRIM(V_TMP_TIPO_DATA(1))||''', ''00'')';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      V_SQL := 'SELECT DD_TRO_ID FROM '||V_ESQUEMA||'.DD_TRO_TIPO_RECHAZO_OFERTA WHERE DD_TRO_CODIGO = '''||V_COD_DIC||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_ID_DIC;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''00');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(1))||''',
            DD_'||V_CHARS||'_VISIBLE_CAIXA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
            DD_'||V_CHARS||'_VENTA = 0,
            DD_'||V_CHARS||'_ALQUILER = 0,
            DD_TRO_ID = '||V_ID_DIC||',
	    USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = CONCAT('''||TRIM(V_TMP_TIPO_DATA(1))||''', ''00'')
			    ';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''00');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				DD_'||V_CHARS||'_ID, DD_'||V_CHARS||'_CODIGO, DD_'||V_CHARS||'_DESCRIPCION, DD_'||V_CHARS||'_DESCRIPCION_LARGA, 
				VERSION, USUARIOCREAR, FECHACREAR, DD_'||V_CHARS||'_CODIGO_C4C, DD_'||V_CHARS||'_VISIBLE_CAIXA, DD_'||V_CHARS||'_VENTA, DD_'||V_CHARS||'_ALQUILER,
        DD_TRO_ID)
          	SELECT 
	            '|| V_ID || ',
	            CONCAT('''||V_TMP_TIPO_DATA(1)||''', ''00''),
	            '''||V_TMP_TIPO_DATA(2)||''',
	            '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	            0, '''||V_USUARIO||''', SYSDATE, '||V_TMP_TIPO_DATA(1)||', '''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, 0, '||V_ID_DIC||' FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;

    END LOOP;

    V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_VISIBLE_CAIXA = 0,
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
          WHERE DD_'||V_CHARS||'_VISIBLE_CAIXA IS NULL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS CORRECTAMENTE');
    --ROLLBACK;
    COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

        DBMS_OUTPUT.put_line(V_MSQL);

        DBMS_OUTPUT.put_line(V_SQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
