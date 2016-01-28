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

	var tipoGestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);

	var comboTipoGestorStore = page.getStore({
		reader: new Ext.data.JsonReader({
			root : 'data'
	      }, tipoGestor)
	     }); 


	var cargaComboTipoGestor = function() {
	     var tipoGestorJSON = <json:array name="data"
		items="${tiposGestor}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.id}" />
			<json:property name="descripcion" value="${rec.descripcion}" />
		</json:object>
	</json:array>
	     comboTipoGestorStore.loadData({data:tipoGestorJSON});
	}
	cargaComboTipoGestor.defer(1);

	var comboTipoGestor = new Ext.form.ComboBox({
		store:comboTipoGestorStore
		,displayField:'descripcion'
		,valueField:'id'
		,mode: 'local'
		,width: comboWidth
		,resizable: true
		,forceSelection: true
		,editable: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.tipoGestor"
		text="**Tipo de gestor" />'
		,allowBlank : false
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
    var comboDespachosOriginal = new Ext.form.ComboBox({
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
	
	 
	 
	var Gestor = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsGestorOriginalStore = page.getStore({
	       flow: 'cambiomasivogestoresasunto/buscaGestoresByDespachoTipoGestor'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, Gestor)
	       
	});
		
  var comboGestorOriginal = new Ext.form.ComboBox({
		store:optionsGestorOriginalStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,width: comboWidth
		,resizable: true
		,forceSelection: true
		,editable: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.usuario"
		text="**Usuario" />'
		,allowBlank : false
		,disabled: true
	});
	
	var hoy = new Date();
	var tomorrow = hoy.add(Date.DAY, 1);
	
	var fechaInicio = new Ext.ux.form.XDateField({
        name : 'fechaInicio'
        ,fieldLabel : '<s:message
		code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaIda"
		text="**Desde" />'
        ,value : ''
        ,allowBlank : false
        ,width:125
        ,disabled: true
        ,minValue: tomorrow
    });
    
    var fechaFin = new Ext.ux.form.XDateField({
        name : 'fechaFin'
        ,fieldLabel : '<s:message
		code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaVuelta"
		text="**Hasta" />'
        ,value : ''
        ,allowBlank : false
        ,width:125
        ,disabled:true
    });
	
	comboGestorOriginal.on('select', function(){
		if (this.value){
			fechaInicio.setDisabled(false);
		}else{
			fechaInicio.setDisabled(true);
		}
	});
	
	var camposRellenos = function(){
		return comboTipoGestor.getValue() 
				&& comboGestorOriginal.getValue()
				&& fechaInicio.getValue()  
				&& comboDespachosOriginal.getValue() 
	}
	
	
	var createParams = function(){
		var p ={
			tipoGestor:comboTipoGestor.getValue()
			,idGestorOriginal:comboGestorOriginal.getValue()
			,fechaInicio:fechaInicio.getValue().format('d/m/Y')
			,listaAsuntos:${listaAsuntos}
		};
		if (fechaFin.getValue()){
			p.fechaFin = fechaFin.getValue().format('d/m/Y');
		}
		
		return p;			
	}
	
	var grabaLasPeticiones = function(){
				Ext.Ajax.request({
					url: page.resolveUrl('cambiosgestores/anotarCambiosPendientesDesdeBuscadorDeAsuntos')
					,params: createParams()
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText);
						if (r.success){
							Ext.Msg.alert('Correcto', 'Las peticiones han sido almacenadas.');
							page.fireEvent(app.event.DONE);
						}else{
							Ext.Msg.alert('Error', 'Ha ocurrido un error inesperado y no ha sido posible grabar las peticiones');
						}
					}
				}); 
	}
	
	var mismosDespachos = function(){
		if (comboDespachosOriginal.getValue()){
			if ('${idDespacho}'!=''){
				var b = comboDespachosOriginal.getValue() == '${idDespacho}';
				if (! b){
					Ext.Msg.alert('Incoherencia de datos', 'Para cambiar este tipo de gestor, el despacho/grupo debe coincidir con el seleccionado en la pantalla anterior');
				}
				return b;
			}else{
				return true;
			}
		}else{
			return true;
		}
	}
	
	var despachosCompatibles = function(){
		if (comboTipoGestor.getValue()){
			switch (comboTipoGestor.getValue()) {
				case 3: return mismosDespachos();
					break;
				case 4: return mismosDespachos();
					break;
				default: return true;	
			}			
		}else{
			return true;
		}
	};
	
	var btnAceptar = new Ext.Button({
       text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
       		if (despachosCompatibles()){
       			if (camposRellenos()){
 					grabaLasPeticiones();
				}else{
					Ext.Msg.alert('Faltan datos', 'Debe rellenar todos los campos de la ventana.');
				}
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
		code="plugin.cambiosMasivosAsuntos.cambiogestores.gestorDestino"
		text="**Cambiar por" />'
				,width: fieldSetsWidth
				,items:[comboTipoGestor, comboDespachosOriginal, comboGestorOriginal]
			},
			{
				title:'<s:message
		code="plugin.cambiosMasivosAsuntos.cambiogestores.fechas"
		text="**Entre las fechas" />'
				,width: fieldSetsWidth
				,items:[fechaInicio, fechaFin]
			}
  		]
	});	
	
	comboTipoGestor.on('select', function(){
		comboDespachosOriginal.reset();
		optionsDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue(), 'incluirBorrados': true}); 
		
		comboGestorOriginal.reset();
		comboGestorOriginal.setValue('');
		optionsGestorOriginalStore.removeAll();
		
		comboDespachosOriginal.setDisabled(false);		
		if (this.value) {
			comboDespachosOriginal.setDisabled(false);
		}else{
			comboDespachosOriginal.setDisabled(true);
		}
	});
	
	comboDespachosOriginal.on('select',function(){
		if (this.value){
			comboGestorOriginal.setDisabled(false);
			optionsGestorOriginalStore.webflow({despacho:this.value});
		}else{
			comboGestorOriginal.setDisabled(true);
		}
	});
	
	optionsGestorOriginalStore.on('load',function(){
		if (this.getCount() < 1){
			Ext.Msg.alert('Sin gestores', 'No se han encontrado gestores de �ste tipo en el despacho.');
		}
	});
	 
	fechaInicio.on('select',function(){
		if (this.value){
			fechaFin.setDisabled(false);
			fechaFin.minValue = this.getValue().add(Date.DAY,1);
		}else{
			fechaFin.setDisabled(true);
		}
	});
	 
	 var panelContenedor = new Ext.Panel({
	 	height:300
	 	,layout : 'column'
		,viewConfig : { columns : 1 }
		,items : [			
			panelEdicion]
		,bbar:[btnAceptar, btnCancelar]
	 });

	    
   	page.add(panelContenedor);
</fwk:page>
