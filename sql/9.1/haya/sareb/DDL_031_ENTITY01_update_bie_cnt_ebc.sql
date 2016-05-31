--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=12-04-2016
--## ARTEFACTO=BACHT
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2234
--## PRODUCTO=NO
--## Finalidad:  Asociar al bien relacionado con el contrato 1339915133 el valor del DD_EBC_ID tal que su código sea 'ACT'. 
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

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Asociar al bien relacionado con el contrato 1339915133 el valor del DD_EBC_ID tal que su código sea ''ACT''.');
    
V_MSQL := '
MERGE INTO HAYA01.BIE_CNT BIC
   USING (
      SELECT BIC.BIE_CNT_ID FROM HAYA01.CNT_CONTRATOS CNT
      INNER JOIN HAYA01.BIE_CNT BIC ON BIC.CNT_ID=CNT.CNT_ID
      WHERE CNT.CNT_CONTRATO LIKE ''%1339915133%''
   )  TMP
   ON (BIC.BIE_CNT_ID=TMP.BIE_CNT_ID)
   WHEN MATCHED THEN UPDATE SET BIC.DD_EBC_ID=(SELECT EBC.DD_EBC_ID FROM HAYA01.DD_EBC_ESTADO_BIEN_CNT EBC WHERE EBC.DD_EBC_CODIGO = ''2'')
';
EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('    [INFO] Actualización terminada.');	

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT