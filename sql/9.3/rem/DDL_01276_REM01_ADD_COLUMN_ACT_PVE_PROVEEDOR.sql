--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17597
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17597'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --COLUMNA      TIPO         COMENTARIO                     NOMBRE FK/TABLA DESTINO FK/CAMPO DESTINO FK/SE AÑADE FK
       T_TIPO_DATA('DD_OPH_ID', 'NUMBER(16,0)', 'Origen petición homologación','FK_PVE_OPH','DD_OPH_ORIGEN_PETI_HOMOLOG','DD_OPH_ID','SI'),
       T_TIPO_DATA('PVE_PETICIONARIO', 'VARCHAR2(100 CHAR)', 'se indica también el nombre del trabajador que lo propone, número oficina o el tique Silk.','','','','NO'),
       T_TIPO_DATA('PVE_LINEA_NEGOCIO', 'NUMBER(16,0)', 'Línea de negocio, FK de DD_TCO_TIPO_COMERCIALIZACION.','FK_LINEA_NEGOCIO','DD_TCO_TIPO_COMERCIALIZACION','DD_TCO_ID','SI'),     
       T_TIPO_DATA('PVE_GEST_CLIENT_NO_RESIDENTES', 'NUMBER(16,0)', 'Gestión de clientes no residentes.','FK_PVE_GEST_CLIENT','REMMASTER.DD_SIN_SINO','DD_SIN_ID','SI'),
       T_TIPO_DATA('PVE_NUMERO_COMERCIALES', 'NUMBER(16,0)', 'Número de comerciales.','','','','NO'),
       T_TIPO_DATA('PVE_FECHA_ULT_CNT_VIGNETE', 'DATE', 'Fecha último contrato vigente.','','','','NO'),
       T_TIPO_DATA('PVE_MOTIVO_BAJA', 'VARCHAR2(100 CHAR)', 'Motivo baja.','','','','NO')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_PVE_PROVEEDOR');


	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);


		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||'''
                             
														 and TABLE_NAME = '''||V_TEXT_TABLA||''' 
														 and OWNER = '''||V_ESQUEMA||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- si no existen las columnas se crean
    IF V_NUM_TABLAS = 0 THEN
		
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
             ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
             
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';

      EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));     
      
      IF V_TMP_TIPO_DATA(7) = 'SI' THEN


        -- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
        V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_TMP_TIPO_DATA(4)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
        IF V_NUM_TABLAS = 0 THEN
            --No existe la FK y la creamos
            DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_TMP_TIPO_DATA(4)||']');
            V_MSQL := '
            ALTER TABLE '||V_TEXT_TABLA||'
            ADD CONSTRAINT '||V_TMP_TIPO_DATA(4)||' FOREIGN KEY
            (
                '||V_TMP_TIPO_DATA(1)||'
            )
            REFERENCES '||V_TMP_TIPO_DATA(5)||'
            (
                '||V_TMP_TIPO_DATA(6)||' 
            )
            ON DELETE SET NULL ENABLE
            ';

            EXECUTE IMMEDIATE V_MSQL;
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_TMP_TIPO_DATA(4)||' creada en tabla correctamente');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] ... FK '||V_TMP_TIPO_DATA(4)||' YA EXISTE ... NO SE HACE NADA.');
        END IF;



      END IF;


    ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'Ya Existe. No se hace nada');
      		
		END IF;

    DBMS_OUTPUT.PUT_LINE(' -------------------------------------------');
		
	END LOOP;
    
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA ACT_PVE_PROVEEDOR');
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKs ... OK *************************************************');

	
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
