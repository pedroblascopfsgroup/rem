--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16330
--## PRODUCTO=NO
--## 
--## Finalidad: Nueva interfaz informe
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
  V_TEXT_TABLA VARCHAR2(50 CHAR):= 'ACT_ICO_INFO_COMERCIAL';

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('ADD_COLUMN', 'ICO_ACTIVO_PRINCIPAL', 'NUMBER(16,0)', 'Indicador activo principal'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ACTIVO_PRINCIPAL', 'ICO_ACTIVO_PRINCIPAL','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'DD_ESO_ID', 'NUMBER(16,0)', 'Id Estado ocupacional'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_ESO_ID', 'DD_ESO_ID','DD_ESO_ESTADO_OCUPACIONAL','DD_ESO_ID',''),
    T_COL('ADD_COLUMN', 'ICO_SUP_REGISTRAL', 'NUMBER(13,2)', 'Superficie registral activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_DORMITORIOS', 'NUMBER(11,0)', 'Indicador numero dormitorios activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_BANYOS', 'NUMBER(11,0)', 'Indicador numero banyos activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_GARAJE', 'NUMBER(11,0)', 'Indicador numero plazas garaje activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_ASEOS', 'NUMBER(11,0)', 'Indicador numero aseos activo'),
    T_COL('ADD_COLUMN', 'ICO_TERRAZA', 'NUMBER(16,0)', 'Indicador terraza activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_TERRAZA', 'ICO_TERRAZA','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_PATIO', 'NUMBER(16,0)', 'Indicador patio activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_PATIO', 'ICO_PATIO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_ASCENSOR', 'NUMBER(16,0)', 'Indicador ascensor activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ASCENSOR', 'ICO_ASCENSOR','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_REHABILITADO', 'NUMBER(16,0)', 'Indicador activo rehabilitado'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_REHABILITADO', 'ICO_REHABILITADO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_LIC_APERTURA', 'NUMBER(16,0)', 'Indicador licencia apertura activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_LIC_APERTURA', 'ICO_LIC_APERTURA','DD_SIN_SINO','DD_SIN_ID','1'), 
    T_COL('ADD_COLUMN', 'ICO_ANEJO_GARAJE', 'NUMBER(16,0)', 'Indicador anejo garaje activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ANEJO_GARAJE', 'ICO_ANEJO_GARAJE','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_ANEJO_TRASTERO', 'NUMBER(16,0)', 'Indicador anejo trastero activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ANEJO_TRASTERO', 'ICO_ANEJO_TRASTERO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'DD_RAC_ID', 'NUMBER(16,0)', 'Id Rating cocina'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_RAC_ID', 'DD_RAC_ID','DD_RAC_RATING_COCINA','DD_RAC_ID',''),
    T_COL('ADD_COLUMN', 'ICO_COCINA_AMUEBLADA', 'NUMBER(16,0)', 'Indicador cocina amueblada activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_COCINA_AMUEBLADA', 'ICO_COCINA_AMUEBLADA','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_ORIENTACION', 'VARCHAR2(250 CHAR)', 'Orientacion/es del activo'),
    T_COL('ADD_COLUMN', 'ICO_CALEFACCION', 'VARCHAR2(250 CHAR)', 'Calefaccion/es del activo'),
    T_COL('ADD_COLUMN', 'DD_TCA_ID', 'NUMBER(16,0)', 'Id Tipo calefaccion'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_TCA_ID', 'DD_TCA_ID','DD_TCA_TIPO_CALEFACCION','DD_TCA_ID',''),
    T_COL('ADD_COLUMN', 'DD_TCL_ID', 'NUMBER(16,0)', 'Id Tipo climatizacion'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_TCL_ID', 'DD_TCL_ID','DD_TCL_TIPO_CLIMATIZACION','DD_TCL_ID',''),
    T_COL('ADD_COLUMN', 'ICO_ARM_EMPOTRADOS', 'NUMBER(16,0)', 'Indicador armarios empotrados activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ARM_EMPOTRADOS', 'ICO_ARM_EMPOTRADOS','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_SUP_TERRAZA', 'NUMBER(13,2)', 'Superficie terraza activo'),
    T_COL('ADD_COLUMN', 'ICO_SUP_PATIO', 'NUMBER(13,2)', 'Superficie patio activo'),
    T_COL('ADD_COLUMN', 'DD_EXI_ID', 'NUMBER(16,0)', 'Id Tipo exterior/interior'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_EXI_ID', 'DD_EXI_ID','DD_EXI_EXTERIOR_INTERIOR','DD_EXI_ID',''),
    T_COL('ADD_COLUMN', 'ICO_ZONAS_VERDES', 'NUMBER(16,0)', 'Indicador zonas verdes activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ZONAS_VERDES', 'ICO_ZONAS_VERDES','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_CONSERJE', 'NUMBER(16,0)', 'Indicador conserje activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_CONSERJE', 'ICO_CONSERJE','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_INST_DEPORTIVAS', 'NUMBER(16,0)', 'Indicador instalaciones deportivas activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_INST_DEPORTIVAS', 'ICO_INST_DEPORTIVAS','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_ACC_MINUSVALIDO', 'NUMBER(16,0)', 'Indicador acceso minusvalidos activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ACC_MINUSVALIDO', 'ICO_ACC_MINUSVALIDO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_JARDIN', 'NUMBER(16,0)', 'Indicador disponibilidad jardin'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_JARDIN', 'ICO_JARDIN','DD_DIS_DISPONIBILIDAD','DD_DIS_ID',''),
    T_COL('ADD_COLUMN', 'ICO_PISCINA', 'NUMBER(16,0)', 'Indicador disponibilidad piscina'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_PISCINA', 'ICO_PISCINA','DD_DIS_DISPONIBILIDAD','DD_DIS_ID',''),
    T_COL('ADD_COLUMN', 'ICO_GIMNASIO', 'NUMBER(16,0)', 'Indicador disponibilidad gimnasio'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_GIMNASIO', 'ICO_GIMNASIO','DD_DIS_DISPONIBILIDAD','DD_DIS_ID',''),
    T_COL('ADD_COLUMN', 'DD_ESC_ID', 'NUMBER(16,0)', 'Id Estado conservacion edificio'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_ESC_ID', 'DD_ESC_ID','DD_ESC_ESTADO_CONSERVACION_EDIFICIO','DD_ESC_ID',''),
    T_COL('ADD_COLUMN', 'ICO_NUM_PLANTAS_EDI', 'NUMBER(11,0)', 'Indicador numero plantas edificio activo'),
    T_COL('ADD_COLUMN', 'DD_TPU_ID', 'NUMBER(16,0)', 'Id Tipo puerta'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_TPU_ID', 'DD_TPU_ID','DD_TPU_TIPO_PUERTA','DD_TPU_ID',''),
    T_COL('ADD_COLUMN', 'ICO_PUERTAS_INT', 'NUMBER(16,0)', 'Indicador estado puertas interiores'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_PUERTAS_INT', 'ICO_PUERTAS_INT','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_COLUMN', 'ICO_VENTANAS', 'NUMBER(16,0)', 'Indicador estado ventanas'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_VENTANAS', 'ICO_VENTANAS','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_COLUMN', 'ICO_PERSIANAS', 'NUMBER(16,0)', 'Indicador estado persianas'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_PERSIANAS', 'ICO_PERSIANAS','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_COLUMN', 'ICO_PINTURA', 'NUMBER(16,0)', 'Indicador estado pintura'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_PINTURA', 'ICO_PINTURA','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_COLUMN', 'ICO_SOLADOS', 'NUMBER(16,0)', 'Indicador estado solados'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_SOLADOS', 'ICO_SOLADOS','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_COLUMN', 'ICO_BANYOS', 'NUMBER(16,0)', 'Indicador estado banyos'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ICO_BANYOS', 'ICO_BANYOS','DD_ESM_ESTADO_MOBILIARIO','DD_ESM_ID',''),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ADMITE_MASCOTAS', 'ICO_ADMITE_MASCOTAS','DD_ADM_ADMISION','DD_ADM_ID',''),
    T_COL('ADD_COLUMN', 'DD_VUB_ID', 'NUMBER(16,0)', 'Id Valoracion ubicacion'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_VUB_ID', 'DD_VUB_ID','DD_VUB_VALORACION_UBICACION','DD_VUB_ID',''),
    T_COL('ADD_COLUMN', 'ICO_SALIDA_HUMOS', 'NUMBER(16,0)', 'Indicador salida humos activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_SALIDA_HUMOS', 'ICO_SALIDA_HUMOS','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_USO_BRUTO', 'NUMBER(16,0)', 'Indicador apto uso bruto activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_USO_BRUTO', 'ICO_USO_BRUTO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_EDIFICABILIDAD', 'NUMBER(13,2)', 'Superficie edificabilidad techo'),
    T_COL('ADD_COLUMN', 'ICO_SUP_PARCELA', 'NUMBER(13,2)', 'Superficie parcela activo'),
    T_COL('ADD_COLUMN', 'ICO_URBANIZACION_EJEC', 'NUMBER(5,2)', 'Porcentaje urbanizacion ejecutado'),
    T_COL('ADD_COLUMN', 'ICO_MTRS_FACHADA', 'NUMBER(6,2)', 'Metros lineales fachada activo'),
    T_COL('ADD_COLUMN', 'ICO_SUP_ALMACEN', 'NUMBER(13,2)', 'Superficie almacen activo'),
    T_COL('ADD_COLUMN', 'DD_CLA_ID', 'NUMBER(16,0)', 'Id Clasificacion'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_CLA_ID', 'DD_CLA_ID','DD_CLA_CLASIFICACION','DD_CLA_ID',''),
    T_COL('ADD_COLUMN', 'DD_USA_ID', 'NUMBER(16,0)', 'Id Uso activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_DD_USA_ID', 'DD_USA_ID','DD_USA_USO_ACTIVO','DD_USA_ID',''),
    T_COL('ADD_COLUMN', 'ICO_ALMACEN', 'NUMBER(16,0)', 'Indicador almacen activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ALMACEN', 'ICO_ALMACEN','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_VENTA_EXPO', 'NUMBER(16,0)', 'Indicador superficie venta exposicion activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_VENTA_EXPO', 'ICO_VENTA_EXPO','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_ENTREPLANTA', 'NUMBER(16,0)', 'Indicador entreplanta activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_ENTREPLANTA', 'ICO_ENTREPLANTA','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_SUP_VENTA_EXPO', 'NUMBER(13,2)', 'Superficie venta exposicion construido'),
    T_COL('ADD_COLUMN', 'ICO_ALTURA_LIBRE', 'NUMBER(6,2)', 'Metros lineales altura libre activo'),
    T_COL('ADD_COLUMN', 'ICO_EDIFICACION_EJEC', 'NUMBER(5,2)', 'Porcentaje edificacion ejecutada'),
    T_COL('ADD_COLUMN', 'ICO_VISITABLE', 'NUMBER(16,0)', 'Indicador visitable activo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_VISITABLE', 'ICO_VISITABLE','DD_SIN_SINO','DD_SIN_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_RECEPCION_INFORME', 'DATE', 'Fecha recepcion informe'),
    T_COL('ADD_COLUMN', 'ICO_FECHA_MODIFICACION', 'DATE', 'Fecha modificacion informe'),
    T_COL('ADD_COLUMN', 'ICO_FECHA_INFORME_COMPLETO', 'DATE', 'Fecha informe completo'),
    T_COL('ADD_COLUMN', 'ICO_USU_MODIFICACION', 'NUMBER(16,0)', 'Usuario modificacion informe'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_USU_MODIFICACION', 'ICO_USU_MODIFICACION','USU_USUARIOS','USU_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_USU_INFORME_COMPLETO', 'NUMBER(16,0)', 'Usuario informe completo'),
    T_COL('ADD_CONSTRAINT', 'FK_ICO_USU_INFORME_COMPLETO', 'ICO_USU_INFORME_COMPLETO','USU_USUARIOS','USU_ID','1'),
    T_COL('ADD_COLUMN', 'ICO_VALOR_MIN_VENTA', 'NUMBER(15,6)', 'Valor minimo venta activo'),
    T_COL('ADD_COLUMN', 'ICO_VALOR_MAX_VENTA', 'NUMBER(15,6)', 'Valor maximo venta activo'),
    T_COL('ADD_COLUMN', 'ICO_VALOR_MIN_RENTA', 'NUMBER(15,6)', 'Valor minimo renta activo'),
    T_COL('ADD_COLUMN', 'ICO_VALOR_MAX_RENTA', 'NUMBER(15,6)', 'Valor maximo renta activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_SALONES', 'NUMBER(16,0)', 'Indicador num salones activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_ESTANCIAS', 'NUMBER(16,0)', 'Indicador num estancias activo'),
    T_COL('ADD_COLUMN', 'ICO_NUM_PLANTAS', 'NUMBER(16,0)', 'Indicador num plantas activo'));  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');

    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINAR FK ANTERIOR ICO_ADMITE_MASCOTAS');
    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND CONSTRAINT_NAME = ''FK_DD_SINI''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] Eliminando FK ''FK_DD_SINI'' de '||V_TEXT_TABLA||'.ICO_ADMITE_MASCOTAS');  
        
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP CONSTRAINT FK_DD_SINI';
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción ''FK_DD_SINI'' no existe.');
    END IF; 
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'ADD_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_COLUMN]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND COLUMN_NAME = '''||V_TMP_COL(2)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo Columna '||V_TMP_COL(2)||'');
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD '||V_TMP_COL(2)||' '||V_TMP_COL(3)||''; 

                    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_COL(2)||' IS '''||V_TMP_COL(4)||'''';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna '||V_TMP_COL(2)||' creado.');      
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TEXT_TABLA||'.'||V_TMP_COL(2)||'... ya existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... No existe.');  
            END IF;
        END IF;

        IF 'ADD_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(2)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiento FK '||V_TMP_COL(2)||'');  
                    IF '1' = ''||V_TMP_COL(6)||'' THEN
                        DBMS_OUTPUT.PUT_LINE('  [INFO] TABLA DE REMMASTER');
                        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT '||V_TMP_COL(2)||' FOREIGN KEY('||V_TMP_COL(3)||') REFERENCES '||V_ESQUEMA_M||'.'||V_TMP_COL(4)||'('||V_TMP_COL(5)||')';
                    ELSE
                        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT '||V_TMP_COL(2)||' FOREIGN KEY('||V_TMP_COL(3)||') REFERENCES '||V_TMP_COL(4)||'('||V_TMP_COL(5)||')';
                    END IF; 
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(2)||' ya existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TEXT_TABLA||'... No existe.');
            END IF;    
        END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    COMMIT;  
    
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
