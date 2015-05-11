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

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.cartera.nombre"
		label="**Nombre" value="${cartera.nombre}" obligatory="true" />
		
	nombre.maxLength=50;	

	<pfs:textfield name="descripcion" labelKey="plugin.recobroConfig.cartera.descripcion"
		label="**Descripción" value="${cartera.descripcion}" obligatory="true" />
		
	descripcion.maxLength=250;	
	
	<pfsforms:ddCombo name="idRegla"
		labelKey="plugin.recobroConfig.cartera.paqueteReglas" label="**Paquete de reglas"
		value="" dd="${ddRegla}" width="200" propertyCodigo="id" propertyDescripcion="name" obligatory="true"/>
		
	idRegla.setValue(${cartera.regla.id});
		
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return nombre.getActiveError();
		}
		if (descripcion.getActiveError()!=''){
			return descripcion.getActiveError();
		}
		if (idRegla.getValue()==''){
			return "Este campo es obligatorio";
		}
		return '';
	};	
	
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
	    			var parms = {};
	    			parms.id='${cartera.id}';
	    			parms.nombre=nombre.getValue();
	    			parms.descripcion=descripcion.getValue();
	    			parms.idRegla=idRegla.getValue();
	 
	    			page.webflow({
							flow: 'recobrocartera/saveCartera'
							,params: parms
							,success : function(){ 
								page.fireEvent(app.event.DONE); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>'
				,validarForm());
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
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [nombre,descripcion]}
						,{items: [idRegla]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		

	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_CARTERAS">
		btnGuardarValidacion.show();
		if ('${cartera}'!=''){	
			if ('${cartera.estado.codigo}'==ESTADO_BLOQUEADO.getValue() || '${cartera.propietario.id}' != usuarioLogado.getValue()){
				btnGuardarValidacion.hide();
			} 
		}
	</sec:authorize>	
	
	page.add(panelEdicion);

</fwk:page>