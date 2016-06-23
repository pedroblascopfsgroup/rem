--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2120
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    CURSOR c1 IS select tpa.DD_TPA_ID from DD_TPA_TIPO_ACUERDO tpa, DD_ENTIDAD_ACUERDO ent where tpa.DD_ENT_ACU_ID= ent.DD_ENT_ACU_ID and (ent.DD_ENT_ACU_COD= 'EXP' or ent.DD_ENT_ACU_COD='AMBAS') and tpa.BORRADO=0 and ent.BORRADO=0 and tpa.DD_TPA_CODIGO!= 'SINSOLUCION';
  	ID_MI NUMBER(16);
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** ACU_CAMPOS_TIPO_ACUERDO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Comprobaciones previas'); 
    
    IF c1 %ISOPEN THEN
    	CLOSE c1 ;
  	END IF;
  	OPEN c1;
  	DBMS_OUTPUT.PUT_LINE('[INFO] ABIERTO CURSOR');
	
  	LOOP
  	
  		FETCH c1 INTO ID_MI;
  		EXIT WHEN c1%NOTFOUND;
  	
   		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE CMP_NOMBRE_CAMPO = ''importePrevistoRegularizar'' AND DD_TPA_ID ='||ID_MI||'';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
    	
    	IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el registro en la tabla '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO.');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID, DD_TPA_ID, CMP_NOMBRE_CAMPO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, CMP_LABEL, CMP_TIPO_CAMPO, CMP_VALORES_COMBO, CMP_OBLIGATORIO) VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||ID_MI||', ''importePrevistoRegularizar'',0,''RECOVERY-2120'',SYSDATE,0,NULL,NULL,NULL,NULL,''Importe Previsto Regularizar'', ''number'', NULL, 1 )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO');
			

		END IF;
  	
  	END LOOP;
  	CLOSE c1;
  	
	
    COMMIT;
	
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
