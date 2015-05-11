<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

new Ext.Button({
    text:'<s:message code="asunto.boton.generacion.plantilla" text="**Generar Escritos"/>'
    ,iconCls:'icon_comite_actas'
	,menu : {
      	items: [
		    {text:'<s:message code="asunto.boton.generacion.plantilla.CESION_CREDITO" text="**Cesión Crédito"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	var idAsunto=data.id;
		    	var plantilla='CESION_CREDITO';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.DESGLOSE" text="**Desglose"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	var idAsunto=data.id;
		    	var plantilla='DESGLOSE';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ENVIO_MDTO_EXHORTO" text="**Envío mandamiento por exhorto"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ENVIO_MDTO_EXHORTO';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ESCRITO_NOCTURNAS" text="**Escrito habilitando horas nocturnas"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ESCRITO_NOCTURNAS';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.SOL_COM_EDICTOS_ETJ" text="**Solicitud comunicación por edictos ETJ"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='SOL_COM_EDICTOS_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.NUEV_AVERIG_ETJ" text="**Solicitud nueva averiguación ETJ"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='NUEV_AVERIG_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ESCRITO_EMBARGO" text="**Escrito de Embargo"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ESCRITO_EMBARGO';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ESCRITO_AV_DNI_NUEV_AB_ETJ" text="**Escrito averiguación DNI y nueva AB"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ESCRITO_AV_DNI_NUEV_AB_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ARCHIVO_LEV_EB_ETJ" text="**Archivo y levantamiento EB"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ARCHIVO_LEV_EB_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.LEVANT_SUSP" text="**Alzamiento de suspensión"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='LEVANT_SUSP';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		     {text:'<s:message code="asunto.boton.generacion.plantilla.ACLARACION_CUANTIA" text="**Aclaración de cuantía"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ACLARACION_CUANTIA';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.DEMANDA_MONITORIO" text="**Demanda de procedimiento monitorio"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='DEMANDA_MONITORIO';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.DEMANDA_ETJ" text="**Demanda de procedimiento de ejecución"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='DEMANDA_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.DEMANDA_ETJ_BARNEY" text="**Demanda de procedimiento de ejecución (BARNEY)"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='DEMANDA_ETJ_BARNEY';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.CERTIF_DOBLE_CESION" text="**Certificado de doble cesión"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='CERTIF_DOBLE_CESION';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.CERTIFICADO_DEUDA" text="**Certificado de deuda"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='CERTIFICADO_DEUDA';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.INGRESO_CUANTIA" text="**Ingreso de cuantía consignada"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='INGRESO_CUANTIA';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.LIBRAR_OFC_LOCAL" text="**Librar oficios para localización"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='LIBRAR_OFC_LOCAL';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.REQ_DOMICILIO_LABORAL" text="**Requerimiento en domicilio laboral"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='REQ_DOMICILIO_LABORAL';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.REQ_OTROS_DOMICILIO" text="**Requerimiento en otros domicilios"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='REQ_OTROS_DOMICILIO';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.SOL_DEC_FIN_MONIT" text="**Solicitud decreto que pone fin a monitorio"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='SOL_DEC_FIN_MONIT';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.ACREDIT_TITUL_CUENT" text="**Acreditar titularidad de cuenta"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='ACREDIT_TITUL_CUENT';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		    ,
		    {text:'<s:message code="asunto.boton.generacion.plantilla.COMUNIC_PAGOS_ETJ" text="**Comunicación de pagos"/>'
		    ,iconCls:'icon_comite_actas'
		    ,handler: function() {
		    	//debugger;
		    	var idAsunto=data.id;
		    	var plantilla='COMUNIC_PAGOS_ETJ';
				var flow='/pfs/geninfvisorinforme/generarEscritoEditable';
            	var params = {idAsunto:idAsunto, plantilla:plantilla};
            	app.openBrowserWindow(flow,params);	       
		    }}
		]
	}
})
            