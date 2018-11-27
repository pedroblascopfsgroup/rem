--/*
--##########################################
--## AUTOR=javier.pons@pfsgroup.es
--## FECHA_CREACION=20181108
--## ARTEFACTO=incidencias_produccion
--## VERSION_ARTEFACTO=recovery_evolutivo
--## INCIDENCIA_LINK=REMVIP-2456
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir garaje a activo
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
	
 	V_ITEM VARCHAR2(50) := 'REMVIP-2456';

BEGIN 
	
V_SQL := q'[INSERT INTO ]' || V_ESQUEMA || q'[.ACT_DIS_DISTRIBUCION (DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, USUARIOCREAR, FECHACREAR, DIS_DESCRIPCION, ICO_ID)  
VALUES 
(REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL,  -1,  (SELECT DD_TPH_ID FROM ]' || V_ESQUEMA || q'[.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = 12), 1, 'REMVIP-2456', SYSDATE, 'garaje', (SELECT ICO_ID FROM ]' || V_ESQUEMA || q'[.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID = 263942)) ]';
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
