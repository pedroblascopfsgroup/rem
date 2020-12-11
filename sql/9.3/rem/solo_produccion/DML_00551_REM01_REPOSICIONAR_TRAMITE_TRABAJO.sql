--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8408
--## PRODUCTO=NO
--## 
--## Finalidad:
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 char);
    
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-8408';
    OFR_NUM_OFERTA NUMBER(16);
    TAP_CODIGO VARCHAR2(50 CHAR);
    ECO_NUM_EXPEDIENTE NUMBER(16);
    TRA_ID NUMBER(16);
    TBJ_NUM_TRABAJO NUMBER(16):=9000074172;
    V_TABLA_TRAMITE VARCHAR2(100):='ACT_TRA_TRAMITE';
    V_TABLA_TRABAJO VARCHAR2(100):='ACT_TBJ_TRABAJO';

	
BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');

        V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' WHERE TBJ_NUM_TRABAJO='||TBJ_NUM_TRABAJO||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
               
                 V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_TRAMITE||' TRA
                JOIN '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' TBJ ON TBJ.TBJ_ID=TRA.TBJ_ID
                WHERE tbj.tbj_num_trabajo='||TBJ_NUM_TRABAJO||' AND TRA.BORRADO=1';

                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS > 0 THEN

                 V_MSQL:='SELECT TRA.TRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TRAMITE||' TRA
                JOIN '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' TBJ ON TBJ.TBJ_ID=TRA.TBJ_ID
                WHERE tbj.tbj_num_trabajo='||TBJ_NUM_TRABAJO||' AND TRA.BORRADO=1';

                EXECUTE IMMEDIATE V_MSQL INTO TRA_ID;

                    V_MSQL:='UPDATE '||V_ESQUEMA||'.'||V_TABLA_TRAMITE||' SET
                    BORRADO=0,
                    USUARIOMODIFICAR='''||V_USUARIO||''',
                    FECHAMODIFICAR=SYSDATE
                    WHERE TRA_ID='||TRA_ID||' AND BORRADO=1';

                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.put_line('[INFO] Modificado tramite correctamente');
                    #ESQUEMA#.REPOSICIONAMIENTO_TRABAJO(V_USUARIO,TBJ_NUM_TRABAJO,'T002_CierreEconomico');
                    DBMS_OUTPUT.put_line('[INFO] Trabajo reposicionado correctamente');

                    #ESQUEMA#.ALTA_BPM_INSTANCES(V_USUARIO, PL_OUTPUT);
                ELSE
                    DBMS_OUTPUT.put_line('[INFO] NO SE HAN ENCONTRADO TRAMITES BORRADOS PARA ESE TRABAJO');
                END IF;
        ELSE
            DBMS_OUTPUT.put_line('[INFO] NO SE HA ENCONTRADO EL TRABAJO CON NUMERO TRABAJO:'||TBJ_NUM_TRABAJO||'');
        END IF; 

	COMMIT;
 DBMS_OUTPUT.put_line('[FIN]');
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