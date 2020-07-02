--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7489
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CEX_COMPRADOR_EXPEDIENTE los datos añadidos en T_ARRAY_DATA.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7489'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'CEX_COMPRADOR_EXPEDIENTE';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	T_FUNCION('90253364','48984583B','01',''),
	T_FUNCION('6010093','34847465G','02','02'),
	T_FUNCION('6009378','46355467W','02','02'),
	T_FUNCION('6009726','77789920X','02','02'),
	T_FUNCION('6009545','39731253H','02','02'),
	T_FUNCION('90252929','78051000V','02','02'),
	T_FUNCION('90248865','47769354X','02','02'),
	T_FUNCION('6009784','40886735A','02','02'),
	T_FUNCION('90252284','45438456R','02','02'),
	T_FUNCION('6009870','26251247J','01','')   
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

                V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							   JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_FUNCION(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;
                	IF V_ID > 0 THEN

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
		             SET CEX_PORCION_COMPRA = 50
		             WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							   JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_FUNCION(1)||''')';
				    	
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' modificados correctamente.');
            
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE (COM_ID, ECO_ID, DD_ECV_ID, DD_REM_ID, CEX_PORCION_COMPRA, CEX_TITULAR_RESERVA, CEX_TITULAR_CONTRATACION, VERSION, BORRADO, DD_PAI_ID)
				VALUES (
				(SELECT COM_ID FROM '||V_ESQUEMA||'.COM_COMPRADOR WHERE COM_DOCUMENTO = '''||V_TMP_FUNCION(2)||'''),
				(SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
							   JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID WHERE OFR.OFR_NUM_OFERTA = '''||V_TMP_FUNCION(1)||'''),
				(SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES WHERE DD_ECV_CODIGO = '''||V_TMP_FUNCION(3)||'''),
				(SELECT DD_REM_ID FROM '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES WHERE DD_REM_CODIGO = '''||V_TMP_FUNCION(4)||'''),
				50,
				0,
				0,
				0,
				0,
				(SELECT DD_PAI_ID FROM '||V_ESQUEMA||'.DD_PAI_PAISES WHERE DD_PAI_CODIGO = ''28'')
				)';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE insertados correctamente.');		
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] Expediente no existe.');

	END IF;
						
			 
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
