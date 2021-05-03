--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13839
--## PRODUCTO=NO
--## Finalidad: Procedimiento almacenado que realiza el cambio de oficinas en Bankia
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-12758
--##        0.2 Resolución de dudas, cambios - HREOS-13241
--##        0.3 Cierre Oficinas Bankia. Traspaso de Negocio - HREOS-13610
--##        0.4 Se trunca la tabla auxiliar al principio del proceso
--##        0.5 Se quita el truncado de la tabla auxiliar -  HREOS-13822
--##        0.5 Se cambia el INSERT de la tabla auxiliar -  HREOS-13839
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_CAMBIO_OFICINA_BANKIA (
    V_USUARIO       VARCHAR2 DEFAULT 'SP_CAMBIO_OFICINA_BANKIA',
    PL_OUTPUT       OUT VARCHAR2,
    PVE_COD_API_PROVEEDOR_ANTIGUA  IN REM01.ACT_PVE_PROVEEDOR.PVE_COD_API_PROVEEDOR%TYPE,
    PVE_COD_API_PROVEEDOR_NUEVA  IN REM01.ACT_PVE_PROVEEDOR.PVE_COD_API_PROVEEDOR%TYPE) AS
--  0.4

    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR);
    V_COUNT_OFICINA_ANTIGUA NUMBER(16);
    V_COUNT_OFICINA_NUEVA NUMBER(16);
    V_OFICINA_ANTIGUA NUMBER(16);
    V_OFICINA_NUEVA NUMBER(16);
    V_TEXT_TABLA_AUX VARCHAR2(1024 CHAR):= 'ENVIO_CIERRE_OFICINAS_BANKIA';

