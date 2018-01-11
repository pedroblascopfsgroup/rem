--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3631
--## PRODUCTO=NO
--## Finalidad: Script de completitud de la tabla ACT_LOC_LOCALIZACION.
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_M#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de insercion de registros de localización...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION... Procedemos a insertar');
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BLOC ON BLOC.BIE_ID = act.BIE_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
			WHERE  LOC.ACT_ID IS NULL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen registros insertamos
    IF V_NUM_TABLAS > 0 THEN		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION (LOC_ID, ACT_ID, BIE_LOC_ID, LOC_LONGITUD, LOC_LATITUD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					SELECT 
					'||V_ESQUEMA||'.S_ACT_LOC_LOCALIZACION.NEXTVAL,
					ACT.ACT_ID,
					BIE.BIE_LOC_ID,
					0,
					0,
					0,
					''HREOS-3631'',
					SYSDATE,
					0
					FROM '||V_ESQUEMA||'.BIE_LOCALIZACION BIE
					INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.BIE_ID = BIE.BIE_ID
					LEFT JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.BIE_LOC_ID = BIE.BIE_LOC_ID
					WHERE LOC.BIE_LOC_ID IS NULL';
		EXECUTE IMMEDIATE V_SQL; 
			
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION... SE HAN INSERTADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');    
    ELSE    
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION... No hay registros pendientes de insertar');    
    END IF;    
    
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion de registros de localización');
	
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
