--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160403
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-3072
--## PRODUCTO=NO
--## 
--## Finalidad: Precontencioso- con marca gestión CAJAMAR incorrecta deberia ser HAYA
--##                               
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Ampliación a todas las fechas relacionadas con Bienes incorrectas.
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

  V_MSQL := '
	MERGE INTO '||V_ESQUEMA||'.'||'asu_asuntos asu  USING
	(
	  select asuf.asu_id
	       , (SELECT ges.DD_GES_ID FROM '||V_ESQUEMA||'.'||'DD_GES_GESTION_ASUNTO ges
		                   WHERE ges.DD_GES_CODIGO = ''HAYA'') as DD_GES_ID
	  from
	  (select asu.asu_id, asu.dd_tas_id, asu.DD_GES_ID, trim(substr(asu.asu_nombre,1,INSTR(asu.asu_nombre,''|'', 1) -1)) as numero_contrato
	      from '||V_ESQUEMA||'.'||'asu_asuntos asu ) asuf
	    , '||V_ESQUEMA||'.'||'cnt_contratos cnt
	    , '||V_ESQUEMA||'.'||'dd_ges_gestion_especial b
	    , '||V_ESQUEMA||'.'||'dd_cre_condiciones_remun_ext r
	  where asuf.numero_contrato = lpad(cnt.cnt_contrato,16,''0'')
	      and cnt.dd_ges_id = b.dd_ges_id
	      and cnt.dd_cre_id = r.dd_cre_id
	      AND dd_ges_codigo = ''HAYA''
	      AND dd_cre_codigo = ''AL''
	) AUX
	ON (asu.ASU_ID = AUX.ASU_ID AND asu.usuariocrear in (''MIGRAHAYA02'', ''MIGRAHAYA02PCO''))        
	WHEN MATCHED THEN
	UPDATE SET asu.DD_GES_ID = AUX.DD_GES_ID ';

  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Merge marcas AL para HAYA.');  

  COMMIT;

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT; 
