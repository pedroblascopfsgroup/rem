--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Guillermo Marín
--## Finalidad: DML para insertar registros en TGP_TIPO_GESTOR_PROPIEDAD
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  V_ENTIDAD_ID NUMBER(16);
  --Insertando valores en TGP_TIPO_GESTOR_PROPIEDAD
  TYPE T_TIPO_TGP IS TABLE OF VARCHAR2(2048);
  TYPE T_ARRAY_TGP IS TABLE OF T_TIPO_TGP;
  V_TIPO_TGP T_ARRAY_TGP := T_ARRAY_TGP(
    T_TIPO_TGP('(select DD_TGE_ID from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''GGLL'')', 'DES_VALIDOS', '(select dd_tde_codigo from '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO where dd_tde_codigo=''GDLL'')', '0', 'SAG', sysdate, null, null, null, null, '0'),
    T_TIPO_TGP('(select DD_TGE_ID from '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO=''GGDLL'')', 'DES_VALIDOS', '(select dd_tde_codigo from '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO where dd_tde_codigo=''GDLL'')', '0', 'SAG', sysdate, null, null, null, null, '0')
  ); 
  V_TMP_TIPO_TGP T_TIPO_TGP;   
  
  
BEGIN
 --  LOOP Insertando valores en TGP_TIPO_GESTOR_PROPIEDAD
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD... Empezando a insertar datos en el diccionario');
    FOR I IN V_TIPO_TGP.FIRST .. V_TIPO_TGP.LAST
      LOOP
        V_TMP_TIPO_TGP := V_TIPO_TGP(I);
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD WHERE DD_TGE_ID = '||TRIM(V_TMP_TIPO_TGP(1)) || ' AND TGP_CLAVE=''' ||TRIM(V_TMP_TIPO_TGP(2)) || '''';
      -- DBMS_OUTPUT.PUT_LINE(V_SQL);
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TGP_TIPO_GESTOR_PROPIEDAD... Ya existe el tipo gestor '''|| TRIM(V_TMP_TIPO_TGP(1)) ||''' y la clave ''' || TRIM(V_TMP_TIPO_TGP(2)) ||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.s_tgp_tipo_gestor_propiedad.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TGP_TIPO_GESTOR_PROPIEDAD (
                      TGP_ID, DD_TGE_ID, TGP_CLAVE, TGP_VALOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) ' ||
                      'SELECT '''|| V_ENTIDAD_ID || ''', '||V_TMP_TIPO_TGP(1)||' ,'''||TRIM(V_TMP_TIPO_TGP(2))||''','||TRIM(V_TMP_TIPO_TGP(3))||','''||TRIM(V_TMP_TIPO_TGP(4))||''','||
                        ''''||TRIM(V_TMP_TIPO_TGP(5)) || ''','''||V_TMP_TIPO_TGP(6)||''','''||V_TMP_TIPO_TGP(7)||''','''||V_TMP_TIPO_TGP(8)||''','''||V_TMP_TIPO_TGP(9)||''','||
                        ''''||V_TMP_TIPO_TGP(10)||''','''||TRIM(V_TMP_TIPO_TGP(11)) ||
                        ''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TGP(1)||''','''||TRIM(V_TMP_TIPO_TGP(2)));
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD... Datos del diccionario insertado');

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