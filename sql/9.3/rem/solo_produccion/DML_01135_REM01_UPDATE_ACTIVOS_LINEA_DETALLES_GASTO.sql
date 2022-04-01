--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11242
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES: Exluimos un activo (V_ACTIVO_EXCLUIR) y añadimos participación al activo (V_ACTIVO_ADD_PORC)
--##                en el gasto (V_NUM_GASTO)
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
	V_TABLA_ENT VARCHAR2(2400 CHAR) := 'GLD_ENT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_GLD VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_GPV VARCHAR2(2400 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_ACT VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11242';
    V_ACTIVO_EXCLUIR NUMBER(25) := 7042802;
    V_ACTIVO_ADD_PORC NUMBER(25) := 7042082;
    V_NUM_GASTO NUMBER(25) := 14597304;


    
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TABLA_ENT);

    --Comprobar el dato a updatear.
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' aa
                    WHERE aa.ACT_NUM_ACTIVO = '||V_ACTIVO_EXCLUIR||'
                    AND aa.BORRADO= 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    -- Si existe se modifica.
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' aa
                    WHERE aa.ACT_NUM_ACTIVO = '||V_ACTIVO_ADD_PORC||'
                    AND aa.BORRADO= 0';
         EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

         IF V_NUM_TABLAS > 0 THEN


            V_MSQL := 'SELECT COUNT (*) FROM '|| V_ESQUEMA ||'.'||V_TABLA_ENT||' 
                            WHERE GLD_ID = ( select DISTINCT GLD.GLD_ID from '|| V_ESQUEMA ||'.'||V_TABLA_GLD||' gld  
                                JOIN '|| V_ESQUEMA ||'.'||V_TABLA_GPV||' gpv ON gpv.gpv_id = gld.gpv_id AND gpv.borrado = 0
                                WHERE gpv.gpv_num_gasto_haya = '||V_NUM_GASTO||'
                                AND gld.borrado = 0)
                            AND ENT_ID IN (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO IN ('||V_ACTIVO_EXCLUIR||','||V_ACTIVO_ADD_PORC||')
                            AND BORRADO = 0)
                            AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            IF V_NUM_TABLAS = 2 THEN
                        -- UPDATE para borrado logico del gasto de linea de detalle.
                        DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAR EL REGISTRO  ACT_NUM '''|| V_ACTIVO_EXCLUIR ||'''');
                        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA_ENT||' '||
                                    'SET BORRADO = 0'||
                                        ', USUARIOBORRAR = '''||V_USUARIO||''' 
                                        , FECHABORRAR = SYSDATE '||
                                    'WHERE GLD_ID = ( select DISTINCT GLD.GLD_ID from '|| V_ESQUEMA ||'.'||V_TABLA_GLD||' gld  
                                        JOIN '|| V_ESQUEMA ||'.'||V_TABLA_GPV||' gpv ON gpv.gpv_id = gld.gpv_id AND gpv.borrado = 0
                                        WHERE gpv.gpv_num_gasto_haya = '||V_NUM_GASTO||'
                                        AND gld.borrado = 0)
                                    AND ENT_ID = (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO = '||V_ACTIVO_EXCLUIR||'
                                    AND BORRADO = 0)';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');

                        -- UPDATE para actualizar el gasto de linea de detalle.
                        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO  ACT_NUM '''|| V_ACTIVO_ADD_PORC ||''' SUMANDO EL PORCENTAJE FALTANTE ');
                    V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA_ENT||' '||
                                    'SET GLD_PARTICIPACION_GASTO = (SELECT SUM(GLD_PARTICIPACION_GASTO) 
                                                from '|| V_ESQUEMA ||'.'||V_TABLA_ACT||' aa
                                                JOIN '|| V_ESQUEMA ||'.'||V_TABLA_ENT||' ent ON aa.act_id = ent.ent_id 
                                                JOIN '|| V_ESQUEMA ||'.'||V_TABLA_GLD||' gld ON gld.gld_id = ent.gld_id AND gld.borrado = 0
                                                JOIN '|| V_ESQUEMA ||'.'||V_TABLA_GPV||' gpv ON gpv.gpv_id = gld.gpv_id AND gpv.borrado = 0
                                                WHERE gpv.gpv_num_gasto_haya = 14597304
                                                AND act_Num_Activo in (7042802, 7042082)
                                                AND aa.borrado = 0;)'||
                                        ', USUARIOMODIFICAR = '''||V_USUARIO||''' 
                                        , FECHAMODIFICAR = SYSDATE '||
                                    'WHERE GLD_ID = ( select DISTINCT GLD.GLD_ID from '|| V_ESQUEMA ||'.'||V_TABLA_GLD||' gld  
                                        JOIN '|| V_ESQUEMA ||'.'||V_TABLA_GPV||' gpv ON gpv.gpv_id = gld.gpv_id AND gpv.borrado = 0
                                        WHERE gpv.gpv_num_gasto_haya = '||V_NUM_GASTO||'
                                        AND gld.borrado = 0)
                                    AND ENT_ID = (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO = '||V_ACTIVO_ADD_PORC||'
                                    AND BORRADO = 0)';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
                ELSE
       	     -- Si no existe se actualiza.
                DBMS_OUTPUT.PUT_LINE('[INFO]: EL NUMERO DE GASTO '||V_NUM_GASTO||' NO CONTIENE LOS ACTIVOS :  '''||V_ACTIVO_EXCLUIR||''' Y '''||V_ACTIVO_ADD_PORC||'''');
                END IF;

            ELSE
       	     -- Si no existe se actualiza.
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON ACT_NUM:  '''||V_ACTIVO_ADD_PORC||'''');
             END IF;
       ELSE
       	-- Si no existe se actualiza.
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON ACT_NUM:  '''||V_ACTIVO_EXCLUIR||'''');

       END IF;
    
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA_ENT||' ACTUALIZADO CORRECTAMENTE ');

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
