--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210722
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14647
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Hace rollback del dml DML_00963_REM01_UPDATE_PRO_ID_GASTOS_ACTIVOS.sql
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
    V_USUARIO VARCHAR2(100 CHAR):='HREOS-14647_2'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_PRO_PROPIETARIO'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_BACK_ACTIVOS VARCHAR2(100 CHAR) :='HREOS_14647_BACKUP_ACTIVOS';
    V_TABLA_BACK_GASTOS VARCHAR2(100 CHAR) :='HREOS_14647_BACKUP_GASTOS';
    V_PRO_DOCIDENTIF VARCHAR2(100 CHAR):='A86201993';
    V_COUNT NUMBER(16):=0;
    V_PRO_ID NUMBER(16);
    TABLE_COUNT NUMBER(1,0) := 0;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION DE PROPIETARIO EN ACTIVOS Y GASTOS - ROLLBACK '); 


    DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos que exista el propietario con docidentif: '||V_PRO_DOCIDENTIF||' ');  

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_PRO_DOCIDENTIF||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN 

         DBMS_OUTPUT.PUT_LINE('[INFO]: Obtenemos id propietario con docidentif: '||V_PRO_DOCIDENTIF||' ');  

        V_MSQL :='SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_DOCIDENTIF='''||V_PRO_DOCIDENTIF||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_PRO_ID;

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_BACK_ACTIVOS||'' AND OWNER= ''||V_ESQUEMA||'';

        IF TABLE_COUNT > 0 THEN
            V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO T1 USING (
               SELECT DISTINCT BACK.PAC_ID, BACK.PAC_PRO_ID  FROM HREOS_14647_BACKUP_ACTIVOS BACK
            ) T2
            ON (T1.PAC_ID = T2.PAC_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.PRO_ID = T2.PAC_PRO_ID,
            T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
            T1.FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PAC_PROPIETARIO_ACTIVO');
        
        ELSE
             DBMS_OUTPUT.PUT_LINE('[ERROR]: NO EXISTE LA TABLA '||V_TABLA_BACK_ACTIVOS||' '); 
        END IF;

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA_BACK_GASTOS||'' AND OWNER= ''||V_ESQUEMA||'';

        IF TABLE_COUNT > 0 THEN

            V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING (
                    SELECT DISTINCT BACK.GPV_ID, BACK.PRO_ID  FROM HREOS_14647_BACKUP_GASTOS BACK
                ) T2
                ON (T1.GPV_ID = T2.GPV_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.PRO_ID = T2.PRO_ID,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN GPV_GASTOS_PROVEEDOR');
        
        ELSE
             DBMS_OUTPUT.PUT_LINE('[ERROR]: NO EXISTE LA TABLA '||V_TABLA_BACK_GASTOS||' '); 
        END IF;

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