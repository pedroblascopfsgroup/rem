--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20150525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-901
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
    V_ENTIDAD_ID NUMBER(16);
  	--Insertando valores en DD_RCC_RES_COMITE_CONCURS
  	TYPE T_TIPO_ACR1 IS TABLE OF VARCHAR2(2048);
  	TYPE T_ARRAY_ACR1 IS TABLE OF T_TIPO_ACR1;
  	V_TIPO_ACR1 T_ARRAY_ACR1 := T_ARRAY_ACR1(
    	T_TIPO_ACR1('DECRETO','Decreto','Decreto',0,'DD',sysdate,0),
    	T_TIPO_ACR1('ESCRITURA','Escritura','Escritura',0,'DD',sysdate,0)
  	); 
  	V_TMP_TIPO_ACR1 T_TIPO_ACR1; 
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_DAD_DOC_ADJUDICACION ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Comprobaciones previas'); 

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION';

    EXECUTE IMMEDIATE V_MSQL INTO table_count;

    -- Si existe registros
    IF table_count > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION...no se modificara nada.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Empezando a insertar datos en el diccionario');
	    FOR I IN V_TIPO_ACR1.FIRST .. V_TIPO_ACR1.LAST
	      LOOP
	        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_DD_DAD_DOC_ADJUDICACION.NEXTVAL FROM DUAL';
	        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
	        V_TMP_TIPO_ACR1 := V_TIPO_ACR1(I);
	        V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_DAD_DOC_ADJUDICACION (
	                    DD_DAD_ID,DD_DAD_CODIGO,DD_DAD_DESCRIPCION,DD_DAD_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) ' ||
	                    'SELECT '|| V_ENTIDAD_ID || ', '''||TRIM(V_TMP_TIPO_ACR1(1))||''' ,'''||TRIM(V_TMP_TIPO_ACR1(2))||''','''||TRIM(V_TMP_TIPO_ACR1(3))||''','||V_TMP_TIPO_ACR1(4)||
	                    ','''||TRIM(V_TMP_TIPO_ACR1(5))||''','''||TRIM(V_TMP_TIPO_ACR1(6))||''','||V_TMP_TIPO_ACR1(7)||' FROM DUAL';
	                       DBMS_OUTPUT.PUT_LINE(V_MSQL);
	            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||TRIM(V_TMP_TIPO_ACR1(1))||''','''||TRIM(V_TMP_TIPO_ACR1(2)));
	        EXECUTE IMMEDIATE V_MSQL;
	      END LOOP;
	    COMMIT;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_DAD_DOC_ADJUDICACION... Datos del diccionario insertado');
	END IF; 
	COMMIT;
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;