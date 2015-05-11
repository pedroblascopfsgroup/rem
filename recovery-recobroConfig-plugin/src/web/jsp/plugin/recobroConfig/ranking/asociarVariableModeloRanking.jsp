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
	
	
	<pfsforms:ddCombo name="tipoVariable"
		labelKey="plugin.recobroConfig.modeloRanking.altaVariable.tipoVariable" label="**Tipo de Variable"
		value="" dd="${tiposVariables}" width="200" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" obligatory="true" />
	
	 	
	tipoVariable.setValue('${variable.variableRanking.codigo}');	
	
    	
	<pfsforms:numberfield name="coeficiente" 
		labelKey="plugin.recobroConfig.variableRanking.coeficiente" 
		label="**Coeficiente"  
		value="${variable.coeficiente}" allowDecimals="true" />
		
	coeficiente.maxValue=100;	
	
	var validarForm= function(){
		if (tipoVariable.getValue()==''){
			return 'Este campo es obligatorio';
		}
		if (coeficiente.getActiveError()!=''){
			return coeficiente.getActiveError();
		}
		return '';
	};	

	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.idVariable='${variable.id}';
    			parms.idModelo='${idModelo}';
    			parms.tipoVariable=tipoVariable.getValue();
    			parms.coeficiente=coeficiente.getValue();
    			
    			page.webflow({
						flow: 'recobromodeloderanking/saveVariableModelo'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
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
				,items:[{items: [tipoVariable]}
						,{items: [coeficiente]}]
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