BEGIN
        PL_OUTPUT := '[INICIO]'||CHR(10);
        
    
        --------------------------------------------------------------------
        ----------- COMPROBACIONES PREVIAS --------------------------------
        --------------------------------------------------------------------
    
        V_SQL := 'SELECT COUNT(PVE.PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
        LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
        WHERE TPR.DD_TPR_CODIGO = ''28'' AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.BORRADO = 0 AND PVE.PVE_COD_API_PROVEEDOR = '''||PVE_COD_API_PROVEEDOR_ANTIGUA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT_OFICINA_ANTIGUA;
        
        IF V_COUNT_OFICINA_ANTIGUA > 0 THEN
            V_MSQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
            WHERE TPR.DD_TPR_CODIGO = ''28'' AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.BORRADO = 0 AND PVE.PVE_COD_API_PROVEEDOR = '''||PVE_COD_API_PROVEEDOR_ANTIGUA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_OFICINA_ANTIGUA;

            V_SQL := 'SELECT COUNT(PVE.PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
            WHERE TPR.DD_TPR_CODIGO = ''28'' AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.BORRADO = 0 AND PVE.PVE_COD_API_PROVEEDOR = '''||PVE_COD_API_PROVEEDOR_NUEVA||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_COUNT_OFICINA_NUEVA;
            
            IF V_COUNT_OFICINA_NUEVA > 0 THEN 
                V_MSQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
                WHERE TPR.DD_TPR_CODIGO = ''28'' AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.PVE_FECHA_BAJA IS NULL AND PVE.BORRADO = 0 AND PVE.PVE_COD_API_PROVEEDOR = '''||PVE_COD_API_PROVEEDOR_NUEVA||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_OFICINA_NUEVA;


        --------------------------------------------------------------------
        ----------- DAR DE BAJA OFICINA ------------------------------------
        --------------------------------------------------------------------
        
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL PROCESO DE CAMBIO DE OFICINA BANKIA' || CHR(10);
                    
                    
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                            SET 
                                PVE.USUARIOMODIFICAR = '''||V_USUARIO||'''
                                , PVE.FECHAMODIFICAR = SYSDATE
                                , PVE.PVE_FECHA_BAJA = SYSDATE
                                , PVE.DD_EPR_ID = (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.BORRADO = 0 AND EPR.DD_EPR_CODIGO = ''07'')
                            WHERE PVE.BORRADO = 0 AND PVE.PVE_ID = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                            
                PL_OUTPUT := PL_OUTPUT || '     BORRADA OFICINA ANTIGUA' || CHR(10) ;
                            
        --------------------------------------------------------------------
        ----------- CAMBIO DE OFICINA --------------------------------------
        --------------------------------------------------------------------
        
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN CLIENTES' || CHR(10);
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
                    SET 
                        CLC.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , CLC.FECHAMODIFICAR = SYSDATE
                        , CLC.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE CLC.BORRADO = 0 AND CLC.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' CLIENTES' || CHR(10) ;
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
                    SET 
                        CLC.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , CLC.FECHAMODIFICAR = SYSDATE
                        , CLC.PVE_ID_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE CLC.BORRADO = 0 AND CLC.PVE_ID_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' CLIENTES' || CHR(10) ;
                
        --------------------------------------------------------------------
        ----------- CAMBIO DE VISITAS --------------------------------------
        --------------------------------------------------------------------

                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN VISITAS' || CHR(10);
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
               EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' || CHR(10) ;
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_PVE_VISITA = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_PVE_VISITA = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     REALIZADOR CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' || CHR(10) ;   
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_API_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_API_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' || CHR(10);   
        --------------------------------------------------------------------
        ----------- CAMBIO DE OFERTAS Y EXPEDIENTES ------------------------
        --------------------------------------------------------------------

                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN OFERTAS Y EXPEDIENTE' || CHR(10);
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                    SET 
                        OFR.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , OFR.FECHAMODIFICAR = SYSDATE
                        , OFR.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE OFR.BORRADO = 0 AND OFR.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' OFERTAS' || CHR(10) ;          
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                    SET 
                        OFR.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , OFR.FECHAMODIFICAR = SYSDATE
                        , OFR.PVE_ID_API_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE OFR.BORRADO = 0 AND OFR.PVE_ID_API_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' OFERTAS' || CHR(10) ;  
                
                V_MSQL := 'INSERT INTO '||V_TEXT_TABLA_AUX||' 
                            (ENVIO_ID,
                            ECO_ID,
                            OFICINA_ANTERIOR,
                            ENVIADO,
                            VERSION,
                            USUARIOCREAR,
                            FECHACREAR,
                            BORRADO)                         
                         SELECT  '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX||'.NEXTVAL,
                         GEX.ECO_ID,
                         '''||PVE_COD_API_PROVEEDOR_ANTIGUA||''',
                         0,
                         0,
                         '''||V_USUARIO||''',
                         SYSDATE,                         
                         0 
                        FROM (SELECT AUX_GEX.ECO_ID, ROW_NUMBER() OVER (PARTITION BY AUX_GEX.ECO_ID ORDER BY AUX_GEX.GEX_ID desc) RN
                                FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE AUX_GEX 
                                WHERE AUX_GEX.BORRADO = 0 
                                AND AUX_GEX.GEX_PROVEEDOR = '||V_OFICINA_ANTIGUA||') GEX
                        WHERE GEX.RN = 1';

                EXECUTE IMMEDIATE V_MSQL;        

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX 
                    SET 
                        GEX.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , GEX.FECHAMODIFICAR = SYSDATE
                        , GEX.GEX_PROVEEDOR = '||V_OFICINA_NUEVA||'
                    WHERE GEX.BORRADO = 0 AND GEX.GEX_PROVEEDOR = '||V_OFICINA_ANTIGUA;
                EXECUTE IMMEDIATE V_MSQL;
                    
                PL_OUTPUT := PL_OUTPUT || '     RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' HONORARIOS' || CHR(10) ;  

            ELSE
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - LA OFICINA NUEVA '||PVE_COD_API_PROVEEDOR_NUEVA||' NO ESTÁ VIGENTE, NO SE REALIZARÁ NINGUNA ACCIÓN' || CHR(10);
            END IF;
        ELSE
            PL_OUTPUT := PL_OUTPUT || '   [INFO] - LA OFICINA ANTIGUA '||PVE_COD_API_PROVEEDOR_ANTIGUA||' NO ESTÁ VIGENTE, NO SE REALIZARÁ NINGUNA ACCIÓN' || CHR(10);
        END IF; 

    PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_CAMBIO_OFICINA_BANKIA;
/
EXIT;
