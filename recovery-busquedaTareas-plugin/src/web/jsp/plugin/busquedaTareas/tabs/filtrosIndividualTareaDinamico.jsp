<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){
var limit=25;

	<%-- Store para los tipos de gestor --%>
	var optionsTiposGestor  = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		
	]);
	
	var optionsTipoGestorStore = page.getStore({
	       flow: 'coreextension/getListTipoGestorAdicionalData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoGestores'
	    }, optionsTiposGestor)	       
	});
	
	<%-- Campo Combo Tipos de Gestor --%>
	var comboTiposGestor = new Ext.form.ComboBox({
				store:optionsTipoGestorStore
				,displayField:'descripcion'
				,valueField:'id'
				,mode: 'local'
				,forceSelection: true
				,editable: true
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="ext.asuntos.busqueda.filtro.tipoGestor" text="**Tipo de gestor"/>'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
				<app:test id="comboTiposGestor" addComa="true"/>
	});
	
	comboTiposGestor.on('select', function(){
	
		comboDespachos.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTiposGestor.getValue(), 'incluirBorrados': true}); 
		
		comboGestor.reset();
		comboGestor.setValue('');
		optionsGestoresStore.removeAll();
		
		comboDespachos.setDisabled(false);		
	});
	 
	
	<%-- Store generico de combo diccionario --%>
	var optionsDespachosRecord = Ext.data.Record.create([
		 {name:'cod'}
		,{name:'descripcion'}
	]);
	
	var optionsDespachoStore = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    }, optionsDespachosRecord)	       
	});
	
	<%-- Campo Combo Despacho --%>
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachoStore
				,displayField:'descripcion'
				,valueField:'cod'
				,mode: 'local'
				,emptyText:'---'
				,forceSelection: true
				,editable: true
				,triggerAction: 'all'
				,disabled:true
				,resizable:true
				,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
				<app:test id="comboDespachos" addComa="true"/>
	});
	
	comboDespachos.on('select', function(){
		comboGestor.reset();
		optionsGestoresStore.webflow({'idTipoDespacho': comboDespachos.getValue(), 'incluirBorrados': true}); 
				
		comboGestor.setDisabled(false);
	});
	
	
	
	var Gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	
	var optionsGestoresStore =  page.getStore({
	       flow: 'coreextension/getListUsuariosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, Gestor)	       
	});
		
	<%-- Campo Gestores, double select --%> 
	 var creaDblSelectMio = function(label, config){
		var store = config.store ;
		var cfg = {
		    	fieldLabel: label || ''
		    	,displayField:'username'
		    	,valueField: 'id'
		    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
		    	,dataFields : ['id', 'username']
		    	,fromStore:store
		    	,toData : []
		        ,msHeight : config.height || 130
				,labelStyle:config.labelStyle || ''
		        ,msWidth : config.width || 300
		        ,drawTopIcon:false
		        ,drawBotIcon:false
		        ,drawUpIcon:false
				,drawDownIcon:false
				,disabled:true
				,toSortField : 'codigo'
	    };
		if(config.id) {
			cfg.id = config.id;
		}
	
	
		var itemSelector = new Ext.ux.ItemSelector(cfg);
		if (config.funcionReset){
			itemSelector.funcionReset = config.funcionReset;
		}
	
	
		<%-- modificacion al itemSelector porque no tiene un metodo setValue. Si se cambia de version se tendria que revisar la validez de este metodo --%>
		itemSelector.setValue =  function(val) {
	        if(!val) {
	            return;
	        }
	        val = val instanceof Array ? val : val.split(',');
	        var rec, i, id;
	        for(i = 0; i < val.length; i++) {
	            id = val[i];
	            if(this.toStore.find('id',id)>=0) {
	                continue;
	            }
	            rec = this.fromStore.find('id',id);
	            if(rec>=0) {
	            	rec = this.fromStore.getAt(rec);
	                this.toStore.add(rec);
	                this.fromStore.remove(rec);
	            }
	        }
	    };
	
		itemSelector.getStore =  function() {
			return this.toStore;
		};
	
	
		return itemSelector;
	};

	var comboGestor = creaDblSelectMio('<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores});



var recargarComboGestores = function(){
	
		
			optionsGestoresStore.webflow({id:0});
		
	}

	var validarEmptyForm = function(){

	try{
		if (comboDespachos.getValue() != '' ){
			return true;
		}
		if (comboGestor.getValue() != '' ){
			return true;
		}
		if (comboTiposGestor.getValue() != '' ){
			return true;
		}
			
		return false;
	}catch(err){
			
		};		
	}
	
	var validaMinMax = function(){
		
		return true;
	}

	var getParametros = function() {
		return {
			comboDespachos:comboDespachos.getValue()
			,comboGestor:comboGestor.getValue()
			,comboTiposGestor:comboTiposGestor.getValue()
		};
	};

	
	var tabFiltrosUsuario = false;		
	<%-- Tab --%>
	var filtrosDeUsuarioTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros4" text="**Tareas Individuales" />'
		,autoHeight:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,header: false
	    ,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{items:[comboTiposGestor]}
				,{items:[comboDespachos]}
				,{items:[comboGestor]}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
			,limpiar: function() {
    		   			app.resetCampos([      
    		           comboDespachos
    		           ,comboGestor
    		           ,comboTiposGestor
    		           ]);
    		           comboGestor.setDisabled(true);
	          		   comboDespachos.setDisabled(true);
	          		   optionsGestoresStore.webflow({'idTipoDespacho': 0});
    				}
    			}
	});
	
    Ext.onReady(function(){
		 optionsTipoGestorStore.webflow({ugCodigo:'3'});
	});

    return filtrosDeUsuarioTabBuscaTareas;
    
})()