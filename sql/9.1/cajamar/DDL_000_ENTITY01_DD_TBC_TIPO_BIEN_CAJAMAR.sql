--/*
--##########################################
--## AUTOR=Gonzalo E
--## FECHA_CREACION=20150916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hy
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TBC_TIPO_BIEN_CAJAMAR... Creando vista...');
    V_MSQL := 'create or replace view '||V_ESQUEMA||'.DD_TBC_TIPO_BIEN_CAJAMAR AS ' ||
		' SELECT DD_TBI_ID,DD_TBI_CODIGO,DD_TBI_DESCRIPCION,DD_TBI_DESCRIPCION_LARGA,BORRADO ' ||
		' FROM '||V_ESQUEMA||'.Dd_Tbi_Tipo_Bien ' ||
		' WHERE DD_TBI_CODIGO IN (''7'',''34'',''6'',''4'',''5'',''31'',''8'',''80'',''79'',''82'',''77'',''78'',''81'',''28'',''27'',''15'',''21'',''20'',' ||
		' ''72'',''67'',''76'',''14'',''26'',''13'',''66'',''30'',''32'',''58'',''17'',''16'',''12'',''19'',''18'',''36'',''3'',''2'',''1'',' ||
		' ''11'',''35'',''55'',''25'',''24'',''23'',''71'',''33'',''70'',''22'',''9'',''10'',''69'',''68'', '||
		' ''01'',''02'',''03'',''04'',''05'',''06'')'; -- QUITAR LA ULTIMA LINEA, SON LOS LOS DE LA BD ORIGINAL!!!!!!!
    EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TBC_TIPO_BIEN_CAJAMAR... Vista creada');
	
    COMMIT;
    
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