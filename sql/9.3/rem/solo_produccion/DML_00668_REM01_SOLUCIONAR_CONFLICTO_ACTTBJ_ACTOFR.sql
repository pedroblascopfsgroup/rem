--/*
--#########################################
--## AUTOR=IVAN REPISO CAMARA
--## FECHA_CREACION=20210217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8989
--## PRODUCTO=NO
--## 
--## Finalidad: Solucionar conflicto entre activo/trabajo o activo/oferta
--## Modo: 	Eliminar relacion de oferta borrada o trabajo borrado por activo/s
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-8989'; -- USUARIOCREAR/USUARIOMODIFICAR.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --ACTIVOS > ACT_NUM_ACTIVO
        T_TIPO_DATA(6082988)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    V_OFR_ID NUMBER(25); --VARIABLE PARA ALMACENAR OFR_ID
    V_TBJ_ID NUMBER(25); --VARIABLE PARA ALMACENAR TBJ_ID
    
BEGIN		

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '||V_TMP_TIPO_DATA(1)||'');

    -----------------------------------------OFERTAS-----------------------------------------------------

        DBMS_OUTPUT.PUT_LINE('[INFO] BUSCAMOS OFERTA BORRADA RELACIONADO CON ACTIVO '||V_TMP_TIPO_DATA(1)||'');

        V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR AOFR ON AOFR.ACT_ID = ACT.ACT_ID
                    INNER JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AOFR.OFR_ID AND OFR.BORRADO = 1
                    AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND ACT.BORRADO = 0';

        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT != 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE RELACION ACTIVO/OFERTA CON CONFLICTO: OFERTA BORRADA');

            V_MSQL := 'SELECT OFR.OFR_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR AOFR ON AOFR.ACT_ID = ACT.ACT_ID
                    INNER JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AOFR.OFR_ID AND OFR.BORRADO = 1
                    AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND ACT.BORRADO = 0';

            EXECUTE IMMEDIATE V_MSQL INTO V_OFR_ID;

            V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_OFR WHERE OFR_ID = '||V_OFR_ID||'' ;	
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] RELACION ACTIVO/OFERTA BORRADA');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '||V_TMP_TIPO_DATA(1)||' NO TIENE CONFLICTO CON OFERTA');

        END IF;

        -----------------------------------------TRABAJOS-----------------------------------------------------

        DBMS_OUTPUT.PUT_LINE('[INFO] BUSCAMOS TRABAJO BORRADO RELACIONADO CON ACTIVO '||V_TMP_TIPO_DATA(1)||'');

        V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_TBJ ATBJ ON ATBJ.ACT_ID = ACT.ACT_ID
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATBJ.TBJ_ID AND TBJ.BORRADO = 1
                    AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND ACT.BORRADO = 0';

        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT != 0 THEN
        
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE RELACION ACTIVO/TRABAJO CON CONFLICTO: TRABAJO BORRADO');

            V_MSQL := 'SELECT TBJ.TBJ_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_TBJ ATBJ ON ATBJ.ACT_ID = ACT.ACT_ID
                    INNER JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATBJ.TBJ_ID AND TBJ.BORRADO = 1
                    AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND ACT.BORRADO = 0';

            EXECUTE IMMEDIATE V_MSQL INTO V_TBJ_ID;
        
            V_MSQL := 'DELETE FROM '|| V_ESQUEMA ||'.ACT_TBJ WHERE TBJ_ID = '||V_TBJ_ID||'' ;	
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] RELACION ACTIVO/TRABAJO BORRADO');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '||V_TMP_TIPO_DATA(1)||' NO TIENE CONFLICTO CON TRABAJO');

        END IF;

    END LOOP;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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