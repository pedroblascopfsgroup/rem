--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.2.0
--## INCIDENCIA_LINK=HREOS-5387
--## PRODUCTO=NO
--##
--## Finalidad: Script para sustituir el gestor actual de las configuraciones por las de una Excel adjunta en el item.
--## 			(Cambio en configuración de gestor de activo y supervisor de activo)
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
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'HREOS-5387'; 
    
BEGIN	
	
DBMS_OUTPUT.PUT_LINE('[INICIO] ');
DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TEXT_TABLA);
INSERT INTO REM01.ACT_GES_DIST_GESTORES
(
  ID
  , TIPO_GESTOR
  , COD_CARTERA
  , COD_TIPO_COMERZIALZACION
  , COD_PROVINCIA
  , USERNAME
  , NOMBRE_USUARIO
  , VERSION
  , USUARIOCREAR
  , FECHACREAR
  , BORRADO
)
SELECT 
  REM01.S_ACT_GES_DIST_GESTORES.NEXTVAL
  , 'HAYASBOINM' AS TIPO_GESTOR
  , AUX.DD_CRA_CODIGO
  , AUX.DD_TCR_CODIGO
  , AUX.DD_PRV_CODIGO
  , 'usugrubac'
  , (SELECT USU.USU_NOMBRE ||' '|| USU.USU_APELLIDO1 ||' '|| USU.USU_APELLIDO2 FROM REMMASTER.USU_USUARIOS USU WHERE USU.USU_USERNAME = 'usugrubac')
  , 0
  , 'HREOS-5387'
  , SYSDATE
  , 0
FROM (
      SELECT
      DD_CRA_CODIGO
      , DD_TCR_CODIGO 
      , DD_PRV_CODIGO
      FROM REM01.AUX_CARTERIAZA_HREOS_5387
      WHERE DD_TGE_CODIGO = 'HAYAGBOINM'
      GROUP BY 
      DD_CRA_CODIGO
      , DD_TCR_CODIGO
      , DD_PRV_CODIGO
     ) AUX;
DBMS_OUTPUT.PUT_LINE('FILAS INSERTADAS EN LA TABLA '||V_TEXT_TABLA||' ' ||SQL%ROWCOUNT);
COMMIT;
DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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
