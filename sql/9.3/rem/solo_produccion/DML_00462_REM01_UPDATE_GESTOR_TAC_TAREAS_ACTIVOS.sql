--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200923
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8114
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar gestor tramite informe comercial
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8114'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='TAC_TAREAS_ACTIVOS'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_USUARIO VARCHAR2(100 CHAR) :='USU_USUARIOS';

    V_USERNAME VARCHAR2(100 CHAR) :='arevillo'; --Vble. auxiliar para almacenar el nombre de usuario a actualizar
    V_TPO_CODIGO VARCHAR2(100 CHAR) :='T011'; --Vble para almacenar el tipo de procedimiento
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    V_ENT_ID NUMBER(16); --Vble.Para almacenar el id del usuario a modificar
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- Numero Activo
        T_TIPO_DATA('138200'),
        T_TIPO_DATA('138827'),
        T_TIPO_DATA('143077'),
        T_TIPO_DATA('150266'),
        T_TIPO_DATA('150653'),
        T_TIPO_DATA('150654'),
        T_TIPO_DATA('160328'),
        T_TIPO_DATA('160362'),
        T_TIPO_DATA('161066'),
        T_TIPO_DATA('102037'),
        T_TIPO_DATA('102038'),
        T_TIPO_DATA('102039'),
        T_TIPO_DATA('102040'),
        T_TIPO_DATA('102041'),
        T_TIPO_DATA('102042'),
        T_TIPO_DATA('102043'),
        T_TIPO_DATA('102060'),
        T_TIPO_DATA('102061'),
        T_TIPO_DATA('102062'),
        T_TIPO_DATA('102484'),
        T_TIPO_DATA('102485'),
        T_TIPO_DATA('102486'),
        T_TIPO_DATA('102487'),
        T_TIPO_DATA('102488'),
        T_TIPO_DATA('109685'),
        T_TIPO_DATA('109686'),
        T_TIPO_DATA('109687'),
        T_TIPO_DATA('109688'),
        T_TIPO_DATA('109689'),
        T_TIPO_DATA('109764'),
        T_TIPO_DATA('109765'),
        T_TIPO_DATA('109766'),
        T_TIPO_DATA('109817'),
        T_TIPO_DATA('109818'),
        T_TIPO_DATA('109819'),
        T_TIPO_DATA('109976'),
        T_TIPO_DATA('109977'),
        T_TIPO_DATA('109978'),
        T_TIPO_DATA('109979'),
        T_TIPO_DATA('109980'),
        T_TIPO_DATA('109981'),
        T_TIPO_DATA('109982'),
        T_TIPO_DATA('109983'),
        T_TIPO_DATA('109984'),
        T_TIPO_DATA('109985'),
        T_TIPO_DATA('143948')       

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN TAC_TAREAS_ACTIVOS ');

    V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIO||' WHERE USU_USERNAME='''||V_USERNAME||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN

        V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIO||' WHERE USU_USERNAME='''||V_USERNAME||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_ENT_ID;
            
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' TAC
                        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID=TAC.TRA_ID
                        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=TRA.DD_TPO_ID
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TRA.ACT_ID
                        WHERE ACT.ACT_NUM_ACTIVO='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AND TPO.DD_TPO_CODIGO='''||V_TPO_CODIGO||''' ';

            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos activo: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');

              V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
				USING (
				    SELECT TAC.TAR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' TAC
                        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID=TAC.TRA_ID
                        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID=TRA.DD_TPO_ID
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TRA.ACT_ID
                        WHERE ACT.ACT_NUM_ACTIVO='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AND TPO.DD_TPO_CODIGO='''||V_TPO_CODIGO||'''				    
				) T2
				ON (T1.TAR_ID = T2.TAR_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.USU_ID = '||V_ENT_ID||'
				,USUARIOMODIFICAR = '''||V_USUARIO||'''
				,FECHAMODIFICAR = SYSDATE';
                        
                EXECUTE IMMEDIATE V_SQL;
               DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizados: '|| SQL%ROWCOUNT ||' registros ');
                V_COUNT:=V_COUNT+1;

            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE TRAMITE DE APROBACION DE INFORME COMERCIAL PARA EL ACTIVO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            END IF;

                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE:= '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');

                
            
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO CON EL USERNAME INDICADO: '||V_USERNAME||' ');
    END IF;    
    
        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');

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