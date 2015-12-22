--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151221
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CARGA DATOS EN DICCIONARIO DD_TIN_TIPO_INTERVENCION
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
 TYPE T_TIN IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TIN IS TABLE OF T_TIN;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

-- VARIABLES
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';               -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_TIN_TIPO_INTERVENCION';
 TABLA2 VARCHAR(30) :='CPE_CONTRATOS_PERSONAS';  
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 V_MSQL3 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION ARRAY.

 V_TIN T_ARRAY_TIN := T_ARRAY_TIN(
                    T_TIN ( '01','PRIMER TITULAR','PRIMER TITULAR','0','INICIAL','SYSDATE','null','null','null','null','0','1','0','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                  , T_TIN ( '02','COTITULAR','COTITULAR','0','INICIAL','SYSDATE','null','null','null','null','0','1','0','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                  , T_TIN ( '03','AUTORIZADO','AUTORIZADO','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                  , T_TIN ( '04','AVALISTA','AVALISTA','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                  , T_TIN ( '05','GARANTE','GARANTE','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                  , T_TIN ( '06','REPRESENTANTE LEGAL','REPRESENTANTE LEGAL','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                  , T_TIN ( '07','REPRESENTANTE LEGAL DE PERSONA JURIDICA','REPRESENTANTE LEGAL DE PERSONA JURIDICA','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                  , T_TIN ( '08','USUARIO CANALES','USUARIO CANALES','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                  , T_TIN ( '09','RECEPTOR DE COMUNICACIONES','RECEPTOR DE COMUNICACIONES','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                  , T_TIN ( '10','INTERVENTOR','INTERVENTOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  , T_TIN ( '11','TUTOR','TUTOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                  , T_TIN ( '12','NOMBRE COMERCIAL','NOMBRE COMERCIAL','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                  , T_TIN ( '13','PARTICIP','PARTICIP','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                  , T_TIN ( '14','PRENEDOR','PRENEDOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                  , T_TIN ( '15','CORREDOR DEL PRESTEC','CORREDOR DEL PRESTEC','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                  , T_TIN ( '16','COMPTE ABONAMENT CORREDOR','COMPTE ABONAMENT CORREDOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                  , T_TIN ( '17','AGENTE COLABORADOR','AGENTE COLABORADOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                  , T_TIN ( '18','SOCIO DE LA ENTIDAD','SOCIO DE LA ENTIDAD','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  , T_TIN ( '20','BENEFICIARIO DE AVAL','BENEFICIARIO DE AVAL','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                  , T_TIN ( '21','PROVEEDOR','PROVEEDOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                  , T_TIN ( '22','HIPOTECANTE','HIPOTECANTE','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                  , T_TIN ( '23','TOMADOR','TOMADOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                  , T_TIN ( '24','ASEGURADO','ASEGURADO','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                  , T_TIN ( '25','PAGADOR','PAGADOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                  , T_TIN ( '26','PARTICIPE','PARTICIPE','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                  , T_TIN ( '27','ASEGURADO PPAGOS','ASEGURADO PPAGOS','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                  , T_TIN ( '55','USUFRUCTUARIO','USUFRUCTUARIO','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                  , T_TIN ( '56','NUDOPROPIETARIO','NUDOPROPIETARIO','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                  , T_TIN ( '91','ACREDITAT','ACREDITAT','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                  , T_TIN ( '92','FIADOR','FIADOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                  , T_TIN ( '93','PRESTATARI','PRESTATARI','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                  , T_TIN ( '99','HIPOTECANTE NO DEUDOR','HIPOTECANTE NO DEUDOR','0','INICIAL','SYSDATE','null','null','null','null','0','0','1','0')
 );


 V_TMP_TIN T_TIN;

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

   V_MSQL2 := 'DELETE FROM ' ||V_ESQUEMA|| '.'||TABLA||' WHERE DD_TIN_ID IN(
						SELECT TIN.DD_TIN_ID 
						FROM ' ||V_ESQUEMA|| '.'||TABLA||' TIN
  						LEFT OUTER JOIN ' ||V_ESQUEMA|| '.'||TABLA2||' CPE ON CPE.DD_TIN_ID = TIN.DD_TIN_ID
						WHERE CPE.DD_TIN_ID IS NULL
									)';


                    --DBMS_OUTPUT.PUT_LINE(V_MSQL2);
    
   EXECUTE IMMEDIATE V_MSQL2;
   DBMS_OUTPUT.PUT_LINE('BORRAMOS DE LA TABLA '||TABLA||'');

COMMIT;



 FOR I IN V_TIN.FIRST .. V_TIN.LAST
 LOOP
   V_TMP_TIN := V_TIN(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': '||V_TMP_TIN(1));   
   
  


   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLA||' WHERE DD_TIN_CODIGO = ''' || V_TMP_TIN(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' - '||V_TMP_TIN(1) || ' YA EXISTE');



     --Actualizamos los ya existentes

 V_MSQL3 := 'UPDATE ' || V_ESQUEMA || '.'||TABLA||' 
					SET DD_TIN_DESCRIPCION = ''' || V_TMP_TIN(2) || ''' ,
					    DD_TIN_DESCRIPCION_LARGA = ''' || V_TMP_TIN(3) || ''',
					    DD_TIN_TITULAR = ''' || V_TMP_TIN(12) || ''',
                                            DD_TIN_AVALISTA = ''' || V_TMP_TIN(13) || '''
WHERE DD_TIN_CODIGO = ''' || V_TMP_TIN(1) || '''';

--DBMS_OUTPUT.PUT_LINE(V_MSQL3);
EXECUTE IMMEDIATE V_MSQL3;
DBMS_OUTPUT.PUT_LINE('ACTUALIZAMOS DE LA TABLA '||TABLA||': '||V_TMP_TIN(1));

COMMIT;


  ELSE
  
  -- SECUENCIA INSERT
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
                    ( DD_TIN_ID, DD_TIN_CODIGO, DD_TIN_DESCRIPCION, DD_TIN_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_TIN_TITULAR, DD_TIN_AVALISTA, DD_TIN_EXP_RECOBRO_SN)
                   VALUES (   S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_TIN(1)||q'[',']'
                        ||V_TMP_TIN(2)||q'[',']'
                        ||V_TMP_TIN(3)||q'[',]'
                        ||V_TMP_TIN(4)||q'[,']'
                        ||V_TMP_TIN(5)||q'[',]' 
                        ||V_TMP_TIN(6)||q'[,']' 
                        ||V_TMP_TIN(7)||q'[',]'
                        ||V_TMP_TIN(8)||q'[,]'
                        ||V_TMP_TIN(9)||q'[,]'
                        ||V_TMP_TIN(10)||q'[,]'
                        ||V_TMP_TIN(11)||q'[,]' 
                        ||V_TMP_TIN(12)||q'[,]' 
                        ||V_TMP_TIN(13)||q'[,]' 
                        ||V_TMP_TIN(14)||q'[)]' 
                        -- ||V_TMP_TIN(15)||q'[)]' 
                        ;
             
   -- DBMS_OUTPUT.PUT_LINE(V_MSQL1);

DBMS_OUTPUT.PUT_LINE('INSERTAMOS EN LA TABLA '||TABLA||': '||V_TMP_TIN(1));
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
