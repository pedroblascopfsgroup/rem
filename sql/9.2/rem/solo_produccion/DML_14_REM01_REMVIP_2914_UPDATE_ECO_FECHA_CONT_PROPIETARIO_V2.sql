--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20181228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2914
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2914';
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_RECOVERY_ID_MALO NUMBER(16);
    ACT_RECOVERY_ID_BUENO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('107401','17/05/18'),
		T_JBV('127234','19/11/18'),
		T_JBV('131270','11/12/18'),
		T_JBV('131191','21/11/18'),
		T_JBV('131364','03/12/18'),
		T_JBV('133780','22/11/18'),
		T_JBV('129608','19/11/18'),
		T_JBV('118210','29/11/18'),
		T_JBV('131303','27/11/18'),
		T_JBV('131109','26/11/18'),
		T_JBV('135770','22/11/18'),
		T_JBV('133831','12/12/18'),
		T_JBV('136814','30/11/18'),
		T_JBV('139817','03/12/18'),
		T_JBV('133088','29/11/18'),
		T_JBV('136990','14/12/18'),
		T_JBV('141972','17/12/18'),
		T_JBV('137243','12/12/18'),
		T_JBV('137491','12/12/18'),
		T_JBV('107404','17/05/18'),
		T_JBV('107415','17/05/18'),
		T_JBV('104709','08/05/18'),
		T_JBV('128616','11/10/18'),
		T_JBV('129886','22/11/18'),
		T_JBV('133930','29/11/18'),
		T_JBV('134590','10/12/18'),
		T_JBV('129978','07/12/18'),
		T_JBV('130090','23/11/18'),
		T_JBV('134310','28/11/18'),
		T_JBV('129713','27/11/18'),
		T_JBV('128415','28/11/18'),
		T_JBV('134301','04/12/18'),
		T_JBV('134909','28/11/18'),
		T_JBV('133493','04/12/18'),
		T_JBV('136949','13/12/18'),
		T_JBV('107396','17/05/18'),
		T_JBV('106733','13/12/18'),
		T_JBV('137213','04/12/18'),
		T_JBV('134991','05/12/18'),
		T_JBV('106296','20/07/18'),
		T_JBV('113511','01/08/18'),
		T_JBV('121194','30/11/18'),
		T_JBV('131511','23/11/18'),
		T_JBV('127722','20/11/18'),
		T_JBV('130492','28/11/18'),
		T_JBV('127081','18/12/18'),
		T_JBV('133512','27/11/18'),
		T_JBV('139874','03/12/18'),
		T_JBV('132388','29/11/18'),
		T_JBV('136632','13/12/18'),
		T_JBV('107510','17/05/18'),
		T_JBV('132265','28/11/18'),
		T_JBV('131480','19/11/18'),
		T_JBV('134468','10/12/18'),
		T_JBV('126852','29/11/18'),
		T_JBV('130985','19/11/18'),
		T_JBV('134464','27/11/18'),
		T_JBV('130751','23/11/18'),
		T_JBV('136483','29/11/18'),
		T_JBV('127759','27/11/18'),
		T_JBV('134293','07/12/18'),
		T_JBV('141913','18/12/18'),
		T_JBV('104055','17/04/18'),
		T_JBV('126589','10/12/18'),
		T_JBV('102094','29/03/18'),
		T_JBV('127792','20/11/18'),
		T_JBV('135242','28/11/18'),
		T_JBV('127507','22/11/18'),
		T_JBV('132308','19/11/18'),
		T_JBV('130559','28/11/18'),
		T_JBV('133720','21/11/18'),
		T_JBV('126053','22/11/18'),
		T_JBV('107392','17/05/18'),
		T_JBV('136110','14/12/18'),
		T_JBV('101930','29/03/18'),
		T_JBV('102561','23/03/18'),
		T_JBV('107428','29/06/18'),
		T_JBV('134120','26/11/18'),
		T_JBV('134654','20/11/18'),
		T_JBV('131195','22/11/18'),
		T_JBV('132089','30/11/18'),
		T_JBV('132549','26/11/18'),
		T_JBV('138930','28/11/18'),
		T_JBV('130650','18/12/18'),
		T_JBV('135755','04/12/18'),
		T_JBV('108561','27/11/18'),
		T_JBV('115955','27/07/18'),
		T_JBV('94557','08/03/18'),
		T_JBV('127025','06/11/18'),
		T_JBV('131011','19/11/18'),
		T_JBV('127058','19/11/18'),
		T_JBV('134846','23/11/18'),
		T_JBV('133735','29/11/18'),
		T_JBV('135620','10/12/18'),
		T_JBV('133621','07/12/18'),
		T_JBV('77538','21/02/18'),
		T_JBV('107414','17/05/18'),
		T_JBV('107403','17/05/18'),
		T_JBV('102154','29/03/18'),
		T_JBV('127241','20/11/18'),
		T_JBV('130081','23/11/18'),
		T_JBV('130754','22/11/18'),
		T_JBV('135418','23/11/18'),
		T_JBV('127296','19/11/18'),
		T_JBV('130215','21/11/18'),
		T_JBV('134168','29/11/18'),
		T_JBV('136931','29/11/18'),
		T_JBV('133112','28/11/18'),
		T_JBV('136487','11/12/18'),
		T_JBV('140492','05/12/18')
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
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el expediente '||V_TMP_JBV(1)||' con fecha '||V_TMP_JBV(2)||'');
  
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

