--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7307
--## PRODUCTO=NO
--##
--## Finalidad: script para añadir descripciones
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7307'; -- USUARIOCREAR/USUARIOMODIFICAR.
    NUM_ACT NUMBER(16);
    DESCRIPCION VARCHAR2(100 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--act_num_activo, descripcion

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

	T_JBV(7285533,'- Alto Standing (No)'),
T_JBV(7284159,'- Alto Standing (No)'),
T_JBV(7285596,'- Alto Standing (No)'),
T_JBV(7285581,'- Alto Standing (No)'),
T_JBV(7286064,'- Alto Standing (No)'),
T_JBV(7288078,'- Alto Standing (No)'),
T_JBV(7284213,'- Alto Standing (No)'),
T_JBV(7284214,'- Alto Standing (No)'),
T_JBV(7284771,'- Alto Standing (No)'),
T_JBV(7286283,'- Alto Standing (No)'),
T_JBV(7286607,'- Alto Standing (No)'),
T_JBV(7284758,'- Alto Standing (No)'),
T_JBV(7285330,'- Alto Standing (No)'),
T_JBV(7287984,'- Alto Standing (No)'),
T_JBV(7283904,'- Alto Standing (Si)'),
T_JBV(7284590,'- Alto Standing (No)'),
T_JBV(7285698,'- Alto Standing (No)'),
T_JBV(7285869,'- Alto Standing (No)'),
T_JBV(7283917,'- Alto Standing (No)'),
T_JBV(7284835,'- Alto Standing (No)'),
T_JBV(7285965,'- Alto Standing (No)'),
T_JBV(7285464,'- Alto Standing (No)'),
T_JBV(7285466,'- Alto Standing (No)'),
T_JBV(7286967,'- Alto Standing (No)'),
T_JBV(7283903,'- Alto Standing (Si)'),
T_JBV(7287917,'- Alto Standing (No)'),
T_JBV(7286309,'- Alto Standing (No)'),
T_JBV(7285463,'- Alto Standing (No)'),
T_JBV(7285469,'- Alto Standing (No)'),
T_JBV(7284374,'- Alto Standing (No)'),
T_JBV(7285465,'- Alto Standing (No)'),
T_JBV(7285468,'- Alto Standing (No)'),
T_JBV(7288051,'- Alto Standing (No)'),
T_JBV(7288053,'- Alto Standing (No)'),
T_JBV(7283894,'- Alto Standing (Si)'),
T_JBV(7288052,'- Alto Standing (No)'),
T_JBV(7285888,'- Alto Standing (No)'),
T_JBV(7285467,'- Alto Standing (No)'),
T_JBV(7286241,'- Alto Standing (No)'),
T_JBV(7285418,'- Alto Standing (No)'),
T_JBV(7284802,'- Alto Standing (No)'),
T_JBV(7286150,'- Alto Standing (No)'),
T_JBV(7287475,'- Alto Standing (No)'),
T_JBV(7287592,'- Alto Standing (No)'),
T_JBV(7288050,'- Alto Standing (No)'),
T_JBV(7283462,'- Alto Standing (No)'),
T_JBV(7286541,'- Alto Standing (No)'),
T_JBV(7284769,'- Alto Standing (No)'),
T_JBV(7284820,'- Alto Standing (No)'),
T_JBV(7287855,'- Alto Standing (No)'),
T_JBV(7287472,'- Alto Standing (No)'),
T_JBV(7286294,'- Alto Standing (No)'),
T_JBV(7287476,'- Alto Standing (No)'),
T_JBV(7284311,'- Alto Standing (No)'),
T_JBV(7288045,'- Alto Standing (No)'),
T_JBV(7287474,'- Alto Standing (No)'),
T_JBV(7288362,'- Alto Standing (No)'),
T_JBV(7288385,'- Alto Standing (No)'),
T_JBV(7284240,'- Alto Standing (No)'),
T_JBV(7287897,'- Alto Standing (No)'),
T_JBV(7284845,'- Alto Standing (No)'),
T_JBV(7284010,'- Alto Standing (No)'),
T_JBV(7284452,'- Alto Standing (No)'),
T_JBV(7283919,'- Alto Standing (No)'),
T_JBV(7286281,'- Alto Standing (No)'),
T_JBV(7286971,'- Alto Standing (No)'),
T_JBV(7284744,'- Alto Standing (No)'),
T_JBV(7288046,'- Alto Standing (No)'),
T_JBV(7286250,'- Alto Standing (No)'),
T_JBV(7286412,'- Alto Standing (No)'),
T_JBV(7286932,'- Alto Standing (No)'),
T_JBV(7284352,'- Alto Standing (No)'),
T_JBV(7283651,'- Alto Standing (No)'),
T_JBV(7285855,'- Alto Standing (No)'),
T_JBV(7285314,'- Alto Standing (No)'),
T_JBV(7287444,'- Alto Standing (No)'),
T_JBV(7286222,'- Alto Standing (No)'),
T_JBV(7284401,'- Alto Standing (No)'),
T_JBV(7288154,'- Alto Standing (No)'),
T_JBV(7285246,'- Alto Standing (No)'),
T_JBV(7284223,'- Alto Standing (No)'),
T_JBV(7287932,'- Alto Standing (No)'),
T_JBV(7283913,'- Alto Standing (Si)'),
T_JBV(7285854,'- Alto Standing (No)'),
T_JBV(7286185,'- Alto Standing (No)'),
T_JBV(7285777,'- Alto Standing (No)'),
T_JBV(7288047,'- Alto Standing (No)'),
T_JBV(7285651,'- Alto Standing (No)'),
T_JBV(7288391,'- Alto Standing (No)'),
T_JBV(7284825,'- Alto Standing (No)'),
T_JBV(7288077,'- Alto Standing (No)'),
T_JBV(7286325,'- Alto Standing (No)'),
T_JBV(7288048,'- Alto Standing (No)'),
T_JBV(7285714,'- Alto Standing (No)'),
T_JBV(7286989,'- Alto Standing (No)'),
T_JBV(7286418,'- Alto Standing (No)'),
T_JBV(7287473,'- Alto Standing (No)'),
T_JBV(7283710,'- Alto Standing (No)'),
T_JBV(7288049,'- Alto Standing (No)'),
T_JBV(7287955,'- Alto Standing (No)'),
T_JBV(7288562,'Dúplex a reformar listo para comercializar- Alto Standing (No)')


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

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO ='||NUM_ACT||')';
			
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe ACTUALIZAMOS
		IF V_NUM_TABLAS > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL 
				  SET USUARIOMODIFICAR =  '''||V_USR||'''
				, FECHAMODIFICAR = SYSDATE
				, ICO_DESCRIPCION = '''||DESCRIPCION||''' 
				WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO ='||NUM_ACT||')';

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
