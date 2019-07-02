--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4634
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4634'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('6868375','22590.00'),
			T_JBV('6869034','23180.00'),
			T_JBV('6868376','23180.00'),
			T_JBV('6868961','23180.00'),
			T_JBV('6869269','22600.00'),
			T_JBV('6868450','22600.00'),
			T_JBV('6869072','23180.00'),
			T_JBV('6868488','23180.00'),
			T_JBV('6868378','34070.00'),
			T_JBV('6869071','26020.00'),
			T_JBV('6869026','23180.00'),
			T_JBV('6869028','22600.00'),
			T_JBV('6868370','23470.00'),
			T_JBV('6868476','22890.00'),
			T_JBV('6868650','39220.00'),
			T_JBV('6868952','35170.00'),
			T_JBV('6868289','39610.00'),
			T_JBV('6870690','23180.00'),
			T_JBV('6872349','38770.00'),
			T_JBV('6871096','23480.00'),
			T_JBV('6871094','23480.00'),
			T_JBV('6869746','22600.00'),
			T_JBV('6871091','29860.00'),
			T_JBV('6871824','22600.00'),
			T_JBV('6871635','23480.00'),
			T_JBV('6869748','24470.00'),
			T_JBV('6871296','23480.00'),
			T_JBV('6871371','24790.00'),
			T_JBV('6871633','28570.00'),
			T_JBV('6870687','23480.00'),
			T_JBV('6871543','24790.00'),
			T_JBV('6871542','23480.00'),
			T_JBV('6871086','24190.00'),
			T_JBV('6871537','23480.00'),
			T_JBV('6871287','23480.00'),
			T_JBV('6871394','23180.00'),
			T_JBV('6869739','23180.00'),
			T_JBV('6871286','23190.00'),
			T_JBV('6871536','25780.00'),
			T_JBV('6871178','23480.00'),
			T_JBV('6871531','23480.00'),
			T_JBV('6871078','23180.00'),
			T_JBV('6869406','24080.00'),
			T_JBV('6870415','28290.00'),
			T_JBV('6871280','26010.00'),
			T_JBV('6872332','36290.00'),
			T_JBV('6871540','23480.00'),
			T_JBV('6871174','29610.00'),
			T_JBV('6871202','22890.00'),
			T_JBV('6870409','22600.00'),
			T_JBV('6871200','25870.00'),
			T_JBV('6870410','25730.00'),
			T_JBV('6870351','23470.00'),
			T_JBV('6869399','22600.00'),
			T_JBV('6870548','25730.00'),
			T_JBV('6870546','25730.00'),
			T_JBV('6870543','23180.00'),
			T_JBV('6870542','23180.00'),
			T_JBV('6871275','23180.00'),
			T_JBV('6869924','23180.00'),
			T_JBV('6871198','23180.00'),
			T_JBV('6869919','23180.00'),
			T_JBV('6871272','23180.00'),
			T_JBV('6870406','23180.00'),
			T_JBV('6869609','23160.00'),
			T_JBV('6871349','23180.00'),
			T_JBV('6871348','23180.00'),
			T_JBV('6871278','23280.00'),
			T_JBV('6869248','1500.00'),
			T_JBV('6868504','2400.00'),
			T_JBV('6868137','1500.00'),
			T_JBV('6868075','2400.00'),
			T_JBV('6868495','2400.00'),
			T_JBV('6870595','2400.00'),
			T_JBV('6869264','1500.00'),
			T_JBV('6869263','1500.00'),
			T_JBV('6869537','1500.00'),
			T_JBV('6869262','1500.00'),
			T_JBV('6872715','1500.00'),
			T_JBV('6869261','1500.00'),
			T_JBV('6870398','1500.00'),
			T_JBV('6869483','1500.00'),
			T_JBV('6868784','1500.00'),
			T_JBV('6869482','1500.00'),
			T_JBV('6869535','1500.00'),
			T_JBV('6871870','1500.00'),
			T_JBV('6868783','1500.00'),
			T_JBV('6869481','1500.00'),
			T_JBV('6870397','1500.00'),
			T_JBV('6868782','1500.00'),
			T_JBV('6869912','1500.00'),
			T_JBV('6870532','1500.00'),
			T_JBV('6869534','1500.00'),
			T_JBV('6869260','1500.00'),
			T_JBV('6869259','1500.00'),
			T_JBV('6870810','1500.00'),
			T_JBV('6869533','1500.00'),
			T_JBV('6869258','1500.00'),
			T_JBV('6869257','1500.00'),
			T_JBV('6870396','1500.00'),
			T_JBV('6869256','1500.00'),
			T_JBV('6869255','1500.00'),
			T_JBV('6868780','1500.00'),
			T_JBV('6871869','1500.00'),
			T_JBV('6869253','1500.00'),
			T_JBV('6870530','1500.00'),
			T_JBV('6870809','1500.00'),
			T_JBV('6873118','1500.00'),
			T_JBV('6873114','1500.00'),
			T_JBV('6870807','1500.00'),
			T_JBV('6871733','1500.00'),
			T_JBV('6869520','1500.00'),
			T_JBV('6871868','1500.00'),
			T_JBV('6868502','1500.00'),
			T_JBV('6869519','1500.00'),
			T_JBV('6868078','1500.00'),
			T_JBV('6868133','1500.00'),
			T_JBV('6868815','1500.00'),
			T_JBV('6868132','2400.00'),
			T_JBV('6868077','1500.00'),
			T_JBV('6871503','1500.00'),
			T_JBV('6867265','1500.00'),
			T_JBV('6868900','1500.00'),
			T_JBV('6868501','1500.00'),
			T_JBV('6867264','1500.00'),
			T_JBV('6868130','1500.00'),
			T_JBV('6867263','1500.00'),
			T_JBV('6868500','1500.00'),
			T_JBV('6871502','2400.00'),
			T_JBV('6868769','1500.00'),
			T_JBV('6868128','1500.00'),
			T_JBV('6868899','1500.00'),
			T_JBV('6869131','1500.00'),
			T_JBV('6870806','1500.00'),
			T_JBV('6867261','1500.00'),
			T_JBV('6867260','1500.00'),
			T_JBV('6867259','2400.00'),
			T_JBV('6873117','1500.00'),
			T_JBV('6871867','2400.00')
); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA BORRADO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_OFR 
				   SET ACT_OFR_IMPORTE = '||V_TMP_JBV(2)||'
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90200535)';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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
