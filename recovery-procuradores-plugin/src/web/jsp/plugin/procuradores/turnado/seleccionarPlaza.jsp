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
//debugger;
	<%--
	var listadoPlazasData = <app:dict value="${listaPlazas}"/>;
	var listadoPlazasStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : listadoPlazasData
	       ,root: 'diccionario'
	});
	--%>
	var busquedaActiva = false;
	
	<%-- Store del combo de casos --%>
	var listadoPlazasStore = page.getStore({
		flow:'turnadoprocuradores/getPlazasInstant'
	        ,remoteSort:false
	        ,autoLoad: false
	        ,reader : new Ext.data.JsonReader({
	            root:'data'
	            ,fields:['id','codigo','descripcion']
	        })
    });
    
    
    listadoPlazasStore.on('beforeload', function(store, options){
    	if (busquedaActiva){
    		return false;
    	} else{
    		busquedaActiva = true;
    	}
    });
    
    listadoPlazasStore.on('load', function(store, records, options){
    	busquedaActiva = false;
    });

    var cmbPlazas = new Ext.form.ComboBox({
        name : 'turnadoProcuComboPlazas'
        ,valueField: 'codigo' 
        ,displayField:'descripcion'
        ,store: listadoPlazasStore
        ,fieldLabel : '<s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" />'
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,width : 130
        ,allowBlank:false
        ,enableKeyEvents: true
        ,typeAhead: false   
        ,minChars: 3
        ,maxLength:256 
        ,queryDelay: 1500
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,listeners: {
			select: function(){
				dimeSiPlazaYaSeleccionada(this.getValue());
			}
		}
    });
  
    <%--Boton añadir plaza--%>
	var botonAddPlaza = new Ext.Button({
        iconCls:'icon_mas'
        ,disabled : true
        ,handler : function(){
        	if(cmbPlazas.getValue().trim()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('codigo', cmbPlazas.getValue()));
	        	var campo = new Ext.form.Label({
	  	   				name: 'plaza_'+plazaItem.get('codigo'),
		   				html:  plazaItem.get('descripcion')+ '&nbsp;',
		   				width:250,
		   				style: 'font-size:12px;'
	   	    	}); 
	   	    	var borrarCampo = new Ext.form.Label({
				   name: 'borrarPlaza_'+plazaItem.get('codigo'),
				   html: '<img src="/${appProperties.appName}/img/plugin/masivo/icon_trash.png"/>',
		  		   style: 'float:left;font-size:12px;margin-left:2px;',
		  		   listeners: {
		  		   		render: function(c){
		  		   			c.getEl().on({
		  		   				click: function(el){
		  		   					var plazaValue = this.name.split('_')[1];
		  		   					var cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+plazaValue)[0];
		  		   					cmp.destroy();
		  		   					this.destroy();
		  		   					dimeSiPlazaYaSeleccionada(plazaValue);
		  		   				},scope: c
		  		   			});
		  		   		}
		   		   }
		  		});
		  		var panel = Ext.getCmp('turn_procu_lista_plazas');
			    panel.add(campo);
			   	panel.add(borrarCampo);
			   	dimeSiPlazaYaSeleccionada(plazaItem.get('codigo'));
			  	panel.doLayout(); 
   	    	}		
		}
    });
    
    <%--Boton eliminar plaza--%>
	var botonRemovePlaza = new Ext.Button({
        iconCls:'icon_menos'
        ,disabled : true
        ,handler: function(){
        	if(cmbPlazas.getValue().trim()!='' && cmbPlazas.getValue()!=null){
        		var plazaItem = listadoPlazasStore.getAt(listadoPlazasStore.find('codigo', cmbPlazas.getValue()));	
				var cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+plazaItem.get('codigo'))[0];
				cmp.destroy();
				cmp = Ext.getCmp('turn_procu_lista_plazas').find('name','borrarPlaza_'+plazaItem.get('codigo'))[0];
				cmp.destroy();
				dimeSiPlazaYaSeleccionada(plazaItem.get('codigo'));
			}
        }
    });
    
    <%-- Funcion validar si plaza ya seleccionada --%>
    var dimeSiPlazaYaSeleccionada = function(codigoPlaza){
    	var falg;
    	var plazaItem = Ext.getCmp('turn_procu_lista_plazas').find('name','plaza_'+codigoPlaza);
    	if(plazaItem.length>0) flag=true;
    	else flag=false;
		botonAddPlaza.setDisabled(flag);
		botonRemovePlaza.setDisabled(!flag);	
    }
    
	var plazasPanel = app.creaPanelHz({style : "margin-top:4px;margin-bottom:4px;"},[{html:"<b><s:message code="plugin.procuradores.turnado.plaza" text="**Plazas" /></b>"+":", border: false, width : 133, cls: 'x-form-item', style: "margin-top:4px;"},cmbPlazas, botonAddPlaza, botonRemovePlaza]);

	var turnadoFiltrosFieldSet = new Ext.form.FieldSet({
		layout:'table'
		,autoHeight:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', border : false, width:400 }
		,items : [plazasPanel,
		 			{
	                title : ''
	                ,layout:'table' 
	                ,border : true
	                ,layoutConfig: { columns: 2 }
	                ,autoScroll:true
	                ,bodyStyle:'padding:5px;'
	                ,name: 'turn_procu_lista_plazas'
	                ,id:'turn_procu_lista_plazas'
	                //,autoHeight:true
	                //,autoWidth : true
	                ,height: 100
	                ,width:305
            		},
		]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(800-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
  
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
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Añadir tipos de procedimientos" />'
		,iconCls : 'icon_mas'
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
	
	var btnCancelar = new Ext.Button({
		text : '<s:message code="plugin.procuradores.turnado.btnSiguiente**" text="Cancelar" />'
		,iconCls : 'icon_cancel'
		,disabled: false
		,minWidth:60
		,handler: function() {
			page.fireEvent(app.event.DONE);
	    } 
	});
	
	var tabPlaza = new Ext.Panel({
		autoWidth:true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[turnadoFiltrosFieldSet]
		,bbar:['->',btnSiguiente,btnGuardar,btnCancelar]
	});
	
	page.add(tabPlaza);
</fwk:page>


