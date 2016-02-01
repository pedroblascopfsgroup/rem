<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'
	
	var excedido =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.excedido" text="**Excedido" />'
		,value : '${resultado.excedido}'
		,labelStyle:labelStyle
	});
	
	var fechaImpago =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.fechaImpago" text="**Fecha Impago" />'
		,value : '${resultado.fechaImpago}'
		,labelStyle:labelStyle
	});
	
	var numCuenta =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.numCuenta" text="**Nº Cuenta" />'
		,value : '${resultado.numCuenta}'
		,labelStyle:labelStyle
	});
	
	var oficina =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.codigoOficina" text="**Código Oficina" />'
		,value : '${resultado.oficina}'
		,labelStyle:labelStyle
	});
	
	var riesgoGlobal =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.riesgoGlobal" text="**Riesgo Global" />'
		,value : '${resultado.riesgoGlobal}'
		,labelStyle:labelStyle
	});
	
	var saldoAct =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.saldoAct" text="**Saldo Actual" />'
		,value : '${resultado.saldoAct}'
		,labelStyle:labelStyle
	});
	
	var saldoGastos =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.saldoGastos" text="**Saldo Gastos" />'
		,value : '${resultado.saldoGastos}'
		,labelStyle:labelStyle
	});
	
	var saldoRetenido =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.saldoRetenido" text="**Saldo Retenido" />'
		,value : '${resultado.saldoRetenido}'
		,labelStyle:labelStyle
	});
	
	var capitalVencido =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.capitalVencido" text="**Capital Vencido" />'
		,value : '${resultado.capitalVencido}'
		,labelStyle:labelStyle
	});
	
	var capitalNoVencido =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.capitalNoVencido" text="**Capital No Vencido" />'
		,value : '${resultado.capitalNoVencido}'
		,labelStyle:labelStyle
	});
	
	var demoraRecibos =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.demoraRecibos" text="**Demora Recibos" />'
		,value : '${resultado.demoraRecibos}'
		,labelStyle:labelStyle
	});
	
	var demoras =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.demoras" text="**Demoras" />'
		,value : '${resultado.demoras}'
		,labelStyle:labelStyle
	});
	
	var impagado =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.impagado" text="**Impagado" />'
		,value : '${resultado.impagado}'
		,labelStyle:labelStyle
	});
	
	var intereses =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.intereses" text="**Intereses" />'
		,value : '${resultado.intereses}'
		,labelStyle:labelStyle
	});
	
	var disponible =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.disponible" text="**Disponible" />'
		,value : '${resultado.disponible}'
		,labelStyle:labelStyle
	});
	
	var interesesRecibos =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.interesesRecibos" text="**Intereses Recibos" />'
		,value : '${resultado.interesesRecibos}'
		,labelStyle:labelStyle
	});
	
	var movimientos3M =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.movimientos3M" text="**Movimientos 3M" />'
		,value : '${resultado.movimientos3M}'
		,labelStyle:labelStyle
	});
	
	var saldoMedio12M =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.saldoMedio12M" text="**SaldoMedio 12M" />'
		,value : '${resultado.saldoMedio12M}'
		,labelStyle:labelStyle
	});
	
	var saldoMedio3M =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.saldoMedio3M" text="**SaldoMedio 3M" />'
		,value : '${resultado.saldoMedio3M}'
		,labelStyle:labelStyle
	});
	
	var comisionDevolucion =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.comisionDevolucion" text="**Comision Devolucion" />'
		,value : '${resultado.comisionDevolucion}'
		,labelStyle:labelStyle
	});
	
	var dispuesto =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.dispuesto" text="**Dispuesto" />'
		,value : '${resultado.dispuesto}'
		,labelStyle:labelStyle
	});
	
	var fechaMora =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.fechaMora" text="**Fecha Mora" />'
		,value : '${resultado.fechaMora}'
		,labelStyle:labelStyle
	});
	
	var financiado =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.financiado" text="**Financiado" />'
		,value : '${resultado.financiado}'
		,labelStyle:labelStyle
	});
	
	var importeLimite =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.importeLimite" text="**Importe límite" />'
		,value : '${resultado.importeLimite}'
		,labelStyle:labelStyle
	});
	
	var iva =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.iva" text="**IVA" />'
		,value : '${resultado.iva}'
		,labelStyle:labelStyle
	});
	
	var capitalDispuesto =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.capitalDispuesto" text="**Capital Dispuesto" />'
		,value : '${resultado.capitalDispuesto}'
		,labelStyle:labelStyle
	});
	
	var capitalRecibosOpen =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.capitalRecibosOpen" text="**Capital RecibosOpen" />'
		,value : '${resultado.capitalRecibosOpen}'
		,labelStyle:labelStyle
	});
	
	var carencia =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.carencia" text="**Carencia" />'
		,value : '${resultado.carencia}'
		,labelStyle:labelStyle
	});
	
	var demoraRecibosOpen =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.demoraRecibosOpen" text="**Demora RecibosOpen" />'
		,value : '${resultado.demoraRecibosOpen}'
		,labelStyle:labelStyle
	});
	
	var interesesRecibosOpen =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.interesesRecibosOpen" text="**Intereses RecibosOpen" />'
		,value : '${resultado.interesesRecibosOpen}'
		,labelStyle:labelStyle
	});
	
	var ivaRecibosOpen =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.ivaRecibosOpen" text="**IVA RecibosOpen" />'
		,value : '${resultado.ivaRecibosOpen}'
		,labelStyle:labelStyle
	});
	
	var importePol =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.importePol" text="**Importe Pol" />'
		,value : '${resultado.importePol}'
		,labelStyle:labelStyle
	});
	
	var mensajeWSVacio =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="plugin.cajamar.contrato.consultaSaldo.mensajeWS" text="**Aviso" />'
		,value : ''
		,labelStyle:labelStyle 
		,rawvalue : '<s:message code="plugin.cajamar.contrato.consultaSaldo.mensajeWSVacio" text="**Esta funcionalidad no est&aacute; disponible para este tipo de contrato"/>'
	});
	
	<c:set var="codigoAplicativo" value="${resultado.aplicativo.codigo}"/>
	<c:choose>
  		<c:when test="${codigoAplicativo eq 'RF'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct, riesgoGlobal,saldoGastos, dispuesto, intereses, capitalVencido];
		</c:when>
		<c:when test="${codigoAplicativo eq 'TJ'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct,saldoGastos, intereses, demoras];
		</c:when>
		<c:when test="${codigoAplicativo eq 'LS'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct,capitalVencido, intereses, demoras,
    					capitalNoVencido, carencia, riesgoGlobal, dispuesto, iva, saldoGastos];
		</c:when>
		<c:when test="${codigoAplicativo eq 'FT'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct, excedido, disponible, riesgoGlobal, 
    					saldoGastos, dispuesto, comisionDevolucion, iva, demoras, fechaMora, intereses];
		</c:when>
		<c:when test="${codigoAplicativo eq 'DC'}">
    		camposMostrar=[oficina, importePol, fechaImpago ,saldoAct, riesgoGlobal, saldoGastos, 
    					capitalNoVencido, capitalVencido, intereses, demoras];
		</c:when>
		<c:when test="${codigoAplicativo eq 'CR'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct, excedido, disponible, 
    					riesgoGlobal, saldoGastos, intereses, demoras, capitalVencido];
		</c:when>
		<c:when test="${codigoAplicativo eq 'CF'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct, riesgoGlobal, saldoGastos, 
    					capitalNoVencido, capitalVencido, impagado, intereses, demoras];
		</c:when>
		<c:when test="${codigoAplicativo eq 'AV'}">
    		camposMostrar=[oficina, fechaImpago ,saldoAct, excedido, riesgoGlobal, saldoRetenido, saldoGastos];
		</c:when>
		<c:when test="${codigoAplicativo eq 'CE'}">
    		camposMostrar=[oficina, saldoAct ,riesgoGlobal, capitalNoVencido, capitalVencido, intereses, demoras, saldoGastos];
		</c:when>
   		<c:otherwise>
   			camposMostrar=[mensajeWSVacio];
    	</c:otherwise>
 </c:choose>	
	
	debugger;
	
	var btnCerrar= new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls:'icon_ok'
		,handler : function(){
			page.fireEvent(app.event.DONE);
		}
	});

		var panelEdicion = new Ext.form.FormPanel({
			autoHeight : true
			,autoWidth : true
			,bodyStyle:'padding:10px; cellspacing:10px;'
			,border : true
			,items : [
				 { xtype : 'errorList', id:'errL' }
				,{
					autoHeight:true
					,layout:'table'
					,layoutConfig:{columns:1}
					,border:false
					,bodyStyle:'padding:0px;cellspacing:50px;'
					,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375,style:'padding:10px; margin:10px'} 
					,items:[{
							layout:'form'
							,bodyStyle:'padding:5px;cellspacing:10px'
							,items:[camposMostrar]
							,columnWidth:.20
						}
					]
				}
			]
			,bbar : [
				btnCerrar
			]
		});
	

	page.add(panelEdicion);

</fwk:page>
