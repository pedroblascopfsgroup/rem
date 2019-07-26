--/*
--##########################################
--## AUTOR=Carles Molins Pascual
--## FECHA_CREACION=20190725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4826
--## PRODUCTO=NO
--##
--## Finalidad: Script para añadir comentarios en las columnas de las tablas del array
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		--			TABLA 						, COLUMNA 	, COMENTARIO   
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','ACT_ID','Identificador único del activo.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_CHECK_ANULACION','Check indicador si está anulado'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_COMPRADOR_APELLIDO1','Apellido1 del comprador'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_COMPRADOR_APELLIDO2','Apellido2 del comprador'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_COMPRADOR_NIF','NIF del comprador'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_COMPRADOR_NOMBRE','Nombre del comprador'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_FECHA_ANULACION','Fecha anulación GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_FECHA_COMUNICACION','Fecha comunicación GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_FECHA_PREBLOQUEO','Fecha prebloqueo GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_FECHA_PREV_SANCION','Fecha prevista sanción GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_FECHA_SANCION','Fecha sanción GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','DD_ECG_ID','Identificador único estado comunicación GENCAT.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','DD_SAN_ID','Identificador único estado sanción GENCAT.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_CMG_COMUNICACION_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','ACT_ID','Identificador único del activo.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','DD_ECG_ID','Identificador único estado comunicación GENCAT.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','DD_SAN_ID','Identificador único estado sanción GENCAT.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_CHECK_ANULACION','Check indicador si está anulado'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_COMPRADOR_APELLIDO1','Apellido1 del comprador'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_COMPRADOR_APELLIDO2','Apellido2 del comprador'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_COMPRADOR_NIF','NIF del comprador'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_COMPRADOR_NOMBRE','Nombre del comprador'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_ANULACION','Fecha anulación GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_COMUNICACION','Fecha comunicación GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_FIN','Fecha en la que finaliza el proceso de GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_INI','Fecha en la que se inicia el proceso de GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_PREBLOQUEO','Fecha prebloqueo GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_PREV_SANCION','Fecha prevista sanción GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_FECHA_SANCION','Fecha sanción GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','HCG_ID','Identificador único de la tabla del histórico de GENCAT'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_HCG_HIST_COM_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('DD_SAN_SANCION','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('DD_SAN_SANCION','DD_SAN_CODIGO','Código identificador único del estado de la sanción de GENCAT'),
		T_FUNCION('DD_SAN_SANCION','DD_SAN_DESCRIPCION','Descripción del estado de la sanción de GENCAT'),
		T_FUNCION('DD_SAN_SANCION','DD_SAN_DESCRIPCION_LARGA','Descripción larga del estado de la sanción de GENCAT'),
		T_FUNCION('DD_SAN_SANCION','DD_SAN_ID','Identificador único estado sanción GENCAT.'),
		T_FUNCION('DD_SAN_SANCION','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('DD_SAN_SANCION','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('DD_SAN_SANCION','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('DD_SAN_SANCION','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('DD_SAN_SANCION','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('DD_SAN_SANCION','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('DD_SAN_SANCION','VERSION','Indica la versión del registro.'),

		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','DD_ECG_CODIGO','Código identificador único del estado de la comunicación de GENCAT'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','DD_ECG_DESCRIPCION','Descripción del estado de la comunicación de GENCAT'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','DD_ECG_DESCRIPCION_LARGA','Descripción larga del estado de la comunicación de GENCAT'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','DD_ECG_ID','Identificador único estado comunicación GENCAT.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('DD_ECG_ESTADO_COM_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','DD_TDN_CODIGO','Código identificador único del estado de la sanción de GENCAT'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','DD_TDN_DESCRIPCION','Descripción del estado de la sanción de GENCAT'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','DD_TDN_DESCRIPCION_LARGA','Descripción larga del estado de la sanción de GENCAT'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','DD_TDN_ID','Identificador único del estado de la sanción de GENCAT'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('DD_TDN_TIPO_DOCUMENTO','VERSION','Indica la versión del registro.'),

		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','ADG_FECHA_ENVIO_COMUNICA','Fecha envío comunicación adecuación GENCAT'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','ADG_FECHA_REVISION','Fecha envío revisión adecuación GENCAT'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','ADG_ID','Identificador único adecuación GENCAT'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','ADG_IMPORTE','Importe adecuación GENCAT'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','ADG_REFORMA','Booleano indicando si es necesaria reforma'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_ADG_ADECUACION_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('ACT_OFG_OFERTA_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','DD_SIP_ID','Identificador único diccionario situación posesoria del activo'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','DD_TPE_ID','Identificador único diccionario tipo de persona'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','OFG_ID','Identificador único oferta GENCAT'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','OFG_IMPORTE','Importe oferta GENCAT'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','OFR_ID','Identificador único de la oferta'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','OFR_ID_ANT','Identificador único de la oferta anterior'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_OFG_OFERTA_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('ACT_VIG_VISITA_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','FECHA_ENVIO_SOLICITUD','Fecha envío solicitud visita GENCAT'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','FECHA_RECEPCION_ALTA','Fecha recepción alta visita GENCAT'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','ID_LEAD_SF','ID de la visita en Salesforce'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','VERSION','Indica la versión del registro.'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','VIG_ID','Identificador único visita GENCAT'),
		T_FUNCION('ACT_VIG_VISITA_GENCAT','VIS_ID','Identificador único visita'),

		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','ADC_ID','Código identificador único del adjunto de la comunicacion.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','ADC_ID_SANCION','Código identificador único del adjunto de la comunicacion de la sanción.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','DD_NOG_ID','Identificador único diccionario notificación GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','NOG_CHECK_NOTIFICATION','Check identificador de notificación GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','NOG_FECHA_CIERRE_NOTIFICATION','Fecha cierre notificación GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','NOG_FECHA_NOTIFICATION','Fecha notificación GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','NOG_FECHA_SANCION_NOTIFICATION','Fecha notificación sanción GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','NOG_ID','Identificador único tabla notificaciones GENCAT'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_NOG_NOTIFICACION_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','DD_NOG_CODIGO','Identificador de código único diccionario notificación GENCAT'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','DD_NOG_DESCRIPCION','Descripción diccionario notificación GENCAT'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','DD_NOG_DESCRIPCION_LARGA','Descripción larga diccionario notificación GENCAT'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','DD_NOG_ID','Identificador único diccionario notificación GENCAT'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('DD_NOG_NOTIFICACION_GENCAT','VERSION','Indica la versión del registro.'),

		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','BORRADO','Indica si el registro se encuentra borrado de manera lógica'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','CMG_ID','Identificador único tabla comunicación GENCAT'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','FECHABORRAR','Indica la fecha en la que se borró el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','FECHACREAR','Indica la fecha en la que se creó el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','FECHAMODIFICAR','Indica la fecha en la que se modificó el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','RCG_FECHA_AVISO','Fecha aviso reclamación GENCAT'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','RCG_FECHA_RECLAMACION','Fecha reclamación GENCAT'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','RCG_ID','Identificador único tabla reclamaciones GENCAT'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','USUARIOBORRAR','Indica el usuario que borró el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','USUARIOCREAR','Indica el usuario que creó el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','USUARIOMODIFICAR','Indica el usuario que modificó el registro.'),
		T_FUNCION('ACT_RCG_RECLAMACION_GENCAT','VERSION','Indica la versión del registro.'),
		
		T_FUNCION('ACT_PAL_PROMOCION_ALQUILER','AGR_ID','Código identificador único de la agrupación.'),
		T_FUNCION('ACT_PAL_PROMOCION_ALQUILER','DD_PRV_ID','Código identificador único de la provincia.'),
		T_FUNCION('ACT_PAL_PROMOCION_ALQUILER','DD_LOC_ID','Código identificador único de la localidad.'),
		T_FUNCION('ACT_PAL_PROMOCION_ALQUILER','PAL_DIRECCION','Dirección promoción de alquiler'),
		T_FUNCION('ACT_PAL_PROMOCION_ALQUILER','PAL_CP','Código postal promoción de alquiler')
		
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||TRIM(V_TMP_FUNCION(1))||'.'||TRIM(V_TMP_FUNCION(2))||' IS '''||TRIM(V_TMP_FUNCION(3))||''' ';
        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIDO COMENTARIO PARA LA TABLA '''||TRIM(V_TMP_FUNCION(1))||''' COLUMNA '''||TRIM(V_TMP_FUNCION(2))||'''');

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
  COMMIT;
   
EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
