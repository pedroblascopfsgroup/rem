--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7198
--## PRODUCTO=NO
--##
--## Finalidad: script para añadir comunicacion entorno comunicaciones
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7198'; -- USUARIOCREAR/USUARIOMODIFICAR.
    NUM_ACT NUMBER(16);
    INS_CALEF NUMBER(1);
    INS_CALEF_CENTRAL NUMBER(1);
    INS_CALEF_GAS NUMBER(1);
    ACT_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--act_num_activo, descripcion

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

	T_JBV(7265168,1,0,0),
	T_JBV(7265155,1,0,0),
	T_JBV(7265162,1,0,0),
	T_JBV(7265163,1,0,0),
	T_JBV(7265165,1,0,0),
	T_JBV(7265167,1,0,0),
	T_JBV(7265174,1,0,0),
	T_JBV(7265175,1,0,0),
	T_JBV(7257184,1,0,0),
	T_JBV(7284216,1,0,0),
	T_JBV(7284215,1,0,0),
	T_JBV(7262719,1,0,0),
	T_JBV(7265277,1,0,0),
	T_JBV(7278504,1,0,0),
	T_JBV(7254758,1,0,0),
	T_JBV(7240393,1,0,0),
	T_JBV(7237250,1,0,0),
	T_JBV(7267049,1,0,0),
	T_JBV(7239413,1,0,0),
	T_JBV(7239414,1,0,0),
	T_JBV(7239415,1,0,0),
	T_JBV(7239416,1,0,0),
	T_JBV(7241736,1,0,0),
	T_JBV(7263639,1,0,0),
	T_JBV(7266234,1,0,0),
	T_JBV(7237342,1,0,0),
	T_JBV(7238054,1,0,0),
	T_JBV(7255079,1,0,0),
	T_JBV(7281216,1,0,0),
	T_JBV(7245606,1,0,0),
	T_JBV(7236701,1,0,0),
	T_JBV(7237210,1,0,0),
	T_JBV(7282916,1,0,0),
	T_JBV(7250222,1,0,0),
	T_JBV(7267426,1,0,0),
	T_JBV(7280021,1,0,0),
	T_JBV(7280022,1,0,0),
	T_JBV(7269237,1,0,0),
	T_JBV(7259099,1,0,0),
	T_JBV(7265164,1,0,0),
	T_JBV(7265176,1,0,0),
	T_JBV(7265153,1,0,0),
	T_JBV(7265158,1,0,0),
	T_JBV(7264203,1,0,0),
	T_JBV(7238942,1,0,0),
	T_JBV(7290019,1,0,0),
	T_JBV(7265150,1,0,0),
	T_JBV(7248253,1,0,0),
	T_JBV(7231643,1,0,0),
	T_JBV(7268859,1,0,0),
	T_JBV(7240852,1,0,0),
	T_JBV(7282459,1,0,0),
	T_JBV(7252446,1,0,0),
	T_JBV(7236759,1,0,0),
	T_JBV(7258447,1,0,0),
	T_JBV(7262711,1,0,0),
	T_JBV(7282388,1,0,0),
	T_JBV(7233010,1,0,0),
	T_JBV(7247192,1,0,0),
	T_JBV(7265725,1,0,0),
	T_JBV(7265724,1,0,0),
	T_JBV(7244908,1,0,0),
	T_JBV(7262989,1,0,0),
	T_JBV(7242715,1,0,0),
	T_JBV(7241612,1,0,0),
	T_JBV(7265722,1,0,0),
	T_JBV(7265726,1,0,0),
	T_JBV(7231242,1,0,0),
	T_JBV(7265723,1,0,0),
	T_JBV(7239594,1,0,0),
	T_JBV(7247651,1,0,0),
	T_JBV(7265145,1,0,0),
	T_JBV(7265147,1,0,0),
	T_JBV(7265154,1,0,0),
	T_JBV(7265160,1,0,0),
	T_JBV(7265143,1,0,0),
	T_JBV(7265149,1,0,0),
	T_JBV(7265144,1,0,0),
	T_JBV(7265169,1,0,0),
	T_JBV(7265170,1,0,0),
	T_JBV(7265171,1,0,0),
	T_JBV(7265172,1,0,0),
	T_JBV(7265173,1,0,0),
	T_JBV(7244863,1,0,0),
	T_JBV(7245932,1,0,0),
	T_JBV(7252473,1,0,0),
	T_JBV(7281035,1,0,0),
	T_JBV(7266825,1,0,0),
	T_JBV(7265156,1,0,0),
	T_JBV(7265247,1,0,0),
	T_JBV(7264657,1,0,0),
	T_JBV(7264651,1,0,0),
	T_JBV(7238110,1,0,0),
	T_JBV(7241927,1,0,0),
	T_JBV(7241928,1,0,0),
	T_JBV(7241929,1,0,0),
	T_JBV(7241930,1,0,0),
	T_JBV(7241931,1,0,0),
	T_JBV(7265708,1,0,0),
	T_JBV(7245327,1,0,0),
	T_JBV(7257026,1,0,0),
	T_JBV(7280894,1,0,0),
	T_JBV(7246561,1,0,0),
	T_JBV(7250511,1,0,0),
	T_JBV(7237360,1,0,0),
	T_JBV(7247265,1,0,0),
	T_JBV(7280450,1,0,0),
	T_JBV(7264650,1,0,0),
	T_JBV(7264649,1,0,0),
	T_JBV(7246128,1,0,0),
	T_JBV(7248575,1,0,0),
	T_JBV(7255633,1,0,0),
	T_JBV(7256030,1,0,0),
	T_JBV(7243082,1,0,0),
	T_JBV(7236513,1,0,0),
	T_JBV(7262111,1,0,0),
	T_JBV(7240579,1,0,0),
	T_JBV(7233641,1,0,0),
	T_JBV(7243971,1,0,0),
	T_JBV(7257592,1,0,0),
	T_JBV(7264646,1,0,0),
	T_JBV(7261826,1,0,0),
	T_JBV(7233397,1,0,0),
	T_JBV(7248020,1,0,0),
	T_JBV(7230518,1,0,0),
	T_JBV(7257342,1,0,0),
	T_JBV(7244926,1,0,0),
	T_JBV(7249096,1,0,0),
	T_JBV(7268706,1,0,0),
	T_JBV(7248565,1,0,0),
	T_JBV(7277000,1,0,0),
	T_JBV(7266997,1,0,0),
	T_JBV(7258632,1,0,0),
	T_JBV(7246822,1,0,0),
	T_JBV(7277838,1,0,0),
	T_JBV(7277839,1,0,0),
	T_JBV(7240884,1,0,0),
	T_JBV(7266725,1,0,0),
	T_JBV(7257066,1,0,0),
	T_JBV(7249513,1,0,0),
	T_JBV(7250467,1,0,0),
	T_JBV(7257126,1,0,0),
	T_JBV(7264200,1,0,0),
	T_JBV(7264202,1,0,0),
	T_JBV(7264205,1,0,0),
	T_JBV(7263088,1,0,0),
	T_JBV(7241947,1,0,0),
	T_JBV(7264204,1,0,0),
	T_JBV(7243446,1,0,0),
	T_JBV(7277034,1,0,0),
	T_JBV(7265096,1,0,0),
	T_JBV(7265140,1,0,0),
	T_JBV(7265142,1,0,0),
	T_JBV(7255329,1,0,0),
	T_JBV(7237803,1,0,0),
	T_JBV(7247111,1,0,0),
	T_JBV(7245135,1,0,0),
	T_JBV(7239187,1,0,0),
	T_JBV(7244096,1,0,0),
	T_JBV(7246393,1,0,0),
	T_JBV(7263492,1,0,0),
	T_JBV(7242716,1,0,0),
	T_JBV(7243104,1,0,0),
	T_JBV(7249761,1,0,0),
	T_JBV(7282659,1,0,0),
	T_JBV(7264654,1,0,0),
	T_JBV(7260361,1,0,0),
	T_JBV(7263613,1,0,0),
	T_JBV(7257868,1,0,0),
	T_JBV(7240652,1,0,0),
	T_JBV(7281842,1,0,0),
	T_JBV(7238246,1,0,0),
	T_JBV(7261118,1,0,0),
	T_JBV(7252036,1,0,0),
	T_JBV(7265178,1,0,0),
	T_JBV(7258673,1,0,0),
	T_JBV(7265182,1,0,0),
	T_JBV(7265183,1,0,0),
	T_JBV(7265184,1,0,0),
	T_JBV(7261120,1,0,0),
	T_JBV(7251964,1,0,0),
	T_JBV(7252076,1,0,0),
	T_JBV(7243609,1,0,0),
	T_JBV(7256724,1,0,0),
	T_JBV(7265179,1,0,0),
	T_JBV(7265180,1,0,0),
	T_JBV(7255379,1,0,0),
	T_JBV(7265181,1,0,0),
	T_JBV(7239189,1,0,0)

		); 
	V_TMP_JBV T_JBV;

