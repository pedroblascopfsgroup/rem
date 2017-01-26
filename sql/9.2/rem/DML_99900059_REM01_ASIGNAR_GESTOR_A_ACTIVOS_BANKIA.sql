--/*
--###########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20170126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1432
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar los siguientes usuarios-gestores a todos los activos.
--##			GRUGCCBANKIA - Grupo Gestor Capa Control Bankia.
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

  -- IDs usuario.
  USU_ID_GRUGCCBANKIA NUMBER(16);

 -- IDs tipo gestor.
  TGE_ID_GCCBANKIA NUMBER(16);

 -- ID nuevo para insertar.
  SEQ_NEW_ID NUMBER(16);

   CURSOR ACTIVOS IS
   	SELECT ACT.ACT_ID FROM ACT_ACTIVO ACT
	INNER JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
	WHERE CRA.DD_CRA_CODIGO ='03';

   ACTIVO ACTIVOS%ROWTYPE;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza asignación del gestor a todos los activos de bankia');
	EXECUTE IMMEDIATE 'SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''GRUGCCBANKIA''' INTO USU_ID_GRUGCCBANKIA;
	EXECUTE IMMEDIATE 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCCBANKIA''' INTO TGE_ID_GCCBANKIA;

	OPEN ACTIVOS;

    FETCH ACTIVOS INTO ACTIVO;

    WHILE ACTIVOS%FOUND

    LOOP
    	DBMS_OUTPUT.PUT_LINE('MODIFICANDO GESTOR ACTIVO ' || ACTIVO.ACT_ID);

    -- Insertar USU_ID_GRUGCCBANKIA / TGE_ID_GCCBANKIA.
    	SELECT S_GEE_GESTOR_ENTIDAD.NEXTVAL INTO SEQ_NEW_ID FROM DUAL;

    	EXECUTE IMMEDIATE'
			INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
			(GEE_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR, BORRADO
			)VALUES(
			'||SEQ_NEW_ID||', '||USU_ID_GRUGCCBANKIA||', '||TGE_ID_GCCBANKIA||', ''REM'', SYSDATE, 0)';

		EXECUTE IMMEDIATE'	
			INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
			(GEE_ID, ACT_ID
			) VALUES ( '||SEQ_NEW_ID||', '||ACTIVO.ACT_ID||') ';

		SELECT S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL INTO SEQ_NEW_ID FROM DUAL;

		EXECUTE IMMEDIATE'	
			INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
			(GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, USUARIOCREAR, FECHACREAR, BORRADO
			)VALUES(
			'||SEQ_NEW_ID||', '||USU_ID_GRUGCCBANKIA||', '||TGE_ID_GCCBANKIA||', SYSDATE, ''REM'', SYSDATE, 0)';

		EXECUTE IMMEDIATE'	
			INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
			(GEH_ID, ACT_ID
			) VALUES ( '||SEQ_NEW_ID||', '||ACTIVO.ACT_ID||') ';


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
