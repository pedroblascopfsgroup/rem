--/*
--##########################################
--## AUTOR=Hector Crespo
--## FECHA_CREACION=20210423
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13820
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla APR_AUX_CIEOFI_BNK_MUL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); 
	V_ESQUEMA VARCHAR2(27 CHAR):= '#ESQUEMA#'; 
	V_ESQUEMA_M VARCHAR2(27 CHAR):= '#ESQUEMA_MASTER#';
	V_SQL VARCHAR2(4000 CHAR);
	V_NUM VARCHAR2(16);
	ERR_NUM VARCHAR2(25);  
	ERR_MSG VARCHAR2(1024 CHAR); 
	V_TEXT_TABLA VARCHAR2(30 CHAR):= 'APR_AUX_CIEOFI_BNK_MUL';

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO.');
	
	V_MSQL := '
	SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM != 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TEXT_TABLA||''' YA EXISTE, SE BORRA Y SE VUELVE A CREAR');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '||V_TEXT_TABLA||' NO EXISTE. SE CREARÁ.');
	END IF;		
	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
		    OFI_SALIENTE VARCHAR2(250 CHAR)
            , OFI_ENTRANTE VARCHAR2(250 CHAR)
		)
		'; 
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] LA TABLA '''||V_TEXT_TABLA||''' HA SIDO CREADA CON EXITO.');
  COMMIT;
    
  DBMS_OUTPUT.PUT_LINE('[INFO] PROCESO FINALIZADO.');
         
EXCEPTION

   WHEN OTHERS THEN
   
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(ERR_MSG);

        ROLLBACK;
        RAISE;          

END;
/
EXIT
