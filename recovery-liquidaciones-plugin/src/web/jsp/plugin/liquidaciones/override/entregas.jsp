<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@taglib prefix="pfs"  tagdir="/WEB-INF/tags/pfs"%>
<%@taglib prefix="pfsforms"  tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>	
	var labelStyle='font-weight:bolder;width:100';
	var style='margin-bottom:1px;margin-top:1px';
	var id = new Ext.form.Hidden({
		id:'liqCobroPago.id'
		,value:'${liqCobroPago.id}'
	});
	


	 
	var dictDDTipoCobroPago = <app:dict value="${tipo}" />;
	
	 var dictDDTipoCobroPago = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,root: 'diccionario'
        ,data : dictDDTipoCobroPago
        });
	
	var comboDDTipoCobroPago = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,store: dictDDTipoCobroPago
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="entregas.concepto" text="**Concepto"/>'
		,width : 550
		,editable : true
		, forceSelection : true
		<c:if test="${liqCobroPago.subTipo!=null}" >
		<%--,value:'${liqCobroPago.subTipo.tipoCobroPago}'--%>
		,value:'Genérico'
		</c:if>
	});
	
	
	
	var dictDDAdjContableTipoEntrega = <app:dict value="${tipoEntrega}" />;
	
	var dictDDAdjContableTipoEntrega = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,root: 'diccionario'
        ,data : dictDDAdjContableTipoEntrega
        });
	
	var comboDDAdjContableTipoEntrega = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,store: dictDDAdjContableTipoEntrega
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="entregas.tipo" text="**Tipo Entrega"/>'
		,width : 550
		,editable : true
		,forceSelection : true
		,allowBlank: false
		<c:if test="${liqCobroPago.tipoEntrega!=null}" >
			,value:'${liqCobroPago.tipoEntrega.codigo}'
		</c:if>
	});
	
	var dictDDAdjContableConceptoEntrega = <app:dict value="${conceptoEntrega}" />;
	
	var dictDDAdjContableConceptoEntrega = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,root: 'diccionario'
        ,data : dictDDAdjContableConceptoEntrega
        });
	
	var comboDDAdjContableConceptoEntrega = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,store: dictDDAdjContableConceptoEntrega
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="entregas.concepto" text="**Concepto Entrega"/>'
		,width : 550
		,editable : true
		, forceSelection : true
		<c:if test="${liqCobroPago.conceptoEntrega!=null}" >
			,value:'${liqCobroPago.conceptoEntrega.codigo}'
		</c:if>
	});
	
	
	
	<%--var subTipo = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);--%>
	
	<%--var optionsDDSubtipoCobroPagoStore = page.getStore({
	       flow: 'asuntos/buscarSubtipoCobroPago'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'subtipos'
	    }, subTipo)
	       
	});--%>
	
	<%--var comboDDSubtipoCobroPago = new Ext.form.ComboBox({
		store:optionsDDSubtipoCobroPagoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,editable: false
		,triggerAction: 'all'
		,readOnly:false
		,labelStyle:labelStyle
		,width:550
		,resizable:true
		,style:style
		,fieldLabel : '<s:message code="cobroPago.tipoEntrega" text="**Tipo Entrega"/>'
		
	});--%>
	
	<%--var recargarComboSubtipo = function(){
		optionsDDSubtipoCobroPagoStore.webflow({tipo:comboDDTipoCobroPago.getValue()});
		comboDDSubtipoCobroPago.clearValue();
	}--%>
	
	<%--var bloquearComboSubtipo = function(){
		comboDDSubtipoCobroPago.disable();
		comboDDSubtipoCobroPago.reset();
		comboDDTipoCobroPago.disable();
		comboDDTipoCobroPago.reset();
		
	}--%>
	
<!-- 	comboDDTipoCobroPago.on('change',recargarComboSubtipo);
 -->	
 	var procedimientos={"procedimientos":<json:array name="procedimientos" items='${procedimientos}' var="rec" >
		<json:object>
			<json:property name="id" value="${rec.id}"/>
			<json:property name="procedimiento" value="${rec.nombreProcedimiento}"/>
		
		</json:object>
	</json:array>}; 
	
	 var procedimientoStore = new Ext.data.JsonStore({
		 fields: ['id', 'procedimiento']
		,root: 'procedimientos'
		,data : procedimientos
	});

 	var comboProcedimientos = new Ext.form.ComboBox({
		store:procedimientoStore
		,displayField:'procedimiento'
		,valueField:'id'
		,mode: 'local'
		,editable: false
		,triggerAction: 'all'
		,labelStyle:labelStyle
		,width:550
		,resizable:true
		,style:style
		,allowBlank: false
		,forceSelection : true
		,fieldLabel : '<s:message code="cobroPago.procedimiento" text="**procedimiento"/>'
		<c:if test="${liqCobroPago.procedimiento!=null}" >
		,value:'${liqCobroPago.procedimiento.id}'
		</c:if>
	}); 
	
