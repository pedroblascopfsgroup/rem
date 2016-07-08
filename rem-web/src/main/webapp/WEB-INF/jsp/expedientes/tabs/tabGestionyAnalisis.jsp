<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

	var labelStyle='font-weight:bolder;width:150px';
		
	var gestionesRealizadas=app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.gestiones" text="**Gestiones Realizadas"/>'
		,'<s:message text="${expediente.aaa.gestiones}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'gestiones'
		,{width:300,height:70}
	);
	
	//TODO: Rellenar con diccionario
	var causasImpago=new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.causasimpago" text="**Causa Impago" />'
		,value:'${expediente.aaa.causaImpago.descripcion}'
		,labelStyle:labelStyle
		,name:'causasImpago'
	});
		
	var comentarios= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
		,'<s:message text="${expediente.aaa.comentariosSituacion}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'comentariosSituacion'
		,{width:300,height:70}
	);
	
	var propuesta= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.propuesta" text="**Propuesta"/>'
		,'<s:message text="${expediente.aaa.propuestaActuacion}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'propuestaActuacion'
		,{width:300,height:70}
	);

	
	var tipoAyuda = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipoayuda" text="**Tipo Ayuda"/>'
		,name:'tipoAyudaDescripcion'
		,labelStyle:labelStyle
		,value:'${expediente.aaa.tipoAyudaActuacion.descripcion}'
	});

	var descAyuda= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descrcion Ayuda"/>'
		,'<s:message text="${expediente.aaa.descripcionTipoAyudaActuacion}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'descripcionTipoAyudaActuacion'
		,{width:300}
	);

	var tipoPropuestaActuacion = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipopropuestaactuacion" text="**Tipo Propuesta Actuación"/>'
		,name:'tipoPropuestaActuacion'
		,labelStyle:labelStyle
		,value:'${expediente.aaa.tipoPropuestaActuacion.descripcion}'
	});

	labelObs = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabgestion.revision.observaciones" text="**Observaciones:"/>'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var revision = new Ext.form.TextArea({
		name: 'revision'
		,value: '<s:message text="${expediente.aaa.revision}" javaScriptEscape="true" />'
		,width: 280
		,height: 340
		,labelStyle: labelStyle
		,style:'margin-top:5px'
		,readOnly: true
		,hideLabel: true
	});


	var formGyA = new Ext.form.FormPanel({
			border:false
			,autoHeight:true
			,items:[gestionesRealizadas
							,causasImpago
							,comentarios
							,tipoPropuestaActuacion
							,propuesta
							,tipoAyuda
							,descAyuda]
		});
		
	var formRevision = new Ext.form.FormPanel({
			border:false
			,autoHeight:true
			,items:[labelObs,revision]
		});

	var panelGestion = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.gestion" text="**Gestión"/>'
		,border:true
		,style:'padding:5px'
		,height:427
		,width:470
		,defaults : {border:false }
		,monitorResize: true
		,items:[    
			formGyA
		]
	});

	var panelRevision = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.revision" text="**Revisión"/>'
		,border:true
		,style:'padding:5px'
		,height:427
		,width:300
		,defaults : {border:false }
		,monitorResize: true
		,items:[formRevision]
	});

	var panel = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,layout:'table'
			,title:'<s:message code="expedientes.consulta.tabgestion.titulo" text="**Gestion y Analisis"/>'
			,layoutConfig:{columns:2}
			,titleCollapse:true
			,style:'margin-right:20px;margin-left:10px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelGestion]}
					,{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelRevision]}
			]
			,nombreTab : 'tabGestionyAnalisis'
	});

	var perfilGestor = '${expediente.idGestorActual}';
	var perfilSupervisor = '${expediente.idSupervisorActual}';
	
	<sec:authorize ifAllGranted="EDITAR_GYA">
	var btnEditarGyA = new Ext.Button({
           	text: '<s:message code="app.editar" text="**Editar" />'
           	,style:'margin-left:375px;'
           	,border:false
           	,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
           	,handler:function(){
				var w = app.openWindow({
					flow : 'expedientes/editaGestionyAnalisis'
					,width:650
					,title : '<s:message code="expedientes.consulta.tabgestion.edicion" text="**Editar Gestion Analisis y Propuesta" />' 
					,params : {id:'${expediente.aaa.id}'}
				});
				w.on(app.event.DONE, function(){
					w.close();
					refrescarGestionyAnalisis();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
         }
	});	
	</sec:authorize>

	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		if('${expediente.estadoExpediente.codigo}' != app.estExpediente.ESTADO_CONGELADO
           && '${expediente.estadoExpediente.codigo}' != app.estExpediente.ESTADO_CANCELADO) {
			var btnEditarRevision = new Ext.Button({
		           	text: '<s:message code="app.editar" text="**Editar" />'
		           	,style:'margin-left:200px;'
		           	,border:false
		           	,iconCls : 'icon_edit'
					,cls: 'x-btn-text-icon'
		           	,handler:function(){
						var w = app.openWindow({
							flow : 'expedientes/editaGestionyAnalisisRevision'
							,width:650
							,title : '<s:message code="expedientes.consulta.tabgestion.revision.edicion" text="**Editar Revisión de Gestion Analisis y Propuesta" />' 
							,params : {id:'${expediente.aaa.id}'}
						});
						w.on(app.event.DONE, function(){
							w.close();
							refrescarGestionyAnalisisRev();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });
		         }
			});
		}
	</sec:authorize>

	var refrescarGestionyAnalisis = function(){
		formGyA.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : '${expediente.id}'}
			});
	};

	var refrescarGestionyAnalisisRev = function(){
		formRevision.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : '${expediente.id}'}
			});
	};

	<sec:authorize ifAllGranted="EDITAR_GYA">
		if('${expediente.estadoExpediente.codigo }' == app.estExpediente.ESTADO_ACTIVO) {
			if(permisosVisibilidadGestorSupervisor(perfilGestor) == true
               || permisosVisibilidadGestorSupervisor(perfilSupervisor) == true) {
					panelGestion.items.add(btnEditarGyA);
			}
		}
	</sec:authorize>
	
	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		if('${expediente.estadoExpediente.codigo}' != app.estExpediente.ESTADO_CANCELADO
           && '${expediente.estadoExpediente.codigo}' != app.estExpediente.ESTADO_BLOQUEADO) {
				if('${expediente.estadoItinerario.codigo }' == app.estItinerario.ESTADO_RE) {
					if(permisosVisibilidadGestorSupervisor(perfilGestor) == true
	                   || permisosVisibilidadGestorSupervisor(perfilSupervisor) == true){
							panelRevision.items.add(btnEditarRevision);
					}
				}
		}
	</sec:authorize>

	return panel;
})()
