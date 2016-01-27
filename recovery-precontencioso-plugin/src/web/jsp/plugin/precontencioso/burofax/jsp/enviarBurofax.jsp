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

	var arrayIdEnvios='${arrayIdEnvios}';
	var arrayIdContrato='${arrayIdContrato}';
	
	var certificado = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.precontencioso.grid.burofax.requiereCertificado" text="**Requiere Certificado" />'
		,name:'aceptada'
        ,checked:false
        ,readOnly:true
	});
	
	
   
	var arrayIdBurofax='${arrayIdBurofax}';
    var arrayIdDirecciones='${arrayIdDirecciones}';
    var comboEditable='${comboEditable}';
    
   
   
   <c:if test="${comboEditable}">
   
	<pfsforms:ddCombo name="tipoBurofax"  
		labelKey="plugin.precontencioso.grid.burofax.tipoBurofax" 
 		label="**Tipo Burofax" value="${idTipoBurofax}" dd="${listaTipoBurofax}" 
		propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true"/>   	
		
  </c:if>
  
  <c:if test="${!comboEditable}">
  	<pfsforms:textfield name="tipoBurofaxNoEditable"
			labelKey="plugin.precontencioso.grid.burofax.tipoBurofax" label="**Tipo Burofax"
			value="${descripcionTipoBurofax}" readOnly="true" width="150"/>	
			
			
   var tipoBurofax = new Ext.form.TextField({
		name : 'tipoBurofax'
		,value : "${idTipoBurofax}"
		,fieldLabel : 'email'
		,visible:false
	});
  </c:if>
  

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var mask=new Ext.LoadMask(panelEdicion.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
			if (tipoBurofax.getValue() == '' || tipoBurofax.getActiveError() != '') {
				Ext.Msg.alert(fwk.constant.alert, '<s:message code="plugin.precontencioso.enviar.burofax.errorTipoBur" text="** Tipo burofax obligatorio" />');
				return;
			}else{
				mask.show();
				Ext.Ajax.request({
					url : page.resolveUrl('burofax/guardarEnvioBurofax'), 
					params : {arrayIdEnvios:arrayIdEnvios,arrayIdContrato:arrayIdContrato,certificado:certificado.getValue(),idTipoBurofax:tipoBurofax.getValue(),arrayIdDirecciones:arrayIdDirecciones,arrayIdBurofax:arrayIdBurofax,comboEditable:comboEditable},
					method: 'POST',
					success: function ( result, request ) {
						mask.hide();
						page.fireEvent(app.event.DONE);
					}
				});
			}
		}
	});
	
	var btnCancelar = new Ext.Button({
       text:  '<s:message code="app.cancelar" text="**Cancelar" />'
       <app:test id="btnCancelarAnalisis" addComa="true" />
       ,iconCls : 'icon_cancel'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
    });
	
	bottomBar.push(btnGuardar);
	bottomBar.push(btnCancelar);
	
	<c:if test="${comboEditable}">
		var panelEdicion=new Ext.form.FormPanel({
			autoHeight:true
			,width:700
			,bodyStyle:'padding:10px;cellspacing:20px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items : [certificado,tipoBurofax]
			,bbar:bottomBar
		});
	</c:if>
	
	<c:if test="${!comboEditable}">
		var panelEdicion=new Ext.form.FormPanel({
			autoHeight:true
			,width:700
			,bodyStyle:'padding:10px;cellspacing:20px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items : [certificado,tipoBurofaxNoEditable]
			,bbar:bottomBar
		});
	</c:if>
	
	page.add(panelEdicion);

</fwk:page>