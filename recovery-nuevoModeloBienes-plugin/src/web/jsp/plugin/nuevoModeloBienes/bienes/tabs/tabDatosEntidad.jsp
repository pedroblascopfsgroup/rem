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
	//var labelStyleDescripcion = 'width:185x;height:60px;font-weight:bolder",width:700';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	var banderaOrigen = '${NMBbien.origen.codigo}';
		
	// DATOS PRINCIPALES
	var codBien				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.CodigoBien" text="**Código"/>','${NMBbien.bienEntidad.id}', {labelStyle:labelStyle});
	var codigoInterno		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.codigoInterno" text="**Código internno"/>','${NMBbien.bienEntidad.codigoInterno}', {labelStyle:labelStyle});
	var origen				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.origenCarga" text="**Origen"/>','${(NMBbien.bienEntidad.origen.descripcion != null) ? NMBbien.bienEntidad.origen.descripcion : NMBbien.origen.descripcion}', {labelStyle:labelStyle});
	var valorActual			= app.creaLabel('<s:message code="bienesCliente.valorActual" text="**Valor actual"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.valorActual}'), {labelStyle:labelStyle});
	var ValorTotalCargas	= app.creaLabel('<s:message code="bienesCliente.cargas" text="**Cargas"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.importeCargas}'), {labelStyle:labelStyle});
	var fechaVerificacion	= app.creaLabel('<s:message code="bienesCliente.fechaverificacion" text="**Fecha verificación"/>','<fwk:date value="${NMBbien.bienEntidad.fechaVerificacion}"/>', {labelStyle:labelStyle});
	var tipoBien			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.tipo" text="**Tipo"/>','<s:message javaScriptEscape="true" text="${(NMBbien.bienEntidad.tipoBien != null) ? NMBbien.bienEntidad.tipoBien.descripcion : ''}" />',{labelStyle:labelStyle});
	//var participacion		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.participacion" text="**% Propiedad"/>','${NMBbien.bienEntidad.participacion}',{labelStyle:labelStyle});

	ValorTotalCargas.setVisible(false);
	
	// DATOS DESCRIPCION
	var Descripcion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.descripcion" text="**Descripción" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.descripcionBien}" />'
		,name:'descripcion'
		,width:240		
		,height:150
		,readOnly:true
		,labelStyle:labelStyleTextArea
	});


	// DATOS OBSERVACIONES
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.observaciones" text="**Descripción" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.observaciones}" />'
		,name:'observaciones'
		,hideLabel: true
		,width:745
		,height: 150
		,readOnly:true
	});
	
		
	//VALORACIONES
	var fechaValSubjetivo	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorSubjetivo" text="**Fecha val. subjetivo"/>','<fwk:date value="${NMBbien.bienEntidad.fechaValorSubjetivo}"/>',{labelStyle:labelStyle});
	var valorSubjetivo		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorSubjetivo" text="**Val. Subjetivo"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.importeValorSubjetivo}'),{labelStyle:labelStyle});
	var fechaValApreciacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorApreciacion" text="**Fecha val. apreciación"/>','<fwk:date value="${NMBbien.bienEntidad.fechaValorApreciacion}"/>',{labelStyle:labelStyle});
	var valorApreciacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorApreciacion" text="**Val. Apreciación"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.importeValorApreciacion}'),{labelStyle:labelStyle});
	var fechaValTasacion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaValorTasacion" text="**Fecha val. tasación"/>','<fwk:date value="${NMBbien.bienEntidad.fechaValorTasacion}"/>',{labelStyle:labelStyle});
	var valorTasacion		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.importeValorTasacion" text="**Val. Tasación"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.importeValorTasacion}'),{labelStyle:labelStyle});
	
	//DATOS REGISTRALES	
	var supTerreno			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.superficie" text="**Superficie"/>','${NMBbien.bienEntidad.superficie}',{labelStyle:labelStyle});
	var supConstruida		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.superficieConstruida" text="**Sup. Construida"/>','${NMBbien.bienEntidad.superficieConstruida}',{labelStyle:labelStyle});
	var tomo				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.tomo" text="**Tomo"/>','${NMBbien.bienEntidad.tomo}',{labelStyle:labelStyle});
	var libro				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.libro" text="**Libro"/>','${NMBbien.bienEntidad.libro}',{labelStyle:labelStyle});
	var folio				= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.folio" text="**Folio"/>','${NMBbien.bienEntidad.folio}',{labelStyle:labelStyle});
	var minicipioRegistro	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.municipoLibro" text="**Municipio"/>','<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.municipoLibro}" />',{labelStyle:labelStyle});	
	var numRegistro			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.numRegistro" text="**Nº Registro"/>','${NMBbien.bienEntidad.numRegistro}',{labelStyle:labelStyle});
	var tipoRegistro		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.bienesNMB.codigoRegistro" text="**Tipo registro"/>','${NMBbien.bienEntidad.codigoRegistro}',{labelStyle:labelStyle});
	var refCatastral		= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.referenciaCatastral" text="**Ref. Catastral"/>','${NMBbien.bienEntidad.referenciaCatastralBien}',{labelStyle:labelStyle});
	var inscripcion			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.inscripcion" text="**Inscripción"/>','${NMBbien.bienEntidad.inscripcion}',{labelStyle:labelStyle});
	var fechaInscripcion	= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.fechaInscripcion" text="**Fecha Inscripción"/>','<fwk:date value="${NMBbien.bienEntidad.fechaInscripcion}"/>',{labelStyle:labelStyle});
	var numFinca			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.numFinca" text="**Nº Finca"/>','${NMBbien.bienEntidad.numFinca}',{labelStyle:labelStyle});

	//LOCALIZACION
	var provincia_valor = '';
	<c:if test="${NMBbien.bienEntidad.provincia!=null}">
		provincia_valor = '${NMBbien.bienEntidad.provincia.descripcion}';
	</c:if>
	var poblacion			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.poblacion" text="**Provisión"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.poblacion}" />',{labelStyle:labelStyle});
	var codPostal			= app.creaLabel('<s:message code="plugin.mejoras.bienesNMB.codPostal" text="**Cod. Postal"/>','${NMBbien.bienEntidad.codPostal}',{labelStyle:labelStyle});
	var provincia			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.provincia" text="**Provincia"/>',provincia_valor,{labelStyle:labelStyle});
	
	//---ADICIONALES---
	//cuenta ajena
	var nomEmpresa			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nombreEmpresa" text="**Nombre empresa"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.nomEmpresa}" />',{labelStyle:labelStyle});
	var cifEmpresa			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.cifEmpresa" text="**CIF empresa"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.cifEmpresa}" />',{labelStyle:labelStyle});
	
	//cuenta propia
	var codIAE				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.epigrafeIAE" text="**Código IAE"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.codIAE}" />',{labelStyle:labelStyle});
	var desIAE				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.descripcionIAE" text="**Descripción IAE"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.desIAE}" />',{labelStyle:labelStyle});
	
	//Cuenta bancaria
	var entidad				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.entidad" text="**Entidad"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.entidad}" />',{labelStyle:labelStyle});
	var numCuenta			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nCuenta" text="**Nº Cuenta"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.numCuenta}" />',{labelStyle:labelStyle});
	
	//vehiculo
	var marca				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.marca" text="**Marca"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.marca}" />',{labelStyle:labelStyle});
	var modelo				= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.modelo" text="**Modelo"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.modelo}" />',{labelStyle:labelStyle});
	var matricula			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.matricula" text="**Matricula"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.matricula}" />',{labelStyle:labelStyle});
	var fechaMatricula		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fechaMatriculacion" text="**Fecha matriculación"/>','<fwk:date value="${NMBbien.bienEntidad.fechaMatricula}"/>', {labelStyle:labelStyleAjusteColumnas});
	
	var bastidor			= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.nBastidor" text="**N. Bastidor"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.bastidor}" />',{labelStyle:labelStyle});
	
	//Inmueble
	var tiposInmuebles		= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.tipoInmueble" text="**Tipo Inmueble"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.tipoInmueble.descripcion}" />',{labelStyle:labelStyle});
	
	//activosFinancieros
	var tiposFinancieros	= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.tiposFinaciero" text="**Tipo Financiero"/>', '<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.tipoProdBancario.descripcion}" />',{labelStyle:labelStyle});
	var valorProdBancario	= app.creaLabel('<s:message code="plugin.nuevoModeloBienes.importeValorProdBancario" text="**Valoración"/>',app.format.moneyRenderer('${NMBbien.bienEntidad.valoracion}'),{labelStyle:labelStyle});
	
	// OTROS DATOS
	var numDomicilio = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.numDomicilio" text="**Número del domicilio del bien"/>', '<s:message javaScriptEscape="true" text="${NMBbien.numDomicilio}" />',{labelStyle:labelStyle});
	var idDireccion = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.idDireccion" text="**Identificador de dirección unívoca que tiene dado de alta el bien en la garantía"/>', '<s:message javaScriptEscape="true" text="${NMBbien.idDireccion}" />',{labelStyle:labelStyle});
	var destinoUso = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.destinoUso" text="**Destino uso del bien."/>', '<s:message javaScriptEscape="true" text="${NMBbien.destinoUso}" />',{labelStyle:labelStyle});
	//var secGarantia = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCabecera.otrosDatos.secGarantia" text="**Secuencia de la Garantía de la operación"/>','<fwk:date value="${NMBbien.adicional.fechaMatricula}"/>', {labelStyle:labelStyleAjusteColumnas});
		
	var direccion = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.mejoras.bienesNMB.direccion" text="**Dirección" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.bienEntidad.direccion}" />'
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
	
	var mensajeSolvenciaNoEncontrada	= app.creaLabel('El bien esta marcado como solvencia no encontrada','',{labelStyle:'color:red;width:300px;font-weight:bolder",width:300;'});
	if('${NMBbien.bienEntidad.solvenciaNoEncontrada}' == 'true'){
		solvenciaNoEncontrada.checked = true;
		mensajeSolvenciaNoEncontrada.hidden=false;
	}
	else{
		mensajeSolvenciaNoEncontrada.hidden=true;
		solvenciaNoEncontrada.checked = false;
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
	    ,items : [{items:[mensajeSolvenciaNoEncontrada, origen, codigoInterno ,codBien, tipoBien, solvenciaNoEncontrada]},
				  {items:[Descripcion]}
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
	    ,items : [{items:[fechaVerificacion, valorActual, ValorTotalCargas, fechaValSubjetivo, valorSubjetivo]},
				  {items:[fechaValApreciacion, valorApreciacion, fechaValTasacion, valorTasacion]}
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
	    ,items : [{items:[tiposInmuebles, supTerreno, supConstruida, tomo, libro, folio, minicipioRegistro]},
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
	    ,items : [{items:[provincia, poblacion, codPostal]},
				  {items:[direccion]}
				 ]
	});
	
	var pestanaOtros = new Ext.form.FieldSet({
		autoHeight:true
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
					,width:760
					,title : '<s:message code="app.editarRegistro" text="**Editar bien" />'
					,params : {id:${NMBbien.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.bienEntidad.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
	</sec:authorize>
	
	var listaTabsTipo = [pestanaPrincipal, pestanaLocalizacion, pestanaObservaciones];
	var tabsEncontrados = false;
	<c:forEach items="${tabsTipoBien}" var="entry">
		<c:if test="${((NMBbien.bienEntidad.tipoBien.codigo != null) && (entry.key == NMBbien.bienEntidad.tipoBien.codigo)) || ((NMBbien.bienEntidad.tipoBien.codigo == null) && (entry.key == NMBbien.tipoBien.codigo))}">
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
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabDatosEntidad.titulo" text="**Datos Entidad"/>'
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
		,nombreTab : 'datosEntidad'
		,bbar:new Ext.Toolbar()
	});
	
	return panel;
})()