--/*
--##########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20171205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3329
--## PRODUCTO=NO
--## Finalidad: Asignación de las partidas presupuestarias a los gastos en GIC_GASTOS_INFO_CONTABILIDAD
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(50 CHAR):= 'GIC_GASTOS_INFO_CONTABILIDAD';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de asignación de las partidas presupuestarias a los gastos');
    
	V_SQL := '
		MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' GIC
		USING (
			SELECT DISTINCT GIC1.GIC_ID, CPP.CPP_PARTIDA_PRESUPUESTARIA
			FROM '||V_ESQUEMA||'.'||V_TABLA||' GIC1
			INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC1.GPV_ID
			INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID
			INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
			INNER JOIN '||V_ESQUEMA||'.GPV_ACT GPV_ACT ON GPV_ACT.GPV_ID = GPV.GPV_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GPV_ACT.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP ON CPP.EJE_ID = GIC1.EJE_ID AND CPP.DD_STG_ID = STG.DD_STG_ID AND CPP.DD_CRA_ID = CRA.DD_CRA_ID AND CPP.CPP_ARRENDAMIENTO = DECODE(NVL(SPS.SPS_OCUPADO,0)+NVL(SPS.SPS_CON_TITULO,0),2,1,0)
			WHERE GIC1.GIC_PTDA_PRESUPUESTARIA IS NULL
			AND STG.DD_TGA_ID = TGA.DD_TGA_ID
			AND CRA.DD_CRA_CODIGO = ''02''
			AND GIC1.BORRADO = 0) AUX
		ON (GIC.GIC_ID = AUX.GIC_ID)
		WHEN MATCHED THEN UPDATE SET
		GIC.GIC_PTDA_PRESUPUESTARIA = AUX.CPP_PARTIDA_PRESUPUESTARIA,
		GIC.USUARIOMODIFICAR = ''HREOS-3329'',
		GIC.FECHAMODIFICAR = SYSDATE
	';
    EXECUTE IMMEDIATE V_SQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... SE HAN ASIGNADO CORRECTAMENTE '||SQL%ROWCOUNT||' PARTIDAS PRESUPUESTARIAS');

	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de asignación de las partidas presupuestarias a los gastos a finalizado correctamente');
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
