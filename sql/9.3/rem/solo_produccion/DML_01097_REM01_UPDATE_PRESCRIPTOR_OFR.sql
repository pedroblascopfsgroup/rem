--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10828
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el pve_cod_rem como nextval a partir del ultimo
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10828';
    V_TABLA_OFR VARCHAR2(50 CHAR) := 'OFR_OFERTAS';
    V_TABLA_GEX VARCHAR2(50 CHAR) := 'GEX_GASTOS_EXPEDIENTE';


    
BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio Actualizacion prescriptor en '||V_TABLA_OFR||' y '||V_TABLA_GEX||' ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_GEX||' T1
            USING (
                SELECT GEX.GEX_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OFR||' OFR
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID AND ECO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.'||V_TABLA_GEX||' GEX ON GEX.ECO_ID=ECO.ECO_ID AND GEX.BORRADO = 0
                WHERE OFR.BORRADO = 0
                AND OFR.PVE_ID_PRESCRIPTOR=(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM=20704)

            ) T2
            ON (T1.GEX_ID = T2.GEX_ID)
            WHEN MATCHED THEN
            UPDATE SET 
                GEX_PROVEEDOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM=110128066),
                FECHAMODIFICAR = SYSDATE,
                USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
            ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' GEX actualizados en '||V_TABLA_GEX||'  ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_OFR||' T1
                USING (
                    SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OFR||' OFR
                    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID AND ECO.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_GEX||' GEX ON GEX.ECO_ID=ECO.ECO_ID AND GEX.BORRADO = 0
                    WHERE OFR.BORRADO = 0
                    AND OFR.PVE_ID_PRESCRIPTOR=(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM=20704)

                ) T2
                ON (T1.OFR_ID = T2.OFR_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    PVE_ID_PRESCRIPTOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM=110128066),
                    FECHAMODIFICAR = SYSDATE,
                    USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' OFERTAS actualizados en '||V_TABLA_OFR||'  ');
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Cambios realizados correctamente');
   
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

EXIT;
