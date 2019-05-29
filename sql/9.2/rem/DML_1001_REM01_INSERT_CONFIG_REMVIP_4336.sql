--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4344
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4344'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TAP_ID NUMBER(16); 

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	------------ ID -------------------------- CODIGO 
	T_TIPO_DATA('proveedor.tinsa','tin.tinsa'),
	T_TIPO_DATA('proveedor.homeserve','home.reparalia'),
	T_TIPO_DATA('proveedor.aesctectonica','gen.2039676'),
	T_TIPO_DATA('proveedor.cee.bankia','cenahi04')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TABLA CONFIG');
        
      EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CONFIG MODIFY ID VARCHAR2(50CHAR)';  

      FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
	  V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		  V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CONFIG
				WHERE ID = ''' || TRIM(V_TMP_TIPO_DATA(1)) || '''';

	  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;
        
		  IF ( V_NUM_FILAS = 0 ) THEN
		  
			  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL CODIGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
		       	  V_MSQL := '
				      INSERT INTO '|| V_ESQUEMA ||'.CONFIG (ID,VALOR) VALUES
				      ( '''||TRIM(V_TMP_TIPO_DATA(1))||''',
						'''||TRIM(V_TMP_TIPO_DATA(2))||''')';
                            
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS '||SQL%ROWCOUNT||' CORRECTAMENTE');

			DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO '|| TRIM(V_TMP_TIPO_DATA(1))||' INSERTADO CORRECTAMENTE');
	
		ELSE
	
			DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO '|| TRIM(V_TMP_TIPO_DATA(1))||' , YA EXISTE');
	
		END IF;
	    
        END LOOP;
		
	COMMIT;
 
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

