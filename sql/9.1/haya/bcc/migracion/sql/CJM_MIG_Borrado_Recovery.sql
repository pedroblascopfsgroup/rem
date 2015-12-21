--/*************************************************
--*                                                *
--*      SCRIPT BORRADO MIGRACION FASE II     v.10 *
--*      --------------------------------          *
--*     Borrado de BPMs y tablas maestras.         *
--*                                                *
--*************************************************/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        EXISTE       NUMBER;
        EXISTE2      NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRAHAYA02';
        USUARIO2     VARCHAR2(50 CHAR):= 'MIGRAHAYA02PCO';
        USUARIO3     VARCHAR2(50 CHAR):= 'ALTAASUNCM';
        USUARIO4     VARCHAR2(50 CHAR):= 'SINCRO_CM_HAYA';              
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    

----------------------------
--  DESACTIVACION DE FKs  --
----------------------------
PROCEDURE "PRO_KEYS_STATUS"("P_OWNER" IN VARCHAR2, "P_TABLA" IN VARCHAR2, "P_ACCION" IN VARCHAR2) 
IS
    
        -- Claves a desactivar
        TYPE clave IS RECORD (table_owner     VARCHAR2(30)
                             ,table_name      VARCHAR2(30) 
                             ,constraint_name VARCHAR2(30)
                             ,column_name_fk  VARCHAR2(150)
                             ,column_name_pk  VARCHAR2(150));
        
        TYPE t_clave IS TABLE OF clave;
        v_clave  t_clave;
        
        -- Tabla a la que apuntan
        v_owner         VARCHAR2(30);
        v_table         VARCHAR2(30);
        v_constraint_pk VARCHAR2(30);
        v_status        VARCHAR2(30);
        
        -- Acci?n a realizar
        v_action        VARCHAR2(10);
    
    BEGIN
      
        --** Tabla a manipular y acci?n (enable/disable)
        v_owner := trim(upper(p_owner));
        v_table := trim(upper(p_tabla));
        v_action:= trim(upper(p_accion));

        --** Buscamos nombre de la clave primaria de la tabla a manipular
        v_sql:='SELECT con.constraint_name
                  FROM sys.all_Constraints con
                 WHERE con.table_name = '''||v_table||''' 
                   AND con.owner = '''||v_owner||'''
                   AND con.constraint_type = ''P''
               ';
   
        EXECUTE IMMEDIATE v_sql INTO v_constraint_pk;
        DBMS_OUTPUT.PUT_LINE('Buscamos clave: '''||v_constraint_pk||'''');
               
        
        --** Recuperamos todas las claves ajenas que apuntan a la primaria de la tabla a manipular
        --** y las columnas que las forman 
        SELECT owner, table_name
             , constraint_name
             , wm_concat(column_name_fk) column_name_fk
             , wm_concat(column_name_pk) column_name_pk
        BULK COLLECT INTO v_clave
        FROM ( SELECT fk.owner, fk.table_name, fk.constraint_name
                    , clf.column_name as column_name_fk
                    , clp.column_name as column_name_pk
                 FROM sys.all_Constraints  pk
                    , sys.all_Constraints  fk
                    , sys.all_cons_columns clp
                    , sys.all_cons_columns clf
                WHERE pk.constraint_name   = v_constraint_pk
                  AND pk.constraint_type   = 'P'
                  AND pk.constraint_name   = clp.constraint_name
                  AND fk.constraint_name   = clf.constraint_name
                  AND fk.r_constraint_name = pk.constraint_name
                  AND clp.position = clf.position
                  AND fk.owner = v_owner )
        GROUP BY owner, table_name, constraint_name;
        
       IF v_clave.count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existen claves a desactivar.');
        
       ELSE
        --** Iniciamos cambio de estado de las claves
        FOR i IN v_clave.FIRST .. v_clave.LAST LOOP 
        
           existe2 := 0;
           --** Comprobamos integridad referencial
           v_sql:='SELECT count(*)
                     FROM '||v_clave(i).table_owner||'.'||v_clave(i).table_name||'
                    WHERE ('||v_clave(i).column_name_fk||') 
                       IN (Select '||v_clave(i).column_name_pk||' From '||v_owner||'.'||v_table||' Where usuariocrear = '''||USUARIO||''')
                  ';
           EXECUTE IMMEDIATE v_sql INTO existe2;
           
           IF existe2>0
            THEN 
               --** ERROR
               DBMS_OUTPUT.PUT_LINE('Error de integridad referencial. Existen registros en: '||v_clave(i).table_owner||'.'||v_clave(i).table_name||' para la clave: '||v_clave(i).constraint_name||'');
            ELSE 
            
               --** Desactivamos claves ajenas
               v_sql:='ALTER TABLE '||v_clave(i).table_owner||'.'||v_clave(i).table_name||' '||v_action||' constraint '||v_clave(i).constraint_name;
               EXECUTE IMMEDIATE v_sql;
               v_sql:='select status from sys.all_Constraints where constraint_name = '''||v_clave(i).constraint_name||''' and owner='''||v_clave(i).table_owner||'''';
               EXECUTE IMMEDIATE v_sql INTO v_status;
               DBMS_OUTPUT.PUT_LINE('Clave: '||v_clave(i).table_name||'.'||v_clave(i).constraint_name||' establecida a: '||v_status);
               
           END IF;

        END LOOP;
        
       END IF;
       
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('No existen claves a desactivar.');     
    END; 


BEGIN

--##########################################
--## TABLAS TEMPORALES
--##########################################

      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TABLA_TMP_ASU'''  INTO EXISTE;

      IF EXISTE > 0 THEN
              EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_ASU PURGE ';
      END IF;

     EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.TABLA_TMP_ASU AS ( SELECT ASU_ID  FROM  '||V_ESQUEMA||'.ASU_ASUNTOS Where usuariocrear = '''||USUARIO||'''
                                                                        UNION
                                                                        SELECT ASU_ID  FROM  '||V_ESQUEMA||'.ASU_ASUNTOS Where usuariocrear = '''||USUARIO2||'''
                                                                        UNION
                                                                        SELECT ASU_ID  FROM  '||V_ESQUEMA||'.ASU_ASUNTOS Where usuariocrear = '''||USUARIO3||'''
                                                                        UNION
                                                                        SELECT ASU_ID  FROM  '||V_ESQUEMA||'.ASU_ASUNTOS Where usuariocrear = '''||USUARIO4||'''                                                                        
                                                                        )';
     --
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_ASU... Tabla creada. '||SQL%ROWCOUNT||' Filas.');

     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.TABLA_TMP_ASU ADD CONSTRAINT PK_TABLA_TMP_ASU PRIMARY KEY(ASU_ID)';
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_ASU... PK creada');

     EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TABLA_TMP_ASU COMPUTE STATISTICS');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_ASU... Estadisticas actualizadas');
     

