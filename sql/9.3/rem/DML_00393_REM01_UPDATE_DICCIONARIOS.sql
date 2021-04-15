--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8558
--## PRODUCTO=NO
--##
--## Finalidad: Borrado lógico en diccionarios DD_EEC_EST_EXP_COMERCIAL y DD_EOF_ESTADOS_OFERTA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
       
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#REMMASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'DD_OPM_OPERACION_MASIVA';
    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8558';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = 999 AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN 	
            
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL
                    SET BORRADO = 1,
                    USUARIOBORRAR = '''||V_USUARIO||''', 
                    FECHABORRAR = SYSDATE 
                    WHERE DD_EEC_CODIGO = 999';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LÓGICO APLICADO CORRECTAMENTE EN LA TABLA DD_EEC_EST_EXP_COMERCIAL PARA "999 - DATOS ERRÓNEOS" ');
				
	ELSE

        DBMS_OUTPUT.PUT_LINE('EL REGISTRO NO EXISTE O HA SIDO BORRADO');

    END IF;

    V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = 999 AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN 	
            
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA
                    SET BORRADO = 1,
                    USUARIOBORRAR = '''||V_USUARIO||''', 
                    FECHABORRAR = SYSDATE 
                    WHERE DD_EOF_CODIGO = 999';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LÓGICO APLICADO CORRECTAMENTE EN LA TABLA DD_EOF_ESTADOS_OFERTA PARA "999 - ANULADA RC"  ');
				
	ELSE

        DBMS_OUTPUT.PUT_LINE('EL REGISTRO NO EXISTE O HA SIDO BORRADO');

    END IF;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] ');
    
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