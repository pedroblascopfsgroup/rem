--/*
--##########################################
--## AUTOR= Ys
--## FECHA_CREACION=20220201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10942
--## PRODUCTO=NO
--##
--## Finalidad: dar de baja representantes de compradores dados de baja
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CEX_COMPRADOR_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(250 CHAR) := 'REMVIP-10942';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('40','20')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

 V_TMP_TIPO_DATA := V_TIPO_DATA(1);

         V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING(
                        SELECT CEX.COM_ID, CEX.ECO_ID,CEX.DD_EIC_ID, CEX.DD_EIC_REPR_ID  FROM '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX
                        WHERE CEX.DD_EIC_ID IN(
                        SELECT EIC.DD_EIC_ID FROM '||V_ESQUEMA||'.DD_EIC_ESTADO_INTERLOCUTOR EIC WHERE EIC.DD_EIC_CODIGO IN ('''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''')
                        )
                        AND CEX.CEX_DOCUMENTO_RTE IS NOT NULL
                        AND (CEX.DD_EIC_REPR_ID NOT IN (
                        SELECT EIC.DD_EIC_ID FROM '||V_ESQUEMA||'.DD_EIC_ESTADO_INTERLOCUTOR EIC WHERE EIC.DD_EIC_CODIGO IN ('''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''')
                        ) OR CEX.DD_EIC_REPR_ID IS NULL)
                        ) T2
					    ON (T1.COM_ID = T2.COM_ID AND T1.ECO_ID = T2.ECO_ID)
					WHEN MATCHED THEN UPDATE SET
					T1.dd_eic_repr_id = T2.dd_eic_id,
					T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
					T1.FECHAMODIFICAR = SYSDATE';

   	  	DBMS_OUTPUT.PUT_LINE(V_MSQL);


   	  	EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('[INFO] - Actualizadas '||SQL%ROWCOUNT||' filas.');


  COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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




