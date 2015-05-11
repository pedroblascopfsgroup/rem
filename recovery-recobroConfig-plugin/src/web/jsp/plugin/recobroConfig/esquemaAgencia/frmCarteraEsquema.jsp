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
	
	<pfsforms:ddCombo name="cmbTipoCartera"
		labelKey="plugin.recobroConfig.carteraEsquema.tipoCartera" label="**Tipo Cartera"
		value="" dd="${ddTiposCartera}" 
		width="200"  propertyCodigo="codigo" propertyDescripcion="descripcion"/>
		
	cmbTipoCartera.setValue('${carteraEsquema.tipoCarteraEsquema.codigo}');	
		
	<pfsforms:ddCombo name="cmbTipoGestion"
		labelKey="plugin.recobroConfig.carteraEsquema.tipoGestion" label="**Tipo Gestion"
		value="${carteraEsquema.tipoGestionCarteraEsquema.id}" dd="${ddTiposGestion}" 
		width="200" propertyCodigo="id" propertyDescripcion="descripcion"/>
		
	<pfsforms:ddCombo name="cmbAmbitoExpediente"
		labelKey="plugin.recobroConfig.carteraEsquema.ambitoExpediente" label="**Ambito Expediente"
		value="${carteraEsquema.ambitoExpedienteRecobro.id}" dd="${ddAmbitoExpediente}" 
		width="200" propertyCodigo="id" propertyDescripcion="descripcion"/>
	
	<c:if test="${carteraEsquema.tipoCarteraEsquema.codigo=='FIL'}">
		cmbAmbitoExpediente.hide();
		cmbTipoGestion.hide();
	</c:if>
		
	cmbTipoCartera.on('select', function(){
		if (cmbTipoCartera.getValue() == 'FIL' ){
			cmbAmbitoExpediente.hide();
			cmbTipoGestion.hide();
		} else {
			cmbAmbitoExpediente.show();
			cmbTipoGestion.show();
		}
	});	

	var datosPrioridad = new Array();
   	for (i=1;i<=${maxPrioridad};i++) {
   		datosPrioridad.push(new Array(i,'Prioridad '+i));
   	}
  
	var cmbPrioridad = new Ext.form.ComboBox({
			name:'cmbPrioridad'
			,hiddenName:'comboPrioridad'
			,store:datosPrioridad
			,displayField:'descripcion'
			,valueField:'id'
			,mode: 'local'
			,style:'margin:0px'
			,triggerAction: 'all'
			//,labelStyle:labelStyle
			,disabled:false
			,allowBlank:false
			,fieldLabel : '<s:message code="plugin.recobroConfig.carteraEsquema.prioridad" text="**Prioridad" />'
	});
	cmbPrioridad.setValue(${selPrioridad});			
	
	var validarForm= function(){
		if (cmbTipoCartera.getValue()==''){
			return false;
		}
		if (cmbTipoCartera.getValue()=='GES'){
			if ( cmbTipoGestion.getValue()=='' || cmbAmbitoExpediente.getValue()=='' || cmbPrioridad.getValue==''){
			return false;
			}
		} else {
			if (cmbPrioridad.getValue==''){
				return false;
			}
		}
		
		return true;
	};	
	
	cmbTipoCartera.on('select', function(){
		if (cmbTipoCartera.getValue()=='GES'){
			cmbTipoGestion.allowBlank=false;
			cmbAmbitoExpediente.allowBlank=false;
		}
		if (cmbTipoCartera.getValue()=='FIL'){
			cmbTipoGestion.allowBlank=true;
			cmbAmbitoExpediente.allowBlank=true;
		}
	});
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()){
    			var parms = {};
    			if ('${carteraEsquema.id}'!=null && (cmbTipoCartera.getValue() == 'FIL' || cmbTipoGestion.getValue()=='${sinGestion.id}')
    				&& (cmbTipoCartera.getValue() != '${carteraEsquema.tipoCarteraEsquema.codigo}' || cmbTipoGestion.getValue()!='${carteraEsquema.tipoGestionCarteraEsquema.id}')){
    				Ext.Msg.confirm('<s:message code="pfs.tags.editform.guardar" text="**Guardar" />', 
    					'<s:message code="plugin.recobroConfig.editarCartera.buttonGuardar.confirmar" 
    						text="**Al hacer estas modificaciones se eliminarán las subcarteras asociadas a anteriormente a esta cartera, ¿desea continuar?" />', 
    					function(btn){
		    				if (btn == 'yes'){
		    					parms.id='${carteraEsquema.id}';
			    				parms.idCartera='${idCartera}';
			    				parms.idEsquema='${idEsquema}';
			    				parms.codigoTipoCarteraEsquema=cmbTipoCartera.getValue();
			    				parms.idTipoGestionCarteraEsquema=cmbTipoGestion.getValue();
			    				parms.idAmbitoExpedienteRecobro=cmbAmbitoExpediente.getValue();
			    				parms.prioridad=cmbPrioridad.getValue();
			    				page.webflow({
									flow: 'recobroesquema/saveCarteraEsquema'
									,params: parms
									,success : function(){ 
										page.fireEvent(app.event.DONE); 
									}
								});
							}	
		
    				});
    			} else {
	    			parms.id='${carteraEsquema.id}';
	    			parms.idCartera='${idCartera}';
	    			parms.idEsquema='${idEsquema}';
	    			parms.codigoTipoCarteraEsquema=cmbTipoCartera.getValue();
	    			parms.idTipoGestionCarteraEsquema=cmbTipoGestion.getValue();
	    			parms.idAmbitoExpedienteRecobro=cmbAmbitoExpediente.getValue();
	    			parms.prioridad=cmbPrioridad.getValue();
	 
	    			page.webflow({
							flow: 'recobroesquema/saveCarteraEsquema'
							,params: parms
							,success : function(){ 
								page.fireEvent(app.event.DONE); 
							}
						});
				}	
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,'<s:message code="plugin.recoveryConfig.altaAgencia.camposObligatorios" text="**Debe rellenar todos los campos obligatorios" />');
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
				,items:[{items: [cmbTipoCartera,cmbPrioridad]}
						,{items: [cmbTipoGestion,cmbAmbitoExpediente]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	 
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_CARTERASESQUEMA">
		btnGuardarValidacion.show();
	</sec:authorize>	
	
	page.add(panelEdicion);

</fwk:page>