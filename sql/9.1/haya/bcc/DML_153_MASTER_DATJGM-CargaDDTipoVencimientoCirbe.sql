--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151030
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CreaciÃ³n de TABLAS DE DICCIONARIOS DE TIPO VENCIDOS CIRBE
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


 -- #ESQUEMA_MASTER#.DD_TVC_TIPO_VENC_CIRBE;
 TYPE T_TVC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TVC IS TABLE OF T_TVC;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_TVC_TIPO_VENC_CIRBE'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;
 V_ENTIDAD_ID  NUMBER(16);

-- DEFINICION CURSORES.

 V_TVC T_ARRAY_TVC := T_ARRAY_TVC(
                   T_TVC ('A','CORTO HASTA 3 MESES ','CORTO HASTA 3 MESES ','0','INICIAL','SYSDATE','null','null','null','null','0')
                      , T_TVC ('B','CORTO > 3 MESES ��� 1 A��O','CORTO > 3 MESES ��� 1 A��O','0','INICIAL','SYSDATE','null','null','null','null','0')
                      , T_TVC ('C','MEDIO > 1A��O   ��� 3 A��OS ','MEDIO > 1A��O   ��� 3 A��OS ','0','INICIAL','SYSDATE','null','null','null','null','0')
                      , T_TVC ('D','MEDIO > 3A��OS ��� 5 A��OS','MEDIO > 3A��OS ��� 5 A��OS','0','INICIAL','SYSDATE','null','null','null','null','0')
                      , T_TVC ('E','LARGO + 5 A��OS','LARGO + 5 A��OS','0','INICIAL','SYSDATE','null','null','null','null','0')
                      , T_TVC ('M','LARGO INDETERMINADO','LARGO INDETERMINADO','0','INICIAL','SYSDATE','null','null','null','null','0')
 );


 V_TMP_TVC T_TVC;


BEGIN 

-- Modifica los valores del campo CODIGO añadiendo una X para no borrar y poder insertar los nuevos
 DBMS_OUTPUT.PUT_LINE('MODIFICAMOS LOS VALORES ACTUALES DE '||TABLA||'');
 EXECUTE IMMEDIATE('UPDATE '|| V_ESQUEMA_M||'.'||TABLA||' SET DD_TVC_CODIGO = ''X''||DD_TVC_CODIGO');
 



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
 
 
 FOR I IN V_TVC.FIRST .. V_TVC.LAST
 LOOP
   V_TMP_TVC := V_TVC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': CODIGO '|| V_TMP_TVC(1));   
   
  
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.'||TABLA||' WHERE DD_TVC_CODIGO = ''' || V_TMP_TVC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' CON CODIGO - '||V_TMP_TVC(1) || ' YA EXISTE');
  ELSE
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLA||' 
                    ( DD_TVC_ID, DD_TVC_CODIGO, DD_TVC_DESCRIPCION, DD_TVC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES (   S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_TVC(1)||q'[',']'
                        ||V_TMP_TVC(2)||q'[',']'
                        ||V_TMP_TVC(3)||q'[',]'
                        ||V_TMP_TVC(4)||q'[,']'
                        ||V_TMP_TVC(5)||q'[',]' 
                        ||V_TMP_TVC(6)||q'[,]' 
                        ||V_TMP_TVC(7)||q'[,]'
                        ||V_TMP_TVC(8)||q'[,]'
                        ||V_TMP_TVC(9)||q'[,]'
                        ||V_TMP_TVC(10)||q'[,]'
                        ||V_TMP_TVC(11)||q'[)]';   

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
