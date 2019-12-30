--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6093
--## PRODUCTO=NO
--##
--## Finalidad: Modificar ACT_PAC_PERIMETRO_ACTIVO y recalcular situación comercial
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

    V_COUNT NUMBER(16);
    
    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

    
BEGIN	

        ---------------------------------------------------------------------------------
        
    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado lógico del histórico posterior al creado por REMVIP-6063 ');
     
    	V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		  USING
		  (

            SELECT AHP2.AHP_ID
            FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AHP.ACT_ID = ACT.ACT_ID
            JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP2 ON AHP2.ACT_ID = ACT.ACT_ID AND AHP.AHP_ID <> AHP2.AHP_ID
            WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
            AND AHP.BORRADO = 0 AND AHP2.BORRADO = 0
            AND AHP.FECHACREAR < AHP2.FECHACREAR

                  ) AUX
		 ON ( AHP.AHP_ID = AUX.AHP_ID )
		 WHEN MATCHED THEN UPDATE SET
		 BORRADO = 1,
		 USUARIOBORRAR = ''REMVIP-6093'',
		 FECHABORRAR = SYSDATE
	
		' ;
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registros del histórico borrados ');
       
       ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado lógico del histórico creado por REMVIP-6063 ');
     
    	V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		  USING
		  (

		   SELECT DISTINCT AHP.AHP_ID
		   FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		   WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		   AND AHP.ACT_ID = ACT.ACT_ID 
		   AND AHP.BORRADO = 0

                  ) AUX
		 ON ( AHP.AHP_ID = AUX.AHP_ID )
		 WHEN MATCHED THEN UPDATE SET
		 BORRADO = 1,
		 USUARIOBORRAR = ''REMVIP-6093'',
		 FECHABORRAR = SYSDATE
	
		' ;
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registros del histórico borrados ');
	

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar la fecha hasta de los registros del histórico modificados por REMVIP-6063 ');
     
    	V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
		  USING
		  (

		   SELECT DISTINCT AHP.AHP_ID
		   FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		   WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		   AND AHP.ACT_ID = ACT.ACT_ID 
		   AND AHP.BORRADO = 0

                  ) AUX
		 ON ( AHP.AHP_ID = AUX.AHP_ID )
		 WHEN MATCHED THEN UPDATE SET
		 AHP_FECHA_FIN_VENTA = NULL,
		 USUARIOMODIFICAR = ''REMVIP-6093'',
		 FECHAMODIFICAR = SYSDATE
	
		' ;
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registros del histórico borrados ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Se modifica el check de publicar ');
	
	V_MSQL:= ' MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
		USING
		(

		SELECT DISTINCT ACT.ACT_ID
		FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		AND AHP.ACT_ID = ACT.ACT_ID
		AND EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
				     WHERE PAC.ACT_ID = ACT.ACT_ID 
				     AND USUARIOMODIFICAR = ''REMVIP-6063''
				 AND TRUNC( PAC.PAC_FECHA_PUBLICAR ) = TO_DATE( ''23/12/2019'', ''DD/MM/YYYY'' )
				 AND PAC_CHECK_PUBLICAR = 0		
				    ) 
				
		) AUX
		ON ( PAC.ACT_ID = AUX.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
		PAC_CHECK_PUBLICAR = 1,
		USUARIOMODIFICAR = ''REMVIP-6093'',
		FECHAMODIFICAR = SYSDATE  ';
					
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Se modifica el check de comercializar ');
	
	V_MSQL:= ' MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
		USING
		(

		SELECT DISTINCT ACT.ACT_ID
		FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		AND AHP.ACT_ID = ACT.ACT_ID
		AND EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
				     WHERE PAC.ACT_ID = ACT.ACT_ID 
				     AND USUARIOMODIFICAR = ''REMVIP-6063''
				 AND TRUNC( PAC.PAC_FECHA_COMERCIALIZAR ) = TO_DATE( ''23/12/2019'', ''DD/MM/YYYY'' )
				 AND PAC_CHECK_COMERCIALIZAR = 0		
				    ) 
				
		) AUX
		ON ( PAC.ACT_ID = AUX.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
		PAC_CHECK_COMERCIALIZAR = 1,
		USUARIOMODIFICAR = ''REMVIP-6093'',
		FECHAMODIFICAR = SYSDATE  ';
					
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Se modifica el check de formalizar ');
	
	V_MSQL:= ' MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
		USING
		(

		SELECT DISTINCT ACT.ACT_ID
		FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		AND AHP.ACT_ID = ACT.ACT_ID
		AND EXISTS ( SELECT 1 FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
				     WHERE PAC.ACT_ID = ACT.ACT_ID 
				     AND USUARIOMODIFICAR = ''REMVIP-6063''
				 AND TRUNC( PAC.PAC_FECHA_FORMALIZAR ) = TO_DATE( ''23/12/2019'', ''DD/MM/YYYY'' )
				 AND PAC_CHECK_FORMALIZAR = 0		
				    ) 
				
		) AUX
		ON ( PAC.ACT_ID = AUX.ACT_ID )
		WHEN MATCHED THEN UPDATE SET
		PAC_CHECK_FORMALIZAR = 1,
		USUARIOMODIFICAR = ''REMVIP-6093'',
		FECHAMODIFICAR = SYSDATE ';
					
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS ');

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP recálculo de la situación comercial ');

    	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
		  USING
		  (

		   SELECT DISTINCT ACT.ACT_ID
		   FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		   WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		   AND AHP.ACT_ID = ACT.ACT_ID 

                  ) AUX
		 ON ( ACT.ACT_ID = AUX.ACT_ID )
		 WHEN MATCHED THEN UPDATE SET
		 DD_SCM_ID = NULL,
		 USUARIOMODIFICAR = ''REMVIP-6093'',
		 FECHAMODIFICAR = SYSDATE  
	
		' ;
	   EXECUTE IMMEDIATE V_MSQL;


	   DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTIVOS DEJADOS CON SITUACIÓN COMERCIAL NULA ');

       
       	REM01.SP_ASC_ACT_SIT_COM_VACIOS_V2( 0 );
           
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial ');

        ---------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP cambio estado de publicación ');
     
    	V_SQL := ' SELECT DISTINCT ACT.ACT_ID
		   FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT
		   WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		   AND AHP.ACT_ID = ACT.ACT_ID	
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
       
       		REM01.SP_CAMBIO_ESTADO_PUBLICACION( V_ID, 1, 'REMVIP-6093' );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado el estado de publicación de '||V_COUNT||' activos ');
	   
   	
        ---------------------------------------------------------------------------------



	DBMS_OUTPUT.PUT_LINE('[INICIO] Ejecutándose SP cambio estado de publicación en caso de agrupaciones restringidas ');
     
     	-- Busca los activos que sí están en una agrupación asistida ni restringida:
    	V_SQL := ' SELECT DISTINCT AGR.AGR_ID
		   FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP, '||V_ESQUEMA||'.ACT_ACTIVO ACT,
			'||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA,
			'||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR, 
			'||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION  TAG
		   WHERE AHP.USUARIOCREAR = ''REMVIP-6063''
		   AND AHP.ACT_ID = ACT.ACT_ID	
		   AND AGA.ACT_ID = ACT.ACT_ID
		   AND AGR.BORRADO = 0	
		   AND TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
		   AND AGR.AGR_ID = AGA.AGR_ID	
                   AND AGR_FECHA_BAJA IS NULL	
		   AND AGA.BORRADO = 0
		   AND TAG.DD_TAG_CODIGO = ''02''

		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_ID;
       		EXIT WHEN v_cursor%NOTFOUND;
       
       		REM01.SP_CAMBIO_ESTADO_PUBLI_AGR( V_ID, 1, 'REMVIP-6093' );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se ha recalculado la situación comercial de '||V_COUNT||' agrupaciones ');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');


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
