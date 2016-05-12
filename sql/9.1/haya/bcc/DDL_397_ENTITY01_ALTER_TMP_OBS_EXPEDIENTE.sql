--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=20160405
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-2926
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de tabla TMP_OBS_EXPEDIENTE esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 GMN Se pone el campo TMP_REF_TIPO_OBSERVACION a nullable
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
 TABLA VARCHAR(30 CHAR) :='TMP_OBS_EXPEDIENTE';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

-- Crear tabla 1 TMP_PER_EST_CICLO_VIDA

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = TABLA;
  
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' 
	MODIFY TMP_TOM_DESCRIPCION VARCHAR2(215 CHAR)';
 
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' MODIFICADA');

--Fin crear tabla 1

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
