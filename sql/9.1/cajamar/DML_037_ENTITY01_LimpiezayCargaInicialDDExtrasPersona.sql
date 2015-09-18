--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150828
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de Campos Extras de personas en EXT_DD_IFX_INFO_EXTRA_CLI, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_IFX IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_IFX IS TABLE OF T_IFX;

   
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
   seq_count          NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código del grupo de carga   
--Configuracion  EXT_DD_IFX_INFO_EXTRA_CLI
                                   
   V_IFX T_ARRAY_IFX := T_ARRAY_IFX(
                                     T_IFX('char_extra1','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra2','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra3','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra4','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra5','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra6','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra7','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra8','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra9','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('char_extra10','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                   , T_IFX('flag_extra1','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra2','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra3','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra4','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra5','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra6','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra7','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra8','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra9','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('flag_extra10','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                   , T_IFX('date_extra1','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra2','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra3','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra4','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra5','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra6','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra7','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra8','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra9','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('date_extra10','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                   , T_IFX('num_extra1','Dispuesto no vencido','Dispuesto no vencido')
                                   , T_IFX('num_extra2','Dispuesto vencido','Dispuesto vencido')
                                   , T_IFX('num_extra3','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra4','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra5','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra6','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra7','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra8','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra9','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra10','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra11','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('num_extra12','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                   , T_IFX('SERV_NOMINA_PENSION','Servicio_Nomina_Pension','Indicador de si el cliente tiene contratado servicio nómina o pensión 1=Si / 0=No')
                                   , T_IFX('ULTIMA_ACTUACION','Última_Actuación','Se informará de la última actuación realizada por gestor Cajamar informada en la FGI')
                                   , T_IFX('COD_ENT_OFI_GESTORA','CODIGO_ENTIDAD_OFICINA_GESTORA','El código de la entidad para la oficina gestora del cliente.')
                                   , T_IFX('COD_OFICINA_GESTORA','CODIGO_OFICINA_GESTORA','El código de la oficina para la oficina gestora del cliente.')
                                   , T_IFX('COD_SUBS_OFI_GESTORA','CODIGO_SUBSECCION_OFICINA_GESTORA','El código de subsección para la oficina gestora del cliente.')
                            );
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_IFX T_IFX;

   
BEGIN

    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de EXT_DD_IFX_INFO_EXTRA_CLI');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.EXT_DD_IFX_INFO_EXTRA_CLI');
       
        
 
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_IFX_INFO_EXTRA_CLI' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_IFX_INFO_EXTRA_CLI');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_IFX_INFO_EXTRA_CLI
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 


   DBMS_OUTPUT.PUT_LINE('Creando EXT_DD_IFX_INFO_EXTRA_CLI......');
   FOR I IN V_IFX.FIRST .. V_IFX.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_IFX_INFO_EXTRA_CLI.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_IFX := V_IFX(I);
      DBMS_OUTPUT.PUT_LINE('Creando GRC: '||V_TMP_IFX(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EXT_DD_IFX_INFO_EXTRA_CLI (DD_IFX_ID, DD_IFX_CODIGO, DD_IFX_DESCRIPCION,' ||
        'DD_IFX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_IFX(1)||''','''||SUBSTR(V_TMP_IFX(2),1, 50)||''','''
         ||V_TMP_IFX(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_IFX := NULL;


  

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


