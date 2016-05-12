<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<fwk:page>
	

	<pfs:textfield name="despacho" labelKey="plugin.config.despachoExterno.field.despacho"
		label="**Despacho" value="${despacho.despacho}" obligatory="true" />

	<pfs:textfield name="domicilio" labelKey="plugin.config.despachoExterno.field.domicilio"
		label="**Domicilio" value="${despacho.domicilio}" />

	<pfs:textfield name="domicilioPlaza"
		labelKey="plugin.config.despachoExterno.field.domicilioPlaza" label="**Domicilio plaza"
		value="${despacho.domicilioPlaza}" />

	<pfs:textfield name="personaContacto"
		labelKey="plugin.config.despachoExterno.field.personaContacto" label="**Persona de contacto"
		value="${despacho.personaContacto}" />
		
	<pfs:textfield name="codigoPostal"
		labelKey="plugin.config.despachoExterno.field.codigoPostal" label="**Codigo Postal"
		value="${despacho.codigoPostal}" />

	<pfs:textfield name="telefono1" labelKey="plugin.config.despachoExterno.field.telefono1"
		label="**Telefono 1" value="${despacho.telefono1}" />
		
	<pfs:textfield name="telefono2" labelKey="plugin.config.despachoExterno.field.telefono2"
		label="**Telefono 2" value="${despacho.telefono2}" />

	<pfsforms:ddCombo name="tipoVia"
		labelKey="plugin.config.despachoExterno.field.tipoVia" label="**Tipo de Via"
		value="${despacho.tipoVia}" dd="${ddTipoVia}" width="75" propertyCodigo="codigo"/>
		
	<pfsforms:ddCombo name="tipoDespacho"
		labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho"
		value="${despacho.tipoDespacho.id}" dd="${tiposDespachos}" />
		
	var DDtiposGestor = <app:dict value="${tiposGestor}"/>;
	var tipoGestor = app.creaDblSelect(DDtiposGestor
                              ,'<s:message code="plugin.config.despachoExterno.field.tipoGestor" text="**Tipo de gestor" />'
                              ,{width: 140,height: 140});    
    tipoGestor.disable();
    
    <%-- PRODUCTO-1274 Nuevos campos Despacho_Externo_Extras --%>	
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.fax" label="**Fax" name="fax" value="${despachoExtras.fax}" />	
	<pfs:datefield labelKey="plugin.config.despachoExternoExtras.field.fechaAlta" label="**Fecha alta" name="fechaAlta" value="${despachoExtras.fechaAlta}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.correoElectronico" label="**correoElectronico" name="correoElectronico" value="${despachoExtras.correoElectronico}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.tipoDocumento" label="**tipoDocumento" name="tipoDocumento" value="${despachoExtras.tipoDoc}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.documento" label="**documento CIF" name="documentoCif" value="${despachoExtras.documentoCif}" />
	
	<%-- PRODUCTO-1274 Campos de la petanya Datos adicionales --%>
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.contratoVigor" label="**Contrato en vigor" name="contratoVigor" value="${despachoExtras.contratoVigor}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.servicioIntegral" label="**Servicio integral" name="servicioIntegral" value="${despachoExtras.servicioIntegral}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.concursos" label="**Concursos" name="concursos" value="${despachoExtras.clasifDespachoConcursos}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.perfil" label="**Perfil" name="perfil" value="${despachoExtras.clasifDespachoPerfil}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.codEstAse" label="**Estado letrado" name="codEstAse" value="${despachoExtras.codEstAse}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaContacto" label="**Oficina Contacto" name="oficinaContacto" value="${despachoExtras.oficinaContacto}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadContacto" label="**Entidad Contacto" name="entidadContacto" value="${despachoExtras.entidadContacto}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadLiquidacion" label="**Entidad liquidacion" name="entidadLiquidacion" value="${despachoExtras.entidadLiquidacion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaLiquidacion" label="**Oficina liquidacion" name="oficinaLiquidacion" value="${despachoExtras.oficinaLiquidacion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconLiquidacion" label="**Digitos Control liq." name="digconLiquidacion" value="${despachoExtras.digconLiquidacion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaLiquidacion" label="**Cuenta liquidacion" name="cuentaLiquidacion" value="${despachoExtras.cuentaLiquidacion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadProvisiones" label="**Entidad provisiones" name="entidadProvisiones" value="${despachoExtras.entidadProvisiones}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaProvisiones" label="**Oficina provisiones" name="oficinaProvisiones" value="${despachoExtras.oficinaProvisiones}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconProvisiones" label="**Digitos Control prov." name="digconProvisiones" value="${despachoExtras.digconProvisiones}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaProvisiones" label="**Cuenta provisiones" name="cuentaProvisiones" value="${despachoExtras.cuentaProvisiones}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadEntregas" label="**Entidad entregas" name="entidadEntregas" value="${despachoExtras.entidadEntregas}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaEntregas" label="**Oficina entregas" name="oficinaEntregas" value="${despachoExtras.oficinaEntregas}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconEntregas" label="**Digitos Control ent." name="digconEntregas" value="${despachoExtras.digconEntregas}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaEntregas" label="**Cuenta entregas" name="cuentaEntregas" value="${despachoExtras.cuentaEntregas}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.centroRecuperacion" label="**Centro Recuperacion" name="centroRecuperacion" value="${despachoExtras.centroRecuperacion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.tieneAsesoria" label="**Asesoria" name="tieneAsesoria" value="${despachoExtras.asesoria}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.impuesto" label="**impuesto" name="impuesto" value="${despachoExtras.ivaDescripcion}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.irpfAplicado" label="**irpfAplicado" name="irpfAplicado" value="${despachoExtras.irpfAplicado}" />
	<pfs:datefield labelKey="plugin.config.despachoExternoExtras.field.fechaServicioIntegral" label="**Fecha SI" name="fechaServicioIntegral" value="${despachoExtras.fechaServicioIntegral}" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.relacionBankia" label="**Relacion Bankia" name="relacionBankia" value="${despachoExtras.relacionBankia}" />
	
	

	<%--
	var provinciasData = <app:dict value="${listaProvincias}" />;
    var comboProvincias = app.creaDblSelect(provinciasData 
    	,'<s:message code="plugin.config.despachoExterno.turnado.ventana.provincias" text="**Provincias" />'
    	,config);
    	
    var arrayProvinciasLetrado = [ 
	<c:forEach var="codigoProvincia" items="${ambitoDespachoExtras}" varStatus="status">
		<c:if test="${status.index>0}">,</c:if>'<c:out value="${codigoProvincia}" />'
	</c:forEach>
	];
    
	comboProvincias.setValue(arrayProvinciasLetrado);
	
	var ambitoActuacionFieldSet = new Ext.form.FieldSet({
		title : '<s:message code="plugin.config.despachoExterno.turnado.ventana.panelAmbActuacion.titulo" text="**Ambito actuación" />'
		,layout:'column'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:3px;cellspacing:20px;'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false, width:600 }
		,items : [{items:[comboComunidades,comboProvincias]}]
		,doLayout:function() {
				var margin = 40;
				this.setWidth(500-margin);
				Ext.Panel.prototype.doLayout.call(this);
		}
	});
     --%>
    
    var consultaGestorProp = function(valorId) {
    	if (valorId==undefined) return false;
    	page.webflow({
			flow : 'plugin/config/despachoExterno/ADMconsultarTipoGestorPropiedad'
			,params : {id:valorId}
			,success : function(response, config)
			{ 
				var recDatos = response['datos'];
				tipoGestor.enable();
				tipoGestor.reset();
				tipoGestor.setValue(recDatos['tiposGestorPropiedad']);
			}
			 ,failure : function(form,action){
			 	tipoGestor.enable();
				tipoGestor.reset();
			 }
		});
    };
	
	
	consultaGestorProp(${despacho.tipoDespacho.id});
	
	tipoDespacho.on('select',function(combo, record, index ){
		consultaGestorProp(combo.getValue());						 
	});
	
	var pestanaPrincipal = new Ext.Panel({
			title:'<s:message code="plugin.config.despachoExterno.editar.tabPrincipal.title" text="**Datos principales" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:400'}
			,items:[ {items: [despacho,tipoDespacho,tipoGestor,tipoDocumento, documentoCif, fechaAlta ]}
					,{items: [tipoVia,domicilio,domicilioPlaza,codigoPostal,personaContacto,telefono1,telefono2, fax, correoElectronico	]}
				   ]
		});
	
	var pestanaAdicionales = new Ext.Panel({
			title:'<s:message code="plugin.config.despachoExterno.consultadespacho.adicionales.title" text="**Datos adicionales" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:400'}
			,items:[ {items: [contratoVigor, servicioIntegral, codEstAse, oficinaContacto, entidadContacto, entidadLiquidacion, oficinaLiquidacion, digconLiquidacion, cuentaLiquidacion ]}
					,{items: [entidadProvisiones, oficinaProvisiones, digconProvisiones, cuentaProvisiones, entidadEntregas, oficinaEntregas, digconEntregas, cuentaEntregas, centroRecuperacion, tieneAsesoria, relacionBankia	]}
				   ]
		});
	
	var btnGuardarEditar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function() {
			<%--if (panelEdicion.getForm().isValid()){
				if(validarForm()){--%>
					var p = getParametros();
					Ext.Ajax.request({
						url : page.resolveUrl('plugin/config/despachoExterno/ADMguardarDespachoExterno'), 
						params : p,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
			<%--	}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
				}
			}
			else
			{											   		
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');						
			} --%>
	   	}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var getParametros = function() {
	 	var parametros = {};
	 	
	 	parametros.id='${despacho.id}';
	 	parametros.despacho=despacho.getValue();
		parametros.tipoVia=tipoVia.getValue();
		parametros.domicilio=domicilio.getValue();
		parametros.domicilioPlaza=domicilioPlaza.getValue();
		parametros.codigoPostal=codigoPostal.getValue();
		parametros.personaContacto=personaContacto.getValue();
		parametros.telefono1=telefono1.getValue();
		parametros.telefono2=telefono2.getValue();
		parametros.tipoDespacho=tipoDespacho.getValue();
		parametros.tipoGestor=tipoGestor.getValue();
		parametros.fax=fax.getValue();
		parametros.fechaAlta=fechaAlta.getValue();
		parametros.correoElectronico=correoElectronico.getValue();
		parametros.tipoDocumento=tipoDocumento.getValue();
		parametros.documentoCif=documentoCif.getValue();
	 	
		return parametros;
	}
	
		
	var panelEdicion=new Ext.form.FormPanel({
		 id:'tabsinform-form'
		,border:false
		,height: 450
		,width : 1400
		,bodyStyle:'width:1400'
	  	,items: {
			 xtype: 'tabpanel'
			,id:'idTabPanel'
			,activeItem:0
			,border : false	
			,anchor:'100% 100%'
			//,deferredRender:false
			,height: 350
			//,autoWidth : true
			,items:[ pestanaPrincipal,pestanaAdicionales]
		}
		,bbar : [btnGuardarEditar, btnCancelar]
	});	

	page.add(panelEdicion);

<%--                  
	<pfs:defineParameters name="parametros" paramId="${despacho.id}" 
		despacho="despacho"
		tipoVia="tipoVia"
		domicilio="domicilio"
		domicilioPlaza="domicilioPlaza"
		codigoPostal="codigoPostal"
		personaContacto="personaContacto"
		telefono1="telefono1"
		telefono2="telefono2"
		tipoDespacho="tipoDespacho"
		tipoGestor="tipoGestor"
		/>

	<pfs:editForm saveOrUpdateFlow="plugin/config/despachoExterno/ADMguardarDespachoExterno"
		leftColumFields="despacho,tipoDespacho,tipoGestor"
		rightColumFields="tipoVia,domicilio,domicilioPlaza,codigoPostal,personaContacto,telefono1,telefono2"
		parameters="parametros" onSuccessMode="tab" 
			tab_titleData="despacho" tab_iconCls="icon_despacho" tab_paramName="id" tab_paramValue="despacho.id" 
			tab_flow="plugin/config/despachoExterno/ADMconsultarDespachoExterno" tab_type="DespachoExterno"/> 
		
--%>
			
</fwk:page>