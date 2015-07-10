--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Inserta permisos de nuevas funciones.
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
    V_FUNCION VARCHAR2(100 CHAR); -- Vble. auxiliar para obtener función.
    V_PERFIL VARCHAR2(100 CHAR); --Vble. auxiliar para obtener perfil.
    
    
    
    --Valores en FUN_PEF
    TYPE T_FUN_PEF IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FPEF IS TABLE OF T_FUN_PEF;
    V_FUN_PEF T_ARRAY_FPEF := T_ARRAY_FPEF(
      T_FUN_PEF('MANTENIMIENTO_CATEGORIAS', 'usuario administrador', 0, 'SUPER_PR',SYSDATE,NULL,NULL,NULL,NULL,0),
      T_FUN_PEF('MENU_PROCURADORES_GENERAL', 'Gestor Procurador', 0, 'SUPER_PR',SYSDATE,NULL,NULL,NULL,NULL,0),
	  T_FUN_PEF('MENU_PROCESADO_PROCURADORES', 'Gestor Procurador', 0, 'SUPER_PR',SYSDATE,NULL,NULL,NULL,NULL,0),
	  T_FUN_PEF('INITIAL_TAB_RESOL_PROC', 'Gestor Procurador', 0, 'SUPER_PR',SYSDATE,NULL,NULL,NULL,NULL,0),
	  T_FUN_PEF('RAMA_TAREAS_PENDIENTES_VALIDAR', 'Gestor Procurador', 0, 'SUPER_PR',SYSDATE,NULL,NULL,NULL,NULL,0)
    );   
    V_TMP_FUN_PEF T_FUN_PEF;

BEGIN	

      -- LOOP Insertando valores en FUN_PEF ------------------------------------------------------------------------
     
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Empezando a insertar datos en FUN_PEF');
    FOR I IN V_FUN_PEF.FIRST .. V_FUN_PEF.LAST
      LOOP
        V_TMP_FUN_PEF := V_FUN_PEF(I);
        V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUN_PEF(1)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_FUNCION;
        
        V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_DESCRIPCION = '''||V_TMP_FUN_PEF(2)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_PERFIL;
        
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = '''||V_FUNCION||''' AND PEF_ID = '''||V_PERFIL||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FUN_PEF... Ya existe el FUN_PEF '''||V_TMP_FUN_PEF(1)||''' - '''||V_TMP_FUN_PEF(2)||'''');
        ELSE
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_FUN_PEF.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.FUN_PEF (' ||
                      'FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)' ||
                      'SELECT '||V_FUNCION||', '||V_PERFIL||', '|| V_ENTIDAD_ID || ', '''||V_TMP_FUN_PEF(3)||''''||
					  ','''||V_TMP_FUN_PEF(4)||''', '''||V_TMP_FUN_PEF(5)||''''||
					  ','''||V_TMP_FUN_PEF(6)||''', '''||V_TMP_FUN_PEF(7)||''''||
					  ','''||V_TMP_FUN_PEF(8)||''', '''||V_TMP_FUN_PEF(9)||''''||
					  ','''||V_TMP_FUN_PEF(10)||''' FROM DUAL';
              DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUN_PEF(1)||''' - '''||V_TMP_FUN_PEF(2)||''' ');
          EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_PEF... Datos de los permisos insertados');
    
    
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