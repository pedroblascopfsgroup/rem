<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var labelStyle = 'width:150px;font-weight:bolder",width:375';
	var labelStyleTextArea = 'font-weight:bolder",width:500';

	var SI_NO_Render = function (value, meta, record) {
		if (value=='Sí' || value=='01' || ''+value=='true') {
			return '<s:message code="label.si" text="**S&iacute;" />';
		}if (value=='No' || value=='02' || ''+value=='false') {
			return '<s:message code="label.no" text="**No" />';
		}
		return '';
	};

	id = '';
	ancId = '';
	bieId = '';
	solicitarNoAfeccion = '';
	fechaSolicitarNoAfeccion = '';
	fechaResolucion = '';
	resolucion = '';
	
	bieId = '${bieId}';
	ancId = '${ancId}'
	
	<c:if test="${bie!=null}">
		id = '${bie.id}';
		ancId = '${ancId}';
		solicitarNoAfeccion = '${bie.solicitarNoAfeccion}';
		fechaSolicitarNoAfeccion = '${bie.fechaSolicitarNoAfeccion}';
		fechaResolucion = '${bie.fechaResolucion}';
		resolucion = '${bie.resolucion}';
		
	</c:if>
	
	var validarForm = function() {
		
		return true;
	}

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
			
	var getParametros = function() {
	 	var parametros = {};	 	
		
		return parametros;
	}
	
	
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);
	
	var sinoStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	sinoStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDSiNo' });
	
	var posNegStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'posNegStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	
	posNegStore.webflow({diccionario: 'es.capgemini.pfs.procesosJudiciales.model.DDPositivoNegativo' });
	
	<%--prendas, ... --%>
	
	var comboSolicitarNoAfeccion = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,width: 100
		,resizable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Solicitar no afección" />'
		,value : solicitarNoAfeccion == '' ? '' : solicitarNoAfeccion == 'true' ? 'Si' : 'No'
	});
	
	
	var fechaSolicitarNoAfeccion=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="" text="Fecha solicitar no afección" />'
		,name:'fechaSolicitarNoAfeccion'
		,value:	'<fwk:date value="${bie.fechaSolicitarNoAfeccion}"/>'
	});
	
	var fechaResolucion=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="" text="Fecha resolución" />'
		,name:'fechaResolucion'
		,value:	'<fwk:date value="${bie.fechaResolucion}"/>'
	});
	
	var comboResolucion = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Resolución" />'
		,value : resolucion == '' ? '' : resolucion == 'true' ? 'Si' : 'No'
	});
	
	
	
	var btnGuardarEdit = new Ext.Button({
		text : '<s:message code="app.guardar" text="Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			var p = getParametros();
			 Ext.Ajax.request({
				url: page.resolveUrl('analisiscontratos/guardarAnalisisContratosBienes')
				,method: 'POST'
				,params: p
				,success: function (result, request){
					page.fireEvent(app.event.DONE);
				}
			});
	   }
	});
	
	var getParametros =  function(){
			var parametros = {};
			
			parametros.id = id;
			parametros.bieId = bieId;
			parametros.ancId = ancId;
			parametros.solicitarNoAfeccion = comboSolicitarNoAfeccion.getValue() == '' ? null : comboSolicitarNoAfeccion.getValue() == 'Si' || comboSolicitarNoAfeccion.getValue() == '01' ? true : false ;
      		parametros.fechaSolicitarNoAfeccion = fechaSolicitarNoAfeccion.getValue();
      		parametros.fechaResolucion = fechaResolucion.getValue();
      		parametros.resolucion = comboResolucion.getValue() == '' ? null : comboResolucion.getValue() == 'Si' || comboResolucion.getValue() == '01' ? true : false ;
			
			return parametros;
	}
		
			
	
	var panelEdicion=new Ext.form.FormPanel({
		autoHeight:true
		,width:700
		,bodyStyle:'padding:10px;cellspacing:20px'
		//,xtype:'fieldset'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[
			{ xtype : 'errorList', id:'errorList' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:1}
				,border:false
				//,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,autoHeight:true
						,items:[
							comboSolicitarNoAfeccion,fechaSolicitarNoAfeccion,fechaResolucion,comboResolucion
							]
					}
				]
			}
		]
		,bbar:[btnGuardarEdit, btnCancelar]
	});
	
	
	
page.add(panelEdicion);
	
</fwk:page>
