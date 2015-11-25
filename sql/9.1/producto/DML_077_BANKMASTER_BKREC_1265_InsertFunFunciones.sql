--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20151023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1265
--## PRODUCTO=SI
--## Finalidad: DML
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
    V_ENTIDAD_ID NUMBER(16);
    CUENTA NUMBER(10);  -- Vble. auxiliar para ver si existe un registro con el mismo FUN_DESCRIPCION

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

	--/** Guarda en CUENTA un contado por si ya existe el registro **/
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''ROLE_PUEDE_CAMBIAR_PROCURADORES_CON_PROVISION''';
    EXECUTE IMMEDIATE V_SQL INTO CUENTA;
	
	--/**
	-- * Insertar valores en la tabla FUNC_FUNCIONES
	-- **/   
	IF CUENTA=0 THEN
	  EXECUTE IMMEDIATE 'insert INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES(FUN_ID,FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR) 
			values('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL,''Permite cambiar el procurador de asuntos con provisión'',''ROLE_PUEDE_CAMBIAR_PROCURADORES_CON_PROVISION'',0,''BKREC-1265'',sysdate)';
	  COMMIT;
	  DBMS_OUTPUT.PUT_LINE('Valores insertados correctamente');
 	END IF;

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