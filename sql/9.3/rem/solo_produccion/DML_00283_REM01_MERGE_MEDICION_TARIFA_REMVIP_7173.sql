--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200427
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-7088
--## PRODUCTO=NO
--## 
--## Finalidad: Carga masiva. act_hfp_hist_fases_pub.hfp_fecha_fin a NULL
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar ACT_TCT_TRABAJO_CFGTARIFA DESDE AUX_MEDICION_TARIFA_REMVIP_7173.');

	execute immediate 'merge into '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA t1 using (
						    select DISTINCT CFG.TCT_ID, AUX.MEDICION/100 AS MEDICION
						     from '||V_ESQUEMA||'.AUX_MEDICION_TARIFA_REMVIP_7173 AUX 
						     INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_NUM_TRABAJO = AUX.TRABAJO 
						     INNER JOIN '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA CFG ON CFG.TBJ_ID = TBJ.TBJ_ID 
						) t2
						on (t2.TCT_ID = t1.TCT_ID)
						when matched then update set
						t1.TCT_MEDICION = t2.MEDICION,
						t1.usuariomodificar = ''REMVIP-7173'',
						t2.fechamodificar = sysdate';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TCT_TRABAJO_CFGTARIFA. Deberian ser 91.688.');  

	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
