--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CARGA DATOS EN DICCIONARIO DD_EFC_ESTADO_FINAN_CNT
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


 -- DD_TIN_TIPO_INTERVENCION
 TYPE T_EFC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TIN IS TABLE OF T_EFC;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

-- VARIABLES
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';               -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_EFC_ESTADO_FINAN_CNT';
 TABLA2 VARCHAR(30) :='CNT_CONTRATOS';  
 TABLA3 VARCHAR(30) :='PER_PERSONAS';  
 TABLA4 VARCHAR(30) :='H_MOV_MOVIMIENTOS'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 V_MSQL3 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION ARRAY.

 V_EFC T_ARRAY_TIN := T_ARRAY_TIN(
                    T_EFC ( '0','CUENTA INEXISTENTE','CUENTA INEXISTENTE','1','0','INICIAL','SYSDATE','null','null','null','null','0'),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                    T_EFC ( '1','VIGENTE','VIGENTE','2','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '2','CANCELADA','CANCELADA','3','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '3','SIN FORMALIZAR/CONCEDIDO','SIN FORMALIZAR/CONCEDIDO','4','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '4','SITUACION ESPECIAL','SITUACION ESPECIAL','5','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '5','VEN}UT','VEN}UT','6','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '6','VENCIDO SIN CADUCAR','VENCIDO SIN CADUCAR','7','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '7','CEDIDA','CEDIDA','8','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '8','EN LITIGIO','EN LITIGIO','9','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '14','DUDOSO GENERAL','DUDOSO GENERAL','10','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '24','DUDOSO COBRO','DUDOSO COBRO','11','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '34','DUDOSO ARRASTRE','DUDOSO ARRASTRE','12','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '42','PRECONTENCIOSO','PRECONTENCIOSO','13','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '43','SUSPENSO SIN LITIGIO','SUSPENSO SIN LITIGIO','14','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '44','LITIGIO','LITIGIO','15','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '51','DUDOSOS COBROS VIGENTES','DUDOSOS COBROS VIGENTES','16','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '54','SUSPENSO-FALLIDO-CSR','SUSPENSO-FALLIDO-CSR','17','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '58','DUDOSOS COBROS EN LITIGIO','DUDOSOS COBROS EN LITIGIO','18','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '61','FALLO VIGENTE','FALLO VIGENTE','19','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '64','FAILED','FAILED','20','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '68','FALLO EN LITIGIO','FALLO EN LITIGIO','21','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '77','INOPERATIVA SALDO=CERO','INOPERATIVA SALDO=CERO','22','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '90','CANCELADA','CANCELADA','23','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '96','PENDIENTE DE ACTIVAR','PENDIENTE DE ACTIVAR','24','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '97','EXPEDIENTE EN TRAMITE','EXPEDIENTE EN TRAMITE','25','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '98','FINALIZADA','FINALIZADA','26','0','INICIAL','SYSDATE','null','null','null','null','0'),
                    T_EFC ( '99','ANULADA','ANULADA','27','0','INICIAL','SYSDATE','null','null','null','null','0')
				  
				  
				
 );


 V_TMP_EFC T_EFC;

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


--Borramos de la tabla los no utilizados

   V_MSQL2 := 'DELETE FROM ' ||V_ESQUEMA|| '.'||TABLA||' WHERE DD_EFC_ID IN(
						SELECT EFC.DD_EFC_ID 
FROM ' ||V_ESQUEMA|| '.'||TABLA||' EFC
  LEFT OUTER JOIN ' ||V_ESQUEMA|| '.'||TABLA2||' CNT ON CNT.DD_EFC_ID = EFC.DD_EFC_ID
  LEFT OUTER JOIN ' ||V_ESQUEMA|| '.'||TABLA3||' PER ON PER.DD_EFC_ID = EFC.DD_EFC_ID
  LEFT OUTER JOIN ' ||V_ESQUEMA|| '.'||TABLA4||' MOV ON MOV.DD_EFC_ID = EFC.DD_EFC_ID
WHERE CNT.DD_EFC_ID IS NULL
AND   PER.DD_EFC_ID IS NULL
AND   MOV.DD_EFC_ID IS NULL
)';

                    DBMS_OUTPUT.PUT_LINE(V_MSQL2);
    
   EXECUTE IMMEDIATE V_MSQL2;
   DBMS_OUTPUT.PUT_LINE('BORRAMOS DE LA TABLA '||TABLA||'');

COMMIT;



 FOR I IN V_EFC.FIRST .. V_EFC.LAST
 LOOP
   V_TMP_EFC := V_EFC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_EFC(1));   
   
  


   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLA||' WHERE DD_EFC_CODIGO = ''' || V_TMP_EFC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' - '||V_TMP_EFC(1) || ' YA EXISTE');



     --Actualizamos los ya existentes

 V_MSQL3 := 'UPDATE ' || V_ESQUEMA || '.'||TABLA||' 
					SET DD_EFC_DESCRIPCION = ''' || V_TMP_EFC(2) || ''' ,
					    DD_EFC_DESCRIPCION_LARGA = ''' || V_TMP_EFC(3) || '''
WHERE DD_EFC_CODIGO = ''' || V_TMP_EFC(1) || '''';

DBMS_OUTPUT.PUT_LINE(V_MSQL3);
EXECUTE IMMEDIATE V_MSQL3;
DBMS_OUTPUT.PUT_LINE('ACTUALIZAMOS DE LA TABLA '||TABLA||': '||V_TMP_EFC(1));

COMMIT;


  ELSE
  
  -- SECUENCIA INSERT
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
                    ( DD_EFC_ID, DD_EFC_CODIGO, DD_EFC_DESCRIPCION, DD_EFC_DESCRIPCION_LARGA, DD_EFC_PRIORIDAD,VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES (   S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_EFC(1)||q'[',']'
                        ||V_TMP_EFC(2)||q'[',']'
                        ||V_TMP_EFC(3)||q'[',]'
                        ||V_TMP_EFC(4)||q'[,']'
                        ||V_TMP_EFC(5)||q'[',']' 
                        ||V_TMP_EFC(6)||q'[',]' 
                        ||V_TMP_EFC(7)||q'[,]'
                        ||V_TMP_EFC(8)||q'[,]'
                        ||V_TMP_EFC(9)||q'[,]'
                        ||V_TMP_EFC(10)||q'[,]'
                        ||V_TMP_EFC(11)||q'[,]'  
                        ||V_TMP_EFC(12)||q'[)]' 
                        -- ||V_TMP_EFC(15)||q'[)]' 
                        ;
             
    DBMS_OUTPUT.PUT_LINE(V_MSQL1);

DBMS_OUTPUT.PUT_LINE('INSERTAMOS EN LA TABLA '||TABLA||': '||V_TMP_EFC(1));
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
