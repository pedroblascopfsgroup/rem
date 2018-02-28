--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=HREOS-3783
--## PRODUCTO=NO
--##
--## Finalidad: Introducir gestores
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
   V_COUNT NUMBER(16); -- Vble. para contar.
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
   V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-3783';
   TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
   V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      --          V_TMP_TIPO_DATA(1)   V_TMP_TIPO_DATA(2)   V_TMP_TIPO_DATA(3)   V_TMP_TIPO_DATA(4)
      T_TIPO_DATA('GGADM'              ,'3'                 ,'12'                ,'garsa01'),
      T_TIPO_DATA('GGADM'              ,'3'                 ,'30'                ,'montalvo01'),
      T_TIPO_DATA('GIAFORM'            ,'3'                 ,'12'                ,'garsa03'),
      T_TIPO_DATA('GIAFORM'            ,'3'                 ,'30'                ,'montalvo03'));
   V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');
   FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP  
         V_TMP_TIPO_DATA := V_TIPO_DATA(I);

         V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
            USING (SELECT '''||V_TMP_TIPO_DATA(1)||''' TIPO_GESTOR, '||V_TMP_TIPO_DATA(2)||' COD_CARTERA
                  , '||V_TMP_TIPO_DATA(3)||' COD_PROVINCIA, '''||V_TMP_TIPO_DATA(4)||''' USERNAME
               FROM DUAL) T2
            ON (T1.TIPO_GESTOR = T2.TIPO_GESTOR AND T1.COD_CARTERA = T2.COD_CARTERA
               AND T1.COD_PROVINCIA = T2.COD_PROVINCIA)
            WHEN MATCHED THEN UPDATE SET
               T1.USERNAME = T2.USERNAME, T1.USUARIOMODIFICAR = ''HREOS-3783'', T1.FECHAMODIFICAR = SYSDATE
            WHERE T1.USERNAME <> T2.USERNAME
            WHEN NOT MATCHED THEN INSERT (T1.ID, T1.TIPO_GESTOR, T1.COD_CARTERA, T1.COD_PROVINCIA, T1.USERNAME,  T1.USUARIOCREAR, T1.FECHACREAR)
               VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, T2.TIPO_GESTOR, T2.COD_CARTERA, T2.COD_PROVINCIA, T2.USERNAME, ''HREOS-3783'', SYSDATE)';
         EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
   
   DBMS_OUTPUT.PUT_LINE('  [INFO] Gestores actualizados');
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;