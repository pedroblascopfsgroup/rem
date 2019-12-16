--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20191205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5908
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5908'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	


    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Deshaciendo el borrado lógico de activos ');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
		    USING( 

				SELECT ACT_ID, ( ACT_NUM_ACTIVO * (-1) ) AS ACT_NUM_ACTIVO
				FROM '|| V_ESQUEMA ||'.ACT_ACTIVO
				WHERE 1 = 1
				AND ACT_NUM_ACTIVO_PRINEX IN
			(

10515,
10516,
10517,
10518,
10519,
10520,
10521,
10538,
10540,
10541,
10542,
10543,
10544,
10545,
10546,
10547,
10548,
10549,
10550,
10551,
10552,
10553,
10554,
10555,
10556,
10557,
10558,
10559,
10561,
10562,
10563,
10564,
10565,
10566,
10567,
10568,
10569,
10570,
10572,
10573,
10575,
10576,
10577,
10578,
10579,
10580,
10581,
10582,
10583,
10584,
10585,
10586,
10587,
10588,
10589,
10590,
10591,
10592,
10593,
10594,
10595,
10596,
10597,
10598,
10599,
10600,
10601,
10602,
10603,
10604,
10605,
10606,
10607,
10608,
10609,
10610,
10611,
10614,
10615,
10616,
10617,
10618,
10619,
10620,
10621,
10622,
10623,
10624,
10625,
10626,
10627,
10628,
10629

			)

			   AND BORRADO = 1 

			) AUX
		    ON ( AUX.ACT_ID = ACT.ACT_ID )
		    WHEN MATCHED THEN UPDATE SET
		    ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO,	
		    BORRADO = 0,
		    FECHABORRAR = NULL,
		    USUARIOBORRAR = NULL,	

		    FECHAMODIFICAR = SYSDATE,
		    USUARIOMODIFICAR = ''' || V_USR || '''
' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se activan '||SQL%ROWCOUNT||' registros de ACT_ACTIVO '); 	
   
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
