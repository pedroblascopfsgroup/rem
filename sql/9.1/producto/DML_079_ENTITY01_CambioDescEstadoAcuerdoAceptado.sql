--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150925
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad: Cambia la descripción del Estado de Acuerdo desde Aceptado a Elevado 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_ENTIDAD_ID NUMBER(16);
    
BEGIN	

DBMS_OUTPUT.PUT_LINE('[START]  tabla DD_EAC_ESTADO_ACUERDO');

V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.DD_EAC_ESTADO_ACUERDO set DD_EAC_DESCRIPCION=''Elevado'', DD_EAC_DESCRIPCION_LARGA=''Elevado'' where DD_EAC_DESCRIPCION = ''Aceptado''';
EXECUTE IMMEDIATE V_MSQL;
COMMIT;

DBMS_OUTPUT.PUT_LINE('UPDATE  '|| V_ESQUEMA_M ||'.DD_EAC_ESTADO_ACUERDO ... OK');
   
    
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