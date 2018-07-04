--/*
--##########################################
--## AUTOR=Salvador Puertes
--## FECHA_CREACION=20180704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.9.3
--## INCIDENCIA_LINK=HREOS-4251
--## PRODUCTO=NO
--##
--## Finalidad: INSERTA filas de TFI_TAREAS_FORM_ITEMS - Campo Aceptar y Ampliar para Liberbank en T004_AutorizacionPropietario
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    

BEGIN

  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando datos de TFI_TAREAS_FORM_ITEMS - Enlaces a pestañas para las tareas');

  V_SQL := '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_AutorizacionPropietario''
  ';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_ENLACES;

  IF V_NUM_ENLACES = 1 THEN

    V_SQL := '
      SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_AutorizacionPropietario''';
    EXECUTE IMMEDIATE V_SQL INTO V_ENTIDAD_ID;

    IF V_ENTIDAD_ID > 0 THEN

    V_SQL := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.tfi_tareas_form_items WHERE tfi_nombre = ''comboAmpliacionYAutorizacion'' AND TAP_ID='||V_ENTIDAD_ID;
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_ENLACES;

    IF V_NUM_ENLACES = 0 THEN

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' ||
              ' (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_BUSINESS_OPERATION, usuariocrear, fechacrear ) '||
              ' VALUES (
                  s_tfi_tareas_form_items.nextval,
                  '||V_ENTIDAD_ID||',
                  ''2'',
                  ''combo'',
                  ''comboAmpliacionYAutorizacion'',
                  ''Autoriza ejecuci&oacute;n trabajo y ampliaci&oacute;n de presupuesto en su caso'',
                  ''Debe indicar si se acepta la ampliaci&oacute;n del presupuesto'',
                  ''false'',
                  ''DDSiNo'',
                  ''HREOS-4251'',
                  SYSDATE
                  ) ';
      EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INSERT] INSERTANDO ENLACE - '||sql%rowcount); 
      DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN] Fila TFI insertada correctamente.');
    END IF;



    ELSE
      DBMS_OUTPUT.PUT_LINE('[ERROR] ID 0, VALOR NO VALIDO');
    END IF;

  ELSE
    DBMS_OUTPUT.PUT_LINE('[ERROR] Resultados inesperados, multiples resultados o valores inexistentes');
  END IF;

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