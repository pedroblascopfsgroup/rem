--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7306
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7306'; -- USUARIOCREAR/USUARIOMODIFICAR.
    NUM_ACT NUMBER(16);
    DESCRIPCION VARCHAR2(100 CHAR);
    ACT_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--act_num_activo, descripcion

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

	T_JBV(7288562,'Entorno Socio-Económico (Medio)- Demanda de la zona (Media)')

		); 
	V_TMP_JBV T_JBV;

BEGIN	
    -- LOOP Insertando 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando a insertar datos en la tabla');

    FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	NUM_ACT := TRIM(V_TMP_JBV(1));
  	
  	DESCRIPCION := V_TMP_JBV(2);

	V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||NUM_ACT||'';
	EXECUTE IMMEDIATE V_SQL INTO ACT_ID;

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_EDI_EDIFICIO WHERE ICO_ID = (SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID ='||ACT_ID||')';
			
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe ACTUALIZAMOS
		IF V_NUM_TABLAS > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_EDI_EDIFICIO 
				  SET USUARIOMODIFICAR =  '''||V_USR||'''
				, FECHAMODIFICAR = SYSDATE
				, EDI_ENTORNO_COMUNICACION = '''||DESCRIPCION||''' 
				WHERE ICO_ID = (SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID ='||ACT_ID||')';

			EXECUTE IMMEDIATE V_MSQL;
				
			DBMS_OUTPUT.PUT_LINE('[INFO] Activo  '||NUM_ACT||' actualizado correctamente. ');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE REGISTRO EN LA ICO');
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
