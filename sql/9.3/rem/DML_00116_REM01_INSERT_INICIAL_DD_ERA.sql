--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20200520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10298
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_ERA_ESTADO_REG_ACTIVO
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
    V_TABLA VARCHAR2(50 CHAR):= 'DD_ERA_ESTADO_REG_ACTIVO';
    V_CHARS VARCHAR2(3 CHAR):= 'ERA';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-10298';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- CODIGO  			DESCRIPCION     DESCRIPCION_LARGA
      T_TIPO_DATA('EDF_TER',		 'Edificación Terminada'),
      T_TIPO_DATA('CON_JUR',		 'En construcción (jurídica)'),
      T_TIPO_DATA('EDF_WIP',		 'Edificación obra en curso'),
      T_TIPO_DATA('EXC_S20',     'Discrepancia físico-jurídica/Exceso cabida > al 20%'),
      T_TIPO_DATA('EXC_I20',     'Discrepancia físico-jurídica/Exceso cabida < al 20%'),
      T_TIPO_DATA('EXC_SIM',     'Discrepancia físico-jurídica/Sin inmatricular'),
      T_TIPO_DATA('EXC_CDU',     'Discrepancia físico-jurídica/Cambio de uso'),
      T_TIPO_DATA('EXC_CDR',     'Discrepancia físico-jurídica/Cambio descripción registral'),
      T_TIPO_DATA('EXC_DHO',     'Discrepancia físico-jurídica/División horizontal'),
      T_TIPO_DATA('CIL_IUR',     'Construcción ilegal/Irregularidades urbanísticas'),
      T_TIPO_DATA('CIL_FOR',     'Contrucción ilegal/Fuera de ordenación'),
      T_TIPO_DATA('ACT_IRR',     'Activo irregular')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	    USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				DD_'||V_CHARS||'_ID, DD_'||V_CHARS||'_CODIGO, DD_'||V_CHARS||'_DESCRIPCION, DD_'||V_CHARS||'_DESCRIPCION_LARGA, 
				VERSION, USUARIOCREAR, FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '''||V_TMP_TIPO_DATA(1)||''',
	            '''||V_TMP_TIPO_DATA(2)||''',
	            '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	            0, '''||V_USUARIO||''', SYSDATE FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;

    END LOOP;
  COMMIT;
   

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
