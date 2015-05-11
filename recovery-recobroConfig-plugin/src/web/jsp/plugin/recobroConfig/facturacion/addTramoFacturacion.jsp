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
	
	<pfs:numberfield name="periodo" labelKey="plugin.recobroConfig.modeloFacturacion.periodo"
		label="**Tramo de días" value="${tramo.tramoDias}" obligatory="true"  
		allowNegative="false" allowDecimals="false"/>


	periodo.setMaxValue(365);
		
	var validarForm= function(){
		if (periodo.getActiveError() != "") {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',periodo.getActiveError());
			return false;
		}
		return true;
	};	
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()){
    			var parms = {};
    			parms.id='${tramo.id}';
    			parms.idModFact='${idModFact}'
    			parms.tramoDias=periodo.getValue();
    			
 				page.webflow({
						flow: 'recobromodelofacturacion/guardarTramoFacturacion'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});

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
				,layoutConfig:{columns:1}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [periodo]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	<%--
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_METAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	--%>
	page.add(panelEdicion);

</fwk:page>