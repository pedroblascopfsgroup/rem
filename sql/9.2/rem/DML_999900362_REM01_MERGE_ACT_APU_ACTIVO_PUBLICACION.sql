--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20181026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4627
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade valores en ACT_APU_ACTIVO_PUBLICACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_ACTIVO VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar la tabla de estado activo.
    V_TEXT_TABLA_COMERZ VARCHAR2(2400 CHAR) := 'DD_TCO_TIPO_COMERCIALIZACION'; -- Vble. auxiliar para almacenar la tabla del estado de comercializacion.
    V_TEXT_TABLA_VENTA VARCHAR2(2400 CHAR) := 'DD_EPV_ESTADO_PUB_VENTA'; -- Vble. auxiliar para la tabla de estado venta.
    V_TEXT_TABLA_ALQUILER VARCHAR2(2400 CHAR) := 'DD_EPA_ESTADO_PUB_ALQUILER'; -- Vble. auxiliar para la tabla de estado alquiler.
    V_TEXT_TABLA_PUB VARCHAR2(2400 CHAR) := 'DD_TPU_TIPO_PUBLICACION'; -- Vble. auxiliar para la tabla de tipo publicación.
    

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en ACT_APU_ACTIVO_PUBLICACION -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ACT_APU_ACTIVO_PUBLICACION ');
  

  /* VENTA */

  /* CASO 1 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO REGISTROS');

  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS NO PUBLICADOS VENTA A SIN TIPO DE PUBLICACIÓN');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epv.DD_EPV_CODIGO IN (''01'', ''04'')
              AND apu.DD_TPU_V_ID IS NOT NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
      
      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
             USING(
                   SELECT apu.ACT_ID
                   FROM '||V_TEXT_TABLA||' apu
                   INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                   INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
                   INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                   WHERE tco.DD_TCO_CODIGO = ''02''
                   AND epv.DD_EPV_CODIGO IN (''01'', ''04'')
                   AND apu.DD_TPU_V_ID IS NOT NULL
             ) t2
             ON (t1.ACT_ID = t2.ACT_ID) 
             WHEN MATCHED THEN
             UPDATE SET
             t1.DD_TPU_V_ID = NULL,
             t1.USUARIOMODIFICAR = ''HREOS-4627'',
		 t1.FECHAMODIFICAR = SYSDATE';

      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO VENTA CASO 1 MODIFICADO CORRECTAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;

  

  /* CASO 2 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS PRE-PUBLICADO VENTA, PUBLICADO VENTA U OCULTO VENTA A TIPO DE PUBLICACIÓN ORDINARIO.');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epv.DD_EPV_CODIGO IN (''02'', ''03'', ''04'')
              AND apu.DD_TPU_V_ID IS NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
       
      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
                 USING(
                       SELECT apu.ACT_ID
                       FROM '||V_TEXT_TABLA||' apu
                       INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                       INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
                       INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                       WHERE tco.DD_TCO_CODIGO = ''02''
                       AND epv.DD_EPV_CODIGO IN (''02'', ''03'', ''04'')
                       AND apu.DD_TPU_V_ID IS NULL
                 ) t2
                 ON (t1.ACT_ID = t2.ACT_ID) 
                 WHEN MATCHED THEN
                 UPDATE SET
                 t1.DD_TPU_V_ID = (SELECT DD_TPU_ID FROM '||V_TEXT_TABLA_PUB||' WHERE DD_TPU_CODIGO = ''01''),
                 t1.USUARIOMODIFICAR = ''HREOS-4627'',
		     t1.FECHAMODIFICAR = SYSDATE';
             
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO VENTA CASO 2 MODIFICADO CORRECTAMENTE');

  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;

  

  /* CASO 3 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS PUBLICADO VENTA U OCULTO VENTA QUE NO TENGAN EL OK DE ADMISIÓN O GESTIÓN MARCADO A TIPO DE PUBLICACIÓN FORZADO.');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epv.DD_EPV_CODIGO IN (''03'', ''04'')
              AND (act.ACT_ADMISION = ''1'' 
              OR act.ACT_GESTION = ''1'')
              AND apu.DD_TPU_V_ID IS NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
        
      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
                 USING(
                       SELECT apu.ACT_ID
                       FROM '||V_TEXT_TABLA||' apu
                       INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                       INNER JOIN '||V_TEXT_TABLA_VENTA||'  epv ON apu.DD_EPV_ID = epv.DD_EPV_ID
                       INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                       WHERE tco.DD_TCO_CODIGO = ''02''
                       AND epv.DD_EPV_CODIGO IN (''03'', ''04'')
                       AND (act.ACT_ADMISION = ''1'' 
                       OR act.ACT_GESTION = ''1'')
                       AND apu.DD_TPU_V_ID IS NULL
                 ) t2
                 ON (t1.ACT_ID = t2.ACT_ID) 
                 WHEN MATCHED THEN
                 UPDATE SET
                 t1.DD_TPU_V_ID = (SELECT DD_TPU_ID FROM '||V_TEXT_TABLA_PUB||' WHERE DD_TPU_CODIGO = ''02''),
                 t1.USUARIOMODIFICAR = ''HREOS-4627'',
                 t1.FECHAMODIFICAR = SYSDATE';

  EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO VENTA CASO 3 MODIFICADO CORRECTAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;



  /* ALQUILER */

  /* CASO 1 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS NO PUBLICADOS ALQUILER A SIN TIPO DE PUBLICACIÓN');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epa.DD_EPA_CODIGO IN (''01'', ''04'')
              AND apu.DD_TPU_V_ID IS NOT NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
       
  V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
             USING(
                   SELECT apu.ACT_ID
                   FROM '||V_TEXT_TABLA||' apu
                   INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                   INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
                   INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                   WHERE tco.DD_TCO_CODIGO = ''02''
                   AND epa.DD_EPA_CODIGO IN (''01'', ''04'')
                   AND apu.DD_TPU_V_ID IS NOT NULL
             ) t2
             ON (t1.ACT_ID = t2.ACT_ID) 
             WHEN MATCHED THEN
             UPDATE SET
             t1.DD_TPU_V_ID = NULL,
             t1.USUARIOMODIFICAR = ''HREOS-4627'',
		 t1.FECHAMODIFICAR = SYSDATE';

      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ALQUILER CASO 1 MODIFICADO CORRECTAMENTE');

  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;


  /* CASO 2 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS PRE-PUBLICADO ALQUILER, PUBLICADO ALQUILER U OCULTO ALQUILER A TIPO DE PUBLICACIÓN ORDINARIO.');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epa.DD_EPA_CODIGO IN (''02'', ''03'', ''04'')
              AND apu.DD_TPU_V_ID IS NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
                  USING(
                        SELECT apu.ACT_ID
                        FROM '||V_TEXT_TABLA||' apu
                        INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                        INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
                        INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                        WHERE tco.DD_TCO_CODIGO = ''02''
                        AND epa.DD_EPA_CODIGO IN (''02'', ''03'', ''04'')
                        AND apu.DD_TPU_V_ID IS NULL
                  ) t2
                  ON (t1.ACT_ID = t2.ACT_ID) 
                  WHEN MATCHED THEN
                  UPDATE SET
                  t1.DD_TPU_V_ID = (SELECT DD_TPU_ID FROM '||V_TEXT_TABLA_PUB||' WHERE DD_TPU_CODIGO = ''01''),
                  t1.USUARIOMODIFICAR = ''HREOS-4627'',
                  t1.FECHAMODIFICAR = SYSDATE';

  EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ALQUILER CASO 2 MODIFICADO CORRECTAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;
  

  /* CASO 3 */
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TODOS LOS ACTIVOS PUBLICADO ALQUILER U OCULTO ALQUILER QUE NO TENGAN EL OK DE ADMISIÓN O GESTIÓN MARCADO A TIPO DE PUBLICACIÓN FORZADO.');

  V_MSQL :=  'SELECT count(apu.ACT_ID) AS numFilas
              FROM '||V_TEXT_TABLA||' apu
              INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
              INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
              INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
              WHERE tco.DD_TCO_CODIGO = ''02''
              AND epa.DD_EPA_CODIGO IN (''03'', ''04'')
              AND (act.ACT_ADMISION = ''1'' 
              OR act.ACT_GESTION = ''1'')
              AND apu.DD_TPU_V_ID IS NULL';

  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' t1
                  USING(
                        SELECT apu.ACT_ID
                        FROM '||V_TEXT_TABLA||' apu
                        INNER JOIN '||V_TEXT_TABLA_COMERZ||' tco ON apu.DD_TCO_ID = tco.DD_TCO_ID
                        INNER JOIN '||V_TEXT_TABLA_ALQUILER||'  epa ON apu.DD_EPA_ID = epa.DD_EPA_ID
                        INNER JOIN '||V_TEXT_TABLA_ACTIVO||' act ON apu.ACT_ID = act.ACT_ID
                        WHERE tco.DD_TCO_CODIGO = ''02''
                        AND epa.DD_EPA_CODIGO IN (''03'', ''04'')
                        AND (act.ACT_ADMISION = ''1'' 
                        OR act.ACT_GESTION = ''1'')
                        AND apu.DD_TPU_V_ID IS NULL
                  ) t2
                  ON (t1.ACT_ID = t2.ACT_ID) 
                  WHEN MATCHED THEN
                  UPDATE SET
                  t1.DD_TPU_V_ID = (SELECT DD_TPU_ID FROM '||V_TEXT_TABLA_PUB||' WHERE DD_TPU_CODIGO = ''02''),
                  t1.USUARIOMODIFICAR = ''HREOS-4627'',
                  t1.FECHAMODIFICAR = SYSDATE';

      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ALQUILER CASO 3 MODIFICADO CORRECTAMENTE');
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN REGISTROS CON ESTAS CARACTERISTICAS, NINGUN REGISTRO MODIFICADO');
  END IF;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO ACT_APU_ACTIVO_PUBLICACION ACTUALIZADO CORRECTAMENTE ');

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
