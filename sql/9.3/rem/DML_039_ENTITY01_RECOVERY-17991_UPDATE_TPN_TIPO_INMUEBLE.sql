--/*
--######################################### 
--## AUTOR=Roman Romanchuk
--## FECHA_CREACION=20180819
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=v9.7.03-hy
--## INCIDENCIA_LINK=RECOVERY-17991
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar los nuevos códigos en la tabla DD_TPN_TIPO_INMUEBLE
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TABLA VARCHAR2(30 CHAR) := 'DD_TPN_TIPO_INMUEBLE';  -- Tabla a modificar
  V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_TPN_TIPO_INMUEBLE';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'RECOVERY-17991'; -- USUARIOCREAR/USUARIOMODIFICAR

    --Array que contiene los registros que se van a actualizar
    TYPE T_FUN is table of VARCHAR2(500); 
    TYPE T_ARRAY_FUN IS TABLE OF T_FUN;
    V_FUN T_ARRAY_FUN := T_ARRAY_FUN(
	T_FUN('0904',	'Vivienda colectiva',			'Vivienda colectiva'),
	T_FUN('0942',	'Loft',					'Loft'),
	T_FUN('0905',	'Vivienda unifamiliar aislada',		'Vivienda unifamiliar aislada'),
	T_FUN('0906',	'Vivienda unifamiliar pareada',		'Vivienda unifamiliar pareada'),
	T_FUN('0907',	'Vivienda unifamiliar adosada',		'Vivienda unifamiliar adosada'),
	T_FUN('0908',	'Edificio exclusivo (oficinas)',	'Edificio exclusivo (oficinas)'),
	T_FUN('0909',	'Oficina en edificio exclusivo',	'Oficina en edificio exclusivo'),
	T_FUN('0910',	'Oficina en edificio residencial',	'Oficina en edificio residencial'),
	T_FUN('0911',	'Centro comercial',			'Centro comercial'),
	T_FUN('0912',	'Local en centro comercial',		'Local en centro comercial Polivalente'),
	T_FUN('0934',	'Cine, Teatro, Discoteca',		'Cine, Teatro, Discoteca'),
	T_FUN('0913',	'Local en edificio residencial',	'Local en edificio residencial Polivalente'),
	T_FUN('0930',	'Gasolinera',				'Gasolinera'),
	T_FUN('0914',	'Local en edificio de oficinas',	'Local en edificio de oficinas Polivalente'),
	T_FUN('0943',	'Instalación deportiva',		'Instalación deportiva'),
	T_FUN('0932',	'Campo de golf',			'Campo de golf'),
	T_FUN('0933',	'Hospital, Clínica',			'Hospital, Clínica'),
	T_FUN('0943',	'Instalación deportiva',		'Instalación deportiva'),
	T_FUN('0932',	'Campo de golf',			'Campo de golf'),
	T_FUN('0929',	'Parque de medianas',			'Parque de medianas'),
	T_FUN('0949',	'Local en centro comercial',		'Local en centro comercial No Polivalente'),
	T_FUN('0950',	'Local en edificio residencial',	'Local en edificio residencial No Polivalente'),
	T_FUN('0951',	'Local en edificio de oficinas',	'Local en edificio de oficinas No Polivalente'),
	T_FUN('0937',	'Pantano/Recursos hidráulicos',		'Pantano/Recursos hidráulicos'),
	T_FUN('0915',	'Nave',					'Nave. Polivalente'),
	T_FUN('0916',	'Nave adosada',				'Nave adosada Polivalente'),
	T_FUN('0917',	'Nave escaparate',			'Nave escaparate Polivalente'),
	T_FUN('0946',	'Nave',					'Nave. No polivalente'),
	T_FUN('0947',	'Nave adosada',				'Nave adosada No polivalente'),
	T_FUN('0918',	'Industrial en altura',			'Industrial en altura'),
	T_FUN('0948',	'Nave escaparate',			'Nave escaparate No polivalente'),
	T_FUN('0919',	'Hotel urbano',				'Hotel urbano'),
	T_FUN('0920',	'Hotel vacacional',			'Hotel vacacional'),
	T_FUN('0921',	'Hotel rural',				'Hotel rural'),
	T_FUN('0922',	'Hostal/Pensión',			'Hostal/Pensión'),
	T_FUN('0923',	'Aparthotel/AATT',			'Aparthotel/AATT'),
	T_FUN('0924',	'Camping',				'Camping'),
	T_FUN('0925',	'Garaje',				'Garaje'),
	T_FUN('0926',	'Trastero',				'Trastero'),
	T_FUN('0927',	'Promoción sin división horizontal',	'Promoción sin división horizontal.'),
	T_FUN('0928',	'Suelo.',				'Suelo.'),
	T_FUN('0931',	'Residncia de estudiantes',		'Residncia de estudiantes'),
	T_FUN('0936',	'Geriátrico',				'Geriátrico'),
	T_FUN('0935',	'Concesion administrativa/ otros derechos','Concesion administrativa/ otros derechos'),
	T_FUN('0938',	'Edificio de Garajes',			'Edificio de Garajes'),
	T_FUN('0939',	'Inmueble Uso dotacional privado',	'Inmueble Uso dotacional privado'),
	T_FUN('0940',	'Otro',					'Otro'),
	T_FUN('0941',	'Superficie en zona común',		'Superficie en zona común')
    );
    V_TMP_FUN T_FUN;
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprovaciones previas...');
  
  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');  

    FOR I IN V_FUN.FIRST .. V_FUN.LAST 
    LOOP
      V_TMP_FUN := V_FUN(I);  
  
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPN_CODIGO = '''||V_TMP_FUN(1)||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Insertando '||V_TMP_FUN(2)||'...');
        EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            DD_TPN_ID,
            DD_TPN_CODIGO,
            DD_TPN_DESCRIPCION,
	    DD_TPN_DESCRIPCION_LARGA,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
            , '''||V_TMP_FUN(1)||'''
            , '''||V_TMP_FUN(2)||'''
	    , '''||V_TMP_FUN(3)||'''
            , 0
            , '''||V_USR||'''
            , SYSDATE
            , 0
          FROM DUAL
        '
        ;
      ELSE
        DBMS_OUTPUT.PUT_LINE('      [INFO] El codigo '||V_TMP_FUN(1)||' existe. Actualizando '||V_TMP_FUN(2)||'...');
	EXECUTE IMMEDIATE '
          UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
          SET DD_TPN_DESCRIPCION = '''||V_TMP_FUN(2)||''',
		    DD_TPN_DESCRIPCION_LARGA = '''||V_TMP_FUN(3)||''',
		    USUARIOMODIFICAR = '''||V_USR||''',
		    FECHAMODIFICAR = SYSDATE
          WHERE DD_TPN_CODIGO = '''||V_TMP_FUN(1)||''' AND BORRADO = 0
        '
        ;
      END IF;
      
    END LOOP;
    
    COMMIT;
    
  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... No existe.');
  END IF;
    
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
