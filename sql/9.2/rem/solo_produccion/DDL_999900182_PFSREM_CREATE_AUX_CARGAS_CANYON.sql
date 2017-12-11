--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20171205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3410
--## PRODUCTO=NO
--## Finalidad: Inserción de nuevos campos en AUX_CARGAS_CANYON
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'PFSREM'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(50 CHAR):= 'AUX_CARGAS_CANYON';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('******** '''||V_TABLA||''' - Creacion de tabla *******');
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... La nueva tabla ya existe. NO SE HACE NADA');
    ELSE
        V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' AS 
				 SELECT DISTINCT
				BIE_CAR.BIE_CAR_ID,
				BIE_CAR.BIE_ID,
				BIE.BIE_ENTIDAD_ID,
				BIE_CAR.DD_TPC_ID,
				BIE_CAR.BIE_CAR_LETRA,
				BIE_CAR.BIE_CAR_TITULAR,
				BIE_CAR.BIE_CAR_IMPORTE_REGISTRAL,
				BIE_CAR.BIE_CAR_IMPORTE_ECONOMICO,
				BIE_CAR.BIE_CAR_REGISTRAL,
				BIE_CAR.DD_SIC_ID,
				BIE_CAR.BIE_CAR_FECHA_PRESENTACION,
				BIE_CAR.BIE_CAR_FECHA_INSCRIPCION,
				BIE_CAR.BIE_CAR_FECHA_CANCELACION,
				BIE_CAR.BIE_CAR_ECONOMICA,
				BIE_CAR.DD_SIC_ID2,
				BIE_CAR.VERSION,
				BIE_CAR.USUARIOCREAR,
				BIE_CAR.FECHACREAR,
				BIE_CAR.USUARIOMODIFICAR,
				BIE_CAR.FECHAMODIFICAR,
				BIE_CAR.USUARIOBORRAR,
				BIE_CAR.FECHABORRAR,
				BIE_CAR.BORRADO
				FROM HAYA01.BIE_BIEN BIE
				INNER JOIN HAYA01.BIE_ADJ_ADJUDICACION BIE_ADJ 			ON BIE_ADJ.BIE_ID = BIE.BIE_ID
				INNER JOIN HAYA01.BIE_CAR_CARGAS BIE_CAR 				ON BIE_CAR.BIE_ID = BIE.BIE_ID
				LEFT JOIN HAYA01.DD_TBI_TIPO_BIEN DD_TBI 				ON DD_TBI.DD_TBI_ID = BIE.DD_TBI_ID
				LEFT JOIN HAYA01.DD_EAD_ENTIDAD_ADJUDICA DD_EAD 		ON DD_EAD.DD_EAD_ID = BIE_ADJ.DD_EAD_ID
				WHERE 
				BIE.BORRADO = 0
				AND BIE_ADJ.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL
				AND DD_EAD.DD_EAD_CODIGO = ''1''
				AND DD_TBI.DD_TBI_CODIGO = ''01''
				  ';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se creado la nueva tabla con exito');
	END IF;
    
    
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
