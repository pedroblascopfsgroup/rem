--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211231
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16737
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_VALIDACION_REF_CATASTRAL IS
	
    
   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   letraDc VARCHAR2(2000) := 'MQWERTYUIOPASDFGHJKLBZX';
    dcCalculado VARCHAR2(2000) := '';
    type pesoPosicion IS VARRAY(11) OF INTEGER;
    myArray pesoPosicion;
    var_cat_id number;
    var_cat_id2 number;
    var VARCHAR2(1000);
    var2 VARCHAR2(1000);
    valorCaracter number := NULL;
    sumaDigitos number := 0;
    var_LONGREF number;
    CURSOR c_product
  IS
     SELECT AUX.CAT_ID,AUX.CAT_ID2,AUX.CAT_CATASTRO,AUX.CAD1,AUX.CAD2,AUX.CAD3,AUX.LONGREF
        FROM(
            SELECT ACT_CAT.CAT_ID,
            CAT.CAT_ID AS CAT_ID2,
            ACT_CAT.CAT_REF_CATASTRAL,
            ACT_CAT.CAT_CATASTRO,
            

            CASE
                WHEN ACT_CAT.CAT_CATASTRO IS NOT NULL
                THEN LENGTH(CAT.CAT_REF_CATASTRAL)
                WHEN ACT_CAT.CAT_CATASTRO IS NULL
                THEN LENGTH(ACT_CAT.CAT_REF_CATASTRAL)
            END AS LONGREF,


            CASE
                WHEN ACT_CAT.CAT_CATASTRO IS NOT NULL
                THEN CONCAT(SUBSTR(CAT.CAT_REF_CATASTRAL, 1, 7),SUBSTR(CAT.CAT_REF_CATASTRAL, 15, 4))
                WHEN ACT_CAT.CAT_CATASTRO IS NULL
                THEN CONCAT(SUBSTR(ACT_CAT.CAT_REF_CATASTRAL, 1, 7),SUBSTR(ACT_CAT.CAT_REF_CATASTRAL, 15, 4))
            END AS CAD1,

            CASE
                WHEN ACT_CAT.CAT_CATASTRO IS NOT NULL
                THEN CONCAT(SUBSTR(CAT.CAT_REF_CATASTRAL, 8, 7),SUBSTR(CAT.CAT_REF_CATASTRAL, 15, 4))
                WHEN ACT_CAT.CAT_CATASTRO IS NULL
                THEN CONCAT(SUBSTR(ACT_CAT.CAT_REF_CATASTRAL, 8, 7),SUBSTR(ACT_CAT.CAT_REF_CATASTRAL, 15, 4))
            END AS CAD2,

            CASE
                WHEN ACT_CAT.CAT_CATASTRO IS NOT NULL
                THEN SUBSTR(CAT.CAT_REF_CATASTRAL, 19, 2)
                WHEN ACT_CAT.CAT_CATASTRO IS NULL
                THEN SUBSTR(ACT_CAT.CAT_REF_CATASTRAL, 19, 2)
            END AS CAD3

            FROM REM01.ACT_CAT_CATASTRO ACT_CAT
            LEFT JOIN REM01.CAT_CATASTRO CAT ON CAT.CAT_ID = ACT_CAT.CAT_CATASTRO
            WHERE ACT_CAT.BORRADO=0
                                   
            ) AUX           
            JOIN REM01.AUX_CAT_CATASTRO AUX_CAT ON AUX_CAT.CAT_REF_CATASTRAL = AUX.CAT_REF_CATASTRAL;


BEGIN

myArray := pesoPosicion(13,15,12,5,4,17,9,21,3,7,1);
FOR r_product IN c_product


