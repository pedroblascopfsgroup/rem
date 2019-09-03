--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20190903
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7530
--## PRODUCTO=SI
--## Finalidad: Actualizar el DD_CLO_ID de las ofertas de liberbank que lo tienen en nulo a individual.
--##           
--## INSTRUCCIONES: Lanzar
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro   
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
   V_TABLENAME VARCHAR2(50 CHAR):= 'OFR_OFERTAS';
   V_SEQNAME VARCHAR2(50 CHAR):= 'S_DD_TDN_TIPO_DOCUMENTO';
   V_PREFIJO VARCHAR2(50 CHAR) := 'DD_TDN_';

   V_MERGE  VARCHAR2(4000 CHAR) := 'MERGE INTO ' || V_ESQUEMA || '.' || V_TABLENAME|| ' T1  ' || 
    ' USING (SELECT DISTINCT OFR.OFR_ID
        FROM OFR_OFERTAS OFR
        INNER JOIN ' || V_ESQUEMA || '.ACT_OFR ACTOFR ON OFR.OFR_ID = ACTOFR.OFR_ID
        INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = ACTOFR.ACT_ID
        INNER JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
        WHERE CRA.DD_CRA_CODIGO = ''08''
        AND DD_CLO_ID IS NULL) T2 ' ||
    ' ON (T1.OFR_ID = T2.OFR_ID) ' ||
    ' WHEN MATCHED THEN ' ||
    ' UPDATE SET T1.DD_CLO_ID = (SELECT CLO.DD_CLO_ID FROM ' || V_ESQUEMA || '.DD_CLO_CLASE_OFERTA CLO WHERE CLO.DD_CLO_CODIGO = ''03'')'  ;
 
BEGIN
  
  EXECUTE IMMEDIATE V_MERGE;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || V_TABLENAME ||'... Datos del diccionario insertado');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
