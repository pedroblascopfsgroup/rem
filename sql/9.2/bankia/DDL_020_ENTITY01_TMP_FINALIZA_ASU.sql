--/*
--##########################################
--## AUTOR=RAFAEL ARACIL LOPEZ  
--## FECHA_CREACION=20160226
--## ARTEFACTO=proc_finaliza_asu
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-1757
--## PRODUCTO=SI
--## 
--## Finalidad: CREAR TABLA DE FINALIZACION DE ASUNTOS TMP_FINALIZA_ASU
--## INSTRUCCIONES:  LANZAR Y LISTO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion BANK01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion BANK01 Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
     v_table_count number(38);


 BEGIN

   
DBMS_OUTPUT.PUT_LINE('[START]  tabla TMP_FINALIZA_ASU');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''TMP_FINALIZA_ASU'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.TMP_FINALIZA_ASU 
       (
   ASU_ID NUMBER(16,0) NOT NULL 
  ,COMENTARIO VARCHAR2(250 CHAR) NOT NULL 
)';


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.TMP_FINALIZA_ASU.. Tabla creada OK');


  end if;
  

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO DE CREACION');


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

