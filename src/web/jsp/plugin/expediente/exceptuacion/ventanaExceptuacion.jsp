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
	var tipo = '${tipo}';	
	var tomorrow = new Date();
	tomorrow.setDate(tomorrow.getDate()+1);
	var minDate = tomorrow;
	var excId;

	var txtFechaError = new Ext.form.Label({
	   	text:'<s:message code="plugin.expediente.exceptuacion.ventana.fechaInvalida" text="**La fecha es inválida o no puede ser anterior o igual a hoy" />'
		,style:'color:red;font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
		,hidden: true
	});
	
	var txtMotivoError = new Ext.form.Label({
	   	text:'<s:message code="plugin.expediente.exceptuacion.ventana.motivoObligatorio" text="**El campo motivo es obligatorio" />'
		,style:'color:red;font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
		,hidden: true
	});
	
	var fechaHasta = new Ext.ux.form.XDateField({
        name : 'fechaHasta'
        ,fieldLabel : '<s:message code="plugin.expediente.exceptuacion.ventana.fechaHasta" text="**Fecha hasta"/>'
        ,style:'margin:0px'
        ,minValue : minDate
        ,width:125
    });
    
    var motivo = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsMotivoStore = page.getStore({
	       flow: 'exceptuacion/getListadoMotivosExceptuacion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, motivo)
	});

	var comboMotivo = new Ext.form.ComboBox({
		store:optionsMotivoStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'remote'
		,width: 300
		,autoLoad: true
		,resizable: true
		,forceSelection: true
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.expediente.exceptuacion.ventana.motivo" text="**Motivo" />'
		,value:''
	});
	
	
	var comentarios = new Ext.form.TextArea({
		fieldLabel : '<s:message code='plugin.expediente.exceptuacion.ventana.comentarios' text='**Comentarios' />'
		,value : ''
		,name : 'comentarios'
		,width : 300 
	});	
	
	
	function eliminarExcepcion(opt){
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
	   	  Ext.Ajax.request({
				url: page.resolveUrl('exceptuacion/borrarExceptuacion')
				,method: 'POST'
				,params:{						
					excId:excId
      			}
				,success: function (result, request){					
					page.fireEvent(app.event.DONE);
				}
				,error: function(){
					Ext.MessageBox.show({
			           title: 'Guardado',
			           msg: '<s:message code="plugin.expediente.exceptuacion.ventana.errorGuardado" text="**Error guardado" />',
			           width:300,
			           buttons: Ext.MessageBox.OK
			       });
					page.fireEvent(app.event.CANCEL);
				} 
			});
	   }
	}	 
	 
	 var icono;
	 if(tipo=='1'){
	 	icono = 'icon_deletePersona';
	 }
	 else if(tipo == '2'){
	 	icono = 'icon_deleteContrato';
	 }
	 
	 var btnEliminarExcepcion = new Ext.Button({
		text : '<s:message code="plugin.expediente.exceptuacion.ventana.eliminarExcepcion" text="Eliminar excepción activa" />'
		,iconCls : icono
		,handler : 	function() {
			Ext.Msg.show({
			   title:'Confirmación',
			   msg: '<s:message code="plugin.expediente.exceptuacion.ventana.confirmarEliminarExcepcion" text="**Confirmar eliminar exceptuacion" />',
			   buttons: Ext.Msg.YESNO,
			   animEl: 'elId',
			   width:450,
			   fn: eliminarExcepcion,
			   icon: Ext.MessageBox.QUESTION
			});	
		}
	});
	
	
	var panelEdicion =  new Ext.Container({
		height:300
		,layout: 'form'
		,items : [txtFechaError,fechaHasta,txtMotivoError,comboMotivo,comentarios]
	});
	
	var cargarDatos = function(){
		Ext.Ajax.request({
			url: page.resolveUrl('exceptuacion/getExceptuacion')
			,params: {idEntidad:data.id, tipo:tipo}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				fechaHasta.setValue(r.fechaHasta);
				comboMotivo.setValue(r.idMotivo);
				excId = r.excId;
				comentarios.setValue(r.comentarios);
			}
		});
	}
	
	var comprobarBtnEliminar = function(){
		Ext.Ajax.request({
			url: page.resolveUrl('exceptuacion/existeExceptuacion')
			,params: {id:data.id, tipo:tipo}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				btnEliminarExcepcion.setDisabled(!r.existe);
				if(r.existe){
					cargarDatos();
				}
				
			}
		});
	}
	
	
	
	
	var columnas = new Ext.form.FieldSet({
		layout: 'table'
		,border:false
		,width:500
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
		,items : [{
		     columnWidth:.20,style:'margin-top:10px',items:[panelEdicion]
		    }]
	 });
	 
	 var validarDatosFormulario = function(){
		txtFechaError.hide();
		txtMotivoError.hide();
		
		if(!fechaHasta.validate()){
			txtFechaError.show();
			return false;
		}
		if (!comboMotivo.getValue()){
			txtMotivoError.show();
			return false;
		}
		else {
			return true;
		}
	}
	 
	 function processResult(opt){
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
	      Ext.Ajax.request({
				url: page.resolveUrl('exceptuacion/guardarExceptuacion')
				,method: 'POST'
				,params:{
      				   fechaHasta:app.format.dateRenderer(fechaHasta.getValue())
      				   ,idMotivo:comboMotivo.getValue()
      				   ,idEntidad:'${id}'
      				   ,tipo:tipo
      				   ,observaciones:comentarios.getValue()
      				   ,excId:excId
      				}
				,success: function (result, request){					
					page.fireEvent(app.event.DONE);
				}
				,error: function(){
					Ext.MessageBox.show({
			           title: 'Guardado',
			           msg: '<s:message code="plugin.expediente.exceptuacion.ventana.errorGuardado" text="**Error guardado" />',
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
				   msg: '<s:message code="plugin.expediente.exceptuacion.ventana.confirmarExceptuacion" text="**Confirmar exceptuacion" />',
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
	 
	 var panelContenedor = new Ext.Panel({
	 	height:200
	 	,layout : 'column'
		,viewConfig : { columns : 2 }
		,items : [	
			columnas]
		,bbar:[btnAceptar, btnCancelar, btnEliminarExcepcion]
	 });
	 
	 optionsMotivoStore.webflow();
	 optionsMotivoStore.on('load', function(){
		comprobarBtnEliminar();	
	 });
	 
	 
	 page.add(panelContenedor);
   	

</fwk:page>	