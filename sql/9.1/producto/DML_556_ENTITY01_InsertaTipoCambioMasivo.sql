--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20160113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1795
--## PRODUCTO=SI
--##
--## Finalidad: inserción en la tabla MEJ_DD_TRG_TIPO_REGISTRO para trazas de cambios masivos de gestor
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
    
BEGIN	
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MEJ_DD_TRG_TIPO_REGISTRO WHERE DD_TRG_CODIGO = ''CAMBIO_MASIVO'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... INSERCIÓN DEL TIPO CAMBIO_MASIVO EN EL DICCIONARIO MEJ_DD_TRG_TIPO_REGISTRO');
    	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) ' || 
    		'VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, ''CAMBIO_MASIVO'', ''Cambio masivo de gestor'', ''Cambio masivo de gestor'', ''SAG'', sysdate)';
    	EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.MEJ_DD_TRG_TIPO_REGISTRO: INSERCIÓN CORRECTA DEL TIPO ''CAMBIO_MASIVO'' ' );
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.MEJ_DD_TRG_TIPO_REGISTRO: EL TIPO ''CAMBIO_MASIVO'' YA EXISTE EN EL DICCIONARIO ' );
    END IF;
    
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