--    **************************/
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TABLA_TMP_PRC'''  INTO EXISTE;

      IF EXISTE > 0 THEN
              EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_PRC PURGE ';
      END IF;

     EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.TABLA_TMP_PRC AS ( 
        SELECT DISTINCT PRC.PRC_ID , PRC_PROCESS_BPM FROM  '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC, TABLA_TMP_ASU TMP Where PRC.ASU_ID = TMP.ASU_ID)';
     --
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_PRC... Tabla creada. '||SQL%ROWCOUNT||' Filas.');
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.TABLA_TMP_PRC ADD CONSTRAINT PK_TABLA_TMP_PRC PRIMARY KEY(PRC_ID)';
     EXECUTE IMMEDIATE 'CREATE INDEX idx_borrado_prc_2 ON '||V_ESQUEMA||'.TABLA_TMP_PRC (PRC_PROCESS_BPM)';
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_PRC... Indices creados');

     EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TABLA_TMP_PRC COMPUTE STATISTICS');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_PRC... Estadisticas actualizadas');

--    **************************/
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TABLA_TMP_EXP'''  INTO EXISTE;

      IF EXISTE > 0 THEN
              EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_EXP PURGE ';
      END IF;

     EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.TABLA_TMP_EXP AS ( 
        SELECT DISTINCT EXP.EXP_ID  FROM  '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP, ASU_ASUNTOS ASU, TABLA_TMP_ASU TMP WHERE EXP.EXP_ID = ASU.EXP_ID AND ASU.ASU_ID = TMP.ASU_ID)';
     --
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_EXP... Tabla creada. '||SQL%ROWCOUNT||' Filas.');
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.TABLA_TMP_EXP ADD CONSTRAINT PK_TABLA_TMP_EXP PRIMARY KEY(EXP_ID)';
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_EXP... PK creada');
     EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TABLA_TMP_EXP COMPUTE STATISTICS');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_EXP... Estadisticas actualizadas');

--    **************************/
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TABLA_TMP_BIE'''  INTO EXISTE;

      IF EXISTE > 0 THEN
              EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_BIE PURGE ';
      END IF;

     EXECUTE IMMEDIATE ('CREATE TABLE '||V_ESQUEMA||'.TABLA_TMP_BIE AS  
                                    SELECT DISTINCT BIE.BIE_ID  FROM  '||V_ESQUEMA||'.BIE_BIEN BIE WHERE USUARIOCREAR = '''||USUARIO||'''
                                    UNION
                                    SELECT DISTINCT BIE.BIE_ID  FROM  '||V_ESQUEMA||'.BIE_BIEN BIE WHERE USUARIOCREAR = '''||USUARIO2||'''
                                    UNION
                                    SELECT DISTINCT BIE.BIE_ID  FROM  '||V_ESQUEMA||'.BIE_BIEN BIE WHERE USUARIOCREAR = '''||USUARIO2||'''
                                    UNION
                                    SELECT DISTINCT BIE.BIE_ID  FROM  '||V_ESQUEMA||'.BIE_BIEN BIE WHERE USUARIOCREAR = '''||USUARIO3||'''        
                       ');
     --
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_BIE... Tabla creada. '||SQL%ROWCOUNT||' Filas.');
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.TABLA_TMP_BIE ADD CONSTRAINT PK_TABLA_TMP_BIE PRIMARY KEY(BIE_ID)';
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_BIE... PK creada');
     EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TABLA_TMP_BIE COMPUTE STATISTICS');
     DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_TMP_BIE... Estadisticas actualizadas');


--##########################################
--## BORRADO SELECTIVO DE DATOS. EL ORDEN ES IMPORTANTE
--##########################################
--    /*************************
--    *BORRADO DE BMPs*
--    **************************/

/*
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TABLA_BPM'''  INTO EXISTE;

      IF EXISTE > 0 THEN
              EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_BPM PURGE ';
      END IF;


     EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.TABLA_BPM AS (
     SELECT PRC.PRC_ID, PRC.PRC_PROCESS_BPM, INS.ID_ PROCESSINSTANCES, TOK.ID_ TOKENS, MODU.ID_ MODULEINSTANCES, TKVM.ID_ TOKENVARIABLEMAPS, VINS.ID_ VARIABLEINSTANCES
     FROM  '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
       LEFT JOIN '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE INS ON PRC.PRC_PROCESS_BPM = INS.ID_
       LEFT JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKEN TOK ON INS.ID_ = TOK.PROCESSINSTANCE_
       LEFT JOIN '||V_ESQUEMA_MASTER||'.JBPM_MODULEINSTANCE MODU ON INS.ID_ = MODU.PROCESSINSTANCE_
       LEFT JOIN '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP TKVM ON TOK.ID_ = TKVM.TOKEN_
       LEFT JOIN '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE VINS ON INS.ID_ = VINS.PROCESSINSTANCE_
     WHERE prc.PRC_PROCESS_BPM IS NOT NULL)';

	EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TABLA_BPM COMPUTE STATISTICS');
     	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TABLA_BPM... Estadisticas actualizadas');

      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TABLA_BPM'  INTO EXISTE;

      IF EXISTE > 0 THEN
            
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_JOB J where NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TABLA_TMP_PRC where PRC_PROCESS_BPM = J.PROCESSINSTANCE_)';
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_JOB where PROCESSINSTANCE_ IN (SELECT DISTINCT PROCESSINSTANCES FROM '||V_ESQUEMA||'.TABLA_BPM)';
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_JOB where TOKEN_ IN (SELECT DISTINCT TOKENS FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE where PROCESSINSTANCE_ NOT IN (SELECT DISTINCT PRC_PROCESS_BPM FROM '||V_ESQUEMA||'.TABLA_TMP_PRC)';
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE  WHERE TOKEN_ NOT IN (
                  SELECT DISTINCT ROOTTOKEN_ FROM '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE I JOIN TABLA_TMP_PRC P ON I.ID_ = P.PRC_PROCESS_BPM
                )';
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_VARIABLEINSTANCE where ID_ IN (SELECT DISTINCT VARIABLEINSTANCES FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
             EXECUTE IMMEDIATE 'DELETE '||V_ESQUEMA_MASTER||' .JBPM_TOKENVARIABLEMAP WHERE TOKEN_ NOT IN (
                  SELECT DISTINCT ROOTTOKEN_ FROM '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE I JOIN TABLA_TMP_PRC P ON I.ID_ = P.PRC_PROCESS_BPM
                )';
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_TOKENVARIABLEMAP where ID_ IN (SELECT DISTINCT TOKENVARIABLEMAPS FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_MODULEINSTANCE M where NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TABLA_TMP_PRC where PRC_PROCESS_BPM = M.PROCESSINSTANCE_)';

             EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_MODULEINSTANCE where ID_ IN (SELECT DISTINCT MODULEINSTANCES FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
             EXECUTE IMMEDIATE 'update '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE I set roottoken_ = null where NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TABLA_TMP_PRC where PRC_PROCESS_BPM = I.ID_)';

             EXECUTE IMMEDIATE 'update '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE set roottoken_ = null where roottoken_ in (SELECT TOKENS FROM '||V_ESQUEMA||'.TABLA_BPM)';
           
            existe := 0;

	    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_TAR_TAR_ID_ASU_ID'' and table_name=''TAR_TAREAS_NOTIFICACIONES'' 			     and table_owner = ''' || V_ESQUEMA || '''';
	    EXECUTE IMMEDIATE v_sql INTO existe;

	    IF (existe=0) THEN
	       EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.IDX_TAR_TAR_ID_ASU_ID ON '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES(TAR_ID, ASU_ID)');
	    END IF;

	     EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET TEX_TOKEN_ID_BPM = NULL WHERE TEX_ID IN 
                       ( SELECT TEX_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
                         INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU ASU ON ASU.ASU_ID = TAR.ASU_ID)';
             
	    EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET TEX_TOKEN_ID_BPM = NULL WHERE TEX_TOKEN_ID_BPM  in (SELECT DISTINCT TOKENS FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
            EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_TOKEN T where NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TABLA_TMP_PRC where PRC_PROCESS_BPM = T.PROCESSINSTANCE_)';
             
	    EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_TOKEN where ID_ IN (SELECT DISTINCT TOKENS FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
            EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE I where NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TABLA_TMP_PRC where PRC_PROCESS_BPM = I.ID_)';
            
	    EXECUTE IMMEDIATE 'delete  '||V_ESQUEMA_MASTER||'.JBPM_PROCESSINSTANCE where ID_ IN (SELECT DISTINCT PROCESSINSTANCES FROM '||V_ESQUEMA||'.TABLA_BPM)';
             
             DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PROCEDIMIENTOS BMP .. Se han eliminado '||EXISTE||' registros por tabla');

      END IF;

     EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_BPM PURGE ';
*/


--    /*************************
--    *ORDEN DE BORRADO ULTIMO *
--    **************************/
    
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_EXP EXP
                                                                           WHERE EXP.EXP_ID       = HAC.EXP_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                             FROM '||V_ESQUEMA||'.TABLA_TMP_EXP EXP
                                                                           WHERE EXP.EXP_ID       = HAC.EXP_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PROCEDIMIENTOS EN '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS .. Se han eliminado '||EXISTE||' registros');
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'ENABLE');
           COMMIT;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_ASU ASU
                                                                           WHERE ASU.ASU_ID       = HAC.ASU_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_ASU ASU
                                                                           WHERE ASU.ASU_ID       = HAC.ASU_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PROCEDIMIENTOS EN '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS .. Se han eliminado '||EXISTE||' registros');
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'ENABLE');
           COMMIT;
      END IF;
     
     
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = HAC.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT *
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = HAC.PRC_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' PROCEDIMIENTOS EN '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS .. Se han eliminado '||EXISTE||' registros');
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'ENABLE');
           COMMIT;
      END IF;
      
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA ||'.TABLA_TMP_BIE  BIE
                                                                           WHERE BIE.BIE_ID       = HAC.BIE_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.HAC_HISTORICO_ACCESOS HAC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA ||'.TABLA_TMP_BIE  BIE
                                                                           WHERE BIE.BIE_ID       = HAC.BIE_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' BIENES EN '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS .. Se han eliminado '||EXISTE||' registros');
           PRO_KEYS_STATUS(V_ESQUEMA, 'HAC_HISTORICO_ACCESOS', 'ENABLE');
           COMMIT;
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO GAH
               INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU ASU ON GAH.GAH_ASU_ID = ASU.ASU_ID';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'GAH_GESTOR_ADICIONAL_HISTORICO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.GAH_GESTOR_ADICIONAL_HISTORICO GAH
               WHERE GAH.GAH_ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'GAH_GESTOR_ADICIONAL_HISTORICO', 'ENABLE');
      END IF; 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA
               INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU ASU ON GAA.ASU_ID = ASU.ASU_ID';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'GAA_GESTOR_ADICIONAL_ASUNTO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.GAA_GESTOR_ADICIONAL_ASUNTO GAA
               WHERE GAA.ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'GAA_GESTOR_ADICIONAL_ASUNTO', 'ENABLE');
      END IF;

--    /********************
--    *ORDEN DE BORRADO 8 *
--    ********************/

      -- Recursos
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS RCR WHERE EXISTS (SELECT (1) FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                                                  WHERE RCR.PRC_ID = PRC.PRC_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS RCR WHERE EXISTS (SELECT (1) FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                                                  WHERE RCR.PRC_ID = PRC.PRC_ID)';
                                                                                           
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'ENABLE');
           
      END IF;
      

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOB_LOTE_BIEN... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.LOB_LOTE_BIEN LOB WHERE EXISTS (SELECT (1) FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS 
                                                                                     INNER JOIN SUB_SUBASTA SUB ON LOS.SUB_ID = SUB.SUB_ID
                                                                                     INNER JOIN TABLA_TMP_ASU ASU ON SUB.ASU_ID = ASU.ASU_ID
                                                                                     WHERE LOS.LOS_ID = LOB.LOS_ID
                                                                                       )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOB_LOTE_BIEN', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.LOB_LOTE_BIEN LOB WHERE EXISTS (SELECT (1) FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS 
                                                                                     INNER JOIN SUB_SUBASTA SUB ON LOS.SUB_ID = SUB.SUB_ID
                                                                                     INNER JOIN TABLA_TMP_ASU ASU ON SUB.ASU_ID = ASU.ASU_ID
                                                                                     WHERE LOS.LOS_ID = LOB.LOS_ID
                                                                                       )';
                                                                                           
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOB_LOTE_BIEN .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOB_LOTE_BIEN', 'ENABLE');
           
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOB_LOTE_BIEN(2)... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.LOB_LOTE_BIEN LOB WHERE EXISTS (SELECT * FROM '||V_ESQUEMA||'.TABLA_TMP_BIE BIE 
                                                                                     WHERE BIE.BIE_ID = LOB.BIE_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOB_LOTE_BIEN', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.LOB_LOTE_BIEN LOB WHERE EXISTS (SELECT * FROM '||V_ESQUEMA||'.TABLA_TMP_BIE BIE 
                                                                                     WHERE BIE.BIE_ID = LOB.BIE_ID)';
                                                                                           
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOB_LOTE_BIEN(2) .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOB_LOTE_BIEN', 'ENABLE');
           
      END IF;

