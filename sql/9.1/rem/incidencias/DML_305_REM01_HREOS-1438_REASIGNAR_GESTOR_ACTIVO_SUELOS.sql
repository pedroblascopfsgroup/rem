--/*
--###########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=24/01/2017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-1438
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar gestor de activo a todos los activos de tipo suelo a jbadia
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
   USU_ID_NUEVO NUMBER(16);
   GEH_ID_NUEVO NUMBER(16);
   TGE_ID_GACT NUMBER(16);
   CURSOR ACTIVOS IS
   	SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT
	INNER JOIN DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
	WHERE TPA.DD_TPA_CODIGO ='01';

   ACTIVO ACTIVOS%ROWTYPE;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO PARA LA RE-ASIGNACIÓN DE GESTOR DE ACTIVOS PARA ');
	DBMS_OUTPUT.PUT_LINE('         ACTIVOS DE TIPO SUELO');
	EXECUTE IMMEDIATE 'SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''jbadia''' INTO USU_ID_NUEVO;
	EXECUTE IMMEDIATE 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GACT''' INTO TGE_ID_GACT;

	OPEN ACTIVOS;

    FETCH ACTIVOS INTO ACTIVO;

    WHILE ACTIVOS%FOUND

    LOOP
    	EXECUTE IMMEDIATE'
			UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE SET
			GEE.USU_ID = '||USU_ID_NUEVO||',
			GEE.USUARIOMODIFICAR = ''HREOS-1438'',
			GEE.FECHAMODIFICAR = SYSDATE
			WHERE GEE.GEE_ID = (SELECT GEE2.GEE_ID FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
			  	INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GAC.GEE_ID
			  	INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE2.DD_TGE_ID
			  	WHERE TGE.DD_TGE_CODIGO = ''GACT'' AND GAC.ACT_ID = '||ACTIVO.ACT_ID||')';
			
		EXECUTE IMMEDIATE'	
			UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH SET
			GEH.GEH_FECHA_HASTA = SYSDATE,
			GEH.USUARIOMODIFICAR = ''HREOS-1438'',
			GEH.FECHAMODIFICAR = SYSDATE
			WHERE GEH.GEH_ID = (SELECT GEH2.GEH_ID FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
				INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH2 ON GEH2.GEH_ID = GAH.GEH_ID
				INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEH2.DD_TGE_ID
				WHERE GEH2.GEH_FECHA_HASTA IS NULL AND TGE.DD_TGE_CODIGO = ''GACT'' AND GAH.ACT_ID ='||ACTIVO.ACT_ID||')';
				
		SELECT S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL INTO GEH_ID_NUEVO FROM DUAL;
    
		EXECUTE IMMEDIATE'	
			INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
			(GEH_ID,
			USU_ID,
			DD_TGE_ID,
			GEH_FECHA_DESDE,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO
			)VALUES(
			'||GEH_ID_NUEVO||',
			'||USU_ID_NUEVO||',
			'||TGE_ID_GACT||',
			SYSDATE,
			''HREOS-1438'',
			SYSDATE,
			0)
		';
		
		EXECUTE IMMEDIATE'	
			INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
			(GEH_ID,
			ACT_ID
			) VALUES (
			'||GEH_ID_NUEVO||',
			'||ACTIVO.ACT_ID||')
		';
		
        FETCH ACTIVOS INTO ACTIVO;

    END LOOP;
    
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]  PROCESO FINALIZADO CORRECTAMENTE. SE HAN ACTUALIZADO ' || ACTIVOS%ROWCOUNT || ' ACTIVOS');
 
    CLOSE ACTIVOS;
	
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
