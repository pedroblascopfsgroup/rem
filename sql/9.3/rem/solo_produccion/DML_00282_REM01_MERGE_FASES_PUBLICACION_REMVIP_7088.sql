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

	DBMS_OUTPUT.PUT_LINE('[INFO] Se van a actualizar act_hfp_hist_fases_pub > hfp_fecha_fin a null.');

	execute immediate 'merge into '||V_ESQUEMA||'.act_hfp_hist_fases_pub t1 using (
						    select act_id, max(hfp_id) hfp_id, null as hfp_fecha_fin from '||V_ESQUEMA||'.act_hfp_hist_fases_pub where act_id in (
						    select distinct act_id from '||V_ESQUEMA||'.act_hfp_hist_fases_pub h1 where usuariocrear = ''MIG_DIVARIAN'' and hfp_fecha_fin is not null and act_id not in (
						    select distinct act_id from '||V_ESQUEMA||'.act_hfp_hist_fases_pub hi2 where hi2.hfp_fecha_fin is null)) group by act_id
						) t2
						on (t2.hfp_id = t1.hfp_id)
						when matched then update set
						t1.hfp_fecha_fin = t2.hfp_fecha_fin,
						t1.usuariomodificar = ''REMVIP-7088'',
						t1.fechamodificar = sysdate';

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en act_hfp_hist_fases_pub. Deberian ser 13.');  

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
