--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc01
--## INCIDENCIA_LINK=HR-940
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
    V_ENTIDAD_ID NUMBER(16);
    V_USUARIO_ID NUMBER(16);
    
    --Valores a insertar
    TYPE T_TIPO_TFA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TFA IS TABLE OF T_TIPO_TFA;
    V_TIPO_TFA T_ARRAY_TFA := T_ARRAY_TFA(  
      T_TIPO_TFA('SUPASU','DESPACHO SUPERVISOR ASUNTO','C/','VALENCIA','46000','APELLIDOS, NOMBRE','62661451620','62661451620','12501','DSUPASU')
    ); 
    V_TMP_TIPO_TFA T_TIPO_TFA;

BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando con DES_DESPACHO_EXTERNO');  
	-- LOOP Insertando valores en dd_tfa_fichero_adjunto
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.des_despacho_externo... Empezando a crear despachos...');
    
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST
      LOOP              
            V_TMP_TIPO_TFA := V_TIPO_TFA(I);          		                   			
        		
		-- Creamos el despacho externo si no existe
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO='''||V_TMP_TIPO_TFA(2)||''' ';
    	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    	--Si no existe el despacho lo damos de alta
		IF V_NUM_TABLAS < 1 THEN
			V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DES_DESPACHO_EXTERNO.NEXTVAL FROM DUAL';        
			EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO (' ||
					'DES_ID,'|| 
					'DES_DESPACHO, '||
					'DES_TIPO_VIA, '||
					'DES_DOMICILIO_PLAZA,'|| 
					'DES_CODIGO_POSTAL, '||
					'DES_PERSONA_CONTACTO, '||
					'DES_TELEFONO1,'||
					'DES_TELEFONO2, '||
					'DES_CODIGO, '||
					'VERSION, '||
					'USUARIOCREAR, '||
					'FECHACREAR, '||
					'BORRADO, '||
					'ZON_ID,'||
					'DD_TDE_ID'||
				') VALUES ('||
					V_ENTIDAD_ID||','||
					''''||V_TMP_TIPO_TFA(2)||''''||','||
					''''||V_TMP_TIPO_TFA(3)||''''||','||
					''''||V_TMP_TIPO_TFA(4)||''''||','||
					''''||V_TMP_TIPO_TFA(5)||''''||','||
					''''||V_TMP_TIPO_TFA(6)||''''||','||
					''''||V_TMP_TIPO_TFA(7)||''''||','||
					''''||V_TMP_TIPO_TFA(8)||''''||','||
					''''||V_TMP_TIPO_TFA(10)||''''||','||
					'0,'||
					'''SAG'','||
					'sysdate,'||
					'0,'||
					''''||V_TMP_TIPO_TFA(9)||''''||','||
					'(SELECT DD_TDE_ID FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO='''||V_TMP_TIPO_TFA(1)||''') ' ||
				')';
          		
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
          		
				EXECUTE IMMEDIATE V_MSQL;						
				
				DBMS_OUTPUT.PUT_LINE('Creado el despacho de tipo '||V_TMP_TIPO_TFA(1)||' correctamente.');	
			END IF;
			
		END LOOP;	
   
    COMMIT;

EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
  	