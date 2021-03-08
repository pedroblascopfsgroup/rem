--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9074
--## PRODUCTO=NO
--## 
--## Finalidad: INFORMAR ECO_FECHA_ENVIO_ADVISORY_NOTE
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9074'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_COUNT NUMBER(16);		

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA(6012985,'15/04/2020'),
		T_TIPO_DATA(6013041,'15/04/2020'),
		T_TIPO_DATA(6012958,'15/04/2020'),
		T_TIPO_DATA(6012907,'22/04/2020'),
		T_TIPO_DATA(6012908,'22/04/2020'),
		T_TIPO_DATA(6012908,'22/04/2020'),
		T_TIPO_DATA(6012896,'22/04/2020'),
		T_TIPO_DATA(6012907,'22/04/2020'),
		T_TIPO_DATA(6013102,'15/04/2020'),
		T_TIPO_DATA(6010019,'22/04/2020'),
		T_TIPO_DATA(6012902,'22/04/2020')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	--Insertar valores en tabla auxiliar

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0' ;	
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL T1 USING (
							SELECT DISTINCT ECO.ECO_ID FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR
							JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
							WHERE OFR.OFR_NUM_OFERTA = '||V_TMP_TIPO_DATA(1)||' AND OFR.BORRADO = 0
						)T2
						ON (T1.ECO_ID = T2.ECO_ID)
						WHEN MATCHED THEN UPDATE SET
						T1.ECO_FECHA_ENVIO_ADVISORY_NOTE = TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD/MM/YYYY''),
						T1.USUARIOMODIFICAR = '''||V_USU||''',
						T1.FECHAMODIFICAR = SYSDATE' ;	
			EXECUTE IMMEDIATE V_MSQL;	

			DBMS_OUTPUT.PUT_LINE('[INFO] OFERTA '||V_TMP_TIPO_DATA(1)||' INFORMADA ECO_FECHA_ENVIO_ADVISORY_NOTE : '||V_TMP_TIPO_DATA(2)||''); 	

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA '||V_TMP_TIPO_DATA(1)||' '); 	

		END IF;
        
    END LOOP;

	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
		  DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;