<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fwk:page>
		
	var persona = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);

	var optionsListPersonasStore = page.getStore({
		flow: 'incidenciaexpediente/getListadoPersonasExpediente'
		,reader: new Ext.data.JsonReader({
			root : 'listado'
	      }, persona)
	     }); 

	var comboPersonas = new Ext.form.ComboBox({
				store:optionsListPersonasStore
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,width:300
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.expediente.incidencias.nuevaIncidencia.persona" text="**Persona" />'
				,name: 'comboProveedores'
				<app:test id="comboPersonasAA" addComa="true"/>
	});
	
	var contrato = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);

	var optionsListContratosStore = page.getStore({
		flow: 'incidenciaexpediente/getListadoContratosExpediente'
		,reader: new Ext.data.JsonReader({
			root : 'listado'
	      }, contrato)
	     }); 

	var comboContratos = new Ext.form.ComboBox({
				store:optionsListContratosStore
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.expediente.incidencias.nuevaIncidencia.contrato" text="**Contrato" />'
				,name: 'comboContratos'
				<app:test id="comboContratosAA" addComa="true"/>
	});
	
	var tipoIntervencion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionstipoIntervencionStore = page.getStore({
	       flow: 'incidenciaexpediente/getListadoTiposIncidencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, tipoIntervencion)	       
	});	
	
	var comboTipoIntervencion = new Ext.form.ComboBox({
				store:optionstipoIntervencionStore
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.expediente.incidencias.nuevaIncidencia.tipoIntervencion" text="**tipo Incidencia" />'
				,name: 'comboTipoIntervencion'
				<app:test id="combotipoIntervencionAA" addComa="true"/>
	});
	
	var recargar = function(){
		optionsListPersonasStore.webflow({'id':'${id}'});
		optionsListContratosStore.webflow({'id':'${id}'});
		
	}
	
	var validarDatosFormulario = function(){
	
		if (comboTipoIntervencion.getValue() || comboPersonas().getValue()){
			return true;
		} else {
			return false;
		}
	}
		
	function processResult(opt){
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
	      Ext.Ajax.request({
				url: page.resolveUrl('incidenciaexpediente/guardarIncidencia')
				,method: 'POST'
				,params:{
      				   idPersona:comboPersonas.getValue()
      				   ,idContrato:comboContratos.getValue()
      				   ,idTipoIncidencia:comboTipoIntervencion.getValue()
      				   ,idUsuario:app.usuarioLogado.id
      				   ,idProveedor:app.usuarioLogado.id
      				   ,idExpediente:'${id}'
      				   ,observaciones:comentarios.getValue()
      				}
				,success: function (result, request){					
					page.fireEvent(app.event.DONE);
				}
				,error: function(){
					Ext.MessageBox.show({
			           title: 'Guardado',
			           msg: '<s:message code="plugin.mejoras.asunto.ErrorGuardado" text="**Error guardado" />',
			           width:300,
			           buttons: Ext.MessageBox.OK
			       });
					page.fireEvent(app.event.CANCEL);
				} 
			});
	   }
	}
		
	var btnAceptar = new Ext.Button({
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		var index=0;	
	
      		if(validarDatosFormulario()){
	       		Ext.Msg.show({
				   title:'Confirmación',
				   msg: '<s:message code="plugin.expediente.incidencias.nuevaIncidencia.confirmarAlta" text="**Confirmar alta" />',
				   buttons: Ext.Msg.YESNO,
				   animEl: 'elId',
				   width:450,
				   fn: processResult,
				   icon: Ext.MessageBox.QUESTION
				});
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

	
	var comentarios = new Ext.form.TextArea({
		fieldLabel : '<s:message code='plugin.expediente.incidencias.nuevaIncidencia.comentarios' text='**Comentarios' />'
		,value : ''
		,name : 'comentarios'
		,width : 300 
	});	
	
	var panelEdicion =  new Ext.Container({
		height:300
		,layout: 'form'
		,items : [comboPersonas,comboContratos, comboTipoIntervencion,comentarios]
	});	
	
	 
	var columnas = new Ext.form.FieldSet({
		layout: 'table'
		,border:false
		,width:950
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
		,items : [{
		     columnWidth:.20,style:'margin-top:10px',items:[panelEdicion]
		    }]
	 }); 
	 
	 var panelContenedor = new Ext.Panel({
	 	height:200
	 	,layout : 'column'
		,viewConfig : { columns : 2 }
		,items : [	
			columnas]
		,bbar:[btnAceptar, btnCancelar]
	 });

	    
   	page.add(panelContenedor);
   	
	recargar();
   	optionsListPersonasStore.on('load', function(store, data, options){
		if(optionsListPersonasStore.getCount()==1){		
			var text = store.getAt(0).get(comboPersonas.valueField); 				
			comboPersonas.setValue(text);				
		}
    });
    
  
	    

</fwk:page>	