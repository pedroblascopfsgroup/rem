<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>


(function(page,entidad){

 var cntId;
 var labelStyle = 'width:100px;font-weight:bolder;margin-bottom:5px",width:375';

 function label(id,text){
    return app.creaLabel(text,"",  {id:'entidad-contrato-'+id, labelStyle:labelStyle});
  }
  
 var mensajeExceptuacionLabel = new Ext.form.Label({
	   	text:'<s:message code="grupo.contratoExceptuado" text="**Este contrato está exceptuado de recobro" />'
		,style:'font-weight:bold;font-size:13px;color:red;',id:'entidad-contrato-mensajeLabel'
	});
	
 mensajeExceptuacionLabel.setVisible(false); 

 var nombrePrimerTitular = '';
 <c:if test="${contrato.primerTitular != null}">
  nombrePrimerTitular = "${contrato.primerTitular.apellidoNombre}";
 </c:if>
 
 // DATOS PRINCIPALES
 var estadoContrato = label('estadoContrato','<s:message code="contrato.consulta.tabcabecera.estado" text="**Estado"/>');
 var estadoContratoEntidad = label('estadoContratoEntidad','<s:message code="contrato.consulta.tabcabecera.estadoEntidad" text="**Estado Contrato Entidad"/>');
 var codigoContrato = label('codigoContrato','<s:message code="contrato.consulta.tabcabecera.contrato" text="**Contrato"/>');
 var tipoProducto = label('tipoProducto','<s:message code="contrato.consulta.tabcabecera.tipoProducto" text="**Tipo Producto"/>');
 var tipoProductoComercial = label('tipoProductoComercial','<s:message code="contrato.consulta.tabcabecera.tipoProductoComercial" text="**Tipo Producto Comercial"/>');
 var primerTitular = label('primerTitular', '<s:message code="contrato.consulta.tabcabecera.primerTitular" text="**1er Titular"/>');
 var fechaEstadoContrato = label('fechaEstadoContrato','<s:message code="contrato.consulta.tabcabecera.fechaEstado" text="**Fecha último cambio de estado"/>');
 var fechaDato = label('fechaDato', '<s:message code="contrato.consulta.tabcabecera.fechaDato" text="**Fecha Dato"/>');
 var finalidadContrato = label('finalidadContrato', '<s:message code="contrato.consulta.tabcabecera.finalidadContrato" text="**finalidadContrato"/>');
 var finalidadAcuerdo = label('finalidadAcuerdo','<s:message code="contrato.consulta.tabcabecera.finalidadAcuerdo" text="**finalidadAcuerdo"/>');
 var segmentoCartera = label('segmentoCartera','<s:message code="contrato.consulta.tabcabecera.segmentoCartera" text="**Segmento cartera"/>');
 var fechaCreacion  = label('fechaCreacion','<s:message code="contrato.consulta.tabcabecera.fechaCreación" text="**fecha de Apertura"/>');

 var entidadPropietaria  = label('entidadPropietaria','<s:message code="contrato.consulta.tabcabecera.entidadPropietaria" text="**Entidad"/>');
 var condEspec  = label('condEspec','<s:message code="contrato.consulta.tabcabecera.condEspec" text="**Id. Condiciones Especiales"/>');
 var ofiConta  = label('ofiConta','<s:message code="contrato.consulta.tabcabecera.ofiContable" text="**Oficina Contable"/>');
 var ofiAdmin  = label('ofiAdmin','<s:message code="contrato.consulta.tabcabecera.ofiAdmin" text="**Oficina Administrativa"/>');
 var gestionEspecial  = label('gestionEspecial','<s:message code="contrato.consulta.tabcabecera.gestionEspecial" text="**Gestión Externa"/>');
 
 var apliOrigen  = label('apliOrigen','<s:message code="contrato.consulta.tabcabecera.apliOrigen" text="**Aplicativo Origen"/>');
 var iban  = label('iban','<s:message code="contrato.consulta.tabcabecera.iban" text="**IBAN"/>');
 var cccDomiciliacion  = label('cccDomiciliacion','<s:message code="contrato.consulta.tabcabecera.cuenta.asociada" text="**Cuenta asociada"/>');
 var contratoParaguas  = label('contratoParaguas','<s:message code="contrato.consulta.tabcabecera.contratoParaguas" text="**Contrato Paraguas"/>');
 var remunEsp  = label('remunEsp','<s:message code="contrato.consulta.tabcabecera.remunEsp" text="**Remuneración Gestión Esp."/>');


 primerTitular.autoHeight = true;
 estadoContrato.autoHeight = true;
 estadoContratoEntidad.autoHeight = true;
 codigoContrato.autoHeight = true;
 tipoProducto.autoHeight = true;
 tipoProductoComercial.autoHeight = true; 
 fechaEstadoContrato.autoHeight = true;
 fechaDato.autoHeight = true;
 finalidadContrato.autoHeight = true;
 finalidadAcuerdo.autoHeight = true;
 segmentoCartera.autoHeight = true;
 fechaCreacion.autoHeight = true;
 entidadPropietaria.autoHeight = true;
 condEspec.autoHeight = true;
 ofiConta.autoHeight = true;
 ofiAdmin.autoHeight = true;
 gestionEspecial.autoHeight = true;
 apliOrigen.autoHeight = true;
 iban.autoHeight = true;
 cccDomiciliacion.autoHeight = true
 contratoParaguas.autoHeight = true;
 remunEsp.autoHeight = true;

 
 //DATOS FINANCIEROS
 	var moneda= label('moneda','<s:message code="contrato.consulta.tabcabecera.moneda" text="**Moneda"/>');

	var posVivaNoVencida = label('posVivaNoVencida','<s:message code="contrato.consulta.tabcabecera.pvnv" text="**Capital dispuesto no vencido"/>');

	var posVivaVencida  = label('posVivaVencida','<s:message code="contrato.consulta.tabcabecera.pvv" text="**Capital dispuesto vencido"/>');

	var fechaInicioPVV  = label('fechaInicioPVV','<s:message code="contrato.consulta.tabcabecera.fechaInicioPVV" text="**Fecha Inicio Pos. Viva Vencida"/>');

	var saldoDudoso   = label('saldoDudoso','<s:message code="contrato.consulta.tabcabecera.saldoDudoso" text="**Saldo Dudoso"/>');

	var estadoFinanciero = label('estadoFinanciero','<s:message code="contrato.consulta.tabcabecera.estadoFinanciero" text="**Estado Financiero"/>');

	var estadoFinAnterior = label('estadoFinAnterior','<s:message code="contrato.consulta.tabcabecera.estadoFinancieroAnterior" text="**Estado Financiero Anterior"/>');

	var riesgo    = label('riesgo','<s:message code="contrato.consulta.tabcabecera.riesgo" text="**Riesgo"/>');

	var dispuesto   = label('dispuesto','<s:message code="contrato.consulta.tabcabecera.dispuesto" text="**dispuesto"/>');

	var saldoPasivo   = label('saldoPasivo','<s:message code="contrato.consulta.tabcabecera.saldoPasivo" text="**saldoPasivo"/>');

	var limiteInicial  = label('limiteInicial','<s:message code="contrato.consulta.tabcabecera.limiteInicial" text="**limiteInicial"/>');

	var limiteFinal   = label('limiteFinal','<s:message code="contrato.consulta.tabcabecera.limiteFinal" text="**limiteFinal"/>');

	var riesgoGarantizado = label('riesgoGarantizado','<s:message code="contrato.consulta.tabcabecera.riesgoGarantizado" text="**riesgoGarantizado"/>');

	var saldoExcedido  = label('saldoExcedido','<s:message code="contrato.consulta.tabcabecera.saldoExcedido" text="**saldoExcedido"/>');

	var ltvInicial   = label('ltvInicial','<s:message code="contrato.consulta.tabcabecera.ltvInicial" text="**ltvInicial"/>');

	var ltvFinal   = label('ltvFinal','<s:message code="contrato.consulta.tabcabecera.ltvFinal" text="**ltvFinal"/>');

	var limiteDescubierto = label('limiteDescubierto','<s:message code="contrato.consulta.tabcabecera.limiteDescubierto" text="**limiteDescubierto"/>');

	var garantia1   = label('garantia1','<s:message code="contrato.consulta.tabcabecera.garantia1" text="**garantia1"/>');

	var garantia2   = label('garantia2','<s:message code="contrato.consulta.tabcabecera.garantia2" text="**garantia2"/>');

	var fechaVencimiento = label('fechaVencimiento','<s:message code="contrato.consulta.tabcabecera.fechaVencimiento" text="**fechaVencimiento"/>');

	var provision   = label('provision','<s:message code="contrato.consulta.tabcabecera.provision" text="**Provision"/>');
	var movIntRemun   = label('movIntRemun','<s:message code="contrato.consulta.tabcabecera.interesesRemun" text="**Int. Ordinarios Devengados"/>');
	var movIntMoratorios = label('movIntMoratorios','<s:message code="contrato.consulta.tabcabecera.interesesMoratorios" text="**Int. Moratorios Devengados"/>');
	var comisiones   = label('comisiones','<s:message code="contrato.consulta.tabcabecera.comisiones" text="**Comisiones"/>');
	var gastos    = label('gastos','<s:message code="contrato.consulta.tabcabecera.gastos" text="**Gastos"/>');
	var fechaIniEpiIrregular    = label('fechaIniEpiIrregular','<s:message code="contrato.consulta.tabcabecera.fecIniEpiIrregular" text="**Fecha ini. Episodio Irregular"/>');
	var fechaVencimiento = label('fechaVencimiento','<s:message code="contrato.consulta.tabcabecera.fechaVencimiento" text="**fechaVencimiento"/>');
	var entregasCuenta    = label('entregasCuenta','<s:message code="contrato.consulta.tabcabecera.entregasCuenta" text="**Entregas a Cuenta"/>');
	var interesesEntregasCuenta    = label('interesesEntregasCuenta','<s:message code="contrato.consulta.tabcabecera.interesesEntregasCuenta" text="**Intereses Entregas a Cuenta"/>');
	var pendienteDesembolso    = label('pendienteDesembolso','<s:message code="contrato.consulta.tabcabecera.pendienteDesembolso" text="**Pendiente Desembolso"/>');
	var sistemaAmort    = label('sistemaAmort','<s:message code="contrato.consulta.tabcabecera.sistemaAmort" text="**Sistema Amortización"/>');
	var tipoInteres    = label('tipoInteres','<s:message code="contrato.consulta.tabcabecera.tipoInteres" text="**Tipo de Interés"/>');
 	var importeCuota    = label('importeCuota','<s:message code="contrato.consulta.tabcabecera.importeCuota" text="**Importe Cuota"/>');
 	var periodicidadCuota    = label('periodicidadCuota','<s:message code="contrato.consulta.tabcabecera.periodicidadCuota" text="**Periodicidad Cuota"/>');
 	var numCuotasVencidas    = label('numCuotasVencidas','<s:message code="contrato.consulta.tabcabecera.numCuotasVencidas" text="**Núm Cuotas Vencidas Impagadas"/>');
 	var interesFijoVariable    = label('interesFijoVariable','<s:message code="contrato.consulta.tabcabecera.interesFijoVariable" text="**Interés Fijo Variable"/>');
 	var deudaExigible = label('deudaExigible','<s:message code="contrato.consulta.tabcabecera.deudaExigible" text="**Deuda exigible"/>');
 	var deudaIrregular = label('deudaIrregular','<s:message code="contrato.consulta.tabcabecera.deudaIrregular" text="**Deuda Irregular"/>');
 	
 	var impuestos = label('impuestos','<s:message code="contrato.consulta.tabcabecera.impuestos" text="**Impuestos"/>');
 	var provisionPorcentaje = label('provisionPorcentaje','<s:message code="contrato.consulta.tabcabecera.provisionPorcentaje" text="**% Provisión"/>');
 	
 	
 
 //OTROS DATOS
	var extra1    = label('extra1','<s:message code="contrato.consulta.tabcabecera.extra1" text="**Saldo muy dudoso"/>');
	var extra2    = label('extra2','<s:message code="contrato.consulta.tabcabecera.extra2" text="**Extra2"/>');
	var extra3    = label('extra3','<s:message code="contrato.consulta.tabcabecera.extra3" text="**Extra3"/>');
	var extra4    = label('extra4','<s:message code="contrato.consulta.tabcabecera.extra4" text="**Extra4"/>');
	var extra5    = label('extra5','<s:message code="contrato.consulta.tabcabecera.extra5" text="**Extra5"/>');
	var extra6    = label('extra6','<s:message code="contrato.consulta.tabcabecera.extra6" text="**Extra6"/>');

	//BANKIA ampliacion campos extra
	
	var numextra1    = label('numextra1','<s:message code="contrato.consulta.tabcabecera.numextra1" text="**NumExtra1"/>');
	var numextra2    = label('numextra2','<s:message code="contrato.consulta.tabcabecera.numextra2" text="**NumExtra2"/>');
	var numextra3    = label('numextra3','<s:message code="contrato.consulta.tabcabecera.numextra3" text="**NumExtra3"/>');
	
	var dateextra1    = label('dateextra1','<s:message code="contrato.consulta.tabcabecera.dateextra1" text="**DateExtra1"/>');
	
	var charextra1    = label('charextra1','<s:message code="contrato.consulta.tabcabecera.charextra1" text="**Charextra1"/>');
	var charextra2    = label('charextra2','<s:message code="contrato.consulta.tabcabecera.charextra2" text="**Charextra2"/>');
	var charextra3    = label('charextra3','<s:message code="contrato.consulta.tabcabecera.charextra3" text="**Charextra3"/>');
	// var charextra4    = label('charextra4','<s:message code="contrato.consulta.tabcabecera.charextra4" text="**Charextra4"/>');
	var charextra5    = label('charextra5','<s:message code="contrato.consulta.tabcabecera.charextra5" text="**Charextra5"/>');
	var charextra6    = label('charextra6','<s:message code="contrato.consulta.tabcabecera.charextra6" text="**Charextra6"/>');
	var charextra7    = label('charextra7','<s:message code="contrato.consulta.tabcabecera.charextra7" text="**Charextra7"/>');
	var charextra8    = label('charextra8','<s:message code="contrato.consulta.tabcabecera.charextra8" text="**Charextra8"/>');
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">	
	charextra8 = label('charextra8','<s:message code="contrato.consulta.tabOtrosDatos.charExtra8" text="**Número de contrato en formato CCC"/>');
</sec:authorize>	
	var flagextra1    = label('flagextra1','<s:message code="contrato.consulta.tabcabecera.flagextra1" text="**Flagextra1"/>');
	var flagextra2    = label('flagextra2','<s:message code="contrato.consulta.tabcabecera.flagextra2" text="**Flagextra2"/>');
	var flagextra3    = label('flagextra3','<s:message code="contrato.consulta.tabcabecera.flagextra3" text="**Flagextra3"/>');
 
 	var domiciExt    = label('domiciExt','<s:message code="contrato.consulta.tabcabecera.domiciExt" text="**Domiciliación Externa"/>');
	var domiciExtFecha = label('domiciExtFecha','<s:message code="contrato.consulta.tabcabecera.domiciExtFecha" text="**Fecha recibo devuelto más antiguo"/>');
	var domiciExtTotal = label('domiciExtTotal','<s:message code="contrato.consulta.tabcabecera.domiciExtTotal" text="**Total recibos domi. externa"/>');
	var contratoAnt = label('contratoAnt','<s:message code="contrato.consulta.tabcabecera.contratoAnt" text="**N&ordm; contrato anterior"/>');
	var motivoRenum = label('motivoRenum','<s:message code="contrato.consulta.tabcabecera.motivoRenum" text="**Motivo Renumeración"/>');
 
 	var marca = label('marca','<s:message code="contrato.consulta.tabcabecera.marca" text="**Marca de la operación"/>');
 	var motivoMarca = label('motivoMarca','<s:message code="contrato.consulta.tabcabecera.motivoMarca" text="**Motivo de la marca"/>');
 	var indicador = label('indicador','<s:message code="contrato.consulta.tabcabecera.indicador" text="**Indicador de nómina/pensión"/>');
 	var contadorReincidencia = label('contadorReincidencia','<s:message code="contrato.consulta.tabcabecera.contadorReincidencia" text="**Contador de reincidencia"/>');
 	

   var datosPrincipalesFieldSet = new Ext.form.FieldSet({
   autoHeight:true
   ,width:770
   ,style:'padding:0px'
   ,border:true
   ,layout : 'table'
   ,border : true
   ,layoutConfig:{
    columns:2
   }
   ,title:'<s:message code="contrato.consulta.tabcabecera.datosPrincipales" text="**Datos Principales"/>'
   ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375, style:'padding:10px'}
      ,items : [{items:[estadoContrato,estadoContratoEntidad,codigoContrato,entidadPropietaria,tipoProducto,tipoProductoComercial,condEspec,ofiConta,ofiAdmin,contratoParaguas]},
       {items:[fechaEstadoContrato,fechaDato,fechaCreacion,fechaVencimiento,apliOrigen,iban,cccDomiciliacion,finalidadAcuerdo,segmentoCartera]}
      ]
  });
  
  //voy a añadir el boton de consultar saldo
  	
  /* boton para consultar saldo*/
		var btnConsultarSaldo = new Ext.Button({
		    text: '<s:message code="plugin.cajamar.contrato.consultaSaldo.btnConsultarSaldo" text="**Actualizar" />'
			<app:test id="btnConsultarSaldo" addComa="true" />
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
         	,handler:function(){
         		var w = app.openWindow({
					flow : 'serviciosonlinecajamar/consultaDeSaldos'
					//,width:1400
					,height:900
					,title : '<s:message code="plugin.cajamar.contrato.consultaSaldo.tituloVentana" text="**Consulta Saldo" />'
					,params : {cntId : cntId}
				});
				w.on(app.event.DONE, function(){
					w.close();
			    });
			}
		});
  
  //-----------------------------------------
  
   var datosFinancierosFieldSet = new Ext.form.FieldSet({
   autoHeight:true
   ,width:770
   ,style:'padding:0px'
   ,border:true
   ,layout : 'table'
   ,border : true
   ,defaults : {style: 'padding:200px'}
   ,layoutConfig:{
    columns:2
   }
   ,title:'<s:message code="contrato.consulta.tabcabecera.datosFinancieros" text="**Datos Financieros"/>'
   ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375,style:'padding:10px; margin:10px'}
      ,items : [{items:[moneda, posVivaNoVencida, posVivaVencida, dispuesto, limiteDescubierto, saldoPasivo,limiteInicial,limiteFinal,saldoExcedido,deudaExigible,deudaIrregular,ltvInicial,ltvFinal,riesgoGarantizado<sec:authorize ifNotGranted="OCULTAR_DATOS_CONTRATO">, saldoDudoso,extra1,provision,provisionPorcentaje</sec:authorize>]},
       {items:[entregasCuenta,interesesEntregasCuenta,pendienteDesembolso,sistemaAmort,tipoInteres,interesFijoVariable,importeCuota,periodicidadCuota,numCuotasVencidas,fechaInicioPVV,estadoFinanciero,estadoFinAnterior,garantia1,garantia2]}
      ]
      ,bbar : [
			btnConsultarSaldo
		]
  });
 
 

   var gastosIntComFieldSet = new Ext.form.FieldSet({
   autoHeight:true
   ,width:770
   ,style:'padding:0px'
   ,border:true
   ,layout : 'table'
   ,border : true
   ,layoutConfig:{
    columns:2
   }
   ,title:'<s:message code="contrato.consulta.tabcabecera.gastosIntCom" text="**Gastos Intereses Comisiones"/>'
   ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375, style:'padding:10px; margin:10px'}
      ,items : [{items:[movIntRemun,movIntMoratorios]},
       {items:[comisiones,impuestos,gastos]}
      ]
  });


   var otrosDatosFieldSet = new Ext.form.FieldSet({
	   autoHeight:true
	   ,width:770
	   ,style:'padding:0px'
	   ,border:true
	   ,layout : 'table'
	   ,border : true
	   ,layoutConfig:{columns:2}
	   ,title:'<s:message code="contrato.consulta.tabcabecera.otrosDatos" text="**Otros Datos"/>'
	   ,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375, style:'padding:10px; margin:10px'}
		  ,items : [{items:[domiciExt,domiciExtFecha,fechaIniEpiIrregular,gestionEspecial,remunEsp
		  ,numextra1,numextra2,numextra3
		  ,dateextra1
		  ,flagextra1,flagextra2,flagextra3,indicador]},
		   {items:[domiciExtTotal,contratoAnt,motivoRenum,riesgo
		   ,charextra1,charextra2,charextra3,
			   //charextra4,
		   charextra5,charextra6,charextra7,charextra8,marca,motivoMarca,contadorReincidencia]}
		  ]
	  });
  
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		title : '<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll : true
		,bodyStyle : 'padding:5px;margin:5px'
		,autoHeight : true
		,autoWidth : true
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items:[ mensajeExceptuacionLabel,datosPrincipalesFieldSet, datosFinancierosFieldSet,gastosIntComFieldSet,otrosDatosFieldSet]
		,nombreTab : 'cabecera'
	});
  
