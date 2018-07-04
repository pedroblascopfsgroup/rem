--/*
--###########################################
--## AUTOR=Juanjo Arbona
--## FECHA_CREACION=20180704
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1187
--## PRODUCTO=NO
--## 
--## Finalidad: Re-asignar tramites
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(200 CHAR):= 'REMVIP-1187';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('107340' , 'T013_PosicionamientoYFirma')
       ,T_TIPO_DATA('107546' , 'T013_PosicionamientoYFirma')
       ,T_TIPO_DATA('105611' , 'T013_PosicionamientoYFirma')
        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        #ESQUEMA#.REPOSICIONAMIENTO_TRAMITE(V_USUARIO,TRIM(V_TMP_TIPO_DATA(1)),TRIM(V_TMP_TIPO_DATA(2)),null,null,PL_OUTPUT);
   	 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

    END LOOP;

    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
