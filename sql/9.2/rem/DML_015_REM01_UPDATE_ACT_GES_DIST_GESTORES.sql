--/*
--##########################################
--## AUTOR=Miguel Lopez
--## FECHA_CREACION=20190710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.15.0
--## INCIDENCIA_LINK=HREOS-7029
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar el cod_tipo_comercializacion de ACT_GES_DIST_GESTORES
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16) := 0; --Vble. para contar inserciones o updateos de los loops
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR):= 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-7029';
		
 BEGIN
 			  
 V_SQL :=  'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 				     COD_TIPO_COMERZIALZACION = ''2'',
             USUARIOMODIFICAR = '''||V_USUARIO||''',
             FECHAMODIFICAR = SYSDATE
 				     WHERE TIPO_GESTOR = ''HAYAGBOINM''
             AND (COD_CARTERA = ''6'' OR COD_CARTERA = ''10'' OR COD_CARTERA = ''11'' OR COD_CARTERA = ''12'' OR COD_CARTERA = ''13'' OR COD_CARTERA = ''15'')
             AND USERNAME = ''prodriguezg''
 				   ';
 				   
 EXECUTE IMMEDIATE V_SQL;
 
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han ACTUALUIZADO '||SQL%ROWCOUNT||' REGISTROS');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

