--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6006
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6006'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_6006';
    V_COUNT NUMBER(16);	
    V_GPV_NUM_GASTO_HAYA NUMBER(16);	
    V_RET VARCHAR2( 2048 CHAR ) := '';


    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

    
BEGIN		

        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Reenviar gastos que no estén contabilizados ni pagados ');
     
     	-- Busca los gastos marcados en verde que no están contabilizados ni pagados
    	V_SQL := ' SELECT AUX.GPV_NUM_GASTO_HAYA
		   FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV,
			'||V_ESQUEMA||'.AUX_REMVIP_6006 AUX
		   WHERE 1 = 1			   
		   AND AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
		   AND GPV.BORRADO = 0 
		   AND NOT GPV.DD_EGA_ID IN ( SELECT DD_EGA_ID 
					      FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA
					      WHERE EGA.DD_EGA_CODIGO IN ( ''04'', ''05'' )
					    )	
		   AND AUX.GIC_PTDA_PRESUPUESTARIA = ''690535'' ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_GPV_NUM_GASTO_HAYA;
       		EXIT WHEN v_cursor%NOTFOUND;
       
       		REM01.SP_EXT_REENVIO_GASTO( V_GPV_NUM_GASTO_HAYA, V_USR, V_RET );
           
       		V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se han reenviado '||V_COUNT||' activos ');

        ---------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Se cambia la partida ');	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
		    USING( 

				SELECT DISTINCT GPV.GPV_ID, AUX.GIC_PTDA_PRESUPUESTARIA
				FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV,
				     '||V_ESQUEMA||'.AUX_REMVIP_6006 AUX
			  	WHERE 1 = 1			   
		   		AND AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
		   		AND GPV.BORRADO = 0 
			   	AND AUX.GIC_PTDA_PRESUPUESTARIA = ''656250''

			) AUX
		    ON ( GIC.GPV_ID = AUX.GPV_ID )
		    WHEN MATCHED THEN UPDATE SET
		    GIC_PTDA_PRESUPUESTARIA = ''690535'',
		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USR || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de GIC_GASTOS_INFO_CONTABILIDAD '); 	

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
