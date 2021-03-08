--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8960
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla DD_LOC_LOCALIDAD
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_LOC_LOCALIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ID NUMBER(16);

    
BEGIN		
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 	
               DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN LA TABLA DD_LOC_LOCALIDAD');

       	  V_MSQL := 'MERGE INTO '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD T1 USING(
				  SELECT LOC.DD_LOC_CODIGO, LOC.DD_LOC_DESCRIPCION, AUX.NOMBRE_LOCALIDAD
				  FROM '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC
				  LEFT JOIN '||V_ESQUEMA||'.AUX_REMVIP_8960 AUX ON (TRANSLATE(UPPER(AUX.NOMBRE_LOCALIDAD), ''ÁÉÍÓÚ'', ''AEIOU'')) = LOC.DD_LOC_DESCRIPCION
				  WHERE LOC.DD_LOC_DESCRIPCION <> AUX.NOMBRE_LOCALIDAD) T2 
			     ON (T1.DD_LOC_CODIGO = T2.DD_LOC_CODIGO)
			     WHEN MATCHED THEN UPDATE SET T1.DD_LOC_DESCRIPCION = T2.NOMBRE_LOCALIDAD,
						     T1.USUARIOMODIFICAR = ''REMVIP-8960'',
						     T1.FECHAMODIFICAR = SYSDATE';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_MSG := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
