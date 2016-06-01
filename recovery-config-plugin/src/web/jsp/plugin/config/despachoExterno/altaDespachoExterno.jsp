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

	var config = {width: 90, height: 150, labelStyle:"width:1px", padding:5};

	<pfs:textfield name="despacho" labelKey="plugin.config.despachoExterno.field.despacho"
		label="**Despacho" value="${despacho.despacho}" obligatory="true" maxLength="100" />

	<pfs:textfield name="domicilio" labelKey="plugin.config.despachoExterno.field.domicilio"
		label="**Domicilio" value="${despacho.domicilio}" maxLength="100" />

	<pfs:textfield name="domicilioPlaza"
		labelKey="plugin.config.despachoExterno.field.domicilioPlaza" label="**Domicilio plaza"
		value="${despacho.domicilioPlaza}" maxLength="100" />

	<pfs:textfield name="personaContacto"
		labelKey="plugin.config.despachoExterno.field.personaContacto" label="**Persona de contacto"
		value="${despacho.personaContacto}" maxLength="100" />
		
	<pfs:textfield name="codigoPostal"
		labelKey="plugin.config.despachoExterno.field.codigoPostal" label="**Codigo Postal"
		value="${despacho.codigoPostal}" maxLength="5" />

	<pfs:textfield name="telefono1" labelKey="plugin.config.despachoExterno.field.telefono1"
		label="**Telefono 1" value="${despacho.telefono1}" maxLength="100" />
		
	<pfs:textfield name="telefono2" labelKey="plugin.config.despachoExterno.field.telefono2"
		label="**Telefono 2" value="${despacho.telefono2}" maxLength="100" />

	<pfsforms:ddCombo name="tipoVia"
		labelKey="plugin.config.despachoExterno.field.tipoVia" label="**Tipo de Via"
		value="" dd="${ddTipoVia}" width="75" propertyCodigo="codigo"/>
 	tipoVia.setValue('${despacho.tipoVia}');
 	
	<pfsforms:ddCombo name="tipoDespacho"
		labelKey="plugin.config.despachoExterno.field.tipoDespacho" label="**Tipo de despacho"
		value="${despacho.tipoDespacho.id}" dd="${tiposDespachos}" />
		
	var DDtiposGestor = <app:dict value="${tiposGestor}"/>;
	var tipoGestor = app.creaDblSelect(DDtiposGestor
                              ,'<s:message code="plugin.config.despachoExterno.field.tipoGestor" text="**Tipo de gestor" />'
                              ,{width: 140,height: 140});    
    tipoGestor.disable();
    
    <%-- Desactiva este combo si se ha abierto esta pantalla para modificar al despacho --%>
    if(tipoDespacho.getValue() != '') {
    	tipoDespacho.setDisabled(true);
    }
    
    tipoDespacho.on('select', function(){
    	if(tipoDespacho.getValue() == ${idTipoLetrado}) {
    		pestanaAdicionales.setDisabled(false);
    	} else {
    		pestanaAdicionales.setDisabled(true);
    		resetCamposAdicionales();
    	}
    	
    });
    
    <%-- PRODUCTO-1274 Nuevos campos Despacho_Externo_Extras --%>	
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.fax" label="**Fax" name="fax" value="${despachoExtras.fax}" maxLength="100" />	
	<pfs:datefield labelKey="plugin.config.despachoExternoExtras.field.fechaAlta" label="**Fecha alta" name="fechaAlta" />
	fechaAlta.setValue('${despachoExtras.fechaAlta}');
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.correoElectronico" label="**correoElectronico" name="correoElectronico" value="${despachoExtras.correoElectronico}" maxLength="100" />
	
	<%-- PRODUCTO-1274 Campos de la pestanya Datos adicionales --%>
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaContacto" label="**Oficina Contacto" name="oficinaContacto" value="${despachoExtras.oficinaContacto}" maxLength="5" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadContacto" label="**Entidad Contacto" name="entidadContacto" value="${despachoExtras.entidadContacto}" maxLength="5" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadLiquidacion" label="**Entidad liquidacion" name="entidadLiquidacion" value="${despachoExtras.entidadLiquidacion}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaLiquidacion" label="**Oficina liquidacion" name="oficinaLiquidacion" value="${despachoExtras.oficinaLiquidacion}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconLiquidacion" label="**Digitos Control liq." name="digconLiquidacion" value="${despachoExtras.digconLiquidacion}" maxLength="2" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaLiquidacion" label="**Cuenta liquidacion" name="cuentaLiquidacion" value="${despachoExtras.cuentaLiquidacion}" maxLength="10" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadProvisiones" label="**Entidad provisiones" name="entidadProvisiones" value="${despachoExtras.entidadProvisiones}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaProvisiones" label="**Oficina provisiones" name="oficinaProvisiones" value="${despachoExtras.oficinaProvisiones}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconProvisiones" label="**Digitos Control prov." name="digconProvisiones" value="${despachoExtras.digconProvisiones}"  maxLength="2" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaProvisiones" label="**Cuenta provisiones" name="cuentaProvisiones" value="${despachoExtras.cuentaProvisiones}" maxLength="10" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.entidadEntregas" label="**Entidad entregas" name="entidadEntregas" value="${despachoExtras.entidadEntregas}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.oficinaEntregas" label="**Oficina entregas" name="oficinaEntregas" value="${despachoExtras.oficinaEntregas}" maxLength="4" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.digconEntregas" label="**Digitos Control ent." name="digconEntregas" value="${despachoExtras.digconEntregas}" maxLength="2" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.cuentaEntregas" label="**Cuenta entregas" name="cuentaEntregas" value="${despachoExtras.cuentaEntregas}" maxLength="10" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.centroRecuperacion" label="**Centro Recuperacion" name="centroRecuperacion" value="${despachoExtras.centroRecuperacion}" maxLength="60" />
	<pfs:textfield labelKey="plugin.config.despachoExternoExtras.field.irpfAplicado" label="**irpfAplicado" name="irpfAplicado" value="${despachoExtras.irpfAplicado}" />
	<pfs:datefield labelKey="plugin.config.despachoExternoExtras.field.fechaServicioIntegral" label="**Fecha SI" name="fechaServicioIntegral" value="${despachoExtras.fechaServicioIntegral}" />
	
	<pfsforms:ddCombo name="tipoDocumento"
		labelKey="plugin.config.despachoExternoExtras.field.tipoDocumento" label="**Tipo de documento"
		value="" dd="${tiposDocumentos}" />
	tipoDocumento.setValue('${despachoExtras.doc.id}');	
	
	var documentoCif = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.config.despachoExternoExtras.field.documento" text="**documentoCif" />' 
		,value:'${despachoExtras.documentoCif}'
		,maxLength: 10
		,enforceMaxLength: true
		,width: 180
	});
	
	documentoCif.on('change', function(){
	 if(documentoCif.getValue().length > 10) {
	 	documentoCif.setValue(documentoCif.getValue().substr(0,10));
	 }
	});
	
	<pfsforms:ddCombo name="concursos"
		labelKey="plugin.config.despachoExternoExtras.field.concursos"
		label="**Concursos" value="" dd="${ddSiNo}" width="125" propertyCodigo="codigo"/>	
	concursos.setValue('${despachoExtras.clasifDespachoConcursos}');
	
	
	<pfsforms:ddCombo name="tieneAsesoria"
		labelKey="plugin.config.despachoExternoExtras.field.tieneAsesoria"
		label="**tieneAsesoria" value="" dd="${ddSiNo}" width="150" propertyCodigo="codigo"/>
	tieneAsesoria.setValue('${despachoExtras.asesoria}');
	
	<pfsforms:ddCombo name="servicioIntegral"
		labelKey="plugin.config.despachoExternoExtras.field.servicioIntegral"
		label="**servicioIntegral" value="" dd="${ddSiNo}" width="150" propertyCodigo="codigo"/>
	servicioIntegral.setValue('${despachoExtras.servicioIntegral}');
	
	<%-- PRODUCTO-1274 Combos con valores que se mapean por ac-plugin-coreextension-projectContext.xml--%>
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
		,value:'${despachoExtras.contratoVigor}'
	})
	
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
		,value:'${despachoExtras.clasifDespachoPerfil}'
	});
	
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
		,value:'${despachoExtras.codEstAse}'
	});
	
	
	var impuestoStore = 
		<json:array name="ddimpuesto" items="${mapasDespExtras[3]}" var="d">	
			 	  <json:property name="descripcion" value="${d}" />
		</json:array>;
		
	<!-- Este campo no se muestra, pero lo dejo, si lo piden en un futuro, solo hay que anyadir impuesto a los items de las pestanyas  -->
	var impuesto=new Ext.form.ComboBox({
		store: impuestoStore
		,triggerAction : 'all'
		,mode:'local'
		//,labelSeparator:""
		,fieldLabel:'<s:message code="plugin.config.despachoExternoExtras.field.impuesto" text="**impuesto" />'
		,width:150
		,value:'${despachoExtras.ivaDescripcion}'
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
		,value:'${despachoExtras.relacionBankia}'
	});

	   	
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
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:500'}
			,items:[ {items: [despacho,tipoDespacho,tipoGestor,tipoDocumento, documentoCif, fechaAlta ]}
					,{items: [tipoVia,domicilio,domicilioPlaza,codigoPostal,personaContacto,telefono1,telefono2, fax, correoElectronico	]}
				   ]
		});
	 
	var pestanaAdicionales = new Ext.Panel({
			title:'<s:message code="plugin.config.despachoExterno.consultadespacho.adicionales.title" text="**Datos adicionales" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:3}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:300'}
			,items:[ {items: [clasifDespachoFieldSet, comboProvincias,contratoVigor, servicioIntegral, codEstAse]}
					,{items: [ oficinaContacto, entidadContacto, entidadLiquidacion, oficinaLiquidacion, digconLiquidacion, cuentaLiquidacion, entidadProvisiones, oficinaProvisiones, digconProvisiones, cuentaProvisiones ]}
					,{items: [ entidadEntregas, oficinaEntregas, digconEntregas, cuentaEntregas, centroRecuperacion, tieneAsesoria, relacionBankia	]}
				   ]
		});
	
	pestanaAdicionales.setDisabled(true);
	if(tipoDespacho.getValue() == ${idTipoLetrado}) {
		pestanaAdicionales.setDisabled(false);
	}
	
	var btnGuardarEditar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function() {
			<%--if (panelEdicion.getForm().isValid()){--%>
				if(validarForm() && validarFormAdicionales()){
					var p = getParametros();
					Ext.Ajax.request({
						url : page.resolveUrl('plugin/config/despachoExterno/ADMguardarDespachoExterno'), 
						params : p,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');
				}
			<%--}
			else
			{											   		
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');					
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
	
	<%-- Producto-1274 Valida tamaño campos de DES_DESPACHO_EXTERNO --%>
	var validarForm = function() {
		
		if(despacho.getValue().length <= 100 && domicilio.getValue().length <= 100 && domicilioPlaza.getValue().length <= 100 && personaContacto.getValue().length <= 100) {
			if(codigoPostal.getValue().length <= 100 && telefono1.getValue().length <= 100 && telefono2.getValue().length <= 100) {
				return true;
			}
		}
		
		return false;
	}
	
	<%-- Producto-1274 Valida tamaño campos de DEE_DESPACHO_EXTERNO_EXTRAS --%>
	var validarFormAdicionales = function() {

		if(oficinaContacto.getValue().length <=  5 && entidadContacto.getValue().length <= 5) {
			if(entidadLiquidacion.getValue().length <=  4 && oficinaLiquidacion.getValue().length <=  4 && digconLiquidacion.getValue().length <=  2 && cuentaLiquidacion.getValue().length <=  10) {
				if(entidadProvisiones.getValue().length <=  4 && oficinaProvisiones.getValue().length <=  4 && digconProvisiones.getValue().length <=  2 && cuentaProvisiones.getValue().length <=  10) {
					if(entidadEntregas.getValue().length <=  4 && oficinaEntregas.getValue().length <=  4 && digconEntregas.getValue().length <=  2 && cuentaEntregas.getValue().length <=  10) {
						if(centroRecuperacion.getValue().length <= 60 && correoElectronico.getValue().length <= 100 && fax.getValue().length <= 100) {
							return true;
						}
					}
				}
			}
		}
		
		return false;
	}
	
	var resetCamposAdicionales = function() {
		perfil.setValue('');
		concursos.setValue('');
		codEstAse.setValue('');
		contratoVigor.setValue('');
		servicioIntegral.setValue('');
		fechaServicioIntegral.setValue('');
		relacionBankia.setValue('');
		oficinaContacto.setValue('');
		entidadContacto.setValue('');
		entidadLiquidacion.setValue('');
		oficinaLiquidacion.setValue('');
		digconLiquidacion.setValue('');
		cuentaLiquidacion.setValue('');
		entidadProvisiones.setValue('');
		oficinaProvisiones.setValue('');
		digconProvisiones.setValue('');
		cuentaProvisiones.setValue('');
		entidadEntregas.setValue('');
		oficinaEntregas.setValue('');
		digconEntregas.setValue('');
		cuentaEntregas.setValue('');
		centroRecuperacion.setValue('');
		tieneAsesoria.setValue('');
	}
	
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
		if(comboProvincias.getStore() != null && comboProvincias.getStore().data != null) {
			parametros.listaProvincias=comboProvincias.getValue();
		} else {
			parametros.listaProvincias=[];
		}
		parametros.clasificacionPerfil=perfil.getValue();
		parametros.clasificacionConcursos=concursos.getValue();
		parametros.codEstAse=codEstAse.getValue();
		parametros.contratoVigor=contratoVigor.getValue();
		parametros.servicioIntegral=servicioIntegral.getValue();
		parametros.fechaServicioIntegral=fechaServicioIntegral.getValue();
		parametros.relacionBankia=relacionBankia.getValue();
		parametros.oficinaContacto=oficinaContacto.getValue();
		parametros.entidadContacto=entidadContacto.getValue();
		parametros.entidadLiquidacion=entidadLiquidacion.getValue();
		parametros.oficinaLiquidacion=oficinaLiquidacion.getValue();
		parametros.digconLiquidacion=digconLiquidacion.getValue();
		parametros.cuentaLiquidacion=cuentaLiquidacion.getValue();
		parametros.entidadProvisiones=entidadProvisiones.getValue();
		parametros.oficinaProvisiones=oficinaProvisiones.getValue();
		parametros.digconProvisiones=digconProvisiones.getValue();
		parametros.cuentaProvisiones=cuentaProvisiones.getValue();
		parametros.entidadEntregas=entidadEntregas.getValue();
		parametros.oficinaEntregas=oficinaEntregas.getValue();
		parametros.digconEntregas=digconEntregas.getValue();
		parametros.cuentaEntregas=cuentaEntregas.getValue();
		parametros.centroRecuperacion=centroRecuperacion.getValue();
		parametros.asesoria=tieneAsesoria.getValue();
	 	
		return parametros;
	}
	
		
	var panelEdicion=new Ext.form.FormPanel({
		 id:'tabsinform-form'
		,border:false
		,height: 450
		,width : 1000
		,bodyStyle:'width:1000'
	  	,items: {
			 xtype: 'tabpanel'
			,id:'idTabPanel'
			,activeItem:0
			,border : false	
			,anchor:'100% 100%'
			//,deferredRender:false
			,height: 350
			//,autoWidth : true
			,items:[ pestanaPrincipal<c:if test="${usuarioEntidad == 'BANKIA'}">,pestanaAdicionales</c:if>]
		}
		,bbar : [btnGuardarEditar, btnCancelar]
	});	

	page.add(panelEdicion);
			
</fwk:page>