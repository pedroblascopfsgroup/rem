--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=p2.0.6-170728
--## INCIDENCIA_LINK=HREOS-2112
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TPD_TTR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                  --DD_TTR_CODIGO      DD_TPD_CODIGO
       T_TIPO_DATA('03',              '19'), -- ACTUACIÓN TÉCNICA -> Informe del trabajo realizado.
       T_TIPO_DATA('03',              '01'), -- ACTUACIÓN TÉCNICA -> Informes
       T_TIPO_DATA('03',              '18'), -- ACTUACIÓN TÉCNICA -> Presupuesto
       T_TIPO_DATA('03',              '26'), -- ACTUACIÓN TÉCNICA -> Respuesta propietario incremento de presupuesto
       T_TIPO_DATA('02',              '15'), -- OBTENCIÓN DOCUMENTACIÓN -> Boletín de agua.
       T_TIPO_DATA('02',              '16'), -- OBTENCIÓN DOCUMENTACIÓN -> Boletín electricidad.
       T_TIPO_DATA('02',              '17'), -- OBTENCIÓN DOCUMENTACIÓN -> Boletín de gas.
       T_TIPO_DATA('02',              '13'), -- OBTENCIÓN DOCUMENTACIÓN -> Cédula de habitabilidad.
       T_TIPO_DATA('02',              '27'), -- OBTENCIÓN DOCUMENTACIÓN -> Certificado sustitutivo de Cédula de Habitabilidad
       T_TIPO_DATA('02',              '11'), -- OBTENCIÓN DOCUMENTACIÓN -> CEE (Certificado de eficiencia energética).
       T_TIPO_DATA('02',              '24'), -- OBTENCIÓN DOCUMENTACIÓN -> CEE (Justificante de presentación en registro)
       T_TIPO_DATA('02',              '25'), -- OBTENCIÓN DOCUMENTACIÓN -> CEE (Etiqueta de Eficiencia Energética)
       T_TIPO_DATA('02',              '14'), -- OBTENCIÓN DOCUMENTACIÓN -> CFO (Certificado de final de obra).
       T_TIPO_DATA('02',              '02'), -- OBTENCIÓN DOCUMENTACIÓN -> Decreto de adjudicación.
       -- T_TIPO_DATA('02',              ''), -- OBTENCIÓN DOCUMENTACIÓN -> Diligencia toma posesión.
       T_TIPO_DATA('02',              '03'), -- OBTENCIÓN DOCUMENTACIÓN -> Escritura pública inscrita.
       T_TIPO_DATA('02',              '01'), -- OBTENCIÓN DOCUMENTACIÓN -> Informes.
       T_TIPO_DATA('02',              '12'), -- OBTENCIÓN DOCUMENTACIÓN -> LPO (Licencia de primera ocupación).
       T_TIPO_DATA('02',              '06'), -- OBTENCIÓN DOCUMENTACIÓN -> Nota simple actualizada.
       T_TIPO_DATA('02',              '05'), -- OBTENCIÓN DOCUMENTACIÓN -> Nota simple sin cargas.
       T_TIPO_DATA('02',              '04'), -- OBTENCIÓN DOCUMENTACIÓN -> Posesión: Acta de lanzamiento
       T_TIPO_DATA('02',              '26'), -- OBTENCIÓN DOCUMENTACIÓN -> Respuesta (a) propietario (de) incremento de presupuesto
       T_TIPO_DATA('02',              '07'), -- OBTENCIÓN DOCUMENTACIÓN -> Tasación adjudicación.
       T_TIPO_DATA('02',              '09'), -- OBTENCIÓN DOCUMENTACIÓN -> VPO: Notificación adjudicación para tanteo.
       T_TIPO_DATA('02',              '08'), -- OBTENCIÓN DOCUMENTACIÓN -> VPO: Solicitud autorización venta.
       T_TIPO_DATA('02',              '10'), -- OBTENCIÓN DOCUMENTACIÓN -> VPO: Solicitud importe devolución ayudas.
       T_TIPO_DATA('04',              '21'), -- PRECIOS -> Propuesta de precios inicial (generada)
       T_TIPO_DATA('04',              '22'), -- PRECIOS -> Propuesta enviada al propietario
       T_TIPO_DATA('04',              '23'), -- PRECIOS -> Propuesta sancionada
       T_TIPO_DATA('04',              '20')  -- PRECIOS -> Listado de actualización de precios
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  -- LOOP para insertar los valores --
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ' || V_TEXT_TABLA);

  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      -- Se modifican los registros que coincidan con los códigos del array.
      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR REGISTROS '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

      V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.' || V_TEXT_TABLA || ' (DD_TPD_ID, DD_TTR_ID, VERSION)' ||
      ' SELECT DD_TPD_ID, DD_TTR_ID, 01 FROM ' || V_ESQUEMA || '.DD_TPD_TIPO_DOCUMENTO TPD, ' || V_ESQUEMA || '.DD_TTR_TIPO_TRABAJO TTR WHERE DD_TPD_CODIGO = ''' || TRIM(V_TMP_TIPO_DATA(2)) || ''' AND DD_TTR_CODIGO = ''' || TRIM(V_TMP_TIPO_DATA(1)) || ''' ' ||
      ' AND NOT EXISTS (SELECT 1 FROM ' || V_ESQUEMA || '.' || V_TEXT_TABLA || ' DD  WHERE DD.DD_TPD_ID = TPD.DD_TPD_ID AND  DD.DD_TTR_ID = TTR.DD_TTR_ID )';

      EXECUTE IMMEDIATE V_MSQL;

    END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
