--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12758
--## PRODUCTO=NO
--## Finalidad: Procedimiento almacenado que realiza el cambio de oficinas en Bankia
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_CAMBIO_OFICINA_BANKIA (
    V_USUARIO       VARCHAR2 DEFAULT 'SP_CAMBIO_OFICINA_BANKIA',
    PL_OUTPUT       OUT VARCHAR2,
    PVE_COD_REM_ANTIGUA  IN REM01.ACT_PVE_PROVEEDOR.PVE_COD_REM%TYPE,
    PVE_COD_REM_NUEVA  IN REM01.ACT_PVE_PROVEEDOR.PVE_COD_REM%TYPE) AS
--  0.1

    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR);
    V_OFICINA_ANTIGUA NUMBER(16);
    V_OFICINA_NUEVA NUMBER(16);

BEGIN
        PL_OUTPUT := '[INICIO]'||CHR(10);
    
        --------------------------------------------------------------------
        ----------- COMPROBACIONES PREVIAS --------------------------------
        --------------------------------------------------------------------
    
        V_SQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
        LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
        WHERE TPR.DD_TPR_CODIGO = ''28'' AND PVE.BORRADO = 0 AND PVE_COD_REM = '||PVE_COD_REM_ANTIGUA;
        EXECUTE IMMEDIATE V_SQL INTO V_OFICINA_ANTIGUA;
        
        IF V_OFICINA_ANTIGUA IS NOT NULL THEN
            V_SQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
            WHERE TPR.DD_TPR_CODIGO = ''28'' AND EPR.DD_EPR_CODIGO = ''04'' AND PVE.BORRADO = 0 AND PVE_COD_REM = '||PVE_COD_REM_NUEVA;
            EXECUTE IMMEDIATE V_SQL INTO V_OFICINA_NUEVA;
            
            IF V_OFICINA_NUEVA IS NOT NULL THEN 
            
        --------------------------------------------------------------------
        ----------- DAR DE BAJA OFICINA ------------------------------------
        --------------------------------------------------------------------
        
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL PROCESO DE CAMBIO DE OFICINA BANKIA';
                    
                    
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                            SET 
                                PVE.USUARIOMODIFICAR = '''||V_USUARIO||'''
                                , PVE.FECHAMODIFICAR = SYSDATE
                                , PVE.PVE_FECHA_BAJA = SYSDATE
                                , PVE.DD_EPR_ID = (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.BORRADO = 0 AND EPR.DD_EPR_CODIGO = ''07'')
                            WHERE PVE.BORRADO = 0 AND PVE.PVE_ID = '||V_OFICINA_ANTIGUA;
                            
        --------------------------------------------------------------------
        ----------- CAMBIO DE OFICINA --------------------------------------
        --------------------------------------------------------------------
        
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN CLIENTES';
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
                    SET 
                        CLC.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , CLC.FECHAMODIFICAR = SYSDATE
                        , CLC.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE CLC.BORRADO = 0 AND CLC.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' CLIENTES' ;
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
                    SET 
                        CLC.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , CLC.FECHAMODIFICAR = SYSDATE
                        , CLC.PVE_ID_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE CLC.BORRADO = 0 AND CLC.PVE_ID_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' CLIENTES' ;
                
                REM01.OPERACION_DDL.DDL_TABLE('TRUNCATE','CLC_CLIENTE_COMERCIAL');
                
        --------------------------------------------------------------------
        ----------- CAMBIO DE VISITAS --------------------------------------
        --------------------------------------------------------------------
        -- ¿Y el custodio PVE_ID_API_CUSTODIO?
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN VISITAS';
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' ;
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_PVE_VISITA = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_PVE_VISITA = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - REALIZADOR CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' ;   
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.VIS_VISITAS VIS 
                    SET 
                        VIS.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , VIS.FECHAMODIFICAR = SYSDATE
                        , VIS.PVE_ID_API_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE VIS.BORRADO = 0 AND VIS.PVE_ID_API_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' VISITAS' ;   
                
                REM01.OPERACION_DDL.DDL_TABLE('TRUNCATE','VIS_VISITAS');
                 
        --------------------------------------------------------------------
        ----------- CAMBIO DE OFERTAS Y EXPEDIENTES ------------------------
        --------------------------------------------------------------------
        -- ¿Y el custodio PVE_ID_CUSTODIO y sucursal PVE_ID_SUCURSAL?
        -- Cambiar los honorarios para el comisionamiento se ajuste a las nuevas oficinas en REM. Crear un volcado masivo de los honorarios a UVEM con el botón de "envío de honorarios"
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - COMIENZA EL CAMBIO EN OFERTAS Y EXPEDIENTE';
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                    SET 
                        OFR.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , OFR.FECHAMODIFICAR = SYSDATE
                        , OFR.PVE_ID_PRESCRIPTOR = '||V_OFICINA_NUEVA||'
                    WHERE OFR.BORRADO = 0 AND OFR.PVE_ID_PRESCRIPTOR = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - PRESCRIPTOR CAMBIADO EN '||SQL%ROWCOUNT||' OFERTAS' ;          
                
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                    SET 
                        OFR.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , OFR.FECHAMODIFICAR = SYSDATE
                        , OFR.PVE_ID_API_RESPONSABLE = '||V_OFICINA_NUEVA||'
                    WHERE OFR.BORRADO = 0 AND OFR.PVE_ID_API_RESPONSABLE = '||V_OFICINA_ANTIGUA;
                    
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - RESPONSABLE CAMBIADO EN '||SQL%ROWCOUNT||' OFERTAS' ;  
                
                REM01.OPERACION_DDL.DDL_TABLE('TRUNCATE','OFR_OFERTAS');                 
            
            ELSE
                PL_OUTPUT := PL_OUTPUT || '   [INFO] - LA OFICINA NUEVA '||PVE_DOCIDENTIF||' NO ESTÁ VIGENTE, NO SE REALIZARÁ NINGUNA ACCIÓN';
            END IF;
        ELSE
            PL_OUTPUT := PL_OUTPUT || '   [INFO] - LA OFICINA '||PVE_DOCIDENTIF||' NO EXISTE, NO SE REALIZARÁ NINGUNA ACCIÓN';
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
