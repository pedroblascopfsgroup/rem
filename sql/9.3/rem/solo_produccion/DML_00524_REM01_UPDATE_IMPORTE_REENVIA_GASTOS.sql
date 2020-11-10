--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8039
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8039';
    V_TABLA_GPV VARCHAR2(100 CHAR) :='GPV_GASTOS_PROVEEDOR'; --Vble. auxiliar para almacenar la tabla a insertar     
    V_TABLA_GDE VARCHAR2(100 CHAR) :='GDE_GASTOS_DETALLE_ECONOMICO'; --Vble. auxiliar para almacenar la tabla a insertar 
    V_TABLA_GPVACT VARCHAR2(100 CHAR) :='GPV_ACT'; --Vble. auxiliar para almacenar la tabla a insertar   
        
    V_SQL VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_PAR VARCHAR( 3000 CHAR );
    V_RET VARCHAR( 3000 CHAR );  
    
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar 
    
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.      
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('12038647'),
        T_TIPO_DATA('12126826'),
        T_TIPO_DATA('12126829')
    ); 
    
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA_GPV||' ');            


        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GPV||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';

    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    	IF V_NUM_TABLAS > 0 THEN              

        V_SQL:='SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GPV||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
         EXECUTE IMMEDIATE V_SQL INTO V_ID;
            

            --Comprobar si el gasto existe en GDE
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GDE||' WHERE GPV_ID='||V_ID||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
            
            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS IMPORTE DEL GASTO : '''||V_TMP_TIPO_DATA(1)||''' ');
                    
                
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_GDE||' SET 
                        GDE_PRINCIPAL_NO_SUJETO = GDE_RECARGO ,
                        GDE_RECARGO = NULL,
                        USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', 
                        FECHAMODIFICAR = SYSDATE 
                        WHERE GPV_ID = '||V_ID||' ';

                EXECUTE IMMEDIATE V_MSQL;
                                                                                        
                    V_COUNT:=V_COUNT+1;

            ELSE                
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO CON GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');

            END IF;
            
       V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GPVACT||' WHERE GPV_ID='||V_ID||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
            
            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS POCENTAJE PARTICIPACION ACTIVO DEL GASTO : '''||V_TMP_TIPO_DATA(1)||''' ');
            
          	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_ACT SET 
		  GPV_PARTICIPACION_GASTO = 100
		  WHERE GPV_ID = '||V_ID||' ';		

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

	    ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO ');
	    END IF;	
	    
	 ELSE
       	DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO ');
    	END IF;

        END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
	DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

	 V_PAR := '12038647, 12126826, 12126829';	

   	REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USUARIOMODIFICAR, V_RET );

-----------------------------------------------------------------------------------------------------------------

   	DBMS_OUTPUT.PUT_LINE( V_RET );
   	DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');
   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

	COMMIT;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
