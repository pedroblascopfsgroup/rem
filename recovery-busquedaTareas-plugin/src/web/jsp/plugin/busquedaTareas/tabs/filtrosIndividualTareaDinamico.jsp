<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){

    var busquedaUsuario = new Ext.form.TextField({
		width:220
		,fieldLabel:'<s:message code="plugin.busquedaTareas.gestorOSupervisor" text="**Nombre" />'
		,listeners:{
			specialkey: function(f,e){  
	            if ((e.getKey()==e.ENTER) && (this.getValue().length > 0)) {  
	                buscarFunc();
	            }  
	        } 
		}
		,value:''
	});
	
	//Listado de despachos, viene del flow
	var dictDespachos = <app:dict value="${despachos}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	//store generico de combo diccionario
	var optionsDespachosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDespachos
	});
	
	//Campo Combo Despacho
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				
				}
				,fieldLabel : '<s:message code="plugin.busquedaTareas.filtroDespachos" text="**Despacho"/>'
				<app:test id="comboDespachos" addComa="true"/>
	});

 
 	var gestores={diccionario:[]};
			
	recargarComboGestores = function(){
		if (comboDespachos.getValue()!=null && comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		}else{
			optionsGestoresStore.webflow({id:0});
		}
	};
	
	//Campo Gestores, double select
	var filtroGestores = app.creaDblSelect(gestores,'<s:message code="plugin.busquedaTareas.filtroGestores" text="**Gestor" />'
		,{store:optionsGestoresStore
		  ,funcionReset:recargarComboGestores <app:test id="filtroGestores" addComa="true"/>		  
		}
	);
	
	
	var limpiarYRecargarGestores = function(){
		recargarComboGestores();
	}
	
	//Listado de tipos de gestor, viene del flow
	var dictTiposGestor = <app:dict value="${tiposGestor}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store para los tipos de testor
	var optionsTiposGestor = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTiposGestor
	});
	
	//Campo Combo Tipos de Gestor
	var comboTiposGestor = new Ext.form.ComboBox({
				store:optionsTiposGestor
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,listeners:{
					specialkey: function(f,e){  
			            if((e.getKey() == e.ENTER) && (this.getValue() != '') && (this.getValue() != 0)) {
			                buscarFunc();
			            }  
			        } 
				}
				,fieldLabel : '<s:message code="plugin.busquedaTareas.filtroTipoGestor" text="**Tipo de gestor"/>'
				<app:test id="comboTiposGestor" addComa="true"/>
	});
	
	var comboTipoIntervencion=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO" />','<s:message code="plugin.busquedaTareas.filtroTipoIntervencion.sup" text="**Como supervisor" />'],['<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR" />','<s:message code="plugin.busquedaTareas.filtroTipoIntervencion.ges" text="**Como gestor" />']<%--,['3','De usuario'] --%>]
		,allowBlank: false
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroTipoIntervencion" text="**Tipo de intervención" />'
		,width:175
		,resizable: true
		,value:''
		,listeners:{
			afterRender:function(){
				aplicarVisibilidadFiltros();
			}
			,specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 	
		}
	});
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboGestores = function(){
		if (comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
			filtroGestores.enable();
			comboTiposGestor.enable();
		}else if (busquedaUsuario.getvalue()!=''){
			comboTiposGestor.enable();
		}else{
			//comboSupervisor.setValue('');
			optionsGestoresStore.removeAll();
		}
	}
	
	var bloquearCombos = function(){
		filtroGestores.disable();
		//comboTiposGestor.disable();
		if (comboTiposGestor.getValue() != '<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR" />'){
			comboTipoIntervencion.disable();
		}
	}
	
	comboDespachos.on('focus',bloquearCombos);
	
	busquedaUsuario.on('focus',bloquearCombos);
	
	busquedaUsuario.on('change',function(){
		if (comboTiposGestor.getValue()==''){
			comboTiposGestor.setValue('<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO" />');
		}
	});
	
	comboDespachos.on('change',recargarComboGestores);
	
	bloquearCombos();
	
	comboDespachos.on('select',limpiarYRecargarGestores);
	
	comboTiposGestor.on('select', function(){
		if (comboTiposGestor.getValue()=='<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR" />'){
			comboTipoIntervencion.enable();
			comboTipoIntervencion.setValue('<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR" />');
		}else{
			comboTipoIntervencion.reset();
			comboTipoIntervencion.disable();
		}
	});
	
	var tabFiltrosUsuario = false;		
				
	var filtrosDeUsuarioTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros4" text="**Filtros de usuario" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items: [busquedaUsuario,{html:'<br />', bodyStyle: 'border:0'}, comboDespachos, filtroGestores]
			},{
				layout:'form'
				,items: [comboTiposGestor, comboTipoIntervencion]
			}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
			,limpiar: function() {
    		   			app.resetCampos([      
    		           		filtroGestores, comboTiposGestor, comboTipoIntervencion, comboDespachos, busquedaUsuario
	          			 ]); 
    				}
    			}
	});
	
	var validarEmptyForm = function(){
		
		if(busquedaUsuario.getValue() != '' && busquedaUsuario.getValue() )
			return true;
			
		try{
			if(comboDespachos.getValue() != '' && comboDespachos.getValue() )
				return true;	
			if(filtroGestores.getValue() != '' && filtroGestores.getValue() )
				return true;	
			if(comboTiposGestor.getValue() != '' && comboTiposGestor.getValue() )
				return true;	
			if(comboTipoIntervencion.getValue() != '' && comboTipoIntervencion.getValue() )
				return true;	
			
		}catch(err){
			<%--console.debug(err); --%>
		};		
		return false;			
	}	
	
	var getParametros = function() {
		
		return {busquedaUsuario: busquedaUsuario.getValue()
			,despacho: comboDespachos.getValue()
			,gestores: filtroGestores.getValue()
			,tipoGestor: comboTiposGestor.getValue()
			,tipoGestorTarea: comboTipoIntervencion.getValue()
			
		};
	};
	
	
	filtrosDeUsuarioTabBuscaTareas.on('activate',function(){
		tabFiltrosUsuario=true;
	});
    
    

    return filtrosDeUsuarioTabBuscaTareas;
    
})()