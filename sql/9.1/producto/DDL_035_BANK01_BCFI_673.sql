--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BCFI-673
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
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

	DBMS_OUTPUT.PUT_LINE('[START] ALTER TABLE ACU_ACUERDOS_PROCEDIMIENTOS');
	
	EXECUTE IMMEDIATE 'select count(1) from ALL_TAB_COLUMNS where COLUMN_NAME=''ACU_DEUDA_TOTAL'' and TABLE_NAME=''ACU_ACUERDOS_PROCEDIMIENTOS'' and owner = ''' || V_ESQUEMA || '''' INTO V_NUM_TABLAS;
	
	if V_NUM_TABLAS > 0 then	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_ACUERDOS_PROCEDIMIENTOS... CAMPO ACU_DEUDA_TOTAL ya existe');	
	else 	
		EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.ACU_ACUERDOS_PROCEDIMIENTOS  ADD ACU_DEUDA_TOTAL NUMBER (16,0)';
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.ACU_ACUERDOS_PROCEDIMIENTOS ADD ACU_DEUDA_TOTAL ... OK');	
	end if;
	
	EXCEPTION
	    WHEN OTHERS THEN
	        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
	        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	        DBMS_OUTPUT.put_line(SQLERRM);
	        ROLLBACK;
	        RAISE;
	          
	
	
END;
/

EXIT