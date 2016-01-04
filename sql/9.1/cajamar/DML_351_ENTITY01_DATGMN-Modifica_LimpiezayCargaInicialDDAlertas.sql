--/*
--##########################################
--## AUTOR=GUSTAVO MORA / AGUSTIN MOMPO
--## FECHA_CREACION=20151211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-451
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos tipo ALERTAS, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.2 añadido GAL_DESCRIPCION a la descripcion 
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  

   TYPE T_TAL IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_TAL IS TABLE OF T_TAL;
   TYPE T_GAL IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_GAL IS TABLE OF T_GAL;

  
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   seq_count          NUMBER(13); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(13); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(13); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(13); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   
   V_GAL_ID           NUMBER(5);
   V_GAL_ID_DEFAULT    NUMBER(5);
   V_GRC_ID           NUMBER(5);   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Grupo Alerta
-- Configuracion GAL_GRUPO_ALERTA
   V_GAL T_ARRAY_GAL := T_ARRAY_GAL(
				T_GAL('00000','GRUPO ALERTA NO ESPECIFICADO','GRUPO ALERTA NO ESPECIFICADO')
				,T_GAL('09','SITUACION ECONOMICO','SITUACION ECONOMICO')
				,T_GAL('04','INFORMACION PUBLICA','INFORMACION PUBLICA')
				,T_GAL('01','CIRBE','CIRBE')
				,T_GAL('06','PRODUCTOS','PRODUCTOS')
                        ); 
--Tipo de Alerta  
--Configuracion  TAL_TIPO_ALERTA
   V_TAL T_ARRAY_TAL := T_ARRAY_TAL(                                                                       
                             T_TAL('010101','CIRBE|INCREMENTO DEUDA OTRAS ENTIDADES (Incremento del 25% de la deuda en otras entidades)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento del 25% de la deuda en otras entidades)')
                            , T_TAL('010102','CIRBE|INCREMENTO DEUDA OTRAS ENTIDADES (Incremento entre el 25% y el 50% de la deuda en otras entidades)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento entre el 25% y el 50% de la deuda en otras entidades)')
                            , T_TAL('010103','CIRBE|INCREMENTO DEUDA OTRAS ENTIDADES (Incremento de la deuda en otras entidades superior al 50%)','INCREMENTO DEUDA OTRAS ENTIDADES (Incremento de la deuda en otras entidades superior al 50%)')
                            , T_TAL('010106','CIRBE|DUDOSIDAD (Dos o mas meses seguidos en situacion de dudoso en otras entidades)','DUDOSIDAD (Dos o mas meses seguidos en situacion de dudoso en otras entidades)')
                            , T_TAL('010107','CIRBE|DUDOSIDAD (Primera aparicion de la situacion de dudoso en otras entidades)','DUDOSIDAD (Primera aparicion de la situacion de dudoso en otras entidades)')
                            , T_TAL('010109','CIRBE|REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con garantia real en otras entidades en menos de un 5% del total de riesgo. Incremento del 10% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con garantia real en otras entidades en menos de un 5% del total de riesgo. Incremento del 10% del riesgo en gar. real en otras entidades)')
                            , T_TAL('010110','CIRBE|REFORZAMIENTO DE GARANTIAS (Primera aparicion de oper. con gar. real en otras entidades entre 5% y 15% del total de riesgo. Incremento entre el 10% y el 25% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de oper. con gar. real en otras entidades entre 5% y 15% del total de riesgo. Incremento entre el 10% y el 25% del riesgo en gar. real en otras entidades)')
                            , T_TAL('010111','CIRBE|REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con gar. real en otras entidades superior al 15% del total de riesgo. Incremento superior al 25% del riesgo en gar. real en otras entidades)','REFORZAMIENTO DE GARANTIAS (Primera aparicion de operaciones con gar. real en otras entidades superior al 15% del total de riesgo. Incremento superior al 25% del riesgo en gar. real en otras entidades)')
                            , T_TAL('010112','CIRBE|TECHO RIESGOS (Limite concedido en la entidad inferior al 50% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad inferior al 50% del total riesgo CIRBE)')
                            , T_TAL('010113','CIRBE|TECHO RIESGOS (Limite concedido en la entidad entre el 50% y el 75% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad entre el 50% y el 75% del total riesgo CIRBE)')
                            , T_TAL('010114','CIRBE|TECHO RIESGOS (Limite concedido en la entidad superior al 75% del total riesgo CIRBE)','TECHO RIESGOS (Limite concedido en la entidad superior al 75% del total riesgo CIRBE)')
                            , T_TAL('040101','INFORMACION PUBLICA|RAI (Alta del cliente en el RAI)','RAI (Alta del cliente en el RAI)')
                            , T_TAL('040102','INFORMACION PUBLICA|BADESCUG / ASNEF (Alta del cliente en el ASNEF)','BADESCUG / ASNEF (Alta del cliente en el ASNEF)')
                            , T_TAL('040103','INFORMACION PUBLICA|INCIDENCIAS JUDICIALES (Alta del cliente en Incidencias Judiciales)','INCIDENCIAS JUDICIALES (Alta del cliente en Incidencias Judiciales)')
                            , T_TAL('040104','INFORMACION PUBLICA|SITUACIONES CONCURSALES (Alta del cliente en el Situaciones Concursales)','SITUACIONES CONCURSALES (Alta del cliente en el Situaciones Concursales)')
                            , T_TAL('040105','INFORMACION PUBLICA|TRANSFORMACION DE LA SOCIEDAD','TRANSFORMACION DE LA SOCIEDAD')
                            , T_TAL('040106','INFORMACION PUBLICA|CAMBIO RAZON SOCIAL','CAMBIO RAZON SOCIAL')
                            , T_TAL('040107','INFORMACION PUBLICA|CAMBIO OBJETO SOCIAL','CAMBIO OBJETO SOCIAL')
                            , T_TAL('040108','INFORMACION PUBLICA|CAMBIO DOMICILIO SOCIAL','CAMBIO DOMICILIO SOCIAL')
                            , T_TAL('040109','INFORMACION PUBLICA|NOMBRAMIENTOS','NOMBRAMIENTOS')
                            , T_TAL('040110','INFORMACION PUBLICA|REVOCACIONES','REVOCACIONES')
                            , T_TAL('040111','INFORMACION PUBLICA|FUSION POR ABSORCION','FUSION POR ABSORCION')
                            , T_TAL('040112','INFORMACION PUBLICA|FUSION POR UNION','FUSION POR UNION')
                            , T_TAL('040113','INFORMACION PUBLICA|ESCISION PARCIAL','ESCISION PARCIAL')
                            , T_TAL('040114','INFORMACION PUBLICA|ESCISION TOTAL','ESCISION TOTAL')
                            , T_TAL('040115','INFORMACION PUBLICA|REDUCCION CAPITAL','REDUCCION CAPITAL')
                            , T_TAL('040116','INFORMACION PUBLICA|DISOLUCION','DISOLUCION')
                            , T_TAL('040117','INFORMACION PUBLICA|EXTINCION','EXTINCION')
                            , T_TAL('040118','INFORMACION PUBLICA|SOLIC SUSPENSION PAGOS','SOLIC SUSPENSION PAGOS')
                            , T_TAL('040119','INFORMACION PUBLICA|DECLARACION SUSP.PAGOS','DECLARACION SUSP.PAGOS')
                            , T_TAL('040120','INFORMACION PUBLICA|CONVENIO SUSP.PAGOS','CONVENIO SUSP.PAGOS')
                            , T_TAL('040121','INFORMACION PUBLICA|QUIEBRA','QUIEBRA')
                            , T_TAL('050101','POLITICA DE SEGUIMIENTO PASA DE NEUTRAL A RESTRICTIVA','POLITICA DE SEGUIMIENTO PASA DE NEUTRAL A RESTRICTIVA')
                            , T_TAL('050102','POLITICA DE SEGUIMIENTO PASA DE FAVORABLE A NEUTRAL','POLITICA DE SEGUIMIENTO PASA DE FAVORABLE A NEUTRAL')
                            , T_TAL('060101','PRODUCTOS|EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento inferiores al 15%)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento inferiores al 15%)')
                            , T_TAL('060102','PRODUCTOS|EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento superiores al 15% e inferiores al 30%)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos en el limite de descuento superiores al 15% e inferiores al 30%)')
                            , T_TAL('060103','PRODUCTOS|EXCESOS LIMITE LINEA COMERCIAL (Excedidos superiores al 30% en el limite de descuento)','EXCESOS LIMITE LINEA COMERCIAL (Excedidos superiores al 30% en el limite de descuento)')
                            , T_TAL('060104','PRODUCTOS|PORCENTAJE IMPAGOS (Impagados hasta 2% sobre el total vencido)','0601|PORCENTAJE IMPAGOS (Impagados hasta 2% sobre el total vencido)')
                            , T_TAL('060105','PRODUCTOS|PORCENTAJE IMPAGOS (Impagados superiores al 2% e inferiores al 7% sobre el total vencido)','0601|PORCENTAJE IMPAGOS (Impagados superiores al 2% e inferiores al 7% sobre el total vencido)')
                            , T_TAL('060106','PRODUCTOS|PORCENTAJE IMPAGOS (Impagados superiores al 7% sobre el total vencido)','0601|PORCENTAJE IMPAGOS (Impagados superiores al 7% sobre el total vencido)')
                            , T_TAL('060113','PRODUCTOS|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones hasta 5% sobre el total vencido)','0601|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones hasta 5% sobre el total vencido)')
                            , T_TAL('060114','PRODUCTOS|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superiores al 5% e inferiores al 15% sobre el total vencido)','0601|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superiores al 5% e inferiores al 15% sobre el total vencido)')
                            , T_TAL('060115','PRODUCTOS|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superior al 15% sobre el total vencido)','0601|DEVOLUCION PAPEL COMERCIAL (Indice de devoluciones superior al 15% sobre el total vencido)')
                            , T_TAL('060116','PRODUCTOS|Concentración en un librado hasta 20% sobre el límite total descontado vivo','0601|Concentración en un librado hasta 20% sobre el límite total descontado vivo')
                            , T_TAL('060117','PRODUCTOS|Concentración en un librado superior al 20% e inferior al 50% sobre límite de total descontado vivo','0601|Concentración en un librado superior al 20% e inferior al 50% sobre límite de total descontado vivo')
                            , T_TAL('060118','PRODUCTOS|Concentración en un librado superior al 50% sobre límite de total descontado vivo','0601|Concentración en un librado superior al 50% sobre límite de total descontado vivo')
                            , T_TAL('060119','PRODUCTOS|Plazos de descuento superiores al plazo autorizado e inferiores a 15 días.','Plazos de descuento superiores al plazo autorizado e inferiores a 15 días.')
                            , T_TAL('060120','PRODUCTOS|Plazos de descuento superiores en 15 días e inferiores a 30 dias al plazo autorizado.','Plazos de descuento superiores en 15 días e inferiores a 30 dias al plazo autorizado.')
                            , T_TAL('060121','PRODUCTOS|Plazos de descuento superiores en 30 días e inferiores a 90 dias al plazo autorizado.','Plazos de descuento superiores en 30 días e inferiores a 90 dias al plazo autorizado.')
                            , T_TAL('060122','PRODUCTOS|Importe descontado entre el 50% y el 70% de las ventas del cliente.','Importe descontado entre el 50% y el 70% de las ventas del cliente.')
                            , T_TAL('060123','PRODUCTOS|Importe descontado entre el 70% y el 90% de las ventas del cliente.','Importe descontado entre el 70% y el 90% de las ventas del cliente.')
                            , T_TAL('060124','PRODUCTOS|Importe descontado superiores al 90% de las ventas del cliente.','Importe descontado superiores al 90% de las ventas del cliente.')
                            , T_TAL('060125','PRODUCTOS|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos inferior al 5% de los efectos vencidos)','0601|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos inferior al 5% de los efectos vencidos)')
                            , T_TAL('060126','PRODUCTOS|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 5% e inferior al 15% de los efectos vencidos)','0601|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 5% e inferior al 15% de los efectos vencidos)')
                            , T_TAL('060127','PRODUCTOS|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 15% de los efectos vencidos)','0601|PORCENTAJE DE RECLAMACIONES (Reclamacion de efectos superior al 15% de los efectos vencidos)')
                            , T_TAL('060201','PRODUCTOS|DESCUBIERTOS (Descubiertos superiores a 3.000 euros y 30 días contínuos)','0602|DESCUBIERTOS (Descubiertos superiores a 3.000 euros y 30 días contínuos)')
                            , T_TAL('060202','PRODUCTOS|DESCUBIERTOS (Descubiertos superiores a 6.000 euros y 30 días contínuos)','0602|DESCUBIERTOS (Descubiertos superiores a 6.000 euros y 30 días contínuos)')
                            , T_TAL('060203','PRODUCTOS|DESCUBIERTOS (Descubiertos superiores a 12.000 euros y 30 días contínuos)','0602|DESCUBIERTOS (Descubiertos superiores a 12.000 euros y 30 días contínuos)')
                            , T_TAL('060204','PRODUCTOS|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 3.000 euros)','0602|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 3.000 euros)')
                            , T_TAL('060205','PRODUCTOS|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 6.000 euros)','0602|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 6.000 euros)')
                            , T_TAL('060206','PRODUCTOS|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 12.000 euros)','0602|SALDO MEDIO DEUDOR (Saldo medio deudor superior a 12.000 euros)')
                            , T_TAL('060207','PRODUCTOS|COMPENSACION (Número de cheques compensados devueltos superiores a 5 e inferior a 10)','COMPENSACION (Número de cheques compensados devueltos superiores a 5 e inferior a 10)')
                            , T_TAL('060208','PRODUCTOS|COMPENSACION (Número de cheques compensados devueltos superiores a 10 e inferior a 20)','COMPENSACION (Número de cheques compensados devueltos superiores a 10 e inferior a 20)')
                            , T_TAL('060209','PRODUCTOS|COMPENSACION (Más de 2 cheques compensados devueltos)','COMPENSACION (Más de 2 cheques compensados devueltos)')
                            , T_TAL('060210','PRODUCTOS|CHEQUES (Devolución de más de 3 cheques y menos de 5 por incorrientes (sin fondos))','0602|CHEQUES (Devolución de más de 3 cheques y menos de 5 por incorrientes (sin fondos))')
                            , T_TAL('060211','PRODUCTOS|CHEQUES (Devolución de más de 10 cheques por incorrientes (sin fondos))','0602|CHEQUES (Devolución de más de 10 cheques por incorrientes (sin fondos))')
                            , T_TAL('060212','PRODUCTOS|CHEQUES (Devolución de más de 5 cheques y menos de 10 por incorrientes (sin fondos))','0602|CHEQUES (Devolución de más de 5 cheques y menos de 10 por incorrientes (sin fondos))')
                            , T_TAL('060300','PRODUCTOS|EXCESOS SOBRE LIMITE (EXCEDIDO MENOR O IGUAL AL 15% Y DURANTE 15 DIAS CONTINUOS)','0603|EXCESOS SOBRE LIMITE (EXCEDIDO MENOR O IGUAL AL 15% Y DURANTE 15 DIAS CONTINUOS)')
                            , T_TAL('060301','PRODUCTOS|EXCESOS SOBRE LIMITE (EXCEDIDOS MAYORES DEL 15% Y MENORES DEL 30% DURANTE 15 DIAS CONTINUOS)','0603|EXCESOS SOBRE LIMITE (EXCEDIDOS MAYORES DEL 15% Y MENORES DEL 30% DURANTE 15 DIAS CONTINUOS)')
                            , T_TAL('060302','PRODUCTOS|EXCESOS SOBRE LIMITE (EXCEDIDOS SUPERIORES AL 30% Y DURANTE 15 DIAS CONTINUOS)','0603|EXCESOS SOBRE LIMITE (EXCEDIDOS SUPERIORES AL 30% Y DURANTE 15 DIAS CONTINUOS)')
                            , T_TAL('060303','PRODUCTOS|POLIZAS VENCIDAS (VENCIDO INFERIOR A 7 DIAS)','0603|POLIZAS VENCIDAS (VENCIDO INFERIOR A 7 DIAS)')
                            , T_TAL('060304','PRODUCTOS|POLIZAS VENCIDAS (VENCIDO MAYOR DE 7 DIAS Y MENOR DE 15 DIAS)','POLIZAS VENCIDAS (VENCIDO MAYOR DE 7 DIAS Y MENOR DE 15 DIAS)')
                            , T_TAL('060305','PRODUCTOS|POLIZAS VENCIDAS (VENCIDO SUPERIOR A 15 DIAS)','POLIZAS VENCIDAS (VENCIDO SUPERIOR A 15 DIAS)')
                            , T_TAL('060306','PRODUCTOS|ROTACION POLIZA (INGRESOS SUPERIORES A 1,5 VECES EL LIMITE CONCEDIDO E INFERIOR A 2 VECES EL LIMITE CONCEDIDO)','ROTACION POLIZA (INGRESOS SUPERIORES A 1,5 VECES EL LIMITE CONCEDIDO E INFERIOR A 2 VECES EL LIMITE CONCEDIDO)')
                            , T_TAL('060307','PRODUCTOS|ROTACION POLIZA (INGRESOS SUPERIORES A 1 VECES EL LIMITE CONCEDIDO INFERIOR A 1,5 VECES EL LIMITE CONCEDIDO)','0603|ROTACION POLIZA (INGRESOS SUPERIORES A 1 VECES EL LIMITE CONCEDIDO INFERIOR A 1,5 VECES EL LIMITE CONCEDIDO)')
                            , T_TAL('060308','PRODUCTOS|ROTACION POLIZA (INGRESOS INFERIORES A LIMITE CONCEDIDO)','0603|ROTACION POLIZA (INGRESOS INFERIORES A LIMITE CONCEDIDO)')
                            , T_TAL('060309','PRODUCTOS|Saldo medio dispuesto superior al 90% del límite actual e inferior al límite actual','0603|Saldo medio dispuesto superior al 90% del límite actual e inferior al límite actual')
                            , T_TAL('060310','PRODUCTOS|Saldo medio dispuesto superior al 100% del límite actual e inferior al 110% del límite actual','0603|Saldo medio dispuesto superior al 100% del límite actual e inferior al 110% del límite actual')
                            , T_TAL('060311','PRODUCTOS|Saldo medio dispuesto superior al 110% del límite actual','0603|Saldo medio dispuesto superior al 110% del límite actual')
                            , T_TAL('060401','PRODUCTOS|CUOTAS IMPAGADADAS (Cuotas impagadas hasta 1.200 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 1.200 euros y 15 dias)')
                            , T_TAL('060402','PRODUCTOS|CUOTAS IMPAGADADAS (Cuotas impagadas de mas de 2.500 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas de mas de 2.500 euros y 15 dias)')
                            , T_TAL('060403','PRODUCTOS|CUOTAS IMPAGADADAS (Cuotas impagadas hasta 2.500 euros y 15 dias)','CUOTAS IMPAGADADAS (Cuotas impagadas hasta 2.500 euros y 15 dias)')
                            , T_TAL('070101','Cambios en: Forma Juridica, actividad, domicilio social, apoderados y administradores','Cambios en: Forma Juridica, actividad, domicilio social, apoderados y administradores')
                            , T_TAL('070102','Fusiones y absorciones; cambios de accionistas','Fusiones y absorciones; cambios de accionistas')
                            , T_TAL('070103','Reducciones de capital','Reducciones de capital')
                            , T_TAL('080101','OPERACION PASA DE RIESGO BAJO A RIESGO MEDIO','0801|OPERACION PASA DE RIESGO BAJO A RIESGO MEDIO')
                            , T_TAL('080102','OPERACION PASA DE RIESGO MEDIO A RIESGO ALTO','0801|OPERACION PASA DE RIESGO MEDIO A RIESGO ALTO')
                            , T_TAL('080103','OPERACION PASA DE RIESGO ALTO A RIESGO MUY ALTO','0801|OPERACION PASA DE RIESGO ALTO A RIESGO MUY ALTO')
                            , T_TAL('090101','SITUACION ECONOMICO|Disminución Beneficio entre el 10% y el 25% respecto al año anterior','Disminución Beneficio entre el 10% y el 25% respecto al año anterior')
                            , T_TAL('090102','SITUACION ECONOMICO|Disminución Beneficio igual o superior 25% respecto al año anterior','Disminución Beneficio igual o superior 25% respecto al año anterior')
                            , T_TAL('090103','SITUACION ECONOMICO|Beneficio menor que 0 (Perdidas)','Beneficio menor que 0 (Perdidas)')
                            , T_TAL('090104','SITUACION ECONOMICO|Disminución Margen Neto en 10% respecto al año anterior','Disminución Margen Neto en 10% respecto al año anterior')
                            , T_TAL('090105','SITUACION ECONOMICO|Disminución Margen Neto en 50% respecto al año anterior','Disminución Margen Neto en 50% respecto al año anterior')
                            , T_TAL('090106','SITUACION ECONOMICO|Disminución Margen Neto en 25% respecto al año anterior','Disminución Margen Neto en 25% respecto al año anterior')
                            , T_TAL('090107','SITUACION ECONOMICO|Disminución Margen Bruto en 10% respecto al año anterior','Disminución Margen Bruto en 10% respecto al año anterior')
                            , T_TAL('090108','SITUACION ECONOMICO|Disminución Margen Bruto en 50% respecto al año anterior','Disminución Margen Bruto en 50% respecto al año anterior')
                            , T_TAL('090109','SITUACION ECONOMICO|Disminución Margen Bruto en 25% respecto al año anterior','Disminución Margen Bruto en 25% respecto al año anterior')
                            , T_TAL('090110','SITUACION ECONOMICO|La deuda a Largo Plazo es entre 5 y 7 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es entre 5 y 7 veces mayor que el Cash Flow. ')
                            , T_TAL('090111','SITUACION ECONOMICO|La deuda a Largo Plazo es entre 7 y 10 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es entre 7 y 10 veces mayor que el Cash Flow. ')
                            , T_TAL('090112','SITUACION ECONOMICO|La deuda a Largo Plazo es mas de 10 veces mayor que el Cash Flow. ','La deuda a Largo Plazo es mas de 10 veces mayor que el Cash Flow. ')
                            , T_TAL('090113','SITUACION ECONOMICO|Ratio Margen Explotación Cuenta Resultados < 10%','Ratio Margen Explotación Cuenta Resultados < 10%')
                            , T_TAL('090114','SITUACION ECONOMICO|Ratio Margen Explotación Cuenta Resultados >= 10% y < 25%','Ratio Margen Explotación Cuenta Resultados >= 10% y < 25%')
                            , T_TAL('090115','SITUACION ECONOMICO|Ratio Margen Explotación Cuenta Resultados >= 25% y <= 50%','Ratio Margen Explotación Cuenta Resultados >= 25% y <= 50%')
                            , T_TAL('090116','SITUACION ECONOMICO|Caida de Beneficios.Dism Rdtos antes de impuestos 3 ult ejercicios','Caida de Beneficios.Dism Rdtos antes de impuestos 3 ult ejercicios')
                            , T_TAL('090117','SITUACION ECONOMICO|Perdidas Continuadas.Rtdos antes de imp negat ejerc actual y dos ant','Perdidas Continuadas.Rtdos antes de imp negat ejerc actual y dos ant')
                            , T_TAL('090118','SITUACION ECONOMICO|Ratio PM Cobro > 120 días','Ratio PM Cobro > 120 días')
                            , T_TAL('090119','SITUACION ECONOMICO|Ratio PM Pago < 30 días','Ratio PM Pago < 30 días')
                            , T_TAL('090201','SITUACION ECONOMICO|Disminución del Ratio de Solvencia en un 10% respecto año anterior','Disminución del Ratio de Solvencia en un 10% respecto año anterior')
                            , T_TAL('090202','SITUACION ECONOMICO|Disminución del Ratio de Solvencia en un 30% respecto año anterior','Disminución del Ratio de Solvencia en un 30% respecto año anterior')
                            , T_TAL('090203','SITUACION ECONOMICO|Disminución del Ratio de Solvencia en un 50% respecto año anterior','Disminución del Ratio de Solvencia en un 50% respecto año anterior')
                            , T_TAL('090204','SITUACION ECONOMICO|Valor del Ratio de Solvencia entre 1,75 y 1,4','Valor del Ratio de Solvencia entre 1,75 y 1,4')
                            , T_TAL('090205','SITUACION ECONOMICO|Valor del Ratio de Solvencia entre 1,4 y 1','Valor del Ratio de Solvencia entre 1,4 y 1')
                            , T_TAL('090206','SITUACION ECONOMICO|Valor del Ratio de Solvencia menor o igual a 1','Valor del Ratio de Solvencia menor o igual a 1')
                            , T_TAL('090207','SITUACION ECONOMICO|Disminución del Ratio de Liquidez en un 10% respecto año anterior','Disminución del Ratio de Liquidez en un 10% respecto año anterior')
                            , T_TAL('090208','SITUACION ECONOMICO|Disminución del Ratio de Liquidez en un 30% respecto año anterior','Disminución del Ratio de Liquidez en un 30% respecto año anterior')
                            , T_TAL('090209','SITUACION ECONOMICO|Disminución del Ratio de Liquidez en un 50% respecto año anterior','Disminución del Ratio de Liquidez en un 50% respecto año anterior')
                            , T_TAL('090210','SITUACION ECONOMICO|Valor del Ratio de Liquidez entre 1 y 1,5','Valor del Ratio de Liquidez entre 1 y 1,5')
                            , T_TAL('090211','SITUACION ECONOMICO|Valor del Ratio de Liquidez entre 1,25 y 1','Valor del Ratio de Liquidez entre 1,25 y 1')
                            , T_TAL('090212','SITUACION ECONOMICO|Valor del Ratio de Liquidez menor o igual a 1','Valor del Ratio de Liquidez menor o igual a 1')
                            , T_TAL('090213','SITUACION ECONOMICO|Incremento del Ratio de Endeudamiento en un 10% respecto año anterior','Incremento del Ratio de Endeudamiento en un 10% respecto año anterior')
                            , T_TAL('090214','SITUACION ECONOMICO|Incremento del Ratio de Endeudamiento en un 30% respecto año anterior','Incremento del Ratio de Endeudamiento en un 30% respecto año anterior')
                            , T_TAL('090215','SITUACION ECONOMICO|Incremento del Ratio de Endeudamiento en un 50% respecto año anterior','Incremento del Ratio de Endeudamiento en un 50% respecto año anterior')
                            , T_TAL('090216','SITUACION ECONOMICO|Valor del Ratio de Endeudamiento entre 1,25 y 1,75','Valor del Ratio de Endeudamiento entre 1,25 y 1,75')
                            , T_TAL('090217','SITUACION ECONOMICO|Valor del Ratio de Endeudamiento entre 1,75 y 2,25','Valor del Ratio de Endeudamiento entre 1,75 y 2,25')
                            , T_TAL('090218','SITUACION ECONOMICO|Valor del Ratio de Endeudamiento mayor o igual a 2,25 o es negativo','Valor del Ratio de Endeudamiento mayor o igual a 2,25 o es negativo')
                            , T_TAL('090219','SITUACION ECONOMICO|Incremento del Periodo Medio de Cobro en un 10% respecto año anterior','Incremento del Periodo Medio de Cobro en un 10% respecto año anterior')
                            , T_TAL('090220','SITUACION ECONOMICO|Incremento del Periodo Medio de Cobro en un 30% respecto año anterior','Incremento del Periodo Medio de Cobro en un 30% respecto año anterior')
                            , T_TAL('090221','SITUACION ECONOMICO|Incremento del Periodo Medio de Cobro en un 50% respecto año anterior','Incremento del Periodo Medio de Cobro en un 50% respecto año anterior')
                            , T_TAL('090301','SITUACION ECONOMICO|Ratio Endeudamiento >= 1´25% y <= 1´75%','Ratio Endeudamiento >= 1´25% y <= 1´75%')
                            , T_TAL('090302','SITUACION ECONOMICO|Ratio Endeudamiento > 1´75% y <= 2´25%','Ratio Endeudamiento > 1´75% y <= 2´25%')
                            , T_TAL('090303','SITUACION ECONOMICO|Ratio Endeudamiento > 2´25%','Ratio Endeudamiento > 2´25%')
                            , T_TAL('090304','SITUACION ECONOMICO|Ratio Endeudamiento < 0','Ratio Endeudamiento < 0')
                            , T_TAL('090305','SITUACION ECONOMICO|Ratio de solvencia >= 1,25% y < 1,50%','Ratio de solvencia >= 1,25% y < 1,50%')
                            , T_TAL('090306','SITUACION ECONOMICO|Ratio de solvencia >1% y < 1´25%','Ratio de solvencia >1% y < 1´25%')
                            , T_TAL('090307','SITUACION ECONOMICO|Ratio de solvencia <= 1%','Ratio de solvencia <= 1%')
                            , T_TAL('090308','SITUACION ECONOMICO|Fondos Propios Negativos','Fondos Propios Negativos')
                           );
                                                         
                                   
 
                                                         
                                   
                                   
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_TAL T_TAL;
   V_TMP_GAL T_GAL;

   
BEGIN

--    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TAL_TIPO_ALERTA.');
--    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.TAL_TIPO_ALERTA');
                       
-- INSERTAMOS/UPDATEAMOS LOS VALORES EN LA TABLA GAL_GRUPO_ALERTA

   DBMS_OUTPUT.PUT_LINE('Creando GAL_GRUPO_ALERTA......');
   FOR I IN V_GAL.FIRST .. V_GAL.LAST
   LOOP

       V_TMP_GAL := V_GAL(I);

       -- Comprobamos si existe el codigo
       V_MSQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.GAL_GRUPO_ALERTA WHERE GAL_CODIGO ='''  || V_TMP_GAL(1) || '''';
       EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

	-- Si no existe --> INSERT
       IF v_column_count = 0 THEN
	   DBMS_OUTPUT.PUT_LINE('[INFO] Insertando - GAL_GRUPO_ALERTA ' ||  V_TMP_GAL(1));

           V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GAL_GRUPO_ALERTA.NEXTVAL FROM DUAL';
           EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      
           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAL_GRUPO_ALERTA (GAL_ID, GAL_CODIGO, GAL_DESCRIPCION,' ||
        'GAL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GAL(1)||''','''||SUBSTR(V_TMP_GAL(2),1,50)||''','''||SUBSTR(V_TMP_GAL(3),1,250)||''',
                 0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
    EXECUTE IMMEDIATE V_MSQL;
	-- Si existe --> UPDATE
	ELSE
     
	   DBMS_OUTPUT.PUT_LINE('[INFO] Updateando - GAL_GRUPO_ALERTA ' ||  V_TMP_GAL(1) || '-' || V_TMP_GAL(2)) ;
           V_MSQL := 'UPDATE '||V_ESQUEMA||'.GAL_GRUPO_ALERTA
                  SET GAL_DESCRIPCION = '''||SUBSTR(V_TMP_GAL(2),1,50)||'''
                     ,GAL_DESCRIPCION_LARGA =  ''' ||SUBSTR(V_TMP_GAL(3),1,250)|| '''  WHERE GAL_CODIGO = ''' || V_TMP_GAL(1) || '''' ;
                      
  
	   EXECUTE IMMEDIATE V_MSQL;  
	END IF;
  
END LOOP; 
   V_TMP_GAL := NULL;

   COMMIT; 
                       
                     
    DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GAL sin especificar');
    V_MSQL := 'SELECT GAL_ID 
               FROM '||V_ESQUEMA||'.GAL_GRUPO_ALERTA
               WHERE GAL_DESCRIPCION like ''%NO ESPECIFICADO%''';  
    
    EXECUTE IMMEDIATE V_MSQL INTO V_GAL_ID_DEFAULT  ;
    
/*    SELECT GAL_ID INTO V_GAL_ID 
    FROM GAL_GRUPO_ALERTA
    WHERE GAL_DESCRIPCION like '%NO ESPECIFICADO%';  */
    
    
    DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GRC sin especificar');
    V_MSQL := 'SELECT GRC_ID  
               FROM '||V_ESQUEMA||'.GRC_GRUPO_CARGA
               WHERE GRC_DESCRIPCION like ''%NO ESPECIFICADO%'''; 
    
    EXECUTE IMMEDIATE V_MSQL INTO V_GRC_ID;  
    
  /*****************************************************/
   /*** PENDIENTE CORRESPONDENCIA GAL_ID y GRC_ID  ******/
   /*****************************************************/   
   
   DBMS_OUTPUT.PUT_LINE('Creando TAL_TIPO_ALERTA......');
   FOR I IN V_TAL.FIRST .. V_TAL.LAST
   LOOP

  V_TMP_TAL := V_TAL(I);
  
	    --DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GAL');
    	V_MSQL := 'SELECT COUNT(1) 
        	     FROM '||V_ESQUEMA||'.GAL_GRUPO_ALERTA
        	     WHERE GAL_CODIGO = ''' || SUBSTR(V_TMP_TAL(1),1,2)||''''; 
       EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

       IF v_column_count = 0 THEN 
            V_GAL_ID := V_GAL_ID_DEFAULT;              
       ELSE
    	V_MSQL := 'SELECT GAL_ID 
        	     FROM '||V_ESQUEMA||'.GAL_GRUPO_ALERTA
        	     WHERE GAL_CODIGO = ''' || SUBSTR(V_TMP_TAL(1),1,2)||''''; 
            	EXECUTE IMMEDIATE V_MSQL INTO V_GAL_ID ;       
       END IF;
      --DBMS_OUTPUT.PUT_LINE('Obtenemos el id de GAL '|| V_GAL_ID);
    
      -- Comprobamos si existe el codigo
       V_MSQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.TAL_TIPO_ALERTA WHERE TAL_CODIGO ='''  || V_TMP_TAL(1) || '''';
       EXECUTE IMMEDIATE V_MSQL INTO v_column_count; 
       	-- Si no existe --> INSERT
       IF v_column_count = 0 THEN
	   DBMS_OUTPUT.PUT_LINE('[INFO] Insertando - TAL_TIPO_ALERTA ' ||  V_TMP_TAL(1));

	
       
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TAL_TIPO_ALERTA.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TAL := V_TAL(I);
      DBMS_OUTPUT.PUT_LINE('Creando TAL: '||V_TMP_TAL(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAL_TIPO_ALERTA (TAL_ID, TAL_CODIGO, GAL_ID, GRC_ID, TAL_DESCRIPCION,' ||
        'TAL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAL_PLAZO_VISIBILIDAD) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TAL(1)||''','''||V_GAL_ID||''',
                 '''||V_GRC_ID||''','''||SUBSTR(V_TMP_TAL(2),1,50)||''','''||SUBSTR(V_TMP_TAL(3),1,250)||''',
                 0,'''||V_USUARIO_CREAR||''',SYSDATE,0, 2592000000)';
      EXECUTE IMMEDIATE V_MSQL;
      ELSE
      	   DBMS_OUTPUT.PUT_LINE('[INFO] Updateando - TAL_TIPO_ALERTA ' ||  V_TMP_TAL(1));
           V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAL_TIPO_ALERTA
                  SET TAL_DESCRIPCION = '''|| SUBSTR(V_TMP_TAL(2),1,50) ||'''
                     ,TAL_DESCRIPCION_LARGA =  ''' || SUBSTR(V_TMP_TAL(3),1,250) || '''
                     ,GAL_ID = ' || V_GAL_ID || 
		    ',TAL_PLAZO_VISIBILIDAD = 2592000000 WHERE TAL_CODIGO = ''' || V_TMP_TAL(1) || '''' ;
                     EXECUTE IMMEDIATE V_MSQL;
      
    END IF;
   END LOOP; 
   V_TMP_TAL := NULL;
   
    

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

