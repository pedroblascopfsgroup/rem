--/*
--##########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20181022
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2153
--## PRODUCTO=NO
--##
--## Finalidad: Borrado lógico de varios trabajo
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(50 CHAR) := 'ACT_TBJ_TRABAJO';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-2153';
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ENTIDAD_ID NUMBER(16);

BEGIN	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' TBJ SET TBJ.BORRADO = 1, TBJ.USUARIOBORRAR = '''||V_USUARIO||''', TBJ.FECHABORRAR = SYSDATE
			   WHERE TBJ.TBJ_NUM_TRABAJO IN (9000112260, 9000112258, 9000112253)';
				
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TABLA);
	


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
  	
