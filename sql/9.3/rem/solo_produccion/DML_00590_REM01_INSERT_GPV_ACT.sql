--/*
--###########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8588
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


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-8588';
  TABLE_COUNT NUMBER(1,0) := 0;

  V_TABLA_ACTIVO VARCHAR2(100 CHAR):='ACT_ACTIVO';
  V_TABLA_GASTO VARCHAR2(100 CHAR):='GPV_GASTOS_PROVEEDOR';
  V_TABLA_ACTIVO_GASTO VARCHAR2(100 CHAR):='GPV_ACT';

  V_NUM_ACT VARCHAR2(30 CHAR):='7258071';
  V_NUM_GASTO VARCHAR2(30 CHAR):='12197722';

  V_ID_ACTIVO NUMBER(16);
  V_ID_GASTO NUMBER(16);
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='||V_NUM_ACT||'';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	 

    IF V_NUM_TABLAS = 1 THEN

        V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' WHERE GPV_NUM_GASTO_HAYA='||V_NUM_GASTO||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

            V_MSQL :='SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='||V_NUM_ACT||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_ACTIVO;

            V_MSQL :='SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' WHERE GPV_NUM_GASTO_HAYA='||V_NUM_GASTO||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_GASTO;


            V_MSQL :='SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO_GASTO||' WHERE GPV_ID='||V_ID_GASTO||' AND ACT_ID='||V_ID_ACTIVO||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR ACTIVO EN GASTO' );


                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACTIVO_GASTO||'(
                GPV_ACT_ID,
                GPV_ID,
                ACT_ID,
                GPV_PARTICIPACION_GASTO,
                GPV_REFERENCIA_CATASTRAL,
                VERSION
                )
                SELECT '||V_ESQUEMA||'.S_'||V_TABLA_ACTIVO_GASTO||'.NEXTVAL,
                '||V_ID_GASTO||',
                '||V_ID_ACTIVO||',
                100,
                NULL,
                0 FROM DUAL';

                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO CORRECTAMENTE ACTIVO EN GASTO' );


            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO YA ESTA RELACIONADO CON EL GASTO' );
            END IF;


        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE GASTO CON EL NUMERO DE GASTO INDICADO: '||V_NUM_GASTO||'' );
        END IF;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE ACTIVO CON EL NUMERO DE ACTIVO INDICADO: '||V_NUM_ACT||'' );
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