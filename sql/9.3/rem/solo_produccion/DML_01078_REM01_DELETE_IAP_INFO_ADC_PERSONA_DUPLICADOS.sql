--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20211109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10722
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10722'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_COUNT NUMBER(16);
			
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado duplicados en IAP_INFO_ADC_PERSONA.ID_PERSONA_HAYA');

        V_MSQL:='SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_IAP_DUPLICADOS''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT > 0 THEN
                V_MSQL:='DROP TABLE AUX_IAP_DUPLICADOS';
                EXECUTE IMMEDIATE V_MSQL;
        END IF;

        V_MSQL:='CREATE TABLE AUX_IAP_DUPLICADOS AS 
                SELECT DUP.IAP_ID, IAP.ID_PERSONA_HAYA, CLC.CLC_ID, CLC_REP.CLC_ID AS CLC_REP_ID, TIA.TIA_ID, TIA_REP.TIA_ID AS TIA_REP_ID
                        ,IOC.IOC_ID, PVE.PVE_ID, COM.COM_ID, CEX.COM_ID AS COM_CEX_ID, CEX.ECO_ID
                FROM '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA IAP
                LEFT JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.IAP_ID = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC_REP ON CLC_REP.IAP_ID_REP = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES TIA ON TIA.IAP_ID = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES TIA_REP ON TIA.IAP_ID_REP = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.IOC_INTERLOCUTOR_PBC_CAIXA IOC ON IOC.IAP_ID = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.IAP_ID = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.IAP_ID = IAP.IAP_ID
                LEFT JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.IAP_REPR_ID = IAP.IAP_ID
                JOIN (
                        SELECT RN.IAP_ID, IAP.ID_PERSONA_HAYA 
                        FROM (
                        SELECT ID_PERSONA_HAYA, COUNT(ID_PERSONA_HAYA) FROM '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA WHERE BORRADO = 0 GROUP BY ID_PERSONA_HAYA HAVING COUNT(ID_PERSONA_HAYA) > 1
                        ) IAP
                        JOIN (
                        SELECT ROW_NUMBER() OVER (PARTITION BY ID_PERSONA_HAYA ORDER BY IAP_ID ASC) RN, IAP_ID, ID_PERSONA_HAYA
                        FROM '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA
                        ) RN ON IAP.ID_PERSONA_HAYA = RN.ID_PERSONA_HAYA
                        WHERE RN.RN = 1
                ) DUP ON DUP.ID_PERSONA_HAYA = IAP.ID_PERSONA_HAYA';
        EXECUTE IMMEDIATE V_MSQL;


        -- CLIENTES 

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.CLC_ID = T2.CLC_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- REPRESENTANTES CLIENTES 

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.CLC_ID = T2.CLC_REP_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID_REP = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- TITULARES 

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.TIA_ID = T2.TIA_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- REPRESENTANTES TITULARES 

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.OFR_TIA_TITULARES_ADICIONALES T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.TIA_ID = T2.TIA_REP_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID_REP = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- INTERLOCUTORES CAIXA 

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.IOC_INTERLOCUTOR_PBC_CAIXA T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.IOC_ID = T2.IOC_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- PROVEEDORES

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.PVE_ID = T2.PVE_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- COMPRADORES

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.COM_COMPRADOR T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.COM_ID = T2.COM_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- REPRESENTANTES COMPRADORES

        V_MSQL:='MERGE INTO '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE T1
                USING (
                SELECT * FROM AUX_IAP_DUPLICADOS
                ) T2 ON (T1.COM_ID = T2.COM_CEX_ID AND T1.ECO_ID = T2.ECO_ID)
                WHEN MATCHED THEN UPDATE
                SET T1.IAP_REPR_ID = T2.IAP_ID
                ,T1.USUARIOMODIFICAR = '''||V_USU||'''
                ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
        -- BORRADO IAP_INFO_ADC_PERSONA

        V_MSQL:='UPDATE '||V_ESQUEMA||'.IAP_INFO_ADC_PERSONA IAP
                SET USUARIOBORRAR = '''||V_USU||'''
                ,FECHABORRAR = SYSDATE
                ,BORRADO = 1
                WHERE EXISTS (
                SELECT * FROM AUX_IAP_DUPLICADOS AUX 
                WHERE AUX.ID_PERSONA_HAYA = IAP.ID_PERSONA_HAYA AND IAP.IAP_ID <> AUX.IAP_ID
                )';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' registros borrados');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

        WHEN OTHERS THEN
                err_num := SQLCODE;
                err_msg := SQLERRM;

                DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
                DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
                DBMS_OUTPUT.put_line(err_msg);

                ROLLBACK;
                RAISE;          

END;
/
EXIT