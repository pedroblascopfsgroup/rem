--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151105
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-922
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla DD_PRV_PROVINCIA
--##                   
--##                               , esquema CMMASTER. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES: 0.1
--##        
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- DD_PRV_PROVINCIA
 TYPE T_PRV IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_PRV IS TABLE OF T_PRV;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_PRV_PROVINCIA'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_PRV T_ARRAY_PRV := T_ARRAY_PRV(
                          T_PRV ('0','0','PROVINCIA SIN ASIGNAR','PROVINCIA SIN ASIGNAR','0','INICIAL','SYSDATE','null','null','null','null','0')                   
                                 );
 V_TMP_PRV T_PRV;


BEGIN 

 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLA and sequence_owner= V_ESQUEMA_M;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA_M|| '.S_'||TABLA||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;

 FOR I IN V_PRV.FIRST .. V_PRV.LAST
 LOOP
   V_TMP_PRV := V_PRV(I);
   V_EXISTE:=0; 
      
  
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.'||TABLA||' WHERE DD_PRV_CODIGO = ''' || V_TMP_PRV(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
  
  IF V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' - '||V_TMP_PRV(1) || ' YA EXISTE');
      
  ELSE
        DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_PRV(1));
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLA||' 
                    ( DD_PRV_ID, DD_PRV_CODIGO, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES ('||V_TMP_PRV(1)||q'[,]'
                        ||V_TMP_PRV(2)||q'[,']'
                        ||V_TMP_PRV(3)||q'[',']'
                        ||V_TMP_PRV(4)||q'[',]'
                        ||V_TMP_PRV(5)||q'[,']'
                        ||V_TMP_PRV(6)||q'[',]' 
                        ||V_TMP_PRV(7)||q'[,]' 
                        ||V_TMP_PRV(8)||q'[,]'
                        ||V_TMP_PRV(9)||q'[,]'
                        ||V_TMP_PRV(10)||q'[,]'
                        ||V_TMP_PRV(11)||q'[,]'
                        ||V_TMP_PRV(12)||q'[)]';

EXECUTE IMMEDIATE V_MSQL1;

 END IF;
    
 END LOOP; 


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

