--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4888
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

    PL_OUTPUT VARCHAR2(32000 CHAR);   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-4888'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_NUM NUMBER(25);	
        

    
BEGIN	

-------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrando activos');

        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando 161272 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = -888161272,
		       BORRADO = 1,
		       FECHABORRAR = SYSDATE,
		       USUARIOBORRAR = ''' || V_USUARIO || '''
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = 161272
		   AND ACT_NUM_ACTIVO_SAREB = ''555376'' 
		   AND BORRADO = 0 ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro '); 

        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando 107744 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = -888107744,
		       BORRADO = 1,
		       FECHABORRAR = SYSDATE,
		       USUARIOBORRAR = ''' || V_USUARIO || '''
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = 107744
		   AND ACT_NUM_ACTIVO_SAREB = ''642994'' 
		   AND BORRADO = 0 ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro '); 

        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando 161779 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = -888161779,
		       BORRADO = 1,
		       FECHABORRAR = SYSDATE,
		       USUARIOBORRAR = ''' || V_USUARIO || '''
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = 161779
		   AND ACT_NUM_ACTIVO_SAREB = ''549490'' 
		   AND BORRADO = 0 ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro ');

--------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Deshaciendo borrado');

        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando -161272 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = 161272,
		       BORRADO = 0,
		       FECHABORRAR = NULL,
		       USUARIOBORRAR = NULL
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = -161272
		   AND ACT_NUM_ACTIVO_SAREB = ''555376'' ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro '); 


        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando -107744 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = 107744,
		       BORRADO = 0,
		       FECHABORRAR = NULL,
		       USUARIOBORRAR = NULL
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = -107744
		   AND ACT_NUM_ACTIVO_SAREB = ''642994'' ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro '); 
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Modificando -161779 ' );

	V_SQL := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
		   SET ACT_NUM_ACTIVO = 161779,
		       BORRADO = 0,
		       FECHABORRAR = NULL,
		       USUARIOBORRAR = NULL
		   WHERE 1 = 1
		   AND ACT_NUM_ACTIVO = -161779
		   AND ACT_NUM_ACTIVO_SAREB = ''549490'' ';
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registro '); 


	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso realizado ');
	
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
