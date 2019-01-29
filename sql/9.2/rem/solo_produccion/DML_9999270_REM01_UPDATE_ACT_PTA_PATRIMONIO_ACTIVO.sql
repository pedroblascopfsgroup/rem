--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2850
--## PRODUCTO=NO
--## Finalidad:
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_PTA_PATRIMONIO_ACTIVO';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2850';
    
 BEGIN
 
      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
				SET DD_ADA_ID_ANTERIOR = (
				    SELECT DD_ADA_ID FROM DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = ''01''
				    ), USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
				WHERE ACT_ID IN (
				    SELECT ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU LEFT JOIN DD_MTO_MOTIVOS_OCULTACION MTO_A ON MTO_A.DD_MTO_ID = APU.DD_MTO_A_ID
				    WHERE MTO_A.DD_MTO_CODIGO = ''05''
				    )
				';
    				
      EXECUTE IMMEDIATE V_SQL;
      
	  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_TABLA||' actualizada correctamente ');
      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
