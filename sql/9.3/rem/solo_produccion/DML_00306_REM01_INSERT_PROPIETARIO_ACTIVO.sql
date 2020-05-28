--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7142
--## PRODUCTO=SI
--##
--## Finalidad: Script que inserta asignación entre propietario y activo (tabla ACT_PAC_PROPIETARIO_ACTIVO)
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(4000 CHAR);
	V_SQL VARCHAR2(4000 CHAR);
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM NUMBER(16); -- Vble. para validar la existencia de un registro.
	V_NUM2 NUMBER(16); -- Vble. para validar la existencia de un registro.
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-7142'; -- USUARIOCREAR/USUARIOMODIFICAR.
	PRO_ID NUMBER(16);
	
	TYPE T_VAR IS TABLE OF VARCHAR2(50);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR; 
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR( 
		   --num_activo, doc_indetif, nombre, tipo_grado_propiedad, porc_propiedad  
		T_VAR('7300538', 'A14010342', 'BANKIA', '01', '100')
	); 
	V_TMP_VAR T_VAR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Creando nueva/s asignación/es de propietarios en ACT_PAC_PROPIETARIO_ACTIVO:');

	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Asignación de propietario para el activo '||V_TMP_VAR(1)||'...');
		
		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_VAR(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM = 1 THEN

			V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||V_TMP_VAR(2)||''' AND PRO_NOMBRE = '''||V_TMP_VAR(3)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM2;

			IF V_NUM2 = 1 THEN

				V_MSQL := 'SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF = '''||V_TMP_VAR(2)||''' AND PRO_NOMBRE = '''||V_TMP_VAR(3)||'''';
				EXECUTE IMMEDIATE V_MSQL INTO PRO_ID;

				DBMS_OUTPUT.PUT_LINE('	[INFO] Insertando en ACT_PAC_PROPIETARIO_ACTIVO...');
			
				EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO (
					PAC_ID,
					ACT_ID,
					PRO_ID,
					DD_TGP_ID,
					PAC_PORC_PROPIEDAD,
					VERSION,
					USUARIOCREAR,
					FECHACREAR,
					BORRADO
				)
				VALUES(
					'||V_ESQUEMA||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL,
					(
					SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_VAR(1)||'
					),
					'||PRO_ID||',
					(
					SELECT DD_TGP_ID FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = '''||V_TMP_VAR(4)||'''
					),
					'''||V_TMP_VAR(5)||''',
					0,
					'''||V_USR||''',
					SYSDATE,
					0
				)
				';
			
				DBMS_OUTPUT.PUT_LINE('[INFO] Asignación de propietario realizada para el activo '||V_TMP_VAR(1)||'.');

			ELSE
				DBMS_OUTPUT.PUT_LINE('[WRN] No existe el PROPIETARIO '''||V_TMP_VAR(3)||'''.');
			END IF;

		ELSE
			DBMS_OUTPUT.PUT_LINE('[WRN] No existe el ACTIVO '||V_TMP_VAR(1)||'.');
		END IF;
	END LOOP;
	
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
