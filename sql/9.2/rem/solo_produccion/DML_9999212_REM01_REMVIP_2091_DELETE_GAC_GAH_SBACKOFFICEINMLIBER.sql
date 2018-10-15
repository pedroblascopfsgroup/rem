--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20180927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2091
--## PRODUCTO=NO
--##
--## Finalidad: Borrar gestores duplicados SBACKOFFICEINMLIBER
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
    V_TABLA_ACT VARCHAR2(25 CHAR):= 'GAC_GESTOR_ADD_ACTIVO';
    V_TABLA_ECO VARCHAR2(25 CHAR):= 'GAC_GESTOR_ADD_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2091';    
    
BEGIN	
	
	--QUITAR FECHA VENTA EXPEDIENTE

	V_SQL := 'DELETE REM01.GAC_GESTOR_ADD_ACTIVO WHERE GEE_ID 
              IN (
                  select GAC.GEE_ID
                  from '||V_ESQUEMA||'.ACT_ACTIVO act 
                  JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID 
                  join '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE on GEE.GEE_ID = GAC.GEE_ID
                  JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
                  join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = gee.usu_id
                  WHERE TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER''  AND ACT.ACT_NUM_ACTIVO IN (6860471,
                  6856216,
                  6884929,
                  7004881,
                  6874618,
                  7008331,
                  6949291,
                  6860820,
                  7012802,
                  6860470,
                  7007885,
                  6862518,
                  6850212,
                  6857623,
                  6848228,
                  6961611,
                  6874954,
                  6857101,
                  6852998,
                  7012801,
                  6857620,
                  7012797,
                  6873704,
                  7012804,
                  6860587,
                  6874955,
                  6860635,
                  6861438,
                  6875266,
                  7012798,
                  6825527,
                  6935975,
                  7008352,
                  6860634,
                  6885305,
                  6825706
                  )
              AND USU.USU_USERNAME = ''lmarcos''
               )
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se han borrado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_ACT);

	--PONER ESTADO ACTIVO A DISPONIBLE VENTA

	V_SQL := 'DELETE REM01.GAH_GESTOR_ACTIVO_HISTORICO WHERE GEH_ID 
              IN (
                select GAH.GEH_ID
                from '||V_ESQUEMA||'.ACT_ACTIVO act 
                JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID 
                join '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH on GEH.GEH_ID = GAH.GEH_ID
                JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEH.DD_TGE_ID
                join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = GEH.usu_id
                WHERE TGE.DD_TGE_CODIGO = ''SBACKOFFICEINMLIBER''  AND ACT.ACT_NUM_ACTIVO IN (6860471,
                6856216,
                6884929,
                7004881,
                6874618,
                7008331,
                6949291,
                6860820,
                7012802,
                6860470,
                7007885,
                6862518,
                6850212,
                6857623,
                6848228,
                6961611,
                6874954,
                6857101,
                6852998,
                7012801,
                6857620,
                7012797,
                6873704,
                7012804,
                6860587,
                6874955,
                6860635,
                6861438,
                6875266,
                7012798,
                6825527,
                6935975,
                7008352,
                6860634,
                6885305,
                6825706
                )
              AND GEH.GEH_FECHA_HASTA is null
              AND USU.USU_USERNAME = ''lmarcos'')';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_ECO);
	   
        COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

