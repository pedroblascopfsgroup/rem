--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9925
--## PRODUCTO=NO
--##
--## Finalidad: Modificar estado trabajos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-9925';
	V_NUM NUMBER;
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET
			    TBJ_FECHA_VALIDACION = TO_DATE(TO_CHAR(SYSDATE,''DD/MM/YYYY''),''DD/MM/YYYY''),
                TBJ_FECHA_CAMBIO_ESTADO = TO_DATE(TO_CHAR(SYSDATE,''DD/MM/YYYY''),''DD/MM/YYYY''),
			    USUARIOMODIFICAR = '''||V_ITEM||''',
			    FECHAMODIFICAR = SYSDATE
				WHERE TBJ_NUM_TRABAJO = 924567867946';
	    
	EXECUTE IMMEDIATE V_MSQL;
	
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
EXIT;