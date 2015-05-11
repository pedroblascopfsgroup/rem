<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'	


	var nroAntecedentesJud = new Ext.form.NumberField({
		fieldLabel:'<s:message code="antecedentes.edicion.nroincjudic" text="**Nro Antecedentes" />'
		<app:test id="nroAntecedentesJud" addComa="true" />
		,allowNegative:false
		,allowDecimals:false
		,maxValue:999999999
		,value:'${antecedenteExterno.numIncidenciasJudiciales}'
		,name:'antecedenteExterno.numIncidenciasJudiciales'
		,labelStyle:labelStyle
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});


	var fechaAntecedentesJud = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="antecedentes.edicion.fechaincjud" text="**Fecha Antec." />'
		<app:test id="fechaAntecedentesJud" addComa="true" />
		,style:'margin:0px'
		,name:'antecedenteExterno.fechaIncidenciaJudicial'
		,value:'<fwk:date value="${antecedenteExterno.fechaIncidenciaJudicial}" />'
        ,maxValue : new Date()
		,labelStyle:labelStyle
		//,disabled:true
	});


	var nroImpagos = new Ext.form.NumberField({
		fieldLabel:'<s:message code="antecedentes.edicion.nroimpagos" text="**Nro Impagos" />'
		<app:test id="nroImpagos" addComa="true" />
		,allowNegative:false
		,allowDecimals:false
		,value:'${antecedenteExterno.numImpagos}'
		,name:'antecedenteExterno.numImpagos'
		,labelStyle:labelStyle
		,maxValue:999999999
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});


	var fechaImpagos = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="antecedentes.edicion.fechaimpago" text="**Fecha Impago" />'
		<app:test id="fechaImpagos" addComa="true" />
		//,minValue : new Date()
		,style:'margin:0px'
		,name:'antecedenteExterno.fechaImpagos'
		,value:'<fwk:date value="${antecedenteExterno.fechaImpagos}" />'
        ,maxValue : new Date()
		,labelStyle:labelStyle
		//,disabled:true
	});



	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarAntecedenteExterno" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,width:500
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
		
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false,width:300}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[nroAntecedentesJud,fechaAntecedentesJud,nroImpagos,fechaImpagos]
					}
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});
	
	page.add(panelEdicion);
	
</fwk:page>