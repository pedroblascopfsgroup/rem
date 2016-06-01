--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20160215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CARGA DATOS EN DICCIONARIO DD_SCE_SEGTO_CLI_ENTIDAD
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


 -- DD_SEC_SEGMENTO_CARTERA
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
 TABLA VARCHAR(30) :='DD_SCE_SEGTO_CLI_ENTIDAD';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 V_MSQL3 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION ARRAY.

 V_SEC T_ARRAY_SEC := T_ARRAY_SEC(
T_SEC('01','AGRICULTOR BAJO PLASTICO MINORISTA','AGRICULTOR BAJO PLASTICO MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('02','COMERCIALIZADORAS AGRICOLAS','COMERCIALIZADORAS AGRICOLAS','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('03','PROMOTOR GRANDE','PROMOTOR GRANDE','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('04','GRAN EMPRESA','GRAN EMPRESA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('05','MEDIANA EMPRESA','MEDIANA EMPRESA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('06','PEQUENYA EMPRESA','PEQUENYA EMPRESA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('07','MICROEMPRESA','MICROEMPRESA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('08','PARTICULARES','PARTICULARES','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('09','SECTOR PUBLICO','SECTOR PUBLICO','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('10','ENTIDADES SIN ANIMO DE LUCRO','ENTIDADES SIN ANIMO DE LUCRO','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('11','INTERMEDIARIOS FINANCIEROS','INTERMEDIARIOS FINANCIEROS','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('12','RESTO SECTOR PRIMARIO MINORISTA','RESTO SECTOR PRIMARIO MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('13','AUTONOMOS','AUTONOMOS','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('14','INDUSTRIA AUX. AGROALIM. MINORISTA','INDUSTRIA AUX. AGROALIM. MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('16','PRODUCTOR PEQUEÑA','PRODUCTOR PEQUEÑA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('17','PRODUCTOR MEDIANA','PRODUCTOR MEDIANA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('18','PRODUCTOR GRANDE','PRODUCTOR GRANDE','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('19','COMERCIALIZADOR MINORISTA','COMERCIALIZADOR MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('20','COMERCIALIZADORA PEQUEÑA','COMERCIALIZADORA PEQUEÑA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('21','COMERCIALIZADORA MEDIANA','COMERCIALIZADORA MEDIANA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('22','COMERCIALIZADORA GRANDE','COMERCIALIZADORA GRANDE','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('23','ENTIDADES DE CREDITO','ENTIDADES DE CREDITO','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('24','IND. AUX. AGROALIMENTARIA PEQUEÑA','IND. AUX. AGROALIMENTARIA PEQUEÑA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('25','IND. AUX. AGROALIMENTARIA MEDIANA','IND. AUX. AGROALIMENTARIA MEDIANA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('26','IND. AUX. AGROALIMENTARIA GRANDE','IND. AUX. AGROALIMENTARIA GRANDE','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('27','PROMOTOR MINORISTA','PROMOTOR MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('28','PROMOTOR PEQUEÑA','PROMOTOR PEQUEÑA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('29','PROMOTOR MEDIANA','PROMOTOR MEDIANA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('30','CONSTRUCTOR MINORISTA','CONSTRUCTOR MINORISTA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('31','CONSTRUCTOR PEQUEÑA','CONSTRUCTOR PEQUEÑA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('32','CONSTRUCTOR MEDIANA','CONSTRUCTOR MEDIANA','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('33','CONSTRUCTOR GRANDE','CONSTRUCTOR GRANDE','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('34','PRODUC PEQUEÑA RETAIL    ','PRODUC PEQUEÑA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('35','PRODUC MEDIANA RETAIL    ','PRODUC MEDIANA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('36','COMERC PEQUEÑA RETAIL    ','COMERC PEQUEÑA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('37','COMERC MEDIANA RETAIL    ','COMERC MEDIANA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('38','PROMOT PEQUEÑA RETAIL    ','PROMOT PEQUEÑA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('39','PROMOT MEDIANA RETAIL    ','PROMOT MEDIANA RETAIL    ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('40','PEQUEÑA RETAILAIL        ','PEQUEÑA RETAILAIL        ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('41','MEDIANA RETAILAIL        ','MEDIANA RETAILAIL        ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('42','INDAUXAGRO PEQUEÑA RETAIL','INDAUXAGRO PEQUEÑA RETAIL','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('43','INDAUXAGRO MEDIANA RETAIL','INDAUXAGRO MEDIANA RETAIL','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('44','CONST PEQUEÑA RETAIL     ','CONST PEQUEÑA RETAIL     ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('45','CONST MEDIANA RETAIL     ','CONST MEDIANA RETAIL     ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('46','ISL PEQUEÑA RETAIL       ','ISL PEQUEÑA RETAIL       ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('47','ISL MICRO                ','ISL MICRO                ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('48','ISL MEDIANA RETAIL       ','ISL MEDIANA RETAIL       ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('49','ISL MEDCORP              ','ISL MEDCORP              ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('50','ISL GRANDE               ','ISL GRANDE               ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('51','ADM CENTRAL              ','ADM CENTRAL              ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('52','COMUNIDADAUT             ','COMUNIDADAUT             ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('53','CORPORA LOCAL            ','CORPORA LOCAL            ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('54','ADM SEG SOCIAL           ','ADM SEG SOCIAL           ','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('55','PRODBAJOPL PEQUEÑA RETAIL','PRODBAJOPL PEQUEÑA RETAIL','0','INICIAL','SYSDATE','null','null','null','null','0'),
T_SEC('56','PRODBAJOPL MEDIANA RETAIL','PRODBAJOPL MEDIANA RETAIL','0','INICIAL','SYSDATE','null','null','null','null','0')


			
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
   
  


   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLA||' WHERE DD_SCE_CODIGO = ''' || V_TMP_SEC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' - '||V_TMP_SEC(1) || ' YA EXISTE');



     --Actualizamos los ya existentes

 V_MSQL3 := 'UPDATE ' || V_ESQUEMA || '.'||TABLA||' 
					SET DD_SCE_DESCRIPCION = ''' || SUBSTR(V_TMP_SEC(2),1,50) || ''' ,
					    DD_SCE_DESCRIPCION_LARGA = ''' || V_TMP_SEC(3) || ''',
					    USUARIOCREAR = ''INICIAL'',
				            FECHACREAR = SYSDATE			
WHERE DD_SCE_CODIGO = ''' || V_TMP_SEC(1) || '''';

DBMS_OUTPUT.PUT_LINE(V_MSQL3);
EXECUTE IMMEDIATE V_MSQL3;
DBMS_OUTPUT.PUT_LINE('ACTUALIZAMOS DE LA TABLA '||TABLA||': '||V_TMP_SEC(1));

COMMIT;


  ELSE
  
  -- SECUENCIA INSERT
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLA||' 
                    ( DD_SCE_ID, DD_SCE_CODIGO, DD_SCE_DESCRIPCION, DD_SCE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
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


--Borramos de la tabla los no utilizados


  -- V_MSQL2 := 'DELETE FROM ' ||V_ESQUEMA|| '.'||TABLA||' WHERE USUARIOCREAR <> ''INICIAL''';
						
    
   --EXECUTE IMMEDIATE V_MSQL2;
  -- DBMS_OUTPUT.PUT_LINE('BORRAMOS DE LA TABLA '||TABLA||'');

COMMIT;



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
