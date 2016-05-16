<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<fwk:page>
	var comboWidth = 300;
	var fieldSetsWidth = 430;

	var usuarioRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	 	
	var usuarioOrigenStore = page.getStore({
	       flow: 'coreextension/getListAllUsersPaginated'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, usuarioRecord)	       
	});
	
	var comboUsuarioOrigen = new Ext.form.ComboBox ({
		store:  usuarioOrigenStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.config.delegaciones.new.usuario" text="**Usuario" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'remote'
	});
	
	
	var usuarioDestinoStore = page.getStore({
	       flow: 'coreextension/getListAllUsersPaginated'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, usuarioRecord)	       
	});
	
	var comboUsuarioDestino = new Ext.form.ComboBox ({
		store:  usuarioDestinoStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.config.delegaciones.new.usuario" text="**Usuario" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'remote'
	});
	
	var hoy = new Date();
	var tomorrow = hoy.add(Date.DAY, 1);
	
	var fechaInicio = new Ext.ux.form.XDateField({
        name : 'fechaInicio'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.new.desde"
		text="**Desde" />'
        ,value : ''
        ,allowBlank : false
        ,width:125
        ,minValue: tomorrow
    });
  
  
   fechaInicio.on('select',function(){
		if (this.value){
			if(fechaFin.getValue() != ''){
	    		fechaFin.reset();
	    	}
			fechaFin.setMinValue(this.getValue().add(Date.DAY,1));	
		}
	});
    
    var fechaFin = new Ext.ux.form.XDateField({
        name : 'fechaFin'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.new.hasta"
		text="**Hasta" />'
        ,value : ''
        ,allowBlank : false
        ,width:125
        ,minValue: tomorrow
    });
	
	
	var camposRellenos = function(){
		return comboTipoGestor.getValue() 
				&& comboUsuarioOrigen.getValue()
				&& comboUsuarioDestino.getValue() 
				&& fechaInicio.getValue()
				&& fechaFin.getValue();
	}
	
	
	var createParams = function(){
		var p ={
			 usuarioDestino:comboUsuarioDestino.getValue()
			,usuarioOrigen:comboUsuarioOrigen.getValue()
			,fechaInicio:fechaInicio.getValue().format('d/m/Y')
			,fechaFin:fechaFin.getValue().format('d/m/Y')
		};
		
		return p;			
	}
	
	
	var btnAceptar = new Ext.Button({
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		if (camposRellenos()){
					Ext.Ajax.request({
					url: page.resolveUrl('delegaciontareas/crearDelegacion')
					,params: createParams()
					,method: 'POST'
					,success: function (result, request){
						page.fireEvent(app.event.DONE);
					}
				}); 
			}else{
				Ext.Msg.alert('Faltan datos', 'Debe rellenar todos los campos de la ventana.');
			}
     	}		
	});
	
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});
			    
 
	var panelEdicion =  new Ext.Container({
		layout: 'form'
		,style: 'margin:10px'
		,defaults:{xtype:'fieldset'}	
		,items : [
		    {
				title:'<s:message
		code="plugin.config.delegaciones.new.usuario.origen"
		text="**Usuario origen" />'
				,width: fieldSetsWidth
				,items:[comboUsuarioOrigen]
			}
			, {
				title:'<s:message
		code="plugin.config.delegaciones.new.usuario.destino"
		text="**Usuario destino" />'
				,width: fieldSetsWidth
				,items:[comboUsuarioDestino]
			}
			, {
				title:'<s:message
		code="plugin.config.delegaciones.new.entre.fechas"
		text="**Entre las fechas" />'
				,width: fieldSetsWidth
				,items:[fechaInicio, fechaFin]
			}
  		]
	});	
	
	 
	 var panelContenedor = new Ext.Panel({
	 	height:290
	 	,layout : 'column'
		,viewConfig : { columns : 1 }
		,items : [panelEdicion]
		,bbar:[btnAceptar, btnCancelar]
	 });

	    
   	page.add(panelContenedor);
</fwk:page>
