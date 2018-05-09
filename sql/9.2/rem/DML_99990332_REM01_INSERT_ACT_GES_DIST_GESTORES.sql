--/*
--###########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-654
--## PRODUCTO=NO
--## 
--## Finalidad: Asignacion de gestores en Central Tecnica
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

  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);

  ENTIDAD NUMBER(1):= '1';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--	  	COM_AUTONOMA/PROVINCIA	PROVEEDOR_REM	COM/PROV	
		T_TIPO_DATA('Andalucía',10004312,'COM'),
		T_TIPO_DATA('Aragón',10004312,'COM'),
		T_TIPO_DATA('Asturias, Principado de',10004312,'COM'),
		T_TIPO_DATA('Balears, Illes',10007348,'COM'),
		T_TIPO_DATA('CANARIAS',37,'COM'),
		T_TIPO_DATA('CANTABRIA',10004312,'COM'),
		T_TIPO_DATA('Castilla - La Mancha',26,'COM'),
		T_TIPO_DATA('Castilla y León',10004312,'COM'),
		T_TIPO_DATA('Barcelona',10007348,'PROV'),
		T_TIPO_DATA('Girona',10007348,'PROV'),
		T_TIPO_DATA('Lleida',10007348,'PROV'),
		T_TIPO_DATA('Tarragona',10004312,'PROV'),
		T_TIPO_DATA('CEUTA',10004312,'COM'),
		T_TIPO_DATA('Extremadura',10004312,'COM'),
		T_TIPO_DATA('Galicia',10004312,'COM'),
		T_TIPO_DATA('Rioja, La',10004312,'COM'),
		T_TIPO_DATA('Madrid, Comunidad de',10004312,'COM'),
		T_TIPO_DATA('Murcia, Región de',10004312,'COM'),
		T_TIPO_DATA('Navarra, Comunidad Foral de',10004312,'COM'),
		T_TIPO_DATA('País Vasco',10004312,'COM'),
		T_TIPO_DATA('Comunitat Valenciana',10009511,'COM')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
   -- LOOP para insertar los valores en ACT_GES_DIST_GESTORES -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -----------------------------------------------------------------------------
       --Comprobamos el usuario del proveedor a insertar en ACT_GES_DIST_GESTORES --
       -----------------------------------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBACION DE PROVEEDOR DE '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
       
       V_SQL := 'SELECT COUNT(1) 
				 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
				 INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = PVE.PVE_DOCIDENTIF
				 WHERE PVE.PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
       --Si existe no se modifica
       IF V_NUM_TABLAS = 0 THEN				         
			
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe usuario para el proveedor '''||TRIM(V_TMP_TIPO_DATA(2))||'''...no se modifica nada.');
			
       ELSE
     
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS PARA EL PROVEEOR '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN ACT_GES_DIST_GESTORES');
			
			IF TRIM(V_TMP_TIPO_DATA(3)) = 'COM' THEN
				        V_MSQL := '
								INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (ID,TIPO_GESTOR,COD_CARTERA,COD_PROVINCIA,USERNAME,NOMBRE_USUARIO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
								SELECT 
								'||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
								''PTEC'',
								3,
								PRV.DD_PRV_CODIGO,
								USU.USU_USERNAME,
								USU.USU_NOMBRE,
								0,
								''REMVIP-654'',
								SYSDATE,
								0
								FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
								INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = PVE.PVE_DOCIDENTIF
								INNER JOIN '||V_ESQUEMA||'.DD_CMA_COMAUTONOMA CMA ON UPPER(CMA.DD_CMA_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(1))||''')
								INNER JOIN '||V_ESQUEMA||'.ACT_CMP_COMAUTONOMA_PROVINCIA CMP ON CMP.DD_CMA_ID = CMA.DD_CMA_ID
								INNER JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = CMP.DD_PRV_ID
								WHERE PVE.PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
								AND NOT EXISTS
								(
									SELECT 1 
									FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES
									WHERE GES.USERNAME = USU.USU_USERNAME
									AND GES.COD_PROVINCIA = PRV.DD_PRV_CODIGO
									AND GES.TIPO_GESTOR = ''PTEC''
									AND GES.COD_CARTERA = 3
								)
								  ';
						EXECUTE IMMEDIATE V_MSQL;
								
						DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' GESTOR/ES '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN ACT_GES_DIST_GESTORES PARA LA COMUNIDAD AUTONOMA '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			ELSE
						V_MSQL := '
							INSERT INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES (ID,TIPO_GESTOR,COD_CARTERA,COD_PROVINCIA,USERNAME,NOMBRE_USUARIO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
							SELECT 
							'||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL,
							''PTEC'',
							3,
							PRV.DD_PRV_CODIGO,
							USU.USU_USERNAME,
							USU.USU_NOMBRE,
							0,
							''REMVIP-654'',
							SYSDATE,
							0
							FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
							INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = PVE.PVE_DOCIDENTIF
							INNER JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON UPPER(PRV.DD_PRV_DESCRIPCION) = UPPER('''||TRIM(V_TMP_TIPO_DATA(1))||''')
							WHERE PVE.PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							AND NOT EXISTS
							(
								SELECT 1 
								FROM '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES GES
								WHERE GES.USERNAME = USU.USU_USERNAME
								AND GES.COD_PROVINCIA = PRV.DD_PRV_CODIGO
								AND GES.TIPO_GESTOR = ''PTEC''
								AND GES.COD_CARTERA = 3
							)
							';
						EXECUTE IMMEDIATE V_MSQL;
								
						DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' GESTOR/ES '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' INSERTADO CORRECTAMENTE EN ACT_GES_DIST_GESTORES PARA LA PROVINCIA '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');							
			END IF;      
       END IF;
		
    END LOOP;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
