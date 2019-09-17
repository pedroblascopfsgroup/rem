--/*
--###########################################
--## AUTOR=Jose Manuel Santa
--## FECHA_CREACION=20190916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5259
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR GPV_GASTOS_PROVEEDOR - GIC_GASTOS_INFO_CONTABILIDAD - GDE_GASTOS_DETALLE_ECONOMICO                         
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar       
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
  V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5259';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
/*
    DBMS_OUTPUT.PUT_LINE('[INFO]: CONCEDIENDO PRIVILEGIOS A REM01 SOBRE REM_EXT.TMP_CUADRE_ALL_ASPRO_160919 ' );

		V_MSQL := 'GRANT ALL ON REM_EXT.TMP_CUADRE_ALL_ASPRO_160919 TO REM01 WITH GRANT OPTION';

		EXECUTE IMMEDIATE V_MSQL;
*/

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR A CONTABILIZADO GPV_GASTOS_PROVEEDOR.DD_EGA_ID ' );

            
               	V_MSQL := '			
			UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV_OLD
			SET 
			   GPV_OLD.DD_EGA_ID         = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04'')
			 , USUARIOMODIFICAR          = ''' || V_USUARIOMODIFICAR ||'''
			 , GPV_OLD.FECHAMODIFICAR    = sysdate
			WHERE GPV_OLD.GPV_NUM_GASTO_HAYA IN(
			  SELECT 
			    GPV_NUM_GASTO_HAYA
			  FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919
			  WHERE ESTADO = ''CONTABILIZADO'')';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR a estado Contabilizado ');  


    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR A PAGADO GPV_GASTOS_PROVEEDOR.DD_EGA_ID ' );

            
               	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV_OLD
			SET 
			   GPV_OLD.DD_EGA_ID         = (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'')
			 , USUARIOMODIFICAR          = ''' || V_USUARIOMODIFICAR || '''
			 , GPV_OLD.FECHAMODIFICAR    = sysdate
			WHERE GPV_OLD.GPV_NUM_GASTO_HAYA IN(
			  SELECT 
			    GPV_NUM_GASTO_HAYA
			  FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919
			  WHERE ESTADO = ''PAGADO'')';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR a estado Pagado ');



    DBMS_OUTPUT.PUT_LINE('[INFO]: CAMBIANDO NLS_DATE_FORMAT A mm/dd/rr ' );
            
               	V_MSQL := q'[ALTER SESSION SET NLS_DATE_FORMAT = 'mm/dd/rr']';

		EXECUTE IMMEDIATE V_MSQL;

	 V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = ''REM_EXT'' AND TABLE_NAME = ''TMP_CUADRE_ALL_ASPRO_160919_2''';
	 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	 
	 IF V_NUM_TABLAS = 0 THEN  


   	 DBMS_OUTPUT.PUT_LINE('[INFO]: CREANDO TABLA TMP_CUADRE_ALL_ASPRO_160919_2 ' );

		V_MSQL:= q'[CREATE TABLE REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_2 AS
			SELECT 
				GPV_NUM_GASTO_HAYA, ESTADO
				, to_char(to_date (FECHA_CONTABILIZACION,'mm/dd/rr'),'dd/mm/rr') as FECHA_CONTABILIZACION
			FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919]';

		EXECUTE IMMEDIATE V_MSQL;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA TMP_CUADRE_ALL_ASPRO_160919_2 YA EXISTE' );
		
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = ''REM_EXT'' AND TABLE_NAME = ''TMP_CUADRE_ALL_ASPRO_160919_3''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
	 
	 IF V_NUM_TABLAS_2 = 0 THEN  


   	 DBMS_OUTPUT.PUT_LINE('[INFO]: CREANDO TABLA TMP_CUADRE_ALL_ASPRO_160919_3 ' );

		V_MSQL:= q'[CREATE TABLE REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_3 AS
			SELECT 
			  	GPV_NUM_GASTO_HAYA, ESTADO, to_char(to_date (FECHA_PAGO,'mm/dd/rr'),'dd/mm/rr') as FECHA_PAGO
			FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919
			WHERE FECHA_PAGO IS NOT NULL AND FECHA_PAGO <> '1753-01-01']';

		EXECUTE IMMEDIATE V_MSQL;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA TMP_CUADRE_ALL_ASPRO_160919_3 YA EXISTE' );
		
	END IF;

/*
    DBMS_OUTPUT.PUT_LINE('[INFO]: CONCEDIENDO PRIVILEGIOS A REM01 SOBRE REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_2 ' );

		V_MSQL := 'GRANT ALL ON REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_2 TO REM01 WITH GRANT OPTION';

		EXECUTE IMMEDIATE V_MSQL;


    DBMS_OUTPUT.PUT_LINE('[INFO]: CONCEDIENDO PRIVILEGIOS A REM01 SOBRE REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_3 ' );

		V_MSQL := 'GRANT ALL ON REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_3 TO REM01 WITH GRANT OPTION';

		EXECUTE IMMEDIATE V_MSQL;
*/

    DBMS_OUTPUT.PUT_LINE('[INFO]: CAMBIANDO NLS_DATE_FORMAT A dd/mm/rr ' );
            
               	V_MSQL := q'[ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/rr']';

		EXECUTE IMMEDIATE V_MSQL;


    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO FECHA DE CONTABILIZACIÓN EN GIC_GASTOS_INFO_CONTABILIDAD ' );

		V_MSQL := ' 

			MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GPV_OLD USING
			(
			  SELECT DISTINCT CONT.GPV_ID, FECHA_CONTABILIZACION
			  FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_2 TMP 
			  INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON TMP.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
			  INNER JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD CONT ON CONT.GPV_ID = GPV.GPV_ID 
			  AND CONT.GIC_FECHA_CONTABILIZACION IS NULL
			  WHERE TMP.ESTADO = ''CONTABILIZADO''
			) GPV_NEW
			ON (GPV_OLD.GPV_ID = GPV_NEW.GPV_ID)
			WHEN MATCHED THEN UPDATE SET 
			   GPV_OLD.GIC_FECHA_CONTABILIZACION    = GPV_NEW.FECHA_CONTABILIZACION
			 , GDE_OLD.USUARIOMODIFICAR             = ''' || V_USUARIOMODIFICAR || '''
			 , GPV_OLD.FECHAMODIFICAR               = sysdate
		';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GIC_GASTOS_INFO_CONTABILIDAD '); 



    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO FECHA DE PAGO EN GDE_GASTOS_DETALLE_ECONOMICO ' );

		V_MSQL := ' 

			MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE_OLD USING
			(
			  SELECT DISTINCT ECO.GPV_ID, FECHA_PAGO
			  FROM REM_EXT.TMP_CUADRE_ALL_ASPRO_160919_3 TMP 
			  INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON TMP.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
			  INNER JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO ECO ON ECO.GPV_ID = GPV.GPV_ID AND ECO.GDE_FECHA_PAGO IS NULL
			  WHERE TMP.ESTADO = ''PAGADO''
			) GDE_NEW
			ON (GDE_OLD.GPV_ID = GDE_NEW.GPV_ID)
			WHEN MATCHED THEN UPDATE SET 
			   GDE_OLD.GDE_FECHA_PAGO      = GDE_NEW.FECHA_PAGO
			 , GDE_OLD.USUARIOMODIFICAR    = ''' || V_USUARIOMODIFICAR || '''
			 , GDE_OLD.FECHAMODIFICAR      = sysdate
		';

                EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GDE_GASTOS_DETALLE_ECONOMICO '); 


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

EXIT
