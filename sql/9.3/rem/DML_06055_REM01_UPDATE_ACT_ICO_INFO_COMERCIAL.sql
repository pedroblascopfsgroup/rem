--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20211224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16794
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16794';
    
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  V_SQL := 'MERGE INTO ACT_ICO_INFO_COMERCIAL T1
            USING (
                SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, BIE.DD_PRV_ID, BIE.DD_LOC_ID, BIE.DD_UPO_ID
                FROM ACT_ACTIVO ACT
                JOIN ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID AND LOC.BORRADO = 0
                JOIN BIE_LOCALIZACION BIE ON BIE.BIE_LOC_ID = LOC.BIE_LOC_ID AND BIE.BORRADO = 0
                WHERE ACT.BORRADO = 0
            ) T2
            ON (T1.ACT_ID = T2.ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.DD_PRV_ID = T2.DD_PRV_ID,
                T1.DD_LOC_ID = T2.DD_LOC_ID,
                T1.DD_UPO_ID = T2.DD_UPO_ID,
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE';
  EXECUTE IMMEDIATE V_SQL;

  V_SQL := 'UPDATE ACT_ICO_INFO_COMERCIAL SET 
                DD_ESO_ID = 1,
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE
            WHERE DD_ESO_ID IS NULL';
  EXECUTE IMMEDIATE V_SQL;

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
