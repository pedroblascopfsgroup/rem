<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	<%@ include file="../contratos/formBusquedaContratos.jsp" %>
	mainPanel=formBusquedaContratos();

	function transformParamInc() {
		var store = mainPanel.contratosGrid2.getStore();
		var str = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('incluir') == true) {
				if(str!='') str += ',';
	      		str += datos.get('id');
			}
		}
		return str;
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="inclusionContratos.incluirContratos" text="**Incluir contratos seleccionados" />'
		,iconCls:'icon_ok'
		,handler : function(){
      		page.webflow({
      			flow:'expedientes/incluirContratoUpdate'
				,eventName: 'update'
      			,params:{
      				   contratos:transformParamInc()
					   ,idExpediente:'${idExpediente}'
      				}
      			,success: function(){
           		   page.fireEvent(app.event.DONE);
           		}
      		});
		}
	});

	var btnCancelar = new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		,bodyStyle:'padding:0px;'
		,border: false
		,items: [
			{
				autoHeight:true
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:0px;cellspacing:0px;'
						,items:[mainPanel]
					}
				]
			}
		]
		,bbar: [ '->',btnIncluir,btnCancelar ]
	});

	page.add(panelEdicion);
</fwk:page>