--    /********************
--    *ORDEN DE BORRADO 7 *
--    ********************/

       DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOS_LOTE_SUBASTA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.LOS_LOTE_SUBASTA LOS
                                             INNER JOIN SUB_SUBASTA SUB ON LOS.SUB_ID = SUB.SUB_ID
                                             INNER JOIN TABLA_TMP_ASU ASU ON SUB.ASU_ID = ASU.ASU_ID';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOS_LOTE_SUBASTA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.LOS_LOTE_SUBASTA LOS WHERE EXISTS (
                                             SELECT (1) FROM SUB_SUBASTA SUB 
                                             INNER JOIN TABLA_TMP_ASU ASU ON SUB.ASU_ID = ASU.ASU_ID 
                                             WHERE LOS.SUB_ID = SUB.SUB_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.LOS_LOTE_SUBASTA .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'LOS_LOTE_SUBASTA', 'ENABLE');
      END IF;

--    /********************
--    *ORDEN DE BORRADO 6 *
--    ********************/
      --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS EMP 
                                                    INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_BIE BIE ON BIE.BIE_ID =EMP.BIE_ID';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'EMP_NMBEMBARGOS_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS EMP WHERE EXISTS
                                                   (SELECT (1) FROM '||V_ESQUEMA||'.TABLA_TMP_BIE BIE WHERE BIE.BIE_ID =EMP.BIE_ID)';
                                                   
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'EMP_NMBEMBARGOS_PROCEDIMIENTOS', 'ENABLE');
      END IF;
      --
     
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SUB_SUBASTA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.SUB_SUBASTA SUB WHERE SUB.ASU_ID IN 
                                      (SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'SUB_SUBASTA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.SUB_SUBASTA SUB WHERE SUB.ASU_ID IN 
                                      (SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SUB_SUBASTA .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'SUB_SUBASTA', 'ENABLE');
      END IF;
      --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_BUR_ENVIO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_BUR_ENVIO PBUR WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC, '||V_ESQUEMA||'.PCO_BUR_BUROFAX PCO, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCOPRC
                                                                            WHERE PBUR.PCO_BUR_BUROFAX_ID = PCO.PCO_BUR_BUROFAX_ID
                                                                            AND PCO.PCO_PRC_ID = PCOPRC.PCO_PRC_ID
                                                                            AND PCOPRC.PRC_ID       = PRC.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_BUR_ENVIO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_BUR_ENVIO PBUR WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC, '||V_ESQUEMA||'.PCO_BUR_BUROFAX PCO, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCOPRC
                                                                            WHERE PBUR.PCO_BUR_BUROFAX_ID = PCO.PCO_BUR_BUROFAX_ID
                                                                            AND PCO.PCO_PRC_ID = PCOPRC.PCO_PRC_ID
                                                                            AND PCOPRC.PRC_ID       = PRC.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_BUR_ENVIO .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_BUR_ENVIO', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_BUR_BUROFAX... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_BUR_BUROFAX PBUR WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                            WHERE PBUR.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                            AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_BUR_BUROFAX', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_BUR_BUROFAX PBUR WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                            WHERE PBUR.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                            AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_BUR_BUROFAX .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_BUR_BUROFAX', 'ENABLE');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES PSOL WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS PDOC, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PSOL.PCO_DOC_PDD_ID = PDOC.PCO_DOC_PDD_ID
                                                                                           AND PDOC.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_DOC_SOLICITUDES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_DOC_SOLICITUDES PSOL WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS PDOC, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PSOL.PCO_DOC_PDD_ID = PDOC.PCO_DOC_PDD_ID
                                                                                           AND PDOC.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_DOC_SOLICITUDES', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS PDOC WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PDOC.PCO_PRC_ID = PCO.PCO_PRC_ID 
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_DOC_DOCUMENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_DOC_DOCUMENTOS PDOC WHERE EXISTS (SELECT (1) 
                                                                                          FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PDOC.PCO_PRC_ID = PCO.PCO_PRC_ID 
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_DOC_DOCUMENTOS', 'ENABLE');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES PLIQ WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PLIQ.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_LIQ_LIQUIDACIONES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_LIQ_LIQUIDACIONES PLIQ WHERE EXISTS (SELECT (1) 
                                                                                          FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                                                                                           WHERE PLIQ.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_LIQ_LIQUIDACIONES', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP PRCH WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.pco_prc_procedimientos pco
                                                                                           WHERE PRCH.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;

      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_PRC_HEP_HISTOR_EST_PREP', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_PRC_HEP_HISTOR_EST_PREP PRCH WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP, '||V_ESQUEMA||'.pco_prc_procedimientos pco
                                                                                           WHERE PRCH.PCO_PRC_ID = PCO.PCO_PRC_ID
                                                                                           AND PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_PRC_HEP_HISTOR_EST_PREP', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_PER... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRC_PER PRP WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = PRP.PRC_ID)'  ;



      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_PRC_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PCO_PRC_PROCEDIMIENTOS PCO WHERE EXISTS (SELECT (1) 
                                                                                           FROM '||V_ESQUEMA||'.TABLA_TMP_PRC TMP
                                                                                           WHERE PCO.PRC_ID       = TMP.PRC_ID)'  ;
                                                                            
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PCO_PRC_PROCEDIMIENTOS', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRC_PER PRP WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = PRP.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_PER', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRC_PER PRP WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = PRP.PRC_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_PER .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_PER', 'ENABLE');
      END IF; 
      
      -- CRE_PRC_CEX
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRE_PRC_CEX... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CRE_PRC_CEX CPC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID = CPC.CRE_PRC_CEX_PRCID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRE_PRC_CEX', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CRE_PRC_CEX CPC WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID = CPC.CRE_PRC_CEX_PRCID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRE_PRC_CEX... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRE_PRC_CEX', 'ENABLE');
      END IF;      
      
      --PRC_CEX
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_CEX... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRC_CEX PRX WHERE EXISTS (SELECT * 
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = PRX.PRC_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_CEX', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRC_CEX PRX  WHERE EXISTS (SELECT *
                                                                            FROM '||V_ESQUEMA||'.TABLA_TMP_PRC PRC
                                                                           WHERE PRC.PRC_ID       = PRX.PRC_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_CEX .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_CEX', 'ENABLE');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_CEX(2)... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRC_CEX PRX WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                                                                            INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_EXP EXP ON CEX.EXP_ID = EXP.EXP_ID
                                                                           WHERE CEX.CEX_ID       = PRX.CEX_ID)'  ;
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_CEX', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRC_CEX PRX  WHERE EXISTS (SELECT (1) 
                                                                            FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                                                                            INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_EXP EXP ON CEX.EXP_ID = EXP.EXP_ID
                                                                           WHERE CEX.CEX_ID       = PRX.CEX_ID)'  ;
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_CEX(2) .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_CEX', 'ENABLE');
      END IF;

            existe := 0;
	    v_sql:= 'select count(*) from all_indexes where index_name=''IDX_TEV_TEX_ID'' and table_name=''TEV_TAREA_EXTERNA_VALOR''    and table_owner = ''' || V_ESQUEMA || '''';
	    EXECUTE IMMEDIATE v_sql INTO existe;
	    IF (existe=0) THEN
	       EXECUTE IMMEDIATE('CREATE INDEX '||V_ESQUEMA||'.IDX_TEV_TEX_ID ON '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR(TEX_ID)');
	    END IF; 
      
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN( SELECT TEX_ID 
                                                                                         FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
                                                                                            , '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
                                                                                            , '||V_ESQUEMA||'.TABLA_TMP_ASU asu
                                                                                        WHERE tex.TAR_ID = tar.TAR_ID
                                                                                          AND tar.ASU_ID = asu.ASU_ID )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEV_TAREA_EXTERNA_VALOR', 'DISABLE');

	   EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS FOR ALL INDEXES');
	   EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS FOR ALL INDEXES');

           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN( SELECT TEX_ID 
                                                                                         FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex
                                                                                            , '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar
                                                                                            , '||V_ESQUEMA||'.TABLA_TMP_ASU asu
                                                                                        WHERE tex.TAR_ID = tar.TAR_ID
                                                                                          AND tar.ASU_ID = asu.ASU_ID )';

           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR .. Se han eliminado '|| EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEV_TAREA_EXTERNA_VALOR', 'ENABLE');
      END IF;
      --
       DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TER_TAREA_EXTERNA_RECUPERACION... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TER_TAREA_EXTERNA_RECUPERACION WHERE TEX_ID IN 
                       ( SELECT TEX_ID FROM TEX_TAREA_EXTERNA TEX
                         INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU ASU ON ASU.ASU_ID = TAR.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TER_TAREA_EXTERNA_RECUPERACION', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TER_TAREA_EXTERNA_RECUPERACION WHERE TEX_ID IN 
                       ( SELECT TEX_ID FROM TEX_TAREA_EXTERNA TEX
                         INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU ASU ON ASU.ASU_ID = TAR.ASU_ID) ';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TER_TAREA_EXTERNA_RECUPERACION .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TER_TAREA_EXTERNA_RECUPERACION', 'ENABLE');
      END IF;
      --
     
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEX_TAREA_EXTERNA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN ( SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TABLA_TMP_ASU ASU WHERE ASU.ASU_ID = TAR.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEX_TAREA_EXTERNA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN ( SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TABLA_TMP_ASU ASU WHERE ASU.ASU_ID = TAR.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEX_TAREA_EXTERNA .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEX_TAREA_EXTERNA', 'ENABLE');
      END IF;
      --
     
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA WHERE TAR_ID IN ( SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TABLA_TMP_ASU ASU WHERE ASU.ASU_ID = TAR.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'SPR_SOLICITUD_PRORROGA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.SPR_SOLICITUD_PRORROGA WHERE TAR_ID IN ( SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TABLA_TMP_ASU ASU WHERE ASU.ASU_ID = TAR.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'SPR_SOLICITUD_PRORROGA', 'ENABLE');
      END IF;
      --
      
      -- CRT_CICLO_RECOBRO_TAREA_NOTI
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRT_CICLO_RECOBRO_TAREA_NOTI... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CRT_CICLO_RECOBRO_TAREA_NOTI WHERE TAR_ID IN (
                                                  SELECT TAR_ID 
                                                  FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRT_CICLO_RECOBRO_TAREA_NOTI', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CRT_CICLO_RECOBRO_TAREA_NOTI WHERE TAR_ID IN (
                                                  SELECT TAR_ID 
                                                  FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRT_CICLO_RECOBRO_TAREA_NOTI... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRT_CICLO_RECOBRO_TAREA_NOTI', 'ENABLE');
      END IF;   
      
      -- PRD_PROCEDIMIENTOS_DERIVADOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN (
                                                    SELECT DPR_ID
                                                    FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR
                                                      JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON DPR.TAR_ID = TAR.TAR_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN (
                                                    SELECT DPR_ID
                                                    FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR
                                                      JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON DPR.TAR_ID = TAR.TAR_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'ENABLE');
      END IF;      
      
      --DPR_DECISIONES_PROCEDIMIENTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                    SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'DPR_DECISIONES_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.DPR_DECISIONES_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                    SELECT TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           EXECUTE IMMEDIATE 'Alter table '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS enable constraint FK_PRC_PROC_REFERENCE_PRC_PROC';
           PRO_KEYS_STATUS(V_ESQUEMA, 'DPR_DECISIONES_PROCEDIMIENTOS', 'ENABLE');
      END IF;       
      
      -- RCR_RECURSOS_PROCEDIMIENTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                SELECT TAR_ID 
                                                FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.RCR_RECURSOS_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                SELECT TAR_ID 
                                                FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON TAR.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'ENABLE');
      END IF;      

      -- ADA_ADJUNTOS_ASUNTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS WHERE ASU_ID IN (
                                                SELECT ASU_ID 
                                                FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADA_ADJUNTOS_ASUNTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ADA_ADJUNTOS_ASUNTOS WHERE ASU_ID IN (
                                                SELECT ASU_ID 
                                                FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';

           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADA_ADJUNTOS_ASUNTOS', 'ENABLE');
      END IF;    
      
      ---TAR_TAREAS_NOTIFICACIONES
      --- EJD:> Incluimos borrado de todo lo que sea Solicitudes de Prorrogas ya borradas.	
/*  
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES... Que apunten a Solicitudes de Prorrogas borradas.');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar where tar.spr_id NOT in (SELECT spr.spr_ID FROM '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA spr ) and tar.spr_id is not null';        
                                                                                                                             
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES tar where tar.spr_id NOT in (SELECT spr.spr_ID FROM '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA spr ) and tar.spr_id is not null';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES .. Se han eliminado con Solicitud de Prorroga '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'ENABLE');
      END IF;
*/

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';                                                                                                                                      
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'DISABLE');

           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES .. Se han eliminado '||EXISTE||' registros');

           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES tar where tar.spr_id NOT in (SELECT spr.spr_ID FROM '||V_ESQUEMA||'.SPR_SOLICITUD_PRORROGA spr ) and tar.spr_id is not null';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES .. Se han eliminado con Solicitud de Prorroga '||EXISTE||' registros');

           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'ENABLE');
      END IF;
      
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRB_PRC_BIE... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRB_PRC_BIE WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE ) AND PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRB_PRC_BIE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRB_PRC_BIE WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE ) AND PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRB_PRC_BIE .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRB_PRC_BIE', 'ENABLE');
      END IF; 
/*
      -- 
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_DATOS_REGISTRALES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_DATOS_REGISTRALES WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_DATOS_REGISTRALES', 'ENABLE');
      END IF; 
      
    --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_LOCALIZACION... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_LOCALIZACION WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_LOCALIZACION', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_LOCALIZACION WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_LOCALIZACION .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_LOCALIZACION', 'ENABLE');
      END IF; 
      
    --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_VALORACIONES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_VALORACIONES WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_VALORACIONES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_VALORACIONES WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_VALORACIONES .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_VALORACIONES', 'ENABLE');
      END IF; 
      
      --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ADICIONAL... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_ADICIONAL WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ADICIONAL', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_ADICIONAL WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ADICIONAL .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ADICIONAL', 'ENABLE');
      END IF; 

      --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ADJ_ADJUDICACION', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ADJ_ADJUDICACION', 'ENABLE');
      END IF; 

        --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_PER... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_PER WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_PER', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_PER WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_PER .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_PER', 'ENABLE');
      END IF; 
        --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CNT... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_CNT WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_CNT', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_CNT WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CNT .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_CNT', 'ENABLE');
      END IF; 
        --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CAR_CARGAS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_CAR_CARGAS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_CAR_CARGAS WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CAR_CARGAS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_CAR_CARGAS', 'ENABLE');
      END IF; 
        --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO WHERE TEA_ID IN 
                 ( SELECT TEA_ID FROM BIE_TEA TEA
                   INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_BIE BIE ON BIE.BIE_ID = TEA.BIE_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_TERMINOS_ACUERDO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TEA_TERMINOS_ACUERDO WHERE TEA_ID IN 
                 ( SELECT TEA_ID FROM BIE_TEA TEA
                   INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_BIE BIE ON BIE.BIE_ID = TEA.BIE_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CAR_CARGAS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_TERMINOS_ACUERDO', 'ENABLE');
      END IF; 
        --
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_TEA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_TEA WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_TEA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_TEA WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_CAR_CARGAS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_TEA', 'ENABLE');
      END IF; 
*/
--    /********************
--    *ORDEN DE BORRADO 5 *
--    ********************/
/*
     

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_BIEN... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_BIEN';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_BIEN', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_BIEN WHERE BIE_ID IN ( SELECT BIE_ID FROM '||V_ESQUEMA||'.TABLA_TMP_BIE )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_BIEN .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_BIEN', 'ENABLE');
      END IF;      
*/
      -- PRD_PROCEDIMIENTOS_DERIVADOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN (
                                                    SELECT DPR_ID
                                                    FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR
                                                        JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC PRC ON DPR.PRC_ID = PRC.PRC_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE DPR_ID IN (
                                                    SELECT DPR_ID
                                                    FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS DPR
                                                        JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC PRC ON DPR.PRC_ID = PRC.PRC_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'ENABLE');
      END IF;

      --DPR_DECISIONES_PROCEDIMIENTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'DPR_DECISIONES_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.DPR_DECISIONES_PROCEDIMIENTOS  WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           EXECUTE IMMEDIATE 'Alter table '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS enable constraint FK_PRC_PROC_REFERENCE_PRC_PROC';
           PRO_KEYS_STATUS(V_ESQUEMA, 'DPR_DECISIONES_PROCEDIMIENTOS', 'ENABLE');
      END IF; 
 
       -- COV_CONVENIOS_CREDITOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.COV_CONVENIOS_CREDITOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.COV_CONVENIOS_CREDITOS WHERE COV_ID IN (
                                                  SELECT COV_ID 
                                                  FROM '||V_ESQUEMA||'.COV_CONVENIOS COV
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC TMP ON COV.PRC_ID = TMP.PRC_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'COV_CONVENIOS_CREDITOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.COV_CONVENIOS_CREDITOS WHERE COV_ID IN (
                                                  SELECT COV_ID 
                                                  FROM '||V_ESQUEMA||'.COV_CONVENIOS COV
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC TMP ON COV.PRC_ID = TMP.PRC_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.COV_CONVENIOS_CREDITOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'COV_CONVENIOS_CREDITOS', 'ENABLE');
      END IF;

      --COV_CONVENIOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.COV_CONVENIOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.COV_CONVENIOS WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'COV_CONVENIOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.COV_CONVENIOS  WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.COV_CONVENIOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'COV_CONVENIOS', 'ENABLE');
      END IF; 

      -- BIE_SUI_SUBASTA_INSTRUCCIONES
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_SUI_SUBASTA_INSTRUCCIONES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_SUI_SUBASTA_INSTRUCCIONES WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_SUI_SUBASTA_INSTRUCCIONES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_SUI_SUBASTA_INSTRUCCIONES WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_SUI_SUBASTA_INSTRUCCIONES... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_SUI_SUBASTA_INSTRUCCIONES', 'ENABLE');
      END IF;
      
      -- IAG_IMPULSO_AUTO_GENERADO
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.IAG_IMPULSO_AUTO_GENERADO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.IAG_IMPULSO_AUTO_GENERADO WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'IAG_IMPULSO_AUTO_GENERADO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.IAG_IMPULSO_AUTO_GENERADO WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.IAG_IMPULSO_AUTO_GENERADO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'IAG_IMPULSO_AUTO_GENERADO', 'ENABLE');
      END IF;      
      
      -- PRB_PRC_BIE
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRB_PRC_BIE... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRB_PRC_BIE WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRB_PRC_BIE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRB_PRC_BIE WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.IAG_IMPULSO_AUTO_GENERADO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRB_PRC_BIE', 'ENABLE');
      END IF;      

      -- RCR_RECURSOS_PROCEDIMIENTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                SELECT TAR_ID 
                                                FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC TMP ON TAR.PRC_ID = TMP.PRC_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.RCR_RECURSOS_PROCEDIMIENTOS WHERE TAR_ID IN (
                                                SELECT TAR_ID 
                                                FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_PRC TMP ON TAR.PRC_ID = TMP.PRC_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RCR_RECURSOS_PROCEDIMIENTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'RCR_RECURSOS_PROCEDIMIENTOS', 'ENABLE');
      END IF;

      -- TAR_TAREAS_NOTIFICACIONES
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TAR_TAREAS_NOTIFICACIONES', 'ENABLE');
      END IF;
      
      -- SUB_SUBASTA
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SUB_SUBASTA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.SUB_SUBASTA WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'SUB_SUBASTA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.SUB_SUBASTA WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SUB_SUBASTA... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'SUB_SUBASTA', 'ENABLE');
      END IF;
      
      -- RES_RESOLUCIONES_MASIVO
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RES_RESOLUCIONES_MASIVO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.RES_RESOLUCIONES_MASIVO WHERE RES_PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'RES_RESOLUCIONES_MASIVO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.RES_RESOLUCIONES_MASIVO WHERE RES_PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.RES_RESOLUCIONES_MASIVO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'RES_RESOLUCIONES_MASIVO', 'ENABLE');
      END IF;          
      
      -- PRD_PROCEDIMIENTOS_DERIVADOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRD_PROCEDIMIENTOS_DERIVADOS WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRD_PROCEDIMIENTOS_DERIVADOS', 'ENABLE');
      END IF;      

      -- PRC_PROCEDIMIENTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'Alter table '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS disable constraint FK_PRC_PROC_REFERENCE_PRC_PROC';
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PRC_PROCEDIMIENTOS  WHERE PRC_ID IN ( SELECT PRC_ID FROM '||V_ESQUEMA||'.TABLA_TMP_PRC )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS .. Se han eliminado '||EXISTE||' registros');
           COMMIT;
           EXECUTE IMMEDIATE 'Alter table '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS enable constraint FK_PRC_PROC_REFERENCE_PRC_PROC';
           PRO_KEYS_STATUS(V_ESQUEMA, 'PRC_PROCEDIMIENTOS', 'ENABLE');
      END IF; 
     

     -- ***************************************************************
     -- BORRADO DE ACUERDOS (ORDEN DE BORRADO)
	-- 1º delete from tea_cnt ....
	-- 2º delete from cm01.bie_tea ...
	-- 3º delete from cm01.acu_operaciones_terminos ...
	-- 4º delete from cm01.tea_terminos_acuerdo ...
	-- 5º delete from cm01.acu_acuerdo_procedimientos ...
     -- *************************************************************** 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ANA_ANALIS_ACUERDO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ANA_ANALIS_ACUERDO WHERE ACU_ID IN ( SELECT ACU_ID FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
                                                                                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ANA_ANALIS_ACUERDO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ANA_ANALIS_ACUERDO WHERE ACU_ID IN ( SELECT ACU_ID FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
                                                                                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ANA_ANALIS_ACUERDO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ANA_ANALIS_ACUERDO', 'ENABLE');
      END IF;
      
      -- 1º delete from tea_cnt ....
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEA_CNT... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEA_CNT WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_CNT', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TEA_CNT WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEA_CNT... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_CNT', 'ENABLE');
      END IF;

      -- 2º delete from cm01.bie_tea ...
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_TEA... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_TEA WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_TEA', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_TEA WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_TEA... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_TEA', 'ENABLE');
      END IF;

      -- 3º delete from cm01.acu_operaciones_terminos ...

      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ACU_OPERACIONES_TERMINOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ACU_OPERACIONES_TERMINOS WHERE TEA_ID IN (
                                                    SELECT TEA_ID 
                                                    FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO TEA
                                                      JOIN '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU ON TEA.ACU_ID = ACU.ACU_ID
                                                      JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ACU_OPERACIONES_TERMINOS', 'ENABLE');
      END IF;


      

      -- 4º delete from cm01.tea_terminos_acuerdo ...
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN ( SELECT ACU_ID FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
                                                                                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';

      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_TERMINOS_ACUERDO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.TEA_TERMINOS_ACUERDO WHERE ACU_ID IN ( SELECT ACU_ID FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU
                                                                                         INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'TEA_TERMINOS_ACUERDO', 'ENABLE');
      END IF; 

      -- AAR_ACTUACIONES_REALIZADAS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AAR_ACTUACIONES_REALIZADAS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.AAR_ACTUACIONES_REALIZADAS WHERE ACU_ID IN (
                                                  SELECT ACU_ID 
                                                  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU 
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'AAR_ACTUACIONES_REALIZADAS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.AAR_ACTUACIONES_REALIZADAS WHERE ACU_ID IN (
                                                  SELECT ACU_ID 
                                                  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU 
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AAR_ACTUACIONES_REALIZADAS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'AAR_ACTUACIONES_REALIZADAS', 'ENABLE');
      END IF;       

      -- AEA_ACTUACIO_EXPLOR_ACUERDO
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AEA_ACTUACIO_EXPLOR_ACUERDO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.AEA_ACTUACIO_EXPLOR_ACUERDO WHERE ACU_ID IN (
                                                  SELECT ACU_ID 
                                                  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU 
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'AEA_ACTUACIO_EXPLOR_ACUERDO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.AEA_ACTUACIO_EXPLOR_ACUERDO WHERE ACU_ID IN (
                                                  SELECT ACU_ID 
                                                  FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS ACU 
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ACU.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AEA_ACTUACIO_EXPLOR_ACUERDO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'AEA_ACTUACIO_EXPLOR_ACUERDO', 'ENABLE');
      END IF;

      -- 5º delete from cm01.acu_acuerdo_procedimientos ...
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ACU_ACUERDO_PROCEDIMIENTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ACU_ACUERDO_PROCEDIMIENTOS WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ACU_ACUERDO_PROCEDIMIENTOS', 'ENABLE');
      END IF; 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AAS_ANALISIS_ASUNTO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.AAS_ANALISIS_ASUNTO WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'AAS_ANALISIS_ASUNTO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.AAS_ANALISIS_ASUNTO WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AAS_ANALISIS_ASUNTO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'AAS_ANALISIS_ASUNTO', 'ENABLE');
      END IF; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ANC_ANALISIS_CONTRATOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_ANC_ANALISIS_CONTRATOS WHERE ANC_ID IN ( SELECT ANC_ID FROM '||V_ESQUEMA||'.ANC_ANALISIS_CONTRATOS ANC
                                                                                INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ANC.ASU_ID = TMP.ASU_ID )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ANC_ANALISIS_CONTRATOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.BIE_ANC_ANALISIS_CONTRATOS WHERE ANC_ID IN ( SELECT ANC_ID FROM '||V_ESQUEMA||'.ANC_ANALISIS_CONTRATOS ANC
                                                                                INNER JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ANC.ASU_ID = TMP.ASU_ID )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.BIE_ANC_ANALISIS_CONTRATOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'BIE_ANC_ANALISIS_CONTRATOS', 'ENABLE');
      END IF; 


      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ANC_ANALISIS_CONTRATOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ANC_ANALISIS_CONTRATOS WHERE ASU_ID IN ( SELECT ASU_ID FROM TABLA_TMP_ASU )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ANC_ANALISIS_CONTRATOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ANC_ANALISIS_CONTRATOS WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ANC_ANALISIS_CONTRATOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ANC_ANALISIS_CONTRATOS', 'ENABLE');
      END IF; 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.HCA_HISTORICO_CAMBIOS_ASUNTO... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.HCA_HISTORICO_CAMBIOS_ASUNTO WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'HCA_HISTORICO_CAMBIOS_ASUNTO', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.HCA_HISTORICO_CAMBIOS_ASUNTO WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.HCA_HISTORICO_CAMBIOS_ASUNTO... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'HCA_HISTORICO_CAMBIOS_ASUNTO', 'ENABLE');
      END IF;
      
      -- ADJ_ADJUNTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADJ_ADJUNTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ADJ_ADJUNTOS WHERE ADJ_ID IN (
                                                  SELECT ADJ_ID 
                                                  FROM '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS ADA
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ADA.ASU_ID = TMP.ASU_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADJ_ADJUNTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ADJ_ADJUNTOS WHERE ADJ_ID IN (
                                                  SELECT ADJ_ID 
                                                  FROM '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS ADA
                                                    JOIN '||V_ESQUEMA||'.TABLA_TMP_ASU TMP ON ADA.ASU_ID = TMP.ASU_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADJ_ADJUNTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADJ_ADJUNTOS', 'ENABLE');
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS WHERE ASU_ID IN (
                                                    SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADA_ADJUNTOS_ASUNTOS', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ADA_ADJUNTOS_ASUNTOS WHERE ASU_ID IN (
                                                    SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ADA_ADJUNTOS_ASUNTOS', 'ENABLE');
      END IF;       

     
--    /********************
--    *ORDEN DE BORRADO 4 *
--    ********************/      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ASU_ASUNTOS... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ASU_ASUNTOS WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'ASU_ASUNTOS', 'DISABLE');
--           EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA ||'.ASU_ASUNTOS ';
             EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.ASU_ASUNTOS WHERE ASU_ID IN ( SELECT ASU_ID FROM '||V_ESQUEMA||'.TABLA_TMP_ASU )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ASU_ASUNTOS... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'ASU_ASUNTOS', 'ENABLE');
      END IF;
      
      COMMIT;
      
--    /********************
--    *ORDEN DE BORRADO 3 *
--    ********************/
      -- CRE_PRC_CEX
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRE_PRC_CEX... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CRE_PRC_CEX WHERE CRE_PRC_CEX_CEXID IN (
                                                SELECT CEX_ID 
                                                FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_EXP TMP ON CEX.EXP_ID = TMP.EXP_ID)';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRE_PRC_CEX', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CRE_PRC_CEX WHERE CRE_PRC_CEX_CEXID IN (
                                                SELECT CEX_ID 
                                                FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX
                                                  JOIN '||V_ESQUEMA||'.TABLA_TMP_EXP TMP ON CEX.EXP_ID = TMP.EXP_ID)';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CRE_PRC_CEX... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CRE_PRC_CEX', 'ENABLE');
      END IF;

      --CEX_CONTRATOS_EXPEDIENTE
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CEX_CONTRATOS_EXPEDIENTE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CEX_CONTRATOS_EXPEDIENTE  WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CEX_CONTRATOS_EXPEDIENTE', 'ENABLE');
      END IF; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'PEX_PERSONAS_EXPEDIENTE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.PEX_PERSONAS_EXPEDIENTE 
           WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'PEX_PERSONAS_EXPEDIENTE', 'ENABLE');
      END IF; 
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SCX_SOL_CANCELAC_EXP... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.SCX_SOL_CANCELAC_EXP WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'SCX_SOL_CANCELAC_EXP', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.SCX_SOL_CANCELAC_EXP 
           WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.SCX_SOL_CANCELAC_EXP... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'SCX_SOL_CANCELAC_EXP', 'ENABLE');
      END IF; 

--    /********************
--    *ORDEN DE BORRADO 2 *
--    ********************/  
     
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.EXP_EXPEDIENTES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.EXP_EXPEDIENTES  WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'EXP_EXPEDIENTES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.EXP_EXPEDIENTES WHERE EXP_ID IN ( SELECT EXP_ID FROM '||V_ESQUEMA||'.TABLA_TMP_EXP )';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.EXP_EXPEDIENTES... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'EXP_EXPEDIENTES', 'ENABLE');
      END IF; 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE WHERE USUARIOCREAR = '''||USUARIO||'''';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CCL_CONTRATOS_CLIENTE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CCL_CONTRATOS_CLIENTE WHERE USUARIOCREAR = '''||USUARIO||'''';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CCL_CONTRATOS_CLIENTE', 'ENABLE');
      END IF; 
      
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE... Comprobando si existen registros para el usuario CONVIVE_F2');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE WHERE USUARIOCREAR = '''||USUARIO2||'''';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CCL_CONTRATOS_CLIENTE', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CCL_CONTRATOS_CLIENTE WHERE USUARIOCREAR = '''||USUARIO2||'''';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CCL_CONTRATOS_CLIENTE... Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CCL_CONTRATOS_CLIENTE', 'ENABLE');
      END IF; 

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CLI_CLIENTES... Comprobando si existen registros para el usuario MIGRAHAYA02');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CLI_CLIENTES WHERE USUARIOCREAR = '''||USUARIO||'''';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CLI_CLIENTES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CLI_CLIENTES WHERE USUARIOCREAR = '''||USUARIO||'''';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CLI_CLIENTES...  Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CLI_CLIENTES', 'ENABLE');
      END IF; 
 
 DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CLI_CLIENTES... Comprobando si existen registros para el usuario CONVIVE_F2');
      EXISTE := 0;
      V_SQL:= 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.CLI_CLIENTES WHERE USUARIOCREAR = '''||USUARIO2||'''';
      EXECUTE IMMEDIATE V_SQL INTO EXISTE;
      IF (EXISTE>0) THEN
           PRO_KEYS_STATUS(V_ESQUEMA, 'CLI_CLIENTES', 'DISABLE');
           EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA ||'.CLI_CLIENTES WHERE USUARIOCREAR = '''||USUARIO2||'''';
           DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.CLI_CLIENTES...  Se han eliminado '||EXISTE||' registros');
           COMMIT;
           PRO_KEYS_STATUS(V_ESQUEMA, 'CLI_CLIENTES', 'ENABLE');
      END IF;  

--***************************************/
DBMS_OUTPUT.PUT_LINE( 'BORRADO DE TEMPORALES');
--***************************************/


     EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_ASU PURGE ';
     EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_PRC PURGE ';
     EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_EXP PURGE ';
     EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TABLA_TMP_BIE PURGE ';



--***************************************/
DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');
--***************************************/





EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT
