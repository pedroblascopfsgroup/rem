--/*
--###########################################
--## AUTOR=JESSICA SAMPERE
--## FECHA_CREACION=20180124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMNIVDOS-3259,REMNIVDOS-3335,REMNIVDOS-3223,REMNIVDOS-3450,REMNIVDOS-3505,REMNIVDOS-3517
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
  --TYPE T_TIPO_DATA_PRV IS TABLE OF VARCHAR2(150);
  --TYPE T_ARRAY_DATA_PRV IS TABLE OF T_TIPO_DATA_PRV;




--------------------------------------------------------------
-- INICIO ZONA PARA EDITAR            ------------------------
--------------------------------------------------------------

 V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
  -- Cada ACTIVO en un T_TIPO_DATA
  --3259
	T_TIPO_DATA(	155041	),
	T_TIPO_DATA(	142482	),
	T_TIPO_DATA(	152762	),
	T_TIPO_DATA(	136285	),
	T_TIPO_DATA(	152553	),
	T_TIPO_DATA(	155556	),
	--3335
	T_TIPO_DATA(	181544	),
	T_TIPO_DATA(	118631	),
	T_TIPO_DATA(	121065	),
	T_TIPO_DATA(	193650	),
	T_TIPO_DATA(	121496	),
	T_TIPO_DATA(	185086	),
	--3223
	T_TIPO_DATA(	153029	),
	T_TIPO_DATA(	142255	),
	T_TIPO_DATA(	153030	),
	T_TIPO_DATA(	142385	),
	T_TIPO_DATA(	200290	),
	T_TIPO_DATA(	142386	),
	T_TIPO_DATA(	163496	),
	--3450
	T_TIPO_DATA(	5925263	),
	--3505
	T_TIPO_DATA(	148342	),
	T_TIPO_DATA(137086),
	T_TIPO_DATA(	136095	),
	--3517
	T_TIPO_DATA(	69929	),
	T_TIPO_DATA(	69930	),
	T_TIPO_DATA(	69931	),
	T_TIPO_DATA(	70094	),
	T_TIPO_DATA(	70095	),
	T_TIPO_DATA(	70096	),
	T_TIPO_DATA(	70247	),
	T_TIPO_DATA(	70278	),
	T_TIPO_DATA(	70279	),
	T_TIPO_DATA(	70507	),
	T_TIPO_DATA(	70508	),
	T_TIPO_DATA(	70510	),
	T_TIPO_DATA(	142326	),
	T_TIPO_DATA(	145798	),
	T_TIPO_DATA(	146017	),
	T_TIPO_DATA(	154107	),
	T_TIPO_DATA(	154498	),
	T_TIPO_DATA(	154682	),
	T_TIPO_DATA(	158167	),
	T_TIPO_DATA(	158168	),
	T_TIPO_DATA(	158169	),
	T_TIPO_DATA(	158385	),
	T_TIPO_DATA(	158386	),
	T_TIPO_DATA(	158885	),
	T_TIPO_DATA(	168686	),
	T_TIPO_DATA(	168687	),
	T_TIPO_DATA(	168688	),
	T_TIPO_DATA(	168689	),
	T_TIPO_DATA(	168690	),
	T_TIPO_DATA(	168691	),
	T_TIPO_DATA(	168853	),
	T_TIPO_DATA(	168963	),
	T_TIPO_DATA(	168964	),
	T_TIPO_DATA(	169009	),
	T_TIPO_DATA(	169010	),
	T_TIPO_DATA(	169012	),
	T_TIPO_DATA(	169469	),
	T_TIPO_DATA(	169470	),
	T_TIPO_DATA(	169471	),
	T_TIPO_DATA(	174248	),
	T_TIPO_DATA(	174249	),
	T_TIPO_DATA(	174648	),
	T_TIPO_DATA(	174649	),
	T_TIPO_DATA(	174650	),
	T_TIPO_DATA(	174651	),
	T_TIPO_DATA(	174765	),
	T_TIPO_DATA(	174766	),
	T_TIPO_DATA(	174767	),
	T_TIPO_DATA(	174768	),
	T_TIPO_DATA(	174985	),
	T_TIPO_DATA(	163836	),
	T_TIPO_DATA(	163837	),
	T_TIPO_DATA(	936762	),
	T_TIPO_DATA(	940051	),
	T_TIPO_DATA(	935294	),
	T_TIPO_DATA(	174769	),
	T_TIPO_DATA(	939160	),
	T_TIPO_DATA(	154106	),
	T_TIPO_DATA(	169011	),
	T_TIPO_DATA(	70509	),
	T_TIPO_DATA(	942464	),
	T_TIPO_DATA(	710510	),
	T_TIPO_DATA(	809676	),
	T_TIPO_DATA(	163936	)


  ); 


  /*
  V_TIPO_DATA_PRV T_ARRAY_DATA_PRV := T_ARRAY_DATA_PRV(
  -- Cada PROVEEDOR en un T_TIPO_DATA
	);
*/

--------------------------------------------------------------
-- FIN ZONA PARA EDITAR               ------------------------
--------------------------------------------------------------




  V_TMP_TIPO_DATA T_TIPO_DATA;
  --V_TMP_TIPO_DATA_PRV T_TIPO_DATA_PRV;
  
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

/*
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
	*/
    
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