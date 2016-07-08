--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1844
--## PRODUCTO=SI
--##
--## Finalidad: DML Datos nuevo diccionario DD_DVI_DESTINO_VIVIENDA
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
   TYPE T_DVI is table of  VARCHAR2(250);
   TYPE T_ARRAY_DVI  IS TABLE OF T_DVI;

   V_DVI T_ARRAY_DVI := T_ARRAY_DVI(
         T_DVI('1','VIVIENDA HABITUAL'),
         T_DVI('2','SEGUNDA VIVIENDA'),
         T_DVI('3','PARA ARRENDAMIENTOS A TERCEROS'),
         T_DVI('4','OFICINA'),
         T_DVI('5','PARA LA VENTA'),
         T_DVI('6','USO PROPIO'),
         T_DVI('7','EXPLOTACION AGRARIA'),
         T_DVI('8','DESARROLLO URBANISTICO (INCLUIDA PROMOCION)'),
         T_DVI('9','OTROS USOS'),
		 T_DVI('0','DESCONOCIDO')
	);

   V_SEQ_ID NUMBER(16);
   V_TMP_DVI T_DVI;
BEGIN    

   DBMS_OUTPUT.PUT_LINE('Empezamos......');
   FOR I IN V_DVI.FIRST .. V_DVI.LAST
   LOOP
      V_TMP_DVI := V_DVI(I);
      
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA WHERE DD_DVI_CODIGO = '''|| V_TMP_DVI(1) ||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN    
         DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la fila '|| V_TMP_DVI(1) || ' - ' ||  V_TMP_DVI(2));
      ELSE
         DBMS_OUTPUT.PUT_LINE('Insertanto DD_DVI_DESTINO_VIVIENDA: ' || V_TMP_DVI(1) || ' - ' ||  V_TMP_DVI(2));   
              
         V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DVI_DESTINO_VIVIENDA (DD_DVI_ID, DD_DVI_CODIGO, DD_DVI_DESCRIPCION, DD_DVI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                   ' VALUES ('||V_ESQUEMA||'.S_DD_DVI_DESTINO_VIVIENDA.NEXTVAL, ''' || V_TMP_DVI(1) || ''','''||V_TMP_DVI(2)||''', '''||V_TMP_DVI(2)||''', 0, ''PRODU-1844'', SYSDATE, 0)';
         EXECUTE IMMEDIATE V_MSQL;
      END IF;
   END LOOP;
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

EXIT;
