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
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.politicaAcuerdos.columna.nombre"
		label="**Nombre" value="${politica.nombre}" obligatory="true" />
		
	nombre.maxLength=100;	

	<pfs:textfield name="codigo" labelKey="plugin.recobroConfig.politicaAcuerdos.columna.codigo"
		label="**Código" value="${politica.codigo}" obligatory="true" />
		
	codigo.maxLength=20;	

	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return nombre.getActiveError();
		}
		if (codigo.getActiveError()!=''){
			return codigo.getActiveError();
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
    			parms.id='${politica.id}';
    			parms.nombre=nombre.getValue();
    			parms.codigo=codigo.getValue();
    			page.webflow({
						flow: 'recobropoliticadeacuerdos/savePoliticaAcuerdos'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.politicaAcuerdo.alta.error" text="**Error" />',validarForm());
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
				,items:[{items: [nombre]}
						,{items: [codigo]}
				]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		

	<%-- 	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_POLITICAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	--%>
	page.add(panelEdicion);		
	
</fwk:page>