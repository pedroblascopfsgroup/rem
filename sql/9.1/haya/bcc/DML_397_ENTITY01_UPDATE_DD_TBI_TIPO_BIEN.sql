--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=20160413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-2974
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar DD_TBI_TIPO_BIEN
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES: 1
--##           
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
  
 V_ESQUEMA 			     VARCHAR2(25 CHAR):= '#ESQUEMA#'; 				-- Configuracion Esquema
 V_ESQUEMA_MASTER    		     VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 			-- Configuracion Esquema Master
 TABLA                               VARCHAR(100 CHAR):= 'DD_TBI_TIPO_BIEN';
 SECUENCIA                           VARCHAR(100 CHAR):= 'S_DD_TBI_TIPO_BIEN_ID';
 seq_count 			     NUMBER(3); 						-- Vble. para validar la existencia de las Secuencias.
 table_count 		     	     NUMBER(3); 						-- Vble. para validar la existencia de las Tablas.
 v_column_count  	   	     NUMBER(3); 						-- Vble. para validar la existencia de las Columnas.
 v_constraint_count  		     NUMBER(3); 						-- Vble. para validar la existencia de las Constraints.
 err_num  			     NUMBER; 							-- Numero de errores
 err_msg  			     VARCHAR2(2048); 						-- Mensaje de error 
 V_MSQL 			     VARCHAR2(4000 CHAR);
 V_EXIST  			     NUMBER(10);
 V_ENTIDAD_ID  		   	     NUMBER(16); 
 V_ENTIDAD 			     NUMBER(16);
 
 V_COUNT	NUMBER;
 V_USUARIO_CREAR VARCHAR2(10) := 'CMREC-2974';
 
 BEGIN

SELECT COUNT(1) INTO V_COUNT  FROM CM01.DD_TBI_TIPO_BIEN WHERE DD_TBI_CODIGO = 100;

IF V_COUNT = 0
THEN
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100'',''Vehículo'',''Vehículo'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''101'',''Coche'',''Coche'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''102'',''Moto'',''Moto'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''103'',''Camión o Camioneta'',''Camión o Camioneta'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''104'',''Roulotte o Remolque'',''Roulotte o Remolque'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''105'',''Otros vehículos'',''Otros vehículos'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''200'',''Maquinaria'',''Maquinaria'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''201'',''Maquinaria Industrial'',''Maquinaria Industrial'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''202'',''Otra Maquinaria'',''Otra Maquinaria'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''300'',''Otros Bienes'',''Otros Bienes'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1008'',''Titulos y Valores Mobiliarios'',''Titulos y Valores Mobiliarios'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100801'',''Deuda Publica: Estado'',''Deuda Publica: Valores Emitidos por el Estado, Banco de España, CE Y OCD'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100802'',''Deuda Publica CCAA'',''Deuda Publica: Valores Emitidos por Comunidades Autonomas Autorizadas'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100803'',''Otros Titulos'',''Otros Titulos Emitidos por Administraciones Territoriales No Autorizadas'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100804'',''Otros Valores Emitidos por Administraciones'',''Otros Valores Emitidos por Administraciones de Paises distintos de la UE y de la OCDE'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100805'',''Valores de R.Fija Emt por Ent de Credito'',''Valores de Renta Fija Emitidos por Entidades de Credito'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100806'',''Val R.Fija Emit por Emisor Solvencia (Cot)'',''Valores de Renta Fija Emitidos por Emisores de Reconocida Solvencia (con Cotizacion)'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100807'',''Val Ren F Emt  Emisores que no recon sol no Cot'',''Valores de Renta Fija Emitidos por Emisores que no tienen reconocida su solvencia (sin Cotiza'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100808'',''Valores de Renta Variable con c'',''Valores de Renta Variable con Cotizacion'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100809'',''Valores de Renta Variable sin c'',''Valores de Renta Variable sin Cotizacion'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100810'',''Participaciones en FIAMM'',''Participaciones en FIAMM'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''100811'',''Participaciones F.Inversion'',''Participaciones en Otros Fondos de Inversion'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1201'',''IVA'',''IVA'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1202'',''Ayuda Paralizacion pesquera'',''Subvencion/Ayuda Paralizacion pesquera'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1203'',''Seguro de Ahorro'',''Seguro de Ahorro'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1204'',''Cesion de Agua'',''Cesion de Agua'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1205'',''Rentas Contrato'',''Rentas Contrato'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120501'',''Arrendamiento Presente'',''Arrendamiento Presente'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120502'',''Arrendamiento Futuro'',''Arrendamiento Futuro'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1206'',''Derechos Credito'',''Derechos Credito'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120601'',''Compraventa Presente'',''Compraventa Presente'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120602'',''Compraventa Futura'',''Compraventa Futura'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120603'',''Contratos Futuros de Comercio Exterior'',''Contratos Futuros de Comercio Exterior'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120604'',''Sentencia Judicial'',''Sentencia Judicial'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120605'',''Facturacion'',''Facturacion'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120606'',''Credito Documentario'',''Credito Documentario'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120607'',''Pagare CC'',''Pagare CC'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''120608'',''Derechos Expropiacion'',''Derechos Expropiacion'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);
V_MSQL:='INSERT INTO '||V_ESQUEMA||'.'||TABLA||' values ('||V_ESQUEMA||'.'||SECUENCIA||'.nextval,''1207'',''Plan Pensiones'',''Plan Pensiones'',0,'''||V_USUARIO_CREAR||''',SYSTIMESTAMP,NULL,NULL,NULL,NULL,0)';
execute immediate(V_MSQL);

DBMS_OUTPUT.PUT_LINE('Insertados nuevos registro en el diccionario');

ELSE
DBMS_OUTPUT.PUT_LINE('El diccionario ya estaba actualizado');

END IF;

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
