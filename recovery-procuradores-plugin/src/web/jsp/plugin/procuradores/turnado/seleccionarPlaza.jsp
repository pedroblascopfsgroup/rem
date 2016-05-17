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
debugger;	
	var maxWidth=800;
	var plazas = "";
	var listadoPlazasStore = new Ext.data.JsonStore({
		fields: [
			{name: 'codigo'
			,name: 'comentario'}
		]
		,data : [["1","Valencia"]
				,["2","Madrid"]
				,["3","Barcelona"]]
	});
	
	var creaDblSelectMio = function(label, config){
				
		var store = config.store ;
		var cfg = {
		    	fieldLabel: label || ''
		    	,displayField:'comentario'
		    	,valueField: 'codigo'
		    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
		    	,dataFields : ['codigo']
		    	,fromStore:store
		    	,toData : []
		        ,msHeight : config.height || 120
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
	
   var dbselectPlazas = creaDblSelectMio('<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" /></b>',{store:listadoPlazasStore});
  
  var ventanaEdicion = function() {
		var w = app.openWindow({
			flow : 'turnadoprocuradores/seleccionarTpo'
			,width :  600
			,closable: true
			,title : '<s:message code="plugin.procuradores.turnado.tabSeleccionarTpo" text="**Seleccionar tpo" />'
			,params : ''
		});
		w.on(app.event.DONE, function(){
			w.close();
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
                     
	var btnSiguiente = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente" text="**Siguiente" />'
		,iconCls : 'icon_siguiente'
		,disabled: false
		,minWidth:60
		,handler: function() {
				Ext.Msg.confirm('<s:message code="plugin.procuradores.turnado.confirmarBorrarPlaza" text="**Borrar datos plaza" />', '<s:message code="plugin.procuradores.turnado.mensajeConfirmarBorrarPlaza" text="**Ya existe una configuracion para la plaza seleccionada, desea borrarla" />', this.evaluateAndSend);
		}
		,evaluateAndSend: function(seguir) {      			
	         			if(seguir== 'yes') {
	         				ventanaEdicion();
	            			page.fireEvent(app.event.DONE);				
						}
	    } 
	});    
	                 
                               
	var tabPlazas = new Ext.Panel({
		autoWidth:true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[dbselectPlazas]
					,autoWidth:true
				}
				]
		,bbar:['->',btnSiguiente]
	});
	
	page.add(tabPlazas);
</fwk:page>


