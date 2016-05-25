<%@page import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"%>
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
	var maxWidth=800;
	
	var listadoTpoData = <app:dict value="${listaTpo}"/>;
	var listadoTpoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : listadoTpoData
	       ,root: 'diccionario'
	});
	
	
	var creaDblSelectMio = function(label, config){
				
		var store = config.store ;
		var cfg = {
		    	fieldLabel: label || ''
		    	,displayField:'descripcion'
		    	,valueField: 'codigo'
		    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
		    	,dataFields : ['codigo']
		    	,fromStore:store
		    	,toData : []
		        ,msHeight : config.height || 150
				,labelStyle:config.labelStyle || ''
		        ,msWidth : config.width || maxWidth/5.65
		        ,drawTopIcon:false
		        ,drawBotIcon:false
		        ,drawUpIcon:false
				,drawDownIcon:false
				,toSortField : 'codigo'
		    };
		if(config.id) {
			cfg.id = config.id;
		}

		var itemSelector = new Ext.ux.ItemSelector(cfg);
		if (config.funcionReset){
			itemSelector.funcionReset = config.funcionReset;
		}

		itemSelector.setValue =  function(val) {
	        if(!val) {
	            return;
	        }
	        val = val instanceof Array ? val : val.split(',');
	        var rec, i, id;
	        for(i = 0; i < val.length; i++) {
	            id = val[i];
	            if(this.toStore.find('codigo',id)>=0) {
	                continue;
	            }
	            rec = this.fromStore.find('codigo',id);
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
	
   var dbselectTpo = creaDblSelectMio('<b><s:message code="plugin.procuradores.turnado.tpo**" text="Tipos de procedimientos" /></b>',{store:listadoTpoStore});
    
    var ventanaEdicion = function() {
		var w = app.openWindow({
			flow : 'turnadoprocuradores/configurarPlazaTpo'
			,width :  800
			,closable: true
			,title : '<s:message code="plugin.procuradores.turnado.tapConfigurar" text="**Configuracion plazas y TPO" />'
			,params : ''
		});
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};          
	
	var btnAtras = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Volver" />'
		,iconCls : 'icon_atras'
		,disabled: false
		,minWidth:60
		,handler: function() {
			var w = app.openWindow({
					flow : 'turnadoprocuradores/seleccionarPlaza'
					,width :  600
					,resizable:false
					,closable: true
					,title : '<s:message code="plugin.procuradores.turnado.tabSeleccionarPlaza" text="**Seleccionar plaza" />'
					,params : ''
					,autoScroll: 'auto'
				});
				w.on(app.event.DONE, function(){
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			page.fireEvent(app.event.DONE);
	    } 
	}); 
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Guardar" />'
		,iconCls : 'icon_ok'
		,disabled: false
		,minWidth:60
		,handler: function() {
	           page.fireEvent(app.event.DONE);	
	    } 
	}); 
	       
	var btnSiguiente = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Añadir rangos" />'
		,iconCls : 'icon_mas'
		,disabled: false
		,minWidth:60
		,handler: function() {
						ventanaEdicion();
	            		page.fireEvent(app.event.DONE);	
	       		}
	});
	
	var btnCancelar = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Cancelar" />'
		,iconCls : 'icon_cancel'
		,disabled: false
		,minWidth:60
		,handler: function() {
			page.fireEvent(app.event.DONE);
	    } 
	});     
	                                        
	var tabTpo = new Ext.Panel({
		autoWidth:true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[dbselectTpo]
					,autoWidth:true
				}
				]
		,bbar:['->',btnAtras,btnSiguiente,btnGuardar,btnCancelar]
	});
	
	page.add(tabTpo);
</fwk:page>


