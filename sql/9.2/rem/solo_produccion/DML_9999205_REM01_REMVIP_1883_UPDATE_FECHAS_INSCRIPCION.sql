--/*
--##########################################
--## AUTOR=REMUS OVIDIU VIOREL
--## FECHA_CREACION=20180921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1883
--## PRODUCTO=NO
--##
--## Finalidad: PONER FECHA INSCRIPCION EN ACTIVOS 
--## INSTRUCCIONES:
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1883';    
    
BEGIN	
	
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TIT_TITULO T1 USING (
                        SELECT ACTT.ACT_ID, BIE_DREG_FECHA_INSCRIPCION 
			FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE 
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON BIE.BIE_ID = ACT.BIE_ID 
                        JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO ACTT ON ACTT.ACT_ID = ACT.ACT_ID 
                        JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID 
                        WHERE ACT.ACT_NUM_ACTIVO IN (6031863,
                        6031941,
                        6035977,
                        6035978,
                        6035979,
                        6036002,
                        6036017,
                        6036472,
                        6037322,
                        6037323,
                        6037668,
                        6037669,
                        6037885,
                        6043679,
                        6077431,
                        6077528,
                        6079068,
                        6079144,
                        6079276,
                        6080931,
                        6081038,
                        6081064,
                        6081920,
                        6082545,
                        6084179,
                        6133599,
                        6136253,
                        6136681,
                        6136979,
                        6528493,
                        6757955)
                    ) T2 ON (T1.ACT_ID = T2.ACT_ID)
                    WHEN MATCHED THEN UPDATE SET
                      T1.TIT_FECHA_INSC_REG = T2.BIE_DREG_FECHA_INSCRIPCION 
                    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''' 
                    , T1.FECHAMODIFICAR = SYSDATE';


        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla ACT_TIT_TITULO');
	   
        COMMIT;

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
