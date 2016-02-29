--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20160226
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-2023
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir un registro en diccionario tipo actor
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    TYPE T_TIPO_ACTOR IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TACTOR IS TABLE OF T_TIPO_ACTOR;

    V_USUARIO_CREAR VARCHAR2(10) := 'MIGRAPCO';
    V_TIPO_ACTOR T_ARRAY_TACTOR := T_ARRAY_TACTOR(
									T_TIPO_ACTOR('''PENDIENTE_MIG''', 'Pendiente de migración', 'Pendiente de migración', '1', '0'));
    V_DD_PCO_DSA_ID NUMBER(16,0);
    V_TMP_TIPO_ACTOR T_TIPO_ACTOR;
BEGIN
    DBMS_OUTPUT.PUT_LINE('************** Comprobando si existe el registro **************');
    DBMS_OUTPUT.PUT_LINE('SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_PCO_DOC_SOLICIT_TIPOACTOR WHERE DD_PCO_DSA_CODIGO = ''PENDIENTE_MIG'' ');
    V_MSQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA ||'.DD_PCO_DOC_SOLICIT_TIPOACTOR WHERE DD_PCO_DSA_CODIGO = ''PENDIENTE_MIG'''; 
    EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
  IF table_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('************** Insertando en DD_PCO_DOC_SOLICIT_TIPOACTOR **************');
    FOR I IN V_TIPO_ACTOR.FIRST .. V_TIPO_ACTOR.LAST
    LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_PCO_DOC_SOLICIT_ACTOR.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL 
      INTO V_DD_PCO_DSA_ID;
      V_TMP_TIPO_ACTOR := V_TIPO_ACTOR(I);     
      DBMS_OUTPUT.PUT_LINE('Insertando TIPO ACTOR: '|| V_DD_PCO_DSA_ID ||' DD_PCO_DSA_CODIGO = '|| V_TMP_TIPO_ACTOR(1));      
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PCO_DOC_SOLICIT_TIPOACTOR (DD_PCO_DSA_ID, DD_PCO_DSA_CODIGO, DD_PCO_DSA_DESCRIPCION, DD_PCO_DSA_DESCRIPCION_LARGA, DD_PCO_DSA_TRAT_EXP, DD_PCO_DSA_ACCESO_RECOVERY, USUARIOCREAR, FECHACREAR, BORRADO) 
      VALUES ('||V_DD_PCO_DSA_ID||','||V_TMP_TIPO_ACTOR(1)||','''||V_TMP_TIPO_ACTOR(2)||''','''||V_TMP_TIPO_ACTOR(3)||''','''||V_TMP_TIPO_ACTOR(4)||''','''||V_TMP_TIPO_ACTOR(5)||''','''||V_USUARIO_CREAR||''', SYSDATE, 0)';
      EXECUTE IMMEDIATE V_MSQL;
END LOOP; --LOOP TIPO_ACTOR 
END IF;
COMMIT;
   V_TMP_TIPO_ACTOR:= NULL;
   V_TIPO_ACTOR:= NULL;
   table_count:= NULL;
   
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
