--/*
--###########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20180112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=GC-4753
--## PRODUCTO=NO
--## 
--## Finalidad: Marcar para reenviar entidades del detector de cambios
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  TYPE T_TIPO_DATA_PRV IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA_PRV IS TABLE OF T_TIPO_DATA_PRV;




--------------------------------------------------------------
-- INICIO ZONA PARA EDITAR            ------------------------
--------------------------------------------------------------

  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
  -- Cada ACTIVO en un T_TIPO_DATA
		--REMNIVDOS-2826
		T_TIPO_DATA('6781587'),
	T_TIPO_DATA('6781620'),
	T_TIPO_DATA('6796985'),
	T_TIPO_DATA('5948383'),
	T_TIPO_DATA('6838568'),
	T_TIPO_DATA('5968612'),
	T_TIPO_DATA('5938630'),
	T_TIPO_DATA('133071'),
	T_TIPO_DATA('133072'),
	T_TIPO_DATA('133244'),
	T_TIPO_DATA('133447'),
	T_TIPO_DATA('133448'),
	T_TIPO_DATA('133700'),
	T_TIPO_DATA('133702'),
	T_TIPO_DATA('145743'),
	T_TIPO_DATA('145744'),
	T_TIPO_DATA('145983'),
	T_TIPO_DATA('146162'),
	T_TIPO_DATA('146164'),
	T_TIPO_DATA('146427'),
	T_TIPO_DATA('148840'),
	T_TIPO_DATA('148841'),
	T_TIPO_DATA('148929'),
	T_TIPO_DATA('148952'),
	T_TIPO_DATA('148953'),
	T_TIPO_DATA('157706'),
	T_TIPO_DATA('157929'),
	T_TIPO_DATA('157931'),
	T_TIPO_DATA('157488'),
	T_TIPO_DATA('148707'),
	T_TIPO_DATA('2100000340'),
	T_TIPO_DATA('133701'),
	T_TIPO_DATA('2100000341'),
	T_TIPO_DATA('2100000342'),
	T_TIPO_DATA('2100000343'),
	T_TIPO_DATA('2100000344'),
	T_TIPO_DATA('2100000345'),
	T_TIPO_DATA('157489'),
	T_TIPO_DATA('145982'),
	T_TIPO_DATA('2100000346'),
	T_TIPO_DATA('157930'),
	T_TIPO_DATA('146163')


  ); 

  V_TIPO_DATA_PRV T_ARRAY_DATA_PRV := T_ARRAY_DATA_PRV(
  -- Cada PROVEEDOR en un T_TIPO_DATA
  T_TIPO_DATA_PRV('10033482'),
  T_TIPO_DATA_PRV('6968'),
  T_TIPO_DATA_PRV('110065127'),
  T_TIPO_DATA_PRV('110065066')
	
  );

--------------------------------------------------------------
-- FIN ZONA PARA EDITAR               ------------------------
--------------------------------------------------------------




  V_TMP_TIPO_DATA T_TIPO_DATA;
  V_TMP_TIPO_DATA_PRV T_TIPO_DATA_PRV;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para marcar activos a reenviar por el detector de cambios
 -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos que el activo existe--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: MARCADO PARA REENVIAR ACTIVO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');


       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST WHERE ID_ACTIVO_HAYA = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe, se borra
       IF V_NUM_TABLAS > 0 THEN				         
		
            DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN SWH_STOCK_ACT_WEBCOM_HIST');
            V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST WHERE ID_ACTIVO_HAYA = '||V_TMP_TIPO_DATA(1);

          	EXECUTE IMMEDIATE V_MSQL;
        
          	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' MARCADO PARA REENVIAR');
			
       --Si no existe, se informa
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' NO EXISTE, NO SE MARCARÁ PARA REENVIAR');   
        
       END IF;
      
		
    END LOOP;


   -- LOOP para marcar proveedores a reenviar por el detector de cambios
 -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA_PRV.FIRST .. V_TIPO_DATA_PRV.LAST
     LOOP
    
       V_TMP_TIPO_DATA_PRV := V_TIPO_DATA_PRV(I);
       
       -------------------------------------------------
       --Comprobamos que el proveedor existe--
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: MARCADO PARA REENVIAR PROVEEDOR: '''|| TRIM(V_TMP_TIPO_DATA_PRV(1)) ||'''');


       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST WHERE id_proveedor_rem = '''||TRIM(V_TMP_TIPO_DATA_PRV(1))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe, se borra
       IF V_NUM_TABLAS > 0 THEN				         
		
            DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA_PRV(1)) ||''' EN pwh_proveedor_webcom_hist');
            V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST WHERE id_proveedor_rem = '||V_TMP_TIPO_DATA_PRV(1);

          	EXECUTE IMMEDIATE V_MSQL;
        
          	DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR '''|| TRIM(V_TMP_TIPO_DATA_PRV(1)) ||''' MARCADO PARA REENVIAR');
			
       --Si no existe, se informa
       ELSE
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: EL PROVEEDOR '''|| TRIM(V_TMP_TIPO_DATA_PRV(1)) ||''' NO EXISTE, NO SE MARCARÁ PARA REENVIAR');   
        
       END IF;
      
		
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO FINALIZADO CORRECTAMENTE ');
 

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
