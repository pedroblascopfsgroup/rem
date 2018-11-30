--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=2018113029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-alquileres
--## INCIDENCIA_LINK=HREOS-4844
--## PRODUCTO=NO
--##
--## Finalidad: Añadir registros en USD_USUARIOS_DESPACHOS
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
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USD_USUARIOS_DESPACHOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		
         T_TIPO_DATA('GESTCOMALQ', 'fmartin'   ), 
         T_TIPO_DATA('GESTCOMALQ', 'mvillamor' ),  
         T_TIPO_DATA('GESTCOMALQ', 'jxerri'    ), 
         T_TIPO_DATA('GESTCOMALQ', 'ralvarez'  ), 
         T_TIPO_DATA('GESTCOMALQ', 'ralvarez'  ), 

         T_TIPO_DATA('SUPCOMALQ' , 'sbejarano' )

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- LOOP para insertar o modificar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) 
		  FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO, ' ||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS, ' ||V_ESQUEMA_M||'.USU_USUARIOS 
        	  WHERE DES_DESPACHO_EXTERNO.DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' '||	
		' AND USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '|| 
		' AND DES_DESPACHO_EXTERNO.DES_ID = USD_USUARIOS_DESPACHOS.DES_ID
		  AND USD_USUARIOS_DESPACHOS.USU_ID = USU_USUARIOS.USU_ID ' ;	

        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
          DBMS_OUTPUT.PUT_LINE( '#REG: ' || V_NUM_REG );

        --Si existe lo modificamos
        IF V_NUM_REG = 0 THEN				
  
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
                      	'USD_ID, 
			 USU_ID,
			 DES_ID,
			 USD_GESTOR_DEFECTO,
			 USD_SUPERVISOR,
			 VERSION,
			 USUARIOCREAR,
			 FECHACREAR,
			 BORRADO
			 )
                      	SELECT '|| V_ID || ', 
			 ( SELECT USU.USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU 
			   WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||'
			 ( SELECT DES.DES_ID FROM '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO DES 
			   WHERE DES.DES_DESPACHO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
			', 1, 1, 0, ''HREOS-4844'',SYSDATE, 0 FROM DUAL';

          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT CORRECTO');
        
       END IF;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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
