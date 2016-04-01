<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@taglib prefix="pfs"  tagdir="/WEB-INF/tags/pfs"%>
<%@taglib prefix="pfsforms"  tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>
	<%-- Variables --%>
	var labelStyle='font-weight:bolder;width:100';
	var style='margin-bottom:2px;margin-top:1px';
	var stylePanelDerecha='margin-bottom:-5px;margin-left:25px';
	var styleColumnas='margin-bottom:-15px;margin-top:-8px;margin-left:-10px';
	var id = new Ext.form.Hidden({
		id:'contabilidadCobro.id'
		,value:'${contabilidadCobro.id}'
	});
	
	<%-- Campo Fecha Entrega --%>
	var fechaEntrega = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="contabilidad.fechaEntrega" text="**Fecha Entrega" />'
		,name:'contCobro.fechaEntrega'
		,style:'margin:0px'
		,allowBlank: false
		,labelStyle:labelStyle
		<c:if test="${contabilidadCobro.fechaEntrega!=null}" >
			,value: '<fwk:date value="${contabilidadCobro.fechaEntrega}" />'
		</c:if>
	});
	
	<%-- Campo Fecha Valor --%>
	var fechaValor = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="contabilidad.fechaValor" text="**Fecha Valor" />'
		,name:'contCobro.fechaValor'
		,style:'margin:0px'
		,allowBlank: false
		,labelStyle:labelStyle
		<c:if test="${contabilidadCobro.fechaValor!=null}" >
			,value: '<fwk:date value="${contabilidadCobro.fechaValor}" />'
		</c:if>
	});
	
	<%-- Combo Tipo Entrega --%>
	var dictDDTipoEntrega = <app:dict value="${ddTipoEntrega}" />;
	
	var storeTipoEntrega =  new Ext.data.JsonStore({
		fields : ['codigo', 'descripcion']
		,root : 'diccionario'
		,data : dictDDTipoEntrega
	});
	
	var comboDDTipoEntrega =new Ext.form.ComboBox({
		store: storeTipoEntrega
		,allowBlank: false
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,hiddenName: 'DDTipoEntrega'
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="contabilidad.tipoEntrega" text="**Tipo Entrega"/>'
		,triggerAction : 'all'
		,mode:'local'
		,width:550
		<c:if test="${contabilidadCobro.tipoEntrega!=null}" >
			,value:'${contabilidadCobro.tipoEntrega.codigo}'
		</c:if>
		
	});

	 <%-- Combo Concepto Entrega --%>
	var dictDDConceptoEntrega = <app:dict value="${ddConceptoEntrega}" />;
	
	var storeConceptoEntrega =  new Ext.data.JsonStore({
		fields : ['codigo', 'descripcion']
		,root : 'diccionario'
		,data : dictDDConceptoEntrega
	});
	
	var comboDDConceptoEntrega =new Ext.form.ComboBox({
		store: storeConceptoEntrega
		,allowBlank: false
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,hiddenName: 'DDConceptoEntrega'
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="contabilidad.conceptoEntrega" text="**Concepto Entrega"/>'
		,triggerAction : 'all'
		,mode:'local'
		,width:550
		<c:if test="${contabilidadCobro.conceptoEntrega!=null}" >
			,value:'${contabilidadCobro.conceptoEntrega.codigo}'
		</c:if>
		
	});

	<%-- Entrada de Texto Numero Nominal --%>
	var nominal  = app.creaNumber('contabilidadCobro.nominal',
		'<s:message code="contabilidad.nominal" text="**Nominal" />',
		'${contabilidadCobro.nominal}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,enableKeyEvents: true
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.nominal!=null}" >
				,value:'${contabilidadCobro.nominal}'
			</c:if>
		}
	);
	
	
	
	<%-- Entrada de Texto Numero Intereses --%>
	var intereses  = app.creaNumber('contabilidadCobro.intereses',
		'<s:message code="contabilidad.intereses" text="**Intereses" />',
		'${contabilidadCobro.intereses}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.intereses!=null}" >
				,value:'${contabilidadCobro.intereses}'
			</c:if>
		}
	);
	
	
	
	<%-- Entrada de Texto Numero Demoras --%>
	var demoras  = app.creaNumber('contabilidadCobro.demoras',
		'<s:message code="contabilidad.demoras" text="**Demoras" />',
		'${contabilidadCobro.demoras}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.demoras!=null}" >
				,value:'${contabilidadCobro.demoras}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Impuestos --%>
	var impuestos  = app.creaNumber('contabilidadCobro.impuestos',
		'<s:message code="contabilidad.impuestos" text="**Impuestos" />',
		'${contabilidadCobro.impuestos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.impuestos!=null}" >
				,value:'${contabilidadCobro.impuestos}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Gastos Procurador --%>
	var gastosProcurador  = app.creaNumber('contabilidadCobro.gastosProcurador',
		'<s:message code="contabilidad.gastosProcurador" text="**Gastos Procurador" />',
		'${contabilidadCobro.gastosProcurador}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.gastosProcurador!=null}" >
				,value:'${contabilidadCobro.gastosProcurador}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Gastos Letrado --%>
	var gastosLetrado  = app.creaNumber('contabilidadCobro.gastosLetrado',
		'<s:message code="contabilidad.gastosLetrado" text="**Gastos Letrado" />',
		'${contabilidadCobro.gastosLetrado}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.gastosLetrado!=null}" >
				,value:'${contabilidadCobro.gastosLetrado}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Otros Gastos --%>
	var otrosGastos  = app.creaNumber('contabilidadCobro.otrosGastos',
		'<s:message code="contabilidad.otrosGastos" text="**Otros Gastos" />',
		'${contabilidadCobro.otrosGastos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.otrosGastos!=null}" >
				,value:'${contabilidadCobro.otrosGastos}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Nominal --%>
	var quitaNominal  = app.creaNumber('contabilidadCobro.quitaNominal',
		'<s:message code="contabilidad.quitaNominal" text="**Quita Nominal" />',
		'${contabilidadCobro.quitaNominal}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaNominal!=null}" >
				,value:'${contabilidadCobro.quitaNominal}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Intereses --%>
	var quitaIntereses  = app.creaNumber('contabilidadCobro.quitaIntereses',
		'<s:message code="contabilidad.quitaIntereses" text="**Quita Intereses" />',
		'${contabilidadCobro.quitaIntereses}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaIntereses!=null}" >
				,value:'${contabilidadCobro.quitaIntereses}'
			</c:if>
		}
	);
		
	<%-- Entrada de Texto Numero Quita Demoras --%>
	var quitaDemoras  = app.creaNumber('contabilidadCobro.quitaDemoras',
		'<s:message code="contabilidad.quitaDemoras" text="**Quita Demoras" />',
		'${contabilidadCobro.quitaDemoras}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaDemoras!=null}" >
				,value:'${contabilidadCobro.quitaDemoras}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Impuestos --%>
	var quitaImpuestos  = app.creaNumber('contabilidadCobro.quitaImpuestos',
		'<s:message code="contabilidad.quitaImpuestos" text="**Quita Impuestos" />',
		'${contabilidadCobro.quitaImpuestos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaImpuestos!=null}" >
				,value:'${contabilidadCobro.quitaImpuestos}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Gastos Procurador --%>
	var quitaGastosProcurador  = app.creaNumber('contabilidadCobro.quitaGastosProcurador',
		'<s:message code="contabilidad.quitaGastosProcurador" text="**Quita Gastos Procurador" />',
		'${contabilidadCobro.quitaGastosProcurador}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaGastosProcurador!=null}" >
				,value:'${contabilidadCobro.quitaGastosProcurador}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Gastos Letrado --%>
	var quitaGastosLetrado  = app.creaNumber('contabilidadCobro.quitaGastosLetrado',
		'<s:message code="contabilidad.quitaGastosLetrado" text="**Quita Gastos Letrado" />',
		'${contabilidadCobro.quitaGastosLetrado}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaGastosLetrado!=null}" >
				,value:'${contabilidadCobro.quitaGastosLetrado}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Quita Otros Gastos --%>
	var quitaOtrosGastos  = app.creaNumber('contabilidadCobro.quitaOtrosGastos',
		'<s:message code="contabilidad.quitaOtrosGastos" text="**Quita Otros Gastos" />',
		'${contabilidadCobro.quitaOtrosGastos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:16
			,listeners : {blur : function(){
							refreshTotalEntrega()
						}
			}
			<c:if test="${contabilidadCobro.quitaOtrosGastos!=null}" >
				,value:'${contabilidadCobro.quitaOtrosGastos}'
			</c:if>
		}
	);
	
	<%-- Entrada de Texto Numero Total Entrega --%>
	var totalEntrega  = app.creaNumber('contabilidadCobro.totalEntrega',
		'<s:message code="contabilidad.totalEntrega" text="**Total Entrega" />',
		'${contabilidadCobro.totalEntrega}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowBlank: false
			,allowNegative: false
			,readOnly:true
			,maxLength:16
			<c:if test="${contabilidadCobro.totalEntrega!=null}" >
				,value:'${contabilidadCobro.totalEntrega}'
			</c:if>
		}
	);
	
	function refreshTotalEntrega(){
		var sumaTotal = 0;
	 	if(nominal.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(nominal.getValue());
		}
		if(intereses.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(intereses.getValue());
		}
		if(demoras.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(demoras.getValue());
		}
		if(impuestos.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(impuestos.getValue());
		}
		if(gastosProcurador.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(gastosProcurador.getValue());
		}
		if(gastosLetrado.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(gastosLetrado.getValue());
		}
		if(otrosGastos.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(otrosGastos.getValue());
		}
		if(quitaNominal.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaNominal.getValue());
		}
		if(quitaIntereses.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaIntereses.getValue());
		}
		if(quitaDemoras.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaDemoras.getValue());
		}
		if(quitaImpuestos.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaImpuestos.getValue());
		}
		if(quitaGastosProcurador.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaGastosProcurador.getValue());
		}
		if(quitaGastosLetrado.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaGastosLetrado.getValue());
		}
		if(quitaOtrosGastos.getValue() != ''){
			sumaTotal = sumaTotal + parseInt(quitaOtrosGastos.getValue());
		}

		totalEntrega.setValue(sumaTotal);
	}
	
	<%-- Campo de Texto Numero Num Enlace --%>
	var numEnlace  = new Ext.form.TextArea({
		fieldLabel:'<s:message code="contabilidad.numEnlace" text="**Número Enlace" />'
		,labelStyle:labelStyle
		,style:style
		,width:135
		,height:21
		<c:if test="${contabilidadCobro.numEnlace!=null}" >
			,value:'${contabilidadCobro.numEnlace}'
		</c:if>
		}
	);
	
	<%-- Campo de Texto Numero Num Mandamiento --%>
	var numMandamiento  = new Ext.form.TextArea({
		fieldLabel:'<s:message code="contabilidad.numMandamiento" text="**Número Mandamiento" />'
		,labelStyle:labelStyle
		,style:style
		,width:135
		,height:21
		<c:if test="${contabilidadCobro.numMandamiento!=null}" >
			,value:'${contabilidadCobro.numMandamiento}'
		</c:if>
		}
	);
	
	<%-- Campo de Texto Numero Num Cheque --%>
	var numCheque  = new Ext.form.TextArea({
		fieldLabel:'<s:message code="contabilidad.numCheque" text="**Número Cheque" />'
		,labelStyle:labelStyle
		,width:135
		,height:21
		,style:style
		<c:if test="${contabilidadCobro.numCheque!=null}" >
			,value:'${contabilidadCobro.numCheque}'
		</c:if>
		});

	<%-- Campo Texto Observaciones --%>
	var observaciones=new Ext.form.TextArea({
		fieldLabel:'<s:message code="contabilidad.observaciones" text="**Observaciones" />'
		,width:550
		,height:80
		,maxLength:100
		,style:style
		,labelStyle:labelStyle
	    ,name: 'contabilidadCobro.observaciones'
	    <c:if test="${contabilidadCobro.observaciones!=null}" >
			,value:'${contabilidadCobro.observaciones}'
		</c:if>
	});
	
	<%-- CheckBox operaciones en tramite --%>
	var opTramite = new Ext.form.CheckboxGroup({
    id:'opTramite',
    xtype: 'checkboxgroup',
    itemCls: 'x-check-group-alt',
    columns: 1,
    style:style,
	labelStyle:labelStyle,
    items: [
        {fieldLabel: '<s:message code="contabilidad.operacionesTramite" text="**Operaciones Trámite" />'
        ,name: 'cb-1'
        ,style:style
		,labelStyle:labelStyle
		<c:if test="${contabilidadCobro.operacionesTramite==true}" >
			,checked: true
		</c:if>
		}
    ]
});
	
	<%-- Validaciones Formulario --%>
	var validarCamposObligatorios = function(){
		if(fechaEntrega.getValue() != null && fechaEntrega.getValue() != "" && fechaValor.getValue() != null && fechaValor.getValue() != "" &&
		 comboDDTipoEntrega.getValue() != null && comboDDTipoEntrega.getValue() != "" && comboDDConceptoEntrega.getValue() != null && comboDDConceptoEntrega.getValue() != "" &&
		 totalEntrega.getValue() != 0 && totalEntrega.getValue() != "" && totalEntrega.getValue() != null){
			return true;
		} else {
			Ext.MessageBox.alert('<s:message code="contabilidad.msgValidationErrorTitle" text="**Error" />', '<s:message code="contabilidad.msgValidationError" text="**Falta algún parámetro obligatorio" />');
			return false;
		}
	}
	
	Ext.onReady(function () {
	    refreshTotalEntrega();
	});
	
	<%-- Botones Ventana --%>
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if(validarCamposObligatorios()){
			<%-- Si las validaciones son correctas --%>
				var parametros = {
						id:'${contabilidadCobro.id}'
						,asunto:'${idAsunto}'
						,fechaEntrega:fechaEntrega.getRawValue()
						,fechaValor:fechaValor.getRawValue()
						,tipoEntrega:comboDDTipoEntrega.getValue()
						,conceptoEntrega:comboDDConceptoEntrega.getValue()
						,nominal:nominal.getValue()
						,intereses:intereses.getValue()
						,demoras:demoras.getValue()
						,impuestos:impuestos.getValue()
						,gastosProcurador:gastosProcurador.getValue()
						,gastosLetrado:gastosLetrado.getValue()
						,otrosGastos:otrosGastos.getValue()
						,quitaNominal:quitaNominal.getValue()
						,quitaIntereses:quitaIntereses.getValue()
						,quitaDemoras:quitaDemoras.getValue()
						,quitaImpuestos:quitaImpuestos.getValue()
						,quitaGastosProcurador:quitaGastosProcurador.getValue()
						,quitaGastosLetrado:quitaGastosLetrado.getValue()
						,quitaOtrosGastos:quitaOtrosGastos.getValue()
						,totalEntrega:totalEntrega.getValue()
						,observaciones:observaciones.getValue()
						,numEnlace:numEnlace.getValue()
						,numMandamiento:numMandamiento.getValue()
						,numCheque:numCheque.getValue()
						,operacionesTramite:opTramite.items.items[0].getValue()
					};
				Ext.Ajax.request({
    				url: page.resolveUrl('contabilidadcobros/saveContabilidadCobro')
   					,params: parametros
  					,method: 'POST'
   					,success: function (result, request){
   						page.fireEvent(app.event.DONE)
   					 }
   					,error : function (result, request){
	   				 }
       				,failure: function (response, options){
					 }
				});
			}
		}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
		page.fireEvent(app.event.CANCEL);
			}
	});
	
	<%-- Seccion Superior Izquierda --%>
	var panelSuperiorIzquierdo =  new Ext.Container({
		layout: 'form'
		,items : [fechaValor]
	});
	
	<%-- Seccion Superior Derecha --%>
	var panelSuperiorDerecha =  new Ext.Container({
		layout: 'form'
		,items : [opTramite]
	});
	
	<%-- Columnas Superior --%>
	var columnasSuperior = new Ext.form.FieldSet({
		autoHeight:'true'
		,layout: 'table'
		,border:false
		,style: styleColumnas
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
		,items : [panelSuperiorIzquierdo,panelSuperiorDerecha]
	 });
	
	<%-- Seccion Inferior Izquierda --%>
	var panelInferiorIzquierdo =  new Ext.Container({
		layout: 'form'
		,items : [nominal,intereses,demoras,impuestos,
			gastosProcurador,gastosLetrado,otrosGastos]
	});
	
	
	<%-- Seccion Inferior Derecha --%>
	var panelInferiorDerecha =  new Ext.Container({
		layout: 'form'
		,style: stylePanelDerecha
		,items : [quitaNominal,quitaIntereses,quitaDemoras,quitaImpuestos,quitaGastosProcurador,
			quitaGastosLetrado,quitaOtrosGastos]
	});
	
	<%-- Columnas Inferior --%>
	var columnasInferior = new Ext.form.FieldSet({
		autoHeight:'true'
		,layout: 'table'
		,border:false
		,style: styleColumnas
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
		,items : [panelInferiorIzquierdo,panelInferiorDerecha]
	 }); 
	
	<%-- Panel --%>	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			{ xtype : 'errorList', id:'errL' }
			,{ 
			border : false
			,layout : 'table'
			,viewConfig : { columns : 2 }
			,defaults :  {layout:'form', autoHeight : true, border : false,width:680 }
			,items : [
			{ items : [fechaEntrega,columnasSuperior,comboDDTipoEntrega,comboDDConceptoEntrega,columnasInferior,totalEntrega,numEnlace,numMandamiento,numCheque,observaciones]
			,style : 'margin-right:10px' }
			]
		}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});

	page.add(panelEdicion);
</fwk:page>
