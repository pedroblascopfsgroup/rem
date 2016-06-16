--/*
--##########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20160614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.5-bk
--## INCIDENCIA_LINK=PRODUCTO-1451
--## PRODUCTO=NO
--##
--## Finalidad: inserción inicial en la tabla MPP_MAPEO_PLANTILLAS_PCO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_TABLENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
	    T_TIPO_TPO('041','AVAL'),
	    T_TIPO_TPO('032','DESCUENTO'),
	    T_TIPO_TPO('029','DESCUBIERTO'),
	    T_TIPO_TPO('121','DESCUBIERTO'),
	    T_TIPO_TPO('059','HIPOTECARIO'),
	    T_TIPO_TPO('059','PERSONAL'),
	    T_TIPO_TPO('039','LEASING'),
	    T_TIPO_TPO('021','CREDITO')
	); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
    V_TABLA1 VARCHAR(30 CHAR) :='MPP_MAPEO_PLANTILLAS_PCO';
    V_ID_APLICATIVO NUMBER(16);
    V_ID_PLANTILLA NUMBER(16);
    V_EJECUTAR_MERGE NUMBER(1);
BEGIN	

	-- Borramos los registros correspondientes a mapeo de Tipo de Liquidacion, y si existen, luego los actualizamos con el merge
	V_SQL := 'UPDATE '||V_ESQUEMA||'.' || V_TABLA1 || ' set BORRADO = 1 WHERE DD_PCO_LIQ_ID IS NOT NULL';
	EXECUTE IMMEDIATE V_SQL; 
	
   	V_TABLENAME := V_ESQUEMA || '.' || V_TABLA1 || '';
    V_SEQUENCENAME := V_ESQUEMA || '.S_' || V_TABLA1 || '';
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME || '.');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        
        V_EJECUTAR_MERGE := 1;
        BEGIN
        	EXECUTE IMMEDIATE 'SELECT DD_APO_ID FROM ' || V_ESQUEMA ||'.DD_APO_APLICATIVO_ORIGEN WHERE DD_APO_CODIGO=''' || V_TMP_TIPO_TPO(1) || '''' INTO V_ID_APLICATIVO;
        EXCEPTION
  			WHEN NO_DATA_FOUND 
  			THEN 
  				DBMS_OUTPUT.PUT_LINE('[AVISO] APLICATIVO ' || V_TMP_TIPO_TPO(1) || ' NO EXISTE');
  				V_EJECUTAR_MERGE := 0;
  		END;
  		
  		BEGIN
        	EXECUTE IMMEDIATE 'SELECT DD_PCO_LIQ_ID FROM ' || V_ESQUEMA ||'.DD_PCO_LIQ_TIPO WHERE DD_PCO_LIQ_CODIGO=''' || V_TMP_TIPO_TPO(2) || '''' INTO V_ID_PLANTILLA;
        EXCEPTION
  			WHEN NO_DATA_FOUND 
  			THEN 
  				DBMS_OUTPUT.PUT_LINE('[AVISO] PLANTILLA ' || V_TMP_TIPO_TPO(2) || ' NO EXISTE');
  				V_EJECUTAR_MERGE := 0;
  		END;
        
        IF V_EJECUTAR_MERGE>0 THEN
	        V_SQL := q'[MERGE INTO ]' || V_TABLENAME || q'[ tabla  USING (select ']' || V_ID_APLICATIVO || q'[' APLICATIVO, ']' || V_ID_PLANTILLA || q'[' PLANTILLA,
	        	 'PRODUCTO-1451' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
		    ON (tabla.DD_APO_ID=actual.APLICATIVO and tabla.DD_PCO_LIQ_ID=actual.PLANTILLA and tabla.DD_PCO_BFT_ID is null)
		    WHEN NOT MATCHED THEN
			    INSERT (MPP_ID,DD_APO_ID,DD_PCO_LIQ_ID,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
			    VALUES (]' || V_SEQUENCENAME || q'[.NEXTVAL, actual.APLICATIVO, actual.PLANTILLA, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)
			WHEN MATCHED THEN
				UPDATE SET usuariomodificar=actual.usuariocrear, fechamodificar=actual.fechacrear, borrado=actual.borrado]';
		    EXECUTE IMMEDIATE V_SQL; 
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_TABLENAME || ': ' || V_TMP_TIPO_TPO(1) || ' - ' || V_TMP_TIPO_TPO(2) || '... registros afectados: ' || sql%rowcount);
		END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION DE EN LA TABLA ' || V_TABLENAME);

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