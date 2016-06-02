--/*
--##########################################
--## AUTOR=Carlos Lopez
--## FECHA_CREACION=20160413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-
--## PRODUCTO=NO
--## 
--## Finalidad: Crea V_LIS_PREPROYECT_MOV
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='V_LIS_PREPROYECT_MOV';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
    FROM ALL_TABLES
  WHERE TABLE_NAME = TABLA;
             
  IF V_EXISTE = 1 THEN   
     DBMS_OUTPUT.PUT_LINE(TABLA||' Existe, no se hace nada');
  ELSE   
  
   V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||
   '(	"CNT_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"MOV_RIESGO" NUMBER(14,2), 
	"MOV_DEUDA_IRREGULAR" NUMBER(14,2) NOT NULL ENABLE, 
	"MOV_FECHA_POS_VENCIDA" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  ';
              
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');

--Fin crear tabla

	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'."IDX_MOV_CNT_ID_MOV_DEU_IRR" ON '||V_ESQUEMA||'.'||TABLA||
   ' ("CNT_ID","MOV_DEUDA_IRREGULAR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE '||ITABLE_SPACE;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('CREADO INDICE PARA '||TABLA);

	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'."IDX_MOV_MOV_DEUDA_IRREGULAR" ON '||V_ESQUEMA||'.'||TABLA||
   ' ("MOV_DEUDA_IRREGULAR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE '||ITABLE_SPACE;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('CREADO INDICE PARA '||TABLA);

	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'."V_LIS_PREPROYECT_MOV_CNT_INDEX" ON '||V_ESQUEMA||'.'||TABLA||
   ' ("CNT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE '||ITABLE_SPACE;

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('CREADO INDICE UNICO PARA '||TABLA);
  END IF;           
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
EXIT
