--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191010
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Corregir la columna mal definida del script DDL_00016_REM01_ALTER_TABLE_ACT_CRG_CARGAS_IMP_VENTA.sql
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

	--Comprobamos si existe foreign key FK_ACTIVO_GESTOR_PRECIO
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS WHERE CRG_IMPIDE_VENTA IS NOT NULL';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS <> 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La columna CRG_IMPIDE_VENTA contiene datos, no es alterable, no hacemos nada.');		
	ELSE
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_CRG_CARGAS MODIFY (CRG_IMPIDE_VENTA NUMBER(1,0))';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_IMPIDE_VENTA IS ''Indicador que marca si se impide o no la venta''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_CRG_CARGAS.CRG_IMPIDE_VENTA TIPO Y COMENTARIO CAMBIADO');
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

EXIT
