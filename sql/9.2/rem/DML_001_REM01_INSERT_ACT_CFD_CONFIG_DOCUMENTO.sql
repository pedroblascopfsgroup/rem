--/*
--##########################################
--## AUTOR=Guillermo Llidó
--## FECHA_CREACION=20190403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6011
--## PRODUCTO=NO
--##
--## Finalidad: Insertar documentos en la ACT_CFD_CONFIG_DOCUMENTO
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
	
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;
    
    CURSOR DOCUMENTO IS    SELECT  DD_TPD_ID
									   FROM 
									   (SELECT TPD.DD_TPD_ID
										  FROM REM01.DD_TPD_TIPO_DOCUMENTO TPD 
										  LEFT JOIN REM01.ACT_CFD_CONFIG_DOCUMENTO CFD on TPD.DD_TPD_ID = CFD.DD_TPD_ID
										  LEFT JOIN REM01.DD_TPA_TIPO_ACTIVO TPA on TPA.DD_TPA_ID = CFD.DD_TPA_ID
										  where TPD.USUARIOCREAR = 'REMVIP-3353'
									   MINUS
									   SELECT DISTINCT TPD.DD_TPD_ID  
									   FROM REM01.DD_TPD_TIPO_DOCUMENTO TPD
									   INNER JOIN REM01.ACT_CFD_CONFIG_DOCUMENTO CFD on TPD.DD_TPD_ID = CFD.DD_TPD_ID
									   where TPD.USUARIOCREAR = 'REMVIP-3353');
    
    FILA DOCUMENTO%ROWTYPE;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    DBMS_OUTPUT.put_line('	[INFO] INSERT INTO ACT_CFD_CONFIG_DOCUMENTO');
		
		OPEN DOCUMENTO;
		
		V_COUNT := 0;
		V_COUNT2 := 0;
		
		LOOP
			FETCH DOCUMENTO INTO FILA;
			EXIT WHEN DOCUMENTO%NOTFOUND;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO (
						CFD_ID
						,DD_TPA_ID
						,DD_TPD_ID
						,CFD_OBLIGATORIO
						,CFD_APLICA_F_CADUCIDAD
						,CFD_APLICA_F_ETIQUETA
						,CFD_APLICA_CALIFICACION
						,VERSION
						,USUARIOCREAR
						,FECHACREAR
						,BORRADO
					)VALUES(
						'||V_ESQUEMA||'.S_ACT_CFD_CONFIG_DOCUMENTO.NEXTVAL
						,NULL
						,'||FILA.DD_TPD_ID||'
						,1
						,0
						,NULL
						,NULL
						,0
						,''HREOS-6011''
						,SYSDATE
						,0
						)';
		
		-- DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
			
			V_COUNT := V_COUNT + 1 ;
			V_COUNT2 := V_COUNT2 +1 ;
			
			IF V_COUNT2 = 100 THEN
				
                COMMIT;
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Se comitean '||V_COUNT2||' registros ');
				V_COUNT2 := 0;
				
			END IF;
			
		END LOOP;
		
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_CFD_CONFIG_DOCUMENTO ACTUALIZADA CORRECTAMENTE ');
   

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


