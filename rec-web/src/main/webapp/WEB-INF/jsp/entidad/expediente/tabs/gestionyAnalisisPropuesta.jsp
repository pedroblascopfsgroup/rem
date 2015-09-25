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

	<%@ include file="/WEB-INF/jsp/acuerdos/actuacionesRealizadasAcuerdo.jsp" %>
	var actuacionesRealizadas=crearActuacionesRealizadas();
	
	<%@ include file="/WEB-INF/jsp/acuerdos/actuacionesAExplorarAcuerdo.jsp" %>
	var actAExpl = crearActuacionesAExplorar();

	var labelStyle='font-weight:bolder;width:150px';
	
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

	var panelGyA = new Ext.Panel({
		style:'padding: 5px'
		,defaults:{
		    style:'margin:5px'
		}
		,border : false
		,autoHeight:true 
		,autoWidth:true
	      ,items:[actuacionesRealizadas, actAExpl]
	   });
	
	var formGestion = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[tipoAyuda, descAyuda, causasImpago, comentarios]
	});

	var panelGestion = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.consulta.tabgestion.revision" text="**Revisión"/>'
		,border:true
		,style:'padding:5px'
		,height:427
		,width:450
		,defaults : {border:false }
		,monitorResize: true
		,items:[formGestion]
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
						,items:[panelGyA]}
					,{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelGestion]}
			]
			,nombreTab : 'tabGestionyAnalisis'
	});

	return panel;
})
