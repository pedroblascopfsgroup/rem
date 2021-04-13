--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210407
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9415
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9415';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_TOTAL NUMBER(16):=0;
    V_PROVEEDOR NUMBER(16):=110115587;
    V_PREFACTURA NUMBER(16):=712;


BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PROVEEDOR PREFACTURA');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE             
                WHERE PVE.PVE_COD_REM='||V_PROVEEDOR||' AND PVE.BORRADO=0';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN

        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PFA_PREFACTURA PFA WHERE PFA_NUM_PREFACTURA = '||V_PREFACTURA||'' INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

            V_SQL := ' UPDATE '||V_ESQUEMA||'.PFA_PREFACTURA SET 
                        USUARIOMODIFICAR = ''' || V_USUARIO || ''',
                        FECHAMODIFICAR   = SYSDATE, 
                        PVE_ID = (SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                                    WHERE PVE.PVE_COD_REM='||V_PROVEEDOR||' AND PVE.BORRADO=0)
                        WHERE PFA_NUM_PREFACTURA = '||V_PREFACTURA||' ';	

            EXECUTE IMMEDIATE V_SQL;            
            DBMS_OUTPUT.PUT_LINE('[INFO] Modificada prefactura: '||V_PREFACTURA||'');
            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] La prefactura no existe!');
                        
            END IF;


    ELSE
         DBMS_OUTPUT.PUT_LINE('[INFO]: No existe proveedor con el cod proveedor rem indicado '||V_PROVEEDOR||'');

    END IF;

     COMMIT;

     DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT