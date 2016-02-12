--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HR-1316
--## PRODUCTO=SI
--##
--## Finalidad: inserción en la tabla DD_TRI_TRIBUTACION nuevos valores para la ficha del BIEN
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
	    T_TIPO_TPO('TPO','TPO'),
		T_TIPO_TPO('IGIC','IGIC'),
		T_TIPO_TPO('IGICREN','IGIC con renuncia'),
		T_TIPO_TPO('IVA','IVA'),
		T_TIPO_TPO('IVAREN','IVA con renuncia')
	); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
BEGIN	
	-- Borramos los registros, y si existen, luego los actualizamos con el merge
	V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_TRI_TRIBUTACION set BORRADO = 1';
	EXECUTE IMMEDIATE V_SQL; 
	
   	V_TABLENAME := V_ESQUEMA || '.DD_TRI_TRIBUTACION';
    V_SEQUENCENAME := V_ESQUEMA || '.S_DD_TRI_TRIBUTACION';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME || '.');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME || q'[ tabla  USING (select ']' || V_TMP_TIPO_TPO(1) || q'[' codigo, ']' || V_TMP_TIPO_TPO(2) || q'[' descripcion, ']' || V_TMP_TIPO_TPO(2) || 
            q'[' descripcion_larga, 'HR-1316' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
    ON (tabla.DD_TRI_CODIGO=actual.codigo)
    WHEN NOT MATCHED THEN
    INSERT (DD_TRI_ID,DD_TRI_CODIGO,DD_TRI_DESCRIPCION,DD_TRI_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
    VALUES (]' || V_SEQUENCENAME || q'[.NEXTVAL, actual.codigo, actual.descripcion, actual.descripcion_larga, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)
	WHEN MATCHED THEN
	UPDATE SET DD_TRI_DESCRIPCION=actual.descripcion, DD_TRI_DESCRIPCION_LARGA=actual.descripcion_larga, usuariomodificar=actual.usuariocrear, fechamodificar=actual.fechacrear, borrado=actual.borrado where DD_TRI_CODIGO=actual.codigo]';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || ': ' || V_TMP_TIPO_TPO(1) || '... registros afectados: ' || sql%rowcount);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION EN LA TABLA ' || V_TABLENAME);

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