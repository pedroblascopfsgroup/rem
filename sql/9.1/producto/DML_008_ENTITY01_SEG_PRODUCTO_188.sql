--/*
--##########################################
--## AUTOR=ALBERTO RAMÍREZ
--## FECHA_CREACION=20150824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-188
--## PRODUCTO=SI
--## Finalidad: Insertar los datos en la tabla 'REA_REGLA_AMBITO'
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    --Valores en DD_TVI_TIPO_VIA
    TYPE T_TIPO_TVI IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TVI IS TABLE OF T_TIPO_TVI;
    V_TIPO_TVI T_ARRAY_TVI := T_ARRAY_TVI(
      T_TIPO_TVI('POLITICA', 'PP'),
      T_TIPO_TVI('POLITICA', 'PG'),
      T_TIPO_TVI('POLITICA', 'PPGRA'),
	  T_TIPO_TVI('POLITICA', 'PSGRA'),
	  T_TIPO_TVI('GESTION_SINTESIS', 'PP'),
      T_TIPO_TVI('GESTION_SINTESIS', 'PG'),
      T_TIPO_TVI('GESTION_SINTESIS', 'PPGRA'),
	  T_TIPO_TVI('GESTION_SINTESIS', 'PSGRA'),
	  T_TIPO_TVI('SOLVENCIA', 'PP'),
      T_TIPO_TVI('SOLVENCIA', 'PG'),
      T_TIPO_TVI('SOLVENCIA', 'PPGRA'),
	  T_TIPO_TVI('SOLVENCIA', 'PSGRA'),
	  T_TIPO_TVI('ANTECEDENTES', 'PP'),
      T_TIPO_TVI('ANTECEDENTES', 'PG'),
      T_TIPO_TVI('ANTECEDENTES', 'PPGRA'),
	  T_TIPO_TVI('ANTECEDENTES', 'PSGRA'),
	  T_TIPO_TVI('DOCUMENTOS', 'CP'),
	  T_TIPO_TVI('DOCUMENTOS', 'CG'),
	  T_TIPO_TVI('DOCUMENTOS', 'CPGRA'),
	  T_TIPO_TVI('DOCUMENTOS', 'CSGRA'),
	  T_TIPO_TVI('GESTION_ANALISIS', 'EXP')
    ); 
    V_TMP_TIPO_TVI T_TIPO_TVI;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: Script de insercción de registros en REA_REGLA_AMBITO.');
    
    -- LOOP para insertar los valores en REA_REGLA_AMBITO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: LOOP de insercción en REA_REGLA_AMBITO.');
    FOR I IN V_TIPO_TVI.FIRST .. V_TIPO_TVI.LAST
      LOOP
      
        V_TMP_TIPO_TVI := V_TIPO_TVI(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.REA_REGLA_AMBITO REA 
				  JOIN '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION TRE ON TRE.DD_TRE_ID = REA.DD_TRE_ID 
				  JOIN '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE AEX ON AEX.DD_AEX_ID = REA.DD_AEX_ID
				  WHERE TRE.DD_TRE_CODIGO = '''||TRIM(V_TMP_TIPO_TVI(1))||''' 
				  AND AEX.DD_AEX_CODIGO ='''||TRIM(V_TMP_TIPO_TVI(2))||'''';
				  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe no hacemos nada
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: El registro '|| TRIM(V_TMP_TIPO_TVI(1)) ||'-'|| TRIM(V_TMP_TIPO_TVI(2))||' ya existe.');
          
       --Si no existe, lo insertamos   
       ELSE
		  
       	  V_MSQL := 'SELECT '|| V_ESQUEMA || '.S_REA_REGLA_AMBITO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.REA_REGLA_AMBITO 
					(REA_ID,DD_TRE_ID,DD_AEX_ID)
					VALUES 
                    ('||V_ID||'
					,(SELECT DD_TRE_ID FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO = '''||TRIM(V_TMP_TIPO_TVI(1))||''')
					,(SELECT DD_AEX_ID FROM '||V_ESQUEMA_M||'.DD_AEX_AMBITOS_EXPEDIENTE WHERE DD_AEX_CODIGO = '''||TRIM(V_TMP_TIPO_TVI(2))||'''))';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro '|| TRIM(V_TMP_TIPO_TVI(1)) ||'-'|| TRIM(V_TMP_TIPO_TVI(2))||' insertado correctamente.');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: Registros insertados correctamente.');
   

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