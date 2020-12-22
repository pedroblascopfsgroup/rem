--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8557
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Informar ID DIVARIAN
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
    V_COUNT NUMBER(16);
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8557'; --Vble. auxiliar para almacenar el usuario
    V_ID NUMBER(16);
    V_USU_CREAR VARCHAR2(100 CHAR):='REMVIP-8257'; --Vble. auxiliar para almacenar el usuario

    TYPE CURTYP IS REF CURSOR;
	V_CURSOR    CURTYP;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_SQL := ' SELECT ACT_ID
        FROM '||V_ESQUEMA||'.ACT_ACTIVO
        WHERE USUARIOCREAR = '''||V_USU_CREAR||'''
        AND BORRADO = 0 ' ;

	OPEN V_CURSOR FOR V_SQL;
   
   	V_COUNT := 1;
   
   	LOOP

        FETCH V_CURSOR INTO V_ID;
        EXIT WHEN V_CURSOR%NOTFOUND;
    
        V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_ACTIVO SET 
                    ACT_NUM_ACTIVO_DIVARIAN =  ''58634F/'||V_COUNT||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = '||V_ID||'';

        EXECUTE IMMEDIATE V_MSQL;
        
        V_COUNT := V_COUNT + 1;

   	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||V_COUNT-1||' ACTIVOS');

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