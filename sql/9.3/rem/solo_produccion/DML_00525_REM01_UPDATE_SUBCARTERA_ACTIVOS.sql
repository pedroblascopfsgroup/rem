--/*
--######################################### 
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201106
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8342
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR SUBCARTERA ACTIVOS
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8342'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar   
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS SUBCARTERA ACTIVOS');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING 
			(SELECT DISTINCT ACT_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO 
			WHERE ACT_NUM_ACTIVO IN (7226481,
			7226579,
			7228151,
			7228152,
			7228153,
			7228154,
			7288604,
			7288605,
			7288606,
			7292505,
			7292506,
			7293230,
			7293231,
			7293232,
			7293233,
			7297333,
			7297334,
			7297335,
			7297336,
			7297337,
			7297338,
			7297339,
			7297340,
			7297341,
			7297424,
			7297425,
			7297426,
			7297427,
			7297428,
			7297429,
			7297430,
			7297431,
			7297432,
			7297433,
			7297434,
			7297435,
			7297436,
			7297437,
			7297831,
			7298724,
			7299241,
			7299242,
			7300446,
			7301017,
			7301018,
			7301019,
			7302453,
			7302454,
			7302774,
			7302931,
			7328480,
			7328481,
			7385579) AND DD_SCR_ID = 343
			) T2 ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET 
		T1.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''140''),
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
		T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN ACT_ACTIVO: ' ||sql%rowcount);

        
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
EXIT
