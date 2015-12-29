<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>

debugger;
	var panelWidth=800;
	var labelStyle='width:100px';
	var idCliente = "${idCliente}";
	var idProcedimiento = "${idProcedimiento}";
	var idDireccion = "${idDireccion}";
	//var idContrato = "${idContrato}";	
	var valorProvincia = "${valorProvincia}";
	var valorCodigoPostal = "${valorCodigoPostal}";
	var valorLocalidad = "${valorLocalidad}";
	var valorLocalidadTexto = "${valorLocalidadTexto}";
	var valorMunicipio = "${valorMunicipio}";
	var valorTipoVia = "${valorTipoVia}";
	var valorDomicilio = "${valorDomicilio}";
	var valorNumero = "${valorNumero}";
	var valorPortal = "${valorPortal}";
	var valorPiso = "${valorPiso}";
	var valorEscalera = "${valorEscalera}";
	var valorPuerta = "${valorPuerta}";

	var flag=0;
  	<pfsforms:ddCombo name="provincia"
		labelKey="rec-web.direccion.form.provincia" 
 		label="**Provincia" value="${valorProvincia}" dd="${provincias}" 
		propertyCodigo="id" propertyDescripcion="descripcion" />
	
    debugger;
	provincia.on('select',function(){
		if( provincia.getValue() != null && provincia.getValue() != '' ){
			localidad.reset();
			localidad.setDisabled(false);
			comboLocalidadStore.webflow({'idProvincia':  provincia.getValue() }); 
			localidad.setValue('');
			municipio.setValue('');
			codigoPostal.setValue('');
			flag=1;
		} else{
			localidad.reset();
			localidad.setDisabled(true);
		}
	})
			
	<pfsforms:numberfield name="codigoPostal" 
		labelKey="rec-web.direccion.form.codigoPostal" 
		label="**Código Postal" 
		value="${valorCodigoPostal}" 
		allowDecimals="false" 
		allowNegative="false"/>
		
	var listadoLocalidades = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var comboLocalidadStore = page.getStore({
	       flow: 'direccion/getListLocalidades'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listaLocalidades'
	    }, listadoLocalidades)	       
	});	

	comboLocalidadStore.webflow({'idProvincia':  valorProvincia });
	var localidad = new Ext.form.ComboBox({
		store:comboLocalidadStore
		,name:'localidad'
		,displayField:'descripcion'
		,valueField:'id'
		,allowBlank : false
		,mode: 'local'
		,width: 350
		,resizable: true
		,forceSelection: true
		,disabled: false
		,editable: true
		//,emptyText:'<s:message code="rec-web.direccion.form.seleccionar" text="**Seleccionar" />'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="rec-web.direccion.form.localidad" text="**Localidad" />'
	});
	localidad.setValue(valorLocalidadTexto);
		
	localidad.on('select',function(){
		municipio.setValue('');
		flag=1;
		if( localidad.getValue() != null && localidad.getValue() != '' && municipio.getValue() == ''){
			municipio.setValue(localidad.getRawValue().toUpperCase());
		}
	})

	<pfsforms:textfield name="municipio"
			labelKey="rec-web.direccion.form.municipio" label="**Municipio"
			value="${valorMunicipio}" obligatory="true" width="350" />

	<pfsforms:ddCombo name="tipoVia"
		labelKey="rec-web.direccion.form.tipoVia" 
 		label="**Tipo Vía" value="${valorTipoVia}" dd="${tiposVia}" 
		propertyCodigo="id" propertyDescripcion="descripcion" />

	<pfsforms:textfield name="domicilio"
			labelKey="rec-web.direccion.form.domicilio" label="**Domicilio"
			value="${valorDomicilio}" obligatory="true" width="350" />
	
	<pfsforms:textfield name="numero"
			labelKey="rec-web.direccion.form.numero" label="**Número"
			value="${valorNumero}" obligatory="false" width="50" />
	
	<pfsforms:textfield name="portal"
			labelKey="rec-web.direccion.form.portal" label="**Portal"
			value="${valorPortal}" obligatory="false" width="50" />
	
	<pfsforms:textfield name="piso"
			labelKey="rec-web.direccion.form.piso" label="**Piso"
			value="${valorPiso}" obligatory="false" width="50" />
	
	<pfsforms:textfield name="escalera"
			labelKey="rec-web.direccion.form.escalera" label="**Escalera"
			value="${valorEscalera}" obligatory="false" width="50" />
	
	<pfsforms:textfield name="puerta"
			labelKey="rec-web.direccion.form.puerta" label="**Puerta"
			value="${valorPuerta}" obligatory="false" width="50" />
				
	var origen = app.creaText("origen","<s:message code="rec-web.direccion.form.origen" text="**Origen" />","Manual",{
		width : 100
		,readOnly: true
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		
	});
	
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
	});
	btnGuardar.on('click', function(){
		if(flag==0){
			localidad.setValue(valorLocalidad);
		}
		if (provincia.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.provinciaObligatoria" text="**La provincia es obligatoria." />');
			provincia.focus();
		} else if (localidad.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.localidadObligatoria" text="**La localidad es obligatoria." />');
			localidad.focus();
		} else if (tipoVia.getValue() == '') {
			Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.tipoViaObligatoria" text="**El tipo de vía es obligatorio." />');
			tipoVia.focus();
		} else {
			panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
			Ext.Ajax.request({
						url : page.resolveUrl('burofax/updateDireccion'), 
						params : {idProcedimiento:idProcedimiento,idCliente:idCliente, idDireccion:idDireccion,provincia:provincia.getValue(),codigoPostal:codigoPostal.getValue(),localidad:localidad.getValue(),municipio:municipio.getValue(),tipoVia:tipoVia.getValue(),
								domicilio:domicilio.getValue(),numero:numero.getValue(),portal:portal.getValue(),piso:piso.getValue(),escalera:escalera.getValue(),puerta:puerta.getValue(),
								origen:origen.getValue()},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						},
					    failure: function(form, action) {
					    	panelEdicion.container.unmask();
					        switch (action.failureType) {
					            case Ext.form.Action.CLIENT_INVALID:
					                Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.camposObligatorios" text="**Debe rellenar los campos obligatorios." />');
					                break;
					            case Ext.form.Action.CONNECT_FAILURE:
					                Ext.Msg.alert('Error', '<s:message code="rec-web.direccion.validacion.errorComunicacion" text="**Error de comunicación" />');
					                break;
					       }
						}
		
		});
	}});
	
	
	var bottomBar = [];
	bottomBar.push(btnGuardar);
	bottomBar.push(btnCancelar);
  

  
  	var panelEdicion = new Ext.form.FormPanel({
		defaults : {cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,border : false
		,height : 250
        ,layout : 'table'
        ,title : '<s:message code="plugin.precontencioso.grid.burofax.editar.direccion" text="**Editar Dirección" />'
		,bbar:bottomBar
		,items : [
			{   layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype : 'fieldset', border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:1px'}
				,items:[{items: [ provincia,codigoPostal,localidad,municipio,tipoVia,domicilio]}
						,{items: [ numero,portal,piso,escalera,puerta,origen]}
				]
			},
			{ xtype : 'errorList', id:'errL' }			
		]
	});	

	page.add(panelEdicion);
	
</fwk:page>