--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180919
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


      --ACTUALIZO 
      V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1 USING (
                    SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID
                    FROM REM01.ACT_ACTIVO ACT
                    JOIN REM01.ACT_LLV_LLAVE LLV ON LLV.ACT_ID = ACT.ACT_ID and LLV.borrado = 0
                    JOIN rem01.AUX_CARGA_LLAVES AUX ON AUX.ACT_NUM_UVEM = ACT.ACT_NUM_ACTIVO_UVEM
                    GROUP BY ACT.ACT_NUM_ACTIVO, ACT.ACT_ID
                ) T2 ON (T1.ACT_ID = T2.ACT_ID and  T1.borrado = 0)
                WHEN MATCHED THEN UPDATE SET
                  T1.ACT_LLAVES_NECESARIAS = 1
                , T1.ACT_LLAVES_HRE = 1
                , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                , T1.FECHAMODIFICAR = SYSDATE';

      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros en ACT_ACTIVO');


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
