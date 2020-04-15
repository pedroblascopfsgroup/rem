--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6933
--## PRODUCTO=NO
--##
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
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6933';


 BEGIN

    	V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_CDU_CESION_USO
					SET	DD_CDU_DESCRIPCION = ''Cesión Ayto/Generalitat CX''
                    ,   DD_CDU_DESCRIPCION_LARGA = ''Cesión Ayto/Generalitat CX''
                    ,   USUARIOMODIFICAR = '''||V_USUARIO||'''
                    , 	FECHAMODIFICAR = SYSDATE
                WHERE DD_CDU_CODIGO = ''02'' ';

      EXECUTE IMMEDIATE V_SQL;

	  DBMS_OUTPUT.PUT_LINE('Se borrado el registro correctamente');

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