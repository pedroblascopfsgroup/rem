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
		<c:if test="${codigoTipoEntrega!=null}" >
			,value:'${codigoTipoEntrega}'
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
		<c:if test="${codigoConceptoEntrega!=null}" >
			,value:'${codigoConceptoEntrega}'
		</c:if>
	});
	console.log('${conceptoEntrega}');

	var fechaEntrega = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="entregas.fecha" text="**Fecha Cobro" />'
		,name:'liqCobroPago.fecha'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,allowBlank: false
		,value: '<fwk:date value="${fechaCobro}" />'
	});
	
	var fechaValor = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="entregas.fechaValor" text="**Fecha Valor" />'
		,name:'liqCobroPago.fechaValor'
		,style:'margin:0px'
		,labelStyle:labelStyle
		,allowBlank: false
		,value: '<fwk:date value="${fechaValor}" />'
	});
	

	
 	var gastosProcurador  = app.creaNumber('liqCobroPago.gastosProcurador',
		'<s:message code="entregas.gastosProcurador" text="**Gastos Procurador" />',
		'${gastosProcurados}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${gastosProcurados!=null}" >
			,value:'${gastosProcurados}'
			</c:if>
			,listeners : {
				change : function(){
				}
			}
		}
	);
	
	var gastosAbogado  = app.creaNumber('liqCobroPago.gastosAbogado',
		'<s:message code="entregas.gastosAbogado" text="**Gastos Abogado" />',
		'${gastosLetrado}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${gastosLetrado!=null}" >
			,value:'${gastosLetrado}'
			</c:if>
			,listeners : {
				change : function(){
				}
			}
		}
	);
	
	var otrosGastos  = app.creaNumber('liqCobroPago.gastosOtros',
		'<s:message code="entregas.otrosGastos" text="**Otros Gastos" />',
		'${otrosGastos}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${otrosGastos!=null}" >
			,value:'${otrosGastos}'
			</c:if>
			,listeners : {
				change : function(){
				}
			}
		}
	);

	
	
 	var totalEntrega  = app.creaNumber('liqCobroPago.importe',
		'<s:message code="entregas.totalEntrega" text="**Total Entrega" />',
		'${totalEntrega}',
		{
			labelStyle:labelStyle
			,style:style
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			<c:if test="${totalEntrega!=null}" >
			,value:'${totalEntrega}'
			</c:if>
		}
	);
	
	
	
	var validarParametrosObligatorios= function(){
	
		if(fechaEntrega.getValue() != null && fechaEntrega.getValue() != "" && fechaValor.getValue()!= null && fechaValor.getValue()!= ""){
			return true;
		}
		else{
			Ext.MessageBox.alert('Error', 'Falta un parámetro obligatorio');
			return false;
		}
	};
	
	var validarSumaCamposNumericos= function(){
		
		if(gastosProcurador.getValue() + gastosAbogado.getValue() + totalEntrega.getValue() > 0){
			return true;
		}
		else{
			Ext.MessageBox.alert('Error', 'Al menos un campo debe estar informado con una cantidad positiva');
			return false;
		}
	};
	
	var validarFechas= function(){
		fc= '${fechaCierre}'.split(' ');
		fl= '${fechaLiquidacion}'.split(' ');
	   	dtfechaCierre = Date.parseDate(fc[0], "Y-m-d");
	   	dtfechaLiquidacion = Date.parseDate(fl[0], "Y-m-d");
	   	
	   	if(fechaValor.getValue().between(dtfechaCierre,dtfechaLiquidacion)){
	   	
	   		return true;
	   	}
	   	else{
			Ext.MessageBox.alert('Error', 'La fecha Valor debe estar entre la Fecha de Cierre y Fecha Liquidación');
			return false;
		}
		
	};

	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		if(validarParametrosObligatorios() && validarSumaCamposNumericos() && validarFechas()){
			Ext.Ajax.request({
               		url: page.resolveUrl('entregas/saveEntrega')
               		,params: {
               			idCalculo: '${idCalculo}'
               			,id: '${idEntrega}'
						,tipoEntrega: comboDDAdjContableTipoEntrega.getValue()
						,conceptoEntrega: comboDDAdjContableConceptoEntrega.getValue()
						,fechaEntrega: fechaEntrega.getRawValue()
						,fechaValor: fechaValor.getRawValue()
						,gastosProcurador: gastosProcurador.getValue()
						,gastosAbogado: gastosAbogado.getValue()
						,otrosGastos: otrosGastos.getValue()
						,totalEntrega: totalEntrega.getValue()
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
			{ items : [ id,fechaEntrega,fechaValor,comboDDAdjContableTipoEntrega,comboDDAdjContableConceptoEntrega,gastosProcurador,gastosAbogado,otrosGastos,totalEntrega], style : 'margin-right:10px' }
			]
		}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});
	
	g_panel = panelEdicion;	
	
	page.add(panelEdicion);
</fwk:page>

