--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16597
--## PRODUCTO=NO
--##
--## Finalidad:  
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-16597';
    
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    V_TABLA_AUX VARCHAR2(30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

BEGIN

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TABLA_AUX||''' AND OWNER ='''||V_ESQUEMA||''' ';
   
   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio de la anulación de venta');

    
            V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
                        SET ACT_VENTA_EXTERNA_FECHA = TO_DATE(''13/07/2022'', ''DD/MM/YYYY'')
                            ,ACT_VENTA_EXTERNA_IMPORTE = 1
                            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_ANT FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO)';
            EXECUTE IMMEDIATE V_SQL;
  
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar los checks de los activos vendidos');

    --Se actualizan los checks de los activos vendidos
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
                SET PAC_CHECK_PUBLICAR = 0,
                    PAC_FECHA_PUBLICAR = SYSDATE,
                    PAC_CHECK_COMERCIALIZAR = 0,
                    PAC_FECHA_COMERCIALIZAR = SYSDATE,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                WHERE EXISTS (
                    SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
                    JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                    WHERE T1.ACT_ID = ACT.ACT_ID)
                             ';
             EXECUTE IMMEDIATE V_SQL; 


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: IMPORTES ACTUALIZADOS CORRECTAMENTE ');

    ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] La tabla '||V_TABLA_AUX||' no existe.');
	END IF;

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
