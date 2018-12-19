--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4574
--## PRODUCTO=NO
--## Finalidad:
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_ACTUALIZA_PERIMETRO (ACT_NUM_ACTIVO IN NUMBER DEFAULT NULL
                                   ,PAC_INCLUIDO IN NUMBER DEFAULT NULL) IS

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar
    
    BEGIN
	    DBMS_OUTPUT.PUT_LINE('[INICIO]');
        
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO
                    SET PAC_INCLUIDO  = '||PAC_INCLUIDO||'
                        ,USUARIOMODIFICAR = ''SP_EXT''
                        ,FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (
	                    SELECT ACT_ID 
	                    FROM ACT_ACTIVO 
	                    WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
	                    )
                  ';
        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[FIN]');
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

END SP_EXT_ACTUALIZA_PERIMETRO;

/
EXIT;