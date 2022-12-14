--/*
--##########################################
--## AUTOR=lara.pablo@pfsgroup.es
--## FECHA_CREACION=20221215
--## ARTEFACTO=incidencias_produccion
--## VERSION_ARTEFACTO=recovery_evolutivo
--## INCIDENCIA_LINK=HREOS-19080
--## PRODUCTO=NO
--## 
--## Finalidad: Merge Mapeo Jupiter Subcarteras
--## VERSIONES:
--##        Generado automáticamente por asistenteDML
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON
SET TIMING ON

DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';
	V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
	err_num NUMBER;
	err_msg VARCHAR2(2048); 

	V_SQL VARCHAR2(8500 CHAR);
	
 	V_ITEM VARCHAR2(50) := q'['HREOS-19080']';

BEGIN 
	
V_SQL := q'[UPDATE ]' || V_ESQUEMA || q'[.MJR_MAPEO_JUPITER_REM SET MJR_CODIGO_REM=REPLACE(MJR_CODIGO_REM, 'Unicaja', 'Liberbank') WHERE MJR_CODIGO_REM LIKE '%Unicaja%']';
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE(' ... ' || RPAD(substr(V_SQL, 1, 60), 60, ' ') || ' ... registros afectados ...' || sql%rowcount);

V_SQL := q'[merge INTO ]' || V_ESQUEMA || q'[.mjr_mapeo_jupiter_rem mapeo using ( select m.mjr_id, m.mjr_codigo_rem, s.dd_scr_codigo FROM ]' || V_ESQUEMA || q'[.mjr_mapeo_jupiter_rem m inner JOIN ]' || V_ESQUEMA || q'[.dd_cra_cartera c on c.borrado=0 inner JOIN ]' || V_ESQUEMA || q'[.dd_scr_subcartera s on s.borrado=0 and c.dd_cra_id=s.dd_cra_id where m.mjr_tipo_perfil = 'subcartera' and m.borrado=0 and UPPER(m.mjr_codigo_rem)=UPPER(c.dd_cra_descripcion || ' / ' || s.dd_scr_descripcion) ) queryaux on ( mapeo.mjr_id = queryaux.mjr_id ) when matched then update set mapeo.mjr_codigo_rem = queryaux.dd_scr_codigo ]';
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE(' ... ' || RPAD(substr(V_SQL, 1, 60), 60, ' ') || ' ... registros afectados ...' || sql%rowcount);

V_SQL := q'[UPDATE ]' || V_ESQUEMA || q'[.mjr_mapeo_jupiter_rem SET USUARIOBORRAR=]' || V_ITEM || q'[, BORRADO=1, FECHABORRAR=SYSDATE WHERE MJR_CODIGO_REM='BFA / BFA' ]';
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE(' ... ' || RPAD(substr(V_SQL, 1, 60), 60, ' ') || ' ... registros afectados ...' || sql%rowcount);


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
