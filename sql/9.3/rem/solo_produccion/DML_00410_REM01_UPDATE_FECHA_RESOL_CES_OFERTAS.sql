--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7880
--## PRODUCTO=NO
--## 
--## Finalidad: Script que actualizar fecha alta ofertas
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
    V_TABLA VARCHAR2(25 CHAR):= 'OFR_OFERTAS';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7880';    

    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR FECHA OFERTAS ');

   
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
				  SET OFR_FECHA_RESOLUCION_CES = TO_DATE(''16/12/2019'', ''DD/MM/YYYY'')
				     ,USUARIOMODIFICAR = '''||V_USUARIO||'''
				     ,FECHAMODIFICAR = SYSDATE
				  WHERE OFR_NUM_OFERTA IN (90233586, 90233072,90233080)';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('MODIFICADA FECHA DE OFERTAS');
		
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');
   

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
