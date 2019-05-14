--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190430
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4112
--## PRODUCTO=NO
--##
--## Finalidad: Corregir los registro incorrectos en la tabla AHP provocados por la última subida
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-4112';  -- Vble. usuario crear
    V_COUNT NUMBER(25);  -- Vble. para validar la existencia de los registros
    
    
BEGIN
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
				    WITH HIST AS (
				        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA,
				        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_ID DESC NULLS FIRST) RN
				        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
				        WHERE ((AHP.AHP_FECHA_FIN_VENTA > ''19/04/19'' OR AHP.AHP_FECHA_FIN_VENTA IS NULL))
						AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL
				        AND DD_TCO_ID IN (1,2)
				        AND AHP.BORRADO = 0
				        ORDER BY 1,2,3,5
				    )
				    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_VENTA, H.AHP_FECHA_FIN_VENTA, H.RN, H2.AHP_FECHA_FIN_VENTA AS FECHA_INI_NUEVA
				    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
				    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
				    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
				    WHERE AHP.DD_TCO_ID in (1,2) AND H2.AHP_FECHA_FIN_VENTA IS NOT NULL
				) T2
				ON (T1.AHP_ID = T2.AHP_ID)
				WHEN MATCHED THEN UPDATE SET
				    T1.AHP_FECHA_INI_VENTA = T2.FECHA_INI_NUEVA
				    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				    ,T1.FECHAMODIFICAR = SYSDATE
				WHERE T1.DD_TCO_ID IN (1,2)
				AND T2.FECHA_INI_NUEVA IS NOT NULL';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
				USING (
				    WITH HIST AS (
				        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER,
				        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_ID DESC NULLS FIRST) RN
				        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
				        WHERE ((AHP.AHP_FECHA_FIN_ALQUILER > ''19/04/19'' OR AHP.AHP_FECHA_FIN_ALQUILER IS NULL))
						AND AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL
				        AND DD_TCO_ID IN (2,3)
				        AND AHP.BORRADO = 0
				        ORDER BY 1,2,3,5
				    )
				    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_ALQUILER, H.AHP_FECHA_FIN_ALQUILER, H.RN, H2.AHP_FECHA_FIN_ALQUILER AS FECHA_INI_NUEVA
				    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
				    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
				    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
				    WHERE AHP.DD_TCO_ID in (2,3) AND H2.AHP_FECHA_FIN_ALQUILER IS NOT NULL
				) T2
				ON (T1.AHP_ID = T2.AHP_ID)
				WHEN MATCHED THEN UPDATE SET
				    T1.AHP_FECHA_INI_ALQUILER = T2.FECHA_INI_NUEVA
				    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				    ,T1.FECHAMODIFICAR = SYSDATE
				WHERE T1.DD_TCO_ID IN (2,3)
				AND T2.FECHA_INI_NUEVA IS NOT NULL';
    EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[FIN] Actualización del histórico realizada correctamente');
		
    COMMIT;
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;