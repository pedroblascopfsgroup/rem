--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20160517
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HR-2549
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar
--## INSTRUCCIONES:  
--## VERSIONES:
--##            0.1 Versión inicial
--##########################################
--*/
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  cursor c1 is
    select usd_id, usu_id ,des_id from(
      select usd_id, usu_id ,des_id,ROW_NUMBER()
         OVER (PARTITION BY usu_id ,des_id ORDER BY fechacrear DESC, USD_ID DESC) AS rownumber
      from HAYA02.USD_USUARIOS_DESPACHOS where borrado=0
      )
      where rownumber > 1 ;  
  
  nUSD_iD HAYA02.USD_USUARIOS_DESPACHOS.USD_iD%type;

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] HR-2549');
  
   UPDATE haya02.USD_USUARIOS_DESPACHOS
          SET BORRADO = 0,
                 usuarioborrar=NULL,
                 fechaborrar= NULL
   WHERE usuarioborrar='HR-2549';

   UPDATE HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO
          SET BORRADO = 0,
                 usuarioborrar=NULL,
                 fechaborrar= NULL
   WHERE usuarioborrar='HR-2549';
   
   UPDATE haya02.gaa_gestor_adicional_asunto
          SET BORRADO = 0,
                 usuarioborrar=NULL,
                 fechaborrar= NULL
   WHERE usuarioborrar='HR-2549';
   
   for r in c1 loop
   
    select usd_id
       into nUSD_iD 
     from(
      select usd_id ,usu_id,ROW_NUMBER()
         OVER (PARTITION BY usu_id ,des_id ORDER BY fechacrear DESC, USD_ID DESC) AS rownumber
      from HAYA02.USD_USUARIOS_DESPACHOS where borrado=0 and usu_id= r.usu_id and des_id=r.des_id
      )
      where rownumber = 1 ;     
  
     update HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa
           set gaa.USD_ID = nUSD_iD
      where gaa.usd_id =  r.usd_id
          and gaa.borrado=0;
  
     update HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah
           set gah.gah_gestor_id = nUSD_iD
      where gah.gah_gestor_id =  r.usd_id
         and borrado=0; 
  
     update HAYA02.USD_USUARIOS_DESPACHOS usd
           set usd.BORRADO = 1,
                 usd.usuarioborrar='HR-2549',
                 usd.fechaborrar= sysdate
      where usd.usu_id = r.usu_id
          and usd.des_id = r.des_id
          and borrado=0;
         
      DBMS_OUTPUT.PUT_LINE('Usuario con usu_id= '||r.usu_id||' y des_id='||r.des_id||' actualizado a BORRADO = 1');
   end loop;
  
  MERGE INTO HAYA02.gaa_gestor_adicional_asunto gaa USING
    (   select distinct gaa_id from 
                                        (select  gaa_id,ROW_NUMBER()
                                           OVER (PARTITION BY asu_id, /*usd_id,*/dd_tge_id ORDER BY fechacrear DESC, USD_ID DESC) AS rownumber
                                        from haya02.gaa_gestor_adicional_asunto
                                        where borrado=0 ) aux
                                        where rownumber > 1 ) aux
      ON (gaa.gaa_id =  aux.gaa_id)
      WHEN MATCHED THEN
        UPDATE SET
          gaa.borrado = 1,
          gaa.usuarioborrar='HR-2549',
          gaa.fechaborrar= sysdate;
          
          
  MERGE INTO HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah USING
    (   select distinct gah_id from   
                                      (select  gah_id, ROW_NUMBER()
                                         OVER (PARTITION BY gah_asu_id,/*gah_gestor_id,*/ gah_tipo_gestor_id ORDER BY fechacrear DESC, GAH_GESTOR_ID DESC) AS rownumber
                                      from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah
                                      where borrado=0 )
                                      where rownumber > 1 ) aux
      ON (gah.gah_id =  aux.gah_id)
      WHEN MATCHED THEN
        UPDATE SET
          gah.borrado = 1,
          gah.usuarioborrar='HR-2549',
          gah.fechaborrar= sysdate;          
    
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] HR-2549');        
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
