<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>
	var style='margin-bottom:1px;margin-top:1px';
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:120px'
	var txtNombreAsunto = app.creaText('asunto','<s:message code="" text="**Asunto" />','',{style:style,labelStyle:labelStyle});
	
	var dictDespachos = <app:dict value="${despachos}" />;
	
	//store generico de combo diccionario
	var optionsDespachosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDespachos
	});
	
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.despacho" text="**Despacho"/>'
	});		
	
	var recargarComboGestores = function(){
		optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		comboGestores.enable();
		comboGestores.focus();
	}
	
	var bloquearComboGestores = function(){
		comboGestores.disable();
	}
	
	comboDespachos.on('focus',bloquearComboGestores);
	
	comboDespachos.on('change',recargarComboGestores);
	
	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	      // ,params: {id:comboDespachos.getValue()}
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
	
	var comboGestores = new Ext.form.ComboBox({
				store:optionsGestoresStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,disabled:true
				,mode: 'remote'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.gestor" text="**Gestor"/>'
				,name: 'comboGestores'
	});

	var labelTipoGestor = new Ext.form.Label({
		text:'[Externo]'
		,style:'valgin:center'
	});
	var comboSupervisores = new Ext.form.ComboBox({
				//store:optionsGestoresStore
				displayField:'descripcion'
				,valueField:'codigo'
				//,disabled:true
				,mode: 'remote'
				,triggerAction: 'all'
				,editable: false
				,labelStyle:labelStyle
				,style:style
				,fieldLabel : '<s:message code="asuntos.alta.supervisor" text="**Supervisor"/>'
				,name: 'comboSupervisores'
	});
	
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="asuntos.alta.observaciones" text="**Propuesta / Observaciones"/>'
		,width:150
		,labelStyle:labelStyle
		,name:'observaciones'
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.submit({
			//	flow: 'asuntos/altaAsuntos',
			//	formPanel: panelAlta
			//	,eventName : 'altaAsunto'
			//	,params: {
			//		idGestor:comboGestores.getValue(), 
			//		nombreAsunto:txtNombreAsunto.getValue(),
			//		idExpediente:${idExpediente}					
			//	}
			//	,success :  function(){ 
                  				page.fireEvent(app.event.DONE);
            //      			}
			//});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});

	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
			,cellCls:'vtop'
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		layout:'table'
		 		,autoHeight:true
		 		,border:false
		 		,layoutConfig:{columns:2}
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true,width:330}
		 		,items:[
		 			{items:[txtNombreAsunto,comboDespachos,comboGestores,comboSupervisores]}
		 			,{items:[observaciones]}
		 		]
		 	}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});


	page.add(panelAlta);

</fwk:page>