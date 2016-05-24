--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-812
--## PRODUCTO=SI
--##
--## Finalidad: Modifica el tamaño de las columnas usuariocrear, modificar y borrar de PCO_OBS_OBSERVACIONES
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_COLUMN IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_COLUMN IS TABLE OF T_TIPO_COLUMN;
    V_TIPO_COLUMN T_ARRAY_COLUMN := T_ARRAY_COLUMN(   
      T_TIPO_COLUMN('USUARIOCREAR'),
      T_TIPO_COLUMN('USUARIOMODIFICAR'),
      T_TIPO_COLUMN('USUARIOBORRAR')
     );
     V_TMP_TIPO_COLUMN T_TIPO_COLUMN;
    
BEGIN
	 FOR I IN V_TIPO_COLUMN.FIRST .. V_TIPO_COLUMN.LAST
      LOOP
      	V_TMP_TIPO_COLUMN := V_TIPO_COLUMN(I);
        	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES MODIFY '||V_TMP_TIPO_COLUMN(1)||' VARCHAR2(50 CHAR)';
						
			EXECUTE IMMEDIATE V_MSQL;	
		DBMS_OUTPUT.PUT_LINE('Modificados el tamanyo de los campos para la columna ' ||V_TMP_TIPO_COLUMN(1)||' de '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES');
	END LOOP;
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
						
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;