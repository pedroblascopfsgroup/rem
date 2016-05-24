<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

(function(){
	var limit=25;
	
	//store para los tipos de testor
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
	
	//Campo Combo Tipos de Gestor
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
	 
	
	//store generico de combo diccionario
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
	
	//Campo Combo Despacho
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
	
//Campo Gestores, double select 
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


	//modificaci�n al itemSelector porque no tiene un m�todo setValue. Si se cambia de versi�n se tendr� que revisar la validez de este m�todo
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



	<%-- PRODUCTO-1273 - Nuevos campos  --%>
	<pfs:datefield labelKey="plugin.coreextension.multigestor.fechaDesde" label="**Fecha alta desde" name="fechaAltaDesde" />
	<pfs:datefield labelKey="plugin.coreextension.multigestor.fechaHasta" label="**Fecha alta hasta" name="fechaAltaHasta" />
	var fechaAltaFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="asuntos.busqueda.filtros.tabs.filtrosLetrados.fechaAlta.text" text="**Fecha Alta" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:300 }
		,items : [{items:[fechaAltaDesde, fechaAltaHasta]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(340-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	
	var documentoCif = app.creaText('documentoCif', '<s:message code="plugin.config.despachoExternoExtras.field.documento" text="**documentoCif" />'); 
	
	//Listado de Estados, viene del flow
	var dictTipoAsunto = <app:dict value="${tiposDocumentos}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	
	//store generico de combo diccionario
	var comboTipoAsuntoStore = new Ext.data.JsonStore({
	       fields: ['id', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoAsunto
	});
	
	//Campo Combo Estados
	var tipoDocumento = new Ext.form.ComboBox({
				store: comboTipoAsuntoStore
				,displayField:'descripcion'
				,valueField:'descripcion'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.config.despachoExternoExtras.field.tipoDocumento" text="**Tipo Documento"/>'
				<app:test id="comboTipoDocumento" addComa="true"/>
	});


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
		if (fechaAltaHasta.getValue() != '' ){
			return true;
		}
		if (fechaAltaDesde.getValue() != '' ){
			return true;
		}
		if(tipoDocumento.getValue() != '') {
			return true;
		}
		if(documentoCif.getValue() != '') {
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
			,fechaAltaHasta: fechaAltaHasta.getValue()
			,fechaAltaDesde: fechaAltaDesde.getValue()
			,tipoDocumento: tipoDocumento.getValue() 
			,documentoCif: documentoCif.getValue()
		};
	};
	
	


	var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="asuntos.busqueda.filtros.tabs.filtrosGestores.title" text="**Filtro gestores" />'
		,layoutConfig:{columns:2}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:20px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:20px;padding-right:20px;padding-top:1px;padding-bottom:1px;cellspacing:20px'}
		,items:[{items:[comboTiposGestor, comboDespachos,comboGestor]}
				,{items:[tipoDocumento, documentoCif, fechaAltaFieldSet]}
				
		]
		,listeners:{	
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	            if (validaMinMax()){
    	                anadirParametros(getParametros());
    	            }else{
    	                hayError();
    	                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
    	            }
    	        }
    	     }

    		,limpiar: function() {
    		   app.resetCampos([      
    		           comboDespachos
    		           ,comboGestor
    		           ,comboTiposGestor
    		           ,fechaAltaDesde
    		           ,fechaAltaHasta
    		           ,tipoDocumento
    		           ,documentoCif
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


    return panel;
    
})()