--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-4895
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4895'; -- Vble. para el usuario modificar.
    V_COUNT NUMBER(16):= 0; -- Vble. para el contador de activos modificados.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
   
    CURSOR ACTIVOS IS 
        SELECT ACT_ID FROM REM01.ACT_ACTIVO ACT
        JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        WHERE DD_SCM_CODIGO = '10';
        
    FILA ACTIVOS%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    OPEN ACTIVOS;
    V_COUNT := 0;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET DD_SCM_ID = NULL
				WHERE DD_SCM_ID = (
					SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM WHERE DD_SCM_CODIGO = ''10''
				)';
	EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'CALL '||V_ESQUEMA||'.SP_ASC_ACT_SIT_COM_VACIOS_V2 (0)';
    EXECUTE IMMEDIATE V_MSQL;
    
    LOOP
        FETCH ACTIVOS INTO FILA;
        EXIT WHEN ACTIVOS%NOTFOUND;

		V_MSQL := 'CALL '||V_ESQUEMA||'.SP_CAMBIO_ESTADO_PUBLICACION ('||FILA.ACT_ID||', 1, '''||V_USUARIOMODIFICAR||''')';
		EXECUTE IMMEDIATE V_MSQL;
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE(' [INFO] Se han actualizado las situaciones comerciales y los estados de publicación de '||V_COUNT||' activos');
    CLOSE ACTIVOS;

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
END;
/
EXIT;
