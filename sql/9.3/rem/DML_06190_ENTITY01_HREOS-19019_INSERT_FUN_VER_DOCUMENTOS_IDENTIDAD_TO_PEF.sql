--/*
--##########################################
--## AUTOR=lara.pablo@pfsgroup.es
--## FECHA_CREACION=20221223
--## ARTEFACTO=incidencias_produccion
--## VERSION_ARTEFACTO=recovery_evolutivo
--## INCIDENCIA_LINK=HREOS-19019
--## PRODUCTO=NO
--## 
--## Finalidad: INSERT_FUN_VER_DOCUMENTOS_IDENTIDAD_TO_PEF
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
	
 	V_ITEM VARCHAR2(50) := 'HREOS-19019';

BEGIN 
	
V_SQL := q'[INSERT INTO ]' || V_ESQUEMA || q'[.FUN_PEF(FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) SELECT (SELECT FUN_ID FROM ]' || V_ESQUEMA_MASTER || q'[.FUN_FUNCIONES WHERE FUN_DESCRIPCION = 'FUN_VER_DOCUMENTOS_IDENTIDAD'), PEF_ID, S_FUN_PEF.NEXTVAL, 0, 'HREOS-190190', SYSDATE, 0 FROM ]' || V_ESQUEMA || q'[.PEF_PERFILES WHERE PEF_ID IN (SELECT fp.pef_id FROM fun_pef fp JOIN ]' || V_ESQUEMA_MASTER || q'[.fun_funciones fun on fun.fun_id = fp.fun_id Where fun.fun_descripcion = 'TAB_DOCUMENTOS_EXPEDIENTES' ) ]';
DBMS_OUTPUT.PUT_LINE(V_SQL);
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
