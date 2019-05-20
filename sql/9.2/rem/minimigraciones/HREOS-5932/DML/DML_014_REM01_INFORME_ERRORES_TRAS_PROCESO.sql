--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190402
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5932
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_MSQL VARCHAR2(32000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_COUNT NUMBER(16);
	PL_OUTPUT VARCHAR(32000 CHAR);
	
	CURSOR VALIDACION_3_7_A IS SELECT DISTINCT ID_HAYA FROM (  SELECT AUX.ID_HAYA , EPA.DD_EPA_DESCRIPCION
                                                                    FROM REM01.AUX_HREOS_5932 AUX 
                                                                    INNER JOIN REM01.ACT_ACTIVO ACt on AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
                                                                    INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM on SCM.DD_SCM_ID = ACT.DD_SCM_ID
                                                                    INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                                                    INNER JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                                                                    INNER JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                                                    WHERE SCM.DD_SCM_CODIGO <> '05'
                                                                    AND AUX.ALQUILADO = '02'
                                                                    AND TCO.DD_TCO_CODIGO = '02'
                                                                    AND ACT.BORRADO = 0 
                                                                    AND EPA.DD_EPA_CODIGO NOT IN ('01','04')  
															);


	CURSOR VALIDACION_3_7_B IS	SELECT DISTINCT ID_HAYA FROM   (SELECT AUX.ID_HAYA 
                                                                    FROM REM01.AUX_HREOS_5932 AUX 
                                                                        INNER JOIN REM01.ACT_ACTIVO ACt on AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
                                                                        INNER JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM on SCM.DD_SCM_ID = ACT.DD_SCM_ID
                                                                        INNER JOIN REM01.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                                                        INNER JOIN REM01.DD_EPA_ESTADO_PUB_ALQUILER EPA on EPA.DD_EPA_ID = APU.DD_EPA_ID
                                                                        INNER JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                                                        WHERE SCM.DD_SCM_CODIGO <> '05' AND ACT.BORRADO = 0  
                                                                                AND AUX.TIPO_CONTRATO_ALQUILER <> '01' 
                                                                                AND TCO.DD_TCO_CODIGO IN ('02') 
                                                                                AND EPA.DD_EPA_CODIGO NOT IN ('01','04')
																);
																	
												
	FILA_A VALIDACION_3_7_A%ROWTYPE;
	
	FILA_B VALIDACION_3_7_B%ROWTYPE;
	
	
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el informe de errores tras el proceso ...'); 

/**	3.7. Todos los activos del Excel marcados como “Alquilado” hay que revisar lo siguiente: **/
		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.AUX_HREOS_5932 WHERE ALQUILADO = ''02''';
		
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Numero de registros en la excel marcados como alquilados '||V_COUNT||' .');

/** 3.7. A. En publicación alquiler pueden estar como “No publicados” u “Ocultos por Alquiler”, cualquier otro tipo es error **/

		V_MSQL := 'SELECT COUNT(1) FROM (  SELECT AUX.ID_HAYA , EPA.DD_EPA_DESCRIPCION
                                                                    FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
                                                                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
                                                                    INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM on SCM.DD_SCM_ID = ACT.DD_SCM_ID
                                                                    INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                                                    INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                                                                    INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                                                    WHERE SCM.DD_SCM_CODIGO <> ''05''
                                                                    AND AUX.ALQUILADO = ''02''
                                                                    AND TCO.DD_TCO_CODIGO = ''02''
                                                                    AND ACT.BORRADO = 0 
                                                                    AND EPA.DD_EPA_CODIGO NOT IN (''01'',''04'') 
										)';
		
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Numero de registros que no se encuentran como No publicados u Ocultos por Alquiler y en la EXCEL están como Alquilados '||V_COUNT||' .');
		
		OPEN VALIDACION_3_7_A;
		
		V_COUNT := 0;
		PL_OUTPUT := '';
		
        DBMS_OUTPUT.PUT_LINE('	[INFO] ACTIVOS AFECTADOS');
        
		LOOP
			FETCH VALIDACION_3_7_A INTO FILA_A;
			EXIT WHEN VALIDACION_3_7_A%NOTFOUND;
			
			V_COUNT:= V_COUNT + 1;
			
			PL_OUTPUT := PL_OUTPUT ||V_COUNT||' - '|| FILA_A.ID_HAYA||' '||chr(10);
			
 
            IF LENGTH(PL_OUTPUT)>30000 THEN
                DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
                PL_OUTPUT := '';
            END IF;
            
		END LOOP;
		
		
		DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
		
/** 3.7. B. En publicación de venta (si corresponde) y si el tipo de alquiler NO es “Ordinario” pueden estar como “No publicados” u “Ocultos por Alquiler”, cualquier otro tipo es error**/
	 
		V_MSQL := 'SELECT COUNT(1) FROM   (SELECT AUX.ID_HAYA 
                                                                    FROM '||V_ESQUEMA||'.AUX_HREOS_5932 AUX 
                                                                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
                                                                        INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM on SCM.DD_SCM_ID = ACT.DD_SCM_ID
                                                                        INNER JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                                                        INNER JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA on EPA.DD_EPA_ID = APU.DD_EPA_ID
                                                                        INNER JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                                                        WHERE SCM.DD_SCM_CODIGO <> ''05'' AND ACT.BORRADO = 0  
                                                                                AND AUX.TIPO_CONTRATO_ALQUILER <> ''01'' 
                                                                                AND TCO.DD_TCO_CODIGO IN (''02'') 
                                                                                AND EPA.DD_EPA_CODIGO NOT IN (''01'',''04'')                          
                                            )';

		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
		
		DBMS_OUTPUT.PUT_LINE('	[INFO] Numero de registros que no son de tipo de alquiler NO es Ordinario pueden estar como No publicados u Ocultos por Alquiler '||V_COUNT||' .');
		
		OPEN VALIDACION_3_7_B;
		
		V_COUNT := 0;
		PL_OUTPUT := '';
		
        DBMS_OUTPUT.PUT_LINE('	[INFO] ACTIVOS AFECTADOS');
        
		LOOP
			FETCH VALIDACION_3_7_B INTO FILA_B;
			EXIT WHEN VALIDACION_3_7_B%NOTFOUND;
			
			V_COUNT:= V_COUNT + 1;
			
			PL_OUTPUT := PL_OUTPUT ||V_COUNT||' - '|| FILA_B.ID_HAYA||' '||chr(10);
			
 
            IF LENGTH(PL_OUTPUT)>30000 THEN
                DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
                PL_OUTPUT := '';
            END IF;
            
		END LOOP;
		
		
		DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] INFORME ERROES');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
