--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4525
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Añadido truncate inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_CAMBIO_ESTADO_PUBLI';  -- Tabla a modificar  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4525'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
			
			--Vaciar tabla
			DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO TRUNCATE');
			EXECUTE IMMEDIATE '
				TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
			DBMS_OUTPUT.PUT_LINE('[INFO]: FIN TRUNCATE');
			
			--Insertar datos
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO');
			EXECUTE IMMEDIATE '
				INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
				  ACT_ID,	
				  DD_TCO_CODIGO,				  	
				  CODIGO_ESTADO_A,			  	
				  DESC_ESTADO_A,			   	  	
				  CHECK_PUBLICAR_A,			  	
				  CHECK_OCULTAR_A,				
				  DD_MTO_CODIGO_A,				
				  DD_MTO_MANUAL_A,				
				  CODIGO_ESTADO_V,				
				  DESC_ESTADO_V,					
				  CHECK_PUBLICAR_V,				
				  CHECK_OCULTAR_V,				
				  DD_MTO_CODIGO_V,				
				  DD_MTO_MANUAL_V,				
				  DD_TPU_CODIGO_A,				
				  DD_TPU_CODIGO_V,				
				  DD_TAL_CODIGO,					
				  ADMISION,						
				  GESTION,						
				  INFORME_COMERCIAL,				
				  PRECIO_A,						
				  PRECIO_V,						
				  CEE_VIGENTE,					
				  ADECUADO,							
				  ES_CONDICONADO				
				)   
				SELECT
				  ACT_ID,	
				  DD_TCO_CODIGO,				  	
				  CODIGO_ESTADO_A,			  	
				  DESC_ESTADO_A,			   	  	
				  CHECK_PUBLICAR_A,			  	
				  CHECK_OCULTAR_A,				
				  DD_MTO_CODIGO_A,				
				  DD_MTO_MANUAL_A,				
				  CODIGO_ESTADO_V,				
				  DESC_ESTADO_V,					
				  CHECK_PUBLICAR_V,				
				  CHECK_OCULTAR_V,				
				  DD_MTO_CODIGO_V,				
				  DD_MTO_MANUAL_V,				
				  DD_TPU_CODIGO_A,				
				  DD_TPU_CODIGO_V,				
				  DD_TAL_CODIGO,					
				  ADMISION,						
				  GESTION,						
				  INFORME_COMERCIAL,				
				  PRECIO_A,						
				  PRECIO_V,						
				  CEE_VIGENTE,					
				  ADECUADO,							
				  ES_CONDICONADO
				FROM V_CAMBIO_ESTADO_PUBLI';
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA AUX_CAMBIO_ESTADO_PUBLI ACTUALIZADA CORRECTAMENTE ');
   

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
