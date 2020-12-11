--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8210
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-8210'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_8210';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(5925334),
		T_TIPO_DATA(5927913),
		T_TIPO_DATA(5933408),
		T_TIPO_DATA(5937367),
		T_TIPO_DATA(5954693),
		T_TIPO_DATA(5962222),
		T_TIPO_DATA(5966586),
		T_TIPO_DATA(5967713),
		T_TIPO_DATA(5970237),
		T_TIPO_DATA(6061553),
		T_TIPO_DATA(6062799),
		T_TIPO_DATA(6063292),
		T_TIPO_DATA(6351096),
		T_TIPO_DATA(6789196),
		T_TIPO_DATA(6824851),
		T_TIPO_DATA(6828549),
		T_TIPO_DATA(6831733),
		T_TIPO_DATA(6837238),
		T_TIPO_DATA(6886535),
		T_TIPO_DATA(6886822),
		T_TIPO_DATA(6891412),
		T_TIPO_DATA(6891416),
		T_TIPO_DATA(6935999),
		T_TIPO_DATA(6937886),
		T_TIPO_DATA(6959968),
		T_TIPO_DATA(6963483),
		T_TIPO_DATA(6983668),
		T_TIPO_DATA(6985287),
		T_TIPO_DATA(6990566),
		T_TIPO_DATA(7004264),
		T_TIPO_DATA(7030211),
		T_TIPO_DATA(7089288),
		T_TIPO_DATA(7089569),
		T_TIPO_DATA(7101549),
		T_TIPO_DATA(7226475),
		T_TIPO_DATA(7226880),
		T_TIPO_DATA(7226965),
		T_TIPO_DATA(7229418),
		T_TIPO_DATA(7293192),
		T_TIPO_DATA(7294168),
		T_TIPO_DATA(7294198),
		T_TIPO_DATA(7294429),
		T_TIPO_DATA(7294507),
		T_TIPO_DATA(7294591),
		T_TIPO_DATA(7294772),
		T_TIPO_DATA(7295515),
		T_TIPO_DATA(7295544),
		T_TIPO_DATA(7296325),
		T_TIPO_DATA(7296415),
		T_TIPO_DATA(7296468),
		T_TIPO_DATA(7296866),
		T_TIPO_DATA(7296907),
		T_TIPO_DATA(7297073),
		T_TIPO_DATA(7297075),
		T_TIPO_DATA(7297088),
		T_TIPO_DATA(7297612),
		T_TIPO_DATA(7297828),
		T_TIPO_DATA(7298446)
	); 
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
			   SELECT ACT.ACT_ID
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