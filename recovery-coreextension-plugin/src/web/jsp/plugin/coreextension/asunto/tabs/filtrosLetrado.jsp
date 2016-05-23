<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>

(function(){
	var limit=25;
	var config = {width: 90, height: 150, labelStyle:"width:1px", padding:5};
	
	//Campo Nombre Despacho-Letrado
	<%--var nombreDespacho = new Ext.form.TextField({
		fieldLabel:'<s:message code="asuntos.busqueda.filtros.tabs.filtrosLetrados.despacho.text" text="**Despacho" />'
		,name:'nombre'
		,listeners:{
			specialkey: function(f,e){  
	            if (e.getKey() == e.ENTER) {
	                buscarFunc();
	            }  
	        } 
		}
		<app:test id="nombreLetrado" addComa="true"/>
	});
	
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
	
	var tipoDocumento = app.creaText('tipoDocumento', '<s:message code="plugin.config.despachoExternoExtras.field.tipoDocumento" text="**tipoDocumento" />'); 
	var documentoCif = app.creaText('documentoCif', '<s:message code="plugin.config.despachoExternoExtras.field.documento" text="**documentoCif" />'); 
 --%>	
	var oficinaContacto = app.creaText('oficinaContacto', '<s:message code="plugin.config.despachoExternoExtras.field.oficinaContacto" text="**Oficina Contacto" />'); 
	var entidadContacto = app.creaText('entidadContacto', '<s:message code="plugin.config.despachoExternoExtras.field.entidadContacto" text="**entidadContacto" />'); 
	var entidadLiquidacion = app.creaText('entidadLiquidacion', '<s:message code="plugin.config.despachoExternoExtras.field.entidadLiquidacion" text="**entidadLiquidacion" />'); 
	var oficinaLiquidacion = app.creaText('oficinaLiquidacion', '<s:message code="plugin.config.despachoExternoExtras.field.oficinaLiquidacion" text="**oficinaLiquidacion" />'); 
	var digconLiquidacion = app.creaText('digconLiquidacion', '<s:message code="plugin.config.despachoExternoExtras.field.digconLiquidacion" text="**digconLiquidacion" />'); 
	var cuentaLiquidacion = app.creaText('cuentaLiquidacion', '<s:message code="plugin.config.despachoExternoExtras.field.cuentaLiquidacion" text="**cuentaLiquidacion" />'); 
	var entidadProvisiones = app.creaText('entidadProvisiones', '<s:message code="plugin.config.despachoExternoExtras.field.entidadProvisiones" text="**entidadProvisiones" />'); 
	var oficinaProvisiones = app.creaText('oficinaProvisiones', '<s:message code="plugin.config.despachoExternoExtras.field.oficinaProvisiones" text="**oficinaProvisiones" />'); 
	var digconProvisiones = app.creaText('digconProvisiones', '<s:message code="plugin.config.despachoExternoExtras.field.digconProvisiones" text="**digconProvisiones" />'); 
	var cuentaProvisiones = app.creaText('cuentaProvisiones', '<s:message code="plugin.config.despachoExternoExtras.field.cuentaProvisiones" text="**cuentaProvisiones" />'); 
	var entidadEntregas = app.creaText('entidadEntregas', '<s:message code="plugin.config.despachoExternoExtras.field.entidadEntregas" text="**entidadEntregas" />'); 
	var digconEntregas = app.creaText('digconEntregas', '<s:message code="plugin.config.despachoExternoExtras.field.digconEntregas" text="**digconEntregas" />'); 
	var oficinaEntregas = app.creaText('oficinaEntregas', '<s:message code="plugin.config.despachoExternoExtras.field.oficinaEntregas" text="**oficinaEntregas" />'); 
	var cuentaEntregas = app.creaText('cuentaEntregas', '<s:message code="plugin.config.despachoExternoExtras.field.cuentaEntregas" text="**cuentaEntregas" />');
	var centroRecuperacion = app.creaText('centroRecuperacion', '<s:message code="plugin.config.despachoExternoExtras.field.centroRecuperacion" text="**centroRecuperacion" />');
	
	var perfilStore = 
		<json:array name="ddPerfil" items="${mapasDespExtras[1]}" var="d">	
			<json:property name="descripcion" value="${d}" />
		</json:array>;
	
	var perfil=new Ext.form.ComboBox({
		store: perfilStore
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="plugin.config.despachoExternoExtras.field.perfil" text="**Perfil" />'
		,width:125
	})
	
	<pfsforms:ddCombo name="concursos"
		labelKey="plugin.config.despachoExternoExtras.field.concursos"
		label="**Concursos" value="" dd="${ddSiNo}" width="125" propertyCodigo="codigo"/>	
	
	var clasifDespachoFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExternoExtras.fieldSet.title" text="**Clasif Despacho" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:300 }
		,items : [{items:[perfil, concursos]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(340-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
	
	var provinciasData = <app:dict value="${listaProvincias}" />;
   	var comboProvincias = app.creaDblSelect(provinciasData 
    	,'<s:message code="plugin.config.despachoExterno.turnado.ventana.provincias" text="**Provincias" />'
    	,config);

	var contratoStore =
		<json:array name="ddContrato" items="${mapasDespExtras[0]}" var="d">	
			 	  <json:property name="descripcion" value="${d}" />
		</json:array>;

	var contratoVigor=new Ext.form.ComboBox({
		store: contratoStore
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="plugin.config.despachoExternoExtras.field.contratoVigor" text="**Contrato en vigor" />'
		,width:150
	});
	
	<pfsforms:ddCombo name="servicioIntegral"
		labelKey="plugin.config.despachoExternoExtras.field.servicioIntegral"
		label="**servicioIntegral" value="" dd="${ddSiNo}" width="150" propertyCodigo="codigo"/>
		
	var codEstAseStore = 
		<json:array name="ddCodEstAse" items="${mapasDespExtras[2]}" var="d">	
			 	  <json:property name="descripcion" value="${d}" />
		</json:array>;
	
	var codEstAse=new Ext.form.ComboBox({
		store: codEstAseStore
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="plugin.config.despachoExternoExtras.field.codEstAse" text="**codEstAse" />'
		,width:150
	});	
		
	var relacionBankiaStore = 
		<json:array name="ddrelacionBankia" items="${mapasDespExtras[4]}" var="d">	
			 	  <json:property name="descripcion" value="${d}" />
		</json:array>;
	
	var relacionBankia=new Ext.form.ComboBox({
		store: relacionBankiaStore
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="plugin.config.despachoExternoExtras.field.relacionBankia" text="**relacionBankia" />'
		,width:150
	});	
	
	<pfsforms:ddCombo name="tieneAsesoria"
		labelKey="plugin.config.despachoExternoExtras.field.tieneAsesoria"
		label="**tieneAsesoria" value="" dd="${ddSiNo}" width="150" propertyCodigo="codigo"/>

	var validarEmptyForm = function(){
	debugger;
	try{	
		if (comboProvincias.getValue() != '' ){
			return true;
		}
		if (perfil.getValue() != '' ){
			return true;
		}
		if (concursos.getValue() != '' ){
			return true;
		}
		if (codEstAse.getValue() != '' ){
			return true;
		}
		if (servicioIntegral.getValue() != '' ){
			return true;
		}
		if (relacionBankia.getValue() != '' ){
			return true;
		}
		if (oficinaContacto.getValue() != '' ){
			return true;
		}
		if (entidadContacto.getValue() != '' ){
			return true;
		}
		if (entidadLiquidacion.getValue() != '' ){
			return true;
		}
		if (oficinaLiquidacion.getValue() != '' ){
			return true;
		}
		if (digconLiquidacion.getValue() != '' ){
			return true;
		}
		if (cuentaLiquidacion.getValue() != '' ){
			return true;
		}
		if (entidadProvisiones.getValue() != '' ){
			return true;
		}
		if (oficinaProvisiones.getValue() != '' ){
			return true;
		}
		if (digconProvisiones.getValue() != '' ){
			return true;
		}
		if (cuentaProvisiones.getValue() != '' ){
			return true;
		}
		if (entidadEntregas.getValue() != '' ){
			return true;
		}
		if (oficinaEntregas.getValue() != '' ){
			return true;
		}
		if (digconEntregas.getValue() != '' ){
			return true;
		}
		if (cuentaEntregas.getValue() != '' ){
			return true;
		}
		if (centroRecuperacion.getValue() != '' ){
			return true;
		}
		if (tieneAsesoria.getValue() != '' ){
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
			listaProvincias: comboProvincias.getValue()
			,clasificacionPerfil: perfil.getValue()
			,clasificacionConcursos: concursos.getValue()
			,codEstAse: codEstAse.getValue()
			,contratoVigor: contratoVigor.getValue()
			,servicioIntegral: servicioIntegral.getValue()
			,relacionBankia: relacionBankia.getValue()
			,oficinaContacto: oficinaContacto.getValue()
			,entidadContacto: entidadContacto.getValue()
			,entidadLiquidacion: entidadLiquidacion.getValue()
			,oficinaLiquidacion: oficinaLiquidacion.getValue()
			,digconLiquidacion: digconLiquidacion.getValue()
			,cuentaLiquidacion: cuentaLiquidacion.getValue()
			,entidadProvisiones: entidadProvisiones.getValue()
			,oficinaProvisiones: oficinaProvisiones.getValue()
			,digconProvisiones: digconProvisiones.getValue()
			,cuentaProvisiones: cuentaProvisiones.getValue()
			,entidadEntregas: entidadEntregas.getValue()
			,oficinaEntregas: oficinaEntregas.getValue()
			,digconEntregas: digconEntregas.getValue()
			,cuentaEntregas: cuentaEntregas.getValue()
			,centroRecuperacion: centroRecuperacion.getValue()
			,asesoria: tieneAsesoria.getValue()
		};
	};

	var panel=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="asuntos.busqueda.filtros.tabs.filtrosLetrados.title" text="**Filtro letrados" />'
		,id: 'tabLetradosBuscadorAsuntos'
		,layoutConfig:{columns:4}
	    ,header: false
	    ,border:false
		//,titleCollapse : true
		//,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:20px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding-left:20px;padding-right:20px;padding-top:1px;padding-bottom:1px;cellspacing:20px'}
		,items:[ 
				{items: [ contratoVigor, servicioIntegral, codEstAse, tieneAsesoria, relacionBankia, clasifDespachoFieldSet ]}
				,{items: [ oficinaContacto, entidadContacto, entidadLiquidacion, oficinaLiquidacion, digconLiquidacion, cuentaLiquidacion, entidadProvisiones, oficinaProvisiones ]}
				,{items: [ digconProvisiones, cuentaProvisiones, entidadEntregas, oficinaEntregas, digconEntregas, cuentaEntregas, centroRecuperacion]}
				,{items: [  comboProvincias]}
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
    		           comboProvincias
    		           ,contratoVigor
    		           ,servicioIntegral
    		           ,codEstAse
    		           ,oficinaContacto
    		           ,entidadContacto
    		           ,entidadLiquidacion
    		           ,oficinaLiquidacion
    		           ,digconLiquidacion
    		           ,cuentaLiquidacion
    		           ,entidadProvisiones
    		           ,oficinaProvisiones
    		           ,digconProvisiones
    		           ,cuentaProvisiones
    		           ,entidadEntregas
    		           ,oficinaEntregas
    		           ,digconEntregas
    		           ,cuentaEntregas
    		           ,centroRecuperacion
    		           ,tieneAsesoria
    		           ,relacionBankia
    		           ,perfil
    		           ,concursos
	           ]); 
    		}
		}
	});

    return panel;
    
})()