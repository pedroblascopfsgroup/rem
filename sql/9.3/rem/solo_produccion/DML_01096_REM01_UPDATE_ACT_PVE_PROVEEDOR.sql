--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10833
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-10833';
    V_TABLA VARCHAR2(50 CHAR) := 'ACT_PVE_PROVEEDOR';


    
BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: Inicio Actualizacion proveedores en '||V_TABLA||'');


    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                USING (
                    SELECT AUX.PVE_ID,AUX.MAXIMO,AUX.MAXIMO+AUX.NFILA AS PVE_COD_REM FROM
                    (
                    SELECT PVE.PVE_ID,(SELECT MAX(PVE2.PVE_COD_REM) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE2) AS MAXIMO, ROWNUM AS NFILA FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                    WHERE PVE.USUARIOCREAR=''REMVIP-9603''
                    GROUP BY PVE.PVE_ID,ROWNUM
                    ORDER BY PVE.PVE_ID
                    )AUX

                ) T2
                ON (T1.PVE_ID = T2.PVE_ID)
                WHEN MATCHED THEN
                UPDATE SET 
                    PVE_COD_REM = T2.PVE_COD_REM,
                    FECHAMODIFICAR = SYSDATE,
                    USUARIOMODIFICAR = '''||V_USUARIO||'''	 		
                ';
		
	EXECUTE IMMEDIATE V_MSQL;  

    DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' Proveedores actualizados  ');
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA ');
   
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