<%-- 	var dictDDOrigenCobro = <app:dict value="${origenCobro}" />; 

	var comboDDOrigenCobro = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDOrigenCobro
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="plugin.liquidaciones.cobroPago.origenCobro" text="**Origen cobro"/>'
		,width : 550
		<c:if test="${liqCobroPago.origenCobro!=null}" >
		,value:'${liqCobroPago.origenCobro.codigo}'
		</c:if>
		,editable : true
		
	}); --%>
	
	<%-- var dictDDModalidadCobro = <app:dict value="${modalidadCobro}" />; 

	var comboDDModalidadCobro = app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictDDModalidadCobro
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="plugin.liquidaciones.cobroPago.modalidadCobro" text="**Modalidad cobro"/>'
		,width : 550
		<c:if test="${liqCobroPago.modalidadCobro!=null}" >
		,value:'${liqCobroPago.modalidadCobro.codigo}'
		</c:if>
		,editable : true
		
	}); --%>
	
	
	<!-- nuevos -->
	
	var fechaEntrega = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="entregas.fecha" text="**Fecha Cobro" />'
		,name:'liqCobroPago.fecha'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,allowBlank: false
		,value: '<fwk:date value="${liqCobroPago.fecha}" />'
	});
	
	var fechaValor = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="entregas.fechaValor" text="**Fecha Valor" />'
		,name:'liqCobroPago.fechaValor'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,allowBlank: false
		,value: '<fwk:date value="${liqCobroPago.fechaValor}" />'
	});
	
	
	
	var nominal  = app.creaNumber('liqCobroPago.capital + liqCobroPago.capitalNoVencido',
		'<s:message code="entregas.nominal" text="**Nominal" />',
		'${liqCobroPago.capital + liqCobroPago.capitalNoVencido}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,disabled: true
			<c:if test="${liqCobroPago.capital!=null && liqCobroPago.capitalNoVencido!=null}" >
			,value:'${liqCobroPago.capital + liqCobroPago.capitalNoVencido}'
			</c:if>
			,listeners : {
				change : function(){
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var capital  = app.creaNumber('liqCobroPago.capital',
		'<s:message code="entregas.capital" text="**Capital Vencido" />',
		'${liqCobroPago.capital}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.capital!=null}" >
			,value:'${liqCobroPago.capital}'
			</c:if>
			,listeners : {
				change : function(){
					nominal.setValue(capital.getValue() + capitalNoVencido.getValue());
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var capitalNoVencido  = app.creaNumber('liqCobroPago.capitalNoVencido',
		'<s:message code="entregas.capitalNoVencido" text="**Capital No Vencido" />',
		'${liqCobroPago.capitalNoVencido}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.capitalNoVencido!=null}" >
			,value:'${liqCobroPago.capitalNoVencido}'
			</c:if>
			,listeners : {
				change : function(){
					nominal.setValue(capital.getValue() + capitalNoVencido.getValue());
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);		
	
	var interesesOrdinarios  = app.creaNumber('liqCobroPago.interesesOrdinarios',
		'<s:message code="entregas.interesesOrdinarios" text="**Intereses" />',
		'${liqCobroPago.interesesOrdinarios}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.interesesOrdinarios!=null}" >
			,value:'${liqCobroPago.interesesOrdinarios}'
			</c:if>
			,listeners : {
				change : function(){
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var interesesMoratorios  = app.creaNumber('liqCobroPago.interesesMoratorios',
		'<s:message code="entregas.interesesMoratorios" text="**Demoras" />',
		'${liqCobroPago.interesesMoratorios}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.interesesMoratorios!=null}" >
			,value:'${liqCobroPago.interesesMoratorios}'
			</c:if>
			,listeners : {
				change : function(){
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var impuestos  = app.creaNumber('liqCobroPago.impuestos',
		'<s:message code="entregas.impuestos" text="**Impuestos" />',
		'${liqCobroPago.impuestos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.impuestos!=null}" >
			,value:'${liqCobroPago.impuestos}'
			</c:if>
			,listeners : {
				change : function(){
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
 	var gastosProcurador  = app.creaNumber('liqCobroPago.gastosProcurador',
		'<s:message code="entregas.gastosProcurador" text="**Gastos Procurador" />',
		'${liqCobroPago.gastosProcurador}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.gastosProcurador!=null}" >
			,value:'${liqCobroPago.gastosProcurador}'
			</c:if>
			,listeners : {
				change : function(){
					totalGastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					gastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var gastosAbogado  = app.creaNumber('liqCobroPago.gastosAbogado',
		'<s:message code="entregas.gastosAbogado" text="**Gastos Abogado" />',
		'${liqCobroPago.gastosAbogado}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.gastosAbogado!=null}" >
			,value:'${liqCobroPago.gastosAbogado}'
			</c:if>
			,listeners : {
				change : function(){
					totalGastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					gastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var otrosGastos  = app.creaNumber('liqCobroPago.gastosOtros',
		'<s:message code="entregas.otrosGastos" text="**Otros Gastos" />',
		'${liqCobroPago.gastosOtros}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${liqCobroPago.gastosOtros!=null}" >
			,value:'${liqCobroPago.gastosOtros}'
			</c:if>
			,listeners : {
				change : function(){
					totalGastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					gastos.setValue(gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					importePago.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
					totalEntrega.setValue(nominal.getValue() + interesesOrdinarios.getValue() + interesesMoratorios.getValue() +impuestos.getValue() + gastosProcurador.getValue() + gastosAbogado.getValue() + otrosGastos.getValue());
				}
			}
		}
	);
	
	var totalGastos  = app.creaNumber('liqCobroPago.gastos',
		'<s:message code="entregas.totalGastos" text="**Total Gastos" />',
		'${liqCobroPago.gastosProcurador + liqCobroPago.gastosAbogado + liqCobroPago.gastosOtros}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,disabled: true
			<c:if test="${liqCobroPago.gastos!=null}" >
			,value:'${liqCobroPago.gastosProcurador + liqCobroPago.gastosAbogado + liqCobroPago.gastosOtros}'
			</c:if>
		}
	);
	
	var gastos  = app.creaNumber('liqCobroPago.gastos',
		'<s:message code="cobroPago.totales" text="**Gasto Totales" />',
		'${liqCobroPago.gastos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
 			,hidden : true
 			<c:if test="${liqCobroPago.gastos!=null}" >
			,value:'${liqCobroPago.gastos}'
			</c:if>
		}
	);	
	
	
 	var totalEntrega  = app.creaNumber('liqCobroPago.importe',
		'<s:message code="entregas.totalEntrega" text="**Total Entrega" />',
		'${liqCobroPago.capital + liqCobroPago.capitalNoVencido + liqCobroPago.interesesOrdinarios + liqCobroPago.interesesMoratorios + liqCobroPago.impuestos + liqCobroPago.gastosAbogado + liqCobroPago.gastosProcurador + liqCobroPago.gastosOtros}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,disabled: true
			<c:if test="${liqCobroPago.importe!=null}" >
			,value:'${liqCobroPago.capital + liqCobroPago.capitalNoVencido + liqCobroPago.interesesOrdinarios + liqCobroPago.interesesMoratorios + liqCobroPago.impuestos + liqCobroPago.gastosAbogado + liqCobroPago.gastosProcurador + liqCobroPago.gastosOtros}'
			</c:if>
		}
	);  <%-- --%>
	
	
	var importePago  = app.creaNumber('liqCobroPago.importe',
		'<s:message code="cobroPago.importe" text="**Importe Total Entrega" />',
		'${liqCobroPago.importe}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
 			,hidden : true
 			<c:if test="${liqCobroPago.importe!=null}" >
			,value:'${liqCobroPago.importe}'
			</c:if>
		}
	);	
	
	var observaciones=new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.liquidaciones.cobroPago.observaciones" text="**Observaciones" />'
		,width:550
		,height:80
		,maxLength:500
		,style:style
		,labelStyle:labelStyle
	    ,name: 'liqCobroPago.observaciones'
		,value:'${liqCobroPago.observaciones}'
	});
	
	var validarParametrosObligatorios= function(){
	
		if(fechaEntrega.getValue() != null && fechaEntrega.getValue() != "" && fechaValor.getValue()!= null && fechaValor.getValue()!= "" && comboDDAdjContableTipoEntrega.getValue() != null && comboDDAdjContableConceptoEntrega.getValue() != null && totalEntrega.getValue() != null
		&& totalEntrega.getValue() != "" && comboProcedimientos.getValue() != null && comboContratos.getValue() != null){
			return true;
		}
		else{
			Ext.MessageBox.alert('Error', 'Falta un parámetro obligatorio');
			return false;
		}
	};

	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		if(validarParametrosObligatorios()){
			Ext.Ajax.request({
               		url: page.resolveUrl('entregas/saveEntrega')
               		,params: {
               			id: '${liqCobroPago.id}'
               			,idAsunto:'${idAsunto}'
	               		,subtipo: 'EC'
						,estado: '03'
						,tipoEntrega: comboDDAdjContableTipoEntrega.getValue()
						,conceptoEntrega: comboDDAdjContableConceptoEntrega.getValue()
						,fechaEntrega: fechaEntrega.getRawValue()
						,fechaValor: fechaValor.getRawValue()
						,nominal: nominal.getValue()
						,capital: capital.getValue()
						,capitalNoVencido: capitalNoVencido.getValue()
						,interesesOrdinarios: interesesOrdinarios.getValue()
						,interesesMoratorios: interesesMoratorios.getValue()
						,impuestos: impuestos.getValue()
						,gastosProcurador: gastosProcurador.getValue()
						,gastosAbogado: gastosAbogado.getValue()
						,otrosGastos: otrosGastos.getValue()
						,gastos: gastos.getValue()
						,importePago: importePago.getValue()
						,observaciones: observaciones.getValue()
						<!-- ,'liqCobroPago.subTipo':subtipo -->
						,procedimiento:comboProcedimientos.getValue()
						 ,contrato:comboContratos.getValue()
						<!-- ,origenCobro:comboDDOrigenCobro.getValue() -->
						<!-- ,modalidadCobro:comboDDModalidadCobro.getValue() -->
					}
                    ,method: 'POST'
                    ,success : function(result, request){ page.fireEvent(app.event.DONE) }
                    
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
	
 	<pfs:defineParameters name="pcontratos" paramId=""
		idProcedimiento="comboProcedimientos"
	/>
	
	<pfsforms:remotecombo 
		name="comboContratos" 
		dataFlow="plugin.liquidaciones.contratosData" 
		labelKey="plugin.liquidaciones.cobropago.control.comboContratos" 
		displayField="codigo" 
		root="contratos" 
		label="**Contratos" 
		value="${liqCobroPago.contrato.id}" 
		valueField="id"
		width="550"
		parameters="pcontratos"/> 
	 comboContratos.labelStyle = labelStyle;
	
	 var enableDisableContratos = function(){ 
		<!-- if (comboDDSubtipoCobroPago.getValue() == 'EC'){ -->
			<!-- comboContratos.enable(); -->
		<!-- }else{ -->
			<!-- comboContratos.disable(); -->
		<!-- } -->
		
		 if(comboContratos.getValue() != ''){
			 comboContratos.reload(false);
			 comboContratos.enable();
		 }
	 };
	 
	
	<!-- comboDDSubtipoCobroPago.on('select',function(){ -->
		<!-- enableDisableContratos(); -->
	<!-- }); -->
 	 comboProcedimientos.on('select',function (){comboContratos.reload()});
	
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
			{ items : [ id,comboProcedimientos,comboContratos,importePago,fechaEntrega,fechaValor,comboDDAdjContableTipoEntrega,comboDDAdjContableConceptoEntrega,capital,capitalNoVencido,nominal,interesesOrdinarios,interesesMoratorios,impuestos,gastosProcurador,gastosAbogado,otrosGastos,totalGastos,gastos,totalEntrega], style : 'margin-right:10px' }
			]
		}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});
	
	<%-- if(${liqCobroPago.subTipo!=null}){
		var setSubTipoValue = function (){
			comboDDSubtipoCobroPago.setValue("${liqCobroPago.subTipo.codigo}");
			comboDDSubtipoCobroPago.enable();
		}
		optionsDDSubtipoCobroPagoStore.on('load',setSubTipoValue);
		optionsDDSubtipoCobroPagoStore.webflow({tipo:'${liqCobroPago.subTipo.tipoCobroPago.codigo}'});	
	} --%>
	
<!-- 	g_combo = comboDDSubtipoCobroPago;
 -->	g_panel = panelEdicion;	
	
	 enableDisableContratos();
	page.add(panelEdicion);
</fwk:page>

