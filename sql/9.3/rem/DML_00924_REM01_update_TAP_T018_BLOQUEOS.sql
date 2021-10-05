--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15407
--## PRODUCTO=SI
--##
--## Finalidad: 
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        
		    T_TIPO_DATA('T018_DefinicionOferta', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkInquilinos() ? null : ''''Falta completar algunos datos obligatorios del inquilino'''''),
        T_TIPO_DATA('T018_AnalisisBc', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),
        T_TIPO_DATA('T018_Scoring', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'), 
        T_TIPO_DATA('T018_PbcAlquiler', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),
        T_TIPO_DATA('T018_ScoringBc', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),
        T_TIPO_DATA('T018_AnalisisTecnico', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),	
        T_TIPO_DATA('T018_ResolucionComite', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),	
        T_TIPO_DATA('T018_SolicitarGarantiasAdicionales', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),
        T_TIPO_DATA('T018_PteClRod', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),	
        T_TIPO_DATA('T018_TrasladarOfertaCliente', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),	
        T_TIPO_DATA('T018_RevisionBcYCondiciones', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null'),
        T_TIPO_DATA('T018_AgendarYFirmar', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null')       
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO ----------------------------
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ' INTO V_COUNT;
	
	    IF V_COUNT = 1 THEN
		  
	        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
	        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    		SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''HREOS-15407''
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' 
		        ';
			EXECUTE IMMEDIATE V_MSQL;
	    END IF;
	
	
	
	
	    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
	END LOOP;
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
