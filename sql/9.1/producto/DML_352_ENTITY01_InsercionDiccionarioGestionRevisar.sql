/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151223
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-547
--## PRODUCTO=SI
--##
--## Finalidad: DML Diccionario de Tipo de Gestion en tarea Revisar Expediente Preparar (precontencioso)
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
    
    V_TABLENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_SEQUENCENAME2 VARCHAR2(50 CHAR); -- Nombre de la tabla a crear


    TYPE T_REL IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_REL IS TABLE OF T_REL;
    V_REL T_ARRAY_REL := T_ARRAY_REL(
T_REL('SIN_GESTION','Sin Gestión'),
T_REL('AGENCIA_EXTERNA','Agencia Externa'),
T_REL('JUDICIALIZAR','Judicializar')
    ); 
    V_TMP_REL T_REL;


BEGIN

    V_TABLENAME2 := V_ESQUEMA || '.DD_PCO_GESTION_REVISAR';
    V_SEQUENCENAME2 := V_ESQUEMA || '.S_DD_PCO_GESTION_REVISAR';
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inserción en '||V_TABLENAME2 || '.');
    FOR I IN V_REL.FIRST .. V_REL.LAST LOOP
        V_TMP_REL := V_REL(I);
        V_SQL := q'[MERGE INTO ]' || V_TABLENAME2 || q'[ tabla  USING (select ']' || 
        V_TMP_REL(1) || q'[' DD_PCO_GRE_CODIGO, ']' || V_TMP_REL(2) || q'[' DD_PCO_GRE_DESCRIPCION, 'SAG' usuariocrear, sysdate fechacrear from dual) actual
    ON (tabla.DD_PCO_GRE_CODIGO=actual.DD_PCO_GRE_CODIGO)
    WHEN NOT MATCHED THEN
    INSERT (DD_PCO_GRE_ID,DD_PCO_GRE_CODIGO,DD_PCO_GRE_DESCRIPCION,DD_PCO_GRE_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
    VALUES (]' || V_SEQUENCENAME2 || q'[.NEXTVAL, actual.DD_PCO_GRE_CODIGO, actual.DD_PCO_GRE_DESCRIPCION, actual.DD_PCO_GRE_DESCRIPCION, actual.usuariocrear, actual.fechacrear)]';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
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

