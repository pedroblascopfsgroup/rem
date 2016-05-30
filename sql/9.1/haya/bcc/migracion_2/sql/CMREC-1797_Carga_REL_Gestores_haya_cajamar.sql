--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ
--## FECHA_CREACION=20160209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-451
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos Relación GESTORES haya cajamar definitivos, esquema HAYA02.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  
   TYPE T_LET IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_LET IS TABLE OF T_LET;
   
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
   seq_count          NUMBER(13); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(13); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(13); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(13); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   
   V_LET_ID           NUMBER(5);
   V_LET_ID_DEFAULT    NUMBER(5);
   V_GRC_ID           NUMBER(5);   

   V_USUARIO_CREAR VARCHAR2(10) := 'DD';

--GESTORES
-- Configuracion GESTORES
V_LET T_ARRAY_LET := T_ARRAY_LET(
              T_LET('IVP22085','ivanacloig')
            , T_LET('JRM3757','jrebollo')
            , T_LET('LRM55125','lramos')
            , T_LET('MGM4606','mvgonzalez')
            , T_LET('PFS22556','pfernandez')
            , T_LET('AMG21185','amoreno')
            , T_LET('FLT8370','fluque')
            , T_LET('JGG22236','jgimenez')
            , T_LET('JNL6653','jnavarro')
            , T_LET('LMR80279','lmontoya')
            , T_LET('MGP52028','mgabarda')
            , T_LET('OSP22740','osalazar')
            , T_LET('RCM80276','rcanovas')
            , T_LET('SSJ4546','ssalcedo')
            , T_LET('VRF22936','vrosello')
            , T_LET('AVE15878','avillare')
            , T_LET('CMI80307','cmoya')
            , T_LET('EBC40085','eballesteros')
            , T_LET('EMC555','emunozc')
            , T_LET('ERI4930','erodriguez')
            , T_LET('FGM1183','fgimenez')
            , T_LET('MGS55248','mgonzalezsu')
            , T_LET('MMM1932','mmoreno')
            , T_LET('OLL80192','ollorca')
            , T_LET('RSO40008','rsaez')
            , T_LET('AFA22292','afernandeza')
            , T_LET('ASM829','asorianob')
            , T_LET('CTF55432','ctrincado')
            , T_LET('FGM5496','fgalvez')
            , T_LET('FLV2084','floira')
            , T_LET('JCL3640','jcarlos')
            , T_LET('JDM21123','jdejuan')
            , T_LET('LRO55022','lrubio')
            , T_LET('MPL22856','mpiqueras')
            , T_LET('RMV2978','rmendez')
            , T_LET('TCG22290','tchiner')
            , T_LET('ATA80186','ateruel')
            , T_LET('EMR2049','emaldonado')
            , T_LET('ESL20875','esanchezl')
            , T_LET('JCM6658','jcallejon')
            , T_LET('JGG22433','jgarciaga')
            , T_LET('MGM4340','megonzalez')
            , T_LET('MTC2726','mtamayo')
            , T_LET('SLV8564','sluque')
            , T_LET('SRM80287','sreyes')
            , T_LET('ACN80265','acontreras')
            , T_LET('ACS5111','acastro')
            , T_LET('ARL80254','aromera')
            , T_LET('GAN55505','gacosta')
            , T_LET('GRS55135','grivero')
            , T_LET('ACS5111','acastro')
            , T_LET('ADD80188','adesco')
            , T_LET('AFA22292','afernandeza')
            , T_LET('AON23026','aorti')
            , T_LET('ARF7931','aruizf')
            , T_LET('ARL80254','aromera')
            , T_LET('ATA80186','ateruel')
            , T_LET('CSM2674','csalmeron')
         --   , T_LET('EJM15877','')
            , T_LET('EMR2049','emaldonado')
            , T_LET('FGM1183','fgimenez')
            , T_LET('FGM5496','fgalvez')
            , T_LET('FLT8370','fluque')
            , T_LET('GGM7015','ggarciam')
            , T_LET('JCM6658','jcallejon')
            , T_LET('JDM21123','jdejuan')
            , T_LET('JNL6653','jnavarro')
            , T_LET('MCF80184','mcarrascosa')
            , T_LET('MFH52018','mfons')
            , T_LET('MGM4606','mvgonzalez')
            , T_LET('MNC20462','mnavarroc')
            , T_LET('MRL80195','mriquelme')
            , T_LET('MRV4890','mramirez')
            , T_LET('MTC2726','mtamayo')
            , T_LET('MVA22312','mvalles')
            , T_LET('OLL80192','ollorca')
            , T_LET('OSP22740','osalazar')
            , T_LET('RHR40365','rhernaiz')
            , T_LET('RSO40008','rsaez')
            , T_LET('SGJ7961','sgonzalez')
            , T_LET('SLV8564','sluque')
            , T_LET('SSJ4546','ssalcedo')
            , T_LET('STC22246','stos')
);

                                   
                                   
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_LET T_LET;

   
BEGIN

 -- Borramos la tabla DD_GHC_GEST_HAYA_CAJAMAR
     DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_GHC_GEST_HAYA_CAJAMAR');
     EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR');
                     
-- INSERTAMOS/UPDATEAMOS LOS VALORES EN LA TABLA DD_GHC_GEST_HAYA_CAJAMAR

   DBMS_OUTPUT.PUT_LINE('Actualizando DD_GHC_GEST_HAYA_CAJAMAR con relación haya cajamar');
   FOR I IN V_LET.FIRST .. V_LET.LAST
   LOOP

       V_TMP_LET := V_LET(I);


	   DBMS_OUTPUT.PUT_LINE('[INFO] Insertando - DD_GHC_GEST_HAYA_CAJAMAR ' ||  V_TMP_LET(1));

         
           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR (DD_GHC_HAYA_CODIGO, DD_GHC_BCC_CODIGO, ' ||
                                                                           'VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                                   ' VALUES (
                                      '''||V_TMP_LET(1)||'''
                                     ,'''||V_TMP_LET(2)||'''
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

