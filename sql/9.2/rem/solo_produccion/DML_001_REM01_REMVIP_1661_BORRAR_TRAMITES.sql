--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1661
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar trámites
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
  V_TABLA_TEMP VARCHAR(50 CHAR):='APR_AUX_TAREAS_TRABAJOS';
  V_USUARIO_MODIFICAR VARCHAR(50 CHAR):='REMVIP-1661';
    
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_COUNT NUMBER(16);
    
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('34574'),
	T_TIPO_DATA('60961'),
	T_TIPO_DATA('61075'),
	T_TIPO_DATA('61160'),
	T_TIPO_DATA('61260'),
	T_TIPO_DATA('61464'),
	T_TIPO_DATA('61652'),
	T_TIPO_DATA('61807'),
	T_TIPO_DATA('62142'),
	T_TIPO_DATA('62542'),
	T_TIPO_DATA('62932'),
	T_TIPO_DATA('63484'),
	T_TIPO_DATA('67874'),
	T_TIPO_DATA('63949'),
	T_TIPO_DATA('61603'),
	T_TIPO_DATA('75034'),
	T_TIPO_DATA('62278'),
	T_TIPO_DATA('67666'),
	T_TIPO_DATA('80744'),
	T_TIPO_DATA('62588'),
	T_TIPO_DATA('62362'),
	T_TIPO_DATA('97007'),
	T_TIPO_DATA('63590'),
	T_TIPO_DATA('63726'),
	T_TIPO_DATA('62145'),
	T_TIPO_DATA('123025'),
	T_TIPO_DATA('123496'),
	T_TIPO_DATA('135951'),
	T_TIPO_DATA('117808'),
	T_TIPO_DATA('124355'),
	T_TIPO_DATA('124449'),
	T_TIPO_DATA('122184'),
	T_TIPO_DATA('122180'),
	T_TIPO_DATA('138736'),
	T_TIPO_DATA('135990'),
	T_TIPO_DATA('136064'),
	T_TIPO_DATA('138827'),
	T_TIPO_DATA('137403'),
	T_TIPO_DATA('138078'),
	T_TIPO_DATA('140075'),
	T_TIPO_DATA('139998'),
	T_TIPO_DATA('137349'),
	T_TIPO_DATA('140780'),
	T_TIPO_DATA('63559'),
	T_TIPO_DATA('63175'),
	T_TIPO_DATA('62455'),
	T_TIPO_DATA('62508'),
	T_TIPO_DATA('73262'),
	T_TIPO_DATA('61150'),
	T_TIPO_DATA('141294'),
	T_TIPO_DATA('103229'),
	T_TIPO_DATA('73267'),
	T_TIPO_DATA('99128'),
	T_TIPO_DATA('137339')
  ); 
  V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');

 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_TEMP||' ');
 
   -- LOOP para insertar los valores TBJ_ID  ,TRA_ID  ,TAR_ID -----------------------------------------------------------------
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
     LOOP
    
       V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
       -------------------------------------------------
       --Comprobamos el dato a insertar en usu_usuario--
       -------------------------------------------------

       --Si existe no se modifica
     
        --DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN '||V_TABLA_TEMP||'');   
        
        V_MSQL := 'SELECT COUNT(1) 
						 FROM '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA 
						 INNER JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
						 INNER JOIN '|| V_ESQUEMA ||'.TEX_TAREA_EXTERNA TEX ON TAC.TAR_ID = TEX.TAR_ID
						 INNER JOIN '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
						 INNER JOIN '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID  AND TPO.DD_TPO_CODIGO IN (''T013'',''T014'',''T015'',''T016'')
						 WHERE TRA.TRA_ID = '|| TRIM(V_TMP_TIPO_DATA(1)) ||'
						 ';
						
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT > 0 THEN
        
			V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA_TEMP||'';
				
			EXECUTE IMMEDIATE V_MSQL;
			
			--DBMS_OUTPUT.PUT_LINE('[INFO]: SE LIMPIA LA TABLA TEMPORAL');
			
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA_TEMP||' (TBJ_ID,TRA_ID,TAR_ID) 
						 SELECT 0,TRA.TRA_ID,TAC.TAR_ID 
						 FROM '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA 
						 INNER JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
						 INNER JOIN '|| V_ESQUEMA ||'.TEX_TAREA_EXTERNA TEX ON TAC.TAR_ID = TEX.TAR_ID
						 INNER JOIN '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
						 INNER JOIN '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID  AND TPO.DD_TPO_CODIGO IN (''T013'',''T014'',''T015'',''T016'')
						 WHERE TRA.TRA_ID = '|| TRIM(V_TMP_TIPO_DATA(1)) ||'
						 ';
												
			EXECUTE IMMEDIATE V_MSQL;
			  
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO EN LA TABLA '||V_TABLA_TEMP||'');    
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE EMPIEZA A BORRAR EL TRAMITE '|| TRIM(V_TMP_TIPO_DATA(1)) ||'');  
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
							TAR_FECHA_FIN = SYSDATE
							,TAR_TAREA_FINALIZADA = 1
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1
						WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS)
                              AND TAR_TAREA_FINALIZADA = 0';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAR_TAREAS_NOTIFICACIONES');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
							USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHABORRAR = SYSDATE
						   ,BORRADO = 1 
						WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS)';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAC_TAREAS_ACTIVOS');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET 
							TRA_DECIDIDO = 1
							,DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05'')
							,TRA_FECHA_FIN = SYSDATE
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1 
						WHERE TRA_ID IN (SELECT TRA_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS) ';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			-- DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA ACT_TRA_TRAMITE');
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL TRAMITE '|| TRIM(V_TMP_TIPO_DATA(1)) ||' HA SIDO BORRADO SATISFACTORIAMENTE');
		
        ELSE
        
        DBMS_OUTPUT.PUT_LINE('[ERROR]: NO SE HA ENCONTRADO EL EXPEDIENTE '|| TRIM(V_TMP_TIPO_DATA(1)) ||' ');
              	
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
