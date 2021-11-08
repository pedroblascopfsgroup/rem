--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14762
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEB_ESTADO_EXPEDIENTE_BC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14762';    
	V_ALIAS VARCHAR2(50 CHAR) := 'EEB';    

	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('001', '10', 'Pdte. Aprobación BC'),
		T_TIPO_DATA('002', '20', 'Oferta Cancelada'),
		T_TIPO_DATA('003', '30', 'Oferta Aprobada'),
		T_TIPO_DATA('013', '40', 'Arras Prorrogadas'),
		T_TIPO_DATA('014', '50', 'Ingreso de Arras'),
		T_TIPO_DATA('015', '60', 'Validación de firma de Arras por BC'),
		T_TIPO_DATA('016', '80', 'Firma de Arras Agendadas'),
		T_TIPO_DATA('017', '90', 'Arras Firmadas'),
		T_TIPO_DATA('004', '220', 'Contraoferta aceptada'),
		T_TIPO_DATA('005', '260', 'Scoring a revisar por BC'),
		T_TIPO_DATA('006', '270', 'Valorar acuerdo sin garantías adicionales'),
		T_TIPO_DATA('007', '170', 'Oferta Pdte. Scoring'),
		T_TIPO_DATA('008', '280', 'Bloqueada por Screening BC'),
		T_TIPO_DATA('009', '180', 'Arras Pendientes de Aprobación BC'),
		T_TIPO_DATA('010', '190', 'Arras– Documentación aportada a BC'),
		T_TIPO_DATA('011', '200', 'Ingreso final Pdte. BC'),
		T_TIPO_DATA('012', '210', 'Ingreso final – Documentación aportada a BC'),
		T_TIPO_DATA('018', '100', 'Validación de firma de Contrato por BC'),
		T_TIPO_DATA('019', '120', 'Firma de Contrato Agendado'),
		T_TIPO_DATA('020', '130', 'Contrato Firmado'),
		T_TIPO_DATA('021', '140', 'Venta Formalizada'),
		T_TIPO_DATA('022', '150', 'Compromiso Cancelado'),
		T_TIPO_DATA('023', '290', 'Solicitar devolución de reserva y/o arras a BC'),
		T_TIPO_DATA('024', '300', 'Arras pte. Documentación'),
		T_TIPO_DATA('025', '310', 'Arras aprobadas'),
		T_TIPO_DATA('026', '320', 'Importe Final Pdte. Documentación'),
		T_TIPO_DATA('027', '330', 'Importe final aprobado'),
		T_TIPO_DATA('028', '230', 'Pte. garantías adicionales'),
		T_TIPO_DATA('029', '340', 'Scoring aprobado'),
		T_TIPO_DATA('030', '360', 'Contraofertado'),
		T_TIPO_DATA('031', '250', 'Pte. sanción patrimonio'),
		T_TIPO_DATA('032', '350', 'Pte. Cálculo riesgo'),
		T_TIPO_DATA('033', '160', 'Solicitud Modificación y Valoración'),
		T_TIPO_DATA('036', '330', 'Firma aprobada'),
		T_TIPO_DATA('037', '5', 'En trámite')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR DATOS EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_'||V_ALIAS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 1 THEN
       	-- Si existe se actualiza.
        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                    SET DD_'||V_ALIAS||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||'''		    
		     		 ,USUARIOMODIFICAR = '''||V_USUARIO||'''
				     ,FECHAMODIFICAR = SYSDATE
                    WHERE DD_'||V_ALIAS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha modificado el registro con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
	   ELSE
	   		-- Si no existe, lo insertamos
   			V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
        	EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (' ||
	                      'DD_'||V_ALIAS||'_ID, DD_'||V_ALIAS||'_CODIGO, DD_'||V_ALIAS||'_CODIGO_C4C, DD_'||V_ALIAS||'_DESCRIPCION, DD_'||V_ALIAS||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||V_TMP_TIPO_DATA(2)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||
	                      ' 0, '''||V_USUARIO||''',SYSDATE,0 FROM DUAL';
	        
          	EXECUTE IMMEDIATE V_MSQL;
          	DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el registro con codigo '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
