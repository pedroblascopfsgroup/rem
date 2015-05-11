<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	debugger;
	
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
	asuId = '';
	contratoId = '${contratoId}';
	revisadoA = '';
	ejecucionIniciada = '';
	propuestaEjecucion = '';
	iniciarEjecucion = '';
	revisadoB = '';
	solicitarSolvencia = '';
	fechaSolicitarSolvencia = '';
	fechaRecepcion = '';
	resultado = '';
	decisionB = '';
	revisadoC = '';
	decisionC = '';
	fechaProximaRevision = '';
	decisionRevision = '';
	
	<c:if test="${anc!=null}">
		id = '${anc.id}';
		asuId = '${anc.asunto.id}';
		contratoId = '${contratoId}';
		revisadoA = '${anc.revisadoA}';
		ejecucionIniciada = '${anc.ejecucionIniciada}';
		propuestaEjecucion = '${anc.propuestaEjecucion}';
		iniciarEjecucion = '${anc.iniciarEjecucion}';
		revisadoB = '${anc.revisadoB}';
		solicitarSolvencia = '${anc.solicitarSolvencia}';
		fechaSolicitarSolvencia = '${anc.fechaSolicitarSolvencia}';
		fechaRecepcion = '${anc.fechaRecepcion}';
		resultado = '${anc.resultado}';
		decisionB = '${anc.decisionB}';
		revisadoC = '${anc.revisadoC}';
		decisionC = '${anc.decisionC}';
		fechaProximaRevision = '${anc.fechaProximaRevision}';
		decisionRevision = '${anc.decisionRevision}';
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
	
	var comboRevisadoA = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,width: 100
		,resizable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Revisado" />'
		,value : revisadoA == '' ? '' : revisadoA == 'true' ? 'Si' : 'No'
	});
	
	
	var comboPropuestaEjecucion = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Propuesta ejecución" />'
		,value : propuestaEjecucion == '' ? '' : propuestaEjecucion == 'true' ? 'Si' : 'No'
	});
	
	var comboIniciarEjecucion = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Iniciar ejecución" />'
		,value : iniciarEjecucion == '' ? '' : iniciarEjecucion == 'true' ? 'Si' : 'No'
	});
	
	<%--fiadores --%>
	var comboRevisadoB = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Revisado" />'
		,value : revisadoB == '' ? '' : revisadoB == 'true' ? 'Si' : 'No'
	});
	
	var comboSolicitarSolvenvia = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Solicitar solvencia" />'
		,value : solicitarSolvencia == '' ? '' : solicitarSolvencia == 'true' ? 'Si' : 'No'
	});
	
	
	var fechaSolicitarSolvencia=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="" text="Fecha solicitar solvencia" />'
		,name:'fechaSolicitarSolvencia'
		,value:	'<fwk:date value="${anc.fechaSolicitarSolvencia}"/>'
	});
	
	
	var fechaRecepcion=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="" text="Fecha recepción" />'
		,name:'fechaRecepcion'
		,value:	'<fwk:date value="${anc.fechaRecepcion}"/>'
	});
	
	var comboResultado = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Resultado" />'
		,value : resultado == '' ? '' : resultado == 'true' ? 'Si' : 'No'
	});
	
	var comboDecisionB = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Decisión" />'
		,value : decisionB == '' ? '' : decisionB == 'true' ? 'Si' : 'No'
	});
	
	
	<%--garantía hipotecaria --%>
	
	var comboRevisadoC = new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Revisión" />'
		,value : revisadoC == '' ? '' : revisadoC == 'true' ? 'Si' : 'No'
	});
	
	var comboDecisionC= new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Decisión" />'
		,value : decisionC == '' ? '' : decisionC == 'true' ? 'Si' : 'No'
	});
	
	var fechaProximaRevision=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="" text="Fecha recepción" />'
		,name:'fechaProximaRevision'
		,value:	'<fwk:date value="${anc.fechaProximaRevision}"/>'
	});
	
	var comboDecisionRevision= new Ext.form.ComboBox({
		store:sinoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,width: 100
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="" text="Decisión revisión" />'
		,value : decisionRevision == '' ? '' : decisionRevision == 'true' ? 'Si' : 'No'
	});
	
	
	var btnGuardarEdit = new Ext.Button({
		text : '<s:message code="app.guardar" text="Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			 Ext.Ajax.request({
				url: page.resolveUrl('analisiscontratos/guardarAnalisisContratos')
				,method: 'POST'
				,params:{
						id:id
					   ,contratoId: contratoId
					   ,asuId: asuId
      				   ,revisadoA: comboRevisadoA.getValue() == '' ? null : comboRevisadoA.getValue() == 'Si' || comboRevisadoA.getValue() == '01' ? true : false 
      				   ,propuestaEjecucion: comboPropuestaEjecucion.getValue() == '' ? null : comboPropuestaEjecucion.getValue() == 'Si' || comboPropuestaEjecucion.getValue() == '01' ? true : false 
      				   ,iniciarEjecucion: comboIniciarEjecucion.getValue() == '' ? null : comboIniciarEjecucion.getValue() == 'Si' || comboIniciarEjecucion.getValue() == '01' ? true : false 
      				   ,revisadoB: comboRevisadoB.getValue() == '' ? null : comboRevisadoB.getValue() == 'Si' || comboRevisadoB.getValue() == '01' ? true : false 
      				   ,solicitarSolvencia: comboSolicitarSolvenvia.getValue() == '' ? null : comboSolicitarSolvenvia.getValue() == 'Si' || comboSolicitarSolvenvia.getValue() == '01' ? true : false 
      				   ,fechaSolicitarSolvencia: fechaSolicitarSolvencia.getValue()
      				   ,fechaRecepcion: fechaRecepcion.getValue()
      				   ,resultado: comboResultado.getValue() == '' ? null : comboResultado.getValue() == 'Si' || comboResultado.getValue() == '01' ? true : false 
      				   ,decisionB: comboDecisionB.getValue() == '' ? null : comboDecisionB.getValue() == 'Si' || comboDecisionB.getValue() == '01' ? true : false 
      				   ,revisadoC: comboRevisadoC.getValue() == '' ? null : comboRevisadoC.getValue() == 'Si' || comboRevisadoC.getValue() == '01' ? true : false 
      				   ,decisionC: comboDecisionC.getValue() == '' ? null : comboDecisionC.getValue() == 'Si' || comboDecisionC.getValue() == '01' ? true : false 
      				   ,fechaProximaRevision: fechaProximaRevision.getValue()
      				   ,decisionRevision: comboDecisionRevision.getValue() == '' ? null : comboDecisionRevision.getValue() == 'Si' || comboDecisionRevision.getValue() == '01' ? true : false 
      				}
				,success: function (result, request){
					page.fireEvent(app.event.DONE);
				}
				,error: function(){
					Ext.MessageBox.show({
			           title: 'Guardado',
			           msg: '<s:message code="plugin.mejoras.asunto.ErrorGuardado" text="Error guardado" />',
			           width:300,
			           buttons: Ext.MessageBox.OK
			       });
					page.fireEvent(app.event.CANCEL);
				} 
			});
	   }
	});
			
	
	var panelEdicion=new Ext.form.FormPanel({
		bodyStyle:'padding:10px;cellspacing:20px'
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
							comboRevisadoA,comboPropuestaEjecucion,comboIniciarEjecucion
							,comboRevisadoB, comboSolicitarSolvenvia, fechaSolicitarSolvencia, fechaRecepcion, comboResultado, comboDecisionB
							,comboRevisadoC,comboDecisionC, fechaProximaRevision, comboDecisionRevision
							]
					}
				]
			}
		]
		,bbar:[btnGuardarEdit, btnCancelar]
	});
	
	
	var datosA = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:10px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="" text="prendas, pignoración, IPF, otros"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[comboRevisadoA,comboPropuestaEjecucion]},
				  {items:[comboIniciarEjecucion]}
				 ]
	});
	
	var datosB = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:10px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="" text="fiadores, librado, descuento"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[comboRevisadoB,comboSolicitarSolvenvia, fechaSolicitarSolvencia]},
				  {items:[fechaRecepcion,comboResultado, comboDecisionB]}
				 ]
	});
	
	var datosC = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:10px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="" text="hipotecaria"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[comboRevisadoC,comboDecisionC]},
				  {items:[fechaProximaRevision,comboDecisionRevision]}
				 ]
	});
	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		autoScroll:true
		//,width:300
		,height:480
		,layout:'table'
		,bodyStyle:'padding:10px;margin:10px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', border :true ,cellCls : 'vtop'}
		,items : [datosA, datosB, datosC]
		,bbar:[btnGuardarEdit, btnCancelar]
	});
	
	
	
	
	
page.add(panel);
	
</fwk:page>
