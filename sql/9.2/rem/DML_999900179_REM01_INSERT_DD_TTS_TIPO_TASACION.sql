--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3792
--## PRODUCTO=NO
--##
--## Finalidad: Insertar el tipo de tasacion 12 -> Retasacion BDE en el diccionario DD_TTS_TIPO_TASACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_CODIGO VARCHAR2(32 CHAR) := '12';
	V_DESCRIPCION VARCHAR2(128 CHAR) := 'Retasacion BDE';
    V_DD VARCHAR2(27 CHAR) := 'DD_TTS_TIPO_TASACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-3792';

BEGIN

    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_DD||' WHERE DD_TTS_CODIGO = '''||V_CODIGO||'''' INTO V_COUNT;
		    
	IF V_COUNT = 0 THEN
		   	 
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_DD||' (
					   DD_TTS_ID
					 , DD_TTS_CODIGO
					 , DD_TTS_DESCRIPCION
					 , DD_TTS_DESCRIPCION_LARGA
					 , USUARIOCREAR
					 , FECHACREAR
					 ) VALUES (
					   S_'||V_DD||'.NEXTVAL
					 , '''||V_CODIGO||'''
					 , '''||V_DESCRIPCION||'''
					 , '''||V_DESCRIPCION||'''
					 , '''||V_USUARIO||'''
					 , SYSDATE
					 )
				 ';
				 
	        EXECUTE IMMEDIATE V_SQL;
	        
        DBMS_OUTPUT.PUT_LINE('[SUCCESS] Se han insertado en la tabla  '||V_DD||'el tipo de tasacion '||V_CODIGO||': '||V_DESCRIPCION||'');

	ELSE
		DBMS_OUTPUT.PUT_LINE('[WARNING] Ya existe el tipo de tasacion '||V_CODIGO||': '||V_DESCRIPCION||'');
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


