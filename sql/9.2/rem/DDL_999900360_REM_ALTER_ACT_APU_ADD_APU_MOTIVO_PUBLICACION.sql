--/*
--##########################################
--## AUTOR=Matias Garcia-Argudo
--## FECHA_CREACION=20181024
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=?
--## INCIDENCIA_LINK=HREOS-4637
--## PRODUCTO=NO
--## Finalidad: DDL para añadir la columna APU_MOTIVO_PUBLICACION a la tabla ACT_APU
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##       
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    COLUMN_COUNT NUMBER(1,0) := 0;
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):='#ESQUEMA_MASTER#'; --Configuracion Esquema Master
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
	V_TABLA VARCHAR2(4000 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';
	V_COLUMN VARCHAR2(4000 CHAR) := 'APU_MOTIVO_PUBLICACION';
	
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
	DBMS_OUTPUT.PUT_LINE(' ');
	DBMS_OUTPUT.PUT_LINE('[INFO] crear Columna: '||V_COLUMN);
	
	
	--COLUMN_COUNT:= 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME= '''||V_COLUMN||''' AND OWNER='''||V_ESQUEMA||'''';
	SELECT COUNT(1) INTO COLUMN_COUNT FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''||V_TABLA||'' AND COLUMN_NAME= ''||V_COLUMN||'' AND OWNER= ''||V_ESQUEMA||'';
	--DBMS_OUTPUT.PUT_LINE('[INFO] VALOR V_MSQL: '||V_MSQL);
	IF COLUMN_COUNT > 0 THEN
	
	  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||''||V_COLUMN||' LA COLUMNA EXISTE');
	  
	ELSE
	
		V_MSQL := '
        ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'

            ADD     APU_MOTIVO_PUBLICACION		VARCHAR2(1500 CHAR)

   		';

        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||''||V_COLUMN||' CREADA');
		
	END IF;
	
	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
EXIT;


