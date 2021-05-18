--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9705
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
	V_TABLA VARCHAR2(30 CHAR) := 'V_ACTIVOS_TRABAJOS';
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_TRABAJOS AS
	SELECT TBJ.TBJ_NUM_TRABAJO AS TRABAJO, ACT.ACT_NUM_ACTIVO AS ACTIVO
	FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
	JOIN '|| V_ESQUEMA ||'.ACT_TBJ ATBJ ON ATBJ.ACT_ID = ACT.ACT_ID
	JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATBJ.TBJ_ID AND TBJ.BORRADO = 0
	JOIN '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID AND TTR.DD_TTR_FILTRAR IS NULL
	WHERE ACT.BORRADO = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_TRABAJOS...Creada OK');

  IF V_ESQUEMA_MASTER != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_MASTER||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_MASTER||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;

  EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;   
  
END;
/

EXIT;
