--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6548
--## PRODUCTO=NO
--## Finalidad:
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_AGR_AGRUPACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-6548'; -- Incidencia LINK.
    
BEGIN
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
				USING (
				    SELECT DISTINCT AGR.AGR_ID, AGR.AGR_NUM_AGRUP_REM
					FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AGR
				    JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.DD_TAG_CODIGO = ''01''
				    JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
				    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''
				    WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_ALTA < TO_DATE(''01/01/2020'', ''DD/MM/YYYY'')
				) T2
				ON (T1.AGR_ID = T2.AGR_ID)
				WHEN MATCHED THEN UPDATE SET
				    T1.AGR_COD_ON_SAREB = T2.AGR_NUM_AGRUP_REM
				    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
				    ,FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] se han actualizado '||SQL%ROWCOUNT||' agrupaciones');
	
EXCEPTION
	WHEN OTHERS THEN
	err_num := SQLCODE;
	err_msg := SQLERRM;

  	DBMS_OUTPUT.PUT_LINE('KO no modificada');
  	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
  	DBMS_OUTPUT.put_line('-----------------------------------------------------------');
  	DBMS_OUTPUT.put_line(err_msg);

  	ROLLBACK;
  	RAISE;

END;
/
EXIT