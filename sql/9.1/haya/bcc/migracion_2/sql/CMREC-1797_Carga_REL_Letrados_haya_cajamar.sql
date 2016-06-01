--/*
--##########################################
--## AUTOR=GUSTAVO MORA 
--## FECHA_CREACION=20160129
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-451
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos Relación LETRADOS haya cajamar definitivos, esquema HAYA02.
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

--LETRADOS
-- Configuracion LETRADOS
   V_LET T_ARRAY_LET := T_ARRAY_LET(
                                     T_LET('let.abadenes','BALABADEN')
                                   , T_LET('let.aballester','JOSEBALLC')
                                   , T_LET('let.acardona','BALABADEN')
                                   , T_LET('let.achaves','ALBECHAVA')
                                   , T_LET('let.aenguix','LEXEAGOGA')
                                   , T_LET('let.afornes','JOSEMANUG')
                                   , T_LET('let.agarciag','LEONRUBIA')
                                   , T_LET('let.agomez','ANTOGOMEP')
                                   , T_LET('let.ahernandez','GENECIENA')
                                   , T_LET('let.alaras','LEXEAGOGA')
                                   , T_LET('let.apellicer','PELLCAUDA')
                                   , T_LET('let.asimarro','GARRIABOG')
                                   , T_LET('let.avila','ANDRVILAC')
                                   , T_LET('let.bibanez','IBAFERSLP')
                                   , T_LET('let.cbalaguer','BALABADEN')
                                   , T_LET('let.cceruelos','JOSEMANUG')
                                   , T_LET('let.cesteban','CARMESTEN')
                                   , T_LET('let.cmas','ABECSLP')
                                   , T_LET('let.csanchez','SANCVILAA')
                                   , T_LET('let.cvillalonga','CONCVILLAT')
                                   , T_LET('let.dlahiguera','HISPIBERC')
                                   , T_LET('let.ebarruguer','BALABADEN')
                                   , T_LET('let.efernandez','CARRCORPO')
                                   , T_LET('let.emontero','ENRIMONTF')
                                   , T_LET('let.emoreno','LEONRUBIA')
                                   , T_LET('let.eventura','BALABADEN')
                                   , T_LET('let.fbardenes','BALABADEN')
                                   , T_LET('let.fbarrena','FRANBARRB')
                                   , T_LET('let.fgalvez','FGG13852')
                                   , T_LET('let.flao','FRANLAOMO')
                                   , T_LET('let.flaom','FRANLAOMO')
                                   , T_LET('let.fmendoza','MORAZAMEN')
                                   , T_LET('let.fmolla','FRANMOLLF')
                                   , T_LET('let.fmoraza','MORAZAMEN')
                                   , T_LET('let.fnovella','NOVEABOGY')
                                   , T_LET('let.fortigosa','LEXEAGOGA')
                                   , T_LET('let.fsanz','FRANSANZMA')
                                   , T_LET('let.ftintore','TINTOREAB')
                                   , T_LET('let.gramirez','ROSARAMIR')
                                   , T_LET('let.gzornoza','GUILZORND')
                                   , T_LET('let.icrespo','ISABCRESG')
                                   , T_LET('let.igonzalez','GENECIENA')
                                   , T_LET('let.ilopez','IGNALOPEZF')
                                   , T_LET('let.imartin','GENECIENA')
                                   , T_LET('let.imartinez','LEXEAGOGA')
                                   , T_LET('let.iromera','GARRIABOG')
                                   , T_LET('let.isoler','CARRCORPO')
                                   , T_LET('let.jalcoba','JESUALCOL')
                                   , T_LET('let.jarevalo','PROYFORMS')
                                   , T_LET('let.jcanos','JERICANOM')
                                   , T_LET('let.jcardenas','JORGCARDR')
                                   , T_LET('let.jcivico','GARCCIVIC')
                                   , T_LET('let.jdapena','JJDAPENA')
                                   , T_LET('let.jespino','JUANESPIP')
                                   , T_LET('let.jgarcia','BALABADEN')
                                   , T_LET('let.jgimenez','MANURUIZO')
                                   , T_LET('let.jgitrama','JOSEMANUG')
                                   , T_LET('let.jgomez','IBERFORO')
                                   , T_LET('let.jgonzalezr','JOSEGONZR')
                                   , T_LET('let.jhernandez','JUANHERNS')
                                   , T_LET('let.jhita','PROYFORMS')
                                   , T_LET('let.jleon','JOSELEONF')
                                   , T_LET('let.jmartin','GENECIENA')
                                   , T_LET('let.jmonedero','ABECSLP')
                                   , T_LET('let.jnavarro','PROYFORMS')
                                   , T_LET('let.jninerola','JOSENINEG')
                                   , T_LET('let.jortega','JOAQORTEM')
                                   , T_LET('let.jperez','LEONRUBIA')
                                   , T_LET('let.jpereza','PEREVALLA')
                                   , T_LET('let.jremolat','JOAQREMOV')
                                   , T_LET('let.jsintes','JOSESINTS')
                                   , T_LET('let.jsoler','JOSESOLEV')
                                   , T_LET('let.jtirado','JERICANOM')
                                   , T_LET('let.jvallejo','PEREVALLA')
                                   , T_LET('let.jvillalonga','JOSEVILLT')
                                   , T_LET('let.lgarcia','LUISGARCA')
                                   , T_LET('let.lmiralbell','LUISMIRAG')
                                   , T_LET('let.marmengot','MIGUARMEG')
                                   , T_LET('let.mcruz','PEREVALLA')
                                   , T_LET('let.mdeharo','MARIHAROG')
                                   , T_LET('let.mdonnay','JERICANOM')
                                   , T_LET('let.mencarnacion','GARRIABOG')
                                   , T_LET('let.mfernandeze','JOSENINEG')
                                   , T_LET('let.mgallardo','MIJEGALLM')
                                   , T_LET('let.mhuertas','LUISGARCA')
                                   , T_LET('let.mlirola','MARILIROL')
                                   , T_LET('let.mmartinez','BALABADEN')
                                   , T_LET('let.mmartinezn','MIGUMARTN')
                                   , T_LET('let.mortega','JANIAASOC')
                                   , T_LET('let.mpastor','GARRIABOG')
                                   , T_LET('let.mperez','MORAZAMEN')
                                   , T_LET('let.mperezs','PROYFORMS')
                                   , T_LET('let.mpereza','GUILAOLAO')
                                   , T_LET('let.mquintana','JANIAASOC')
                                   , T_LET('let.mrico','PROYFORMS')
                                   , T_LET('let.mrodrigo','MARTRODRR')
                                   , T_LET('let.mruiz','MANURUIZO')
                                   , T_LET('let.msanzg','BALABADEN')
                                   , T_LET('let.mtatay','CARRCORPO')
                                   , T_LET('let.ndiaz','NAYRDIAZG')
                                   , T_LET('let.pnavarro','LEXEAGOGA')
                                   , T_LET('let.pramirez','ROSARAMIR')
                                   , T_LET('let.prodriguezt','JOSEMANUG')
                                   , T_LET('let.psantanac','JANIAASOC')
                                   , T_LET('let.pvalls','BALABADEN')
                                   , T_LET('let.ralvarez','ROSAALVAB')
                                   , T_LET('let.rbarreda','BALABADEN')
                                   , T_LET('let.rcorell','RAFACORER')
                                   , T_LET('let.rgomis','JOSEMANUG')
                                   , T_LET('let.rleon','LEONRUBIA')
                                   , T_LET('let.rromero','ROSAROMER')
                                   , T_LET('let.sgomis','JOSEMANUG')
                                   , T_LET('let.snovella','NOVEABOGY')
                                   , T_LET('let.spacheco','FRANBARRB')
                                   , T_LET('let.spascual','FRANBARRB')
                                   , T_LET('let.spellicer','PELLCAUDA')
                                   , T_LET('let.sromaguera','SEBAROMAG')
                                   , T_LET('let.ssesma','NOVEABOGY')
                                   , T_LET('let.syepes','JOSENINEG')
                                   , T_LET('let.thusillos','IBERFORO')
                                   , T_LET('let.vbellido','HISPIBERC')
                                   , T_LET('let.vferrera','ABOGFERRY')
                                   , T_LET('let.vmoles','SANCVILAA')
                                   , T_LET('let.vrodrigueze','VICERODRE')
                                   , T_LET('let.vserrano','FRANLAOMO')
                                   , T_LET('let.zcubas','JANIAASOC')
                                   ); 
                                   
                                   
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_LET T_LET;

   
BEGIN

 -- Borramos la tabla DD_LHC_LETR_HAYA_CAJAMAR
     DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_LHC_LETR_HAYA_CAJAMAR');
     EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA||'.DD_LHC_LETR_HAYA_CAJAMAR');
                     
-- INSERTAMOS/UPDATEAMOS LOS VALORES EN LA TABLA DD_LHC_LETR_HAYA_CAJAMAR

   DBMS_OUTPUT.PUT_LINE('Actualizando DD_LHC_LETR_HAYA_CAJAMAR con relación haya cajamar');
   FOR I IN V_LET.FIRST .. V_LET.LAST
   LOOP

       V_TMP_LET := V_LET(I);


	   DBMS_OUTPUT.PUT_LINE('[INFO] Insertando - DD_LHC_LETR_HAYA_CAJAMAR ' ||  V_TMP_LET(1));

         
           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_LHC_LETR_HAYA_CAJAMAR (DD_LHC_HAYA_CODIGO, DD_LHC_BCC_CODIGO, ' ||
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

