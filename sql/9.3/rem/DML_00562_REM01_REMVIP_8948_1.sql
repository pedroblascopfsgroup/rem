--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20210214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8948
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##
--##########################################-
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
	
    V_TABLA VARCHAR2(50 CHAR):= 'DD_TDO_TIPO_DOC_ENTIDAD';
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-8948';
    V_CODIGO VARCHAR2(25 CHAR):= '0863';
    V_DESCRIPCION VARCHAR2(30 CHAR):= 'Documentación anexa pedido';
    V_MATRICULA VARCHAR2(25 CHAR):= 'AI-03-ESIN-CA';
   
BEGIN

    	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobamos Dato '''|| V_MATRICULA ||'''');
      --Comprobamos el dato a insertar
      V_SQL :=   'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.DD_TDO_TIPO_DOC_ENTIDAD WHERE DD_TDO_CODIGO = '''|| V_CODIGO ||''' AND DD_TDO_DESCRIPCION = '''|| V_DESCRIPCION ||'''
					AND DD_TDO_MATRICULA = '''|| V_MATRICULA ||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
      
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| V_MATRICULA ||''' Insertado ANTERIORMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS');   
        
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (DD_TDO_ID,DD_TED_ID,DD_TDO_CODIGO,DD_TDO_DESCRIPCION,DD_TDO_DESCRIPCION_LARGA,
					DD_TDO_MATRICULA,USUARIOCREAR,FECHACREAR,BORRADO)
            SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL,
            1,
            '''|| V_CODIGO ||''',
			'''|| V_DESCRIPCION ||''',
			'''|| V_DESCRIPCION ||''',
			'''|| V_MATRICULA ||''',
            ''REMVIP-8948'',
            SYSDATE,
            0
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
      
      END IF;

  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
