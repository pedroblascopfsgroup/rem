--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4563
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'DD_MTO_MOTIVOS_OCULTACION';  -- Tabla a modificar.
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_MTO_MOTIVOS_OCULTACION';  -- Secuencia de la tabla.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4563'; -- USUARIOCREAR.
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MTO_MOTIVOS_OCULTACION ');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = ''15'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el registro en la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
	ELSE
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
						USUARIOMODIFICAR = '''||V_USR||'''
						,FECHAMODIFICAR = SYSDATE
						,DD_MTO_ORDEN = DD_MTO_ORDEN+1
						where DD_MTO_ORDEN > 4';
		EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
						DD_MTO_ID
						,DD_MTO_CODIGO
						,DD_MTO_DESCRIPCION
					  	,DD_MTO_DESCRIPCION_LARGA
					  	,DD_TCO_ID
					  	,DD_MTO_MANUAL
						,VERSION
						,USUARIOCREAR
						,FECHACREAR
						,BORRADO
						,DD_MTO_ORDEN
					) VALUES (
						'||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
						,''15''
						,''Oferta Express''
						,''Oferta Express''
						,(SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02'' AND BORRADO = 0 )
						,0
						,0
						,'''||V_USR||'''
						,SYSDATE
						,0
						,5
					)';
		EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		DBMS_OUTPUT.PUT_LINE('[INFO]: DICCIONARIO '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
	END IF;

    COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
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