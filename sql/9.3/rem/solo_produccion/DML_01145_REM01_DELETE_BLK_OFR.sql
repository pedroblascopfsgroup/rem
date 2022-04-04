--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11276
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar fechas cédulas de habitabilidad
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
  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'BLK_OFR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.     
  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-11276';


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --ID_HAYA/NUM_ACTIVO          
        T_TIPO_DATA('S000440/2021'),
        T_TIPO_DATA('S000441/2021'),
        T_TIPO_DATA('S000488/2022')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    DBMS_OUTPUT.PUT_LINE('[INFO]: INICIA DELETE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a updatear.
        V_MSQL := 'SELECT COUNT(1)
                        FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
                              JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                              JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                              JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''02''
                              JOIN '|| V_ESQUEMA ||'.BLK_OFR BO ON BO.OFR_ID = OFR.OFR_ID AND BO.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.BLK_BULK_ADVISORY_NOTE BLK ON BO.BLK_ID = BLK.BLK_ID
                              JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID AND TBJ.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND DD_TPO_CODIGO = ''T017''
                              JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID 
                              JOIN '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
                        WHERE BLK_NUM_BULK_AN = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

        -- Si existe se modifica.
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO CON  BLK_NUM_BULK_AN '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                              USING (SELECT DISTINCT OFR.OFR_ID, BLK.BLK_ID
                                                FROM '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO
                                                      JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                      JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                                                      JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''02''
                                                      JOIN '|| V_ESQUEMA ||'.BLK_OFR BO ON BO.OFR_ID = OFR.OFR_ID AND BO.BORRADO = 0
                                                      JOIN '|| V_ESQUEMA ||'.BLK_BULK_ADVISORY_NOTE BLK ON BO.BLK_ID = BLK.BLK_ID
                                                      JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ECO.TBJ_ID AND TBJ.BORRADO = 0
                                                      JOIN '|| V_ESQUEMA ||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
                                                      JOIN '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND DD_TPO_CODIGO = ''T017''
                                                      JOIN '|| V_ESQUEMA ||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.BORRADO = 0
                                                      JOIN '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.BORRADO = 0
                                                      JOIN '|| V_ESQUEMA ||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID 
                                                      JOIN '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
                                                WHERE BLK_NUM_BULK_AN = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''') T2
                              ON (T1.BLK_ID = T2.BLK_ID AND T1.OFR_ID = T2.OFR_ID)
                              WHEN MATCHED THEN
                                    UPDATE SET 
                                    T1.USUARIOBORRAR = '''||V_USER||''',
                                    T1.FECHABORRAR = SYSDATE,
                                    T1.BORRADO = 1';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO CON BLK_NUM_BULK_AN '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' BORRADO CORRECTAMENTE ');

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