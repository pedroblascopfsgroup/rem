--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de diccionario DD_EIC_ESTADO_INTERNO_CAJAMAR
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- DD_EIC_ESTADO_INTERNO_CAJAMAR
 TYPE T_EIC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_EIC IS TABLE OF T_EIC;


  

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLADD1 VARCHAR(30) :='DD_EIC_ESTADO_INTERNO_ENTIDAD';
 SECUENCIA VARCHAR(30) := 'DD_EIC_EDO_INTERNO_ENTIDAD' ;
err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);

 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_EIC T_ARRAY_EIC := T_ARRAY_EIC(
        T_EIC('0','SITUACION NORMAL','Normal','0','DD','SYSDATE','0'),
	T_EIC('1','SITUACION NORMAL','Normal','0','DD','SYSDATE','0'),
	T_EIC('2','VENCIDO/EXCEDIDO','Objetiva. Vencido','0','DD','SYSDATE','0'),
	T_EIC('3','DUDOSO NO VENCIDO','Subjetiva. Dudoso por dudosidad','0','DD','SYSDATE','0'),
	T_EIC('4','DUDOSO VENCIDO','Subjetiva. Dudoso por dudosidad','0','DD','SYSDATE','0'),
	T_EIC('5','MOROSO 3-6 MESES','Objetiva. Moroso','0','DD','SYSDATE','0'),
	T_EIC('6','MOROSO 6-12 MESES','Objetiva. Moroso','0','DD','SYSDATE','0'),
	T_EIC('7','MOROSO 12-18 MESES','Objetiva. Moroso','0','DD','SYSDATE','0'),
	T_EIC('8','MOROSO 18-21 MESES','Objetiva. Moroso','0','DD','SYSDATE','0'),
	T_EIC('9','MOROSO MAS DE 21 MESES','Objetiva. Moroso','0','DD','SYSDATE','0'),
	T_EIC('10','SUSPENSO','No es "Cartera", está fuera de balance. No se incluye','0','DD','SYSDATE','0'),
	T_EIC('XX','SUBESTANDAR','Subjetiva. Subestandar','0','DD','SYSDATE','0')

 );
 
 
 


 V_TMP_EIC T_EIC;

	   
	


BEGIN 


 
 EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA|| '.'||TABLADD1);   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD1);

 
 
 FOR I IN V_EIC.FIRST .. V_EIC.LAST
 LOOP
   V_TMP_EIC := V_EIC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_EIC(1));   
   
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD1||' 
                    (DD_EIC_ID, DD_EIC_CODIGO, DD_EIC_DESCRIPCION, DD_EIC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||SECUENCIA||'.NEXTVAL,'''
                        ||V_TMP_EIC(1)||q'[',']'
                        ||V_TMP_EIC(2)||q'[',']'
                        ||V_TMP_EIC(3)||q'[',]'
                        ||V_TMP_EIC(4)||q'[,']'
                        ||V_TMP_EIC(5)||q'[',]' 
                        ||V_TMP_EIC(6)||q'[,]' 
                        ||V_TMP_EIC(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 
 COMMIT;

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
