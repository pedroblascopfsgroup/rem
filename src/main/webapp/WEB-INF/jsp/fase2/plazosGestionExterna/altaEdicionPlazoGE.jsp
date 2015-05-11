<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var dictPlaza = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};


var comboPlazas=app.creaCombo({data:dictPlaza,fieldLabel:'<s:message code="plazos.plaza" text="**Plaza"/>',name:'plaza'});
var comboJuzgado=app.creaCombo({data:dictPlaza,fieldLabel:'<s:message code="plazos.juzgado" text="**Juzgado"/>', name: 'juzgado'});
var comboProcedimiento=app.creaCombo({data:dictPlaza,fieldLabel:'<s:message code="plazos.procedimiento" text="**Procedimiento"/>', name: 'procedimiento'});
var comboTarea=app.creaCombo({data:dictPlaza,fieldLabel:'<s:message code="plazos.tarea" text="**Tarea"/>', name: 'tarea' });
var txtDias = app.creaNumber('dias','<s:message code="plazos.dias" text="**Dias"/>', '' );



var btnGuardar = new Ext.Button({
	text : '<s:message code="app.guardar" text="**Guardar" />'
	,iconCls : 'icon_ok'
	,handler : function(){
		page.fireEvent(app.event.DONE);		
	}
});

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);  	
	}
});

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,bodyStyle:'padding:10px'
	,xtype:'fieldset'
	,items:[
		{ xtype : 'errorList', id:'errL' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:[comboPlazas,comboJuzgado,comboProcedimiento,comboTarea,txtDias]
					//,columnWidth:.5
				}
			]
		}
		
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>