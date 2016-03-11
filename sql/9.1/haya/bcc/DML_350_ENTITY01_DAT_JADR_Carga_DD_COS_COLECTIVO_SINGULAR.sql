--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151230
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CARGA DATOS EN DICCIONARIO DD_COS_COLECTIVO_SINGULAR
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 VersiÃ³n inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- DD_COS_COLECTIVO_SINGULAR
 TYPE T_SEC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_SEC IS TABLE OF T_SEC;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

-- VARIABLES
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';               -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_COS_COLECTIVO_SINGULAR';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 V_MSQL3 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION ARRAY.

 V_SEC T_ARRAY_SEC := T_ARRAY_SEC(
T_SEC ( 'T200','T200','T200','0','INICIAL','SYSDATE','null','null','null','null','0')


			
 );


 V_TMP_SEC T_SEC;

-- FIN ARRAY

-- SECUENCIA

BEGIN 





 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLA and sequence_owner= V_ESQUEMA;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLA||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
 -- FIN SECUENCIA
 




 -- LOOP PARA RECOORER ARRAY

 FOR I IN V_SEC.FIRST .. V_SEC.LAST
 LOOP
   V_TMP_SEC := V_SEC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_SEC(1));   
   
  


   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLA||' WHERE DD_COS_CODIGO = ''' || V_TMP_SEC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' - '||V_TMP_SEC(1) || ' YA EXISTE');



     --Actualizamos los ya existentes

 V_MSQL3 := 'UPDATE ' || V_ESQUEMA || '.'||TABLA||' 
					SET DD_COS_DESCRIPCION = ''' || SUBSTR(V_TMP_SEC(2),1,50) || ''' ,
					    DD_COS_DESCRIPCION_LARGA = ''' || V_TMP_SEC(3) || ''',
					    USUARIOCREAR = ''INICIAL'',
				            FECHACREAR = SYSDATE			
WHERE DD_COS_CODIGO = ''' || V_TMP_SEC(1) || '''';

DBMS_OUTPUT.PUT_LINE(V_MSQL3);
EXECUTE IMMEDIATE V_MSQL3;
DBMS_OUTPUT.PUT_LINE('ACTUALIZAMOS DE LA TABLA '||TABLA||': '||V_TMP_SEC(1));

COMMIT;


  ELSE
  
  -- SECUENCIA INSERT
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
                    ( DD_COS_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION, DD_COS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES (   ' || V_ESQUEMA || '.S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_SEC(1)||q'[',']'
                        ||SUBSTR(V_TMP_SEC(2),1,50)||q'[',']'
                        ||V_TMP_SEC(3)||q'[',]'
                        ||V_TMP_SEC(4)||q'[,']' 
                        ||V_TMP_SEC(5)||q'[',]' 
                        ||V_TMP_SEC(6)||q'[,]'
                        ||V_TMP_SEC(7)||q'[,]'
                        ||V_TMP_SEC(8)||q'[,]'
                        ||V_TMP_SEC(9)||q'[,]'
                        ||V_TMP_SEC(10)||q'[,]'  
                        ||V_TMP_SEC(11)||q'[)]' 
                        ;
             
    DBMS_OUTPUT.PUT_LINE(V_MSQL1);

DBMS_OUTPUT.PUT_LINE('INSERTAMOS EN LA TABLA '||TABLA||': '||V_TMP_SEC(1));
EXECUTE IMMEDIATE V_MSQL1;

COMMIT;

     END IF;
    
 END LOOP; 




-- FIN INSERT / LOOP

-- EXCEPCIONES

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
