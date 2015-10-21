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
	
    
	var arrayIdBurofax='${arrayIdBurofax}';
    var arrayIdDirecciones='${arrayIdDirecciones}';
   
   

	<pfsforms:ddCombo name="tipoBurofax"
		labelKey="plugin.precontencioso.grid.burofax.tipoBurofax" 
 		label="**Tipo Burofax" value="" dd="${tipoBurofax}" 
		propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true" blankElement="" blankElementText=""/>

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
				
				if(tipoBurofax.validate()){	
			    	Ext.Ajax.request({
							url : page.resolveUrl('burofax/configurarTipoBurofax'), 
							params : {idTipoBurofax:tipoBurofax.value,arrayIdDirecciones:arrayIdDirecciones,arrayIdBurofax:arrayIdBurofax},
							method: 'POST',
							success: function ( result, request ) {
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
	
	var panelEdicion=new Ext.form.FormPanel({
		autoHeight:true
		,width:700
		,bodyStyle:'padding:10px;cellspacing:20px'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items : [tipoBurofax]
		,bbar:bottomBar
	});
	
	page.add(panelEdicion);

</fwk:page>