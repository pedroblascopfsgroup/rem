<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var tipoImporteConData = {diccionario: [
		{codigo:'A', descripcion:'A (desde 12 - 22)'}
		,{codigo:'B', descripcion:'B (desde 12 - 22)'}
		,{codigo:'C', descripcion:'C (desde 12 - 22)'}
	]};

	var tipoCalidadConData = {diccionario: [
		{codigo:'A', descripcion:'A (desde 12 - 22)'}
		,{codigo:'B', descripcion:'B (desde 12 - 22)'}
		,{codigo:'C', descripcion:'C (desde 12 - 22)'}
	]};


    var cmbTipoImporteLit = app.creaCombo({
		data: tipoImporteConData
    	,name : 'tipoImporteLit'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.letrado.ventana.label.tipoimporte" text="**Tipo importe" />'
		,width : 130
    });
    var cmbTipoCalidadLit = app.creaCombo({
		data: tipoCalidadConData
    	,name : 'tipoCalidadLit'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.letrado.ventana.label.tipocalidad" text="**Tipo calidad" />'
		,width : 130
    });


    var cmbTipoImporteCon = app.creaCombo({
		data: tipoImporteConData
    	,name : 'tipoImporteCon'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.letrado.ventana.label.tipoimporte" text="**Tipo importe" />'
		,width : 130
    });
    var cmbTipoCalidadCon = app.creaCombo({
		data: tipoCalidadConData
    	,name : 'tipoCalidadCon'
    	,fieldLabel : '<s:message code="plugin.config.esquematurnado.letrado.ventana.label.tipocalidad" text="**Tipo calidad" />'
		,width : 130
    });


	var turnadoLitigiosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelLitigios.titulo" text="**Turnado Litigios" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:310 }
		,items : [
		 	{items:[cmbTipoImporteLit,cmbTipoCalidadLit]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(310-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});

	var turnadoConcursosFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelConcursos.titulo" text="**Turnado Concursos" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:310 }
		,items : [
		 	{items:[cmbTipoImporteCon,cmbTipoCalidadCon]}
		]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(310-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});


	var topPanel = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:2}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [turnadoLitigiosFieldSet]}
				,{layout:'form',
					style:'margin-left:10px'
					,items: [turnadoConcursosFieldSet]}
				]
	});	


	var comunidadesData = {diccionario: [
		{'codigo':'12','descripcion':'C. Valenciana'}
		,{'codigo':'11','descripcion':'C. Madrid'}
	]};
	var provinciasData = {diccionario: [
		{'codigo':'12','descripcion':'C. Valenciana'}
		,{'codigo':'11','descripcion':'C. Madrid'}
	]};

	var config = {width: 100, labelStyle:"width:100px;font-weight:bolder"};
    var comboComunidades = app.creaDblSelect(comunidadesData 
    	,'<s:message code="plugin.config.esquematurnado.editar.comunidades" text="**Comunidades" />'
    	,config);
    var comboProvincias = app.creaDblSelect(provinciasData 
    	,'<s:message code="plugin.config.esquematurnado.editar.provincias" text="**Provincias" />'
    	,config);
	var ambitoActuacionFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.esquematurnado.editar.panelAmbActuacion.titulo" text="**Ambito actuación" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [{items:[comboComunidades,comboProvincias]}]
		,doLayout:function() {
				var margin = 40;
				//var parentSize = app.contenido.getSize(true);
				//this.setWidth(parentSize.width-margin);
				this.setWidth(600-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	var bottomPanel = new Ext.Panel({
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,layout:'table'
		,border:false
		,layoutConfig:{columns:1}
		,viewConfig : {forceFit : true}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,items:[{layout:'form'
					,items: [ambitoActuacionFieldSet]}
				]
	});	



	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});

	var mainPanel = new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		//,style:'padding-bottom:10px; padding-right:10px;'
		//,tbar : [buttonsL,'->', buttonsR]
		,bbar: [btnGuardar,btnCancelar]
		,items:[{layout:'form', items: [topPanel,bottomPanel]}
		]
	});	

	page.add(mainPanel);
	
</fwk:page>


