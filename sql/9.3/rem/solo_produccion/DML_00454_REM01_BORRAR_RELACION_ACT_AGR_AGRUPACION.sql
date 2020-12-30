--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200916
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8079
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar titulo de activos
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8079'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_AGA_AGRUPACION_ACTIVO'; --Vble. auxiliar para almacenar la tabla a actualizar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a buscar el activo
    V_TABLA_AGRUPACION VARCHAR2(100 CHAR):='ACT_AGR_AGRUPACION'; --Vble. auxiliar para almacenar la tabla a buscar agrupacion

    V_NUM_AGRUPACION VARCHAR2(100 CHAR):='6628655'; --Num agrupacion a buscar
    V_NUM_ACTIVO VARCHAR2(100 CHAR):='6035821'; --Num activo a buscar
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN ACT_AGA_AGRUPACION ');
        
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE LA AGRUPACION '''||V_NUM_AGRUPACION||''' ');

        --Comprobamos si existe el activo
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AGRUPACION||' WHERE AGR_NUM_AGRUP_REM = '''||V_NUM_AGRUPACION||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE EL ACTIVO '''||V_NUM_ACTIVO||''' ');

         V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '''||V_NUM_ACTIVO||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
        
        --Existe agrupacion
        IF V_NUM_TABLAS > 0 THEN
          --Existe activo
          IF V_NUM_TABLAS_2 > 0 THEN                

                DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBAMOS QUE EXISTE LA RELACION EN ACT_AGA_AGRUPACION_ACTIVO ');

                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                WHERE AGR_ID = (SELECT AGR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AGRUPACION||' WHERE AGR_NUM_AGRUP_REM='''||V_NUM_AGRUPACION||''') 
                AND ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='''||V_NUM_ACTIVO||''')';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                --Existe relacion
                IF V_NUM_TABLAS > 0 THEN

                    DBMS_OUTPUT.PUT_LINE('[INFO]: REALIZAMOS EL UPDATE ');
                    
                    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET                        
                            USUARIOBORRAR = '''||V_USUARIO||''', 
                            FECHABORRAR = SYSDATE,
                            BORRADO=1
                            WHERE AGR_ID=(SELECT AGR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AGRUPACION||' WHERE AGR_NUM_AGRUP_REM='''||V_NUM_AGRUPACION||''') 
                            AND ACT_ID=(SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO='''||V_NUM_ACTIVO||''')';

                    EXECUTE IMMEDIATE V_SQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');           
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE LA RELACION ENTRE EL ACTIVO Y LA AGRUPACION');
                END IF;               

            ELSE
            --Si no existe el codigo del diccionario no se hace nada
                 DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN ACTIVOS CON EL NUMERO DE ACTIVO INDICADO '''||V_NUM_ACTIVO||''' ');
            END IF;            

            --Si no existe no se hace nada
          ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN AGRUPACIONES CON EL NUMERO DE AGRUPACION INDICADO '''||V_NUM_AGRUPACION||''' ');
          END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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