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
   

	<pfsforms:ddCombo name="resultadosBurofax"
		labelKey="plugin.precontencioso.grid.burofax.resultado" 
 		label="**Resultado Burofax" value="" dd="${resultadosBurofax}" 
		propertyCodigo="id" propertyDescripcion="descripcion" />
		
    var fechaAcuse = new Ext.ux.form.XDateField({
		name : 'fechaAcuse'
		,fieldLabel : '<s:message code="plugin.precontencioso.grid.burofax.fechaAcuse" text="**Fecha Acuse" />'
		,style:'margin:0px'
	});
	
	var fechaEnvio = new Ext.ux.form.XDateField({
		name : 'fechaEnvio'
		,fieldLabel : '<s:message code="plugin.precontencioso.grid.burofax.fechaEnvio" text="**Fecha Envio" />'
		,style:'margin:0px'
	});		

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){	
		    	Ext.Ajax.request({
						url : page.resolveUrl('burofax/configuraInformacionEnvio'), 
						params : {idResultadoBurofax:resultadosBurofax.value,fechaAcuse:fechaAcuse.getValue().format('d/m/Y'),fechaEnvio:fechaEnvio.getValue().format('d/m/Y'),arrayIdEnvios:arrayIdEnvios},
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
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
	
	var panelEdicion=new Ext.form.FormPanel({
		autoHeight:true
		,width:400
		,bodyStyle:'padding:10px;cellspacing:20px'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items : [resultadosBurofax,fechaEnvio,fechaAcuse]
		,bbar:bottomBar
	});
	
	page.add(panelEdicion);

</fwk:page>