--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9280
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva de aprobación del informe comercial
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9280'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_9280';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(5963384),
		T_TIPO_DATA(5927321),
		T_TIPO_DATA(5941090),
		T_TIPO_DATA(5956191),
		T_TIPO_DATA(5943826),
		T_TIPO_DATA(5945238),
		T_TIPO_DATA(5959798),
		T_TIPO_DATA(6049584),
		T_TIPO_DATA(6049654),
		T_TIPO_DATA(5933271),
		T_TIPO_DATA(5944881),
		T_TIPO_DATA(5949050),
		T_TIPO_DATA(6060100),
		T_TIPO_DATA(6059813),
		T_TIPO_DATA(6351166),
		T_TIPO_DATA(5954443),
		T_TIPO_DATA(6344525),
		T_TIPO_DATA(6063738),
		T_TIPO_DATA(6063739),
		T_TIPO_DATA(5971725),
		T_TIPO_DATA(6797122),
		T_TIPO_DATA(6824748),
		T_TIPO_DATA(6711568),
		T_TIPO_DATA(6753449),
		T_TIPO_DATA(6767944),
		T_TIPO_DATA(6788197),
		T_TIPO_DATA(6788195),
		T_TIPO_DATA(6809935),
		T_TIPO_DATA(6810465),
		T_TIPO_DATA(6826946),
		T_TIPO_DATA(6832606),
		T_TIPO_DATA(6837239),
		T_TIPO_DATA(6890994),
		T_TIPO_DATA(6956504),
		T_TIPO_DATA(7010098),
		T_TIPO_DATA(6994089),
		T_TIPO_DATA(6985970),
		T_TIPO_DATA(6981830),
		T_TIPO_DATA(6984000),
		T_TIPO_DATA(6986353),
		T_TIPO_DATA(6992760),
		T_TIPO_DATA(6987408),
		T_TIPO_DATA(6983706),
		T_TIPO_DATA(6992715),
		T_TIPO_DATA(6990314),
		T_TIPO_DATA(6987006),
		T_TIPO_DATA(6994969),
		T_TIPO_DATA(6988589),
		T_TIPO_DATA(6984649),
		T_TIPO_DATA(6995811),
		T_TIPO_DATA(6990226),
		T_TIPO_DATA(6996082),
		T_TIPO_DATA(6999560),
		T_TIPO_DATA(6987407),
		T_TIPO_DATA(6995906),
		T_TIPO_DATA(6994224),
		T_TIPO_DATA(6981581),
		T_TIPO_DATA(6987413),
		T_TIPO_DATA(6986102),
		T_TIPO_DATA(6987648),
		T_TIPO_DATA(6986096),
		T_TIPO_DATA(6980534),
		T_TIPO_DATA(6980437),
		T_TIPO_DATA(6994308),
		T_TIPO_DATA(6983967),
		T_TIPO_DATA(6994323),
		T_TIPO_DATA(6986688),
		T_TIPO_DATA(6979734),
		T_TIPO_DATA(6987469),
		T_TIPO_DATA(6984646),
		T_TIPO_DATA(6990182),
		T_TIPO_DATA(6990338),
		T_TIPO_DATA(6996846),
		T_TIPO_DATA(6993149),
		T_TIPO_DATA(7030369),
		T_TIPO_DATA(7031648),
		T_TIPO_DATA(7032204),
		T_TIPO_DATA(7001704),
		T_TIPO_DATA(7099738),
		T_TIPO_DATA(7091574),
		T_TIPO_DATA(7099294),
		T_TIPO_DATA(7294399),
		T_TIPO_DATA(7101411),
		T_TIPO_DATA(7101341),
		T_TIPO_DATA(7292863),
		T_TIPO_DATA(7293112),
		T_TIPO_DATA(7294275),
		T_TIPO_DATA(7294920),
		T_TIPO_DATA(7295443),
		T_TIPO_DATA(7296917),
		T_TIPO_DATA(7298863),
		T_TIPO_DATA(7298874),
		T_TIPO_DATA(7300355),
		T_TIPO_DATA(7300051),
		T_TIPO_DATA(7299576),
		T_TIPO_DATA(7296920),
		T_TIPO_DATA(7296520),
		T_TIPO_DATA(7295988),
		T_TIPO_DATA(7296845),
		T_TIPO_DATA(7296295),
		T_TIPO_DATA(7296534),
		T_TIPO_DATA(7296989),
		T_TIPO_DATA(7297080),
		T_TIPO_DATA(7298533),
		T_TIPO_DATA(7296547),
		T_TIPO_DATA(7296212),
		T_TIPO_DATA(7296259),
		T_TIPO_DATA(7296731),
		T_TIPO_DATA(7295945),
		T_TIPO_DATA(7297182),
		T_TIPO_DATA(7300501),
		T_TIPO_DATA(7387125),
		T_TIPO_DATA(7387004),
		T_TIPO_DATA(7386643),
		T_TIPO_DATA(7386871),
		T_TIPO_DATA(7302008),
		T_TIPO_DATA(7030818),
		T_TIPO_DATA(7303017),
		T_TIPO_DATA(7327396),
		T_TIPO_DATA(7302354),
		T_TIPO_DATA(7303539),
		T_TIPO_DATA(7303576),
		T_TIPO_DATA(7299198),
		T_TIPO_DATA(7330478),
		T_TIPO_DATA(7386207),
		T_TIPO_DATA(7386232),
		T_TIPO_DATA(7303351),
		T_TIPO_DATA(7302699),
		T_TIPO_DATA(7302785),
		T_TIPO_DATA(7302844),
		T_TIPO_DATA(7403042),
		T_TIPO_DATA(7403030),
		T_TIPO_DATA(7403202),
		T_TIPO_DATA(7386594),
		T_TIPO_DATA(7423814),
		T_TIPO_DATA(7330134),
		T_TIPO_DATA(7300861),
		T_TIPO_DATA(7301012),
		T_TIPO_DATA(7402850),
		T_TIPO_DATA(7402842),
		T_TIPO_DATA(7423658),
		T_TIPO_DATA(7423725),
		T_TIPO_DATA(7431623),
		T_TIPO_DATA(7431907),
		T_TIPO_DATA(7297374),
		T_TIPO_DATA(7298745)); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

    
