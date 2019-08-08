--/*
--##########################################
--## AUTOR=MIGUEL LOPEZ
--## FECHA_CREACION=20190805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-7180
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_MAT_MOTIVO_AUTO_TRAM';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_MAT_MOTIVO_AUTO_TRAM';  -- Tabla a modificar    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-7180'; -- USUARIOCREAR/USUARIOMODIFICAR
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'Autorizado por entidad cliente', 'Autorizado por entidad cliente'),
        T_TIPO_DATA('02', 'Tramitación anterior tuvo que ser anulada para la corrección de datos', 'Tramitación anterior tuvo que ser anulada para la corrección de datos'),
        T_TIPO_DATA('03', 'Otros', 'Otros')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en DD_MAT_MOTIVO_AUTO_TRAM -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MAT_MOTIVO_AUTO_TRAM] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MAT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
		
		IF V_NUM_TABLAS = 0 THEN    
				--Insertar datos
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			EXECUTE IMMEDIATE '
					INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					   DD_MAT_ID
					  ,DD_MAT_CODIGO
					  ,DD_MAT_DESCRIPCION
				  ,DD_MAT_DESCRIPCION_LARGA
					  ,VERSION
					  ,USUARIOCREAR
					  ,FECHACREAR
					  ,BORRADO
					)   
					SELECT
					  '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
					  , '''||V_TMP_TIPO_DATA(1)||'''
					  , '''||V_TMP_TIPO_DATA(2)||'''
					  , '''||V_TMP_TIPO_DATA(3)||'''
					  , 0
					  , '''||V_USR||'''
					  , SYSDATE
				  , 0
					FROM DUAL
					'
					;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		end if;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MAT_MOTIVO_AUTO_TRAM ACTUALIZADO CORRECTAMENTE ');
   

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



   
