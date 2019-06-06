--/*
--##########################################
--## AUTOR=Diego Carrasco Parra
--## FECHA_CREACION=20190605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6659
--## PRODUCTO=NO
--##
--## Finalidad: Marcar como estado del gasto pagado  
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
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); 
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--		Numero de Gasto	
		T_TIPO_DATA(9704265),
		T_TIPO_DATA(10106784),
		T_TIPO_DATA(9704266),
		T_TIPO_DATA(10106785),
		T_TIPO_DATA(10162943),
		T_TIPO_DATA(10106290),
		T_TIPO_DATA(10106786),
		T_TIPO_DATA(9704267),
		T_TIPO_DATA(10106787),
		T_TIPO_DATA(10162944),
		T_TIPO_DATA(9704268),
		T_TIPO_DATA(10106788),
		T_TIPO_DATA(10162920),
		T_TIPO_DATA(10162945),
		T_TIPO_DATA(10106789),
		T_TIPO_DATA(10010677),
		T_TIPO_DATA(10010678),
		T_TIPO_DATA(10106790),
		T_TIPO_DATA(10162946),
		T_TIPO_DATA(10106791),
		T_TIPO_DATA(10162947),
		T_TIPO_DATA(10106792),
		T_TIPO_DATA(10059596),
		T_TIPO_DATA(10059597),
		T_TIPO_DATA(10059839),
		T_TIPO_DATA(10106793),
		T_TIPO_DATA(10162948),
		T_TIPO_DATA(10162562),
		T_TIPO_DATA(10162887),
		T_TIPO_DATA(10162888),
		T_TIPO_DATA(10162949),
		T_TIPO_DATA(10162976),
		T_TIPO_DATA(10162977),
		T_TIPO_DATA(10162978),
		T_TIPO_DATA(10162979),
		T_TIPO_DATA(10162983)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en GPV_GASTOS_PROVEEDOR -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR... Empezando a insertar datos en la tabla GPV_GASTOS_PROVEEDOR');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
	    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	 --Comprobamos el dato a modificar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN       
      
		 V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	  
		V_MSQL := 'update '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR set DD_EGA_ID = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.dd_ega_estados_gasto where dd_ega_codigo = ''05'') '|| ', 			USUARIOMODIFICAR = ''HREOS-6659'' '||
		    ', FECHAMODIFICAR = SYSDATE '||
		   'WHERE GPV_NUM_GASTO_HAYA ='''||V_TMP_TIPO_DATA(1)||''' AND DD_EGA_ID != (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.dd_ega_estados_gasto where dd_ega_codigo = ''05'')';
                      
	       EXECUTE IMMEDIATE V_MSQL;
               DBMS_OUTPUT.PUT_LINE('[INFO] Gasto '''||TRIM(V_TMP_TIPO_DATA(1))||''' actualizado a DD_EGA_ID = PAGADO');

       --Si no existe 
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO NO EXISTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');  
	   end if;
       
    END LOOP;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ' ||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR... Datos de la tabla modificados');
   

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



