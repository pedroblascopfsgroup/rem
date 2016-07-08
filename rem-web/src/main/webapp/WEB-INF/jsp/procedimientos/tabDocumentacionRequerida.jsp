<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

var panelDocumentacionRequerida=function(){

	var docPanel=new Ext.Panel({
		title:'<s:message code="procedimiento.documentacion.titulotexthtml" text="**Documentacion requerida" />'
		,height:300
		//,width:400
		,autoWidth:true
        ,autoScroll:true
		,html:'<s:message text="${procedimiento.tipoProcedimiento.html}" javaScriptEscape="true" />'
	});

	var fechaRecopilacion = new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="procedimiento.documentacion.fechaRecopilacion" text="**Fecha recopilación" />'
		<app:test id="fechaRecopilacion" addComa="true" />
		,labelStyle:'font-weight:bolder;width:250px'
		,name:'fechaRecopilacion'
		,value:'<fwk:date value='${procedimiento.fechaRecopilacion}' />'
	});

	var fechaRecepcionDocumentacion = new Ext.ux.form.StaticTextField({
		fieldLabel:'<s:message code="procedimiento.documentacion.fechaRecepcionDocumentacion" text="**Fecha recopilación" />'
		<app:test id="fechaRecepcionDocumentacion" addComa="true" />
		,labelStyle:'font-weight:bolder;width:250px'
		,name:'fechaRecepcionDocumentacion'
		,value:'<fwk:date value='${procedimiento.asunto.fechaRecepDoc}' />'
	});
	
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
	,style:'font-weight:bolder; font-size:11'
	}); 
	var observacionesRecopilacion = new Ext.form.TextArea({
			fieldLabel:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
			<app:test id="observacionesRecopilacion" addComa="true" />
			,name: 'observacionesRecopilacion'
			,hideLabel:true
			,value:'<s:message javaScriptEscape="true" text="${procedimiento.observacionesRecopilacion}" />'
			,width: 710
			,height:200
			//,autoWidth:true
			,maxLength: 500
			,readOnly:true
			,labelStyle:'font-weight:bolder'
	});

	var btnEditar=new Ext.Button({
		text:'<s:message code="procedimiento.documentacion.recopilada" text="**Recopilada" />'
		,iconCls:'icon_edit'
		,handler:function(){
			var w = app.openWindow({
				flow:'procedimientos/recopilarDocProcedimiento'
				,closable:true
				,title : '<s:message code="procedimiento.documentacion.modificarRecopilacion" text="**Modificar información recopilación" />'
				,params:{idProcedimiento:'${procedimiento.id}'}
			});
			w.on(app.event.DONE, function(){
					w.close();
					refrescar();
			});
			w.on(app.event.CANCEL, function(){ 
					w.close(); 
			});
        }
	});
	
	var panelCampos = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[{
				layout : 'table'
				,layoutConfig:{columns:2}
				,border : false
				,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop', bodyStyle: 'padding:2px'}
				,items:[
						{ items : fechaRecopilacion ,columnWidth:.5}
						,{ items : fechaRecepcionDocumentacion ,columnWidth:.5}
						,{items:tituloobservaciones,colspan:2}
						,{items:observacionesRecopilacion,colspan:2}
                    
                  ]
			}
          ]
	});



	var panelRecopilacion = new Ext.form.FieldSet({
		title:'<s:message code="procedimiento.documentacion.informacionRecopilacion" text="**Información de recopilación" />'
		,border:true
		,autoHeight:true
		,autoWidth:true
		,defaults : {border:false }
		,monitorResize: true
		,items:[    
			{items:panelCampos}
			<c:if test="${esSupervisor}">
				,{items: btnEditar}
			</c:if>
		]
	});

	var refrescar = function(){
		panelCampos.load({
			url : app.resolveFlow('procedimientos/recopilarDocProcedimientoData')
			,params : {idProcedimiento:'${procedimiento.id}'}
		});
	};

	var panel=new Ext.Panel({
		autoHeight:true
		,title:'<s:message code="procedimiento.documentacion.titulo" text="**Documentacion" />'
		,bodyStyle:'padding:10px'
		,xtype:'fieldset'
		,style:'padding-right:10px'
		,items: [ docPanel, panelRecopilacion ]
	});	

	return panel;

}
