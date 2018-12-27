--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2677
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar Situación posesoria de todos los activos que no la tengan
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
  V_USUARIO_MODIFICAR VARCHAR(50 CHAR):='REMVIP-2677';
    
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_COUNT NUMBER(16);
    
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	T_TIPO_DATA('9000144595'),	
	T_TIPO_DATA('9000144476'),
	T_TIPO_DATA('9000144623'),
	T_TIPO_DATA('9000144450'),
	T_TIPO_DATA('9000144792'),
	T_TIPO_DATA('9000144631')
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
     
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' EN '||V_TABLA_TEMP||'');   
        
        V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ
					INNER JOIN '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
					INNER JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID
					INNER JOIN '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID
					WHERE TBJ.TBJ_NUM_TRABAJO = '|| TRIM(V_TMP_TIPO_DATA(1)) ||'';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        
        IF V_COUNT > 1 THEN
        
			V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA_TEMP||'';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE LIMPIA LA TABLA TEMPORAL');
			
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA_TEMP||' (TBJ_ID,TRA_ID,TAR_ID)
							SELECT TBJ.TBJ_ID,TRA.TRA_ID,TAR.TAR_ID 
							FROM '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ
							INNER JOIN '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
							INNER JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID
							INNER JOIN '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID
							WHERE TBJ.TBJ_NUM_TRABAJO = '|| TRIM(V_TMP_TIPO_DATA(1)) ||'';
												
			EXECUTE IMMEDIATE V_MSQL;
			  
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' INSERTADO EN LA TABLA '||V_TABLA_TEMP||'');    
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE EMPIEZA A BORRAR EL TRABAJO '|| TRIM(V_TMP_TIPO_DATA(1)) ||'');  
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET 
							TAR_FECHA_FIN = SYSDATE
							,TAR_TAREA_FINALIZADA = 1
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1
						WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS)';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAR_TAREAS_NOTIFICACIONES');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
							USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
						   ,FECHABORRAR = SYSDATE
						   ,BORRADO = 1 
						WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS)';
			
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA TAC_TAREAS_ACTIVOS');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET 
							TRA_DECIDIDO = 1
							,TRA_FECHA_FIN = SYSDATE
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1 
						WHERE TRA_ID IN (SELECT TRA_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS) ';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA ACT_TRA_TRAMITE');
			
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET 
							 TBJ_FECHA_FIN = SYSDATE
							,USUARIOBORRAR = '''||V_USUARIO_MODIFICAR||'''
							,FECHABORRAR = SYSDATE
							,BORRADO = 1 
						WHERE TBJ_ID IN (SELECT TBJ_ID FROM '||V_ESQUEMA||'.APR_AUX_TAREAS_TRABAJOS) ';
						
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA LA TABLA ACT_TBJ_TRABAJO');
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: EL TRABAJO '|| TRIM(V_TMP_TIPO_DATA(1)) ||' HA SIDO BORRADO SATISFACTORIAMENTE');
			
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
