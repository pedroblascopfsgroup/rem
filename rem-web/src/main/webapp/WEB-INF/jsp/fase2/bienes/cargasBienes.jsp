<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	//Bien al que está asociada la carga
	var bien = app.creaLabel('<s:message code="" text="**Bien" />' , 'bla');
	//Tipo Carga
	var tipoCarga = app.creaText('tipoCarga', '<s:message code="" text="**Tipo Carga" />' , '');
	//Importe Carga
	var importeCarga = app.creaNumber('importeCarga', '<s:message code="" text="**Importe Carga" />' , '');
	//Letra de la carga
	var letraCarga = app.creaText('letraCarga', '<s:message code="" text="**Letra Carga" />' , '');
	//Demandado
	var demandado = app.creaText('demandado', '<s:message code="" text="**Demandado" />' , '');
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
						//if(tipo.getValue()!='1' && tipo.getValue()!='2') {
						//	datosRegistrales.setValue(null);
						//	refCatastral.setValue(null);
						//	poblacion.setValue(null);
						//	superficie.setValue(null);
						//}
						page.submit({
							eventName : 'update'
							,formPanel : panelEdicion
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
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[bien,tipoCarga,importeCarga,letraCarga,demandado]
					}
				]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	

	page.add(panelEdicion);
	
</fwk:page>