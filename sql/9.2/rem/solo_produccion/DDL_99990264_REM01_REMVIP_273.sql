--/*
--##########################################
--## AUTOR=VICENTE MARTINEZ 
--## FECHA_CREACION=20180313
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-273
--## PRODUCTO=NO
--##
--## Finalidad: Avanzar trámite
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
    --V_TABLA VARCHAR2(25 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
	--V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-172';
    
    --ACT_NUM_ACTIVO NUMBER(16);
    
 BEGIN

    V_SQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU ZON SET
		    USUARIOMODIFICAR = ''REMVIP-273'', 
		    FECHAMODIFICAR = SYSDATE, 
		    USUARIOBORRAR = NULL, 
		    FECHABORRAR = NULL, 
		    BORRADO = 0
		WHERE ZON.ZPU_ID = (select zonpef.ZPU_ID from '||V_ESQUEMA_M||'.USU_USUARIOS usu
		 join '||V_ESQUEMA||'.ZON_PEF_USU zonpef on usu.USU_ID = zonpef.USU_ID
		 join '||V_ESQUEMA||'.PEF_PERFILES pef on zonpef.PEF_ID = pef.PEF_ID
		 join '||V_ESQUEMA||'.FUN_PEF funpef on pef.PEF_ID = funpef.PEF_ID
		 join '||V_ESQUEMA_M||'.FUN_FUNCIONES fun on funpef.FUN_ID = fun.FUN_ID
		 where fun.FUN_DESCRIPCION = ''TAB_COMPRADORES_EXP_DETALLES_COMPRADOR'' and usu.USU_USERNAME= ''tpg'')
    ';

    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('Registro modificado correctamente');
  
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
