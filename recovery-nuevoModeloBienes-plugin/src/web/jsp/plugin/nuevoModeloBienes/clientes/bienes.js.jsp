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

	var listaTabs = new Array();
	var msgError = '';
	
	var bloquearCampos = 0;
	
	var idPersona = '';
	//DATOS LOCALIZACION
	var poblacion_valor = '';
	var provincia_valor = '';
	var codPostal_valor = '';
	var tipoVia_valor			= '';
	var nombreVia_valor			= '';
	var numeroDomicilio_valor	= '';
	var portal_valor			= '';
	var bloque_valor			= '';
	var escalera_valor			= '';
	var piso_valor				= '';
	var puerta_valor			= '';
	var barrio_valor			= '';
	var pais_valor				= '';
	var localidad_valor			= '';
	var unidadPoblacional_valor = '';
	
	var numFinca_valor = '';
	var referenciaCatastralBien_valor = '';
	var tomo_valor = '';
	var libro_valor = '';
	var folio_valor = '';
	var inscripcion_valor = '';
	var numRegistro_valor = '';
	var municipoLibro_valor = '';
	var municipioRegistro_valor = '';
	var provinciaRegistro_valor = '';
	var codigoRegistro_valor = '';
	var superficieConstruida_valor = '';
	var superficie_valor = '';
	var importeValorSubjetivo_valor = '';
	var importeValorApreciacion_valor = '';
	var importeValorTasacion_valor = '';
	
	var nomEmpresa_valor = '';
	var cifEmpresa_valor = '';
	
	var epigrafeIAE_valor = '';
	var descripcionIAE_valor = '';
	
	var entidad_valor = '';
	var nCuenta_valor  ='';
	var nCuenta_entidad_valor = '';
	var nCuenta_oficina_valor = '';
	var nCuenta_dc_valor = '';
	var nCuenta_cuenta_valor = '';
	
	var marca_valor = '';
	var modelo_valor = '';
	var matricula_valor = '';
	//var fechaMatriculacion_valor = '';
	var nBastidor_valor = '';
		
	var importeValorProdBancario_valor = '';
	var participacion_valor = "${NMBbien.participacion}" || "100";
	
	
	var situacionPosesoria = '${NMBbien.situacionPosesoria.descripcion}';
	var viviendaHabitual = '${NMBbien.viviendaHabitual}';
	var tipoSubasta = '${NMBbien.tipoSubasta}';
	var numeroActivo  = '${NMBbien.numeroActivo}';
	var licenciaPrimeraOcupacion = '${NMBbien.licenciaPrimeraOcupacion}';
	var primeraTransmision  = '${NMBbien.primeraTransmision}';
	var contratoAlquiler = '${NMBbien.contratoAlquiler}';
	var transmitentePromotor = '${NMBbien.transmitentePromotor}';
	var arrendadoSinOpcCompra = '${NMBbien.arrendadoSinOpcCompra}';
	var usoPromotorMayorDosAnyos = '${NMBbien.usoPromotorMayorDosAnyos}';
	var tributacion = '${NMBbien.tributacion.descripcion}';
	var fechaSolicitudDue = '${NMBbien.fechaSolicitudDueD}';
	var fechaRecepcionDue = '${NMBbien.fechaDueD}';
	var porcentajeImpuestoCompra_valor = '${NMBbien.porcentajeImpuestoCompra}';
	var impuestoCompra = '${NMBbien.impuestoCompra.codigo}';
	var tributacionVenta = '${NMBbien.tributacionVenta.descripcion}';
	var imposicionCompra = '${NMBbien.tipoImposicionCompra.descripcion}';
	var imposicionVenta = '${NMBbien.tipoImposicionVenta.descripcion}';
	var inversionRenuncia = '${NMBbien.inversionPorRenuncia.descripcion}';
	
	var fechaMinima = new Date(1900,0,1);
	
	<c:if test="${NMBbien.datosRegistralesActivo!=null}">
		referenciaCatastralBien_valor = '${NMBbien.datosRegistralesActivo.referenciaCatastralBien}';
		tomo_valor = '${NMBbien.datosRegistralesActivo.tomo}';
		libro_valor = '${NMBbien.datosRegistralesActivo.libro}';
		folio_valor = '${NMBbien.datosRegistralesActivo.folio}';
		inscripcion_valor = '${NMBbien.datosRegistralesActivo.inscripcion}';
		numFinca_valor = '${NMBbien.datosRegistralesActivo.numFinca}';
		numRegistro_valor = '${NMBbien.datosRegistralesActivo.numRegistro}';
		municipoLibro_valor = '<s:message javaScriptEscape="true" text="${NMBbien.datosRegistralesActivo.municipoLibro}" />';
		municipioRegistro_valor = '${NMBbien.datosRegistralesActivo.localidad.codigo}';
		provinciaRegistro_valor = '${NMBbien.datosRegistralesActivo.provincia.codigo}';
		codigoRegistro_valor = '${NMBbien.datosRegistralesActivo.codigoRegistro}';
		superficieConstruida_valor = '${NMBbien.datosRegistralesActivo.superficieConstruida}';
		superficie_valor = '${NMBbien.datosRegistralesActivo.superficie}';   
	</c:if>	
	<c:if test="${NMBbien.valoracionActiva!=null}">
		//fechaValorSubjetivo_valor = '${NMBbien.valoracionActiva.fechaValorSubjetivo}';
		importeValorSubjetivo_valor = '${NMBbien.valoracionActiva.importeValorSubjetivo}';
		//fechaValorApreciacion_valor = '${NMBbien.valoracionActiva.fechaValorApreciacion}';
		importeValorApreciacion_valor = '${NMBbien.valoracionActiva.importeValorApreciacion}';
		//fechaValorTasacion_valor = '${NMBbien.valoracionActiva.fechaValorTasacion}';
		importeValorTasacion_valor = '${NMBbien.valoracionActiva.importeValorTasacion}';
		
		valorTasacionExterna = '${NMBbien.valoracionActiva.valorTasacionExterna}';
    	fechaTasacionExterna = '${NMBbien.valoracionActiva.fechaTasacionExterna}';
    	tasadora             = '${NMBbien.valoracionActiva.tasadora.descripcion}';
    	fechaSolicitudTasacion = '${NMBbien.valoracionActiva.fechaSolicitudTasacion}';
		respuestaConsulta  = '${NMBbien.valoracionActiva.respuestaConsulta}';
	</c:if>	
	<c:if test="${NMBbien.localizacionActual!=null}">
		poblacion_valor = '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.poblacion}" />';
		codPostal_valor = '${NMBbien.localizacionActual.codPostal}';
		provincia_valor = '${NMBbien.localizacionActual.provincia.codigo}';
		tipoVia_valor 			= '${NMBbien.localizacionActual.tipoVia.codigo}';
		nombreVia_valor 		= '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.nombreVia}" />';
		numeroDomicilio_valor 	= '${NMBbien.localizacionActual.numeroDomicilio}';
		portal_valor 			= '${NMBbien.localizacionActual.portal}';
		bloque_valor 			= '${NMBbien.localizacionActual.bloque}';
		escalera_valor 			= '${NMBbien.localizacionActual.escalera}';
		piso_valor 				= '${NMBbien.localizacionActual.piso}';
		puerta_valor 			= '${NMBbien.localizacionActual.puerta}';
		barrio_valor 			= '${NMBbien.localizacionActual.barrio}';
		pais_valor 				= '${NMBbien.localizacionActual.pais.codigo}';
		localidad_valor			= '${NMBbien.localizacionActual.localidad.codigo}';
		unidadPoblacional_valor	= '${NMBbien.localizacionActual.unidadPoblacional.codigo}';
	</c:if>
	<c:if test="${NMBbien.adicional!=null}">
		
		nomEmpresa_valor = '${NMBbien.adicional.nomEmpresa}';
		cifEmpresa_valor = '${NMBbien.adicional.cifEmpresa}';
		
		epigrafeIAE_valor = '${NMBbien.adicional.codIAE}';
		descripcionIAE_valor = '${NMBbien.adicional.desIAE}';
		
		entidad_valor = '${NMBbien.adicional.entidad}';
		nCuenta_valor = '${NMBbien.adicional.numCuenta}';
		if (nCuenta_valor.length==20) {
			nCuenta_entidad_valor = nCuenta_valor.substring(0,4);
			nCuenta_oficina_valor = nCuenta_valor.substring(4,8);
			nCuenta_dc_valor = nCuenta_valor.substring(8,10);
			nCuenta_cuenta_valor = nCuenta_valor.substring(10);
		}		
		
		marca_valor = '${NMBbien.adicional.marca}';
		modelo_valor = '${NMBbien.adicional.modelo}';
		matricula_valor = '${NMBbien.adicional.matricula}';
		nBastidor_valor = '${NMBbien.adicional.bastidor}';
			
		importeValorProdBancario_valor = '${NMBbien.adicional.valoracion}';
	</c:if>
		
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		if ('${NMBbien.origen.id}' == '2') {
			/* AUTOMATICO */
			/*
			CPI - 14/11/2015
			Se permite modificar bienes automaticos por tener la pestaï¿½a datos_entidad
			bloquearCampos = 1;
			*/			 
			bloquearCampos = 2; 
			origen = 'Automatico';
		} else {
			/* MANUAL */
			bloquearCampos = 2;
			origen = 'Manual';
		} 

		/* PRINCIPAL */ 
		idPersona = '${idPersona}';
		var origenCarga = app.creaText('bien.origen.descripcion', '<s:message code="plugin.mejoras.bienesNMB.origenCarga" text="**Tipo de carga" />' , origen, {maxLength:50,labelStyle : labelStyle});
		origenCarga.disable();
		var tipoNMB = app.creaCombo({
			data : <app:dict value="${tiposBien}" />
			<app:test id="tipoBienCombo" addComa="true" />
			,name : 'bien.tipoBien'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.tipo" text="**Tipo" />'
			,value : '${NMBbien.tipoBien.codigo}'
			,labelStyle: labelStyle
			,width:180
			<c:if test="${operacion == 'editar'}">,disabled: true</c:if>
			,listeners: {
 	 			select: function(combo,  record,  index ) {
 	 				resetCampos(); 	 				
 	 				muestraTabs(record.data.codigo);
 	 			}
 	 		}
		});
		
		var tipoBienUbicado = function(tipoBienSel, tabPanel) {
			var ubicado = false;

			for(var i=0;i < listaTabs.length;i++) {
				if (listaTabs[i].tipoBien == tipoBienSel)  {
					ubicado=true;
					for(var x=0;x < tabPanel.items.items.length; x++) {
						var tmpTab = tabPanel.items.items[x];
						if ((listaTabs[i].tabs.indexOf(tmpTab)) != -1) {
							tabPanel.unhideTabStripItem(tmpTab);
						} else {
							tabPanel.hideTabStripItem(tmpTab);
						}
					}
					break;
				}				
			}	
			
			return ubicado;
		}
		
		var resetCampos = function() {
			poblacion.setValue('');
			descripcion.setValue('');
			part.setValue('');
			valor.setValue('');
			cargas.setValue('');
			fechaVerif.setValue('');
			
			
			refCatastral.setValue('');
			superficie.setValue('');
			datosRegistrales.setValue('');
			<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
				solvenciaNoEncontradaNMB.setValue('');
			</sec:authorize>
			obraEnCurso.setValue('');
			NMBparticipacion.setValue(100);
			valorNMB.setValue('');
			cargasNMB.setValue('');
			dueDilligence.setValue('');
			
			fechaVerifNMB.setValue('');
			descripcionNMB.setValue('');
			
			poblacionNMB.setValue('');
			provincia.setValue('');
			codPostal.setValue('');
			direccion.setValue('');
			
			comboVia.setValue('');
			nombreVia.setValue('');
			numeroDomicilio.setValue('');
			portal.setValue('');
			bloque.setValue('');
			escalera.setValue('');
			piso.setValue('');
			puerta.setValue('');
			barrio.setValue('');
			comboPais.setValue('');

			observaciones.setValue('');
			
			referenciaCatastral.setValue('');
			tomo.setValue('');
			libro.setValue('');
			folio.setValue('');
			inscripcion.setValue('');
			fechaInscripcion.setValue('');
			
			numRegistro.setValue('');
			numFinca.setValue('');
			comboProvinciaRegistro.setValue('');
			municipoLibro.setValue('');
			codigoRegistro.setValue('');
			superficieConstruida.setValue('');
			superficieNMB.setValue('');
			
			fechaValorSubjetivo.setValue('');
			
			importeValorSubjetivo.setValue('');
			fechaValorApreciacion.setValue('');
			
			importeValorApreciacion.setValue('');
			fechaValorTasacion.setValue('');
			
			importeValorTasacion.setValue('');
			
			nombreEmpresa.setValue('');
		    cifEmpresa.setValue('');
		    epigrafeIAE.setValue('');
		    descripcionIAE.setValue('');
		    tiposFinancieros.setValue('');
		   	tipoInmueble.setValue('');
		   	importeValorProdBancario.setValue('');
		   	entidad.setValue('');
		   	nCuenta_entidad.setValue('');
		   	nCuenta_oficina.setValue('');
		   	nCuenta_dc.setValue('');
		   	nCuenta_cuenta.setValue('');
		   	
		   	matricula.setValue('');
		   	nBastidor.setValue('');
		   	modelo.setValue('');
		   	marca.setValue('');
		   	fechaMatriculacion.setValue('');
		   	
		   	situacionPosesoria.setValue('');
			viviendaHabitual.setValue('');
			tipoSubasta.setValue('');
			numeroActivo.setValue('');
			licenciaPrimeraOcupacion.setValue('');
			primeraTransmision.setValue('');
			contratoAlquiler.setValue('');
			transmitentePromotor.setValue('');
			arrendadoSinOpcCompra.setValue('');
			usoPromotorMayorDosAnyos.setValue('');
			tributacion.setValue('');
			porcentajeImpuestoCompra.setValue('');
			impuestoCompra.setValue('');
			tributacionVenta.setValue('');
			imposicionCompra.setValue('');
			imposicionVenta.setValue('');
			inversionRenuncia.setValue('');
			
			fechaSolicitudDue.setValue('');
			fechaRecepcionDue.setValue('');
			valorTasacionExterna.setValue('');
    		fechaTasacionExterna.setValue('');
    		tasadora.setValue('');
    		fechaSolicitudTasacion.setValue('');
			respuestaConsulta.setValue('');
		   	
		}
		
		var muestraTabs = function(tipoBienSel) {
			var tabPanel = Ext.getCmp('idTabPanel');
			if (!tipoBienUbicado(tipoBienSel, tabPanel)) {
				if (!tipoBienUbicado('DEFECTO', tabPanel)) 	{
					tabPanel.unhideTabStripItem(pestanaValoraciones);
					tabPanel.unhideTabStripItem(pestanaDatosRegistrales);
					tabPanel.unhideTabStripItem(pestanaLocalizacion);
					tabPanel.hideTabStripItem(pestanaEmpresa);
					tabPanel.hideTabStripItem(pestanaIAE);
					tabPanel.hideTabStripItem(pestanaCuentaBancaria);
					tabPanel.hideTabStripItem(pestanaVehiculo);
					tabPanel.hideTabStripItem(pestanaProductosBanco);
					tabPanel.unhideTabStripItem(pestanaObservaciones);
				}	
			}
		}
	
		
		var descripcionNMB = new Ext.form.TextArea({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.descripcion" text="**Descripcion" />'
			,value:'<s:message javaScriptEscape="true" text="${NMBbien.descripcionBien}" />'
			,name:'descripcion'
			,width:240		
			,height:150
			,labelStyle:labelStyleTextArea
		});
		
		var observaciones = new Ext.form.TextArea({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.observaciones" text="**observaciones" />'
			,value:'<s:message javaScriptEscape="true" text="${NMBbien.observaciones}" />'
			,name:'observaciones'
			,width:240		
			,height:150
			,maxLength:2000
			,labelStyle:labelStyleTextArea
		});
		
		var valorNMB = app.creaNumber(
			'bien.valorActual'
			, '<s:message code="bienesCliente.valorActual" text="**Valor actual" />' 
			, '${NMBbien.valorActual}'
			, {
				autoCreate : {
					tag: "input"
					, type: "text"
					,maxLength:"14"
					, autocomplete: "off"
				}
				, maxLength:14
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 14 digitos" arguments="14" />'
				,labelStyle : labelStyle
			}
		);
		var cargasNMB = app.creaNumber(
			'bien.importeCargas'
			, '<s:message code="bienesCliente.cargas" text="**Cargas" />' 
			, '${NMBbien.importeCargas}'
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"8"
					, autocomplete: "off"
				}
				, maxLength:8
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 8 digitos" arguments="8" />'
				,labelStyle : labelStyle
			}
		);
		
		var solvenciaNoEncontradaNMB =  new Ext.form.Checkbox({
			//id:'solvenciaNoEncontrada'
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.solvenciaNoEncontrada" text="**Solvencia no encontrada"/>'
			,labelStyle : labelStyle
			,name:'solvenciaNoEncontrada'
			,style:'margin:0px'		
		
		});
		
		var obraEnCurso =  new Ext.form.Checkbox({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.obraEnCurso" text="**Obra en curso"/>'
			,labelStyle : labelStyle
			,name:'obraEnCurso'
			,style:'margin:0px'		
		
		});
		
		if('${NMBbien.solvenciaNoEncontrada}' == 'true'){
			solvenciaNoEncontradaNMB.checked = true;
		}
		else{
			solvenciaNoEncontradaNMB.checked = false;
		}
		
		if('${NMBbien.obraEnCurso}' == 'true'){
			obraEnCurso.checked = true;
		}
		else{
			obraEnCurso.checked = false;
		}
		
		var dueDilligence =  new Ext.form.Checkbox({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dueDilligence" text="**dueDilligence"/>'
			,labelStyle : labelStyle
			,name:'dueDilligence'
			,style:'margin:0px'		
		
		});
		
		if('${NMBbien.dueDilligence}' == 'true'){
			dueDilligence.checked = true;
		}
		else{
			dueDilligence.checked = false;
		}
		
		var situacionPosesoria = app.creaCombo({
			data : <app:dict value="${situacionPosesoria}" />
			<app:test id="situacionPosesoriaCombo" addComa="true" />
			,name : 'situacionPosesoria'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.situacionPosesoria" text="**situacionPosesoria" />'
			,value : '${NMBbien.situacionPosesoria.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var tributacion = app.creaCombo({
			data : <app:dict value="${tributacion}" />
			<app:test id="tributacionCombo" addComa="true" />
			,name : 'bien.tributacion'
			<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.tributacionCompra" text="**tributacionCompra" />'
			</sec:authorize>
			<sec:authorize ifNotGranted="PUEDE_VER_TRIBUTACION">
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.tributacion" text="**tributacion" />'
			</sec:authorize>
			,value : '${NMBbien.tributacion.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var tributacionVenta = app.creaCombo({
			data : <app:dict value="${tributacion}" />
			<app:test id="tributacionVentaCombo" addComa="true" />
			,name : 'bien.tributacionVenta'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.tributacionVenta" text="**tributacionVenta" />'
			,value : '${NMBbien.tributacionVenta.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var imposicionCompra = app.creaCombo({
			data : <app:dict value="${imposicion}" />
			<app:test id="imposicionCompraCombo" addComa="true" />
			,name : 'bien.imposicionCompra'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.imposicionCompra" text="**imposicionCompra" />'
			,value : '${NMBbien.tipoImposicionCompra.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var imposicionVenta = app.creaCombo({
			data : <app:dict value="${imposicionVenta}" />
			<app:test id="imposicionVentaCombo" addComa="true" />
			,name : 'bien.imposicionVenta'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.imposicionVenta" text="**imposicionVenta" />'
			,value : '${NMBbien.tipoImposicionVenta.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var inversionRenuncia = app.creaCombo({
			data : <app:dict value="${sino}" />
			<app:test id="inversionRenunciaCombo" addComa="true" />
			,name : 'bien.inversionRenuncia'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.inversionRenuncia" text="**inversionRenuncia" />'
			,value : '${NMBbien.inversionPorRenuncia.codigo}'
			,labelStyle: labelStyle
			,width: 150
			
		});
		
		var impuestoCompra = app.creaCombo({
			data : <app:dict value="${impuestoCompra}" />
			<app:test id="impuestoCompraCombo" addComa="true" />
			,name : 'impuestoCompra'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.impuestoCompra" text="**impuestoCompra" />'
			,value : impuestoCompra
			,valueField:'codigo'
			,labelStyle: labelStyle
			,width: 150
		});
		
		var porcentajeImpuestoCompra = app.creaNumber(
			'porcentajeImpuestoCompra'
			, '<s:message code="plugin.nuevoModeloBienes.porcentajeImpuestoCompra" text="**Porcentaje de impuesto de compra"  />' 
			, porcentajeImpuestoCompra_valor
			, {
				autoCreate : {
					tag: "input"
					,type: "text"
					,maxLength:"5"
					,autocomplete: "off"
				}
				, maxLength:5
				, maxLengthText:'<s:message code="plugin.nuevoModeloBienes.error.porcentajeImpuestoCompra" text="**El valor no puede tener mas de 5 digitos" />'
				,labelStyle: labelStyle
			}
		);
		
		porcentajeImpuestoCompra.setMaxValue(100);
		
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
		
		var viviendaHabitual = app.creaCombo({
			store:sinoStore
			,value:  '${NMBbien.viviendaHabitual}' == '1' ? 'Si' : '${NMBbien.viviendaHabitual}' == '2' ? 'No' : ''
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,width: 100
			,resizable: false
			,emptyText:'--'
			,triggerAction: 'all'
			,name:'viviendaHabitual'
			,fieldLabel: '<s:message code="plugin.mejoras.bienesNMB.viviendaHabitual" text="**viviendaHabitual"/>'
			,labelStyle:labelStyle
		});
						
		var tipoSubasta = app.creaNumber(
			'tipoSubasta'
			, '<s:message code="plugin.mejoras.bienesNMB.tipoSubasta" text="**Tipo Subasta" />' 
			,tipoSubasta
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle: labelStyle
			}
		);
		
		var hoy = new Date();

		var fechaVerifNMB=new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesCliente.fechaverificacion" text="**Fecha VErificacion" />'
			,labelStyle : labelStyle
			,name:'bien.fechaVerificacion'
			,value:	'<fwk:date value="${NMBbien.fechaVerificacion}" />'
			,maxValue: hoy
			,style:'margin:0px'	
			,minValue: fechaMinima		
		});
		
		
		var numeroActivo = app.creaText('numeroActivo', '<s:message code="plugin.mejoras.bienesNMB.numeroActivo" text="**numeroActivo" />' , numeroActivo, {maxLength:50,labelStyle:labelStyle,disabled: true});
		var licenciaPrimeraOcupacion = app.creaText('licenciaPrimeraOcupacion', '<s:message code="plugin.mejoras.bienesNMB.licenciaPrimeraOcupacion" text="**licenciaPrimeraOcupacion" />' , licenciaPrimeraOcupacion, {maxLength:50,labelStyle:labelStyle});
		var primeraTransmision = app.creaText('primeraTransmision', '<s:message code="plugin.mejoras.bienesNMB.primeraTransmision" text="**primeraTransmision" />' , primeraTransmision, {maxLength:50,labelStyle:labelStyle});
		var contratoAlquiler = app.creaText('contratoAlquiler', '<s:message code="plugin.mejoras.bienesNMB.contratoAlquiler" text="**contratoAlquiler" />' , contratoAlquiler, {maxLength:50,labelStyle:labelStyle});
		var transmitentePromotor = app.creaText('transmitentePromotor', '<s:message code="plugin.mejoras.bienesNMB.transmitentePromotor" text="**transmitentePromotor" />' , transmitentePromotor, {maxLength:50,labelStyle:labelStyle});
		var arrendadoSinOpcCompra = app.creaText('arrendadoSinOpcCompra', '<s:message code="plugin.mejoras.bienesNMB.arrendadoSinOpcCompra" text="**arrendadoSinOpcCompra" />' , arrendadoSinOpcCompra, {maxLength:50,labelStyle:labelStyle});
		var usoPromotorMayorDosAnyos = app.creaText('usoPromotorMayorDosAnyos', '<s:message code="plugin.mejoras.bienesNMB.usoPromotorMayorDosAnyos" text="**usoPromotorMayorDosAnyos" />' , usoPromotorMayorDosAnyos, {maxLength:50,labelStyle:labelStyle});



		/* DATOS LOCALIZACION */

		 var localidades = Ext.data.Record.create([
			{name:'id'}
			,{name:'codigo'}
			,{name:'descripcion'}
			,{name:'descripcionLarga'}
		]);
		
		 var uPoblacionales = Ext.data.Record.create([
			{name:'id'}
			,{name:'codigo'}
			,{name:'descripcion'}
			,{name:'descripcionLarga'}
		]);
	
		var optionsLocalidadesStore = page.getStore({
		       flow: 'editbien/getListLocalidades'
		       ,reader: new Ext.data.JsonReader({
		    	 root : 'localidades'	 		
		    }, localidades)	       
		});
		
		optionsLocalidadesStore.on('load', function() {
	 	 				// Cargar localidad
 	 				
 	 				if(!Ext.isEmpty(localidad_valor)) {	 	 					
 	 					comboLocalidad.setValue(localidad_valor);
 	 					comboLocalidad.fireEvent("select");				
 	 					localidad_valor = '';
 	 				}
						
	 	});
		
		var optionsUnidadesPoblacionalesStore = page.getStore({
		       flow: 'editbien/getListUnidadesPoblacionales'
		       ,reader: new Ext.data.JsonReader({
		    	 root : 'unidades'
		    }, uPoblacionales)	       
		});
		
		optionsUnidadesPoblacionalesStore.on('load', function() {
	 	 	// Cargar unidad poblacional
 	 		
			if(!Ext.isEmpty(unidadPoblacional_valor)) {	 	 					
				comboUnidadPoblacional.setValue(unidadPoblacional_valor);
				unidadPoblacional_valor = '';
			}

						
	 	});
	 	
	 	var optionsMunicipioRegistroStore = page.getStore({
		       flow: 'editbien/getListLocalidades'
		       ,reader: new Ext.data.JsonReader({
		    	 root : 'localidades'	 		
		    }, localidades)	       
		});
		
		optionsMunicipioRegistroStore.on('load', function() {
	 	 				// Cargar municipio
 	 				
 	 				if(!Ext.isEmpty(municipioRegistro_valor)) {	 	 					
 	 					comboMunicipioRegistro.setValue(municipioRegistro_valor);
 	 					comboMunicipioRegistro.fireEvent("select");				
 	 					municipioRegistro_valor = '';
 	 				}
						
	 	});
	 	
	 	

		var provincia = app.creaCombo({
			data : <app:dict value="${provincias}" />
			<app:test id="provinciaCombo" addComa="true" />
			,name : 'bien.provincia'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.provincia" text="**Provincia" />'
			,value : provincia_valor
			,valueField:'codigo'
			,emptyText:'-- Seleccione provincia --'
			,labelStyle:labelStyle
			,width:180
			,listeners: {
 	 			select: function() {
 	 				// Cargar localidades
 	 				
					comboLocalidad.reset();
					comboUnidadPoblacional.reset();
					comboLocalidad.setDisabled(false);
					optionsUnidadesPoblacionalesStore.removeAll();
					optionsLocalidadesStore.removeAll();
					optionsLocalidadesStore.webflow({'codProvincia': provincia.getValue()});
					
 	 			}, 	 			
 	 			afterrender: function(combo) {
 	 			
 	 				if(!Ext.isEmpty(provincia_valor)) {
 	 					combo.fireEvent("select");
 	 							
 	 				}
 	 			
 	 			}
 	 		}
		});

		var comboLocalidad = app.creaCombo({
			store:optionsLocalidadesStore
			,value: localidad_valor
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'remote'
			,resizable: true
			,width: 180
			,forceSelection: true
			,disabled: true
			,editable: false
			,emptyText:'-- Seleccione localidad --'
			,triggerAction: 'all'
			,fieldLabel: '<s:message code="plugin.nuevoModeloBienes.localidad" text="**Localidad" />'
			,labelStyle:labelStyle
			,listeners: {
 	 			select: function() {
 	 				//En version actual, Localidad no vincula Unidad Poblacional. Es para seleccionar de la lista por un usuario.
 	 				
					comboUnidadPoblacional.reset();
					comboUnidadPoblacional.setDisabled(false);
					optionsUnidadesPoblacionalesStore.removeAll();
					optionsUnidadesPoblacionalesStore.webflow({'codLocalidad': comboLocalidad.getValue()});
					
 	 			}
 	 		}
		});
		
		var comboUnidadPoblacional = app.creaCombo({
			store:optionsUnidadesPoblacionalesStore
			,value: unidadPoblacional_valor
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'remote'
			,width: 180
			,resizable: true
			,forceSelection: true
			,disabled: true
			,editable: false
			,emptyText:'-- Seleccione unidad poblacional --'
			,triggerAction: 'all'
			,fieldLabel: '<s:message code="plugin.nuevoModeloBienes.unidadPoblacional" text="**Unidad Poblacional" />'
			,labelStyle:labelStyle
		});
		
		var comboPais = app.creaCombo({
			data : <app:dict value="${paises}" />
			<app:test id="paisCombo" addComa="true" />
			,value: pais_valor
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'remote'
			,width: 180
			,resizable: true
			,forceSelection: true
			,editable: false
			,emptyText:'-- Seleccione pais --'
			,triggerAction: 'all'
			,fieldLabel: '<s:message code="plugin.nuevoModeloBienes.pais" text="**Pais" />'
			,labelStyle:labelStyle
		});
		
		var comboVia = app.creaCombo({
			data : <app:dict value="${vias}" />
			<app:test id="viasCombo" addComa="true" />
			,value: tipoVia_valor
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'remote'
			,width: 180
			,resizable: true
			,forceSelection: true
			,editable: false
			,emptyText:'-- Seleccione Tipo de via --'
			,triggerAction: 'all'
			,fieldLabel: '<s:message code="plugin.nuevoModeloBienes.tipoVia" text="**Tipo via" />'
			,labelStyle:labelStyle
		});

		var poblacionNMB = app.creaText('poblacion', '<s:message code="plugin.nuevoModeloBienes.poblacion" text="**Localidad (migrado)" />', poblacion_valor, {maxLength:50,labelStyle:labelStyle,disabled: true});
		var codPostal = app.creaText('codPostal', '<s:message code="plugin.nuevoModeloBienes.codPostal" text="**Codigo Postal" />' , codPostal_valor, {maxLength:50,labelStyle:labelStyle});

		var direccion = new Ext.form.TextArea({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.direccion" text="**Direccion" />'
			,value:'<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.direccion}" />'
			,name:'direccion'
			,width:240
			,labelStyle:labelStyleTextArea
		});
		
		var tipoVia = app.creaText('tipoVia', '<s:message code="plugin.nuevoModeloBienes.tipoVia" text="**Tipo Via" />' , tipoVia_valor, {maxLength:50,labelStyle:labelStyle});
		var nombreVia = app.creaText('nombreVia', '<s:message code="plugin.nuevoModeloBienes.nombreVia" text="**Nombre Via" />' , nombreVia_valor, {maxLength:50,labelStyle:labelStyle});
		var numeroDomicilio = app.creaText('numeroDomicilio', '<s:message code="plugin.nuevoModeloBienes.numeroDomicilio" text="**Num. Domicilio" />' , numeroDomicilio_valor, {maxLength:50,labelStyle:labelStyle});
		var portal = app.creaText('portal', '<s:message code="plugin.nuevoModeloBienes.portal" text="**Portal" />' , portal_valor, {maxLength:50,labelStyle:labelStyle});
		var bloque = app.creaText('bloque', '<s:message code="plugin.nuevoModeloBienes.bloque" text="**Bloque" />' , bloque_valor, {maxLength:50,labelStyle:labelStyle});
		var escalera = app.creaText('escalera', '<s:message code="plugin.nuevoModeloBienes.escalera" text="**Escalera" />' , escalera_valor, {maxLength:50,labelStyle:labelStyle});
		var piso = app.creaText('piso', '<s:message code="plugin.nuevoModeloBienes.piso" text="**Piso" />' , piso_valor, {maxLength:50,labelStyle:labelStyle});
		var puerta = app.creaText('puerta', '<s:message code="plugin.nuevoModeloBienes.puerta" text="**Puerta" />' , puerta_valor, {maxLength:50,labelStyle:labelStyle});
		var barrio = app.creaText('barrio', '<s:message code="plugin.nuevoModeloBienes.barrio" text="**Barrio" />' , barrio_valor, {maxLength:50,labelStyle:labelStyle});
		var pais = app.creaText('pais', '<s:message code="plugin.nuevoModeloBienes.pais" text="**Pais" />' , pais_valor, {maxLength:50,labelStyle:labelStyle});
				
		
		/* DATOS REGISTRALES */ 
		var tipoInmueble = app.creaCombo({
			data : <app:dict value="${tiposInmueble}" />
			<app:test id="tipoInmuebleCombo" addComa="true" />
			,name : 'bien.tipoInmueble'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.tipoInmueble" text="**Tipo Inmueble" />'
			,value : '${NMBbien.adicional.tipoInmueble.codigo}'
			,labelStyle: labelStyle
			,width:180
		});
		var referenciaCatastral = app.creaText('referenciaCatastralBien', '<s:message code="plugin.mejoras.bienesNMB.referenciaCatastral" text="**Referencia catastral" />' , referenciaCatastralBien_valor, {maxLength:20,labelStyle : labelStyle});
		var numFinca = app.creaText('numFinca', '<s:message code="plugin.mejoras.bienesNMB.numFinca" text="**Numero de finca" />' , numFinca_valor, {maxLength:50,labelStyle : labelStyle});
		var tomo = app.creaNumber('tomo', '<s:message code="plugin.nuevoModeloBienes.bienesNMB.tomo" text="**Tomo" />' , tomo_valor, {maxLength:6,labelStyle : labelStyle});
		var libro = app.creaNumber('libro', '<s:message code="plugin.mejoras.bienesNMB.libro" text="**libro" />' , libro_valor, {maxLength:6,labelStyle : labelStyle});
		var folio = app.creaNumber('folio', '<s:message code="plugin.mejoras.bienesNMB.folio" text="**folio" />' , folio_valor, {maxLength:6,labelStyle : labelStyle});
		var inscripcion = app.creaText('inscripcion', '<s:message code="plugin.mejoras.bienesNMB.inscripcion" text="**inscripcion" />' , inscripcion_valor, {maxLength:20,labelStyle : labelStyle});
		var fechaInscripcion = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaInscripcion" text="**Fecha Inscripcion" />'
			,labelStyle : labelStyle
			,name:'fechaInscripcion'
			,value:	'<fwk:date value="${NMBbien.datosRegistralesActivo != null ? NMBbien.datosRegistralesActivo.fechaInscripcion : ''}" />'
			,maxValue: hoy
			,style:'margin:0px'		
			,minValue: fechaMinima	
		});
		var numRegistro = app.creaText('numRegistro', '<s:message code="plugin.nuevoModeloBienes.bienesNMB.numRegistro" text="**Numero de registro" />' , numRegistro_valor, {maxLength:6,labelStyle : labelStyle});
		var municipoLibro = app.creaText('municipoLibro','<s:message code="plugin.mejoras.bienesNMB.municipoLibroMigrado" text="**Municipio (migrado)" />' , municipoLibro_valor, {maxLength:50,labelStyle : labelStyle, disabled: true});
		var comboProvinciaRegistro = app.creaCombo({
			data : <app:dict value="${provincias}" />
			<app:test id="comboProvinciaRegistro" addComa="true" />
			,name : 'bien.datosRegistrales.provincia'
			,fieldLabel : '<s:message code="plugin.mejoras.bienesNMB.provinciaRegistro" text="**Provincia registro" />'
			,value : provinciaRegistro_valor
			,valueField:'codigo'
			,labelStyle:labelStyle
			,emptyText:'-- Seleccione provincia --'
			,width:180
			,listeners: {
 	 			select: function() {
 	 				// Cargar localidades registro 	 				
					comboMunicipioRegistro.reset();
					comboMunicipioRegistro.setDisabled(false);
					optionsMunicipioRegistroStore.removeAll();
					optionsMunicipioRegistroStore.webflow({'codProvincia': comboProvinciaRegistro.getValue()});
					
 	 			}, 	 			
 	 			afterrender: function(combo) {
 	 			
 	 				if(!Ext.isEmpty(provinciaRegistro_valor)) {
 	 					combo.fireEvent("select"); 	 							
 	 				}
 	 			
 	 			}
 	 		}
		});
		
		var comboMunicipioRegistro = app.creaCombo({
			store:optionsMunicipioRegistroStore
			,value: municipioRegistro_valor
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'remote'
			,resizable: true
			,width: 180
			,forceSelection: true
			,disabled: true
			,editable: false
			,emptyText:'-- Seleccione municipio --'
			,triggerAction: 'all'
			,fieldLabel: '<s:message code="plugin.mejoras.bienesNMB.municipoLibro" text="**Municipio registro" />'
			,labelStyle:labelStyle
		});	
		
		
		var codigoRegistro = app.creaText('codigoRegistro', '<s:message code="plugin.nuevoModeloBienes.bienesNMB.codigoRegistro" text="**Tipo registro" />' , codigoRegistro_valor, {maxLength:50,labelStyle : labelStyle});
		var superficieConstruida = app.creaNumber(
			'superficieConstruida'
			, '<s:message code="plugin.mejoras.bienesNMB.superficieConstruida" text="**Superficie construida" />' 
			, superficieConstruida_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle : labelStyle
			}
		);
		var superficieNMB = app.creaNumber(
			'superficie'
			, '<s:message code="plugin.mejoras.bienesNMB.superficie" text="**Superficie terreno" />' 
			, superficie_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle : labelStyle
			}
		);
						
		/* DATOS VALORACIONES */ 
		var fechaValorSubjetivo = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaValorSubjetivo" text="**Fecha valor subjetivo" />'
			,labelStyle: labelStyle
			,name:'fechaValorSubjetivo'
			,value:	'<fwk:date value="${NMBbien.valoracionActiva != null ? NMBbien.valoracionActiva.fechaValorSubjetivo : ''}" />' 
			,maxValue: hoy
			,style:'margin:0px'	
			,minValue: fechaMinima	
		});
		
		var importeValorSubjetivo = app.creaNumber(
			'importeValorSubjetivo'
			, '<s:message code="plugin.mejoras.bienesNMB.importeValorSubjetivo" text="**Valor subjetivo"  />' 
			, importeValorSubjetivo_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				,labelStyle: labelStyle
			}
		);
		
		var fechaValorApreciacion = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaValorApreciacion" text="**Fecha valor apreciacion" />'
			,labelStyle: labelStyle
			,name:'fechaValorApreciacion'
			,value:	'<fwk:date value="${NMBbien.valoracionActiva != null ? NMBbien.valoracionActiva.fechaValorApreciacion : ''}" />'
			,maxValue: hoy
			,style:'margin:0px'		
			,minValue: fechaMinima	
		});
		
		var importeValorApreciacion = app.creaNumber(
			'importeValorApreciacion'
			, '<s:message code="plugin.mejoras.bienesNMB.importeValorApreciacion" text="**Valor apreciacion" />' 
			, importeValorApreciacion_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle: labelStyle
			}
		);
		
		var fechaValorTasacion = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaValorTasacion" text="**Fecha valor tasacion" />'
			,labelStyle: labelStyle
			,name:'fechaValorTasacion'
			,value:	'<fwk:date value="${NMBbien.valoracionActiva != null ? NMBbien.valoracionActiva.fechaValorTasacion : ''}" />'
			,style:'margin:0px'		
			,minValue: fechaMinima	
		});
		
		var importeValorTasacion = app.creaNumber(
			'importeValorTasacion'
			, '<s:message code="plugin.mejoras.bienesNMB.importeValorTasacion" text="**Valor " />' 
			, importeValorTasacion_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle: labelStyle
			}
		);
		
		var respuestaConsulta = new Ext.form.TextArea({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.respuestaConsulta" text="**respuestaConsulta" />'
			,value:'<s:message javaScriptEscape="true" text="${NMBbien.valoracionActiva.respuestaConsulta}" />'
			,name:'respuestaConsulta'
			,width:240
			,height:100
			,labelStyle:labelStyleTextArea
		});

		var valorTasacionExterna = app.creaNumber(
			'valorTasacionExterna'
			, '<s:message code="plugin.nuevoModeloBienes.valorTasacionExterna" text="**valorTasacionExterna" />' 
			, valorTasacionExterna
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle: labelStyle
				<c:if test="${operacion == 'editar'}">,disabled: true</c:if>
			}
		);
    
		var fechaSolicitudDue = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaSolicitudDueD" text="**fechaSolicitudDueD" />'
			,labelStyle: labelStyle
			,name:'fechaSolicitudDue'
			,value:	'<fwk:date value="${NMBbien.fechaSolicitudDueD}" />'
			,style:'margin:0px'		
			,minValue: fechaMinima	
		});
		
		var fechaRecepcionDue = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.fechaDueD" text="**fechaDueD" />'
			,labelStyle: labelStyle
			,name:'fechaRecepcionDue'
			,value:	'<fwk:date value="${NMBbien.fechaDueD}" />'
			,style:'margin:0px'		
			,minValue: fechaMinima	
		});
		
    	var fechaTasacionExterna = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.fechaTasacionExterna" text="**fechaTasacionExterna" />'
			,labelStyle: labelStyle
			,name:'fechaTasacionExterna'
			,value:	'<fwk:date value="${NMBbien.valoracionActiva != null ? NMBbien.valoracionActiva.fechaTasacionExterna : ''}" />'
			,style:'margin:0px'		
			,minValue: fechaMinima	
			<c:if test="${operacion == 'editar'}">,disabled: true</c:if>
		});

		var tasadora = app.creaCombo({
			data : <app:dict value="${tasadora}" />
			<app:test id="tasadora" addComa="true" />
			,name : 'tasadora'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.tasadora" text="**tasadora" />'
			,value : '${NMBbien.valoracionActiva.tasadora.codigo}'
			,labelStyle: labelStyle
			,width: 150
			<c:if test="${operacion == 'editar'}">,disabled: true</c:if>			
		});
		
		var fechaSolicitudTasacion = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.fechaSolicitudTasacion" text="**fechaSolicitudTasacion" />'
			,labelStyle: labelStyle
			,name:'fechaSolicitudTasacion'
			,value:	'<fwk:date value="${NMBbien.valoracionActiva != null ? NMBbien.valoracionActiva.fechaSolicitudTasacion : ''}" />'
			,style:'margin:0px'	
			,minValue: fechaMinima	
		});

		
		var validarDC = function()
		{
			if ((nCuenta_entidad.getValue().length==0) && (nCuenta_oficina.getValue().length==0) &&
				(nCuenta_dc.getValue().length==0) && (nCuenta_cuenta.getValue().length==0)) {
		    	return true;
		    }
		    
		    var numeroCuenta = nCuenta_entidad.getValue()+''+nCuenta_oficina.getValue()+'--'+nCuenta_cuenta.getValue();
		    
		    valores = new Array(1, 2, 4, 8, 5, 10, 9, 7, 3, 6); 
		    var controlCS = 0;
		    var controlCC = 0; 
		    for (i=0; i<=7; i++) 
		    {controlCS += parseInt(numeroCuenta.charAt(i)) * valores[i+2]; 
		    }
		    controlCS = 11 - (controlCS % 11); 
		    if (controlCS == 11) controlCS = 0; 
		    else if (controlCS == 10) controlCS = 1; 
		    
		    for (i=10; i<=19; i++) 
		    controlCC += parseInt(numeroCuenta.charAt(i)) * valores[i-10]; 
		    controlCC = 11 - (controlCC % 11); 
		    if (controlCC == 11) controlCC = 0; 
		    else if (controlCC == 10) controlCC = 1; 
		    
		    var dc = controlCS + "" + controlCC;
		    	    
		    if ((isNaN(controlCS) || isNaN(controlCC)) || (nCuenta_dc.getValue() != dc))
		    {
		        return false;
		    }
		    
		   return true;
		}
		
		var focusError = function(tab,campo) {
			var tabPanel = Ext.getCmp('idTabPanel');
			tabPanel.setActiveTab(tab);
			campo.markInvalid();
		}
		
		var validaTab = function(tab) {
			msgError='';
			if (pestanaPrincipal == tab) {				
				if(NMBparticipacion.getActiveError() != '') {
					msgError=NMBparticipacion.getActiveError();
					focusError(pestanaPrincipal,NMBparticipacion);
					return false;
				}
			}
			if (pestanaValoraciones == tab) {
			
				if(porcentajeImpuestoCompra.getValue()>100){
					msgError = '<s:message text="**El valor no puede ser mayor de 100." code="plugin.nuevoModeloBienes.error.max.porcentajeImpuestoCompra"/>';
					focusError(pestanaValoraciones,porcentajeImpuestoCompra);
					return false;
				}
				if(fechaValorSubjetivo.getValue() < fechaMinima){
					msgError = '<s:message text="**Fecha erronea" code="plugin.nuevoModeloBienes.error.fechaValorSubjetivo"/>';
					focusError(pestanaValoraciones,porcentajeImpuestoCompra);
					return false;
				}
				
				if(fechaValorApreciacion.getValue() < fechaMinima){
					msgError = '<s:message text="**Fecha erronea" code="plugin.nuevoModeloBienes.error.fechaValorApreciacion"/>';
					focusError(pestanaValoraciones,porcentajeImpuestoCompra);
					return false;
				}
			
			}
			
			if (pestanaDatosRegistrales == tab) {
				if (tipoInmueble.getValue() == null || tipoInmueble.getValue() == '') {
					msgError = '<s:message text="**El tipo de inmueble es un dato obligatorio." code="plugin.nuevoModeloBienes.error.tipoInmueble"/>';
					focusError(pestanaDatosRegistrales,tipoInmueble);
					return false;
				}
				
				if(!referenciaCatastral.validate()){
					msgError="<br><s:message code="" text="Validar referencia catastral"/>";	
					return false;
				}
				
				if(fechaInscripcion.getValue() < fechaMinima){
					msgError = '<s:message text="**Fecha erronea" code="plugin.nuevoModeloBienes.error.fechaInscripcion"/>';
					focusError(pestanaDatosRegistrales,fechaInscripcion);
					return false;
				}
				<%-- Ya no es obligatorio segun bankia dgg 
				if (referenciaCatastral.getValue() == null || referenciaCatastral.getValue() == '') {
					msgError = '<s:message text="**La referencia catastral es un dato obligatorio." code="plugin.nuevoModeloBienes.error.referenciaCatastral"/>';
					focusError(pestanaDatosRegistrales,referenciaCatastral);
					return false;
				}
				--%>
			}
			
			if (pestanaEmpresa == tab) {
				if (nombreEmpresa.getValue() == null || nombreEmpresa.getValue() == '') {
					msgError = '<s:message text="**El nombre de empresa es un dato obligatorio." code="plugin.nuevoModeloBienes.error.nombreEmpresa"/>';
					focusError(pestanaEmpresa,nombreEmpresa);
					return false;
				}
			}
			
			if (pestanaIAE == tab) {
				if (epigrafeIAE.getValue() == null || epigrafeIAE.getValue() == '') {
					msgError = '<s:message text="**El epigrafe del IAE es un dato obligatorio." code="plugin.nuevoModeloBienes.error.epigrafeIAE"/>';
					focusError(pestanaIAE,epigrafeIAE);
					return false;
				}
			}
			
			if (pestanaVehiculo == tab) {
				if(fechaMatriculacion.getValue() < fechaMinima){
					msgError = '<s:message text="**Fecha erronea" code="plugin.nuevoModeloBienes.error.fechaMatriculacion"/>';
					focusError(pestanaVehiculo,fechaMatriculacion);
					return false;
				}
				
				/*if (marca.getValue() == null || marca.getValue() == '') {
					msgError = '<s:message text="**La marca es un dato obligatorio obligatorio." code="plugin.nuevoModeloBienes.error.marca"/>';
					focusError(pestanaVehiculo,marca);
					return false;
				}
				if (modelo.getValue() == null || modelo.getValue() == '') {
					msgError = '<s:message text="**El modelo es un dato obligatorio." code="plugin.nuevoModeloBienes.error.modelo"/>';
					focusError(pestanaVehiculo,modelo);
					return false;
				}
				if (matricula.getValue() == null || matricula.getValue() == '') {
					msgError = '<s:message text="**La matricula es un dato obligatorio." code="plugin.nuevoModeloBienes.error.matricula"/>';
					focusError(pestanaVehiculo,matricula);
					return false;
				}*/
			}
			
			if (pestanaProductosBanco == tab) {
				if(tiposFinancieros.getValue() == null || tiposFinancieros.getValue() == '') {
					msgError = '<s:message text="**Los tipos financieros es un dato obligatorio." code="plugin.nuevoModeloBienes.error.tiposFinancieros"/>';
					focusError(pestanaProductosBanco,tiposFinancieros);
					return false;
				}
			}
			
			if (pestanaLocalizacion == tab) {
				if ((tipoNMB.getValue() == 'IAJE') || ((tipoNMB.getValue() == 'INMU'))){
					if(provincia.getValue() == null || provincia.getValue() == '') {
						msgError = '<s:message text="**La provincia es un dato obligatorio." code="plugin.nuevoModeloBienes.error.provincia"/>';
						focusError(pestanaLocalizacion,provincia);
						return false;
					}
					if(comboLocalidad.getValue() == null || comboLocalidad.getValue() == '') {
						msgError = '<s:message text="**Localidad es un dato obligatorio." code="plugin.nuevoModeloBienes.error.localidad"/>';
						focusError(pestanaLocalizacion,comboLocalidad);
						return false;
					}
					if(comboUnidadPoblacional.getValue() == null || comboUnidadPoblacional.getValue() == '') {
						msgError = '<s:message text="**Unidad poblacional es un dato obligatorio." code="plugin.nuevoModeloBienes.error.unidadPoblacional"/>';
						focusError(pestanaLocalizacion,comboLocalidad);
						return false;
					}
					if(codPostal.getValue() == null || codPostal.getValue() == '') {
						msgError = '<s:message text="**El codigo postal es un dato obligatorio." code="plugin.nuevoModeloBienes.error.codPostal"/>';
						focusError(pestanaLocalizacion,codPostal);
						return false;
					}
					if(direccion.getValue() == null || direccion.getValue() == '') {
						msgError = '<s:message text="**La direccion es un dato obligatorio." code="plugin.nuevoModeloBienes.error.direccion"/>';
						focusError(pestanaLocalizacion,direccion);
						return false;
					}
				}
			}
			
			if (pestanaObservaciones == tab) {
				
			}
			
			if (pestanaCuentaBancaria == tab) {
				if(entidad.getValue() == null || entidad.getValue() == '') {
					msgError = '<s:message text="**El nombre de la entidad es un dato obligatorio." code="plugin.nuevoModeloBienes.error.entidad"/>';
					focusError(pestanaCuentaBancaria,entidad);
					return false;
				}
				if(nCuenta_entidad.getActiveError() != '') {
					msgError='<s:message code="plugin.nuevoModeloBienes.numCuentaEntidadError" text="**Error Num cuenta - Entidad:"/> ' + nCuenta_entidad.getActiveError();
					focusError(pestanaCuentaBancaria,nCuenta_entidad);
					return false;
				}
				if(nCuenta_oficina.getActiveError() != '') {
					msgError='<s:message code="plugin.nuevoModeloBienes.numCuentaEntidadError" text="**Error Num cuenta - Oficina:"/> ' + nCuenta_oficina.getActiveError();
					focusError(pestanaCuentaBancaria,nCuenta_oficina);
					return false;
				}
				if(nCuenta_dc.getActiveError() != '') {
					msgError='<s:message code="plugin.nuevoModeloBienes.numCuentaEntidadError" text="**Error Num cuenta - Digito control:"/> ' + nCuenta_dc.getActiveError();
					focusError(pestanaCuentaBancaria,nCuenta_dc);
					return false;
				}
				if(nCuenta_cuenta.getActiveError() != '') {
					msgError='<s:message code="plugin.nuevoModeloBienes.numCuentaEntidadError" text="**Error Num cuenta:"/> ' + nCuenta_cuenta.getActiveError();
					focusError(pestanaCuentaBancaria,nCuenta_cuenta);
					return false;
				}
				if (!validarDC()) {
					msgError='<s:message text="**El numero de cuenta introducida es incorrecta." code="plugin.nuevoModeloBienes.cuentaIncorrecta"/>';
					var tabPanel = Ext.getCmp('idTabPanel');
					tabPanel.setActiveTab(pestanaCuentaBancaria);
					return false;
				}
			}
			
			return true;
		}
		var errores;
		var validarFormNMB = function() {
			var tipoBien = tipoNMB.getValue();
			
			if(tipoBien == null || tipoBien == '' ){
				return false;
			}			
			
			var tipoBienValidar = getTipoBienValidar(tipoBien);
			
			for(var i=0;i < listaTabs.length;i++) {
				 if (listaTabs[i].tipoBien == tipoBienValidar)  {	 	
				 	<%-- Comprobamos pestañas del tipo de bien correspondiente --%>
					for(var x=0;x < listaTabs[i].tabs.length; x++) {
						if (!validaTab(listaTabs[i].tabs[x])) {
							return false;
						}
					}
				return true;
				}				
			}
			return true;			
		}
				
		<%--Obtiene el tipoBien cuyas pestañas se validarán, en caso de no encontrarse, se validarán las pestañas por defecto --%>
		var getTipoBienValidar = function(tipoBien){
			for(var i=0;i < listaTabs.length;i++) {
				 if (listaTabs[i].tipoBien == tipoBien)  {
				 	return listaTabs[i].tipoBien;
				 }	
			}
			return 'DEFECTO';
		} 		
		
		var NMBparticipacion = app.creaInteger(
			'bien.participacion'
			, '<s:message code="bienesCliente.participacion" text="**Participacion" />' 
			, participacion_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"3"
					, autocomplete: "off"
				}
				, maxLength:3
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 3 digitos" arguments="3" />'
				, labelStyle : labelStyle
				, maxValue:100
				, maxText:'<s:message code="error.maxvalor" text="**El valor maximo es 100" />'
			}
		);
		
		
		var nombreEmpresa = app.creaText('nomEmpresa', '<s:message code="plugin.nuevoModeloBienes.nombreEmpresa" text="**Nombre Empresa" />' , nomEmpresa_valor, {width: 350, maxLength:150,labelStyle : labelStyle});
		var cifEmpresa = app.creaText('cifEmpresa', '<s:message code="plugin.nuevoModeloBienes.cifEmpresa" text="**CIF Empresa" />' , cifEmpresa_valor, {maxLength:50,labelStyle : labelStyle});

		var epigrafeIAE = app.creaText('epigrafeIAE', '<s:message code="plugin.nuevoModeloBienes.epigrafeIAE" text="**Epigrafe IAE" />' , epigrafeIAE_valor, {width: 150, maxLength:50,labelStyle : labelStyle});
		var descripcionIAE = app.creaText('descripcionIAE', '<s:message code="plugin.nuevoModeloBienes.descripcionIAE" text="**Descripcion IAE" />' , descripcionIAE_valor, {width: 350, maxLength:50,labelStyle : labelStyle});
 		
 		var entidad = app.creaText('entidad', '<s:message code="plugin.nuevoModeloBienes.entidad" text="**Entidad" />' , entidad_valor, {maxLength:50,labelStyle:labelStyle});
		
		var nCuenta_entidad = app.creaText('nCuenta_entidad', '<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**N\u00BA Cuenta" />',nCuenta_entidad_valor,{width:45,maxLength:4,validator : function(v) {
						    	return (v.length == 0 || /\d{4}$/.test(v))? true : '<s:message code="plugin.nuevoModeloBienes.validacionCuentaEntidad" text="**Debe introducir un numero con {0} digitos" arguments="4" />';},autoCreate:{tag: "input", type: "text", size: "6",maxLength: "4", autocomplete: "off", style: "margin-left:4px"}});
		var nCuenta_oficina = app.creaText('nCuenta_oficina', '<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**N\u00BA Cuenta" />',nCuenta_oficina_valor,{width:45,maxLength:4,validator : function(v) {
						    	return (v.length == 0 || /\d{4}$/.test(v))? true : '<s:message code="plugin.nuevoModeloBienes.validacionCuentaEntidad" text="**Debe introducir un numero con {0} digitos" arguments="4" />';},autoCreate:{tag: "input", type: "text", size: "6",maxLength: "4", autocomplete: "off"}});
		var nCuenta_dc = app.creaText('nCuenta_dc', '<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**N\u00BACuenta" />',nCuenta_dc_valor,{width:25,maxLength:2,validator : function(v) {
						    	return (v.length == 0 || /\d{2}$/.test(v))? true : '<s:message code="plugin.nuevoModeloBienes.validacionCuentaEntidad" text="**Debe introducir un numero con {0} digitos" arguments="2" />';},autoCreate:{tag: "input", type: "text", size: "4",maxLength: "2", autocomplete: "off", style: "margin-left:4px"}});
		var nCuenta_cuenta = app.creaText('nCuenta_entidad', '<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**N\u00BA Cuenta" />',nCuenta_cuenta_valor,{width:85,maxLength:10,validator : function(v) {
						    	return (v.length == 0 || /\d{10}$/.test(v))? true : '<s:message code="plugin.nuevoModeloBienes.validacionCuentaEntidad" text="**Debe introducir un numero con {0} digitos" arguments="10" />';},autoCreate:{tag: "input", type: "text", size: "12",maxLength: "10", autocomplete: "off", style: "margin-left:4px"}});
		
		var cfgPanelNCuenta = {
			style : "margin-top:4px;margin-bottom:2px;"
		};
		var nCuenta_panel = app.creaPanelHz(cfgPanelNCuenta,[{html:"<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**N\u00BA Cuenta" />"+":", border: false, width : 105, cls: 'x-form-item'}, nCuenta_entidad, {html : ' ', border:false, width : 5},  nCuenta_oficina, {html : ' ', border:false, width : 5},  nCuenta_dc, {html : ' ', border:false, width : 5},  nCuenta_cuenta]);
		
		var marca = app.creaText('marca', '<s:message code="plugin.nuevoModeloBienes.marca" text="**Marca" />' , marca_valor, {maxLength:50,labelStyle : labelStyle});
		var modelo = app.creaText('modelo', '<s:message code="plugin.nuevoModeloBienes.modelo" text="**Modelo" />' , modelo_valor, {maxLength:50,labelStyle : labelStyle});
		var matricula = app.creaText('matricula', '<s:message code="plugin.nuevoModeloBienes.matricula" text="**Matricula" />' , matricula_valor, {style : 'text-transform: uppercase', maxLength:50,labelStyle : labelStyle});
		
		//TODO - Cambiar el value por la fecha de matriculacion (Cuando la tenga)
		var fechaMatriculacion = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.fechaMatriculacion" text="**Fecha Matriculacion" />'
			//,labelStyle:labelStyle
			,name:'fechaMatriculacion'
			,value:	'<fwk:date value="${NMBbien.adicional != null ? NMBbien.adicional.fechaMatricula : ''}" />'
			,maxValue: today
			,style:'margin:0px'	
			,labelStyle : labelStyle
			,minValue: fechaMinima	
		});
		var nBastidor = app.creaText('nBastidor', '<s:message code="plugin.nuevoModeloBienes.nBastidor" text="**N\u00BA Bastidor" />' , nBastidor_valor, {style : 'text-transform: uppercase',maxLength:50,labelStyle : labelStyle});
		
		var tiposFinancieros = app.creaCombo({
			data : <app:dict value="${tiposProdBanco}" />
			<app:test id="tipoBienCombo" addComa="true" />
			,name : 'bien.tipoProdBanco'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.tiposFinaciero" text="**Tipos financieros" />'
			,value : '${NMBbien.adicional.tipoProdBancario.codigo}'
			,labelStyle : labelStyle
		});
		
		var importeValorProdBancario = app.creaNumber(
			'importeValorProdBancario'
			, '<s:message code="plugin.nuevoModeloBienes.importeValorProdBancario" text="**Valoracion " />' 
			, importeValorProdBancario_valor
			, {
				autoCreate : {
					tag: "input"
					, type: "text",maxLength:"10"
					, autocomplete: "off"
				}
				, maxLength:10
				, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 10 digitos" arguments="10" />'
				, labelStyle: labelStyle
			}
		);
	</sec:authorize>
		
	var tipo = app.creaCombo({
		data : <app:dict value="${tiposBien}" />
		<app:test id="tipoBienCombo" addComa="true" />
		,name : 'bien.tipoBien'
		//,allowBlank : false
		,fieldLabel : '<s:message code="bienesCliente.tipo" text="**Tipo" />'
		,value : '${NMBbien.tipoBien.codigo}'
	});

		
	var poblacion = app.creaText('bien.poblacion', '<s:message code="bienesCliente.poblacion" text="**Poblacion" />' , '${NMBbien.poblacion}', {maxLength:50});
	
	var refCatastral = app.creaText('bien.referenciaCatastral', '<s:message code="bienesCliente.refcatastral" text="**Ref. catastral" />' , '<s:message text="${NMBbien.referenciaCatastral}" javaScriptEscape="true" />', {maxLength:20,width:250});
	
	var datosRegistrales = app.crearTextArea('<s:message code="bienesCliente.datosRegistrales" text="**Datos registrales" />' , '<s:message text="${NMBbien.datosRegistrales}" javaScriptEscape="true" />',false,'','bien.datosRegistrales', {maxLength:50});
	
	var part = app.creaInteger(
		'bien.participacion'
		, '<s:message code="bienesCliente.participacion" text="**Participacion" />' 
		, '${NMBbien.participacion}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text",maxLength:"3"
				, autocomplete: "off"
			}
			, maxLength:3
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 8 digitos" arguments="3" />'
		}
	);

	var today = new Date();

	var fechaVerif=new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="bienesCliente.fechaverificacion" text="**Fecha VErificacion" />'
		//,labelStyle:labelStyle
		,name:'bien.fechaVerificacion'
		,value:	'<fwk:date value="${NMBbien.fechaVerificacion}" />'
		,maxValue: today
		,style:'margin:0px'		
		,minValue: fechaMinima	
	});
	var valor = app.creaNumber(
		'bien.valorActual'
		, '<s:message code="bienesCliente.valorActual" text="**Valor actual" />' 
		, '${NMBbien.valorActual}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text"
				,maxLength:"14"
				, autocomplete: "off"
			}
			, maxLength:14
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 14 digitos" arguments="14" />'
		}
	);
	var cargas = app.creaNumber(
		'bien.importeCargas'
		, '<s:message code="bienesCliente.cargas" text="**Cargas" />' 
		, '${NMBbien.importeCargas}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text",maxLength:"8"
				, autocomplete: "off"
			}
			, maxLength:8
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 8 digitos" arguments="8" />'
		}
	);
	var superficie = app.creaNumber(
		'bien.superficie'
		, '<s:message code="bienesCliente.superficie" text="**Superfice en m2" />' 
		, '${NMBbien.superficie}'
		, {
			autoCreate : {
				tag: "input"
				, type: "text"
				, maxLength:"8"
				, autocomplete: "off"
			}
			, maxLength:8
			, maxLengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener mas de 8 digitos" arguments="8" />'
		}
	);
			
	
	var descripcion= app.crearTextArea(
		'<s:message code="bienesCliente.descripcion" text="**descripcion" />'
		,'<s:message text="${NMBbien.descripcionBien}" javaScriptEscape="true" />'
		,false
		,''
		,'bien.descripcionBien'
		, {
			maxLength:250 <app:test id="descripcionBien" addComa="true" />
		}
	);
	
	var validarForm = function() {
		if(tipo.getValue() == null || tipo.getValue()== '' ){
			return false;
		}
		/*if(part.getValue() == null || part.getValue()=== '') {
			return false;
		}
		if(valor.getValue() == null || valor.getValue()=== '') {
			return false;
		}
		if(cargas.getValue() == null || cargas.getValue()=== '') {
			return false;
		}
		if(descripcion.getValue() == null || descripcion.getValue()=== '') {
			return false;
		}*/
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
	 	var bien = {};
	 	parametros.id='${NMBbien.id}';
	 	parametros.idPersona='${idPersona}';
	 	
	 	parametros.oldTipoBien=tipo.getValue();
        parametros.oldPoblacion=poblacion.getValue();
		parametros.oldDescripcionBien=descripcion.getValue();
		parametros.oldParticipacion=part.getValue();
		parametros.oldValorActual=valor.getValue();
		parametros.oldImporteCargas=cargas.getValue();
		if (fechaVerif.getValue()){
			parametros.oldFechaVerificacion=fechaVerif.getValue().format('d/m/Y');
		}
		
		parametros.oldReferenciaCatastral=refCatastral.getValue();
		parametros.oldSuperficie=superficie.getValue();
		parametros.oldDatosRegistrales=datosRegistrales.getValue();
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		parametros.solvenciaNoEncontrada = solvenciaNoEncontradaNMB.getValue();
		</sec:authorize>
		parametros.obraEnCurso = obraEnCurso.getValue();
		parametros.dueDilligence = dueDilligence.getValue();
		if (bloquearCampos == 1 || bloquearCampos == 2 ) {
			parametros.tipoBien=tipoNMB.getValue();
			//if (idPersona != '') {
				parametros.participacionNMB=NMBparticipacion.getValue();
				parametros.oldParticipacion=NMBparticipacion.getValue();
			//}
			parametros.valorActual=valorNMB.getValue();
			parametros.importeCargas=cargasNMB.getValue();
			if (fechaVerifNMB.getValue()){
				parametros.fechaVerificacion=fechaVerifNMB.getValue().format('d/m/Y');
			}
			parametros.descripcionBien=descripcionNMB.getValue();
			
			parametros.poblacion=poblacionNMB.getValue();
			parametros.provincia=provincia.getValue();
			parametros.via=comboVia.getValue();
			parametros.pais=comboPais.getValue();
			
			parametros.localidad=comboLocalidad.getValue();
			parametros.unidadPoblacional=comboUnidadPoblacional.getValue();
			
			parametros.codPostal=codPostal.getValue();
			parametros.direccion=direccion.getValue();
			
			parametros.tipoVia=comboVia.getValue();
			parametros.nombreVia=nombreVia.getValue();
			parametros.numeroDomicilio=numeroDomicilio.getValue();
			parametros.portal=portal.getValue();
			parametros.bloque=bloque.getValue();
			parametros.escalera=escalera.getValue();
			parametros.piso=piso.getValue();
			parametros.puerta=puerta.getValue();
			parametros.barrio=barrio.getValue();
			parametros.pais=comboPais.getValue();
			parametros.impuestoCompra=impuestoCompra.getValue();
            parametros.porcentajeImpuestoCompra=porcentajeImpuestoCompra.getValue();
			parametros.observaciones=observaciones.getValue();
			
			parametros.referenciaCatastralBien=referenciaCatastral.getValue();
			parametros.tomo=tomo.getValue();
			parametros.libro=libro.getValue();
			parametros.folio=folio.getValue();
			parametros.inscripcion=inscripcion.getValue();
			if (fechaInscripcion.getValue()){
				parametros.fechaInscripcion=fechaInscripcion.getValue().format('d/m/Y');
			}
			parametros.numRegistro=numRegistro.getValue();
			parametros.numFinca=numFinca.getValue();
			parametros.municipoLibro=municipoLibro.getValue();
			parametros.municipioRegistro=comboMunicipioRegistro.getValue();
			parametros.provinciaRegistro=comboProvinciaRegistro.getValue();
			parametros.codigoRegistro=codigoRegistro.getValue();
			parametros.superficieConstruida=superficieConstruida.getValue();
			parametros.superficie=superficieNMB.getValue();
			
			if (fechaValorSubjetivo.getValue()){
				parametros.fechaValorSubjetivo=fechaValorSubjetivo.getValue().format('d/m/Y');
			}
			parametros.importeValorSubjetivo=importeValorSubjetivo.getValue();
			if (fechaValorApreciacion.getValue()){
				parametros.fechaValorApreciacion=fechaValorApreciacion.getValue().format('d/m/Y');
			}
			parametros.importeValorApreciacion=importeValorApreciacion.getValue();
			if (fechaValorTasacion.getValue()){
				parametros.fechaValorTasacion=fechaValorTasacion.getValue().format('d/m/Y');
			}
			parametros.importeValorTasacion=importeValorTasacion.getValue();
			
			parametros.nomEmpresa=nombreEmpresa.getValue();
		    parametros.cifEmpresa=cifEmpresa.getValue();
		    parametros.codIAE=epigrafeIAE.getValue();
		    parametros.desIAE=descripcionIAE.getValue();
		    parametros.tipoProdBancario=tiposFinancieros.getValue();
		   	parametros.tipoInmueble=tipoInmueble.getValue();
		   	parametros.valoracion=importeValorProdBancario.getValue();
		   	parametros.entidad=entidad.getValue();
		   	parametros.numCuenta=nCuenta_entidad.getValue()+''+nCuenta_oficina.getValue()+''+nCuenta_dc.getValue()+''+nCuenta_cuenta.getValue();
		   	parametros.matricula=matricula.getValue();
		   	parametros.bastidor=nBastidor.getValue();
		   	parametros.modelo=modelo.getValue();
		   	parametros.marca=marca.getValue();
		   	if (fechaMatriculacion.getValue()){
				parametros.fechaMatricula=fechaMatriculacion.getValue().format('d/m/Y');
			}
			parametros.situacionPosesoria = situacionPosesoria.getValue();
			parametros.viviendaHabitual = viviendaHabitual.getValue() == '' ? null : viviendaHabitual.getValue() == '01' ? '1' : '2';
			parametros.tipoSubasta = tipoSubasta.getValue();
			parametros.numeroActivo  = numeroActivo.getValue();
			parametros.licenciaPrimeraOcupacion = licenciaPrimeraOcupacion.getValue();
			parametros.primeraTransmision  = primeraTransmision.getValue();
			parametros.contratoAlquiler = contratoAlquiler.getValue();
			parametros.transmitentePromotor = transmitentePromotor.getValue();
			parametros.arrendadoSinOpcCompra = arrendadoSinOpcCompra.getValue();
			parametros.usoPromotorMayorDosAnyos = usoPromotorMayorDosAnyos.getValue();
			parametros.tributacion = tributacion.getValue();
			parametros.tributacionVenta = tributacionVenta.getValue();
			parametros.imposicionCompra = imposicionCompra.getValue();
			parametros.imposicionVenta = imposicionVenta.getValue();
			parametros.inversionRenuncia = inversionRenuncia.getValue();
			
			if(fechaRecepcionDue.getValue()){
				parametros.fechaDueD = fechaRecepcionDue.getValue().format('d/m/Y');
			}
			if(fechaSolicitudDue.getValue()){
				parametros.fechaSolicitudDueD = fechaSolicitudDue.getValue().format('d/m/Y');
			}
			parametros.valorTasacionExterna = valorTasacionExterna.getValue();
    		parametros.fechaTasacionExterna = fechaTasacionExterna.getValue();
    		parametros.tasadora             = tasadora.getValue();
    		parametros.fechaSolicitudTasacion = fechaSolicitudTasacion.getValue();
			parametros.respuestaConsulta= respuestaConsulta.getValue();
		}
		return parametros;
	}
	
	idBienBandera = '${NMBbien.id}';	
	if (bloquearCampos == 1 || bloquearCampos == 2 ) {
		if (idBienBandera == ''){
			<%-- fase 2 --%>
			<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
				var btnGuardarNuevo = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {
						if (panelEdicion.getForm().isValid()){
							if(validarFormNMB()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								if (msgError == '') {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
								} else {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',msgError);
								}
							}
					   }
					   else{
					   		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');
					   }
				   }
				});
			</sec:authorize>
			<%-- Fin fase 2 --%>
			<sec:authorize ifAllGranted="SOLVENCIA_NUEVO">
				var btnGuardarNuevo = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {
						if (panelEdicion.getForm().isValid()){
							if(validarFormNMB()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										if ('${NMBbien.id}'==''){
											var r = Ext.util.JSON.decode(result.responseText);
											app.abreBien(r.id, r.id + ' ' + r.tipo);
										}
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								if (msgError == '') {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
								} else {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',msgError);
								}
							}
				   		}
				   		else
						{											   		
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');						}
				   }
				});
			</sec:authorize>
		} else {
			<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
				var btnGuardarEdit = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {
					
						//if (panelEdicion.getForm().isValid()){
							if(validarFormNMB()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										if ('${NMBbien.id}'==''){
											var r = Ext.util.JSON.decode(result.responseText);
											app.abreBien(r.id, r.id + ' ' + r.tipo);
										}
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								if (msgError == '') {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
								} else {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',msgError);
								}
							}
						//}
						//else
						//{	
						//	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');										   		
						//}
				   }
				});
			</sec:authorize>
			<%-- Fin fase 2 --%>
			<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">
				var btnGuardarEdit = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {
						//if (validaTab()){
							if(validarFormNMB()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								if (msgError == '') {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
								} else {
									Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',msgError);
								}
							}
						//}
						//else
						//{											   		
							//Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');
						//}
				   }
				});
			</sec:authorize>
			<%-- fin  --%>
		}
		
		
		var pestanaPrincipal = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaPrincipal" text="**Datos basicos" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:350'}
			,items:[ {items: [origenCarga, tipoNMB<c:if test="${operacion == 'editar'}">,solvenciaNoEncontradaNMB</c:if>,obraEnCurso<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">,dueDilligence</sec:authorize><c:if test="${idPersona!=null}">, NMBparticipacion</c:if>,situacionPosesoria,viviendaHabitual<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">,usoPromotorMayorDosAnyos</sec:authorize>,tipoSubasta ]}
					,{items: [					
					<sec:authorize ifNotGranted="PERSONALIZACION-BCC">numeroActivo,</sec:authorize>licenciaPrimeraOcupacion,primeraTransmision,<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">transmitentePromotor,contratoAlquiler,arrendadoSinOpcCompra,</sec:authorize>descripcionNMB]}
				   ]
		});
		
		var pestanaValoraciones = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaValoraciones" text="**Valoraciones" />'
			,id:'pestanaValoraciones'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:350'}
			,items:[ {items: [fechaVerifNMB, valorNMB, cargasNMB, fechaValorSubjetivo, importeValorSubjetivo,fechaValorApreciacion,importeValorApreciacion,tributacion <sec:authorize ifNotGranted="PUEDE_VER_TRIBUTACION">,porcentajeImpuestoCompra,impuestoCompra</sec:authorize> <sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION"><c:if test="${usuario.entidad.descripcion != 'BANKIA'}">,imposicionCompra,tributacionVenta,imposicionVenta</c:if>,inversionRenuncia</sec:authorize>]}
					,{items: [valorTasacionExterna,fechaTasacionExterna,tasadora,fechaSolicitudTasacion, fechaValorTasacion <sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">,fechaSolicitudDue,fechaRecepcionDue</sec:authorize>, importeValorTasacion,respuestaConsulta]}
				   ]
		});
		
		
		var pestanaDatosRegistrales = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaDatosRegistrales" text="**Datos Registrales" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:350'}
			,items:[{
					layout:'form'
					,items: [tipoInmueble, superficieNMB, superficieConstruida, tomo, libro, folio, comboProvinciaRegistro, comboMunicipioRegistro, municipoLibro ]
				},{
					layout:'form'
					,items: [numRegistro, referenciaCatastral, codigoRegistro, inscripcion, fechaInscripcion, numFinca]
				}]
		});
		
		var pestanaLocalizacion = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaLocalizacion" text="**Localizacion" />'
			,autoHeight:false
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:450'}
			,items:[{
					layout:'form'
					,items: [comboPais, provincia, comboLocalidad, poblacionNMB,comboUnidadPoblacional, codPostal,comboVia]				
				},{
					layout:'form'
					,items: [nombreVia, numeroDomicilio, portal, bloque, escalera, piso, puerta, barrio, direccion]
				}]
		});
		
		var pestanaObservaciones = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaObservaciones" text="**Observaciones" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:1}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:850'}
			,items:[{
					layout:'form'
					,items: [observaciones]
				}]
		});
		
		var pestanaEmpresa = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaEmpresa" text="**Datos Empresa" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:1}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:550'}
			,items:[ {items: [nombreEmpresa, cifEmpresa ]}
				   ]
		});
		
		var pestanaIAE = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.PestanaIAE" text="**Actividades Economicas" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:1}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:550'}
			,items:[ {items: [epigrafeIAE, descripcionIAE ]}  ]
		});
		
		var pestanaCuentaBancaria = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaCuentaBancaria" text="**Banco" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:350'}
			,items:[ {items: [entidad, nCuenta_panel ]}
					,{items: []}
				   ]
		});
		
		var pestanaVehiculo = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaVehiculo" text="**Vehiculo" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:2}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:350'}
			,items:[ {items: [marca, modelo, matricula, fechaMatriculacion, nBastidor ]}
					,{items: []}
				   ]
		});
		
		var pestanaProductosBanco = new Ext.Panel({
			title:'<s:message code="plugin.nuevoModeloBienes.pestanaProductosBanco" text="**Productos Bancarios" />'
			,autoHeight:true
			,bodyStyle:'padding: 10px'
			,layout:'table'
			,layoutConfig:{columns:1}
			,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;width:550'}
			,items:[ {items: [tiposFinancieros, importeValorProdBancario ]}					
				   ]
		});
		
		if (bloquearCampos == 1) {
			var panelEdicion=new Ext.TabPanel({
				items:[ pestanaPrincipal, pestanaValoraciones, pestanaDatosRegistrales, pestanaEmpresa, pestanaIAE, pestanaCuentaBancaria, pestanaVehiculo, pestanaProductosBanco, pestanaLocalizacion, pestanaObservaciones]
				,id:'idTabPanel'
				,layoutOnTabChange:true 
				,autoScroll: true
				,autoHeight: true
				,height: 450
				//,width : 1000
				,border : false	
				,activeItem:0
				,bbar : [btnCancelar]
			});
		
		} else {
			
			if (idBienBandera == ''){
				
				var panelEdicion=new Ext.form.FormPanel({
		 			 id:'tabsinform-form'
		 			,border:false
		 			,height: 450
		 			//,width : 1000
	  			  	,items: {	  			  	
						 xtype: 'tabpanel'
						,id:'idTabPanel'
						,activeItem:0
						,border : false	
						,anchor:'100% 100%'
						//,deferredRender:false
						,height: 350
						,autoWidth : true
						,items:[ pestanaPrincipal, pestanaValoraciones, pestanaDatosRegistrales, pestanaEmpresa, pestanaIAE, pestanaCuentaBancaria, pestanaVehiculo, pestanaProductosBanco, pestanaLocalizacion, pestanaObservaciones]
					}
					,bbar : [
							 <sec:authorize ifAllGranted="SOLVENCIA_NUEVO">btnGuardarNuevo ,</sec:authorize>
							 <sec:authorize ifAllGranted="EDITAR_SOLVENCIA">btnGuardarNuevo ,</sec:authorize>
							 btnCancelar]
				});
			} else {
				var panelEdicion=new Ext.form.FormPanel({
		 			 id:'tabsinform-form'
		 			,border:false
					,height: 450
					//,width : 1000
	  			  	,items: {
						 xtype: 'tabpanel'
						,id:'idTabPanel'
						,activeItem:0
						,border : false	
						,anchor:'100% 100%'
						//,deferredRender:false
						,height: 350
						,autoWidth : true
						,items:[ pestanaPrincipal, pestanaValoraciones, pestanaDatosRegistrales, pestanaEmpresa, pestanaIAE, pestanaCuentaBancaria, pestanaVehiculo, pestanaProductosBanco, pestanaLocalizacion, pestanaObservaciones]
					}
					,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">btnGuardarEdit ,</sec:authorize>
							 <sec:authorize ifAllGranted="EDITAR_SOLVENCIA">btnGuardarEdit ,</sec:authorize>
							 btnCancelar]
				});
			}
		}
		
	} else { 
		permisoNuevo = false;
		/* VERSION ANTIGUA DE BIENES */
		if (idBienBandera == ''){
			<sec:authorize ifAllGranted="SOLVENCIA_NUEVO">permisoNuevo = true;</sec:authorize>
			<sec:authorize ifAllGranted="EDITAR_SOLVENCIA">permisoNuevo = true;</sec:authorize>
			if (permisoNuevo) {
				var btnGuardarNuevo = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {						
						if (panelEdicion.getForm().isValid()){
							if(validarForm()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
							}
						}
						else
						{											   		
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');
						}
				   }
				});
			}
		}else{
			<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
				var btnGuardarEditar = new Ext.Button({
					text : '<s:message code="app.guardar" text="**Guardar" />'
					<app:test id="btnGuardarBien" addComa="true" />
					,iconCls : 'icon_ok'
					,handler : function() {
						if (panelEdicion.getForm().isValid()){
							if(validarForm()){
								var p = getParametros();
								Ext.Ajax.request({
									url : page.resolveUrl('editbien/saveBien'), 
									params : p,
									method: 'POST',
									success: function ( result, request ) {
										page.fireEvent(app.event.DONE);
									}
								});
							}else{
								Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
							}
						}
						else
						{											   		
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Hay campos con valor erroneo" code="fwk.ui.errorList.fieldLabel.error"/>');						}
				   		}
				});
			</sec:authorize>
		}
		
		

		if (idBienBandera == ''){
			var panelEdicion = new Ext.form.FormPanel({
				//autoHeight : true
				height : 350
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
								,items:[tipo, part,valor, cargas , descripcion ]
								,columnWidth:.5
							},{
								layout:'form'
								,bodyStyle:'padding:5px;cellspacing:10px'
								,columnWidth:.5
								,items:[refCatastral, superficie ,poblacion, datosRegistrales,fechaVerif]
							}
						]
					}
				]
				,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_NUEVO">btnGuardarNuevo ,</sec:authorize> btnCancelar]
			});
						
		} else {
			var panelEdicion = new Ext.form.FormPanel({
				height : 400
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
								,items:[tipo, part,valor, cargas , descripcion ]
								,columnWidth:.5
							},{
								layout:'form'
								,bodyStyle:'padding:5px;cellspacing:10px'
								,columnWidth:.5
								,items:[refCatastral, superficie ,poblacion, datosRegistrales,fechaVerif]
							}
						]
					}
				]
				,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">btnGuardarEditar ,</sec:authorize>btnCancelar]
			});
		}
	}
	
	var desactivarCamposInmueble = function() {
	//El cliente no quiere que se habiliten los campos. Los quiere siempre activos. Se comprobaran cuando de verdad se diferencien con un tipo los bienes/inmuebles
/*
		if(tipo.getValue()==app.tipoBien.CODIGO_TIPOBIEN_PISO || tipo.getValue()==app.tipoBien.CODIGO_TIPOBIEN_FINCA) {
			datosRegistrales.enable();
			refCatastral.enable();
			poblacion.disable();
			superficie.enable();
		} else {
			datosRegistrales.disable();
			refCatastral.disable();
			poblacion.disable();
			superficie.disable();
		}
*/
	};

	//tipo.on('select',desactivarCamposInmueble);
	//desactivarCamposInmueble();

	page.add(panelEdicion);
	
	var objTabs = function(tipoBien, tabs) {
		this.tipoBien = tipoBien;
		this.tabs = tabs;
	}
	   
    <c:forEach items="${tabs}" var="entry">
		var lista = [];
		<%-- Es posible que algunas de las pestaï¿½as existentes en la configuraciï¿½n no estï¿½n definidas en la jsp, por eso filtramos la lista. --%>
		<c:forEach items = "${entry.value.listaTabs}" var="tab">
			try{
				if(${tab}){
					lista[lista.length] = ${tab};
				}
			}catch(e){
				<%-- Si la pestaï¿½a no se ha creado, no se intenta aï¿½adir. --%>		
			}	
		</c:forEach>
		listaTabs[listaTabs.length] = new objTabs('${entry.key}',lista);
    </c:forEach>
    
    muestraTabs('${NMBbien.tipoBien.codigo}' || 'DEFECTO');
</fwk:page>
