--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10695
--## PRODUCTO=SI
--##
--## Finalidad: Script que actualiza borra el valor del campo OFR_ID_ANT de la tabla ACT_OFG_OFERTA_GENCAT
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-10695';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_CMG_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    			  -- DES_DESPACHO -------------- DD_TDE_CODIGO	
		T_TIPO_DATA('90334634'),
		T_TIPO_DATA('90335110'),
		T_TIPO_DATA('90352119')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	 
    -- LOOP para modificar los valores en DES_DESPACHO_EXTERNO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO LOOP -> UPDATE EN ACT_OFG_OFERTA_GENCAT ] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
        V_CMG_ID := 0;
        
        --Comprobamos el dato a modificar
        V_SQL := 'SELECT CMG.CMG_ID
					FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
					INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR ON ACTOFR.OFR_ID = OFR.OFR_ID
					INNER JOIN '||V_ESQUEMA||'.act_cmg_comunicacion_gencat CMG ON CMG.ACT_ID = ACTOFR.ACT_ID
					INNER JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
					WHERE OFR.OFR_NUM_OFERTA = '||TRIM(V_TMP_TIPO_DATA(1));
        EXECUTE IMMEDIATE V_SQL INTO V_CMG_ID;
        -- ------------------------------------------------------------------------------------
        --Si existe el DESPACHO.
        IF V_CMG_ID > 0 THEN	

        --Comprobamos el dato a INSERTAR
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT WHERE BORRADO = 0 AND CMG_ID = '||V_CMG_ID;
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        -- ------------------------------------------------------------------------------------
        --Si existe el TIPO DE DESPACHO.
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: ELIMINAMOS EL VALOR OFR_ID_ANT DE LA OFERTA '||TRIM(V_TMP_TIPO_DATA(1)));
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_OFG_OFERTA_GENCAT
                        SET OFR_ID_ANT = NULL, USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE 
                        WHERE CMG_ID = '||V_CMG_ID;
          EXECUTE IMMEDIATE V_MSQL;          
       --Si no existe, NO HACEMOS NADA
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
        
       END IF;
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
        
       END IF;
       -- ------------------------------------------------------------------------------------
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: LOOP ');
   

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
