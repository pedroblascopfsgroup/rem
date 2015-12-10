--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151030
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CreaciÃ³n de TABLAS DE DICCIONARIOS DE TIPO PRODUCTO GARANTIA
--##                   
--##                             
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:0.1 Versión Inicial
--##        
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- #ESQUEMA_MASTER#.DD_TGC_TIPO_GARANTIA_CIRBE;
 TYPE T_TGC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TGC IS TABLE OF T_TGC;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_TGC_TIPO_GARANTIA_CIRBE'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;
 V_ENTIDAD_ID  NUMBER(16);

-- DEFINICION CURSORES.

 V_TGC T_ARRAY_TGC := T_ARRAY_TGC(
                   T_TGC ('A','REAL 100 % NORMAL','REAL 100 % NORMAL','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('B','REAL 100 % RESTO','REAL 100 % RESTO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('C','REAL > 50 %','REAL > 50 %','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('D','PERSONAL SECTOR PUBLICO','PERSONAL SECTOR PUBLICO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('E','PERSONAL GARANTIAS CESCE','PERSONAL GARANTIAS CESCE','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('F','PERSONAL ENTI. DECLAR. CIR','PERSONAL ENTI. DECLAR. CIR','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('H','PERSONAL ENTI. CR. NO RESID.','PERSONAL ENTI. CR. NO RESID.','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TGC ('V','PERSONAL RESTO SITUAC.','PERSONAL RESTO SITUAC.','0','INICIAL','SYSDATE','null','null','null','null','0')
 );


 V_TMP_TGC T_TGC;


BEGIN 

 -- Modifica los valores del campo CODIGO añadiendo una X para no borrar y poder insertar los nuevos
 DBMS_OUTPUT.PUT_LINE('MODIFICAMOS LOS VALORES ACTUALES DE '||TABLA||'');
 EXECUTE IMMEDIATE('UPDATE '|| V_ESQUEMA_M||'.'||TABLA||' SET DD_TGC_CODIGO = ''X''||DD_TGC_CODIGO');
 



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
 
 
 FOR I IN V_TGC.FIRST .. V_TGC.LAST
 LOOP
   V_TMP_TGC := V_TGC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': CODIGO '|| V_TMP_TGC(1));   
   
  
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.'||TABLA||' WHERE DD_TGC_CODIGO = ''' || V_TMP_TGC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' CON CODIGO - '||V_TMP_TGC(1) || ' YA EXISTE');
  ELSE
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLA||' 
                    ( DD_TGC_ID, DD_TGC_CODIGO, DD_TGC_DESCRIPCION, DD_TGC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES (   S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_TGC(1)||q'[',']'
                        ||V_TMP_TGC(2)||q'[',']'
                        ||V_TMP_TGC(3)||q'[',]'
                        ||V_TMP_TGC(4)||q'[,']'
                        ||V_TMP_TGC(5)||q'[',]' 
                        ||V_TMP_TGC(6)||q'[,]' 
                        ||V_TMP_TGC(7)||q'[,]'
                        ||V_TMP_TGC(8)||q'[,]'
                        ||V_TMP_TGC(9)||q'[,]'
                        ||V_TMP_TGC(10)||q'[,]'
                        ||V_TMP_TGC(11)||q'[)]';   

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
