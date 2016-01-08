--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-435
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios Contratos Cajamar , esquema CMMASTER.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
 
 --/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := 'CM01';
   V_ESQUEMA_M VARCHAR(25) := 'CMMASTER';
   seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
   table_count number(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
   err_num NUMBER;
   err_msg VARCHAR2(2048); 
   V_MSQL VARCHAR2(4000 CHAR);
   
   
   TYPE T_TIPO_EDOCNT is table of  VARCHAR2(250);
   TYPE T_ARRAY_TIPO_EDOCNT  IS TABLE OF T_TIPO_EDOCNT;
 
   
	
--############ ESTADO CONTRATO #############
   V_TIPO_EDOCNT T_ARRAY_TIPO_EDOCNT := T_ARRAY_TIPO_EDOCNT(
                                        T_TIPO_EDOCNT('0','ACTIVO','ACTIVO'),
                                        T_TIPO_EDOCNT('7','CANCELADO','CANCELADO'),
                                        T_TIPO_EDOCNT('8','NO RECIBIDO','NO RECIBIDO')
                                   );
								   
  


   v_dummy number(10);
   V_EXIST NUMBER(10); -----

   V_ENTIDAD_ID NUMBER(16);
  

   
  
   V_TMP_EDOCNT T_TIPO_EDOCNT;
   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   
BEGIN

 EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.DD_ECE_ESTADO_CONTRATO_ENTIDAD DISABLE CONSTRAINTS FK_DD_ECE_FK_DD_ESC_ID');   	
 DBMS_OUTPUT.PUT_LINE('ALTER TABLE DD_ECE_ESTADO_CONTRATO_ENTIDAD DISABLE CONSTRAINTS FK_DD_ECE_FK_DD_ESC_ID');   


	DBMS_OUTPUT.PUT_LINE('Limpieza de datos DD_ESC_ESTADO_CNT.');
	    execute immediate('DELETE FROM '||V_ESQUEMA_M||'.DD_ESC_ESTADO_CNT');
      commit;
    
 v_dummy:=0;
    SELECT count(*) INTO v_dummy
    FROM all_sequences
    WHERE sequence_name = 'S_DD_ESC_ESTADO_CNT';
    if v_dummy is not null and v_dummy = 1 then
    	EXECUTE IMMEDIATE('DROP SEQUENCE S_DD_ESC_ESTADO_CNT');
    end if;
    
	

    
	EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA_M||'.S_DD_ESC_ESTADO_CNT
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	
	
  DBMS_OUTPUT.PUT_LINE('Creando DD_ESC_ESTADO_CNT......');
   FOR I IN V_TIPO_EDOCNT.FIRST .. V_TIPO_EDOCNT.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_ESC_ESTADO_CNT.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_EDOCNT := V_TIPO_EDOCNT(I);
      DBMS_OUTPUT.PUT_LINE('Creando DD_ESC_ESTADO_CNT: '||V_TMP_EDOCNT(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_ESC_ESTADO_CNT (DD_ESC_ID,  DD_ESC_CODIGO,  DD_ESC_DESCRIPCION,' ||
        'DD_ESC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ',''' || V_TMP_EDOCNT(1) || ''','''||SUBSTR(V_TMP_EDOCNT(2),1,50)||''','''
             ||V_TMP_EDOCNT(3)||''','''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP EDO CONTRATO  
   COMMIT;
   V_TMP_EDOCNT:=NULL;
   	
	
	DBMS_OUTPUT.PUT_LINE('Habilitamos CONSTRAINTS FK_DD_ECE_FK_DD_ESC_ID');
	  EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.DD_ECE_ESTADO_CONTRATO_ENTIDAD DISABLE CONSTRAINTS FK_DD_ECE_FK_DD_ESC_ID');  

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;