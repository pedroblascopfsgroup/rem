--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160408
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-2851
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos Relación GESTORES haya con supervisores, esquema HAYA02.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  
   TYPE T_SUP IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SUP IS TABLE OF T_SUP;
   
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
   TABLA1 VARCHAR(30) :='DD_GHS_GEST_HAYA_SUPERVISOR';   
   seq_count          NUMBER(13); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(13); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(13); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(13); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_MSQL1            VARCHAR2(8500 CHAR);   
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   
   V_SUP_ID           NUMBER(5);
   V_SUP_ID_DEFAULT   NUMBER(5);
   V_GRC_ID           NUMBER(5);   

   V_USUARIO_CREAR VARCHAR2(50) := 'MIGRAHAYA02';

--GESTORES
-- Configuracion GESTORES
V_SUP T_ARRAY_SUP := T_ARRAY_SUP(
                                  T_SUP('mvgonzalez','lcastano')
                                , T_SUP('msanchezal','lcastano')
                                , T_SUP('mselfa','lcastano')
                                , T_SUP('jdelaguila','lcastano')
                                , T_SUP('mescobar','lcastano')
                                , T_SUP('egarcia','lcastano')
                                , T_SUP('rjerez','lcastano')
                                , T_SUP('masensio','lcastano')
                                , T_SUP('mcorcoles','lcastano')
                                , T_SUP('varrocha','lcastano')
                                , T_SUP('ctuson','lcastano')
                                , T_SUP('jmonserrat','lcastano')
                                , T_SUP('lcastano','lcastano')
                                , T_SUP('rcalabuig','lcastano')
                                , T_SUP('fgalvez','megonzalez')
                                , T_SUP('mdomene','megonzalez')
                                , T_SUP('aruizf','megonzalez')
                                , T_SUP('mtamayo','megonzalez')
                                , T_SUP('gcarmona','megonzalez')
                                , T_SUP('emaldonado','megonzalez')
                                , T_SUP('inavarroe','megonzalez')
                                , T_SUP('epadilla','megonzalez')
                                , T_SUP('fgimenez','megonzalez')
                                , T_SUP('igarcia','megonzalez')
                                , T_SUP('rhernandez','megonzalez')
                                , T_SUP('mjimenez','megonzalez')
                                , T_SUP('aromera','megonzalez')
                                , T_SUP('megonzalez','megonzalez')
                                , T_SUP('jcallejon','megonzalez')
                                , T_SUP('sgonzalez','rmendez')
                                , T_SUP('acastro','rmendez')
                                , T_SUP('fluque','rmendez')
                                , T_SUP('sluque','rmendez')
                                , T_SUP('csalmeron','rmendez')
                                , T_SUP('rmendez','rmendez')
                                , T_SUP('jnavarro','rmendez')
                                , T_SUP('jdejuan','mgarciac')
                                , T_SUP('rhernaiz','mgarciac')
                                , T_SUP('aorti','mgarciac')
                                , T_SUP('mgarciac','mgarciac')
                                , T_SUP('mvalles','mgarciac')
                                , T_SUP('afernandeza','mpiqueras')
                                , T_SUP('mnavarroc','mpiqueras')
                                , T_SUP('mramirez','mpiqueras')
                                , T_SUP('rsaez','mpiqueras')
                                , T_SUP('stos','mpiqueras')
                                , T_SUP('mpiqueras','mpiqueras')
                                , T_SUP('mfons','mpiqueras')
                                , T_SUP('mgonzalezsu','mgonzalezsu')
                                , T_SUP('floira','mrodriguezm')
                                , T_SUP('sgongora','mrodriguezm')
                                , T_SUP('jroman','mrodriguezm')
                                , T_SUP('emunozc','mrodriguezm')
                                , T_SUP('asorianob','mrodriguezm')
                                , T_SUP('fcruz','mrodriguezm')
                                , T_SUP('mrodriguezm','mrodriguezm')
                                , T_SUP('cmoya','mrodriguezm')
                                , T_SUP('rcanovas','mgarciam')
                                , T_SUP('sreyes','mgarciam')
                                , T_SUP('contreras','mgarciam')
                                , T_SUP('mgarciam','mgarciam')
                                , T_SUP('lmontoya','mgarciam')
                                , T_SUP('tchiner','ivanacloig')
                                , T_SUP('jgarciaga','ivanacloig')
                                , T_SUP('jbarrachina','ivanacloig')
                                , T_SUP('jgimenez','ivanacloig')
                                , T_SUP('amoreno','ivanacloig')
                                , T_SUP('esanchezl','ivanacloig')
                                , T_SUP('eballesteros','ivanacloig')
                                , T_SUP('jbodega','ivanacloig')
                                , T_SUP('jespi','ivanacloig')
                                , T_SUP('pfernandez','ivanacloig')
                                , T_SUP('mgabarda','ivanacloig')
                                , T_SUP('mmestanza','ivanacloig')
                                , T_SUP('gcarmona','ivanacloig')
                                , T_SUP('grivero','ivanacloig')
                                , T_SUP('gacosta','ivanacloig')
                                , T_SUP('ivanacloig','ivanacloig')
                                , T_SUP('jasensio','ivanacloig')
                                , T_SUP('jrebollo','jcarlos')
                                , T_SUP('erodriguez','jcarlos')
                                , T_SUP('msalido','jcarlos')
                                , T_SUP('jcarlos','jcarlos')
                        );

                                   
                                   
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_SUP T_SUP;

   
BEGIN

  -- CREAMOS LA TABLA DE DD_GHS_GEST_HAYA_SUPERVISOR 
      V_EXIST:=0;
    
      SELECT COUNT(*) INTO V_EXIST
      FROM ALL_TABLES
      WHERE TABLE_NAME = ''||TABLA1||'';
    
    
      V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||' 
       (
            DD_GHS_HAYA_CODIGO          VARCHAR2(20 CHAR) NOT NULL ENABLE,
            DD_GHS_HAYA_SUP_CODIGO      VARCHAR2(20 CHAR),
            VERSION                     NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE,
            USUARIOCREAR                VARCHAR2(50 CHAR) NOT NULL ENABLE,
            FECHACREAR                  TIMESTAMP (6) NOT NULL ENABLE,
            USUARIOMODIFICAR            VARCHAR2(50 CHAR),
            FECHAMODIFICAR              TIMESTAMP (6),
            USUARIOBORRAR               VARCHAR2(50 CHAR),
            FECHABORRAR                 TIMESTAMP (6),
            BORRADO                     NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
       ) SEGMENT CREATION IMMEDIATE';
    
    IF V_EXIST = 0 THEN
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');
    ELSE
         EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA1||' CASCADE CONSTRAINTS ');
         DBMS_OUTPUT.PUT_LINE( TABLA1||' BORRADA');
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');
    END IF;
    


 -- Borramos la tabla DD_GHC_GEST_HAYA_CAJAMAR
     DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_GHS_GEST_HAYA_SUPERVISOR');
     EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.'||TABLA1||'');
                     
-- INSERTAMOS/UPDATEAMOS LOS VALORES EN LA TABLA DD_GHC_GEST_HAYA_CAJAMAR

   DBMS_OUTPUT.PUT_LINE('Actualizando DD_GHS_GEST_HAYA_SUPERVISOR con relación gestor supervisor haya');
   FOR I IN V_SUP.FIRST .. V_SUP.LAST
   LOOP

       V_TMP_SUP := V_SUP(I);


	   DBMS_OUTPUT.PUT_LINE('[INFO] Insertando - DD_GHC_GEST_HAYA_CAJAMAR ' ||  V_TMP_SUP(1));

         
           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA1||' (DD_GHS_HAYA_CODIGO, DD_GHS_HAYA_SUP_CODIGO, ' ||
                                                                           'VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                                   ' VALUES (
                                      '''||V_TMP_SUP(1)||'''
                                     ,'''||V_TMP_SUP(2)||'''
                                     ,0 
                                     ,'''||V_USUARIO_CREAR||'''
                                     ,SYSDATE
                                     , 0)';
                                
       EXECUTE IMMEDIATE V_MSQL;
  
END LOOP; 
    

   COMMIT;   

                     
              
                   


EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/

EXIT;

