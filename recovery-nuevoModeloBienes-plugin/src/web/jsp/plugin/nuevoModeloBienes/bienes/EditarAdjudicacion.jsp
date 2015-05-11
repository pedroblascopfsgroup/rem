<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	//var labelStyleDescripcion = 'width:185x;height:60px;font-weight:bolder",width:700';
	var labelStyleTextArea = 'font-weight:bolder",width:500';

	
	var idAdjudicacion = app.creaLabel('<s:message code="bienesAdjudicacion.idAdjudicacion" text="**idAdjudicacion"/>','${NMBbien.adjudicacion.idAdjudicacion}', {labelStyle:labelStyle});
	var bien = app.creaLabel('<s:message code="bienesAdjudicacion.idBien" text="**idBien"/>','${NMBbien.id}', {labelStyle:labelStyle});
		
	// fechas 
	var fechaDecretoNoFirme =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaDecretoNoFirme" text="**fechaDecretoNoFirme" />'
			,labelStyle: labelStyle
			,name:'bien.fechaDecretoNoFirme'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaDecretoNoFirme}"/>'
			,style:'margin:0px'		
		});
	
	var fechaDecretoFirme =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaDecretoFirme" text="**fechaDecretoFirme" />'
			,labelStyle: labelStyle
			,name:'bien.fechaDecretoFirme'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaDecretoFirme}"/>'
			,style:'margin:0px'		
		});	
	
	var fechaEntregaGestor =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaEntregaGestor" text="**fechaEntregaGestor" />'
			,labelStyle: labelStyle
			,name:'bien.fechaEntregaGestor'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaEntregaGestor}"/>'
			,style:'margin:0px'		
		});
	
	var fechaPresentacionHacienda =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaPresentacionHacienda" text="**fechaPresentacionHacienda" />'
			,labelStyle: labelStyle
			,name:'bien.fechaPresentacionHacienda'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaPresentacionHacienda}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSegundaPresentacion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSegundaPresentacion" text="**fechaSegundaPresentacion" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSegundaPresentacion'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSegundaPresentacion}"/>'
			,style:'margin:0px'		
		});
		
	var txtImporteAdjudicacion = app.creaMoneda("importeAdjudicacion", 
			'<s:message code="bienesAdjudicacion.importeAdjudicacion" text="**Importe adjudicaci�n"/>',
			'${NMBbien.adjudicacion.importeAdjudicacion}',
			{width:80,maxLength:16,labelStyle:labelStyle 
	});
	
	var importeCesionRemate = app.creaMoneda("importeCesionRemate", 
			'<s:message code="bienesAdjudicacion.importeCesionRemate" text="**importeCesionRemate"/>',
			'${NMBbien.adjudicacion.importeCesionRemate}',
			{width:80,maxLength:16,labelStyle:labelStyle 
	});
	
	var fechaRecepcionTitulo =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaRecepcionTitulo" text="**fechaRecepcionTitulo" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRecepcionTitulo'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionTitulo}"/>'
			,style:'margin:0px'		
		});
			
	var fechaInscripcionTitulo =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaInscripcionTitulo" text="**fechaInscripcionTitulo" />'
			,labelStyle: labelStyle
			,name:'bien.fechaInscripcionTitulo'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaInscripcionTitulo}"/>'
			,style:'margin:0px'		
		});
	
	var fechaEnvioAdicion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaEnvioAdicion" text="**fechaEnvioAdicion" />'
			,labelStyle: labelStyle
			,name:'bien.fechaEnvioAdicion'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaEnvioAdicion}"/>'
			,style:'margin:0px'		
		});
	
	var fechaPresentacionRegistro =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaPresentacionRegistro" text="**fechaPresentacionRegistro" />'
			,labelStyle: labelStyle
			,name:'bien.fechaPresentacionRegistro'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaPresentacionRegistro}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSolicitudPosesion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSolicitudPosesion" text="**fechaSolicitudPosesion" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSolicitudPosesion'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudPosesion}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSenalamientoPosesion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSenalamientoPosesion" text="**fechaSenalamientoPosesion" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSenalamientoPosesion'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSenalamientoPosesion}"/>'
			,style:'margin:0px'		
		});
	
	var fechaRealizacionPosesion =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaRealizacionPosesion" text="**fechaRealizacionPosesion" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRealizacionPosesion'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaRealizacionPosesion}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSolicitudLanzamiento =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSolicitudLanzamiento" text="**fechaSolicitudLanzamiento" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSolicitudLanzamiento'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudLanzamiento}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSenalamientoLanzamiento =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSenalamientoLanzamiento" text="**fechaSenalamientoLanzamiento" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSenalamientoLanzamiento'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSenalamientoLanzamiento}"/>'
			,style:'margin:0px'		
		});
	
	var fechaRealizacionLanzamiento =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaRealizacionLanzamiento" text="**fechaRealizacionLanzamiento" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRealizacionLanzamiento'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaRealizacionLanzamiento}"/>'
			,style:'margin:0px'		
		});
	
	var fechaSolicitudMoratoria =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaSolicitudMoratoria" text="**fechaSolicitudMoratoria" />'
			,labelStyle: labelStyle
			,name:'bien.fechaSolicitudMoratoria'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudMoratoria}"/>'
			,style:'margin:0px'		
		});
	
	var fechaResolucionMoratoria =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaResolucionMoratoria" text="**fechaResolucionMoratoria" />'
			,labelStyle: labelStyle
			,name:'bien.fechaResolucionMoratoria'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaResolucionMoratoria}"/>'
			,style:'margin:0px'		
		});
	
	var fechaContratoArrendamiento =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaContratoArrendamiento" text="**fechaContratoArrendamiento" />'
			,labelStyle: labelStyle
			,name:'bien.fechaContratoArrendamiento'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaContratoArrendamiento}"/>'
			,style:'margin:0px'		
		});
	
	var fechaCambioCerradura =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaCambioCerradura" text="**fechaCambioCerradura" />'
			,labelStyle: labelStyle
			,name:'bien.fechaCambioCerradura'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaCambioCerradura}"/>'
			,style:'margin:0px'		
		});
	
	var fechaEnvioLLaves =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaEnvioLLaves" text="**fechaEnvioLLaves" />'
			,labelStyle: labelStyle
			,name:'bien.fechaEnvioLLaves'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaEnvioLLaves}"/>'
			,style:'margin:0px'		
		});
	
	var fechaRecepcionDepositario =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaRecepcionDepositario" text="**fechaRecepcionDepositario" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRecepcionDepositario'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionDepositario}"/>'
			,style:'margin:0px'		
		});
	
	var fechaEnvioDepositario =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaEnvioDepositario" text="**fechaEnvioDepositario" />'
			,labelStyle: labelStyle
			,name:'bien.fechaEnvioDepositario'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaEnvioDepositario}"/>'
			,style:'margin:0px'		
		});
			
	var fechaRecepcionDepositarioFinal =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="bienesAdjudicacion.fechaRecepcionDepositarioFinal" text="**fechaRecepcionDepositarioFinal" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRecepcionDepositarioFinal'
			,value:	'<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionDepositarioFinal}"/>'
			,style:'margin:0px'		
		});
	
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
	
	//booleanos
		
	var ocupado = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'ocupado'
			,fieldLabel:'<s:message code="bienesAdjudicacion.ocupado" text="**ocupado"/>'
			,value : '${NMBbien.adjudicacion.ocupado}' == '' ? '' : '${NMBbien.adjudicacion.ocupado}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});

	var posiblePosesion = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'posiblePosesion'
			,fieldLabel:'<s:message code="bienesAdjudicacion.posiblePosesion" text="**posiblePosesion"/>'
			,value : '${NMBbien.adjudicacion.posiblePosesion}' == '' ? '' : '${NMBbien.adjudicacion.posiblePosesion}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
	
	var ocupantesDiligencia = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'ocupantesDiligencia'
			,fieldLabel:'<s:message code="bienesAdjudicacion.ocupantesDiligencia" text="**ocupantesDiligencia"/>'
			,value : '${NMBbien.adjudicacion.ocupantesDiligencia}' == '' ? '' : '${NMBbien.adjudicacion.ocupantesDiligencia}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
		
	var lanzamientoNecesario = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'lanzamientoNecesario'
			,fieldLabel:'<s:message code="bienesAdjudicacion.lanzamientoNecesario" text="**lanzamientoNecesario"/>'
			,value : '${NMBbien.adjudicacion.lanzamientoNecesario}' == '' ? '' : '${NMBbien.adjudicacion.lanzamientoNecesario}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
		
	var entregaVoluntaria = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'lanzamientoNecesario'
			,fieldLabel:'<s:message code="bienesAdjudicacion.entregaVoluntaria" text="**entregaVoluntaria"/>'
			,value : '${NMBbien.adjudicacion.entregaVoluntaria}' == '' ? '' : '${NMBbien.adjudicacion.entregaVoluntaria}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
			
	var necesariaFuerzaPublica = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'necesariaFuerzaPublica'
			,fieldLabel:'<s:message code="bienesAdjudicacion.necesariaFuerzaPublica" text="**necesariaFuerzaPublica"/>'
			,value : '${NMBbien.adjudicacion.necesariaFuerzaPublica}' == '' ? '' : '${NMBbien.adjudicacion.necesariaFuerzaPublica}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
			
	var existeInquilino = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'existeInquilino'
			,fieldLabel:'<s:message code="bienesAdjudicacion.existeInquilino" text="**existeInquilino"/>'
			,value : '${NMBbien.adjudicacion.existeInquilino}' == '' ? '' : '${NMBbien.adjudicacion.existeInquilino}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
		
	
	var llavesNecesarias = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'llavesNecesarias'
			,fieldLabel:'<s:message code="bienesAdjudicacion.llavesNecesarias" text="**llavesNecesarias"/>'
			,value : '${NMBbien.adjudicacion.llavesNecesarias}' == '' ? '' : '${NMBbien.adjudicacion.llavesNecesarias}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});		
		
	var cesionRemate = new Ext.form.ComboBox({
			store: sinoStore
			,mode:'local'
			,displayField: 'descripcion'
			,valueField: 'codigo'
			,resizable: false
			,triggerAction : 'all'
			,name : 'cesionRemate'
			,fieldLabel:'<s:message code="bienesAdjudicacion.cesionRemate" text="**cesionRemate"/>'
			,value : '${NMBbien.adjudicacion.cesionRemate}' == '' ? '' : '${NMBbien.adjudicacion.cesionRemate}' == 'true' ? 'Si' : 'No'
			,labelStyle:labelStyle
			,width: 100		
	});	
		
	//selector persona
	var Gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	
	var optionsGestoresStore =  page.getStore({
	       flow: 'editbien/getListUsuariosData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, Gestor)	       
	});
	
	optionsGestoresStore.webflow();
      
    var gestoriaAdjudicataria = new Ext.form.ComboBox( {
			store : optionsGestoresStore
			,name : 'gestoriaAdjudicataria'
			,valueField: 'id'
			,displayField: 'username'
			,fieldLabel : '<s:message code="bienesAdjudicacion.gestoriaAdjudicataria" text="**gestoriaAdjudicataria"/>'
			,value : '${NMBbien.adjudicacion.gestoriaAdjudicataria.id}'
			,labelStyle:labelStyle
			,width: 150
			
		});
	
	
	// textos
	var  nombreArrendatario = app.creaText('nombreArrendatario','<s:message code="bienesAdjudicacion.nombreArrendatario" text="**nombreArrendatario"/>','${NMBbien.adjudicacion.nombreArrendatario}', {labelStyle:labelStyle});
	var  nombreDepositario = app.creaText('nombreDepositario','<s:message code="bienesAdjudicacion.nombreDepositario" text="**nombreDepositario"/>','${NMBbien.adjudicacion.nombreDepositario}', {labelStyle:labelStyle});
	var  nombreDepositarioFinal = app.creaText('nombreDepositarioFinal','<s:message code="bienesAdjudicacion.nombreDepositarioFinal" text="**nombreDepositarioFinal"/>','${NMBbien.adjudicacion.nombreDepositarioFinal}', {labelStyle:labelStyle});
	//var  fondo = app.creaText('fondo','<s:message code="bienesAdjudicacion.fondo" text="**fondo"/>','${NMBbien.adjudicacion.fondo}', {labelStyle:labelStyle});
	
	//DICCIONARIOS
	var fondo = app.creaCombo({
			data : <app:dict value="${fondo}" />
			<app:test id="fondoCombo" addComa="true" />
			,name : 'fondo'
			,fieldLabel : '<s:message code="bienesAdjudicacion.fondo" text="**fondo" />'
			,value : '${NMBbien.adjudicacion.fondo.codigo}'
			,labelStyle:labelStyle
			,width: 150
			
		});	
	
	var entidadAdjudicataria = app.creaCombo({
			data : <app:dict value="${entidadAdjudicataria}" />
			<app:test id="entidadAdjudicatariaCombo" addComa="true" />
			,name : 'entidadAdjudicataria'
			,fieldLabel : '<s:message code="bienesAdjudicacion.entidadAdjudicataria" text="**entidadAdjudicataria" />'
			,value : '${NMBbien.adjudicacion.entidadAdjudicataria.codigo}'
			,labelStyle:labelStyle
			,width: 150
			
		});
	
	var situacionTitulo = app.creaCombo({
			data : <app:dict value="${situacionTitulo}" />
			<app:test id="situacionTituloCombo" addComa="true" />
			,name : 'situacionTitulo'
			,fieldLabel : '<s:message code="bienesAdjudicacion.situacionTitulo" text="**situacionTitulo" />'
			,value : '${NMBbien.adjudicacion.situacionTitulo.codigo}'
			,labelStyle:labelStyle
			,width: 150
			
		});
	
	var resolucionMoratoria = app.creaCombo({
			data : <app:dict value="${resolucionMoratoria}" />
			<app:test id="resolucionMoratoriaCombo" addComa="true" />
			,name : 'resolucionMoratoria'
			,fieldLabel : '<s:message code="bienesAdjudicacion.resolucionMoratoria" text="**resolucionMoratoria" />'
			,value : '${NMBbien.adjudicacion.resolucionMoratoria.codigo}'
			,labelStyle:labelStyle
			,width: 150
			
		});
		
		
	var getParametros = function() {
		
	 	var parametros = {};
	 	parametros.id='${NMBbien.id}';
	 	parametros.idAdjudicacion = '${NMBbien.adjudicacion.idAdjudicacion}';
		
		// fechas 
		parametros.fechaDecretoNoFirme = fechaDecretoNoFirme.getValue() ? fechaDecretoNoFirme.getValue().format('d/m/Y') : '';
		parametros.fechaDecretoFirme = fechaDecretoFirme.getValue() ? fechaDecretoFirme.getValue().format('d/m/Y') : '';
		parametros.fechaEntregaGestor = fechaEntregaGestor.getValue() ? fechaEntregaGestor.getValue().format('d/m/Y') : '';
		parametros.fechaPresentacionHacienda = fechaPresentacionHacienda.getValue() ? fechaPresentacionHacienda.getValue().format('d/m/Y') : '';
		parametros.fechaSegundaPresentacion = fechaSegundaPresentacion.getValue() ? fechaSegundaPresentacion.getValue().format('d/m/Y') : '';
		parametros.fechaRecepcionTitulo = fechaRecepcionTitulo.getValue() ? fechaRecepcionTitulo.getValue().format('d/m/Y') : '';
		parametros.fechaInscripcionTitulo = fechaInscripcionTitulo.getValue() ? fechaInscripcionTitulo.getValue().format('d/m/Y') : '';
		parametros.fechaEnvioAdicion = fechaEnvioAdicion.getValue() ? fechaEnvioAdicion.getValue().format('d/m/Y') : '';
		parametros.fechaPresentacionRegistro = fechaPresentacionRegistro.getValue() ? fechaPresentacionRegistro.getValue().format('d/m/Y') : ''; 
		parametros.fechaSolicitudPosesion = fechaSolicitudPosesion.getValue() ? fechaSolicitudPosesion.getValue().format('d/m/Y') : '';
		parametros.fechaSenalamientoPosesion = fechaSenalamientoPosesion.getValue() ? fechaSenalamientoPosesion.getValue().format('d/m/Y') : '';
		parametros.fechaRealizacionPosesion = fechaRealizacionPosesion.getValue() ? fechaRealizacionPosesion.getValue().format('d/m/Y') : '';
		parametros.fechaSolicitudLanzamiento = fechaSolicitudLanzamiento.getValue() ? fechaSolicitudLanzamiento.getValue().format('d/m/Y') : '';
		parametros.fechaSenalamientoLanzamiento = fechaSenalamientoLanzamiento.getValue() ? fechaSenalamientoLanzamiento.getValue().format('d/m/Y') : '';
		parametros.fechaRealizacionLanzamiento = fechaRealizacionLanzamiento.getValue() ? fechaRealizacionLanzamiento.getValue().format('d/m/Y') : '';
		parametros.fechaSolicitudMoratoria = fechaSolicitudMoratoria.getValue() ? fechaSolicitudMoratoria.getValue().format('d/m/Y') : '';
		parametros.fechaResolucionMoratoria = fechaResolucionMoratoria.getValue() ? fechaResolucionMoratoria.getValue().format('d/m/Y') : '';
		parametros.fechaContratoArrendamiento = fechaContratoArrendamiento.getValue() ? fechaContratoArrendamiento.getValue().format('d/m/Y') : '';
		parametros.fechaCambioCerradura = fechaCambioCerradura.getValue() ? fechaCambioCerradura.getValue().format('d/m/Y') : '';
		parametros.fechaEnvioLLaves = fechaEnvioLLaves.getValue() ? fechaEnvioLLaves.getValue().format('d/m/Y') : '';
		parametros.fechaRecepcionDepositario = fechaRecepcionDepositario.getValue() ? fechaRecepcionDepositario.getValue().format('d/m/Y') : '';
		parametros.fechaEnvioDepositario = fechaEnvioDepositario.getValue() ? fechaEnvioDepositario.getValue().format('d/m/Y') : '';
		parametros.fechaRecepcionDepositarioFinal = fechaRecepcionDepositarioFinal.getValue() ? fechaRecepcionDepositarioFinal.getValue().format('d/m/Y') : '';
		
	    parametros.ocupado = ocupado.getValue() == '' ? null : ocupado.getValue() == 'Si' || ocupado.getValue() == '01' ? true : false ;
		parametros.posiblePosesion = posiblePosesion.getValue() == '' ? null : posiblePosesion.getValue() == 'Si' || posiblePosesion.getValue() == '01'? true : false ;
		parametros.ocupantesDiligencia = ocupantesDiligencia.getValue() == '' ? null : ocupantesDiligencia.getValue() == 'Si' || ocupantesDiligencia.getValue() == '01' ? true : false ;
		parametros.lanzamientoNecesario = lanzamientoNecesario.getValue() == '' ? null : lanzamientoNecesario.getValue() == 'Si' || lanzamientoNecesario.getValue() == '01' ? true : false ;
		parametros.entregaVoluntaria = entregaVoluntaria.getValue() == '' ? null : entregaVoluntaria.getValue() == 'Si' || entregaVoluntaria.getValue() == '01' ? true : false ;
		parametros.necesariaFuerzaPublica = necesariaFuerzaPublica.getValue() == '' ? null : necesariaFuerzaPublica.getValue() == 'Si' || necesariaFuerzaPublica.getValue() == '01' ? true : false ;
		parametros.existeInquilino = existeInquilino.getValue() == '' ? null : existeInquilino.getValue() == 'Si' || existeInquilino.getValue() == '01' ? true : false ;
		parametros.llavesNecesarias = llavesNecesarias.getValue() == '' ? null : llavesNecesarias.getValue() == 'Si' || llavesNecesarias.getValue() == '01' ? true : false ;
		parametros.cesionRemate = cesionRemate.getValue() == '' ? null : cesionRemate.getValue() == 'Si' || cesionRemate.getValue() == '01' ? true : false ;
		
		//selector persona
		parametros.gestoriaAdjudicataria = gestoriaAdjudicataria.getValue();
		
		// textos
		parametros.nombreArrendatario = nombreArrendatario.getValue();
		parametros.nombreDepositario = nombreDepositario.getValue();
		parametros.nombreDepositarioFinal = nombreDepositarioFinal.getValue();
		//parametros.fondo = fondo.getValue();
		
		// importes
		parametros.importeAdjudicacion = txtImporteAdjudicacion.getValue();
		parametros.importeCesionRemate = importeCesionRemate.getValue();
		
		//DICCIONARIOS
		parametros.entidadAdjudicataria = entidadAdjudicataria.getValue();
		parametros.situacionTitulo = situacionTitulo.getValue();
		parametros.resolucionMoratoria = resolucionMoratoria.getValue();
		parametros.fondo = fondo.getValue();
	 	
	 	return parametros;
	 }	

	var datosAdjudicacion = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.datosEconomicos.titulo" text="**Datos de adjudicaci�n"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[fechaDecretoNoFirme,fechaDecretoFirme,gestoriaAdjudicataria,fechaEntregaGestor,fechaPresentacionHacienda,fechaSegundaPresentacion, txtImporteAdjudicacion]},
				  {items:[entidadAdjudicataria,fondo,fechaPresentacionRegistro,fechaRecepcionTitulo,fechaInscripcionTitulo,fechaEnvioAdicion,situacionTitulo,cesionRemate,importeCesionRemate]}
				 ]
	});
	
	var datosPosesion = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.datosPosesion.titulo" text="**Datos de posesi�n"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[ocupado,posiblePosesion,fechaSolicitudPosesion,fechaSenalamientoPosesion,fechaRealizacionPosesion,
	ocupantesDiligencia,lanzamientoNecesario,fechaSolicitudLanzamiento,fechaSenalamientoLanzamiento,fechaRealizacionLanzamiento]},
				  {items:[fechaSolicitudMoratoria,resolucionMoratoria,fechaResolucionMoratoria,necesariaFuerzaPublica,existeInquilino,fechaContratoArrendamiento,nombreArrendatario]}
				 ]
	});

	var gestionLLaves = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.gestionLLaves.titulo" text="**Gesti�n de llaves"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[llavesNecesarias,fechaCambioCerradura,nombreDepositario,fechaEnvioLLaves]},
				  {items:[fechaRecepcionDepositario,nombreDepositarioFinal,fechaEnvioDepositario,fechaRecepcionDepositarioFinal]}
				 ]
	});	
	
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		var btnEditar = new Ext.Button({
		    text: '<s:message code="app.guardar" text="**Guardar" />'
			<app:test id="btnEditarSolvencia" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		    	var p = getParametros();
		    	Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveAdjudicacion'), 
						params : p ,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
	        }
		});
	</sec:authorize>
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	 

	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		autoScroll:true
		,width:800
		,height:600
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items : [datosAdjudicacion,datosPosesion,gestionLLaves]
		,nombreTab : 'adjudicacion'
		,bbar:new Ext.Toolbar()
	});
	
	//Se deshabilita por defecto casi todo

	fechaDecretoNoFirme.setDisabled(true);
	fechaDecretoFirme.setDisabled(true);
	gestoriaAdjudicataria.setDisabled(false);
	fechaEntregaGestor.setDisabled(true);
	fechaPresentacionHacienda.setDisabled(true);
	fechaSegundaPresentacion.setDisabled(true); 
	txtImporteAdjudicacion.setDisabled(false);
	cesionRemate.setDisabled(false);
	importeCesionRemate.setDisabled(false);
    entidadAdjudicataria.setDisabled(false);
    fondo.setDisabled(true);
    fechaPresentacionRegistro.setDisabled(true);
    fechaRecepcionTitulo.setDisabled(true);
    fechaInscripcionTitulo.setDisabled(true);
    fechaEnvioAdicion.setDisabled(true);
    situacionTitulo.setDisabled(false);
	ocupado.setDisabled(true);
	posiblePosesion.setDisabled(true);
	fechaSolicitudPosesion.setDisabled(true);
	fechaSenalamientoPosesion.setDisabled(true);
	fechaRealizacionPosesion.setDisabled(true);
    ocupantesDiligencia.setDisabled(true);
    lanzamientoNecesario.setDisabled(true);
    fechaSolicitudLanzamiento.setDisabled(true);
    fechaSenalamientoLanzamiento.setDisabled(true);
    fechaRealizacionLanzamiento.setDisabled(true);
	fechaSolicitudMoratoria.setDisabled(true);
	resolucionMoratoria.setDisabled(true);
	fechaResolucionMoratoria.setDisabled(true);
	necesariaFuerzaPublica.setDisabled(true);
	existeInquilino.setDisabled(true);
	fechaContratoArrendamiento.setDisabled(true);
	nombreArrendatario.setDisabled(true);
	llavesNecesarias.setDisabled(true);
	fechaCambioCerradura.setDisabled(true);
	nombreDepositario.setDisabled(true);
	fechaEnvioLLaves.setDisabled(true);
	fechaRecepcionDepositario.setDisabled(true);
	nombreDepositarioFinal.setDisabled(true);
	fechaEnvioDepositario.setDisabled(true);
	fechaRecepcionDepositarioFinal.setDisabled(true);
	
	<sec:authorize ifAllGranted="BIEN_ADJUDICACION_EDITAR">
		fechaDecretoNoFirme.setDisabled(false);
		fechaDecretoFirme.setDisabled(false);
		gestoriaAdjudicataria.setDisabled(false);
		fechaEntregaGestor.setDisabled(false);
		fechaPresentacionHacienda.setDisabled(false);
		fechaSegundaPresentacion.setDisabled(false); 
		txtImporteAdjudicacion.setDisabled(false);
		cesionRemate.setDisabled(false);
		importeCesionRemate.setDisabled(false);
	    entidadAdjudicataria.setDisabled(false);
	    fondo.setDisabled(false);
	    fechaPresentacionRegistro.setDisabled(false);
	    fechaRecepcionTitulo.setDisabled(false);
	    fechaInscripcionTitulo.setDisabled(false);
	    fechaEnvioAdicion.setDisabled(false);
	    situacionTitulo.setDisabled(false);
		ocupado.setDisabled(false);
		posiblePosesion.setDisabled(false);
		fechaSolicitudPosesion.setDisabled(false);
		fechaSenalamientoPosesion.setDisabled(false);
		fechaRealizacionPosesion.setDisabled(false);
	    ocupantesDiligencia.setDisabled(false);
	    lanzamientoNecesario.setDisabled(false);
	    fechaSolicitudLanzamiento.setDisabled(false);
	    fechaSenalamientoLanzamiento.setDisabled(false);
	    fechaRealizacionLanzamiento.setDisabled(false);
		fechaSolicitudMoratoria.setDisabled(false);
		resolucionMoratoria.setDisabled(false);
		fechaResolucionMoratoria.setDisabled(false);
		necesariaFuerzaPublica.setDisabled(false);
		existeInquilino.setDisabled(false);
		fechaContratoArrendamiento.setDisabled(false);
		nombreArrendatario.setDisabled(false);
		llavesNecesarias.setDisabled(false);
		fechaCambioCerradura.setDisabled(false);
		nombreDepositario.setDisabled(false);
		fechaEnvioLLaves.setDisabled(false);
		fechaRecepcionDepositario.setDisabled(false);
		nombreDepositarioFinal.setDisabled(false);
		fechaEnvioDepositario.setDisabled(false);
		fechaRecepcionDepositarioFinal.setDisabled(false);	
	</sec:authorize>
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
	 	panel.getBottomToolbar().addButton([btnEditar]);
	</sec:authorize> 
	
	panel.getBottomToolbar().addButton([btnCancelar]);
	
		
	page.add(panel);
	
</fwk:page>