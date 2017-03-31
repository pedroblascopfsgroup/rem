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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_EXISTE NUMBER (5);
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
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
