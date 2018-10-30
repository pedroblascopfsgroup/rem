--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1945
--## PRODUCTO=NO
--##
--## Finalidad: Script que carga la tabla DD_ETG_EQV_TIPO_GASTO_RU
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial DAP
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  V_ENTIDAD_ID NUMBER(16);
  V_ID NUMBER(16);
  V_TABLA VARCHAR2(50 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU';
  V_DD_TGA_ID NUMBER(16);
  V_DD_STG_ID NUMBER(16);
    
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO]');
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);

      BEGIN
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ETG_EQV_TIPO_GASTO_RU WHERE DD_ETG_CODIGO = ''108''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

 	IF V_NUM_TABLAS > 0 THEN
        
		DBMS_OUTPUT.PUT_LINE('[INFO]: EL REGISTRO ''108'' YA HA SIDO INSERTADO');

	ELSE

		--Recuperamos DD_TGA_ID y DD_STG_ID
		V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_DESCRIPCION = ''Alquiler''';
		EXECUTE IMMEDIATE V_MSQL INTO V_DD_TGA_ID;
		
		V_MSQL := 'SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_TGA_ID = '||V_DD_TGA_ID||' AND DD_STG_DESCRIPCION = ''Fianzas''';
		EXECUTE IMMEDIATE V_MSQL INTO V_DD_STG_ID;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO ''108''');
		V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL INTO V_ID;
		
		--Insertamos registro
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_ETG_ID, DD_TGA_ID, DD_STG_ID
		  ,DD_ETG_CODIGO,DD_ETG_DESCRIPCION_POS,DD_ETG_DESCRIPCION_LARGA_POS
		  ,COGRUG_POS,COTACA_POS,COSBAC_POS
		  ,DD_ETG_DESCRIPCION_NEG,DD_ETG_DESCRIPCION_LARGA_NEG
		  ,COGRUG_NEG,COTACA_NEG,COSBAC_NEG
		  ,VERSION,USUARIOCREAR,FECHACREAR
		  ,BORRADO) VALUES ('||V_ID||', '||V_DD_TGA_ID||', '||V_DD_STG_ID||'
		  ,''108'', ''PAGO GASTO'', ''PAGO GASTO''
		  ,3, 31, 9
		  ,''ABONO/FACTURA'', ''ABONO/FACTURA'' 
		  ,3, 31, 10
		  ,0, ''REMVIP-1945'',SYSDATE,0)';

        EXECUTE IMMEDIATE V_MSQL;
       END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Id no encontrado');
      END;

  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
EXCEPTION
  WHEN OTHERS THEN
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
