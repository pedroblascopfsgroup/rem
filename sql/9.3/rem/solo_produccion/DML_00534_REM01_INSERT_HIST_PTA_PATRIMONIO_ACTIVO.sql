--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8360
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar histórico patrimonio
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8360'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_8360';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);	

    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERTANDO HIST_PTA_PATRIMONIO_ACTIVO ');	

    -- Selecciona todos los ACT_ID de la tabla auxiliar
    V_SQL := ' SELECT DISTINCT ACT.ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
        '||V_ESQUEMA||'.AUX_REMVIP_8360 AUX
        WHERE AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
        AND ACT.BORRADO = 0 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_COUNT := 0;
   
   	LOOP

        FETCH v_cursor INTO V_ID;
        EXIT WHEN v_cursor%NOTFOUND;
    
        V_MSQL := ' INSERT INTO '|| V_ESQUEMA ||'.HIST_PTA_PATRIMONIO_ACTIVO 
        (HIST_PTA_ID, ACT_ID, CHECK_HPM, FECHA_INI_ADA, FECHA_FIN_ADA, FECHA_INI_HPM, FECHA_FIN_HPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_EAL_ID)
        VALUES (
            '|| V_ESQUEMA ||'.S_HIST_PTA_PATRIMONIO_ACTIVO.NEXTVAL,
            '''|| V_ID ||''',
            1,
            TO_DATE(SYSDATE, ''DD/MM/YY''),
            TO_DATE(SYSDATE, ''DD/MM/YY''),
            TO_DATE(SYSDATE, ''DD/MM/YY''),
            TO_DATE(SYSDATE, ''DD/MM/YY''),
            0,
            ''' || V_USR || ''',	
            SYSDATE,
            0,
            2
        ) ';

        EXECUTE IMMEDIATE V_MSQL;
        
        V_COUNT := V_COUNT + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se han insertado '|| V_COUNT ||' registros en HIST_PTA_PATRIMONIO_ACTIVO ');	

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
