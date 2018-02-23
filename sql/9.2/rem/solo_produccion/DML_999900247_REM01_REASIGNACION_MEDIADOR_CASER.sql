--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20180223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-125
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambai el mediador de los activos derl Array a CASER
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';--'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';--'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
        
    V_MEDIADOR NUMBER(10) := 10004311; -- Vble. auxiliar
    V_MEDIADOR_ID NUMBER(10);
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    EXECUTE IMMEDIATE 'SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '||V_MEDIADOR||'' INTO V_MEDIADOR_ID;
         
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION DE LOS ACTIVOS PARA EL MEDIADOR CASER ');

    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL
      SET ICO_MEDIADOR_ID = '||V_MEDIADOR_ID||',
          USUARIOMODIFICAR = ''REMVIP-125'',
          FECHAMODIFICAR = SYSDATE
      WHERE ACT_ID IN (
        SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO 
          WHERE ACT_NUM_ACTIVO IN (6841482,
            6840016,
            6840020,
            6840015,
            6840018,
            6840019,
            6831681,
            6831689,
            6779872,
            6779875,
            6779879,
            6762263,
            6762378,
            6762215,
            6762351,
            6762352,
            6762338,
            6762311,
            6762297,
            6762299,
            6762269,
            6762270,
            6762255,
            6762241,
            6762219,
            6762216,
            6762217,
            6762222,
            6762199,
            6762381,
            6762373,
            6762370,
            6762321,
            6762237,
            6762331,
            6762286,
            6762230,
            6762210,
            6762283,
            6762284,
            6831684,
            6044345,
            6084923,
            6044156,
            6044065,
            6044139,
            6044059,
            6044233,
            6044099,
            6044021,
            6044182,
            6044098,
            6044081,
            6044225,
            6044036,
            6044199,
            6840017,
            6831688,
            6817105,
            6817110,
            6810469
            )
        )';
    
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN ACTUALIZADO LOS '||SQL%ROWCOUNT||' ACTIVOS CORRECTAMENTE ');
    COMMIT;
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