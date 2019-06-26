--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4631
--## PRODUCTO=NO
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

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_4 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_5 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4631'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    OFR_ID NUMBER(16);
    ECO_ID NUMBER(16);
    EEC_ID VARCHAR2(30 CHAR);
    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_4 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_5 NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, TEX_ID 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(90195402,169266,'11'),
		T_JBV(90197067,169925,'11'),
		T_JBV(90198984,170522,'11'),
		T_JBV(90199009,170533,'01'),
		T_JBV(90198885,170442,'01'),
		T_JBV(90198828,170417,'10'),
		T_JBV(90196474,169268,'11'),
		T_JBV(90198413,170233,'04'),
		T_JBV(90198944,170484,'01'),
		T_JBV(90199230,170653,'10'),
		T_JBV(90197330,169742,'11'),
		T_JBV(90197875,170004,'11'),
		T_JBV(90198834,170423,'10'),
		T_JBV(90199005,170527,'01'),
		T_JBV(90199422,170886,'01'),
		T_JBV(90197434,170589,'01'),
		T_JBV(90193645,168973,'01'),
		T_JBV(90198829,170419,'10'),
		T_JBV(90197858,170593,'10'),
		T_JBV(90197912,170038,'11'),
		T_JBV(90198936,170474,'01'),
		T_JBV(90197160,169674,'11'),
		T_JBV(90185280,165175,'01'),
		T_JBV(90192484,167793,'10'),
		T_JBV(90191190,166825,'06'),
		T_JBV(90192889,167480,'10'),
		T_JBV(90176878,160412,'11'),
		T_JBV(90162997,154560,'11'),
		T_JBV(90162997,154560,'16'),
		T_JBV(90194721,169412,'11'),
		T_JBV(90094669,142010,'01'),
		T_JBV(90200300,171275,'10')
				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION OFERTAS, EXPEDIENTES TRAMITES Y TAREAS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

	OFR_ID := TRIM(V_TMP_JBV(1));

	ECO_ID := TRIM(V_TMP_JBV(2));

        EEC_ID := TRIM(V_TMP_JBV(3));


	--UPDATE OFR_OFERTAS
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||OFR_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_4;
	
	IF V_NUM_FILAS_4 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET 
					  DD_EOF_ID = (SELECT EOF.DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = ''01'')
					  , USUARIOMODIFICAR = '''||V_USR||''' 
					  , FECHAMODIFICAR = SYSDATE 
					WHERE OFR_NUM_OFERTA = '||OFR_ID; 
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON OFR_NUM_OFERTA: '||OFR_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_4 := V_COUNT_UPDATE_4 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;

	--UPDATE ECO_EXPEDIENTE_COMERCIAL
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||ECO_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_5;
	
	IF V_NUM_FILAS_5 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
						  DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '''||EEC_ID||''') 
						  , ECO_FECHA_ANULACION = NULL 
						  , USUARIOMODIFICAR = '''||V_USR||''' 
						  , FECHAMODIFICAR = SYSDATE 
						WHERE ECO_NUM_EXPEDIENTE = '||ECO_ID; 
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ECO_NUM_EXPEDIENTE: '||ECO_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_5 := V_COUNT_UPDATE_5 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_4||' registros EN OFR_OFERTAS');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_5||' registros EN ECO_EXPEDIENTE_COMERCIAL');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
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
