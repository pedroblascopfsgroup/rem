--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7303
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7303'; -- USUARIOCREAR/USUARIOMODIFICAR.
    NUM_ACT NUMBER(16);
    DESCRIPCION VARCHAR2(100 CHAR);
    ACT_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--act_num_activo, descripcion

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

	T_JBV(7285533,'Desconocido'),
	T_JBV(7284159,'Desconocido'),
	T_JBV(7285596,'Desconocido'),
	T_JBV(7285581,'Desconocido'),
	T_JBV(7286064,'Desconocido'),
	T_JBV(7288078,'Desconocido'),
	T_JBV(7284213,'Desconocido'),
	T_JBV(7284214,'Desconocido'),
	T_JBV(7284771,'Desconocido'),
	T_JBV(7286283,'Desconocido'),
	T_JBV(7286607,'Desconocido'),
	T_JBV(7284758,'Desconocido'),
	T_JBV(7285330,'Desconocido'),
	T_JBV(7287984,'Desconocido'),
	T_JBV(7283904,'Desconocido'),
	T_JBV(7284590,'Desconocido'),
	T_JBV(7285698,'Desconocido'),
	T_JBV(7285869,'Desconocido'),
	T_JBV(7283917,'Desconocido'),
	T_JBV(7284835,'Desconocido'),
	T_JBV(7285965,'Desconocido'),
	T_JBV(7285464,'Desconocido'),
	T_JBV(7285466,'Desconocido'),
	T_JBV(7286967,'Desconocido'),
	T_JBV(7283903,'Desconocido'),
	T_JBV(7287917,'Desconocido'),
	T_JBV(7286309,'Desconocido'),
	T_JBV(7285463,'Desconocido'),
	T_JBV(7285469,'Desconocido'),
	T_JBV(7284374,'Desconocido'),
	T_JBV(7285465,'Desconocido'),
	T_JBV(7285468,'Desconocido'),
	T_JBV(7288051,'Desconocido'),
	T_JBV(7288053,'Desconocido'),
	T_JBV(7283894,'Desconocido'),
	T_JBV(7288052,'Desconocido'),
	T_JBV(7285888,'Desconocido'),
	T_JBV(7285467,'Desconocido'),
	T_JBV(7286241,'Desconocido'),
	T_JBV(7285418,'Desconocido'),
	T_JBV(7284802,'Desconocido'),
	T_JBV(7286150,'Desconocido'),
	T_JBV(7287475,'Desconocido'),
	T_JBV(7287592,'Desconocido'),
	T_JBV(7288050,'Desconocido'),
	T_JBV(7283462,'Desconocido'),
	T_JBV(7286541,'Desconocido'),
	T_JBV(7284769,'Desconocido'),
	T_JBV(7284820,'Desconocido'),
	T_JBV(7287855,'Desconocido'),
	T_JBV(7287472,'Desconocido'),
	T_JBV(7286294,'Desconocido'),
	T_JBV(7287476,'Desconocido'),
	T_JBV(7284311,'Desconocido'),
	T_JBV(7288045,'Desconocido'),
	T_JBV(7287474,'Desconocido'),
	T_JBV(7288362,'Desconocido'),
	T_JBV(7288385,'Desconocido'),
	T_JBV(7284240,'Desconocido'),
	T_JBV(7287897,'Desconocido'),
	T_JBV(7284845,'Desconocido'),
	T_JBV(7284010,'Desconocido'),
	T_JBV(7284452,'Desconocido'),
	T_JBV(7283919,'Desconocido'),
	T_JBV(7286281,'Desconocido'),
	T_JBV(7286971,'Desconocido'),
	T_JBV(7284744,'Desconocido'),
	T_JBV(7288046,'Desconocido'),
	T_JBV(7286250,'Desconocido'),
	T_JBV(7286412,'Desconocido'),
	T_JBV(7286932,'Desconocido'),
	T_JBV(7284352,'Desconocido'),
	T_JBV(7283651,'Desconocido'),
	T_JBV(7285855,'Desconocido'),
	T_JBV(7285314,'Desconocido'),
	T_JBV(7287444,'Desconocido'),
	T_JBV(7286222,'Desconocido'),
	T_JBV(7284401,'Desconocido'),
	T_JBV(7288154,'Desconocido'),
	T_JBV(7285246,'Desconocido'),
	T_JBV(7284223,'Desconocido'),
	T_JBV(7287932,'Desconocido'),
	T_JBV(7283913,'Desconocido'),
	T_JBV(7285854,'Desconocido'),
	T_JBV(7286185,'Desconocido'),
	T_JBV(7285777,'Desconocido'),
	T_JBV(7288047,'Desconocido'),
	T_JBV(7285651,'Desconocido'),
	T_JBV(7288391,'Desconocido'),
	T_JBV(7284825,'Desconocido'),
	T_JBV(7288077,'Desconocido'),
	T_JBV(7286325,'Desconocido'),
	T_JBV(7288048,'Desconocido'),
	T_JBV(7285714,'Desconocido'),
	T_JBV(7286989,'Desconocido'),
	T_JBV(7286418,'Desconocido'),
	T_JBV(7287473,'Desconocido'),
	T_JBV(7283710,'Desconocido'),
	T_JBV(7288049,'Desconocido'),
	T_JBV(7287955,'Desconocido'),
	T_JBV(7288562,'Desconocido')


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

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_SOL_SOLADO WHERE ICO_ID = (SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID ='||ACT_ID||')';
			
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe ACTUALIZAMOS
		IF V_NUM_TABLAS > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_SOL_SOLADO 
				  SET USUARIOMODIFICAR =  '''||V_USR||'''
				, FECHAMODIFICAR = SYSDATE
				, SOL_SOLADO_OTROS = '''||DESCRIPCION||''' 
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
