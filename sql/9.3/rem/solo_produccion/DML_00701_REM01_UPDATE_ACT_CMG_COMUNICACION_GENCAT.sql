--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9080
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar fecha comunicación
--##			
--## INSTRUCCIONES:  
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
    V_ID NUMBER(16);
    V_COUNT NUMBER(16);
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9080'; -- USUARIOCREAR/USUARIOMODIFICAR.

    
BEGIN		
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 	
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR FECHA COMUNICACION GENCAT');

    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7272260';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID;

    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT WHERE ACT_ID = '||V_ID||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT SET
                    CMG_FECHA_COMUNICACION = TO_DATE(''10/12/2020'',''dd/MM/yyyy''),
                    USUARIOMODIFICAR = '''||V_USR||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = '||V_ID||' AND BORRADO = 0';      
        EXECUTE IMMEDIATE V_MSQL;           	
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: FECHA DE COMUNICACIÓN GENCAT CAMBIADA A ''10/12/2020''');
    
    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE COMUNICACIÓN PARA EL ACTIVO');

    END IF;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_MSG := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
