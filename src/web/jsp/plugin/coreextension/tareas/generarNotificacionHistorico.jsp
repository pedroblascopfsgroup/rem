<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	var isConsulta = false;
	<c:if test="${isConsulta != null && isConsulta}">
		isConsulta = true;
	</c:if>

	
	var titulolabeltareaOriginal = new Ext.form.Label({
	    	text:'<s:message code="ext.comunicaciones.generarnotificacion.textoComunicacion" text="**Breve descripcion" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
	});
			
	var tituloPreguntaOrigen=new Ext.form.Label({
		text:'<s:message code="comunicaciones.generarnotificacion.preguntaorigen" text="**Pregunta Origen" />'
		,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
	});

	var labeltareaOriginal = new Ext.form.HtmlEditor({
			id:'htmlDescripcion'
			,readOnly:true
			,hideLabel:true
			,hideParent:true
			,enableColors: false
        	,enableAlignments: false
        	,enableFont:false
        	,enableFontSize:false
        	,enableFormat:false
        	,enableLinks:false
        	,enableLists:false
        	,enableSourceEdit:false
			,width:590
			,maxLength:3500
			,height : 100
			,value:'<s:message text="${data.descripcion}" javaScriptEscape="true" />'
			,html:''});
	
	var labelPreguntaOrigen = new Ext.form.HtmlEditor({
			id:'htmlDescripcionTareaAsociada'
			,readOnly:true
			,hideLabel:true
			,hideParent:true
			,enableColors: false
        	,enableAlignments: false
        	,enableFont:false
        	,enableFontSize:false
        	,enableFormat:false
        	,enableLinks:false
        	,enableLists:false
        	,enableSourceEdit:false
			,width:590
			,maxLength:3500
			,height : 100
			,value:'<s:message text="${data.descripcionTareaAsociada}" javaScriptEscape="true" />'
			,html:''});

	var tipoEntidad='${data.codigoTipoEntidad}';
	var descEstado = '${situacion}';
	var fechaCrear = '${fecha}';
	var codigoTipoEntidad = new Ext.form.Hidden({name:'codigoTipoEntidad', value :'${data.codigoTipoEntidad}'}) ;
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${data.idEntidad}'}) ;
	var subtipoTarea ;
	if(codigoTipoEntidad.getValue() == '2' || codigoTipoEntidad.getValue() == '1'){
		subtipoTarea = new Ext.form.Hidden({name:'subtipoTarea', value :'<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR_EXPTE" />'}) ;
	}
	else
		subtipoTarea = new Ext.form.Hidden({name:'subtipoTarea', value :'<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR" />'}) ;
	
	var idTareaAsociada = new Ext.form.Hidden({name:'idTareaAsociada', value :'${data.idTareaAsociada}'}) ;

	

	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";

	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'){
		strTipoEntidad="Cliente";
	}
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'){
		strTipoEntidad="Asunto";
	}
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'){
		strTipoEntidad="Expediente";
	}
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />','${data.idEntidad}');

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaCrear);
	
	
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,width:590
		,items:app.creaFieldSet([txtEntidad,txtSituacion,txtFechaCreacion])
		,autoHeight:true
	});
	
		var titulodescripcion = new Ext.form.Label({
	    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Breve descripcion" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
	<c:if test="${puedeResponder}">
		//Text Area
		
		var descripcion = new Ext.form.TextArea({
			width:590
			,hideLabel:true
			,height:100
			,maxLength:3500
			,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.respuesta" text="**Respuesta" />'
			,labelStyle:"font-weight:bolder"
			,name : 'descripcion'
			<app:test id="campoParaRespuesta" addComa="true"/>
		});
		
	</c:if>

	var items={ 
		border : false
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
			{ items : [
				panelDatosEntidad
				<c:if test="${muestraPreguntaOrigen}">
				,tituloPreguntaOrigen
				,labelPreguntaOrigen
				</c:if>
				,titulolabeltareaOriginal
				,labeltareaOriginal
				<c:if test="${puedeResponder}">
					,titulodescripcion
					,descripcion
				</c:if>
				//,chkLeida
				,idEntidad
				,codigoTipoEntidad
				,subtipoTarea
				,idTareaAsociada
				]
				, style : 'margin-right:15px' }
		]
	}

	//Si NO estamos en modo consulta ejecuta el flujo normal
	if (!isConsulta)
	{	
		<c:if test="${puedeResponder}">
			var panelEdicion = app.crearABMWindow(page , items);
		</c:if>
		<c:if test="${puedeResponder==false}">
			var panelEdicion = app.crearABMWindowConsulta(page , items);
		</c:if>
	}

	//Si estamos en modo consulta, creamos una ventana solo de consulta
	else
	{
		var panelEdicion = app.crearABMWindowConsulta(page , items);
	}	
	
</fwk:page>	