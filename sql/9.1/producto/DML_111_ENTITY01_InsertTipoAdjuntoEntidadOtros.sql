/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20151124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-477
--## PRODUCTO=SI
--##
--## Finalidad: DML Poblacion de la tabla DD_TAE_TIPO_ADJUNTO_ENTIDAD con valores producto
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

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
T_TIPO_TPO('99999','Otros')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    TYPE T_REL IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_REL IS TABLE OF T_REL;
    V_REL T_ARRAY_REL := T_ARRAY_REL(
T_REL('99999','Persona'),
T_REL('99999','Contrato'),
T_REL('99999','Expediente')
    ); 
    V_TMP_REL T_REL;


BEGIN

    V_TABLENAME := V_ESQUEMA || '.DD_TAE_TIPO_ADJUNTO_ENTIDAD';
    V_SEQUENCENAME := V_ESQUEMA || '.S_DD_TAE_TIPO_ADJUNTO_ENTIDAD';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME || '.');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME || q'[ tabla  USING (select ']' || V_TMP_TIPO_TPO(1) || q'[' codigo, ']' || V_TMP_TIPO_TPO(2) || q'[' descripcion, ']' || V_TMP_TIPO_TPO(2) || 
            q'[' descripcion_larga, 'Producto' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
    ON (tabla.DD_TAE_CODIGO=actual.codigo)
    WHEN NOT MATCHED THEN
    INSERT (DD_TAE_ID,DD_TAE_CODIGO,DD_TAE_DESCRIPCION,DD_TAE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
    VALUES (]' || V_SEQUENCENAME || q'[.NEXTVAL, actual.codigo, actual.descripcion, actual.descripcion_larga, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)]';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME || ': ' || V_TMP_TIPO_TPO(1) || '... registros afectados: ' || sql%rowcount);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION DE EN LA TABLA ' || V_TABLENAME);

    V_TABLENAME2 := V_ESQUEMA || '.TAE_EIN';
    V_SEQUENCENAME2 := V_ESQUEMA || '.S_TAE_EIN';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME2 || '.');
    FOR I IN V_REL.FIRST .. V_REL.LAST LOOP
        V_TMP_REL := V_REL(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME2 || q'[ tabla  USING (select (select DD_TAE_ID from ]' || V_TABLENAME || q'[ where DD_TAE_CODIGO=']' || V_TMP_REL(1) || q'[') id_tae, 
            (select DD_EIN_ID from ]' || V_ESQUEMA_M || q'[.DD_EIN_ENTIDAD_INFORMACION where DD_EIN_DESCRIPCION=']' || V_TMP_REL(2) || q'[') id_ein, 
            'Producto' usuariocrear, sysdate fechacrear, 0 version, 0 borrado from DUAL) actual
    ON (tabla.DD_TAE_ID=actual.id_tae AND tabla.DD_EIN_ID=actual.id_ein)
    WHEN NOT MATCHED THEN
    INSERT (TAE_EIN_ID,DD_TAE_ID,DD_EIN_ID,USUARIOCREAR,FECHACREAR,VERSION,BORRADO)
    VALUES (]' || V_SEQUENCENAME2 || q'[.NEXTVAL, actual.id_tae, actual.id_ein, actual.usuariocrear, actual.fechacrear, actual.version, actual.borrado)]';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('---' || V_TABLENAME2 || ': ' || V_TMP_REL(1) || '-' || V_TMP_REL(2) || '... registros afectados: ' || sql%rowcount);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] FIN DE INSERCION DE EN LA TABLA ' || V_TABLENAME2);

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
