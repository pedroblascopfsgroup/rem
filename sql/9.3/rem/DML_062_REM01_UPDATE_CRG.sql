--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7822
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM NUMBER; 
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_ITI IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_ITI;
    V_TIPO_ITI T_ARRAY_TPO := T_ARRAY_TPO(
		T_TIPO_ITI('DD_SIC_ID2','ECO','VIG','01','01'),
		T_TIPO_ITI('DD_SIC_ID2','ECO','SAN','01','04'),
		T_TIPO_ITI('DD_SIC_ID2','ECO','NCN','02','07'),
		T_TIPO_ITI('DD_SIC_ID2','ECO','CAN','03','19'),
		T_TIPO_ITI('DD_SIC_ID','REG','VIG','01','01'),
		T_TIPO_ITI('DD_SIC_ID','REG','SAN','01','02'),
		T_TIPO_ITI('DD_SIC_ID','REG','NCN','02','21'),
		T_TIPO_ITI('DD_SIC_ID','REG','CAN','03','19')
    ); 
    V_TMP_TIPO_ITI T_TIPO_ITI;
    
BEGIN
	DBMS_OUTPUT.put_line('[INICIO PARTE 1 - Cargas Económicos/Resgitrales con Situación de la carga no nulo]');
	FOR I IN V_TIPO_ITI.FIRST .. V_TIPO_ITI.LAST
      LOOP
        V_TMP_TIPO_ITI := V_TIPO_ITI(I);
		
		DBMS_OUTPUT.put_line('Tipo de carga: '||V_TMP_TIPO_ITI(2)||', Situación de la carga: '||V_TMP_TIPO_ITI(3)||', Nuevo estado carga: '||V_TMP_TIPO_ITI(4)||', Nuevo subestado carga: '||V_TMP_TIPO_ITI(5));
		
		V_SQL:='MERGE INTO ACT_CRG_CARGAS T1
				USING (SELECT DISTINCT CRG.CRG_ID 
						FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
						JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR ON CAR.BIE_CAR_ID = CRG.BIE_CAR_ID
						JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC ON SIC.DD_SIC_ID = CAR.'||V_TMP_TIPO_ITI(1)||'
						JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA TCA ON TCA.DD_TCA_ID = CRG.DD_TCA_ID
						WHERE TCA.DD_TCA_CODIGO = '''||V_TMP_TIPO_ITI(2)||'''
						AND SIC.DD_SIC_CODIGO = '''||V_TMP_TIPO_ITI(3)||''') T2 
				ON (T1.CRG_ID = T2.CRG_ID)
				WHEN MATCHED THEN 
				UPDATE SET T1.DD_ECG_ID = (SELECT DD_ECG_ID FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_CARGA WHERE DD_ECG_CODIGO = '''||V_TMP_TIPO_ITI(4)||'''),
				T1.DD_SCG_ID = (SELECT DD_SCG_ID FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA WHERE DD_SCG_CODIGO = '''||V_TMP_TIPO_ITI(5)||'''),
				USUARIOMODIFICAR = ''HREOS-7822'',
				FECHAMODIFICAR = SYSDATE';
				
		EXECUTE IMMEDIATE V_SQL;
    END LOOP;
		DBMS_OUTPUT.put_line('[FIN PARTE 1]');
		
		DBMS_OUTPUT.put_line('[INICIO PARTE 2 - Cargas Económicos con Situación de la carga a null]');
		
		V_SQL:='MERGE INTO ACT_CRG_CARGAS T1
				USING (SELECT DISTINCT CRG.CRG_ID 
						FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
						JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR ON CAR.BIE_CAR_ID = CRG.BIE_CAR_ID
						JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA TCA ON TCA.DD_TCA_ID = CRG.DD_TCA_ID
						WHERE TCA.DD_TCA_CODIGO = ''ECO''
						AND CAR.DD_SIC_ID2 IS NULL) T2 
				ON (T1.CRG_ID = T2.CRG_ID)
				WHEN MATCHED THEN 
				UPDATE SET T1.DD_ECG_ID = NULL,
				T1.DD_SCG_ID = NULL,
				USUARIOMODIFICAR = ''HREOS-7822'',
				FECHAMODIFICAR = SYSDATE';
				
		EXECUTE IMMEDIATE V_SQL;	
		DBMS_OUTPUT.put_line('[FIN PARTE 2]');
		
		DBMS_OUTPUT.put_line('[INICIO PARTE 3 - Cargas Registrales con Situación de la carga a null]');
		
		V_SQL:='MERGE INTO ACT_CRG_CARGAS T1
				USING (SELECT DISTINCT CRG.CRG_ID 
						FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
						JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR ON CAR.BIE_CAR_ID = CRG.BIE_CAR_ID
						JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA TCA ON TCA.DD_TCA_ID = CRG.DD_TCA_ID
						WHERE TCA.DD_TCA_CODIGO = ''REG''
						AND CAR.DD_SIC_ID IS NULL) T2 
				ON (T1.CRG_ID = T2.CRG_ID)
				WHEN MATCHED THEN 
				UPDATE SET T1.DD_ECG_ID = NULL,
				T1.DD_SCG_ID = NULL,
				USUARIOMODIFICAR = ''HREOS-7822'',
				FECHAMODIFICAR = SYSDATE';
				
		EXECUTE IMMEDIATE V_SQL;	
		DBMS_OUTPUT.put_line('[FIN PARTE 3]');
	COMMIT;
	
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
