<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.agencia.alta.nombre"
		label="**Nombre" value="${agencia.nombre}" obligatory="true" />
		
	nombre.maxLength=50;	

	<pfs:textfield name="codigo" labelKey="plugin.recobroConfig.agencia.alta.codigo"
		label="**Código" value="${agencia.codigo}" obligatory="true" />

	codigo.maxLength=10;
	
	<pfs:textfield name="nif"
		labelKey="plugin.recobroConfig.agencia.alta.nif" label="**NIF"
		value="${agencia.nif}" obligatory="true" />

	nif.maxLength=20;
	
	<pfs:textfield name="contactoNombre"
		labelKey="plugin.recobroConfig.agencia.alta.contactoNombre" label="**Nombre contacto"
		value="${agencia.contactoNombre}" />
		
	contactoNombre.maxLength=50;	
		
	<pfs:textfield name="contactoApe1"
		labelKey="plugin.recobroConfig.agencia.alta.contactoApe1" label="**Apellido 1 contacto"
		value="${agencia.contactoApe1}" />
		
	contactoApe1.maxLength=50;	

	<pfs:textfield name="contactoApe2" labelKey="plugin.recobroConfig.agencia.alta.contactoApe2"
		label="**Apellido 2 contacto" value="${agencia.contactoApe2}" />
	
	contactoApe2.maxLength=50;		
		
	<pfs:textfield name="contactoMail" labelKey="plugin.recobroConfig.agencia.alta.contactoMail"
		label="**Mail" value="${agencia.contactoMail}" />
		
	contactoMail.maxLength=50;	

	<pfs:textfield name="contactoTelf" labelKey="plugin.recobroConfig.agencia.alta.contactoTelf"
		label="**Teléfono" value="${agencia.contactoTelf}" />
		
	contactoTelf.maxLength=20;		
	
	<pfs:textfield name="denominacionFiscal" labelKey="plugin.recobroConfig.agencia.alta.denominacionFiscal"
		label="**Denominación fiscal" value="${agencia.denominacionFiscal}" />
		
	denominacionFiscal.maxLength=250;	
	
	<pfsforms:ddCombo name="tipoVia"
		labelKey="plugin.recobroConfig.agencia.alta.tipoVia" label="**Tipo de Via"
		value="" dd="${ddTipoVia}" width="75" propertyCodigo="codigo"/>
		
	
	<pfs:textfield name="nombreVia" labelKey="plugin.recobroConfig.agencia.alta.nombreVia"
		label="**Nombre via" value="${agencia.nombreVia}" />
		
	nombreVia.maxLength=250;	
		
	<pfs:textfield name="numero" labelKey="plugin.recobroConfig.agencia.alta.numero"
		label="**Número via" value="${agencia.numero}" />	
		
	numero.maxLength=10;								
		
	<pfsforms:ddCombo name="provincia"
		labelKey="plugin.recobroConfig.agencia.alta.codigo.provincia" label="**Provincia"
		value="" dd="${ddProvincias}"  propertyCodigo="codigo" />
	
	<pfsforms:ddCombo name="despacho"
		labelKey="plugin.recobroConfig.agencia.alta.despachoAgencia" label="**Grupo"
		value="" dd="${despachosExterno}"  propertyCodigo="id" obligatory="true"/>
	
	despacho.setValue('${agencia.despacho.id}');	
	provincia.setValue('${agencia.provincia.codigo}');
	tipoVia.setValue('${agencia.tipoVia.codigo}');
	 
	var poblacionRT = Ext.data.Record.create([
		 {name:'codigo', mapping: 'codigo'}
		,{name:'descripcion', mapping: 'descripcion'}
	]);
	
	var poblacionStore = page.getStore({
	       flow: 'recobroagencia/getLocalidadesByProvincia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'localidades'
	    }, poblacionRT)	       
	});	

	var usuarioRT = Ext.data.Record.create([
		 {name:'id', mapping: 'id'}
		,{name:'nombre', mapping: 'nombre'}
	]);
	
	var usuarioStore = page.getStore({
	       flow: 'recobroagencia/getGestoresListadoDespachos'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'usuarios'
	    }, usuarioRT)	       
	});	
		
	var poblacion = new Ext.form.ComboBox({
		store:poblacionStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,name:'poblacion'
		,mode: 'local'
		,editable:true
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.recobroConfig.agencia.alta.codigo.poblacion" text="**Población" />'
		,typeAhead: false
	});
	
	var usuario = new Ext.form.ComboBox({
		store:usuarioStore
		,displayField:'nombre'
		,allowBlank: false
		,valueField:'id'
		,name:'usuario'
		,mode: 'local'
		,editable:true
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.recobroConfig.agencia.alta.usuario" text="**Usuario" />'
		,typeAhead: false
	});
	
	var municipioRT = Ext.data.Record.create([
		 {name:'codigo', mapping: 'codigo'}
		,{name:'descripcion', mapping: 'descripcion'}
	]);
	
	var municipioStore = page.getStore({
	       flow: 'recobroagencia/getLocalidadesByProvincia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'localidades'
	    }, municipioRT)	       
	});	
	
	var municipio = new Ext.form.ComboBox({
		store:municipioStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,name:'municipio'
		,mode: 'local'
		,editable:true
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.recobroConfig.agencia.alta.codigo.municipio" text="**Municipio" />'
		,typeAhead: false
	});
	
	recargarPoblaciones = function(){
		if (provincia.getValue()!=null && provincia.getValue()!=''){
			poblacionStore.webflow({idProvincia:provincia.getValue()});
			municipioStore.webflow({idProvincia:provincia.getValue()});
			poblacion.clearValue();
			municipio.clearValue();
		}
	};
		
	recargarUsuarios = function(){
		if (despacho.getValue()!=null && despacho.getValue()!=''){
			usuarioStore.webflow({listadoDespachos:despacho.getValue()});
			usuario.clearValue();
		}
	};
	
    Ext.onReady(function() {
    	if (provincia.getValue()!=null && provincia.getValue()!=''){
			municipioStore.webflow({idProvincia:provincia.getValue()});
			municipioStore.on('load', function(){  
				municipio.setValue('${agencia.municipio.codigo}');
				municipioStore.events['load'].clearListeners();
			});
			poblacionStore.webflow({idProvincia:provincia.getValue()});
			poblacionStore.on('load', function(){  
				poblacion.setValue('${agencia.poblacion.codigo}');
				poblacionStore.events['load'].clearListeners();
			});
		}
		if (despacho.getValue()!=null && despacho.getValue()!=''){
			usuarioStore.webflow({listadoDespachos:despacho.getValue()});
			usuarioStore.on('load', function(){  
				usuario.setValue('${agencia.gestor.id}');
				usuarioStore.events['load'].clearListeners();
			});
		}
    });
    
    var limpiarYRecargar = function(){
		recargarPoblaciones();
	}

    var limpiarYRecargarDespacho = function(){
		recargarUsuarios();
	}
		
	provincia.on('select',limpiarYRecargar);
	
	despacho.on('select',limpiarYRecargarDespacho);
	
	<pfsforms:ddCombo name="pais"
		labelKey="plugin.recobroConfig.agencia.alta.codigo.pais" label="**País"
		value="" dd="${ddPais}" propertyCodigo="codigo"/>
	
	pais.setValue('${agencia.pais.codigo}');
			
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.error.nombre" text="**Error" />'
		}
		if (nif.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.error.nif" text="**Error" />'
		}
		if (codigo.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.error.codigo" text="**Error" />'
		}
		if (contactoNombre.getActiveError()!=''){
			return contactoNombre.getActiveError();
		}
		if (contactoApe1.getActiveError()!=''){
			return contactoApe1.getActiveError();
		}
		if (contactoApe2.getActiveError()!=''){
			return contactoApe2.getActiveError();
		}
		if (contactoMail.getActiveError()!=''){
			return contactoMail.getActiveError();
		}
		if (contactoTelf.getActiveError()!=''){
			return contactoTelf.getActiveError();
		}
		if (denominacionFiscal.getActiveError()!=''){
			return denominacionFiscal.getActiveError();
		}
		if (nombreVia.getActiveError()!=''){
			return nombreVia.getActiveError();
		}
		if (numero.getActiveError()!=''){
			return numero.getActiveError();
		}
		if (despacho.getValue()==''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.error.grupo" text="**Error" />'
		}
		if (usuario.getValue()==''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.error.usuario" text="**Error" />'
		}
		return '';
	}	
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.id='${agencia.id}';
    			parms.nombre=nombre.getValue();
    			parms.codigo=codigo.getValue();
    			parms.nif=nif.getValue();
    			parms.contactoNombre=contactoNombre.getValue();
    			parms.contactoApe1=contactoApe1.getValue();
    			parms.contactoApe2=contactoApe2.getValue();
    			parms.contactoMail=contactoMail.getValue();
    			parms.contactoTelf=contactoTelf.getValue();
    			parms.codigoTipoVia=tipoVia.getValue();
    			parms.nombreVia=nombreVia.getValue();
    			parms.numero=numero.getValue();
    			parms.codigoProvincia=provincia.getValue();
    			parms.codigoPoblacion=poblacion.getValue();
    			parms.codigoMunicipio=municipio.getValue();
				parms.codigoPais=pais.getValue();
				parms.denominacionFiscal=denominacionFiscal.getValue();
				parms.despacho=despacho.getValue();
				parms.usuario=usuario.getValue();
    			page.webflow({
						flow: 'recobroagencia/saveAgencia'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />',validarForm());
			}
		}
	});		
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});
	
	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	
	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:675
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		    ,items : items
		});
	}
	
	var datosBasicosFieldSet = fieldSet( '<s:message code="plugin.recobroConfig.agenciasRecobro.DatosBasicos" text="**Datos Basicos"/>'
                ,[{items:[nombre,codigo,nif]} ,{items : [despacho,usuario]} ]);
	
	var datosContactoFieldSet = fieldSet( '<s:message code="plugin.recobroConfig.agenciasRecobro.DatosContacto" text="**Datos de contacto"/>'
                ,[{items:[contactoNombre,contactoApe1,contactoApe2]} ,{items : [contactoMail,contactoTelf]} ]);
                
    var datosFacturacionFieldSet = fieldSet( '<s:message code="plugin.recobroConfig.agenciasRecobro.DatosFacturacion" text="**Datos de facturacion"/>'
                ,[{items:[denominacionFiscal,tipoVia,nombreVia,numero]} ,{items : [pais,provincia,municipio,poblacion]} ]);
                	
	panelEdicion.add(datosBasicosFieldSet,datosContactoFieldSet,datosFacturacionFieldSet);
	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_AGENCIAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	
	page.add(panelEdicion);		
	
</fwk:page>