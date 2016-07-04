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

	var labelStyle2='font-weight:bolder;width:150px';
	
	function label(id,text){
		return app.creaLabel(text,"",  {id:'sancionar-'+id, labelStyle:labelStyle2});
	}
	
	function fieldset(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}
	
	var fechaElevacionSareb	= label('fechaElevacionSareb',	'<s:message code="expedientes.consulta.tabsancion.fecha.elevacion" text="**F. Elevación Sareb"/>');
	var fechaSancionSareb	= label('fechaSancionSareb',	'<s:message code="expedientes.consulta.tabsancion.fecha.sancion" text="**F. Sanción Sareb"/>');
	var nWorkflow	=  label('nWorkflow',	'<s:message code="expedientes.consulta.tabsancion.num.workflow" text="**Nº Workflow"/>');
	var decionSancion	= label('decionSancion',	'<s:message code="expedientes.consulta.tabsancion.decision" text="**Decisión"/>');
	
	labelObs = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabsancion.observaciones" text="**Observaciones:"/>'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var observaciones = new Ext.form.TextArea({
		name: 'observaciones'
		,value: ''
		,width: 350
		,height: 125
		,style:'margin-top:5px'
		,hideLabel: true
		,readOnly : true
	});
	
	btnModificar = new Ext.Button({
		text: '<s:message code="expedientes.consulta.tabsancion.btnModificar" text="**Modificar" />'
		,border:false
		,hidden : true
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:function(){
			var flow = 'mejexpediente/editar';
			var w = app.openWindow({
	             text:'<s:message code="plugin.mejoras.asuntos.cabecera.editar" text="**Editar" />'
				,flow: flow
				,width:850
				,title: '<s:message code="plugin.mejoras.asuntos.cabecera.editar" text="**Editar" />'
				,params:{
					id:entidad.get("data").sancion.idSancion
					,idExpediente:entidad.get("data").id
				}
			});
			w.on(app.event.DONE, function(){
				panel.el.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>','x-mask-loading');
				w.close();
				entidad.refrescar();
				panel.el.unmask();
			});
			w.on(app.event.CANCEL, function(){ 
				w.close(); 
			});
   	    }
	});

				     
	var formSancion = fieldset('<s:message code="expedientes.consulta.tabsancion.titulo" text="**Sancionar"/>',
		[{items:[<sec:authorize ifAllGranted="PERSONALIZACION-HY">fechaElevacionSareb, </sec:authorize> decionSancion, labelObs, observaciones]},
                 {items:[<sec:authorize ifAllGranted="PERSONALIZACION-HY">fechaSancionSareb, nWorkflow </sec:authorize>]}
	]);

	var panel = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,layout:'auto'
			,title:'<s:message code="expedientes.consulta.tabsancion.titulo" text="**Sancionar"/>'
			,layoutConfig:{columns:1}
			,style:'margin-right:20px;margin-left:10px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[formSancion,btnModificar]}
			]
			,nombreTab : 'tabSancionar'
	});
	
	panel.getValue = function(){};
	panel.setValue = function(){
		var data= entidad.get("data");
		decionSancion.setValue(data.sancion.descDecision == undefined ? '' : data.sancion.descDecision);
		fechaElevacionSareb.setValue(data.sancion.fechaElevacionSancion == undefined ? '' : data.sancion.fechaElevacionSancion);
		fechaSancionSareb.setValue(data.sancion.fechaSancion == undefined ? '' : data.sancion.fechaSancion);
		nWorkflow.setValue(data.sancion.numWorkFlowSancion == undefined ? '' : data.sancion.numWorkFlowSancion);
		observaciones.setValue(data.sancion.observaciones == undefined ? '' : data.sancion.observaciones);
		if(entidad.get("data").esGestorSupervisorActual && entidad.get("data").gestion.estadoItinerario == app.estItinerario.ESTADO_ITINERARIO_EN_SANCION){
			btnModificar.setVisible(true);
		}else{
			btnModificar.setVisible(false);
		}
	};
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente == app.tipoExpediente.TIPO_EXPEDIENTE_GESTION_DEUDA;
   	}
	 
	return panel;
})
