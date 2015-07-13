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
	
    var idProcedimiento='${idProcedimiento}';
	var arrayIdClientes='${arrayIdClientes}';
    var arrayIdDirecciones='${arrayIdDirecciones}';
    var contenidoBurofax='${textoBurofax}';
		
	var textoBurofax = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.precontencioso.grid.burofax.contenido" text="**Contenido Burofax" />'
		,name: 'prueba'
		,value:'<s:message text='${textoBurofax}' javaScriptEscape="true" />'
		,width: 400 
		,height:400
		, maxLength: 2000
		,allowBlank: false
	});	

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){	
		    	Ext.Ajax.request({
						url : page.resolveUrl('burofax/editarBurofax'), 
						params : {contenidoBurofax:textoBurofax.value,idProcedimiento:idProcedimiento,arrayIdClientes:arrayIdClientes,arrayIdDirecciones},
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
		,width:700
		,bodyStyle:'padding:10px;cellspacing:20px'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items : [textoBurofax]
		,bbar:bottomBar
	});
	
	page.add(panelEdicion);

</fwk:page>