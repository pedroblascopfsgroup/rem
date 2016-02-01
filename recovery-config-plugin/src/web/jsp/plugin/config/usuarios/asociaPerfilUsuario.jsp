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
	<pfsforms:textfield name="username" labelKey="plugin.config.usuarios.field.username" label="**Username"   value="${usuario.username}" readOnly="true"/>
	
	<pfs:ddCombo name="perfil"
		labelKey="plugin.config.usuarios.asociarperfil.control.perfil" label="**Perfil"
		value="" dd="${perfiles}"  />
		
	<pfs:ddCombo name="jerarquia" 
		labelKey="plugin.config.usuarios.asociarperfil.control.jerarquia" label="**Jerarquia"
		value="" dd="${niveles}" />
		
	var zonasRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsZonasStore = page.getStore({
		flow:'plugin/config/usuarios/ADMbuscarZonas'
		,reader: new Ext.data.JsonReader({
			root : 'zonas'
		},zonasRecord)
	});
	
	<pfs:dblselect name="centros"
			labelKey="plugin.config.usuarios.asociarperfil.control.centros" label="**Centro"
			dd="${zonas}" store="optionsZonasStore" height="100"/>
			
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboZonas = function(){
		if (jerarquia.getValue()!=null && jerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:jerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	};
	
	
	var permiteGuardar = new Ext.form.TextField({
                hidden: true
                ,value: true
        });	
    
    var tipoTab = new Ext.form.TextField({
                hidden: true
                ,value: 'asociaPerfilUsuario'
        });
	
	perfil.on('select',function(){
    	if(perfil.getValue() == "")
    		permiteGuardar.setValue(false);
    	else
    		permiteGuardar.setValue(true);
    });
	
	
    recargarComboZonas();
    
    var password = app.creaText('password',
                             '<s:message code="plugin.config.confirmacion.password" text="**Introduzca su password para confirmar el cambio" />', 
                             '',
                             {allowBlank : false, inputType:'password'});

    var limpiarYRecargar = function(){
		//app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	jerarquia.on('select',limpiarYRecargar);

	<%--<pfs:defineParameters name="parametros" paramId="${usuario.id}" 
		username="username" perfil="perfil"
		centros="centros"
		/>--%>
		
	<pfs:hidden name="idUsuario" value="${usuario.id}"/>
	<pfs:defineParameters name="parametros" paramId="" 
		idsZona="centros" idUsuario="idUsuario"  idPerfil="perfil"
		password="password"
		permiteGuardar="permiteGuardar"	
		tipoTab="tipoTab" />

	<pfs:editForm saveOrUpdateFlow="plugin/config/usuarios/ADMguardarPerfilUsuario"
		leftColumFields="username,perfil,jerarquia,centros,password"
		parameters="parametros" 
		onSuccessMode="tabGenericoConMsgGuardando" />
		
	<%-- Para deshabilitar los botones mientras se realiza el proceso de Guardado. --%>
	btnGuardar.on('click',function(){
        this.setDisabled(true);
        btnCancelar.setDisabled(true);
	});

</fwk:page>