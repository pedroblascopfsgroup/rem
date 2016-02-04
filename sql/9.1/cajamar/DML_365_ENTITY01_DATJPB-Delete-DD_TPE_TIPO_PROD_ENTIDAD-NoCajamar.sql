--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-1662
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar datos del Diccionario DD_TPE_TIPO_PROD_ENTIDAD que no son de cajamar
--##									
--##
--##
--##									
--##                               , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30 CHAR) :='DD_TPE_TIPO_PROD_ENTIDAD';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
  
  V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||TABLA||' D
			WHERE BORRADO = 1
			AND NOT EXISTS (SELECT 1 FROM ATC_ATIPICOS_CNT A WHERE A.DD_TPE_ID = D.DD_TPE_ID)
			AND NOT EXISTS (SELECT 1 FROM PCO_TPO_TPE_TIPO_BUR A WHERE A.DD_TPE_ID = D.DD_TPE_ID)
			AND NOT EXISTS (SELECT 1 FROM DD_TPE_TIPO_PROD_ENTIDAD_LG A WHERE A.DD_TPE_ID = D.DD_TPE_ID)
			AND NOT EXISTS (SELECT 1 FROM CNT_CONTRATOS A WHERE A.DD_TPE_ID = D.DD_TPE_ID)';
  
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] DD_TPE_TIPO_PROD_ENTIDAD - Delete campos con borrado = 1.');
  
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
