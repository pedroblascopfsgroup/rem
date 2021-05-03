--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8367
--## PRODUCTO=NO
--##
--## Finalidad: Modificar validación carga masiva
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8367';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_COUNT NUMBER(16); --Vble para comprobar si existe registro con el codigo

    V_VALIDACION VARCHAR2(256 CHAR):= 'n*,s,f,i,i,s,s';
    V_OPM_COD VARCHAR2(256 CHAR):= 'SIMP';

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL:='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_OPM_CODIGO = '''||V_OPM_COD||''' AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN 	
            
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET DD_OPM_VALIDACION_FORMATO = '''||V_VALIDACION||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE 
                    WHERE DD_OPM_CODIGO = '''||V_OPM_COD||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO CORRECTAMENTE VALIDACION DE CARGA MASIVA '''||V_OPM_COD||''' ');
				
	ELSE

        DBMS_OUTPUT.PUT_LINE('LA OPERACION MASIVA CON CODIGO '''||V_OPM_COD||''' NO EXISTE O HA SIDO BORRADA');

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