BEGIN	
    -- LOOP Insertando 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos en la tabla');

    FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	NUM_ACT := TRIM(V_TMP_JBV(1));
	INS_CALEF := TRIM(V_TMP_JBV(2));
    	INS_CALEF_CENTRAL := TRIM(V_TMP_JBV(3));
    	INS_CALEF_GAS := TRIM(V_TMP_JBV(4));

	V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
	EXECUTE IMMEDIATE V_SQL INTO ACT_ID;

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_INS_INSTALACION WHERE ICO_ID = (SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID ='||ACT_ID||')';
			
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe ACTUALIZAMOS
		IF V_NUM_TABLAS > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_INS_INSTALACION  
				  SET USUARIOMODIFICAR =  '''||V_USR||'''
				, FECHAMODIFICAR = SYSDATE
				, INS_CALEF = '||INS_CALEF||' 
				, INS_CALEF_CENTRAL = '||INS_CALEF_CENTRAL||' 
				, INS_CALEF_GAS_NATURAL = '||INS_CALEF_GAS||' 
				WHERE ICO_ID = (SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID ='||ACT_ID||')';

			EXECUTE IMMEDIATE V_MSQL;
				
			DBMS_OUTPUT.PUT_LINE('[INFO] Activo  '||NUM_ACT||' actualizado correctamente. ');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE REGISTRO EN ACT_INS_INSTALACION');
		END IF;		
	
    	END LOOP; 

	DBMS_OUTPUT.PUT_LINE('[FIN] Registros actualizado correctamente.');	
	
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
