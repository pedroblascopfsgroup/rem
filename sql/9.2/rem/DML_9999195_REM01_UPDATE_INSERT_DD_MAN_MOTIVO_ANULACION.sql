--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3320
--## PRODUCTO=NO
--##
--## Finalidad: Update e insert en DD_MAN_MOTIVO_ANULACION
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MAN_MOTIVO_ANULACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-3320';
    VALIDACION VARCHAR2(2400 CHAR);
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] ');

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                SET DD_MAN_VENTA = 1,
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE,
					VERSION = VERSION + 1
                WHERE DD_MAN_CODIGO IN (''100'', ''101'', ''102'', ''103'', ''200'', ''201'', ''202'', ''300'', ''301'', ''302'', ''400'', ''401'', ''402'', ''403'',
										''404'', ''405'', ''500'', ''501'', ''502'', ''503'', ''600'', ''601'', ''602'', ''603'', ''604'', ''605'', ''606'', ''607'',
										''608'', ''700'', ''701'', ''702'', ''705'', ''706'', ''800'', ''801'', ''802'', ''803'', ''804'', ''901'', ''902'')';
        EXECUTE IMMEDIATE V_MSQL;
        
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                SET DD_MAN_ALQUILER = 0,
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE
                WHERE DD_MAN_CODIGO = ''200''';
        EXECUTE IMMEDIATE V_MSQL;
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_MAN_CODIGO = ''903''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 0 THEN	
	        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	                	(DD_MAN_ID, DD_MAN_CODIGO, DD_MAN_DESCRIPCION, DD_MAN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_MAN_VENTA, DD_MAN_ALQUILER)
						VALUES('||V_ESQUEMA||'.S_DD_MAN_MOTIVO_ANULACION.NEXTVAL, ''903'', ''EXCESIVO TIEMPO EN FIRMAR'', ''EXCESIVO TIEMPO EN FIRMAR'', 0, '''||V_USUARIO||''', 
						SYSDATE, 0, 0, 1)';
	        EXECUTE IMMEDIATE V_MSQL;
	        DBMS_OUTPUT.PUT_LINE('	[INFO]	REGISTRO AÑADIDO A LA TABLA DD_MAN_MOTIVO_ANULACION CORRECTAMENTE');
	    ELSE
	    	DBMS_OUTPUT.PUT_LINE('	[INFO]	EL REGISTRO YA EXISTE');
	    END IF;
        
        DBMS_OUTPUT.PUT_LINE('[FIN] ');
        
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