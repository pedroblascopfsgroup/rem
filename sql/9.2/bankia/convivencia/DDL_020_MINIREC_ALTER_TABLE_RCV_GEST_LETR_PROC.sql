--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160629
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=RECOVERY-2110
--## PRODUCTO=SI
--## 
--## Finalidad: MODIFICAMOS CAMPOS A CAUSA DEL CAMBIO DE MODELO DE DATOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_MSQL VARCHAR(32000);   
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema Master
   V_DDNAME VARCHAR2(50 CHAR):= 'RCV_GEST_LETR_PROC';
   --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('COD_EST_ASE', 'COD_EST_ASE', 'VARCHAR2 (50 CHAR)')
     ,T_TIPO('IVA_DES', 'IVA_DES', 'VARCHAR2 (50 CHAR)')
     ,T_TIPO('CONTRATO_VIGOR', 'CONTRATO_VIGOR', 'VARCHAR2 (50 CHAR)')
     ,T_TIPO('CLASIFIC_PERFIL', 'CLASIFIC_PERFIL', 'VARCHAR2 (50 CHAR)')
     ,T_TIPO('REL_BANKIA', 'REL_ENTIDAD', 'VARCHAR2 (50 CHAR)')
    ); 
    
    

    
 V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);


BEGIN

dbms_output.enable(1000000);

--##########################################
--## BACKUP DE TABLAS DE BIENES
--##########################################

  DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_MINIREC||'.' || V_DDNAME ||'... ALTER TABLE');
  FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
   
       LOOP
            V_TMP_TIPO := V_TIPO(I);

 
            DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL CAMPO '||V_TMP_TIPO(2)||' EN LA TABLA ' || V_DDNAME|| '');
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME='''||V_TMP_TIPO(2)||''' AND TABLE_NAME=''' || V_DDNAME|| ''' AND OWNER='''||V_ESQUEMA_MINIREC||'''';   
            DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            -- Si existe la tabla no hacemos nada
            IF V_NUM_TABLAS = 1 THEN 
            
            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL CAMPO '||V_TMP_TIPO(2)||' , CAMBIAMOS TAMAÑO');
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA_MINIREC||'.' || V_DDNAME|| ' MODIFY '||V_TMP_TIPO(2)||' '||V_TMP_TIPO(3)||'';   
            
            ELSE
            
            DBMS_OUTPUT.PUT_LINE('NO EXISTE EL CAMPO, LO RENOMBRAMOS Y CAMBIAMOS TAMAÑO : '||V_TMP_TIPO(1)||' TO '||V_TMP_TIPO(2)||' ');
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA_MINIREC||'.' || V_DDNAME|| ' RENAME COLUMN '||V_TMP_TIPO(1)||' TO '||V_TMP_TIPO(2)||'';  
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA_MINIREC||'.' || V_DDNAME|| ' MODIFY '||V_TMP_TIPO(2)||' '||V_TMP_TIPO(3)||'';   

            end if;


       END LOOP;
            
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );



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