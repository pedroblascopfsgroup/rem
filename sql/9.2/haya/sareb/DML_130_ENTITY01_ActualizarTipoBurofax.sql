--/*
--##########################################
--## AUTOR=PedroBlasco
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2094
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las plantillas de los burofax
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_DDNAME VARCHAR2(30):= 'DD_PCO_BFT_TIPO';

    
BEGIN
	
DBMS_OUTPUT.PUT_LINE('[INICIO] Borramos la plantilla anterior');

V_SQL := 'UPDATE ' || V_ESQUEMA || '.' || V_DDNAME || ' SET DD_PCO_BFT_PLANTILLA = ''${nombre} ${apellido1} ${apellido2}<br /><br />${domicilio}<br /> ' || 
'<br /><br /><br />En Madrid, a ${FECHA_ACTUAL}<br /><br />Muy Sres. Nuestros,<br /><br />Les remitimos la presente comunicación, ' ||
'en su condición de ${tipoIntervencion} del Préstamo Hipotecario/Crédito/Préstamo número ${numeroContrato}, otorgado entre ${entidadOrigen}, en calidad de Prestamista, y ${TITULAR_ORDEN_MENOR_CONTRATO}, ' ||
'en calidad de Prestatario, en fecha #DIA_ESCRITURA_DOCUMENTO_VINCULADO# de #MES_ESCRITURA_DOCUMENTO_VINCULADO# de #ANYO_ESCRITURA_DOCUMENTO_VINCULADO#, ante el Notario de #LOCALIDAD_NOTARIO_DOCUMENTO_VINCULADO# , ' ||
'D. #NOTARIO_DOCUMENTO_VINCULADO#, bajo el número #PROTOCOLO_DOCUMENTO_VINCULADO# de su protocolo, y (en su caso) sus sucesivas novaciones.<br /><br />El indicado Préstamo Hipotecario/Crédito/Préstamo, ' ||
'tal y como se les ha informado con anterioridad, fue transmitido a la Sociedad de Gestión de Activos Procedentes de la Reestructuración Bancaria, (“SAREB”) en cumplimiento de la Ley 9/2012, de 14 de noviembre, ' ||
'de Reestructuración y Resolución de entidades de crédito y el Real Decreto 1559/2012, de 15 de noviembre.<br /><br />Dado el incumplimiento de los pagos a que resulta obligado según el referido Préstamo ' ||
'Hipotecario/Crédito/Préstamo, ponemos en su conocimiento que, de conformidad a lo pactado, hemos procedido a dar por vencido anticipadamente dicho Préstamo Hipotecario/Crédito/Préstamo, siendo exigible, por tanto, ' ||
'la totalidad de las cantidades adeudadas. (Este párrafo solo procederá en caso de que la operación no se encuentre totalmente vencida)<br /><br />A los efectos previstos en los artículos 572 y 573 de la ' ||
'Ley 1/2000 de 7 de enero, le notificamos, que el indicado Préstamo Hipotecario/Crédito/Préstamo, a fecha ${FECHA_CIERRE_LIQUIDACION}, presenta un saldo exigible a favor de SAREB, de ${TOTAL_LIQUIDACION_LETRA} ' ||
'(${TOTAL_LIQUIDACION} €), que devenga intereses de demora al tipo pactado desde la fecha de cierre hasta su definitivo pago, sin perjuicio de las costas y gastos imputables que puedan devengarse.<br /><br /><br />' ||
'<br />Por lo anterior, le requerimos para que efectúe el pago de dicha deuda líquida, vencida y exigible en el plazo improrrogable de 10 días naturales (salvo plazo especial pactado) desde la fecha de notificación ' ||
'del presente.<br /><br />En caso de no satisfacer el citado pago en el plazo indicado, Sareb iniciará todas las aquellas acciones legales que sean precisas para el cobro de las cantidades adeudadas y ' ||
'cualesquiera otras que nos asistan para su reclamación o ejecución.'' ' ||
' WHERE DD_PCO_BFT_CODIGO LIKE ''REQ-PAGO''';
EXECUTE IMMEDIATE V_SQL;

V_SQL := 'UPDATE ' || V_ESQUEMA || '.' || V_DDNAME || ' SET DD_PCO_BFT_PLANTILLA = ''${nombre} ${apellido1} ${apellido2}<br /><br />${domicilio}<br /> ' || 
'<br /><br /><br />En Madrid, a ${FECHA_ACTUAL}<br /><br />Muy Sres. Nuestros,<br /><br />Les remitimos la presente comunicación, ' || 
'en su condición de hipotecante no deudor del Préstamo Hipotecario/Crédito/Préstamo número ${numeroContrato}, otorgado entre ${entidadOrigen}, en calidad de Prestamista, y ${TITULAR_ORDEN_MENOR_CONTRATO}, ' || 
'en calidad de Prestatario, en fecha #DIA_ESCRITURA_DOCUMENTO_VINCULADO# de #MES_ESCRITURA_DOCUMENTO_VINCULADO# de #ANYO_ESCRITURA_DOCUMENTO_VINCULADO#, ante el Notario de #LOCALIDAD_NOTARIO_DOCUMENTO_VINCULADO#, ' || 
'D. #NOTARIO_DOCUMENTO_VINCULADO#, bajo el número #PROTOCOLO_DOCUMENTO_VINCULADO# de su protocolo, y (en su caso) sus sucesivas novaciones.<br /><br />El indicado Préstamo Hipotecario/Crédito/Préstamo, ' || 
'tal y como se les ha informado con anterioridad, fue transmitido a la Sociedad de Gestión de Activos Procedentes de la Reestructuración Bancaria, (“SAREB”) en cumplimiento de la Ley 9/2012, de 14 de noviembre, ' || 
'de Reestructuración y Resolución de entidades de crédito y el Real Decreto 1559/2012, de 15 de noviembre.<br /><br />Dado el incumplimiento de los pagos a que resulta obligado según el referido ' || 
'Préstamo Hipotecario/Crédito/Préstamo, ponemos en su conocimiento que, de conformidad a lo pactado, hemos procedido a dar por vencido anticipadamente dicho Préstamo Hipotecario/Crédito/Préstamo, siendo exigible, ' || 
'por tanto, la totalidad de las cantidades adeudadas. (Este párrafo solo procederá en caso de que la operación no se encuentre totalmente vencida)<br /><br />A los efectos previstos en los artículos ' || 
'572 y 573 de la Ley 1/2000 de 7 de enero, le notificamos, que el indicado Préstamo Hipotecario/Crédito/Préstamo, a fecha ${FECHA_CIERRE_LIQUIDACION}, presenta un saldo exigible a favor de SAREB, ' || 
'de ${TOTAL_LIQUIDACION_LETRA} (${TOTAL_LIQUIDACION} €), que devenga intereses de demora al tipo pactado desde la fecha de cierre hasta su definitivo pago, sin perjuicio de las costas y gastos imputables que puedan ' || 
'devengarse.<br /><br />Por lo anterior, le notificamos del requerimiento efectuado a los acreditados  para que efectúen el pago de dicha deuda líquida, vencida y exigible en el plazo improrrogable de ' || 
'10 días naturales (salvo plazo especial pactado) desde la fecha de notificación del presente.<br /><br />En caso de no satisfacer el citado pago en el plazo indicado, Sareb iniciará todas las aquellas ' || 
'acciones legales que sean precisas para el cobro de las cantidades adeudadas y cualesquiera otras que nos asistan para su reclamación o ejecución.'' ' ||
' WHERE DD_PCO_BFT_CODIGO LIKE ''NOT-HIP-NODEUDOR''';
EXECUTE IMMEDIATE V_SQL;


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

