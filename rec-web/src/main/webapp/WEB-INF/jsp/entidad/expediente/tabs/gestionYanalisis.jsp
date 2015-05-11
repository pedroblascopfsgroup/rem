<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var labelStyle='font-weight:bolder;width:150px';
		
	var gestionesRealizadas=app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.gestiones" text="**Gestiones Realizadas"/>'
		,''
		,true
		,labelStyle
		,'gestiones'
		,{width:300,height:70}
	);
	
	//TODO: Rellenar con diccionario
	var causasImpago=new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.causasimpago" text="**Causa Impago" />'
		,value:''
		,labelStyle:labelStyle
		,name:'causasImpago'
	});
		
	var comentarios= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
		,''
		,true
		,labelStyle
		,'comentariosSituacion'
		,{width:300,height:70}
	);
	
	var propuesta= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.propuesta" text="**Propuesta"/>'
		,''
		,true
		,labelStyle
		,'propuestaActuacion'
		,{width:300,height:70}
	);

	
	var tipoAyuda = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipoayuda" text="**Tipo Ayuda"/>'
		,name:'tipoAyudaDescripcion'
		,labelStyle:labelStyle
		,value:''
	});

	var descAyuda= app.crearTextArea(
		'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descrcion Ayuda"/>'
		,''
		,true
		,labelStyle
		,'descripcionTipoAyudaActuacion'
		,{width:300}
	);

	var tipoPropuestaActuacion = new Ext.ux.form.StaticTextField({
		 fieldLabel:'<s:message code="expedientes.consulta.tabgestion.tipopropuestaactuacion" text="**Tipo Propuesta Actuación"/>'
		,name:'tipoPropuestaActuacion'
		,labelStyle:labelStyle
		,value:''
	});

	labelObs = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabgestion.revision.observaciones" text="**Observaciones:"/>'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var revision = new Ext.form.TextArea({
		name: 'revision'
		,value: ''
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
                    ,params : {id:entidad.getData("gestion").aaa}
                  });
                  w.on(app.event.DONE, function(){
                    w.close();
                    refrescarGestionyAnalisis();
                  });
                  w.on(app.event.CANCEL, function(){ w.close(); });
             }
	});	
	</sec:authorize>

	var btnEditarRevision;
	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		btnEditarRevision = new Ext.Button({
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
				  ,params : {id:entidad.getData("gestion.aaa")}
				});
				w.on(app.event.DONE, function(){
				  w.close();
				  refrescarGestionyAnalisisRev();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
		});
	</sec:authorize>

	var refrescarGestionyAnalisis = function(){
		formGyA.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : entidad.getData("id")}
			});
	};

	var refrescarGestionyAnalisisRev = function(){
		formRevision.load({
				url : app.resolveFlow('expedientes/tabGestionyAnalisisData')
				,params : {id : entidad.getData("id")}
			});
	};

	<sec:authorize ifAllGranted="EDITAR_GYA">
    panelGestion.items.add(btnEditarGyA);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="EDITAR_GYA_REV">
		panelRevision.items.add(btnEditarRevision);
	</sec:authorize>

  panel.getValue = function(){};

	panel.setValue = function(){
		gestionesRealizadas.setValue(entidad.getData("gestion.gestiones"));
		causasImpago.setValue(entidad.getData("gestion.causaImpago"));
		comentarios.setValue(entidad.getData("gestion.comentariosSituacion"));
		propuesta.setValue(entidad.getData("gestion.propuestaActuacion"));
		tipoAyuda.setValue(entidad.getData("gestion.tipoAyuda"));
		descAyuda.setValue(entidad.getData("gestion.descripcionTipoAyudaActuacion"));
		tipoPropuestaActuacion.setValue(entidad.getData("gestion.tipoPropuestaActuacion"));
		revision.setValue(entidad.getData("gestion.revision"));
		
		var perfilGestor = entidad.getData('gestion.idGestorActual');
		var perfilSupervisor = entidad.getData('gestion.idSupervisorActual');
		var estadoExpediente = entidad.getData('gestion.estadoExpediente');
		var estadoItinerario = entidad.getData('gestion.estadoItinerario');

		<sec:authorize ifAllGranted="EDITAR_GYA">
			if ((estadoExpediente == app.estExpediente.ESTADO_ACTIVO) &&
			   (permisosVisibilidadGestorSupervisor(perfilGestor) || permisosVisibilidadGestorSupervisor(perfilSupervisor) ) ) {
				btnEditarGyA.show();
			}else{
				btnEditarGyA.hide();
			}
		</sec:authorize>

		<sec:authorize ifAllGranted="EDITAR_GYA_REV">
			if (estadoExpediente != app.estExpediente.ESTADO_CONGELADO && estadoExpediente != app.estExpediente.ESTADO_CANCELADO){
				if ((estadoExpediente != app.estExpediente.ESTADO_CANCELADO && estadoExpediente != app.estExpediente.ESTADO_BLOQUEADO) && 
					(estadoItinerario==app.estItinerario.ESTADO_RE) && (permisosVisibilidadGestorSupervisor(perfilGestor) || permisosVisibilidadGestorSupervisor(perfilSupervisor) ) ){
					btnEditarRevision.show(); 
				}else{
					btnEditarRevision.hide(); 
				}
			}else{
				btnEditarRevision.hide();
			}
		</sec:authorize>
		
	  };

	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
   	}

	return panel;
})
