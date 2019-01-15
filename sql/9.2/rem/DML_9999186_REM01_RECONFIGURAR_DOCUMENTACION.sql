--/*
--#########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20181219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5103
--## PRODUCTO=NO
--## 
--## Finalidad: Reconfigurar la columna DD_SDE_VINCULABLE de la tabla DD_SDE_SUBTIPO_DOC_EXP
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
 V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
 V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
 V_TABLA VARCHAR2(40 CHAR):= 'DD_SDE_SUBTIPO_DOC_EXP';
 V_COUNT NUMBER(16); -- Vble. para contar.
 V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
 ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
 ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 --V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-5103';
 
 
BEGIN
    
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
	 SET '||V_TABLA||'.DD_SDE_VINCULABLE = 0, '||V_TABLA||'.USUARIOMODIFICAR = ''HREOS-5103'', '||V_TABLA||'.FECHAMODIFICAR = SYSDATE
	 WHERE '||V_ESQUEMA||'.'||V_TABLA||'.DD_SDE_CODIGO IN (''43'',''44'',''45'',''46'',''47'',''48'',''49'',''50'',''51'',''52'',''53'')' ;
	EXECUTE IMMEDIATE V_MSQL;


		
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