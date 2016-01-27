--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20160118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-585
--## PRODUCTO=NO
--##
--## Finalidad: Inserta tipos de juicio.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TPROCE VARCHAR2(100 CHAR); -- Vble. auxiliar para obtener tipo procedimiento.
    
    
    
    --Valores en FUN_PEF
    TYPE T_TIPO_JUICIO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TJ IS TABLE OF T_TIPO_JUICIO;
    V_TIPO_JUICIO T_ARRAY_TJ := T_ARRAY_TJ(
      T_TIPO_JUICIO('HIP', 'P. hipotecario - HAYA', 'Procedimiento Hipotecario - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H001'),
      T_TIPO_JUICIO('SBS', 'Subasta Sareb - HAYA', 'Subasta Sareb - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H002'),
      T_TIPO_JUICIO('SBT', 'Subasta a tereceros - HAYA', 'Subasta a terceros - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H004'),
      T_TIPO_JUICIO('CES', 'T. de cesión de remate - HAYA', 'T. de cesión de remate - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H006'),
      T_TIPO_JUICIO('ADJ', 'T. de adjudicación - HAYA', 'T. de adjudicación - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H005'),
      T_TIPO_JUICIO('TCS', 'T. de costas - HAYA', 'T. de costas - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H007'),
      /*T_TIPO_JUICIO('CCG', 'Certificación de cargas - HAYA', 'Certificación de cargas - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H030'),*/
      T_TIPO_JUICIO('INT', 'T. intereses - HAYA', 'T. intereses - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H042'),
      T_TIPO_JUICIO('GLL', 'T. Gestión de llaves - HAYA', 'T. Gestión de llaves - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H040'),
      T_TIPO_JUICIO('OCU', 'T. Ocupantes - HAYA', 'T. Ocupantes - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H048'),
      T_TIPO_JUICIO('MRL', 'T. Moratoria de lanzamiento - HAYA', 'T. Moratoria de lanzamiento - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H011'),
      T_TIPO_JUICIO('POS', 'T. de posesión - HAYA', 'T. de posesión - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H015'),
      T_TIPO_JUICIO('SDA', 'T. subsanación decreto adjudicación - HAYA', 'T. subsanación decreto adjudicación - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H052'),
      T_TIPO_JUICIO('ORD', 'P. Ordinario - HAYA', 'P. Ordinario - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H024'),
      T_TIPO_JUICIO('MON', 'P. Monitorio - HAYA', 'P. Ordinario - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H022'),
      T_TIPO_JUICIO('VBL', 'P. Verbal - HAYA', 'P. Verbal - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H026'),
      T_TIPO_JUICIO('VMN', 'P. Verbal desde Monitorio - HAYA', 'P. Verbal desde Monitorio - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H028'),
      T_TIPO_JUICIO('CCR', 'T. Certificado de cargas y revisión - HAYA', 'T. Certificado de cargas y revisión - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H030'),
      T_TIPO_JUICIO('EMS', 'T. Embargo de Salarios - HAYA', 'T. Embargo de Salarios - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H038'),
      T_TIPO_JUICIO('VBI', 'T. Valoración de bienes inmuebles - HAYA', 'T. Valoración de bienes inmuebles - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H058'),
      T_TIPO_JUICIO('VBM', 'T. Valoración de bienes muebles - HAYA', 'T. Valoración de bienes muebles - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H060'),
      T_TIPO_JUICIO('MEM', 'T. Mejora de embargo - HAYA', 'T. Mejora de embargo - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H046'),
      T_TIPO_JUICIO('PCM', 'P. Cambiario - HAYA', 'P. Cambiario - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H016'),
      T_TIPO_JUICIO('PDD', 'P. De depósito - HAYA', 'P. De depósito - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H034'),
      T_TIPO_JUICIO('PNJ', 'P. Ejecución título no judicial - HAYA', 'P. Ejecución título no judicial - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H020'),
      T_TIPO_JUICIO('PTJ', 'P. Ejecución título judicial - HAYA', 'P. Ejecución título judicial - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H018'),
      T_TIPO_JUICIO('PRE', 'P. De precinto - HAYA', 'P. De precinto - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H050'),
      T_TIPO_JUICIO('INJ', 'T. Investigación judicial - HAYA', 'T. Investigación judicial - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H044'),
      T_TIPO_JUICIO('CON', 'T. Consignación - HAYA', 'T. Consignación', 0, 'MOD_PROC', SYSDATE, 0, 'H064'),
      T_TIPO_JUICIO('TCE', 'T. de Costas contra Entidad - HAYA', 'T. de Costas contra Entidad - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H032'),
      T_TIPO_JUICIO('NOT', 'T. Notificación - HAYA', 'T. Notificación - HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'P400'),
      T_TIPO_JUICIO('VCA', 'T. Vigilancia y Caducidad Embargos - HAYA', 'T. Vigilancia y Caducidad Embargos -HAYA', 0, 'MOD_PROC', SYSDATE, 0, 'H062')	
     );   
    V_TMP_TIPO_JUICIO T_TIPO_JUICIO;

BEGIN	

      -- LOOP Insertando valores en DD_TJ_TIPO_JUICIO ------------------------------------------------------------------------
     
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO... Empezando a insertar datos en DD_TJ_TIPO_JUICIO');
    FOR I IN V_TIPO_JUICIO.FIRST .. V_TIPO_JUICIO.LAST
      LOOP
        V_TMP_TIPO_JUICIO := V_TIPO_JUICIO(I);
        V_SQL := 'SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||V_TMP_TIPO_JUICIO(8)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_TPROCE;
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO WHERE DD_TJ_CODIGO = '''||V_TMP_TIPO_JUICIO(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO... Ya existe el DD_TJ_CODIGO '''||V_TMP_TIPO_JUICIO(1)||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TJ_TIPO_JUICIO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TJ_TIPO_JUICIO (' ||
                      'DD_TJ_ID, DD_TJ_CODIGO, DD_TJ_DESCRIPCION, DD_TJ_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TPO_ID)' ||
                      'SELECT '|| V_ENTIDAD_ID || ', '''||V_TMP_TIPO_JUICIO(1)||''''||
					  ','''||V_TMP_TIPO_JUICIO(2)||''', '''||V_TMP_TIPO_JUICIO(3)||''''||
					  ','''||V_TMP_TIPO_JUICIO(4)||''', '''||V_TMP_TIPO_JUICIO(5)||''''||
					  ','''||V_TMP_TIPO_JUICIO(6)||''', '''||V_TMP_TIPO_JUICIO(7)||''''||
					  ','||V_TPROCE||' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_JUICIO(1)||''' - '''||V_TMP_TIPO_JUICIO(2)||''' ');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TJ_TIPO_JUICIO... Datos del tipo de juicio insertados.');
    
    
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