LOOP
sumaDigitos := 0;
var2 := r_product.CAD3;
var_cat_id := r_product.CAT_ID;
var_cat_id2 := r_product.CAT_ID2;
var_LONGREF := r_product.LONGREF;
dcCalculado := '';
    IF (var_LONGREF != 20) THEN
        dbms_output.put_line('La longitud de la REF distinta de 20 ');
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO
                        SET CAT_CORRECTO = 0
                        WHERE CAT_ID = '||var_cat_id;
                       EXECUTE IMMEDIATE V_MSQL;
        ELSE              
    
        FOR i IN 1..LENGTH(r_product.CAD1) LOOP
            var := substr(r_product.CAD1,i,1);
            valorCaracter  := NULL;
            IF REGEXP_LIKE( var, '[0-9]') THEN
            valorCaracter  := var;
            
            ELSIF REGEXP_LIKE( var, '[A-N]') THEN
            valorCaracter  := ASCII(var)-64;
            
            ELSIF REGEXP_LIKE( var, '[Ñ]') THEN
            valorCaracter  := 15;
            
            ELSIF REGEXP_LIKE( var, '[N-Z]') THEN
            valorCaracter  := ASCII(var)-63;
            
    
            end if;
            
            IF ( (valorCaracter IS NOT NULL)  AND i < 12) THEN
                sumaDigitos:=MOD((sumaDigitos+(valorCaracter*myArray(i))),23);
            end if;
            
        END LOOP;
        dcCalculado := CONCAT(dcCalculado,(substr(letraDc,sumaDigitos,1)));
        FOR i IN 1..LENGTH(r_product.CAD2) LOOP
            var := substr(r_product.CAD2,i,1);
            valorCaracter  := NULL;
            IF REGEXP_LIKE( var, '[0-9]') THEN
            valorCaracter  := var;
            
            ELSIF REGEXP_LIKE( var, '[A-N]') THEN
            valorCaracter  := ASCII(var)-64;
            
            ELSIF REGEXP_LIKE( var, '[Ñ]') THEN
            valorCaracter  := 15;
            
            ELSIF REGEXP_LIKE( var, '[N-Z]') THEN
            valorCaracter  := ASCII(var)-63;
            
            end if;
            
            IF ( (valorCaracter IS NOT NULL)  AND i < 12) THEN
                sumaDigitos:=MOD((sumaDigitos+(valorCaracter*myArray(i))),23);
    
            end if;
            
        END LOOP;
     
    dcCalculado := CONCAT(dcCalculado,(substr(letraDc,sumaDigitos,1)));
    end if;

    IF ( dcCalculado =  var2 ) THEN
            dbms_output.put_line('CORRECTO ');
            dbms_output.put_line('dcCalculado '||dcCalculado||' ');
            dbms_output.put_line('SUBSTR '||var2||' ');
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO
                SET CAT_CORRECTO = 1
                WHERE CAT_ID = '||var_cat_id||' 
                AND CAT_CATASTRO IS NOT NULL';
                EXECUTE IMMEDIATE V_MSQL;
                
             V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO
                SET CAT_CORRECTO = 1,
                CAT_CATASTRO = var_cat_id2
                WHERE CAT_ID = var_cat_id 
                AND CAT_CATASTRO IS NULL
                AND var_cat_id IN (SELECT CAT.CAT_ID FROM '||V_ESQUEMA||'.CAT_CATASTRO CAT WHERE CAT.CAT_ID = '||var_cat_id||')';
                EXECUTE IMMEDIATE V_MSQL; 
                
                
        
         ELSE
          dbms_output.put_line('DISTINTO ');
            dbms_output.put_line('dcCalculado '||dcCalculado||' ');
            dbms_output.put_line('SUBSTR '||var2||' ');
           V_MSQL := ' UPDATE '||V_ESQUEMA||'.ACT_CAT_CATASTRO
                SET CAT_CORRECTO = 0
                WHERE CAT_ID = '||var_cat_id;
                EXECUTE IMMEDIATE V_MSQL;
                
           
        end if;


END LOOP;




EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      
      ROLLBACK;
      RAISE;
END SP_VALIDACION_REF_CATASTRAL;
/
EXIT;

