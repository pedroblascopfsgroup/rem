--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-188
--## PRODUCTO=SI
--## Finalidad: Insertar registro en 'DD_AEX_AMBITOS_EXPEDIENTE'
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
	

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: Script para insertar registro en DD_AEX_AMBITOS_EXPEDIENTE.');
	
	/**
 	* INSERTAR EL REGISTRO 'EXP' EN DD_AEX_AMBITOS_EXPEDIENTE
 	*/
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobaciones previas a insert DD_AEX_AMBITOS_EXPEDIENTE.');
	
	V_SQL := 'SELECT COUNT (*) FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO = ''EXP''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro ''EXP'' en DD_AEX_AMBITOS_EXPEDIENTE.');
	ELSE
		V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE 
					(DD_AEX_ID,DD_AEX_CODIGO,DD_AEX_DESCRIPCION,DD_AEX_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
					VALUES
					('||V_ESQUEMA_M||'.S_DD_AEX_AMBITOS_EXPEDIENTE.NEXTVAL,''EXP'',''Expediente'',''Expediente'',0,''PRODU-188'',SYSDATE,0)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: Registro ''EXP'' insertado correctamente.');
	END IF;
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Script finalizado correctamente.');
   

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