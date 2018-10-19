--/*
--###########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2265
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR IMPORTE GASTO 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2265';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		NUM ACTIVO, IMPORTE 
    T_TIPO_DATA('6032239','3000') 
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ECO_CONDICIONANTES_EXPEDIENTE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE IMPORTE RESERVA');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT
						COUNT(1)
					FROM
						'||V_ESQUEMA||'.ACT_ACTIVO ACT
						INNER JOIN '||V_ESQUEMA||'.ACT_OFR AFR ON ACT.ACT_ID = AFR.ACT_ID
						INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AFR.OFR_ID
						INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
						INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON
							EEC.DD_EEC_ID = ECO.DD_EEC_ID
						AND
							EEC.DD_EEC_CODIGO = ''08''
					WHERE
						ACT.ACT_NUM_ACTIVO =  '||TRIM(V_TMP_TIPO_DATA(1))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS > 0 THEN		

			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL IMPORTE DE LA RESERVA '||TRIM(V_TMP_TIPO_DATA(1))||'');
			
				V_MSQL := 'UPDATE REM01.COE_CONDICIONANTES_EXPEDIENTE
								SET
									COE_IMPORTE_RESERVA = '||TRIM(V_TMP_TIPO_DATA(2))||',
									USUARIOMODIFICAR = '''||V_USUARIO||''',
									FECHAMODIFICAR = SYSDATE
							WHERE
								COE_ID = (
									SELECT
										COE.COE_ID
									FROM
										'||V_ESQUEMA||'.ACT_ACTIVO ACT
										INNER JOIN '||V_ESQUEMA||'.ACT_OFR AFR ON ACT.ACT_ID = AFR.ACT_ID
										INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AFR.OFR_ID
										INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
										INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON
											EEC.DD_EEC_ID = ECO.DD_EEC_ID
										AND
											EEC.DD_EEC_CODIGO = ''08''
										INNER JOIN '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE ON COE.ECO_ID = ECO.ECO_ID
									WHERE
										ACT.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'
								)';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE EL IMPORTE DE LA RESERVA '||TRIM(V_TMP_TIPO_DATA(1))||'');
			
		--El activo no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[ERROR]:  EL IMPORTE DE LA RESERVA '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HA SIDO ACTUALIZADO');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  EL IMPORTE DE LA RESERVA HA SIDO ACTUALIZADO CORRECTAMENTE ');

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
