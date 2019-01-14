--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2033
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el flag CRG_CARGAS_PROPIAS de las cargas de liberbank.
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CRG_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-2033';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	EXECUTE IMMEDIATE 
    'MERGE INTO REM01.ACT_CRG_CARGAS CRG
	USING (
		SELECT distinct
			   CRG.CRG_ID,
			   CASE WHEN AUX.OK_PROPIA_REM = ''propia en REM'' THEN 1
					WHEN AUX.OK_PROPIA_REM = ''no propia en REM'' THEN 0
					ELSE NULL
			   END AS FLAG_CARGAS
		FROM REM01.AUX_MMC_FLAG_CARGAS_LIBER   AUX
		JOIN REM01.ACT_ACTIVO                  ACT
		  ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		JOIN REM01.ACT_CRG_CARGAS              CRG
		  ON CRG.ACT_ID = ACT.ACT_ID
		JOIN REM01.BIE_CAR_CARGAS              CAR
		 ON CAR.BIE_CAR_ID = CRG.BIE_CAR_ID
		AND CAR.BIE_CAR_IMPORTE_REGISTRAL = AUX.BIE_CAR_IMPORTE_REGISTRAL
	) T2
	ON (T2.CRG_ID = CRG.CRG_ID)
	WHEN MATCHED THEN UPDATE
	SET
		CRG.CRG_CARGAS_PROPIAS = T2.FLAG_CARGAS,
		CRG.USUARIOMODIFICAR = ''REMVIP-2033'',
		CRG.FECHAMODIFICAR = SYSDATE
    ';   
    DBMS_OUTPUT.PUT_LINE('[INFO]: Updateamos '||SQL%ROWCOUNT||' registros en la ACT_CRG_CARGAS');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACTUALIZADA CORRECTAMENTE ');


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
