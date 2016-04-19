--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.3
--## INCIDENCIA_LINK=PRODUCTO-1212
--## PRODUCTO=SI
--##
--## Finalidad: Inserta TOB_TIPO_OBJETIVO 
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
    V_MSQL VARCHAR2(8000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_TOB_COUNT VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TPA COUNT.
    V_TOB_COUNT VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TPA
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_CDO_ID NUMBER(16); -- Vble. para el id de CDO_CAMPO_DESTINO_OBJETIVO.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_SQL_CDO_COUNT VARCHAR2(4000 CHAR);
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    --Valores en TOB_TIPO_OBJETIVO 
    TYPE T_TOB IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_STA IS TABLE OF T_TOB;
    V_TOB T_ARRAY_STA := T_ARRAY_STA(
      T_TOB( 'TOB01','Objetivo manual',null,'0','0',null ),
      T_TOB( 'TOB02','Riesgo Directo de persona',null,'1','0','RDP' ),
      T_TOB( 'TOB03','Riesgo Indirecto de persona',null,'1','0','RIP' ),
      T_TOB( 'TOB04','Riesgo Irregular de persona',null,'1','0','RIrrP' ),
      T_TOB( 'TOB05','Riesgo Garantizado de persona',null,'1','0','RGP' ),
      T_TOB( 'TOB06','Riesgo no Garantizado de persona',null,'1','0','RNGP' ),
      T_TOB( 'TOB07','Porcentaje Riesgo no Garantizado - RD de persona',null,'1','0','RNG/RD' ),
      T_TOB( 'TOB08','Porcentaje Riesgo Irregular - RD de persona',null,'1','0','RIrr/RD' ),
      T_TOB( 'TOB09','Riesgo de contrato',null,'1','1','RC' ),
      T_TOB( 'TOB10','Riesgo Irregular de contrato',null,'1','1','RIrrC' ),
      T_TOB( 'TOB11','Riesgo Garantizado de contrato',null,'1','1','RGC' ),
      T_TOB( 'TOB12','Riesgo no Garantizado de contrato',null,'1','1','RNGC' ),
      T_TOB( 'TOB13','Límite descubierto de contrato',null,'1','1','LDC' ),
      T_TOB( 'TOB14','Dispuesto de contrato',null,'1','1','DC' )
    );   
    V_TMP_TOB T_TOB;
    
    
BEGIN	

      -- LOOP Insertando valores en TOB_TIPO_OBJETIVO  ------------------------------------------------------------------------

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TOB_TIPO_OBJETIVO ... Empezando a insertar datos en TOB_TIPO_OBJETIVO ');
    FOR I IN V_TOB.FIRST .. V_TOB.LAST
      LOOP
            V_TMP_TOB := V_TOB(I);
            
            V_SQL_TOB_COUNT := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.TOB_TIPO_OBJETIVO WHERE TOB_CODIGO = '''||V_TMP_TOB(1)||'''';
			EXECUTE IMMEDIATE V_SQL_TOB_COUNT INTO V_TOB_COUNT;
            
            IF (V_TOB_COUNT < 1)  THEN		
              
            		  V_CDO_ID := null;
            		  
            		  IF(V_TMP_TOB(6) is not null) THEN
            		 		
	            		  	V_SQL_CDO_COUNT := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CDO_CAMPO_DESTINO_OBJETIVO WHERE CDO_CODIGO = '''||V_TMP_TOB(6)||'''';
							EXECUTE IMMEDIATE V_SQL_CDO_COUNT INTO V_NUM_TABLAS;
							
							IF(V_NUM_TABLAS > 0) THEN
							    V_MSQL := 'SELECT CDO_ID FROM '|| V_ESQUEMA ||'.CDO_CAMPO_DESTINO_OBJETIVO WHERE CDO_CODIGO = '''||V_TMP_TOB(6)||'''';
	            				EXECUTE IMMEDIATE V_MSQL INTO V_CDO_ID;
							END IF;
		  	
            		  END IF;
            		   DBMS_OUTPUT.PUT_LINE('CDO_ID: '''||V_CDO_ID||'''');
			        
			          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_TOB_TIPO_OBJETIVO .NEXTVAL FROM DUAL';
			          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TOB_TIPO_OBJETIVO  (' ||
			                      'TOB_ID,TOB_CODIGO,TOB_DESCRIPCION,TOB_DESCRIPCION_LARGA,TOB_AUTOMATICO,TOB_CONTRATO,CDO_ID,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO)' ||
			                      'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_TOB(1)||''''||
									','''||V_TMP_TOB(2)||''','''||V_TMP_TOB(3)||''','''||V_TMP_TOB(4)||''''||
									','''||V_TMP_TOB(5)||''','''||V_CDO_ID||''',''0'',''DD'',sysdate,null,null,null,null,''0'' FROM DUAL';
			             
					  DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TOB(1)||'''');
			          EXECUTE IMMEDIATE V_MSQL;
			        
       		ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TOB_TIPO_OBJETIVO ... No existe el DD_TPO_CODIGO = '''|| V_TMP_TOB(2) ||'''');
       		END IF;
            
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.TOB_TIPO_OBJETIVO... Datos insertados.');
    
    
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