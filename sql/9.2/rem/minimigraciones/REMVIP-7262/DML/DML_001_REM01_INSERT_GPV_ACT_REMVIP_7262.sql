--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200508
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RREMVIP-7262
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAR REGISTROS GPV_ACT
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,'


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';  
  V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-7262';
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
  TABLE_COUNT NUMBER(1,0) := 0;
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR ACTIVOS EN GASTO' );

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11935814';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		


		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT(
		GPV_ACT_ID,
		GPV_ID,
		ACT_ID,
		GPV_PARTICIPACION_GASTO,
		GPV_REFERENCIA_CATASTRAL,
		VERSION
		)
		SELECT 
		REM01.S_GPV_ACT.NEXTVAL,
		AUX.GPV_ID,
		ACT.ACT_ID,
		AUX.PORC_PART,
		NULL,
		0
		FROM REM01.AUX_REMVIP_7262 AUX 
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
		WHERE AUX.GPV_ID = 7803268';

	    	 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' || SQL%ROWCOUNT || ' REGISTROS DE GPV_ACT ' );

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 11935814 NO EXISTE ');
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11935817';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT(
		GPV_ACT_ID,
		GPV_ID,
		ACT_ID,
		GPV_PARTICIPACION_GASTO,
		GPV_REFERENCIA_CATASTRAL,
		VERSION
		)
		SELECT 
		REM01.S_GPV_ACT.NEXTVAL,
		AUX.GPV_ID,
		ACT.ACT_ID,
		AUX.PORC_PART,
		NULL,
		0
		FROM REM01.AUX_REMVIP_7262 AUX 
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
		WHERE AUX.GPV_ID = 7803271';

	    	 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' || SQL%ROWCOUNT || ' REGISTROS DE GPV_ACT ' );

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 11935817 NO EXISTE ');
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11935815';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT(
		GPV_ACT_ID,
		GPV_ID,
		ACT_ID,
		GPV_PARTICIPACION_GASTO,
		GPV_REFERENCIA_CATASTRAL,
		VERSION
		)
		SELECT 
		REM01.S_GPV_ACT.NEXTVAL,
		AUX.GPV_ID,
		ACT.ACT_ID,
		AUX.PORC_PART,
		NULL,
		0
		FROM REM01.AUX_REMVIP_7262 AUX 
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
		WHERE AUX.GPV_ID = 7803269';

	    	 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' || SQL%ROWCOUNT || ' REGISTROS DE GPV_ACT ' );

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 11935815 NO EXISTE ');
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11935812';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT(
		GPV_ACT_ID,
		GPV_ID,
		ACT_ID,
		GPV_PARTICIPACION_GASTO,
		GPV_REFERENCIA_CATASTRAL,
		VERSION
		)
		SELECT 
		REM01.S_GPV_ACT.NEXTVAL,
		AUX.GPV_ID,
		ACT.ACT_ID,
		AUX.PORC_PART,
		NULL,
		0
		FROM REM01.AUX_REMVIP_7262 AUX 
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
		WHERE AUX.GPV_ID = 7803266';

	    	 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' || SQL%ROWCOUNT || ' REGISTROS DE GPV_ACT ' );

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 11935812 NO EXISTE ');
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11935816';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_ACT(
		GPV_ACT_ID,
		GPV_ID,
		ACT_ID,
		GPV_PARTICIPACION_GASTO,
		GPV_REFERENCIA_CATASTRAL,
		VERSION
		)
		SELECT 
		REM01.S_GPV_ACT.NEXTVAL,
		AUX.GPV_ID,
		ACT.ACT_ID,
		AUX.PORC_PART,
		NULL,
		0
		FROM REM01.AUX_REMVIP_7262 AUX 
		INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_ACTIVO 
		WHERE AUX.GPV_ID = 7803270';

	    	 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' || SQL%ROWCOUNT || ' REGISTROS DE GPV_ACT ' );

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL GASTO 11935816 NO EXISTE ');
	END IF;

  	COMMIT;

    	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
