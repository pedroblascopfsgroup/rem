--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20210604
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9880
--## PRODUCTO=NO
--##
--## Finalidad:
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
  V_COMMIT NUMBER(16):= 0;
  V_COUNT_ACT NUMBER(16):= 0;
  V_COUNT_AGR NUMBER(16):= 0;
  V_COUNT_AGA NUMBER(16):= 0;
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-9880';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 		Agrupacion  , Activo 
	 	T_TIPO_DATA('40468','169826'),
		T_TIPO_DATA('40468','6804123')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_TBJ_TRABAJO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERT ACT_ID EN AGA');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

	V_COMMIT := V_COMMIT + 1;
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
	-- COmprobamos si la agrupacion existe
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION
	          WHERE AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT_AGR;
        
        --Comprobamos si el activo existe
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO 
		  WHERE ACT_NUM_ACTIVO =  '||TRIM(V_TMP_TIPO_DATA(2))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT_ACT;
        
        IF V_COUNT_AGR = 1 THEN		
			
		IF V_COUNT_ACT = 1 THEN
			
		
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO
				  WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(2))||' )
				  AND AGR_ID = (SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||' )';
								
			EXECUTE IMMEDIATE V_SQL INTO V_COUNT_AGA;
				
				IF V_COUNT_AGA = 0 THEN
								
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
									AGA_ID,
									AGR_ID,
									ACT_ID,
									AGA_FECHA_INCLUSION,
									AGA_PRINCIPAL,
									VERSION,
									USUARIOCREAR,
									FECHACREAR,
									BORRADO,
									PISO_PILOTO,
									ACT_AGA_PARTICIPACION_UA
								) VALUES (
									'||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL,
									(SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = '||TRIM(V_TMP_TIPO_DATA(1))||' ),
									(SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(2))||' ),
									SYSDATE,
									0,
									0,
									'''||V_USUARIO||''',
									SYSDATE,
									0,
									0,
									0
								)';
												

					EXECUTE IMMEDIATE V_MSQL;

					DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA INSERTADO EN LA AGRUPACIÓN '''||TRIM(V_TMP_TIPO_DATA(1))||'''EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
								
				ELSE
					DBMS_OUTPUT.PUT_LINE('[ERROR]:  AGRUPACION '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA TIENE EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
				END IF;
				
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[ERROR]:  EL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(2))||' NO EXISTE');
			END IF;
		
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[ERROR]:  LA AGRUPACION '''||TRIM(V_TMP_TIPO_DATA(1))||' NO EXISTE');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]:  LOS ACTIVOS SE HAN AÑADIDO EN LAS AGRUPACIONES');

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
