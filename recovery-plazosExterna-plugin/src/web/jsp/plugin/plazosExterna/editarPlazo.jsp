<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	var labelStyle='width:120px';
	var idTareaProcedimientoRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);
	
	var idTareaProcedimientoStore = page.getStore({
		flow:'plugin.plazosExterna.buscarTareasProcedimiento'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'idTareaProc'
		},idTareaProcedimientoRecord)
	});
	
	var idTareaProcedimiento =new Ext.form.ComboBox({
		store: idTareaProcedimientoStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,labelStyle:labelStyle
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.plazosExterna.editarPlazo.tareas" text="**Tareas" />'
		,width:300
		,value:'${plazo.tareaProcedimiento.descripcion}'
	});
	
	var idTareaTfiRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
	]);
	
	var idTareaTfiStore = page.getStore({
		flow:'plugin.plazosExterna.buscarTareasTfi'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'idTareaTfi'
		},idTareaTfiRecord)
	});
	
	var idTareaTfi =new Ext.form.ComboBox({
		store: idTareaTfiStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'nombre'
		,valueField: 'id'
		,labelStyle:labelStyle
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.plazosExterna.editarPlazo.tareasTfi" text="**Tipo" />'
		,width:300
	});
	
	var recargarIdTareaTfi = function(){
		idTareaTfi.store.removeAll();
		idTareaTfi.clearValue();
		if (idTareaProcedimiento.getValue()!=null && idTareaProcedimiento.getValue()!=''){
			idTareaTfiStore.webflow({id:idTareaProcedimiento.getValue()});
		}
	}
	
	idTareaProcedimiento.on('select', function(){
		recargarIdTareaTfi();
	});
	
	var nombreProcedimiento = new Ext.ux.form.StaticTextField({
	      name: 'nombreProcedimiento',
	      id: 'nombreProcedimiento',
          fieldLabel: '<s:message code="plugin.plazosExterna.busqueda.procedimiento" text="**Tipo procedimiento" />',
          labelStyle:labelStyle,
          value:'${plazo.tareaProcedimiento.tipoProcedimiento.descripcion}',
          width: 350
	});
	
	var panelTareaProc = new Ext.form.FieldSet({
		autoHeight:'false'
 		,border:true
		,layout : 'column'
		,layoutConfig:{columns:1}
		,width:450
		,bodyStyle:'padding:5px'
		,defaults: {layout:'form',border: false,bodyStyle:'padding:2px'}
		,items : [{items:[nombreProcedimiento,idTareaProcedimiento,idTareaTfi]}]
	});	
	
	var scriptPlazo = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code='plugin.plazosExterna.editarPlazo.scriptPlazo' text='**Script de plazo}' />'
		,value : "${plazo.scriptPlazo}"
		,name : 'scriptPlazo'
		,labelStyle:'font-weight:bolder'
		,width : 600 
	});
	
	<pfsforms:numberfield  name="plazo" labelKey="plugin.plazosExterna.editarPlazo.plazo"
			label="**Plazo" value="${plazo.scriptPlazo}" obligatory="true" />	
	
	var panelPlazo = new Ext.form.FieldSet({
		autoHeight:'false'
 		,border:true
		,layout : 'column'
		,layoutConfig:{columns:1}
		,width:450
		,bodyStyle:'padding:5px'
		,defaults: {layout:'form',border: false,bodyStyle:'padding:2px'}
		,items : [{items:[scriptPlazo,plazo]}]
	});	
	<pfsforms:textfield name="observaciones" labelKey="plugin.plazosExterna.busqueda.observaciones"
		label="**Observaciones" value="${plazo.observaciones}" width="500"/>

	<pfs:defineParameters name="parametros" paramId="${plazo.id}"
	observaciones="observaciones"
	scriptPlazo="plazo"
	/>
		
	<pfs:editForm saveOrUpdateFlow="plugin.plazosExterna.guardaPlazo"
		leftColumFields="panelTareaProc,panelPlazo,observaciones"
		parameters="parametros" 
	/>
		
	idTareaProcedimientoStore.webflow({id:'${plazo.tareaProcedimiento.tipoProcedimiento.id}'});
</fwk:page>