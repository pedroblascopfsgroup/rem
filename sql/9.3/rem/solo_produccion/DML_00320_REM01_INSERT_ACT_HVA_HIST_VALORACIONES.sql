--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7404
--## PRODUCTO=NO
--## Finalidad:
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7404';
    
 BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES T1
		    USING (SELECT ACT.ACT_ID, AUX.IMPORTE, AUX.VAL_FECHA_INICIO, AUX.VAL_FECHA_FIN, AUX.VAL_FECHA_APROV, AUX.VAL_FECHA_CARGA
			    FROM '||V_ESQUEMA||'.AUX_REMVIP_7404 AUX 
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_DIVARIAN = AUX.ACTIVO) T2
		    ON (T1.ACT_ID = T2.ACT_ID AND T1.HVA_IMPORTE = T2.IMPORTE AND T1.HVA_FECHA_INICIO = TO_DATE(T2.VAL_FECHA_INICIO,''DD/MM/YYYY''))
		    WHEN NOT MATCHED THEN
		    INSERT (HVA_ID
			      ,ACT_ID
			      ,DD_TPC_ID
			      ,HVA_IMPORTE
			      ,HVA_FECHA_INICIO
			      ,HVA_FECHA_FIN
			      ,HVA_FECHA_APROBACION
			      ,HVA_FECHA_CARGA
			      ,VERSION
			      ,USUARIOCREAR
			      ,FECHACREAR
			      ,BORRADO)
		    VALUES ('||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL,
			    T2.ACT_ID,
			    3,
			    T2.IMPORTE,
			    TO_DATE(T2.VAL_FECHA_INICIO,''DD/MM/YYYY''),
			    TO_DATE(T2.VAL_FECHA_FIN,''DD/MM/YYYY''),
			    TO_DATE(T2.VAL_FECHA_APROV,''DD/MM/YYYY''),
			    TO_DATE(T2.VAL_FECHA_CARGA,''DD/MM/YYYY''),
			    0,
			    ''REMVIP-7404'',
			    SYSDATE,
			    0)
			  ';
    				
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('Mergeados ' ||SQL%ROWCOUNT|| ' registros');
      
	DBMS_OUTPUT.PUT_LINE('[FIN] ACT_HVA_HIST_VALORACIONES actualizada correctamente ');
      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
