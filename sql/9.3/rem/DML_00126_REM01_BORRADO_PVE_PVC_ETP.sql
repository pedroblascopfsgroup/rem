--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9607
--## PRODUCTO=NO
--##
--## Finalidad: Script que hace un borrado lógico de los proveedores añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9607';
    
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- Borrado lógico de los valores en ACT_PVE_PROVEEDOR registrados con el USUARIOCREAR 'HREOS-9607'-----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN ACT_PVE_PROVEEDOR,  ACT_PVC_PROVEEDOR_CONTACTO Y ACT_ETP_ENTIDAD_PROVEEDOR');
    
    
        --Comprobamos el dato a borrar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.USUARIOCREAR = '''||TRIM(V_ITEM)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --si existe lo borramos
        IF V_NUM_TABLAS > 0 THEN				
                       
          --borrado lógico en ACT_PVE_PROVEEDOR
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            SET PVE.USUARIOBORRAR = '''||TRIM(V_ITEM)||'''
            ,PVE.FECHABORRAR = SYSDATE 
            ,PVE.BORRADO = ''1''
            WHERE PVE.USUARIOCREAR = '''||TRIM(V_ITEM)||'''            
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS BORRADOS EN LA TABLA ACT_PVE_PROVEEDOR');         

          --borrado lógico en ACT_PVC_PROVEEDOR_CONTACTO
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC 
            SET PVC.USUARIOBORRAR = '''||TRIM(V_ITEM)||'''
            ,PVC.FECHABORRAR = SYSDATE 
            ,PVC.BORRADO = ''1''
             WHERE PVC.USUARIOCREAR = '''||TRIM(V_ITEM)||'''           
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS BORRADOS EN LA TABLA ACT_PVC_PROVEEDOR_CONTACTO');  

          --borrado lógico en ACT_ETP_ENTIDAD_PROVEEDOR
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR ETP 
            SET ETP.USUARIOBORRAR = '''||TRIM(V_ITEM)||'''
            ,ETP.FECHABORRAR = SYSDATE 
            ,ETP.BORRADO = ''1''
            WHERE ETP.USUARIOCREAR = '''||TRIM(V_ITEM)||'''           
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS BORRADOS EN LA TABLA ACT_ETP_ENTIDAD_PROVEEDOR'); 
                  
       END IF;
     
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: BORRADO MODIFICADO CORRECTAMENTE EN LAS TABLAS ACT_PVE_PROVEEDOR, ACT_PVC_PROVEEDOR_CONTACTO Y ACT_ETP_ENTIDAD_PROVEEDOR');
   

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
