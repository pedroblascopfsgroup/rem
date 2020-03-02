--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6509
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    V_COUNT NUMBER(16); -- Vble. para contar. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	NUM_EXP NUMBER(16);
	EXP_ID NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6509';    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			-- ECO_NUM_EXPEDIENTE	
			T_TIPO_DATA('182463'),
			T_TIPO_DATA('113242')
		);		
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');


    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	NUM_EXP := TRIM(V_TMP_TIPO_DATA(1));
       	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||NUM_EXP INTO V_COUNT;
  			  
		IF V_COUNT > 0 THEN 
	  			  
			EXECUTE IMMEDIATE 'SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||NUM_EXP INTO EXP_ID;			
	
			V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL             							
					SET ECO_FECHA_ANULACION = NULL, 
		  					ECO_FECHA_DEV_ENTREGAS = NULL,    	
 							USUARIOMODIFICAR = '''||V_USUARIO||''', 
		      				FECHAMODIFICAR = SYSDATE						
					WHERE ECO_ID = '||EXP_ID ;					
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('ACTUALIZADO EXPEDIENTE '||NUM_EXP||' EN ECO_EXPEDIENTE_COMERCIAL');
			
			
			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE BORRADO = 0 AND ECO_ID = '||EXP_ID INTO V_COUNT;
			
			IF V_COUNT > 0 THEN
			
				V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS 
					SET DD_EDE_ID = NULL,
 						USUARIOMODIFICAR = '''||V_USUARIO||''', 
		      			FECHAMODIFICAR = SYSDATE						
					WHERE BORRADO = 0 AND ECO_ID = '||EXP_ID ;					
				EXECUTE IMMEDIATE V_SQL;
			
				DBMS_OUTPUT.PUT_LINE('ACTUALIZADO EXPEDIENTE '||NUM_EXP||' EN RES_RESERVAS');
			
			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO] El expediente '||NUM_EXP||' no tiene reserva!');
			
			END IF;
			
				
		ELSE
			
			DBMS_OUTPUT.PUT_LINE('[INFO] El expediente '||NUM_EXP||' no existe!');
			
		END IF;
		
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado correctamente');   
   

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
EXIT