/*  var panel=new Ext.Panel({
   title:'<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
   ,autoScroll:true
   ,width:775
   ,autoHeight:true
   //,autoWidth : true
   ,layout:'table'
   ,bodyStyle:'padding:5px;margin:5px'
   ,border : false
      ,layoutConfig: {
   columns: 1
      }
   ,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
   ,items:[ datosPrincipalesFieldSet,datosFinancierosFieldSet,gastosIntComFieldSet,otrosDatosFieldSet]
   ,nombreTab : 'cabecera'
  });
*/  

 panel.getValue = function() {
 }

 panel.setValue = function() {
 
  var data=entidad.get("data");
  var d=data.cabecera;
  var contratoExceptuado=d.contratoExceptuado;
  cntId=data.id;
  //alert("el valor de cntId dentro de setValue es: "+cntId);
  if (contratoExceptuado){
  	mensajeExceptuacionLabel.setVisible(true);
  } else {
  	mensajeExceptuacionLabel.setVisible(false);
  }
  
  if(d.condEspec!=null)
  {  
	  var cond=0;
	  try{cond=parseInt(d.condEspec,10);}catch(e){}
	  if (cond > 0)
	  {
		  var TabPanel = Ext.getCmp('contenido');
		  if (TabPanel!=null)
		  {
			  	var p = TabPanel.getItem('contrato-'+data.id);
			  	if (p!=null){
			  		try{p.setTitle(d.codigoContrato + '-' + d.condEspec);}catch(e){}
		  		}
		  	}	
	  }
  }

  entidad.setLabel('codigoContrato',d.codigoContrato);
  entidad.setLabel('tipoProducto',d.tipoProducto);
  entidad.setLabel('tipoProductoComercial',d.tipoProductoComercial);  
  entidad.setLabel('primerTitular',d.primerTitular);
  entidad.setLabel('fechaEstadoContrato',d.fechaEstadoContrato);
  entidad.setLabel('estadoContrato',d.estadoContrato);
  entidad.setLabel('estadoContratoEntidad',d.estadoContratoEntidad);
  entidad.setLabel('fechaDato',d.fechaDato);
  entidad.setLabel('finalidadContrato',d.finalidadContrato);
  entidad.setLabel('finalidadAcuerdo',d.finalidadAcuerdo);
  entidad.setLabel('segmentoCartera',d.segmentoCartera);
  entidad.setLabel('fechaCreacion',d.fechaCreacion);
  entidad.setLabel('moneda',d.moneda);
  entidad.setLabel('posVivaNoVencida',app.format.moneyRenderer(''+d.posVivaNoVencida));
  entidad.setLabel('posVivaVencida',app.format.moneyRenderer(''+d.posVivaVencida));
  entidad.setLabel('fechaInicioPVV',d.fechaInicioPVV);
  entidad.setLabel('saldoDudoso',(''+d.saldoDudoso=='') ? '' : app.format.moneyRenderer(''+d.saldoDudoso) + ((''+d.fechaSaldoDudoso=='') ? '' : " (" +  d.fechaSaldoDudoso +")"));
  entidad.setLabel('estadoFinanciero',d.estadoFinanciero);
  entidad.setLabel('estadoFinAnterior',d.estadoFinAnterior);
  entidad.setLabel('riesgo',app.format.moneyRenderer(''+d.riesgo));
  entidad.setLabel('dispuesto',app.format.moneyRenderer(''+d.dispuesto)); //money
  entidad.setLabel('saldoPasivo',app.format.moneyRenderer(''+d.saldoPasivo)); 
  entidad.setLabel('limiteInicial',app.format.moneyRenderer(''+d.limiteInicial)); //money
  entidad.setLabel('limiteFinal',app.format.moneyRenderer(''+d.limiteFinal)); //money
  entidad.setLabel('riesgoGarantizado',app.format.moneyRenderer(''+d.riesgoGarantizado)); //money
  entidad.setLabel('saldoExcedido',app.format.moneyRenderer(''+d.saldoExcedido)); //money
  entidad.setLabel('ltvInicial',d.ltvInicial); 
  entidad.setLabel('ltvFinal',d.ltvFinal); 
  entidad.setLabel('garantia1',d.garantia1); 
  entidad.setLabel('garantia2',d.garantia2); 
  entidad.setLabel('fechaVencimiento',d.fechaVencimiento); 
  entidad.setLabel('provision',app.format.moneyRenderer(''+d.provision)); //money
  entidad.setLabel('movIntRemun',app.format.moneyRenderer(''+d.movIntRemun)); //money
  entidad.setLabel('movIntMoratorios',app.format.moneyRenderer(''+d.movIntMoratorios)); //money
  entidad.setLabel('comisiones',app.format.moneyRenderer(''+d.comisiones)); //money
  entidad.setLabel('gastos',app.format.moneyRenderer(''+d.gastos)); //money
  entidad.setLabel('extra1',app.format.moneyRenderer(''+d.extra1)); 
  entidad.setLabel('extra2',d.extra2); 
  entidad.setLabel('extra3',d.extra3); 
  entidad.setLabel('extra4',d.extra4); 
  entidad.setLabel('extra5',d.extra5); 
  entidad.setLabel('extra6',d.extra6); 
  
  entidad.setLabel('numextra1',d.numextra1);
  entidad.setLabel('numextra2',d.numextra2);
  entidad.setLabel('numextra3',d.numextra3);
  entidad.setLabel('dateextra1',d.dateextra1);
  entidad.setLabel('charextra1',d.charextra1);
  entidad.setLabel('charextra2',d.charextra2);
  entidad.setLabel('charextra3',d.charextra3);
  //entidad.setLabel('charextra4',d.charextra4);
  entidad.setLabel('charextra5',d.charextra5);
  entidad.setLabel('charextra6',d.charextra6);
  entidad.setLabel('charextra7',d.charextra7);
  entidad.setLabel('charextra8',d.charextra8);
	
  entidad.setLabel('flagextra1',d.flagextra1);	
  entidad.setLabel('flagextra2',d.flagextra2);	
  entidad.setLabel('flagextra3',d.flagextra3);
  
  entidad.setLabel('limiteDescubierto',app.format.moneyRenderer(''+d.limiteDescubierto)); //money
  entidad.setLabel('provisionPorcentaje',d.provisionPorcentaje+' %'); 
  entidad.setLabel('impuestos',app.format.moneyRenderer(''+d.impuestos)); 

  entidad.setLabel('domiciExt',d.domiciExt); 
  entidad.setLabel('domiciExtFecha',d.domiciExtFecha); 
  entidad.setLabel('domiciExtTotal',d.domiciExtTotal); 
  entidad.setLabel('contratoAnt',d.contratoAnt); 
  entidad.setLabel('motivoRenum',d.motivoRenum); 
  
  
  entidad.setLabel('entidadPropietaria',d.entidadPropietaria);
  entidad.setLabel('condEspec',d.condEspec);
  entidad.setLabel('ofiConta',d.ofiConta);
  entidad.setLabel('ofiAdmin',d.ofiAdmin);
  entidad.setLabel('gestionEspecial',d.gestionEspecial);
  
  entidad.setLabel('apliOrigen',d.apliOrigen);
  entidad.setLabel('iban',d.iban);
  entidad.setLabel('cccDomiciliacion',d.cccDomiciliacion);
  entidad.setLabel('contratoParaguas',d.contratoParaguas);
  entidad.setLabel('remunEsp',d.remunEsp);
  
  entidad.setLabel('fechaIniEpiIrregular',d.fechaIniEpiIrregular);
  entidad.setLabel('entregasCuenta',d.entregasCuenta);
  entidad.setLabel('interesesEntregasCuenta',d.interesEntregasCuenta);
  entidad.setLabel('pendienteDesembolso',d.pendienteDesembolso);
  entidad.setLabel('sistemaAmort',d.sistemaAmort);
  entidad.setLabel('tipoInteres',(''+d.tipoInteres=='') ? '' : d.tipoInteres+' %'); 
  entidad.setLabel('importeCuota',app.format.moneyRenderer(''+d.importeCuota));
  entidad.setLabel('periodicidadCuota',(''+d.periodicidadCuota=='') ? '' : d.periodicidadCuota+' <s:message code="app.meses" text="**meses"/>'); 
  entidad.setLabel('numCuotasVencidas',d.numCuotasVencidas);
  entidad.setLabel('interesFijoVariable',d.interesFijoVariable);
  entidad.setLabel('deudaExigible',app.format.moneyRenderer(''+d.deudaExigible));
  entidad.setLabel('deudaIrregular',app.format.moneyRenderer(''+d.deudaIrregular));
  entidad.setLabel('marca', d.marca);
  entidad.setLabel('motivoMarca', d.motivoMarca);
  entidad.setLabel('indicador', d.indicador);
  entidad.setLabel('contadorReincidencia',d.contadorReincidencia);
 }
  <c:choose>
  		<c:when test="${usuario.entidad.id eq appProperties.idEntidadCajamar}">
    		btnConsultarSaldo.setVisible(true);
		</c:when>    
   		<c:otherwise>
   			btnConsultarSaldo.setVisible(false);
    	</c:otherwise>
 </c:choose>	
  return panel;
})
