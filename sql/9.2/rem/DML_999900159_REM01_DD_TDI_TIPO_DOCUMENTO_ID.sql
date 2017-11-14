--/*
--##########################################
--## AUTOR=RAMON LLINARES
--## FECHA_CREACION=20171114
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=2.0.9
--## INCIDENCIA_LINK=HREOS-3184
--## PRODUCTO=SI
--## Finalidad: Insercion registros tabla 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
     TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLA;
    V_TABLAS T_ARRAY_TABLAS := T_ARRAY_TABLAS(
	  T_TABLA('ACT_PVE_PROVEEDOR'),
	  T_TABLA('CLC_CLIENTE_COMERCIAL'),
	  T_TABLA('COM_COMPRADOR'),
	  T_TABLA('CLC_CLIENTE_COMERCIAL'),
	  T_TABLA('OFR_TIA_TITULARES_ADICIONALES')
    );
    ID_EXTRANJERO NUMBER(25);
    ID_NIE NUMBER(25);
   
    BEGIN
	--CAMBIO LA DESCRIPCION DEL TIPO DOC
	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = (''03'')';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT < 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el tipo a modificar');
	ELSE
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID SET DD_TDI_DESCRIPCION = ''TARJETA DE RESIDENTE / NIE'',DD_TDI_DESCRIPCION_LARGA=''TARJETA DE RESIDENTE / NIE'' WHERE DD_TDI_CODIGO=''03''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en la tabla');
	END IF;
	--CAMBIAMOS LAS REFERENCIAS A NIE POR REFERENCIAS A TARJETA DE RESIDENTE / NIE
	V_SQL:= 'SELECT DD_TDI_ID FROM DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO=''03''';
	EXECUTE IMMEDIATE V_SQL INTO ID_EXTRANJERO;
	V_SQL:= 'SELECT DD_TDI_ID FROM DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO=''12''';
	EXECUTE IMMEDIATE V_SQL INTO ID_NIE;
	FOR I IN V_TABLAS.FIRST .. V_TABLAS.LAST
      LOOP
		DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO TABLA '||V_TABLAS(I)(1)||' CAMBIANDO TIPO DOC '||ID_NIE||' POR '||ID_EXTRANJERO);
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLAS(I)(1) ||' SET DD_TDI_ID = '''||ID_EXTRANJERO||''' WHERE DD_TDI_ID='''||ID_NIE||'''';
		EXECUTE IMMEDIATE V_MSQL;
	 END LOOP;
	
	--BORRAMOS EL TIPO NIE
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID SET BORRADO = 1 WHERE DD_TDI_CODIGO=''12''';
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;

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
EXIT
