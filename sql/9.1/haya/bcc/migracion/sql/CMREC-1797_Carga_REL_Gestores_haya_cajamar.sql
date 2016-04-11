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
									T_LET('ACN80265','acontreras')
									,T_LET('AMG21185','amoreno')
									,T_LET('ASM829','asorianob')
									,T_LET('AVE15878','avillare')
									,T_LET('AVE8440','avillare')
									,T_LET('CMI80307','cmoya')
									,T_LET('CTF55432','ctrincado')
									,T_LET('EBC40085','eballesteros')
									--,T_LET('EJM15877','#N/A')
									,T_LET('EMC555','emunozc')
									,T_LET('ERI4930','erodriguez')
									,T_LET('ESL20875','esanchezl')
									,T_LET('FCS16618','fcruz')
									,T_LET('FCS201','fcruz')
									,T_LET('FGA8067','fgarcia')
									,T_LET('FLV2084','floira')
									--,T_LET('FMS60550','#N/A')
									,T_LET('GAN55505','gacosta')
									,T_LET('GRS55135','grivero')
									,T_LET('IGT5040','igarcia')
									,T_LET('IVP22085','ivanacloig')
									,T_LET('JAM16642','jasensio')
									,T_LET('JAM649','jasensio')
									,T_LET('JAR2242','jalonso')
									,T_LET('JBE22084','jbodega')
									,T_LET('JBM20619','jbarrachina')
									,T_LET('JCL3640','jcarlos')
									,T_LET('JET22643','jespi')
									,T_LET('JGG22236','jgimenez')
									,T_LET('JGG22433','jgarciaga')
									,T_LET('JPR1532','jperezr')
									,T_LET('JPR16667','jperezr')
									,T_LET('JRL6655','jroman')
									,T_LET('JRM3757','jrebollo')
									,T_LET('JRP55630','jramirez')
									,T_LET('JUG457','jurrutia')
									,T_LET('LCP5758','lcastano')
									,T_LET('LMR80279','lmontoya')
									,T_LET('LRM55125','lramos')
									,T_LET('LRO55022','lrubio')
									,T_LET('MGC40330','mgarciac')
									,T_LET('MGM4340','megonzalez')
									,T_LET('MGP52028','mgabarda')
									,T_LET('MGS55248','mgonzalezsu')
									,T_LET('MJJ2744','mjimenez')
									,T_LET('MMM16712','mmoreno')
									,T_LET('MMM1932','mmoreno')
									,T_LET('MMM20483','mmestanza')
									,T_LET('MPL22856','mpiqueras')
									,T_LET('MRB2358','mros')
									,T_LET('MRM1666','mrodriguezm')
									,T_LET('MSC5242','msalido')
									,T_LET('PFS22556','pfernandez')
									,T_LET('RCM80276','rcanovas')
									,T_LET('RGM80261','mgarciam')
									,T_LET('RHP4396','rhernandez')
									,T_LET('RMV2978','rmendez')
									,T_LET('SGG5555','sgongora')
									--,T_LET('SMR11668','#N/A')
									,T_LET('SRM80287','sreyes')
									,T_LET('TCG22290','tchiner')
									,T_LET('VRF22936','vrosello')
									--,T_LET('YLJ15863','#N/A')
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

