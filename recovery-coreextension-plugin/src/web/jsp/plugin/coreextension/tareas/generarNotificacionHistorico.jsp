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
	
	var fechaVencimiento='';
	var motivo= '';
	var fechaPropuesta='';
	var destareaOri='';
	var tarea = '${tarea}';
	var idProrroga = '${idProrroga}';
	var descriTareaOri= '${data.descripcion}';

	
	
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaVencimiento = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechavencimiento" text="**fecha Vencimiento" />', fechaVencimiento);
	var motivoSolicitud=app.creaLabel('<s:message code="decisionprorroga.motivo" text="**motivo  prorroga" />',motivo);
	var fechaPropuestaLabel=app.creaLabel('<s:message code="decisionprorroga.fecha" text="**Nueva Fecha propuesta" />',fechaPropuesta);
	var descripcionTareaOriginal=app.creaLabel('<s:message code="comunicaciones.generarnotificacion.descripcionentidad" text="**Descripcion" />',descriTareaOri);
	//textfield que va a contener la descripcion de la entidad

	var detalleTareaOriginal = new Ext.form.TextArea({
		width:300
		,fieldLabel:'<s:message code="decisionprorroga.detalle" text="**detalle" />'
		,labelStyle:"font-weight:bolder"
		,readOnly:true
		,value: '<s:message text="${destareaOri}" javaScriptEscape="true" />'
	});
	
	if((tarea=='Petición de prorroga' || tarea=='Respuesta de prorroga') && idProrroga!='' && idProrroga!=null){
		
		Ext.Ajax.request({
			    	url: page.resolveUrl('bpm/buscarDatosProrroga')
			        ,params: {id: idProrroga}
			        ,success: function(result, request){ 
			         	var r2 = Ext.util.JSON.decode(result.responseText);
			         	if(r2.datos.fechaVencimientoOriginal!=''){
			         		var fechaVencimientoTareaOriginal= r2.datos.fechaVencimientoOriginal.split(' ')[0];
			            	f2= fechaVencimientoTareaOriginal.split('-');
			            	var fVencimientoFinal= f2[2]+"/"+f2[1]+"/"+f2[0];
			         	}
			         	else{
			         		var fVencimientoFinal='';
			         	}
			         	
			            
			            var fechaPropuesta= r2.datos.fechaPropuesta;
			            var motivo= r2.datos.motivo;
			            var destareaOri= r2.datos.destareaOri;
			            var resolucion= r2.datos.respuestaProrroga;
						var observacionesRespuesta= r2.datos.observacionesRespuesta;
						if(resolucion==null || resolucion==''){
							resolucion= 'Pendiente';
						}
			            
			            
			            txtFechaVencimiento.setValue(fVencimientoFinal);
			            motivoSolicitud.setValue(r2.datos.motivo);
			            fechaPropuestaLabel.setValue(r2.datos.fechaPropuesta);
			            detalleTareaOriginal.setValue(r2.datos.destareaOri);
			            aprobada.setValue(resolucion);
			            descrRespuestaProrroga.setValue(observacionesRespuesta);
			            
			            
			                    	
					}
	   			});	
		
	}
	

	
	
	
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
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'){
		strTipoEntidad="Procedimiento";
	}
	
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />','${idProcedimiento}');

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaCrear);
	
	
	<c:if test="${(tarea=='Petición de prorroga' || tarea=='Respuesta de prorroga')}">

		
		var descrRespuestaProrroga = new Ext.form.TextArea({
			width:300
			,fieldLabel:'<s:message code="decisionprorroga.detalle" text="**detalle" />'
			,labelStyle:"font-weight:bolder"
			,readOnly:true
			,value: ''
		});
		
		var aprobada=app.creaLabel('<s:message code="decisionprorroga.resolucion" text="**Resolucion" />','');		
		
		var fieldSetResolucion = new Ext.form.FieldSet({
			title:'<s:message code="decisionprorroga.respuesta" text="**Respuesta" />'
			,items:[aprobada,descrRespuestaProrroga]
			,autoHeight:true
			,autoWidth:true
		});
		
		
		
	</c:if>
	
	var panelDatosEntidadProrroga = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,items:[txtEntidad,descripcionTareaOriginal,txtSituacion,txtFechaVencimiento]
		,autoHeight:true
		,autoWidth:true
	});
	
	var panelDatosProrroga = new Ext.form.FieldSet({
		title:'<s:message code="decisionprorroga.datosprorroga" text="**Solicitud de prorroga" />'
		,items:[motivoSolicitud,fechaPropuestaLabel,detalleTareaOriginal]
		,autoHeight:true
		,autoWidth:true
	});
	
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,width:590
		,items:app.creaFieldSet([
			
			<c:if test="${(tarea=='Petición de prorroga' || tarea=='Respuesta de prorroga')}">
				txtEntidad
				,descripcionTareaOriginal
				,txtSituacion
				,txtFechaVencimiento
			</c:if>
			<c:if test="${(tarea!='Petición de prorroga' && tarea!='Respuesta de prorroga')}">
				txtEntidad
				,txtSituacion
				,txtFechaCreacion
			</c:if>

		])
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
				<c:if test="${(tarea=='Petición de prorroga' || tarea=='Respuesta de prorroga')}">
					,panelDatosProrroga
					,fieldSetResolucion
				</c:if>
				<c:if test="${muestraPreguntaOrigen}">
					,tituloPreguntaOrigen
					,labelPreguntaOrigen
				</c:if>
				<c:if test="${(tarea!='Petición de prorroga' && tarea!='Respuesta de prorroga')}">
					,titulolabeltareaOriginal
					,labeltareaOriginal
				</c:if>
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