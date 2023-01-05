--/*
--##########################################
--## AUTOR=lara.pablo@pfsgroup.es
--## FECHA_CREACION=20230105
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
	
V_SQL := q'[UPDATE ]' || V_ESQUEMA || q'[.DD_SDE_SUBTIPO_DOC_EXP SET DD_SDE_DESCRIPCION = 'NIE/Tarjeta de residencia', FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = 'HREOS-19019' WHERE DD_SDE_CODIGO = 93]';
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
