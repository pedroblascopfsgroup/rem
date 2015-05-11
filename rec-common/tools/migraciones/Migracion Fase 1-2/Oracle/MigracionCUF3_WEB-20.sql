DECLARE
  v_count NUMBER(16);
  v_sql VARCHAR2(1000); 
BEGIN
  
  --SET SERVEROUTPUT ON
  --Se crea la nueva tabla que relaciona procedimientos con contratos
  
  v_sql := ' 
    CREATE TABLE PRC_CEX  (
       PRC_ID               NUMBER(16),
       CEX_ID               NUMBER(16),
       VERSION              INTEGER                        DEFAULT 0 NOT NULL,
       CONSTRAINT PK_PRC_CEX PRIMARY KEY (PRC_ID, CEX_ID)
    )';
  EXECUTE IMMEDIATE v_sql;
  
  --Se elimina la relación 
  v_sql := '
  ALTER TABLE PRC_PROCEDIMIENTOS DROP CONSTRAINT FK_PRC_PROC_FK_CEX_PR_CEX_CONT';
  --EXECUTE IMMEDIATE v_sql;

  --Se carga la tabla intermedia con las relaciones actuales
  v_sql := ' 
    INSERT INTO PRC_CEX (PRC_ID, CEX_ID) 
      SELECT PRC_ID, CEX_ID FROM PRC_PROCEDIMIENTOS'; 
  EXECUTE IMMEDIATE v_sql;
    
  
  --Se verifica que los valores se carguen bién en la nueva tabla intermedia
  v_sql := ' 
    SELECT COUNT(*) FROM prc_procedimientos p 
      INNER JOIN cex_contratos_expediente cex ON p.cex_id=cex.cex_id
      WHERE NOT EXISTS (SELECT * FROM prc_cex pc WHERE pc.prc_id = p.prc_id AND pc.cex_id=cex.cex_id)';
  EXECUTE IMMEDIATE v_sql INTO v_count;
  
  IF v_count <> 0 THEN
    BEGIN
      --Se vuelvn atrás los cambios.
      ROLLBACK;
      --Se elimina la tabla que se creó
      v_sql := 'DROP TABLE PRC_CEX CASCADE CONSTRAINTS';
      EXECUTE IMMEDIATE v_sql;
      --Se vuelven a poner el constraint que se sacó
      v_sql := 'ALTER TABLE PRC_PROCEDIMIENTOS
        ADD CONSTRAINT FK_PRC_PROC_FK_CEX_PR_CEX_CONT FOREIGN KEY (CEX_ID)
        REFERENCES CEX_CONTRATOS_EXPEDIENTE (CEX_ID)';
      EXECUTE IMMEDIATE v_sql;
      dbms_output.put_line('CU20-Fallo el script');
    END;
  ELSE
    BEGIN
      --Los cambios van bien
      COMMIT;
      v_sql := 'ALTER TABLE prc_procedimientos DROP (cex_id, cnt_id)';
      EXECUTE IMMEDIATE v_sql;
      dbms_output.put_line('CU20-Script Correcto');
    END;
   END IF;
END;
/
