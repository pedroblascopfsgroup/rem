<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){

	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	var labelStyleDescripcion = 'width:185px;height:60px;font-weight:bolder",width:375';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	var banderaOrigen = '${NMBbien.origen.codigo}';
		
	// DATOS PRINCIPALES
	var codBien				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.CodigoBien" text="**Código"/>','${NMBbien.id}', {labelStyle:labelStyle});
	var garantiaBien		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.garantiaBien" text="**Garantía Bien"/>','${NMBbien.sarebId}', {labelStyle:labelStyle});
	var codigoInterno 		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.codigoInterno" text="**Código interno"/>','${NMBbien.codigoInterno}', {labelStyle:labelStyle});
	var origen				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.origenCarga" text="**Origen"/>','${NMBbien.origen.descripcion}', {labelStyle:labelStyle});
	var valorActual			= app.creaLabel('<s:message code="bienesCliente.valorActual" text="**Valor actual"/>',app.format.moneyRenderer('${NMBbien.valorActual}'), {labelStyle:labelStyle});
	var ValorTotalCargas	= app.creaLabel('<s:message code="bienesCliente.cargas" text="**Cargas"/>',app.format.moneyRenderer('${NMBbien.importeCargas}'), {labelStyle:labelStyle});
	var fechaVerificacion	= app.creaLabel('<s:message code="bienesCliente.fechaverificacion" text="**Fecha verificación"/>','<fwk:date value="${NMBbien.fechaVerificacion}"/>', {labelStyle:labelStyle});
	var tipoBien			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tipo" text="**Tipo"/>','<s:message javaScriptEscape="true" text="${NMBbien.tipoBien.descripcion}" />',{labelStyle:labelStyle});
	//var participacion		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.participacion" text="**% Propiedad"/>','${NMBbien.participacion}',{labelStyle:labelStyle});

	var situacionPosesoria  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.situacionPosesoria" text="**situacionPosesoria"/>','${NMBbien.situacionPosesoria.descripcion}', {labelStyle:labelStyle});
	var viviendaHabitual    = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.viviendaHabitual" text="**viviendaHabitual"/>','${NMBbien.viviendaHabitual==null ? '--':NMBbien.viviendaHabitual == '1' ? 'Sí' : 'No'}', {labelStyle:labelStyle});
	var tipoSubasta		    = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tipoSubasta" text="**Tipo Subasta"/>',app.format.moneyRenderer('${NMBbien.tipoSubasta}'),{labelStyle:labelStyle});
	var numeroActivo        = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.numeroActivo" text="**numeroActivo"/>','${NMBbien.numeroActivo}', {labelStyle:labelStyle});
	var licenciaPrimeraOcupacion = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.licenciaPrimeraOcupacion" text="**licenciaPrimeraOcupacion"/>','${NMBbien.licenciaPrimeraOcupacion}', {labelStyle:labelStyle});
	var primeraTransmision  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.primeraTransmision" text="**primeraTransmision"/>','${NMBbien.primeraTransmision}', {labelStyle:labelStyle});
	var contratoAlquiler    = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.contratoAlquiler" text="**contratoAlquiler"/>','${NMBbien.contratoAlquiler}', {labelStyle:labelStyle});
	var transmitentePromotor = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.transmitentePromotor" text="**transmitentePromotor"/>','${NMBbien.transmitentePromotor}', {labelStyle:labelStyle});
	var arrendadoSinOpcCompra = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.arrendadoSinOpcCompra" text="**arrendadoSinOpcCompra"/>','${NMBbien.arrendadoSinOpcCompra}', {labelStyle:labelStyle});
	var usoPromotorMayorDosAnyos = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.usoPromotorMayorDosAnyos" text="**usoPromotorMayorDosAnyos"/>','${NMBbien.usoPromotorMayorDosAnyos}', {labelStyle:labelStyle});

        
	// DATOS DESCRIPCION
	var Descripcion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.descripcion" text="**Descripción" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.descripcionBien}" />'
		,name:'descripcion'
		,width:240		
		,height:150
		,readOnly:true
		,labelStyle:labelStyleTextArea
	});
	
	ValorTotalCargas.setVisible(false);

	// DATOS OBSERVACIONES
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.observaciones" text="**Descripción" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.observaciones}" />'
		,name:'observaciones'
		,hideLabel: true
		,width:745
		,height: 150
		,readOnly:true
	});
		
	//VALORACIONES
	var fechaValSubjetivo	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorSubjetivo" text="**Fecha val. subjetivo"/>','<fwk:date value="${NMBbien.valoracionActiva.fechaValorSubjetivo}"/>',{labelStyle:labelStyle});
	var valorSubjetivo		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorSubjetivo" text="**Val. Subjetivo"/>',app.format.moneyRenderer('${NMBbien.valoracionActiva.importeValorSubjetivo}'),{labelStyle:labelStyle});
	var fechaValApreciacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorApreciacion" text="**Fecha val. apreciación"/>','<fwk:date value="${NMBbien.valoracionActiva.fechaValorApreciacion}"/>',{labelStyle:labelStyle});
	var valorApreciacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorApreciacion" text="**Val. Apreciación"/>',app.format.moneyRenderer('${NMBbien.valoracionActiva.importeValorApreciacion}'),{labelStyle:labelStyle});
	var fechaValTasacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorTasacion" text="**Fecha val. tasación"/>','<fwk:date value="${NMBbien.valoracionActiva.fechaValorTasacion}"/>',{labelStyle:labelStyle});
	var valorTasacion		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorTasacion" text="**Val. Tasación"/>',app.format.moneyRenderer('${NMBbien.valoracionActiva.importeValorTasacion}'),{labelStyle:labelStyle});
	
	var valorTasacionExterna = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.valorTasacionExterna" text="**valorTasacionExterna"/>',app.format.moneyRenderer('${NMBbien.valoracionActiva.valorTasacionExterna}'),{labelStyle:labelStyle});
    var fechaTasacionExterna = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaTasacionExterna" text="**fechaTasacionExterna"/>','<fwk:date value="${NMBbien.valoracionActiva.fechaTasacionExterna}"/>',{labelStyle:labelStyle});
    var tasadora             = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tasadora" text="**tasadora"/>','${NMBbien.valoracionActiva.tasadora.descripcion}',{labelStyle:labelStyle});
    var fechaSolicitudTasacion = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaSolicitudTasacion" text="**fechaSolicitudTasacion"/>','<fwk:date value="${NMBbien.valoracionActiva.fechaSolicitudTasacion}"/>',{labelStyle:labelStyle});
	var fechaDueD 			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaDueD" text="**fechaDueD"/>','<fwk:date value="${NMBbien.fechaDueD}"/>', {labelStyle:labelStyle});
	var fechaSolicitudDueD	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaSolicitudDueD" text="**fechaSolicitudDueD"/>','<fwk:date value="${NMBbien.fechaSolicitudDueD}"/>', {labelStyle:labelStyle});
	<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">
	var tributacion  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tributacionCompra" text="**tributacionCompra"/>','${NMBbien.tributacion.descripcion}', {labelStyle:labelStyle});
	</sec:authorize>
	<sec:authorize ifNotGranted="PUEDE_VER_TRIBUTACION">
	var tributacion  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tributacion" text="**tributacion"/>','${NMBbien.tributacion.descripcion}', {labelStyle:labelStyle});
	</sec:authorize>
	var tributacionVenta  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tributacionVenta" text="**tributacionVenta"/>','${NMBbien.tributacionVenta.descripcion}', {labelStyle:labelStyle});
	var imposicionCompra  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.imposicionCompra" text="**imposicionCompra"/>','${NMBbien.tipoImposicionCompra.descripcion}', {labelStyle:labelStyle});
	var imposicionVenta  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.imposicionVenta" text="**imposicionVenta"/>','${NMBbien.tipoImposicionVenta.descripcion}', {labelStyle:labelStyle});
	var inversionRenuncia  = app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.inversionRenuncia" text="**inversionRenuncia"/>','${NMBbien.inversionPorRenuncia.descripcion}', {labelStyle:labelStyle});
	var porcentajeImpuestoCompra  = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.porcentajeImpuestoCompra" text="**porcentajeImpuestoCompra"/>','${NMBbien.porcentajeImpuestoCompra}', {labelStyle:labelStyle});
	var impuestoCompra  = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.impuestoCompra" text="**impuestoCompra"/>','${NMBbien.impuestoCompra.descripcion}', {labelStyle:labelStyleDescripcion});
	
	
	var respuestaConsulta = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.respuestaConsulta" text="**respuestaConsulta" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.valoracionActiva.respuestaConsulta}" />'
		,name:'descripcion'
		,width:240		
		,height:150
		,readOnly:true
		,labelStyle:labelStyleTextArea
	});
	
	
	//DATOS REGISTRALES	
	var supTerreno			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.superficie" text="**Superficie"/>','${NMBbien.datosRegistralesActivo.superficie}',{labelStyle:labelStyle});
	var supConstruida		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.superficieConstruida" text="**Sup. Construida"/>','${NMBbien.datosRegistralesActivo.superficieConstruida}',{labelStyle:labelStyle});
	var tomo				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.tomo" text="**Tomo"/>','${NMBbien.datosRegistralesActivo.tomo}',{labelStyle:labelStyle});
	var libro				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.libro" text="**Libro"/>','${NMBbien.datosRegistralesActivo.libro}',{labelStyle:labelStyle});
	var folio				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.folio" text="**Folio"/>','${NMBbien.datosRegistralesActivo.folio}',{labelStyle:labelStyle});
	//var minicipioRegistro	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.municipoLibro" text="**Municipio"/>','<s:message javaScriptEscape="true" text="${NMBbien.datosRegistralesActivo.municipoLibro}" />',{labelStyle:labelStyle});
	var municipioRegistro	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.municipioRegistro" text="**Municipio"/>','<s:message javaScriptEscape="true" text="${NMBbien.datosRegistralesActivo.localidad.descripcion}" />',{labelStyle:labelStyle});
	var provinciaRegistro	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.provinciaRegistro" text="**"/>','<s:message javaScriptEscape="true" text="${NMBbien.datosRegistralesActivo.provincia.descripcion}" />',{labelStyle:labelStyle});	
	var numRegistro			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.numRegistro" text="**Nº Registro"/>','${NMBbien.datosRegistralesActivo.numRegistro}',{labelStyle:labelStyle});
	var tipoRegistro		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.codigoRegistro" text="**Tipo registro"/>','${NMBbien.datosRegistralesActivo.codigoRegistro}',{labelStyle:labelStyle});
	var refCatastral		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.referenciaCatastral" text="**Ref. Catastral"/>','${NMBbien.datosRegistralesActivo.referenciaCatastralBien}',{labelStyle:labelStyle});
	var inscripcion			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.inscripcion" text="**Inscripción"/>','${NMBbien.datosRegistralesActivo.inscripcion}',{labelStyle:labelStyle});
	var fechaInscripcion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaInscripcion" text="**Fecha Inscripción"/>','<fwk:date value="${NMBbien.datosRegistralesActivo.fechaInscripcion}"/>',{labelStyle:labelStyle});
	var numFinca			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.numFinca" text="**Nº Finca"/>','${NMBbien.datosRegistralesActivo.numFinca}',{labelStyle:labelStyle});

	//LOCALIZACION
	var provincia_valor = '';
	var localidad_valor = '';
	var unidadPoblacional_valor = '';
	<c:if test="${NMBbien.localizacionActual!=null}">
		provincia_valor = '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.provincia.descripcion}" />';
		localidad_valor = '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.localidad.descripcion}" />';
		unidadPoblacional_valor = '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.unidadPoblacional.descripcion}" />';
	</c:if>
	var poblacion			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.poblacion" text="**Población"/>', '<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.poblacion}" />',{labelStyle:labelStyle});
	var codPostal			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.codPostal" text="**Cod. Postal"/>','${NMBbien.localizacionActual.codPostal}',{labelStyle:labelStyle});
	var provincia			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.provincia" text="**Provincia"/>',provincia_valor,{labelStyle:labelStyle});
	
	var tipoVia				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.tipoVia" text="**Tipo Via"/>','${NMBbien.localizacionActual.tipoVia.descripcion}',{labelStyle:labelStyle});
	var nombreVia			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nombreVia" text="**Nombre Via"/>','<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.nombreVia}" />',{labelStyle:labelStyle});
	var numeroDomicilio		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.numeroDomicilio" text="**Num. Domicilio"/>','${NMBbien.localizacionActual.numeroDomicilio}',{labelStyle:labelStyle});
	var portal				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.portal" text="**Portal"/>','${NMBbien.localizacionActual.portal}',{labelStyle:labelStyle});
	var bloque				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bloque" text="**Bloque"/>','${NMBbien.localizacionActual.bloque}',{labelStyle:labelStyle});
	var escalera			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.escalera" text="**Escalera"/>','${NMBbien.localizacionActual.escalera}',{labelStyle:labelStyle});
	var piso				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.piso" text="**Piso"/>','${NMBbien.localizacionActual.piso}',{labelStyle:labelStyle});
	var puerta				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.puerta" text="**Puerta"/>','${NMBbien.localizacionActual.puerta}',{labelStyle:labelStyle});
	var barrio				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.barrio" text="**Barrio"/>','${NMBbien.localizacionActual.barrio}',{labelStyle:labelStyle});
	var pais				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.pais" text="**Pais"/>','${NMBbien.localizacionActual.pais.descripcion}',{labelStyle:labelStyle});

	var localidad			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.localidad" text="**Localidad"/>',localidad_valor,{labelStyle:labelStyle});
	var unidadPoblacional	= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.unidadPoblacional" text="**Unidad Poblacional"/>',unidadPoblacional_valor,{labelStyle:labelStyle});

	//---ADICIONALES---
	//cuenta ajena
	var nomEmpresa			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nombreEmpresa" text="**Nombre empresa"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.nomEmpresa}" />',{labelStyle:labelStyle});
	var cifEmpresa			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.cifEmpresa" text="**CIF empresa"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.cifEmpresa}" />',{labelStyle:labelStyle});
	
	//cuenta propia
	var codIAE				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.epigrafeIAE" text="**Código IAE"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.codIAE}" />',{labelStyle:labelStyle});
	var desIAE				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.descripcionIAE" text="**Descripción IAE"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.desIAE}" />',{labelStyle:labelStyle});
	
	//Cuenta bancaria
	var entidad				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.entidad" text="**Entidad"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.entidad}" />',{labelStyle:labelStyle});
	var numCuenta			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**Nº Cuenta"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.numCuenta}" />',{labelStyle:labelStyle});
	
	//vehiculo
	var marca				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.marca" text="**Marca"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.marca}" />',{labelStyle:labelStyle});
	var modelo				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.modelo" text="**Modelo"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.modelo}" />',{labelStyle:labelStyle});
	var matricula			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.matricula" text="**Matricula"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.matricula}" />',{labelStyle:labelStyle});
	var fechaMatricula		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fechaMatriculacion" text="**Fecha matriculación"/>','<fwk:date value="${NMBbien.adicional.fechaMatricula}"/>', {labelStyle:labelStyleAjusteColumnas});
	
	var bastidor			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nBastidor" text="**N. Bastidor"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.bastidor}" />',{labelStyle:labelStyle});
	
	//Inmueble
	var tiposInmuebles		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.tipoInmueble" text="**Tipo Inmueble"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.tipoInmueble.descripcion}" />',{labelStyle:labelStyle});
	var codigoTipoInmueble          = "${NMBbien.adicional.tipoInmueble.codigo}";
        
	//activosFinancieros
	var tiposFinancieros	= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.tiposFinaciero" text="**Tipo Financiero"/>', '<s:message javaScriptEscape="true" text="${NMBbien.adicional.tipoProdBancario.descripcion}" />',{labelStyle:labelStyle});
	var valorProdBancario	= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.importeValorProdBancario" text="**Valoración"/>',app.format.moneyRenderer('${NMBbien.adicional.valoracion}'),{labelStyle:labelStyle});
	
	// OTROS DATOS
	var numDomicilio = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.numDomicilio" text="**Número del domicilio del bien"/>', '<s:message javaScriptEscape="true" text="${NMBbien.numDomicilio}" />',{labelStyle:labelStyle});
	var idDireccion = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.idDireccion" text="**Identificador de dirección unívoca que tiene dado de alta el bien en la garantía"/>', '<s:message javaScriptEscape="true" text="${NMBbien.idDireccion}" />',{labelStyle:labelStyle});
	var destinoUso = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.destinoUso" text="**Destino uso del bien."/>', '<s:message javaScriptEscape="true" text="${NMBbien.destinoUso}" />',{labelStyle:labelStyle});
	
	var direccion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.direccion" text="**Dirección" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.localizacionActual.direccion}" />'
		,name:'direccion'
		,width:240
		,readOnly:true
		,labelStyle:labelStyleTextArea
	});
	
	var solvenciaNoEncontrada = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.solvenciaNoEncontrada" text="**Solvencia no encontrada"/>'
		,name:'solvenciaNoEncontrada'
		,labelStyle:labelStyle
		,disabled:true
	});
	
	var mensajeSolvenciaNoEncontrada	= app.creaLabel('El bien esta marcado como solvencia no encontrada','',{labelStyle:'color:red;width:300px;font-weight:bolder,width:300;'});
	if('${NMBbien.solvenciaNoEncontrada}' == 'true'){
		solvenciaNoEncontrada.checked = true;
		mensajeSolvenciaNoEncontrada.hidden=false;
	}
	else{
		mensajeSolvenciaNoEncontrada.hidden=true;
		solvenciaNoEncontrada.checked = false;
	}
	
	var obraEnCurso = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.obraEnCurso" text="**Obra en curso"/>'
		,name:'obraEnCurso'
		,labelStyle:labelStyle
		,disabled:true
	});
	
	if('${NMBbien.obraEnCurso}' == 'true'){
		obraEnCurso.checked = true;
	}
	else{
		obraEnCurso.checked = false;
	}
	
	var dueDilligence = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.dueDilligence" text="**dueDilligence"/>'
		,name:'dueDilligence'
		,labelStyle:labelStyle
		,disabled:true
	});
	
	if('${NMBbien.dueDilligence}' == 'true'){
		dueDilligence.checked = true;
	}
	else{
		dueDilligence.checked = false;
	}
		
	var pestanaPrincipal = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.datosPrincipales.titulo" text="**Datos Principales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[mensajeSolvenciaNoEncontrada, origen, codigoInterno ,codBien <sec:authorize ifAllGranted="PERSONALIZACION-HY">, garantiaBien </sec:authorize>
	    			, tipoBien, solvenciaNoEncontrada, obraEnCurso, dueDilligence, situacionPosesoria,viviendaHabitual,usoPromotorMayorDosAnyos,tipoSubasta]},
				  {items:[
				  	<sec:authorize ifNotGranted="PERSONALIZACION-BCC">numeroActivo,</sec:authorize>
				  	licenciaPrimeraOcupacion,primeraTransmision,transmitentePromotor,contratoAlquiler,arrendadoSinOpcCompra,Descripcion]}
				 ]
	});
	
	
	var pestanaValoraciones = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.datosEconomicos.titulo" text="**Datos económicos"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[fechaVerificacion, valorActual, ValorTotalCargas, fechaValSubjetivo, valorSubjetivo,tributacion<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION"><c:if test="${usuario.entidad.descripcion != 'BANKIA'}">,imposicionCompra,tributacionVenta,imposicionVenta</c:if>,inversionRenuncia</sec:authorize>,respuestaConsulta]},
				  {items:[valorTasacionExterna,fechaTasacionExterna,tasadora,fechaSolicitudTasacion,fechaValApreciacion, valorApreciacion, fechaValTasacion, valorTasacion<sec:authorize ifAllGranted="PUEDE_VER_TRIBUTACION">, fechaSolicitudDueD, fechaDueD</sec:authorize> <sec:authorize ifNotGranted="PUEDE_VER_TRIBUTACION">, porcentajeImpuestoCompra, impuestoCompra</sec:authorize>]}
				 ]
	});
	

	var pestanaEmpresa = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.pestanaEmpresa" text="**Datos Empresa"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:766}
	    ,items : [{items:[nomEmpresa, cifEmpresa]} ]
	});

	var pestanaIAE = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.PestanaIAE" text="**Actividades Economicas" />'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:766}
	    ,items : [{items:[codIAE, desIAE]}]
	});	
	
	var pestanaProductosBanco = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.pestanaProductosBanco" text="**Productos Bancarios" />'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:766}
	    ,items : [{items:[tiposFinancieros, valorProdBancario]}]
	});	

	var pestanaCuentaBancaria = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.pestanaCuentaBancaria" text="**Banco" />'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:766}
	    ,items : [{items:[entidad, numCuenta]}]
	});	
	
	var pestanaObservaciones = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.datosObservaciones.titulo" text="**Datos observaciones"/>'
		,defaults : {xtype:'fieldset', border:false, autoHeight:true, cellCls:'vtop', width:766}
	    ,items : [{items:observaciones}]
	});
	
	var pestanaDatosRegistrales = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.datosRegistrales.titulo" text="**Datos registrales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[tiposInmuebles, supTerreno, supConstruida, tomo, libro, folio, provinciaRegistro, municipioRegistro]},
				  {items:[numRegistro, refCatastral, tipoRegistro, inscripcion, fechaInscripcion, numFinca]}
				 ]
	});
	
	var pestanaLocalizacion = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.datosDomicilio.titulo" text="**Domicilio"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [{items:[pais, provincia, localidad, unidadPoblacional, codPostal, tipoVia]},
				  {items:[nombreVia, numeroDomicilio, portal, bloque, escalera, piso, puerta, barrio, direccion]}
				 ]
	});
	
	var pestanaOtros = new Ext.form.FieldSet({
		id: 'otrosDatos'
		,autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.titulo" text="**Otros datos"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [{items:[numDomicilio, idDireccion, destinoUso]}
				 ]
	});
	
	var pestanaVehiculo = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.pestanaVehiculo" text="**Vehiculo"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[marca, modelo, matricula]},
				  {items:[fechaMatricula, bastidor]}
				 ]
	});
	
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		var btnEditar = new Ext.Button({
		    text: '<s:message code="app.editar" text="**Editar" />'
			<app:test id="btnEditarSolvencia" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		         	,handler:function(){
				var w = app.openWindow({
					flow : 'editbien/openByIdBien'
					,width: 1000
					,title : '<s:message code="app.editarRegistro" text="**Editar bien" />'
					,params : {id:${NMBbien.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
		
		//flag que indica si se puede solicitar la tasación
		var solicitarTas = ${solicitarTasacion};

		var btnSolicitarTasacion = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolicitarTasacion" text="**Solicitar Tasacion" />'
			<app:test id="btnSolicitarTasacion" addComa="true" />
		    ,iconCls : 'icon_refresh'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
         	,handler:function(){
				if (false) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
				} else {	
					if(solicitarTas<=-3 || solicitarTas==0)
					{
					    var mensaje;
					    if(solicitarTas==0){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko0"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					    }
					    if(solicitarTas==-1){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko1"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					    }
					   	if(solicitarTas==-2){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko2"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					    }
					   	if(solicitarTas==-3){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko3"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					    }
					   	if(solicitarTas==-4){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko4"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					    }
					   	if(solicitarTas==-5){
					    	Ext.Msg.show({
							title:'Advertencia',
							msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ko5"/>',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING
							});
					   	}
						
					}
					else{			
			      		page.webflow({
			      			flow:'editbien/solicitarTasacion'
			      			,params:{id:${NMBbien.id}}
			      			,success: function(){
			      			   Ext.Msg.show({
									title:'Operación realizada',
									msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ok"/>',
									buttons: Ext.Msg.OK,
									icon:Ext.MessageBox.INFO
								});	
			      			   app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
			            	}
			      		});
		      		}
				}
	        }
		});
		
	</sec:authorize>
	
	var listaTabsTipo = [pestanaPrincipal, pestanaLocalizacion, pestanaObservaciones];
	var tabsEncontrados = false;
	<c:forEach items="${tabsTipoBien}" var="entry">
		<c:if test="${entry.key == NMBbien.tipoBien.codigo}">
			listaTabsTipo =${entry.value.listaTabs};
			tabsEncontrados=true;
		</c:if>
    </c:forEach>
    if (!tabsEncontrados) {
	    <c:forEach items="${tabsTipoBien}" var="entry">
			<c:if test="${entry.key == 'DEFECTO'}">
				listaTabsTipo =${entry.value.listaTabs};
			</c:if>
	    </c:forEach>
	}
	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
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
		,items: listaTabsTipo
		,nombreTab : 'cabecera'
		,bbar:new Ext.Toolbar()
	});
	
	var validarProvLocFinBien = function() {
            //Se valida por existencia de codigoTipoInmueble porque es dato obligatorio en el diccionario y no puede ser null en un tipo de inmueble
			if(codigoTipoInmueble=='' || numFinca.getValue()=='' || localidad.getValue() == '' || provincia.getValue() == '' || numRegistro.getValue() == '' || numRegistro.getValue() == 0){
				Ext.MessageBox.show({
		           title: 'Campos obligatorios',
		           msg: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolNumActivoCamposObligatorios" text="**Los campos provincia, localidad, número de finca y número de registro son obligatorios para solicitar el número de activo" />',
		           width:300,
		           buttons: Ext.MessageBox.OK
		        });
		        return false;
			}
			return true;			
		}
                
	var btnSolicitarNumActivo = new Ext.Button({
	    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolicitarNumActivo" text="**Solicitar Numero de Activo" />'
		<app:test id="btnSolicitarNumActivo" addComa="true" />
	    ,iconCls : 'icon_refresh'
		,cls: 'x-btn-text-icon'
		,style:'margin-left:2px;padding-top:0px'
	    ,handler:function(){
	    	if(validarProvLocFinBien()){
	    		if (false) {
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="acuerdos.conclusiones.observaciones.error"/>');
				} else {				
		      		page.webflow({
		      			flow:'editbien/solicitarNumActivo'
		      			,params:{id:${NMBbien.id}}
		      			,success: function(result,request){
		      			   if(result.msgError=='1'){
		      			   		Ext.Msg.show({
								title:'Operación realizada',
								msg: '<s:message code="plugin.nuevoModeloBienes.uvem.numeroActivo.ok"/>',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.INFO});
		      			   		app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
		      			   	}
		      			   	else{
		      			   	
			      			   	Ext.Msg.show({
								title:'Advertencia',
								msg: 'No se ha podido obtener el n\u00BA de activo. \n' + result.msgError,
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING});
			      			   	
		      			   	}
		            	}
		      		});
				}
			}
        }
	});
	
	var btnSolicitarTasacionHCJ = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolicitarTasacion" text="**Solicitar Tasación" />'
			<app:test id="btnSolicitarTasacion" addComa="true" />
		    ,iconCls : 'icon_refresh'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
         	,handler:function(){
         		var w = app.openWindow({
					flow : 'serviciosonlinecajamar/ventanaSolicitudTasacion'
					,width:770
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnSolicitarTasacion" text="**Solicitar tasación" />'
					,params : {idBien:${NMBbien.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					Ext.Msg.show({
						title:'Operación realizada',
						msg: '<s:message code="plugin.nuevoModeloBienes.uvem.tasacion.ok"/>',
						buttons: Ext.Msg.OK,
						icon:Ext.MessageBox.INFO
					});	
			   		app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
			    });
				w.on(app.event.CANCEL, function(){ w.close(); });         	
				
			}
	});

	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		panel.getBottomToolbar().addButton([btnEditar]);
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ACC_MAN_SERVICIOS_UVEM">
			<c:choose>
    			<c:when test="${usuario.entidad.id eq appProperties.idEntidadCajamar}">
			        panel.getBottomToolbar().addButton([btnSolicitarTasacionHCJ]);
			    </c:when>    
    			<c:otherwise>
    				<c:if test="${empty NMBbien.numeroActivo or NMBbien.numeroActivo==0}">
						panel.getBottomToolbar().addButton([btnSolicitarNumActivo]);
					</c:if>
					<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">		
						<%--Se oculta el botón "Solicitar tasación" en HAYA-SAREB --%>			
        				<sec:authorize ifNotGranted="PERSONALIZACION-HY">
        					panel.getBottomToolbar().addButton([btnSolicitarTasacion]);
        				</sec:authorize>
        			</sec:authorize>
    			</c:otherwise>
			</c:choose>			
	</sec:authorize>
	
	return panel;
})()