--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5423
--## PRODUCTO=NO
--##
--## Finalidad: Avanzar trámite
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    PL_OUTPUT VARCHAR2(20000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_ECO_ID NUMBER(16,0);
    V_NUM_ECO NUMBER;
    V_COS_ID NUMBER(16,0);
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-5423';
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION(90219075, '23')
	); 
	V_TMP_FUNCION T_FUNCION;

BEGIN
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
		LOOP
			V_TMP_FUNCION := V_FUNCION(I);
			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
								WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_TMP_FUNCION(1)||') AND BORRADO = 0' INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS > 0 THEN
				EXECUTE IMMEDIATE 'SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
								WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_TMP_FUNCION(1)||')' INTO V_ECO_ID;
				EXECUTE IMMEDIATE 'SELECT ECO_NUM_EXPEDIENTE FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID INTO V_NUM_ECO;
				EXECUTE IMMEDIATE 'SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = '''||V_TMP_FUNCION(2)||'''' INTO V_COS_ID;
				EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID = '||V_COS_ID||',
									USUARIOMODIFICAR = '''||V_USUARIO||''',
									FECHAMODIFICAR = SYSDATE
									WHERE ECO_ID = '||V_ECO_ID||' AND BORRADO = 0';
				#ESQUEMA#.AVANCE_TRAMITE(V_USUARIO,V_NUM_ECO,'T013_ResolucionComite',null,null,PL_OUTPUT);
				DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

				EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_EEC_ID = 10,
									USUARIOMODIFICAR = '''||V_USUARIO||''',
									FECHAMODIFICAR = SYSDATE
									WHERE ECO_ID = '||V_ECO_ID||' AND BORRADO = 0';
				
			END IF;
		END LOOP;
	
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
