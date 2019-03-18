--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3526
--## PRODUCTO=NO
--##
--## Finalidad: Update e insert en DD_MRO_MOTIVO_RECHAZO_OFERTA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_PAI_PAISES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-3526';  -- Vble. usuario crear
    V_COUNT NUMBER(25);  -- Vble. para validar la existencia de los registros
    
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PAI_CODIGO = ''250''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    IF V_COUNT = 0 THEN
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
					(DD_PAI_ID, DD_PAI_CODIGO, DD_PAI_DESCRIPCION, DD_PAI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES('||V_ESQUEMA||'.S_DD_PAI_PAISES.NEXTVAL, ''250'', ''Kosovo'', ''Kosovo'', 0, '''||V_USUARIO||''', SYSDATE, 0)';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('	[INFO]	KOSOVO AÑADIDO A LA TABLA DD_PAI_PAISES CORRECTAMENTE');
	ELSE
    	DBMS_OUTPUT.PUT_LINE('	[INFO]	EL REGISTRO ''KOSOVO'' YA EXISTE');
    END IF;
    
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_PAI_CODIGO = ''251''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    IF V_COUNT = 0 THEN
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
					(DD_PAI_ID, DD_PAI_CODIGO, DD_PAI_DESCRIPCION, DD_PAI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					VALUES('||V_ESQUEMA||'.S_DD_PAI_PAISES.NEXTVAL, ''251'', ''Niue'', ''Niue'', 0, '''||V_USUARIO||''', SYSDATE, 0)';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('	[INFO]	NIUE AÑADIDO A LA TABLA DD_PAI_PAISES CORRECTAMENTE');
	ELSE
    	DBMS_OUTPUT.PUT_LINE('	[INFO]	EL REGISTRO ''NIUE'' YA EXISTE');
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
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;