BEGIN		

	--Insertar valores en tabla auxiliar

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA_AUX||' (act_num_activo) values ('||V_TMP_TIPO_DATA(1)||')' ;	
		
		EXECUTE IMMEDIATE V_MSQL;
        
    END LOOP;

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO ACT_ICO_INFO_COMERCIAL ');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO
		    USING( 
			   SELECT DISTINCT ACT.ACT_ID
			   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				'||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
			   WHERE 1 = 1
			   AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
			   AND NOT EXISTS ( SELECT 1
					    FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC
				   	    WHERE 1 = 1
					    AND HIC.ACT_ID = ACT.ACT_ID
					    AND DD_AIC_ID = ( SELECT DD_AIC_ID 
							      FROM '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL AIC
							      WHERE DD_AIC_CODIGO = ''02'' )
					    AND HIC.BORRADO = 0	
					   )
			   AND ACT.BORRADO = 0 
			) AUX
		    ON ( AUX.ACT_ID = ICO.ACT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    ICO_FECHA_ACEPTACION = SYSDATE,
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USU || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_ICO_INFO_COMERCIAL'); 	

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO ACT_HIC_EST_INF_COMER_HIST ');	
	
	V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.ACT_HIC_EST_INF_COMER_HIST 
		    ( 
			HIC_ID,
			ACT_ID,
			DD_AIC_ID,
			HIC_FECHA,
			HIC_MOTIVO,
			VERSION,
			BORRADO,
			USUARIOCREAR,
			FECHACREAR
		    )
	    		SELECT     
		        '|| V_ESQUEMA ||'.S_ACT_HIC_EST_INF_COMER_HIST.NEXTVAL,
			ACT.ACT_ID,
			( SELECT DD_AIC_ID FROM '|| V_ESQUEMA ||'.DD_AIC_ACCION_INF_COMERCIAL AIC WHERE DD_AIC_CODIGO = ''02'' ),
			SYSDATE,
			NULL,
			0,
			0,
			''' || V_USU || ''',
			SYSDATE	
			FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT,
		             '|| V_ESQUEMA ||'.'||V_TABLA_AUX||' AUX
			WHERE 1 = 1			   
			AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
			AND NOT EXISTS ( SELECT 1
					  FROM '|| V_ESQUEMA ||'.ACT_HIC_EST_INF_COMER_HIST HIC
			                  WHERE 1 = 1
                      			  AND HIC.ACT_ID = ACT.ACT_ID
			                  AND DD_AIC_ID = ( SELECT DD_AIC_ID 
                        		                    FROM '|| V_ESQUEMA ||'.DD_AIC_ACCION_INF_COMERCIAL AIC
		                                            WHERE DD_AIC_CODIGO = ''02'' )
                	      		  AND HIC.BORRADO = 0
			 		)
			 AND ACT.BORRADO = 0 ' ;


	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se crean '||SQL%ROWCOUNT||' registros de ACT_HIC_EST_INF_COMER_HIST de tipo ''Aceptado'' '); 

        --------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP recálculo de la situación comercial ');

    	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
		  USING
		  (

		   SELECT DISTINCT ACT.ACT_ID
		   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT ACT 
		   INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO

                  ) AUX
		 ON ( ACT.ACT_ID = AUX.ACT_ID )
		 WHEN MATCHED THEN UPDATE SET
		 act.DD_SCM_ID = NULL,
		 USUARIOMODIFICAR = ''' || V_USU || ''',
		 FECHAMODIFICAR = SYSDATE  
	
		' ;
	   EXECUTE IMMEDIATE V_MSQL;


        DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVOS DEJADOS CON SITUACIÓN COMERCIAL NULA ');
       
       	REM01.SP_ASC_ACT_SIT_COM_VACIOS_V2( 0 );
           
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial ');
        ---------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP cambio estado de publicación ');
     
     	-- Busca los activos que no están en una agrupación asistida ni restringida:
    	V_SQL := ' SELECT DISTINCT ACT.ACT_ID
		   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
			'||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		   WHERE 1 = 1			   
		   AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
		   AND ACT.BORRADO = 0 
		   AND NOT EXISTS ( SELECT 1 
				    FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA,
					 '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR, 
					 '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION  TAG
				    WHERE 1 = 1
				    AND AGA.ACT_ID = ACT.ACT_ID
				    AND AGR.BORRADO = 0	
				    AND TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
				    AND AGR.AGR_ID = AGA.AGR_ID	
                        	    AND AGR_FECHA_BAJA IS NULL	
				    AND AGA.BORRADO = 0
				    AND TAG.DD_TAG_CODIGO = ''02''
				  )
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_ID;
       		EXIT WHEN v_cursor%NOTFOUND;
       
       		REM01.SP_CAMBIO_ESTADO_PUBLICACION( V_ID, 1, V_USU );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial de '||V_COUNT||' activos ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP cambio estado de publicación en caso de agrupaciones asistidas ');
     
     	-- Busca los activos que sí están en una agrupación asistida ni restringida:
    	V_SQL := ' SELECT DISTINCT AGR.AGR_ID
		   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
			'||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX,
			'||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA,
			'||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR,
			'||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION  TAG
		   WHERE 1 = 1
		   AND AGA.ACT_ID = ACT.ACT_ID
		   AND AGR.BORRADO = 0	
		   AND TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
		   AND AGR.AGR_ID = AGA.AGR_ID	
                   AND AGR_FECHA_BAJA IS NULL	
		   AND AGA.BORRADO = 0
		   AND TAG.DD_TAG_CODIGO = ''02''
		   AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
		   AND ACT.BORRADO = 0 
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_ID;
       		EXIT WHEN v_cursor%NOTFOUND;
       
       		REM01.SP_CAMBIO_ESTADO_PUBLI_AGR( V_ID, 1, V_USU );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial de '||V_COUNT||' agrupaciones ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP del recálculo de RATING');
     
	-- Busca los activos:
    	V_SQL := ' SELECT ACT.ACT_ID
		   FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
			'||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		   WHERE 1 = 1			   
		   AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
		   AND ACT.BORRADO = 0 
		   AND EXISTS ( SELECT 1 
				FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA
				WHERE 1 = 1
				AND TPA.DD_TPA_ID = ACT.DD_TPA_ID
				AND DD_TPA_CODIGO = ''02''
		              )		
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_ID;
       		EXIT WHEN v_cursor%NOTFOUND;
       
       		REM01.CALCULO_RATING_ACTIVO_AUTO( V_ID, V_USU );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial de '||V_COUNT||' agrupaciones ');


        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Cerrando Tareas ');	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES TAR
		    USING( 

			 	SELECT DISTINCT TAR.TAR_ID
				FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC, '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.ACT_ACTIVO ACT, '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
				WHERE TRA.ACT_ID = ACT.ACT_ID
				AND DD_EPR_ID = ( SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE DD_EPR_CODIGO = ''10'' )
				AND DD_TPO_ID = ( SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T011'' )
				AND TAC.TAR_ID = TAR.TAR_ID
				AND TAC.ACT_ID = ACT.ACT_ID
				AND TRA.TRA_ID = TAC.TRA_ID
				AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				AND TAR.BORRADO = 0
				AND TAC.BORRADO = 0
				AND TRA.BORRADO = 0

			) AUX
		    ON ( AUX.TAR_ID = TAR.TAR_ID )
		    WHEN MATCHED THEN UPDATE SET
		    TAR_FECHA_FIN = SYSDATE,
		    TAR_TAREA_FINALIZADA = 1,
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USU || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de TAR_TAREAS_NOTIFICACIONES '); 	

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Cerrando Trámite ');	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA
		    USING( 

			 	SELECT DISTINCT TRA.TRA_ID
				FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC, '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.ACT_ACTIVO ACT, '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
				WHERE TRA.ACT_ID = ACT.ACT_ID
				AND DD_EPR_ID = ( SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE DD_EPR_CODIGO = ''10'' )
				AND DD_TPO_ID = ( SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T011'' )
				AND TAC.TAR_ID = TAR.TAR_ID
				AND TAC.ACT_ID = ACT.ACT_ID
				AND TRA.TRA_ID = TAC.TRA_ID
				AND ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
				AND TAR.BORRADO = 0
				AND TAC.BORRADO = 0
				AND TRA.BORRADO = 0

			) AUX
		    ON ( AUX.TRA_ID = TRA.TRA_ID )
		    WHEN MATCHED THEN UPDATE SET
		    DD_EPR_ID = ( SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE DD_EPR_CODIGO = ''11'' ),
		    TRA_FECHA_FIN = SYSDATE,
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USU || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_TRA_TRAMITE '); 	

        ---------------------------------------------------------------------------------

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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