<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(){
 
   	var comboAmbitoConsulta=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['1','Grupo'],['2','Individual']]
		,allowBlank: false
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroAmbitoTareas" text="**Ámbito de tareas" />'
		,width:100
		,resizable: true
		,value:'1'
		,listeners:{
			afterRender:function(){
				aplicarVisibilidadFiltros();
			}
			,specialkey: function(f,e){  
	            if(e.getKey() == e.ENTER) {
	                buscarFunc();
	            } 
	        } 
		}
	});
	
	var comboEstadoTarea=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['','Todos'],['1','Pendientes'],['2','Terminadas'],['3','Terminadas y vencidas']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroEstado" text="**Estado" />'
		,width:100
		,resizable: true
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey() == e.ENTER) {
	                buscarFunc();
	            }
	        } 
		}
		,value:'${estadoTarea}'
	});
	
	var comboUgRelacionada=new Ext.form.ComboBox({
		store:[['','Todas'],['1','Cliente'],['2','Expediente'],['3','Asunto'],['4','Tarea'],['5','Procedimiento'],['6','Contrato']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.cabeceraUnidadGestion" text="**Unidad de gestiÃ³n" />'
		,width:100
		,resizable: true
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		,value:'${ugGestion}'
	});
	
	var comboTipotarea=new Ext.form.ComboBox({
		store:[['','Todas'],['3','Notificación'],['1','Tarea']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroClasificacion" text="**Clasificación" />'
		,width:100
		,resizable: true
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,value:'${codigoTipoTarea}'
	});
    
   aplicarVisibilidadFiltros = function(){
		if (comboAmbitoConsulta.getValue() == "1") {
			
			deshabilitarTabGrupos(false);
			deshabilitarTabIndividual(true);

		}
		if (comboAmbitoConsulta.getValue() == "2") {

			deshabilitarTabGrupos(true);
			deshabilitarTabIndividual(false);
			
		}
		
	};
	
	comboAmbitoConsulta.on('select', aplicarVisibilidadFiltros);
	
	// combo dependiente del tipo de tarea -------------
	
	var tipoSubtarea = Ext.data.Record.create([
		 {name:'codigoSubtarea'}
		,{name:'descripcion'}
	]);

	

	var comboTipoSubtarea=new Ext.form.ComboBox({
		store: tipoSubtareaStore
		,disabled: true
		,displayField: 'descripcion'
		,valueField: 'codigoSubtarea'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroTipo" text="**Tipo" />'
		,width:175
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,value:'${codigoTipoSubTarea}'
	});
	
	var recargarComboTipoSubtarea = function(){
		comboTipoSubtarea.store.removeAll();
		comboTipoSubtarea.clearValue();
		if (comboTipotarea.getValue()!=null && comboTipotarea.getValue()!=''){
			comboTipoSubtarea.store.webflow({id:comboTipotarea.getValue()});
		}
	}
	
	comboTipotarea.on('select', function(){
		comboTipoSubtarea.setDisabled(false);	
		recargarComboTipoSubtarea();
	});
	
	<pfs:textfield name="usernameUsuario"
		labelKey="plugin.busquedaTareas.filtroUserUsuario" label="**Usuario"
		value="" searchOnEnter="true" />
		
	var descTarea = new Ext.form.TextField({
		width:220
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroNbTarea" text="**Nombre Tarea" />'
		,listeners:{
			specialkey: function(f,e){  
	            if((e.getKey() == e.ENTER) && (this.getValue() != '')) {
	                buscarFunc();
	            }  
	        } 
		}
		,value:''
	});
	
	var nombreTarea = new Ext.form.TextField({
		width:220
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroDescripcion" text="**Descripcion Tarea" />'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER && this.getValue().length > 0){  
	                buscarFunc();
	            }  
	        } 
		}
		,value:''
	});

	var tabCamposTareas =false;	
	
	var validarEmptyForm = function(){
		
		if(nombreTarea.getValue() != '' && nombreTarea.getValue() )
			return true;
		if(descTarea.getValue() != '' && descTarea.getValue() )
			return true;
			
		try{
			if(comboAmbitoConsulta.getValue() != '' && comboAmbitoConsulta.getValue() )
				return true;	
			if(comboEstadoTarea.getValue() != '' && comboEstadoTarea.getValue() )
				return true;	
			if(comboUgRelacionada.getValue() != '' && comboUgRelacionada.getValue() )
				return true;	
			if(comboTipotarea.getValue() != '' && comboTipotarea.getValue() )
				return true;	
			if(comboTipoSubtarea.getValue() != '' && comboTipoSubtarea.getValue() )
				return true;
			
		}catch(err){
			<%--console.debug(err); --%>
		};		
		return false;			
	}
	

	var getParametros = function() {
		
		return {nombreTarea: nombreTarea.getValue()
			,descripcionTarea: descTarea.getValue()
			,ambitoTarea: comboAmbitoConsulta.getValue()
			,estadoTarea: comboEstadoTarea.getValue()
			,ugGestion: comboUgRelacionada.getValue()
			,codigoTipoTarea: comboTipotarea.getValue()
			,codigoTipoSubTarea: comboTipoSubtarea.getValue()
			
		};
	};
	
	var filtrosDeCampoTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros1" text="**Datos basicos" />'
		,autoHeight:true
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items: [comboAmbitoConsulta, comboEstadoTarea, comboUgRelacionada]
			},{
				layout:'form'
				,items: [nombreTarea, descTarea]
			},{
				layout:'form'
				,items: [comboTipotarea, comboTipoSubtarea]
			}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
    		,limpiar: function() {
    		   app.resetCampos([      
    		           	comboAmbitoConsulta,	comboEstadoTarea, descTarea, comboTipotarea, nombreTarea, comboTipoSubtarea,
						comboUgRelacionada, usernameUsuario
	           ]); 
    		}
    	}
	});

	filtrosDeCampoTabBuscaTareas.on('activate',function(){
		tabCamposTareas=true;
	});

    return filtrosDeCampoTabBuscaTareas;
    
})()