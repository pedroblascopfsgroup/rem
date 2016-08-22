<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	var labelStyle='font-weight:bolder;';

    var dictCausas = <app:dict value="${motivosExclusion}" />;

	//store generico de combo diccionario
	var optionsCausasStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictCausas
	});

	var comboCausas = new Ext.form.ComboBox({
		store:optionsCausasStore
		,displayField:'descripcion'
		,name:'causas'
		,valueField:'codigo'
		,width:200
		,mode: 'local'
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="clientes.telecobro.causas" text="**Causas" />'
		,labelStyle:labelStyle
	});
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.telecobro.observaciones" text="**Observaciones" />'
		,name:'observaciones'
		,width:325
		,height:150
		,maxLength:500
		,labelStyle:labelStyle
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			page.submit({
					eventName : 'update'
					,formPanel : mainPanel
                    ,params: {
                    idMotivo: comboCausas.getValue(), 
                    observacion: observaciones.getValue(),
                    idCliente:${idCliente}                    
                }
					,success : function(){ page.fireEvent(app.event.DONE); }
				});
		  }
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : mainPanel
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
	var mainPanel=new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle:'padding:10px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			 ,{
				border : false
			 	,xtype:'fieldset'
				,autoHeight:true
				,items:[comboCausas,observaciones]
			 }
		]
		,bbar:[btnGuardar,btnCancelar]
	});
	page.add(mainPanel);
</fwk:page>