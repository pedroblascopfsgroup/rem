--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3380
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3380';
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_RECOVERY_ID_MALO NUMBER(16);
    ACT_RECOVERY_ID_BUENO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('115784','27/12/18'),
		T_JBV('130557','26/12/18'),
		T_JBV('139059','19/12/18'),
		T_JBV('134254','21/12/18'),
		T_JBV('137555','19/12/18'),
		T_JBV('132939','19/12/18'),
		T_JBV('137984','19/12/18'),
		T_JBV('132839','21/12/18'),
		T_JBV('139817','03/12/18'),
		T_JBV('142605','26/12/18'),
		T_JBV('143011','19/12/18'),
		T_JBV('139659','19/12/18'),
		T_JBV('139329','19/12/18'),
		T_JBV('141972','17/12/18'),
		T_JBV('112146','19/12/18'),
		T_JBV('114660','21/12/18'),
		T_JBV('139077','26/12/18'),
		T_JBV('136990','14/12/18'),
		T_JBV('134003','20/12/18'),
		T_JBV('135108','21/12/18'),
		T_JBV('143667','26/12/18'),
		T_JBV('143411','19/12/18'),
		T_JBV('142358','19/12/18'),
		T_JBV('139996','19/12/18'),
		T_JBV('135266','27/12/18'),
		T_JBV('137858','21/12/18'),
		T_JBV('136356','21/12/18'),
		T_JBV('135269','20/12/18'),
		T_JBV('139310','27/12/18'),
		T_JBV('141948','27/12/18'),
		T_JBV('141141','19/12/18'),
		T_JBV('139075','21/12/18'),
		T_JBV('137776','21/12/18'),
		T_JBV('138394','20/12/18'),
		T_JBV('138566','20/12/18'),
		T_JBV('133709','19/12/18'),
		T_JBV('139672','21/12/18'),
		T_JBV('140323','26/12/18'),
		T_JBV('110033','21/12/18'),
		T_JBV('130346','19/12/18'),
		T_JBV('136311','21/12/18'),
		T_JBV('139053','19/12/18'),
		T_JBV('134991','05/12/18'),
		T_JBV('134545','20/12/18'),
		T_JBV('135600','19/12/18'),
		T_JBV('140225','21/12/18'),
		T_JBV('107415','17/05/18'),
		T_JBV('111485','27/12/18'),
		T_JBV('108561','27/11/18'),
		T_JBV('139699','21/12/18'),
		T_JBV('139779','19/12/18'),
		T_JBV('107404','17/05/18'),
		T_JBV('136227','27/12/18'),
		T_JBV('137014','26/12/18'),
		T_JBV('139058','19/12/18'),
		T_JBV('137777','20/12/18'),
		T_JBV('138431','27/12/18'),
		T_JBV('132767','19/12/18'),
		T_JBV('126215','21/12/18'),
		T_JBV('141679','19/12/18'),
		T_JBV('134646','19/12/18'),
		T_JBV('135701','26/12/18'),
		T_JBV('139057','19/12/18'),
		T_JBV('138217','19/12/18'),
		T_JBV('137778','27/12/18'),
		T_JBV('134005','20/12/18'),
		T_JBV('126361','21/12/18'),
		T_JBV('136914','21/12/18'),
		T_JBV('131394','26/12/18'),
		T_JBV('140578','19/12/18')
	 	);   
    V_TMP_JBV T_JBV;
    
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);
    
  
    		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
							ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||V_TMP_JBV(2)||''',''DD/MM/RR''),
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE 
						WHERE ECO_NUM_EXPEDIENTE = '||V_TMP_JBV(1)||'
					)';	  
	
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el expediente '||V_TMP_JBV(1)||'');
  
  V_COUNT_INSERT := V_COUNT_INSERT + 1;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);
  
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

