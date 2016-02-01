<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:numberfield name="rankingPosicion" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.cabeceraPosicionRanking" 
		label="**Tramo de mejora" value="${correctoFacturacion.rankingPosicion}" obligatory="true"/>
	
	<pfs:numberfield name="objetivoInicio" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.inicio" 
		label="**Tramo inicio" value="${correctoFacturacion.objetivoInicio}" obligatory="true" allowDecimals="true"/>
	
	<pfs:numberfield name="objetivoFin" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.fin"
		label="**Tramo fin" value="${correctoFacturacion.objetivoFin}" obligatory="true" allowDecimals="true"/>
		
	<pfs:numberfield name="coeficiente" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.coeficiente" 
		label="**Coeficiente" value="${correctoFacturacion.coeficiente}" obligatory="true" allowNegative="true" allowDecimals="true"/>
	
	objetivoInicio.setMaxValue(100);
	objetivoFin.setMaxValue(100);
	coeficiente.setMaxValue(100);
	coeficiente.setMinValue(-100);
	
	
	<c:if test="${modeloFacturacion.tipoCorrector.codigo == 'RAN'}">
		objetivoInicio.hide();
		objetivoFin.hide();
	</c:if>
	
	<c:if test="${modeloFacturacion.tipoCorrector.codigo == 'MEO'}">
		rankingPosicion.hide();
	</c:if>
	
	var validaForm = function(){
		if (objetivoFin.isVisible() && objetivoInicio.isVisible()) {
			if ((objetivoFin.getValue() == "" && objetivoFin.getValue() != "0")|| (objetivoInicio.getValue() == "" && objetivoInicio.getValue() != "0") || coeficiente.getValue() == "") {
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,'<s:message code="plugin.recoveryConfig.altaAgencia.camposObligatorios" text="**Debe rellenar todos los campos obligatorios" />');
				return false;
			}
			if (objetivoInicio.getActiveError() != "") {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.inicio" text="**Tramo inicio"/>: '+objetivoInicio.getActiveError());
				return false;
			}
			if (objetivoFin.getActiveError() != "") {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.fin" text="**Tramo fin"/>: '+objetivoFin.getActiveError());
				return false;
			}
			
			if (objetivoInicio.getValue()>objetivoFin.getValue()) {
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,'<s:message code="plugin.recoveryConfig.modelofacturacion.editarTramoCorrector.InicioMayorFin" text="**El valor del inicio del tramo de mejora no puede ser mayor que el fin" />');
				return false;
			}
		} 
		
		if (coeficiente.getActiveError() != "") {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.coeficiente" text="**Coeficiente"/>: '+coeficiente.getActiveError());
			return false;
		}
		
		if(rankingPosicion.isVisible()) {
			if (rankingPosicion.getActiveError() != "") {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.cabeceraPosicionRanking" text="**Tramo de mejora"/>: '+rankingPosicion.getActiveError());
				return false;
			}
		}
		
 		var parms = {};
 		parms.idModFact='${idModFact}';
 		parms.idTramoCorrector='${idTramoCorrector}';
 		parms.rankingPosicion=rankingPosicion.getValue();
 		parms.objetivoInicio=objetivoInicio.getValue();
 		parms.objetivoFin=objetivoFin.getValue();
 		parms.coeficiente=coeficiente.getValue();
 		page.webflow({
			flow: 'recobromodelofacturacion/guardarTramoCorrector'
			,params: parms
			,success : function(){ 
				page.fireEvent(app.event.DONE); 
			}
		});
				
	};
			
	var btnGuardar = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			validaForm();
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
				,items:[{items: [rankingPosicion, objetivoInicio, objetivoFin]}
						,{items: [coeficiente]}]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});			
	
	page.add(panelEdicion);			
	
</fwk:page>	