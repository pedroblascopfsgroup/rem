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
	
	<pfs:hidden name="CORRECTOR_TIPO_OBJETIVO" value="${CORRECTOR_TIPO_OBJETIVO}"/>
	<pfs:hidden name="CORRECTOR_TIPO_RANKING" value="${CORRECTOR_TIPO_RANKING}"/>
	
	<pfsforms:ddCombo name="tipoDeCorrector"
		labelKey="plugin.recobroConfig.modeloFacturacion.corrector.tipoCorrector" label="**Tipo de corrector"
		value="" dd="${tiposDeCorrectores}" propertyCodigo="codigo" propertyDescripcion="descripcion" obligatory="true"/>
		
	tipoDeCorrector.setValue('${modeloFacturacion.tipoCorrector.codigo}');	
		
	<pfs:numberfield name="objetivoRecobro" labelKey="plugin.recobroConfig.modeloFacturacion.corrector.objetivoDeRecobro" 
		label="**Objetivo de eficacia" value="${modeloFacturacion.objetivoRecobro}" obligatory="true" allowDecimals="true"/>
	
	objetivoRecobro.setMaxValue(100);
	
	mostrarOcultarObjetivo = function() {
		if (tipoDeCorrector.getValue() != CORRECTOR_TIPO_OBJETIVO.getValue()) {
			objetivoRecobro.hide();
		} else {
			objetivoRecobro.setValue('');
			objetivoRecobro.show();
		}
	}
	
	if (tipoDeCorrector.getValue() != CORRECTOR_TIPO_OBJETIVO.getValue()) {
		objetivoRecobro.hide();
		objetivoRecobro.setValue('');
	}			
	
	var tipoDeCorrectorValorOriginal = tipoDeCorrector.getValue();
	
	tipoDeCorrector.on('select', function() {
	     mostrarOcultarObjetivo();
	}); 
		
	var btnGuardar = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
    			if (tipoDeCorrectorValorOriginal != '' && tipoDeCorrector.getValue() != tipoDeCorrectorValorOriginal) {
    				Ext.MessageBox.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.editarTipo" text="**Editar el tipo de corrector"/>'
						, '<s:message code="plugin.recobroConfig.modeloFacturacion.corrector.confirmarCambioTipoCorrector" text="**Confirmar cambio"/>'
						, function(btn){
							if (btn == 'yes'){
								guardarTipo();
							}
						}
					);
    			} else {
    				guardarTipo();
    			}
    		}	
	});		
	
	var guardarTipo = function(){
		if (objetivoRecobro.isVisible() && (objetivoRecobro.getActiveError() != "")) {
  			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',objetivoRecobro.getActiveError());
  		} else {
			var parms = {};
	 		parms.id='${idModFact}';
	 		parms.tipoDeCorrector=tipoDeCorrector.getValue();
	 		parms.objetivoRecobro=objetivoRecobro.getValue();
	 		page.webflow({
				flow: 'recobromodelofacturacion/guardarTipoDeCorrector'
				,params: parms
				,success : function(){ 
					page.fireEvent(app.event.DONE); 
				}
			});
		}
	};
	
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
				,items:[{items: [tipoDeCorrector]}
						,{items: [objetivoRecobro]}]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});			
	
	page.add(panelEdicion);			
	
</fwk:page>	