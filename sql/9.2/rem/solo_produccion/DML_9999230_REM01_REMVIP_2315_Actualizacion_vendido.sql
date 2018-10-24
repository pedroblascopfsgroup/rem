--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2315
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-2315';    

    
BEGIN	
    
    
	V_SQL := 'MERGE INTO rem01.ACT_ACTIVO ACT
			USING (

			    SELECT act.ACT_ID, ACT.ACT_NUM_ACTIVO, ACT.FECHACREAR 
			    FROM REM01.ACT_ACTIVO ACT
			    JOIN REM01.TMP_BOLT_INVICTUS TMP ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO
			    WHERE ACT.FECHACREAR >= to_date(''19/10/18'',''DD/MM/YY'')

			  ) ORIGEN
			ON (ACT.ACT_ID = ORIGEN.ACT_ID)
			WHEN MATCHED THEN
			UPDATE SET 
			        ACT.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = 05),
			        ACT.USUARIOMODIFICAR = ''REMVIP-2315'',
			        ACT.FECHAMODIFICAR = SYSDATE';
				 			  
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla ACT_ACTIVO');


	V_SQL := 'MERGE INTO rem01.ACT_PAC_PERIMETRO_ACTIVO PAC
			USING (

			    SELECT ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, PAC.PAC_CHECK_COMERCIALIZAR, PAC.PAC_CHECK_FORMALIZAR 
			    FROM REM01.ACT_ACTIVO ACT
			    JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID =  ACT.ACT_ID
			    JOIN REM01.TMP_BOLT_INVICTUS TMP ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO
			    WHERE ACT.FECHACREAR >= to_date(''19/10/18'',''DD/MM/YY'')

			  ) ORIGEN
			ON (PAC.ACT_ID = ORIGEN.ACT_ID)
			WHEN MATCHED THEN
			UPDATE SET 
			        PAC.PAC_CHECK_COMERCIALIZAR = 0,
			        PAC.PAC_CHECK_FORMALIZAR = 0,
			        PAC.USUARIOMODIFICAR = ''REMVIP-2315'',
			        PAC.FECHAMODIFICAR = SYSDATE';
				 			  
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla ACT_PAC_PERIMETRO_ACTIVO');


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

