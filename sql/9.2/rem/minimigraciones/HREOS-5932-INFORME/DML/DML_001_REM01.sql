--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190325
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
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
	V_MSQL VARCHAR2(5000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_COUNT NUMBER(16);
	
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de modificar la tabla auxiliar ...'); 

	-- BORRADO DUPLICADOS 
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 
				WHERE ROWID IN  (select ROWID from ( 
						    select ACT_NUM_ACTIVO , row_number() over (partition by ACT_NUM_ACTIVO order by ACT_NUM_ACTIVO desc) AS ORDEN 
						    from '||V_ESQUEMA||'.AUX_INF_HREOS_5932 AUX )
						where ORDEN > 1
						)';
						
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros. Motivo -> DUPLICADOS'); 
	
	V_MSQL := 'SELECT COUNT(1) FROM (

			(SELECT ACT.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
			inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
			WHERE AGR.AGR_NUM_AGRUP_REM in (SELECT AGR.AGR_NUM_AGRUP_REM
						            FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 AUX
						            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.ACT_NUM_ACTIVO
						            inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
						            inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
						            inner join '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION tag on tag.dd_tag_id = agr.dd_tag_id 
						            WHERE TAG.DD_TAG_CODIGO = ''02''
						        )
			)MINUS(
			    SELECT ACT.ACT_NUM_ACTIVO 
			    FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 AUX
			    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.ACT_NUM_ACTIVO
			))';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Numero activos que no esten en la excel y que compartan agrupacion restringida con un activo que si este en la excel '||V_COUNT||'');
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_INF_HREOS_5932 (ACT_NUM_ACTIVO)
				SELECT ACT_NUM_ACTIVO FROM (

							(SELECT ACT.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
							inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
							inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
							WHERE AGR.AGR_NUM_AGRUP_REM in (SELECT AGR.AGR_NUM_AGRUP_REM
													FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 AUX
													INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.ACT_NUM_ACTIVO
													inner join '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga on act.act_id = aga.act_id
													inner join '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr on aga.agr_id = agr.agr_id AND AGR.AGR_FECHA_BAJA IS NULL
													inner join '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION tag on tag.dd_tag_id = agr.dd_tag_id 
													WHERE TAG.DD_TAG_CODIGO = ''02''
												)
							)MINUS(
								SELECT ACT.ACT_NUM_ACTIVO 
								FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 AUX
								INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACt on ACT.ACT_NUM_ACTIVO = aux.ACT_NUM_ACTIVO
							))';
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se insertan los activos que no esten en la excel y que compartan agrupacion restringida con un activo que si este en la excel '||V_COUNT||'');
	
	-- BORRADO VENDIDOS
	
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 
				WHERE ACT_NUM_ACTIVO IN (SELECT AUX.ACT_NUM_ACTIVO 
									FROM '||V_ESQUEMA||'.AUX_INF_HREOS_5932 aux
									INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO act on AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
									inner join '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL scm on scm.dd_scm_id = ACT.DD_SCM_ID
									WHERE SCM.DD_SCM_CODIGO = ''05'')';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han eliminado '||SQL%ROWCOUNT||' vendidos.');

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');


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
