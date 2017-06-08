--/*
--#########################################
--## AUTOR=SERGIO HERNANDEZ
--## FECHA_CREACION=20170326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-1800
--## PRODUCTO=NO
--## 
--## Finalidad: Modificaciones varias tras migracion
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

TABLE_COUNT NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_EXISTE NUMBER (5);
MAX_NUM NUMBER (16);
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_MSQL VARCHAR2(2000 CHAR);

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICACION CLC_CLIENTE_COMERCIAL');

    V_MSQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CLC_CLIENTE_COMERCIAL'' and owner = '''||V_ESQUEMA||''' and (column_name = ''CLC_WEBCOM_ID_OLD'')';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
    -- Si NO existen los campos los creamos
 
    IF V_EXISTE = 0 THEN
		V_MSQL := 'ALTER TABLE '||v_esquema||'.CLC_CLIENTE_COMERCIAL ADD CLC_WEBCOM_ID_OLD NUMBER(16,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] CLC_CLIENTE_COMERCIAL creada columna CLC_WEBCOM_ID_OLD');	     
    END IF; 
  
      --Pedido en HREOS-1800
      EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL set CLC_WEBCOM_ID_OLD = CLC_WEBCOM_ID where usuariocrear = ''MIG2''');
      EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL set CLC_WEBCOM_ID = CLC_REM_ID where usuariocrear = ''MIG2''');

      EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.ACT_AGR_AGRUPACION set AGR_NUM_AGRUP_REM = AGR_NUM_AGRUP_UVEM where AGR_NUM_AGRUP_UVEM IS NOT NULL AND  USUARIOMODIFICAR = ''MIG2''');


    -- Obtenemos el valor maximo de la columna AGR_NUM_AGRUP_REM y lo incrementamos en 1
    V_MSQL := 'SELECT NVL(MAX(AGR_NUM_AGRUP_REM),0) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION';
    EXECUTE IMMEDIATE V_MSQL INTO MAX_NUM;
    
    MAX_NUM := MAX_NUM +1;
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_AGR_NUM_AGRUP_REM'' 
        AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_EXISTE; 
    
    -- Si existe secuencia la borramos
    IF V_EXISTE = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_AGR_NUM_AGRUP_REM... Secuencia eliminada');    
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_AGR_NUM_AGRUP_REM  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM||' NOCACHE NOORDER  NOCYCLE';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_AGR_NUM_AGRUP_REM... Secuencia creada e inicializada correctamente.');



  
    COMMIT;

   EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
