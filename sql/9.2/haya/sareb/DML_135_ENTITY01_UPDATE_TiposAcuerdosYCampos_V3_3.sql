--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20160421
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK= PRODUCTO-1243
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los tipos de soluciones y sus campos correspondientes según la versión 3 del funcional
--##			parte 3
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER;
    V_ENT_AMBAS NUMBER;
    V_DD_TPA_ID NUMBER;
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM > 0 THEN
		V_SQL := 'SELECT DD_ENT_ACU_ID FROM '||V_ESQUEMA||'.DD_ENTIDAD_ACUERDO WHERE DD_ENT_ACU_COD = ''AMBAS'' AND BORRADO = 0 AND ROWNUM=1';
		EXECUTE IMMEDIATE V_SQL INTO V_ENT_AMBAS;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tipo entidad acuerdo AMBAS, id: '||V_ENT_AMBAS);
		
		--******************** PDV (PDV) ***********************************************
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PDV'' AND DD_ENT_ACU_ID = '||V_ENT_AMBAS;
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo acuerdo PDV, se insertará');
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPA_TIPO_ACUERDO.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO (DD_TPA_ID,DD_TPA_CODIGO,DD_TPA_DESCRIPCION,DD_TPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,DD_ENT_ACU_ID) 
						VALUES ('||V_DD_TPA_ID||',''PDV'',''PDV'',''PDV'',0,''DML'',SYSDATE,0,'||V_ENT_AMBAS||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo PDV creado con DD_TAP_ID: '||V_DD_TPA_ID);
		ELSE
			V_SQL := 'SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''PDV'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_SQL INTO V_DD_TPA_ID;
			DBMS_OUTPUT.PUT_LINE('[INFO] Encontrado tipo acuerdo PDV con DD_TPA_ID: '||V_DD_TPA_ID);
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID = '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO SET BORRADO = 1 WHERE DD_TPA_CODIGO = ''PDV'' AND DD_TPA_ID <> '||V_DD_TPA_ID;
			EXECUTE IMMEDIATE V_MSQL;			
			DBMS_OUTPUT.PUT_LINE('[INFO] Tipo acuerdo PDV activado');
		END IF;		
		
		----------------------------------------- PDV - Actualizar Fecha inicio de la PDV -----------------------------------------------------		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CMP_LABEL = ''Fecha de inicio de la PDV'' WHERE CMP_NOMBRE_CAMPO = ''fInicioVencPDV'' ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, actualizada OK.');
		
		----------------------------------------- PDV - Fecha Vencimiento de la PDV -----------------------------------------------------
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fVencimientoPDV''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		IF V_NUM=0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, se insertará');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO (CMP_ID,DD_TPA_ID,CMP_NOMBRE_CAMPO,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,CMP_LABEL,CMP_TIPO_CAMPO,CMP_VALORES_COMBO,CMP_OBLIGATORIO)
						VALUES ('||V_ESQUEMA||'.S_ACU_CAMPOS_TIPO_ACUERDO.NEXTVAL,'||V_DD_TPA_ID||',''fVencimientoPDV'',0,''DML'',SYSDATE,0,''Fecha de vencimiento de la PDV'',''fecha'',NULL,1)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha de vencimiento de la PDV para el tipo acuerdo PDV, insertado OK.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, se marca como activo.');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 0 WHERE DD_TPA_ID='||V_DD_TPA_ID||' AND CMP_NOMBRE_CAMPO=''fInicioVencPDV'' AND ROWNUM = 1';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Campo Fecha inicio y vencimiento de la PDV para el tipo acuerdo PDV, activado.');
		END IF;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] No existe el tipo acuerdo entidad AMBAS.');
	END IF;	
	
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	