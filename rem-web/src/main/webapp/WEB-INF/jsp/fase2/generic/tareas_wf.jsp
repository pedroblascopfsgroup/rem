<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

var tipo_wf='${tipoWf}'




var items;
switch(tipo_wf){
	case '1':
		var dict = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
		var combo1=app.creaCombo({data:dict,fieldLabel:'combo1'});
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		items=[combo1,fecha1];
	break;
	case '2':
		var dict = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
		var combo1=app.creaCombo({data:dict,fieldLabel:'combo1',name:'combo1'});
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1',name:'fecha1'});
		//Nº de juzgado (TXT)  
		//Nº de procedimiento (TXT)
		var nroJuzgado		= app.creaInteger('nroJuzgado', '<s:message code="" text="**Nro. Juzgado" />' , '');
		var nroProcedimiento= app.creaInteger('nroProcedimiento', '<s:message code="" text="**Nro. Procedimiento" />' , '');
		items=[combo1,fecha1,nroJuzgado,nroProcedimiento];
	break;
	case '3':
		var dict = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
		var combo1=app.creaCombo({data:dict,fieldLabel:'combo1',name:'combo1'});
		var combo2=app.creaCombo({data:dict,fieldLabel:'combo2',name:'combo2'});
		var importe1	= app.creaNumber('importe1', '<s:message code="" text="**importe1" />' , '');
		items=[combo1,combo2,importe1];
	break;
	case '4':
		var dict = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
		var combo1=app.creaCombo({data:dict,fieldLabel:'combo1'});
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		var fecha2=new Ext.ux.form.XDateField({fieldLabel:'fecha2'});
		items=[combo1,fecha1,fecha2];
	break;
	case '5':
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		var fecha2=new Ext.ux.form.XDateField({fieldLabel:'fecha2'});
		items=[fecha1,fecha2];
	break;
	case '6':
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		items=[fecha1];
	break;
	case '7':
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		var fecha2=new Ext.ux.form.XDateField({fieldLabel:'fecha2'});
		var importe1	= app.creaNumber('importe1', '<s:message code="" text="**importe1" />' , '');
		items=[fecha1,fecha2,importe1];
	break;
	case '8':
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		var importe1	= app.creaNumber('importe1', '<s:message code="" text="**importe1" />' , '');
		var importe2	= app.creaNumber('importe2', '<s:message code="" text="**importe2" />' , '');
		items=[fecha1,importe1,importe2];
	break;
	case '9':
		var fecha1=new Ext.ux.form.XDateField({fieldLabel:'fecha1'});
		var importe1	= app.creaNumber('importe1', '<s:message code="" text="**importe1" />' , '');
		items=[fecha1,importe1];
	break;
	
}

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
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errL' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			//,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:items
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>