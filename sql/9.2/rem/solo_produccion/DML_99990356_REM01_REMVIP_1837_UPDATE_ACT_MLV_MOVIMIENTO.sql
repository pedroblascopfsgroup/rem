--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1837
--## PRODUCTO=SI
--##
--## Finalidad: Poner activos 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
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
    V_USUARIO VARCHAR2(50 CHAR):= 'REMVIP-1837';
        
BEGIN


       
V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE T1 USING (
              select  MLV_ID from(
               SELECT  ROW_NUMBER() OVER (PARTITION BY LLV.ACT_ID ORDER BY ACT.ACT_ID) RN, ACT.ACT_NUM_ACTIVO, MLV.*
                  FROM '||V_ESQUEMA||'.ACT_MLV_MOVIMIENTO_LLAVE MLV
                  JOIN '||V_ESQUEMA||'.ACT_LLV_LLAVE LLV ON LLV.LLV_ID = MLV.LLV_ID
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = LLV.ACT_ID
                  JOIN '||V_ESQUEMA||'.AUX_CARGA_LLAVES aux ON AUX.ACT_NUM_UVEM = ACT.ACT_NUM_ACTIVO_UVEM
                  WHERE MLV.USUARIOCREAR =  '''||V_USUARIO||''' and ACT_NUM_ACTIVO in (6979392,
                        6980310,
                        6980578,
                        6980904,
                        6980943,
                        6981408,
                        6981417,
                        6981525,
                        6981585,
                        6981682,
                        6982982,
                        6983116,
                        6983762,
                        6984761,
                        6984764,
                        6984789,
                        6984895,
                        6984937,
                        6985918,
                        6985946,
                        6986149,
                        6986281,
                        6987726,
                        6988160,
                        6988518,
                        6989397,
                        6989515,
                        6989701,
                        6990195,
                        6990402,
                        6990433,
                        6990457,
                        6990460,
                        6990652,
                        6990853,
                        6990883,
                        6991143,
                        6991342,
                        6991359,
                        6992220,
                        6992221,
                        6992938,
                        6995302,
                        6999614,
                        6999617,
                        6999680,
                        7000048,
                        7000072,
                        7000073,
                        7000074,
                        7000076,
                        7000078,
                        7000088,
                        7000092,
                        7000298,
                        7001359,
                        7002198,
                        7002260,
                        7002322)and mlv.usuariomodificar is null) where RN = 1 
             ) T2 ON (T1.MLV_ID = T2.MLV_ID)
          WHEN MATCHED THEN UPDATE SET
            T1.BORRADO = 0
          , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
          , T1.FECHAMODIFICAR = SYSDATE'
          ;



      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros en ACT_MLV_MOVIMIENTO_LLAVE');


    COMMIT;

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
