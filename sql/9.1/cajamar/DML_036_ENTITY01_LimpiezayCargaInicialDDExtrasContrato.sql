--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150828
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-531
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de Campos Extras de contratos en EXT_DD_IFC_INFO_CONTRATO, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_IFC IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_IFC IS TABLE OF T_IFC;

   
      
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
--Configuracion  EXT_DD_IFC_INFO_CONTRATO
                                   
   V_IFC T_ARRAY_IFC := T_ARRAY_IFC(
                                  T_IFC('char_extra1','Código que indica la entidad propietaria de la cartera (ej. Cajamar, SAREB, otros)','Código que indica la entidad propietaria de la cartera (ej. Cajamar, SAREB, otros)')
                                , T_IFC('char_extra2','Tipo de aval','Tipo de aval')
                                , T_IFC('char_extra3','Identificación titulización','Identificación titulización')
                                , T_IFC('char_extra4','Fondo propietario en caso de operaciones titulizadas.(Código según Dic. Datos)','Fondo propietario en caso de operaciones titulizadas.(Código según Dic. Datos)')
                                , T_IFC('char_extra5','Entidad origen del contrato, especialmente para operaciones migradas.(Código según Dic. Datos)','Entidad origen del contrato, especialmente para operaciones migradas.(Código según Dic. Datos)')
                                , T_IFC('char_extra6','Código propietario (5) + tipo de producto (5) + número de contrato (17) + Identificador de condiciones especiales (15) del préstamo matriz para promotor.','Código propietario (5) + tipo de producto (5) + número de contrato (17) + Identificador de condiciones especiales (15) del préstamo matriz para promotor.')
                                , T_IFC('char_extra7','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra8','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra9','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra10','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra11','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra12','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra13','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra14','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra15','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('char_extra16','Campo de texto extra para otros códigos que no estén contempladas previamente.','Campo de texto extra para otros códigos que no estén contempladas previamente.')
                                , T_IFC('flag_extra1','Indicador de titulización dentro o fuera de balance','Indicador de titulización dentro o fuera de balance')
                                , T_IFC('flag_extra2','Indicador de si el contrato es titularizado o no. (1=Sí/0=No).','Indicador de si el contrato es titularizado o no. (1=Sí/0=No).')
                                , T_IFC('flag_extra3','Si el contrato pertenece o no al fondo de trasferencia de pérdidas. (1=Sí/0=No).','Si el contrato pertenece o no al fondo de trasferencia de pérdidas. (1=Sí/0=No).')
                                , T_IFC('flag_extra4','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra5','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra6','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra7','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra8','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra9','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra10','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra11','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra12','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('flag_extra13','Campo de un dígito para indicadores que no estén contemplados previamente.','Campo de un dígito para indicadores que no estén contemplados previamente.')
                                , T_IFC('date_extra1','Fecha titulización','Fecha titulización')
                                , T_IFC('date_extra2','Fecha extra usada para informar de la Fecha de Entrada Actual en Gestión especial.','Fecha extra usada para informar de la Fecha de Entrada Actual en Gestión especial.')
                                , T_IFC('date_extra3','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra4','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra5','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra6','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra7','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra8','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra9','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra10','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra11','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('date_extra12','Campo de fecha extra para otras fechas que no estén contempladas previamente.','Campo de fecha extra para otras fechas que no estén contempladas previamente.')
                                , T_IFC('num_extra1','Naturaleza del aval','Naturaleza del aval')
                                , T_IFC('num_extra2','Segmento cartera','Segmento cartera')
                                , T_IFC('num_extra3','Código de producto de titulización','Código de producto de titulización')
                                , T_IFC('num_extra4','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra5','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra6','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra7','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra8','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra9','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra10','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra11','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra12','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('num_extra13','Campo numérico extra para importes o saldos que no estén contemplados previamente.','Campo numérico extra para importes o saldos que no estén contemplados previamente.')
                                , T_IFC('lchar_extra1','campo de texto para información que no esté contemplada previamente.','campo de texto para información que no esté contemplada previamente.')
                                , T_IFC('DD_ECE_CODIGO','Codigo estado contrato entidad','Código estado contrato entidad')
                                , T_IFC('CNT_COD_PROPIETARIO','CODIGO ENTIDAD PROPIETARIA','Código que indica la entidad propietaria de la cartera (ej. Cajamar, SAREB, otros)')
                                , T_IFC('CNT_TIPO_PRODUCTO','TIPO PRODUCTO ENTIDAD ID','Catalogación del producto en la entidad. (Código según Dic. Datos)')
                                , T_IFC('NUMERO_CONTRATO','NUMERO_CONTRATO','Número de Contrato Identificador de Operación (NUMER(17))')
                                , T_IFC('NUMERO_ESPEC','NUMERO_ESPEC','Identificador de condiciones especiales de contratación')                                
                            );
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_IFC T_IFC;

   
BEGIN

    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de EXT_DD_IFC_INFO_CONTRATO');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.EXT_DD_IFC_INFO_CONTRATO');
       
        
 
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_IFC_INFO_CONTRATO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_IFC_INFO_CONTRATO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_IFC_INFO_CONTRATO
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 


   DBMS_OUTPUT.PUT_LINE('Creando EXT_DD_IFC_INFO_CONTRATO......');
   FOR I IN V_IFC.FIRST .. V_IFC.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_IFC_INFO_CONTRATO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_IFC := V_IFC(I);
      DBMS_OUTPUT.PUT_LINE('Creando GRC: '||V_TMP_IFC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.EXT_DD_IFC_INFO_CONTRATO (DD_IFC_ID, DD_IFC_CODIGO, DD_IFC_DESCRIPCION,' ||
        'DD_IFC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_IFC(1)||''','''||SUBSTR(V_TMP_IFC(2),1, 50)||''','''
         ||V_TMP_IFC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_IFC := NULL;


  

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

