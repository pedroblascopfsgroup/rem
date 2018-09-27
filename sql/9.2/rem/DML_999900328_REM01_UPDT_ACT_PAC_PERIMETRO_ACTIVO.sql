--/*
--##########################################
--## AUTOR=Carlos López
--## FECHA_CREACION=20180927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4540
--## PRODUCTO=NO
--## Finalidad: Adecuar el estado del perímetro 'publicable' de los activos
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_ESQUEMA VARCHAR2(25 CHAR):= 'ESQUEMA'; -- Configuracion Esquema.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- Comprobar si existe la tabla.
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobar que la tabla ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' existe.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN	

		-- Actualizar los valores de la columna.
		V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ACT '||
				'SET PAC_CHECK_PUBLICAR =  1 '||
				'   ,PAC_FECHA_PUBLICAR = sysdate '|| 
				'   ,USUARIOMODIFICAR = ''HREOS-4540'' 
					,FECHAMODIFICAR = SYSDATE
				 WHERE EXISTS (SELECT 1
							  FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
							  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = APU.ACT_ID 
							   AND PAC.PAC_CHECK_PUBLICAR = 0 
							 WHERE APU.APU_CHECK_PUBLICAR_V = 1
							   AND APU.ACT_ID = ACT.ACT_ID)
				   AND EXISTS (select 1 
				                 from '|| V_ESQUEMA ||'.act_activo act2 
				                 join '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL scm on SCM.DD_SCM_ID = ACT2.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05'' AND SCM.BORRADO = 0
				                where act2.act_id=ACT.act_id  )	   
							   '
				;
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Registros actualizados: '||SQL%ROWCOUNT);

		V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ACT '||
				'SET PAC_CHECK_PUBLICAR =  1 '||
				'   ,PAC_FECHA_PUBLICAR = sysdate '|| 
				'   ,USUARIOMODIFICAR = ''HREOS-4540'' 
					,FECHAMODIFICAR = SYSDATE
				 WHERE EXISTS (SELECT 1
							  FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
							  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = APU.ACT_ID AND PAC.PAC_CHECK_PUBLICAR = 0 
                JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.DD_TCO_CODIGO = ''03'' AND TCO.BORRADO = 0  
							   
							 WHERE APU.APU_CHECK_PUBLICAR_A = 1
							   AND APU.ACT_ID = ACT.ACT_ID)
				   AND EXISTS (select 1 
				                 from '|| V_ESQUEMA ||'.act_activo act2 
				                 join '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL scm on SCM.DD_SCM_ID = ACT2.DD_SCM_ID AND SCM.DD_SCM_CODIGO <> ''05'' AND SCM.BORRADO = 0
				                where act2.act_id=ACT.act_id  )	            
							   '
				;
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Registros actualizados alquiler: '||SQL%ROWCOUNT);

		V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ACT '||
				'SET PAC_CHECK_PUBLICAR =  0 '||
				'   ,PAC_FECHA_PUBLICAR = sysdate '|| 
				'   ,USUARIOMODIFICAR = ''HREOS-4540'' 
					,FECHAMODIFICAR = SYSDATE
				 WHERE EXISTS (select 1 
				                 from '|| V_ESQUEMA ||'.act_activo act2 
				                 join '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL scm on SCM.DD_SCM_ID = ACT2.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05'' AND SCM.BORRADO = 0
				                where act2.act_id=ACT.act_id )	  
				   AND PAC_CHECK_PUBLICAR = 1            
							   '
				;
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Registros actualizados: '||SQL%ROWCOUNT);
		
		V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ACT '||
				'SET USUARIOMODIFICAR = ''HREOS-4540'' 
					,FECHAMODIFICAR = SYSDATE
					,PAC_CHECK_COMERCIALIZAR = 0
                    ,PAC_FECHA_COMERCIALIZAR = SYSDATE
				 WHERE EXISTS (select 1 
				                 from '|| V_ESQUEMA ||'.act_activo act2 
				                 join '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL scm on SCM.DD_SCM_ID = ACT2.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05'' AND SCM.BORRADO = 0
				                where act2.act_id=ACT.act_id )	  
				   AND PAC_CHECK_COMERCIALIZAR = 1            
							   '
				;
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('Registros actualizados: '||SQL%ROWCOUNT);		
		
		V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ACT '||
				'SET USUARIOMODIFICAR = ''HREOS-4540'' 
					,FECHAMODIFICAR = SYSDATE
					,PAC_CHECK_FORMALIZAR = 0
                    ,PAC_FECHA_FORMALIZAR = SYSDATE
				 WHERE EXISTS (select 1 
				                 from '|| V_ESQUEMA ||'.act_activo act2 
				                 join '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL scm on SCM.DD_SCM_ID = ACT2.DD_SCM_ID AND SCM.DD_SCM_CODIGO = ''05'' AND SCM.BORRADO = 0
				                where act2.act_id=ACT.act_id )	  
				   AND PAC_CHECK_FORMALIZAR = 1            
							   '
				;
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('Registros actualizados: '||SQL%ROWCOUNT);			
	ELSE
		DBMS_OUTPUT.PUT_LINE('la tabla no existe. No se realiza ningún cambio.');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;

		DBMS_OUTPUT.PUT_LINE('KO operacion no realizada');
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);

		ROLLBACK;
		RAISE;

END;

/

EXIT
