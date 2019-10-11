--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5329
--## PRODUCTO=NO
--##
--## Finalidad:Borrado del motivo de rechazo F16. DD_MRG_MOTIVO_RECHAZO_GASTO
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
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-5329';  -- Vble. usuario crear
    V_COUNT NUMBER(25);  -- Vble. para validar la existencia de los registros
    
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
 		   SET BORRADO = 1,
		       USUARIOBORRAR = '''||V_USUARIO||''',
		       FECHABORRAR = SYSDATE
		   WHERE DD_MRG_CODIGO = ''F16'' ';
        EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[FIN] Borrado motivo rechazo F16 ');
		
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
