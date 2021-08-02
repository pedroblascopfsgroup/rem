--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210722
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14647
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualiza propietarios
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
    V_USUARIO VARCHAR2(100 CHAR):='HREOS-14647'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_BACK_ACTIVOS VARCHAR2(100 CHAR) :='HREOS_14647_BACKUP_ACTIVOS';
    V_TABLA_BACK_GASTOS VARCHAR2(100 CHAR) :='HREOS_14647_BACKUP_GASTOS';
    V_PRO_DOCIDENTIF VARCHAR2(100 CHAR):='A93139053';
    V_COUNT NUMBER(16):=0;
    V_PRO_ID NUMBER(16);
    TABLE_COUNT NUMBER(1,0) := 0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION DE PROPIETARIO EN ACTIVOS Y GASTOS '); 


    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos que exista el propietario con docidentif: '||V_PRO_DOCIDENTIF||' ');  

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_PRO_DOCIDENTIF||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN 

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_BACK_ACTIVOS||'' AND OWNER= ''||V_ESQUEMA||'';

        IF TABLE_COUNT > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA_BACK_ACTIVOS||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_BACK_ACTIVOS||'';
        
        END IF;

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_BACK_GASTOS||'' AND OWNER= ''||V_ESQUEMA||'';

        IF TABLE_COUNT > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA_BACK_GASTOS||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_BACK_GASTOS||'';
        
        END IF;

--#####################################BACKUP###############################################################################################
        DBMS_OUTPUT.PUT_LINE('[INFO]: Realizando backup de activos... '); 

        V_MSQL :='CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_BACK_ACTIVOS||' AS
        (
            SELECT DISTINCT ACT.ACT_ID,ACT.ACT_NUM_ACTIVO,ACT.ACT_NUM_ACTIVO_REM,ACT.ACT_NUM_ACTIVO_PRINEX,ACT.DD_CRA_ID,
            PAC.PAC_ID,PAC.PRO_ID AS PAC_PRO_ID,PAC.DD_TGP_ID AS PAC_DD_TGP_ID,PAC.PAC_PORC_PROPIEDAD,
            PAC.USUARIOMODIFICAR AS PAC_USUARIOMODIFICAR,PAC.FECHAMODIFICAR AS PAC_FECHAMODIFICAR
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=PAC.PRO_ID
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID
            WHERE ACT.BORRADO = 0 AND PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF=''A86201993'' AND CRA.DD_CRA_CODIGO=''08''
        )
        ';
        EXECUTE IMMEDIATE V_MSQL;                           

        DBMS_OUTPUT.PUT_LINE('[INFO]: Backup activos correcto!! en - '||V_TABLA_BACK_ACTIVOS||' ');  


        DBMS_OUTPUT.PUT_LINE('[INFO]: Realizando backup de gastos... '); 

        V_MSQL :='CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_BACK_GASTOS||' AS
        (
            SELECT DISTINCT GPV.GPV_ID,GPV.GPV_NUM_GASTO_HAYA,GPV.GPV_NUM_GASTO_GESTORIA,GPV.PRO_ID,
            GPV.USUARIOMODIFICAR AS GPV_USUARIOMODIFICAR, GPV.FECHAMODIFICAR AS GPV_FECHAMODIFICAR 
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID=GPV.DD_EGA_ID
            WHERE GPV.BORRADO = 0 AND PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF=''A86201993'' AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''13'')
        )
        ';
        EXECUTE IMMEDIATE V_MSQL;                           

        DBMS_OUTPUT.PUT_LINE('[INFO]: Backup gastos correcto!! en - '||V_TABLA_BACK_GASTOS||' '); 

--#############################################################################################################################################

        DBMS_OUTPUT.PUT_LINE('[INFO]: Obtenemos id propietario con docidentif: '||V_PRO_DOCIDENTIF||' ');  

        V_MSQL :='SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_PRO_DOCIDENTIF||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_PRO_ID;

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO T1 USING (
                    SELECT DISTINCT PAC.PAC_ID
                    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=PAC.PRO_ID
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID
                    WHERE ACT.BORRADO = 0 AND PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF=''A86201993'' AND CRA.DD_CRA_CODIGO=''08''
                ) T2
                ON (T1.PAC_ID = T2.PAC_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.PRO_ID = '||V_PRO_ID||',
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PAC_PROPIETARIO_ACTIVO');


        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING (
                    SELECT DISTINCT GPV.GPV_ID
                    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID
                    JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID=GPV.DD_EGA_ID
                    WHERE GPV.BORRADO = 0 AND PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF=''A86201993'' AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''13'')
                ) T2
                ON (T1.GPV_ID = T2.GPV_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.PRO_ID = '||V_PRO_ID||',
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN GPV_GASTOS_PROVEEDOR');


        DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizaciones del propietario en gastos y activos correcta');

    ELSE
        DBMS_OUTPUT.PUT_LINE('[ERROR]: NO EXISTE EL PROPIETARIO: '||V_PRO_DOCIDENTIF||' ');  
    END IF;    

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