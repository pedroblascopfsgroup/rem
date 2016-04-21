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

	
	var idAdjudicacion = app.creaLabel('<s:message code="bienesAdjudicacion.idAdjudicacion" text="**idAdjudicacion"/>','${NMBbien.adjudicacion.idAdjudicacion}', {labelStyle:labelStyle});
	var bien = app.creaLabel('<s:message code="bienesAdjudicacion.idBien" text="**idBien"/>','${NMBbien.id}', {labelStyle:labelStyle});
		
	// fechas 
	var  fechaDecretoNoFirme = app.creaLabel('<s:message code="bienesAdjudicacion.fechaDecretoNoFirme" text="**fechaDecretoNoFirme"/>','<fwk:date value="${NMBbien.adjudicacion.fechaDecretoNoFirme}"/>', {labelStyle:labelStyle});
	var  fechaDecretoFirme = app.creaLabel('<s:message code="bienesAdjudicacion.fechaDecretoFirme" text="**fechaDecretoFirme"/>','<fwk:date value="${NMBbien.adjudicacion.fechaDecretoFirme}"/>', {labelStyle:labelStyle});
	var  fechaEntregaGestor = app.creaLabel('<s:message code="bienesAdjudicacion.fechaEntregaGestor" text="**fechaEntregaGestor"/>','<fwk:date value="${NMBbien.adjudicacion.fechaEntregaGestor}"/>', {labelStyle:labelStyle});
	var  fechaPresentacionHacienda = app.creaLabel('<s:message code="bienesAdjudicacion.fechaPresentacionHacienda" text="**fechaPresentacionHacienda"/>','<fwk:date value="${NMBbien.adjudicacion.fechaPresentacionHacienda}"/>', {labelStyle:labelStyle});
	var  fechaSegundaPresentacion = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSegundaPresentacion" text="**fechaSegundaPresentacion"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSegundaPresentacion}"/>', {labelStyle:labelStyle});
	var  fechaRecepcionTitulo = app.creaLabel('<s:message code="bienesAdjudicacion.fechaRecepcionTitulo" text="**fechaRecepcionTitulo"/>','<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionTitulo}"/>', {labelStyle:labelStyle});
	var  fechaInscripcionTitulo = app.creaLabel('<s:message code="bienesAdjudicacion.fechaInscripcionTitulo" text="**fechaInscripcionTitulo"/>','<fwk:date value="${NMBbien.adjudicacion.fechaInscripcionTitulo}"/>', {labelStyle:labelStyle});
	var  fechaEnvioAdicion = app.creaLabel('<s:message code="bienesAdjudicacion.fechaEnvioAdicion" text="**fechaEnvioAdicion"/>','<fwk:date value="${NMBbien.adjudicacion.fechaEnvioAdicion}"/>', {labelStyle:labelStyle});
	var  fechaPresentacionRegistro = app.creaLabel('<s:message code="bienesAdjudicacion.fechaPresentacionRegistro" text="**fechaPresentacionRegistro"/>','<fwk:date value="${NMBbien.adjudicacion.fechaPresentacionRegistro}"/>', {labelStyle:labelStyle});
	var  fechaSolicitudPosesion = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSolicitudPosesion" text="**fechaSolicitudPosesion"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudPosesion}"/>', {labelStyle:labelStyle});
	var  fechaSenalamientoPosesion = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSenalamientoPosesion" text="**fechaSenalamientoPosesion"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSenalamientoPosesion}"/>', {labelStyle:labelStyle});
	var  fechaRealizacionPosesion = app.creaLabel('<s:message code="bienesAdjudicacion.fechaRealizacionPosesion" text="**fechaRealizacionPosesion"/>','<fwk:date value="${NMBbien.adjudicacion.fechaRealizacionPosesion}"/>', {labelStyle:labelStyle});
	var  fechaSolicitudLanzamiento = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSolicitudLanzamiento" text="**fechaSolicitudLanzamiento"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudLanzamiento}"/>', {labelStyle:labelStyle});
	var  fechaSenalamientoLanzamiento = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSenalamientoLanzamiento" text="**fechaSenalamientoLanzamiento"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSenalamientoLanzamiento}"/>', {labelStyle:labelStyle});
	var  fechaRealizacionLanzamiento = app.creaLabel('<s:message code="bienesAdjudicacion.fechaRealizacionLanzamiento" text="**fechaRealizacionLanzamiento"/>','<fwk:date value="${NMBbien.adjudicacion.fechaRealizacionLanzamiento}"/>', {labelStyle:labelStyle});
	var  fechaSolicitudMoratoria = app.creaLabel('<s:message code="bienesAdjudicacion.fechaSolicitudMoratoria" text="**fechaSolicitudMoratoria"/>','<fwk:date value="${NMBbien.adjudicacion.fechaSolicitudMoratoria}"/>', {labelStyle:labelStyle});
	var  fechaResolucionMoratoria = app.creaLabel('<s:message code="bienesAdjudicacion.fechaResolucionMoratoria" text="**fechaResolucionMoratoria"/>','<fwk:date value="${NMBbien.adjudicacion.fechaResolucionMoratoria}"/>', {labelStyle:labelStyle});
	var  fechaContratoArrendamiento = app.creaLabel('<s:message code="bienesAdjudicacion.fechaContratoArrendamiento" text="**fechaContratoArrendamiento"/>','<fwk:date value="${NMBbien.adjudicacion.fechaContratoArrendamiento}"/>', {labelStyle:labelStyle});
	var  fechaCambioCerradura = app.creaLabel('<s:message code="bienesAdjudicacion.fechaCambioCerradura" text="**fechaCambioCerradura"/>','<fwk:date value="${NMBbien.adjudicacion.fechaCambioCerradura}"/>', {labelStyle:labelStyle});
	var  fechaEnvioLLaves = app.creaLabel('<s:message code="bienesAdjudicacion.fechaEnvioLLaves" text="**fechaEnvioLLaves"/>','<fwk:date value="${NMBbien.adjudicacion.fechaEnvioLLaves}"/>', {labelStyle:labelStyle});
	var  fechaRecepcionDepositario = app.creaLabel('<s:message code="bienesAdjudicacion.fechaRecepcionDepositario" text="**fechaRecepcionDepositario"/>','<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionDepositario}"/>', {labelStyle:labelStyle});
	var  fechaEnvioDepositario = app.creaLabel('<s:message code="bienesAdjudicacion.fechaEnvioDepositario" text="**fechaEnvioDepositario"/>','<fwk:date value="${NMBbien.adjudicacion.fechaEnvioDepositario}"/>', {labelStyle:labelStyle});
	var  fechaRecepcionDepositarioFinal = app.creaLabel('<s:message code="bienesAdjudicacion.fechaRecepcionDepositarioFinal" text="**fechaRecepcionDepositarioFinal"/>','<fwk:date value="${NMBbien.adjudicacion.fechaRecepcionDepositarioFinal}"/>', {labelStyle:labelStyle});
	var  fechaContabilidad = app.creaLabel('<s:message code="bienesAdjudicacion.fechaContabilidad" text="**fechaContabilidad"/>','<fwk:date value="${NMBbien.adjudicacion.fechaContabilidad}"/>', {labelStyle:labelStyle});
	
	
	//booleanos
	var  ocupado = app.creaLabel('<s:message code="bienesAdjudicacion.ocupado" text="**ocupado"/>','${NMBbien.adjudicacion.ocupado != null ? NMBbien.adjudicacion.ocupado ? 'Si' : 'No' : ''} ', {labelStyle:labelStyle});
	var  posiblePosesion = app.creaLabel('<s:message code="bienesAdjudicacion.posiblePosesion" text="**posiblePosesion"/>','${NMBbien.adjudicacion.posiblePosesion != null ? NMBbien.adjudicacion.posiblePosesion ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  ocupantesDiligencia = app.creaLabel('<s:message code="bienesAdjudicacion.ocupantesDiligencia" text="**ocupantesDiligencia"/>','${NMBbien.adjudicacion.ocupantesDiligencia != null ? NMBbien.adjudicacion.ocupantesDiligencia ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  lanzamientoNecesario  = app.creaLabel('<s:message code="bienesAdjudicacion.lanzamientoNecesario" text="**lanzamientoNecesario"/>','${NMBbien.adjudicacion.lanzamientoNecesario != null ? NMBbien.adjudicacion.lanzamientoNecesario ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  entregaVoluntaria = app.creaLabel('<s:message code="bienesAdjudicacion.entregaVoluntaria" text="**entregaVoluntaria"/>','${NMBbien.adjudicacion.entregaVoluntaria != null ? NMBbien.adjudicacion.entregaVoluntaria ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  necesariaFuerzaPublica = app.creaLabel('<s:message code="bienesAdjudicacion.necesariaFuerzaPublica" text="**necesariaFuerzaPublica"/>','${NMBbien.adjudicacion.necesariaFuerzaPublica != null ? NMBbien.adjudicacion.necesariaFuerzaPublica ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  existeInquilino = app.creaLabel('<s:message code="bienesAdjudicacion.existeInquilino" text="**existeInquilino"/>','${NMBbien.adjudicacion.existeInquilino != null ? NMBbien.adjudicacion.existeInquilino ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  llavesNecesarias = app.creaLabel('<s:message code="bienesAdjudicacion.llavesNecesarias" text="**llavesNecesarias"/>','${NMBbien.adjudicacion.llavesNecesarias != null ? NMBbien.adjudicacion.llavesNecesarias ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  cesionRemate = app.creaLabel('<s:message code="bienesAdjudicacion.cesionRemate" text="**cesionRemate"/>','${NMBbien.adjudicacion.cesionRemate != null ? NMBbien.adjudicacion.cesionRemate ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	var  postores = app.creaLabel('<s:message code="bienesAdjudicacion.postores" text="**Con postores"/>','${NMBbien.adjudicacion.postores != null ? NMBbien.adjudicacion.postores ? 'Si' : 'No' : ''}', {labelStyle:labelStyle});
	
	
	//selector persona
	var  gestoriaAdjudicataria = app.creaLabel('<s:message code="bienesAdjudicacion.gestoriaAdjudicataria" text="**gestoriaAdjudicataria"/>','${NMBbien.adjudicacion.gestoriaAdjudicataria != null ? NMBbien.adjudicacion.gestoriaAdjudicataria.nombre : ''}', {labelStyle:labelStyle});
	
	// textos
	var  nombreArrendatario = app.creaLabel('<s:message code="bienesAdjudicacion.nombreArrendatario" text="**nombreArrendatario"/>','${NMBbien.adjudicacion.nombreArrendatario}', {labelStyle:labelStyle});
	var  nombreDepositario = app.creaLabel('<s:message code="bienesAdjudicacion.nombreDepositario" text="**nombreDepositario"/>','${NMBbien.adjudicacion.nombreDepositario}', {labelStyle:labelStyle});
	var  nombreDepositarioFinal = app.creaLabel('<s:message code="bienesAdjudicacion.nombreDepositarioFinal" text="**nombreDepositarioFinal"/>','${NMBbien.adjudicacion.nombreDepositarioFinal}', {labelStyle:labelStyle});
	
	//DICCIONARIOS
	var  fondo = app.creaLabel('<s:message code="bienesAdjudicacion.fondo" text="**fondo"/>','${NMBbien.adjudicacion.fondo.descripcion}', {labelStyle:labelStyle});
	var  entidadAdjudicataria = app.creaLabel('<s:message code="bienesAdjudicacion.entidadAdjudicataria" text="**entidadAdjudicataria"/>','${NMBbien.adjudicacion.entidadAdjudicataria.descripcion}', {labelStyle:labelStyle});
	var  situacionTitulo = app.creaLabel('<s:message code="bienesAdjudicacion.situacionTitulo" text="**situacionTitulo"/>','${NMBbien.adjudicacion.situacionTitulo.descripcion}', {labelStyle:labelStyle});
	var  resolucionMoratoria = app.creaLabel('<s:message code="bienesAdjudicacion.resolucionMoratoria" text="**resolucionMoratoria"/>','${NMBbien.adjudicacion.resolucionMoratoria.descripcion}', {labelStyle:labelStyle});
	var  tipoDocAdjudicacion = app.creaLabel('<s:message code="bienesAdjudicacion.documentoAdjudicacion" text="**documentoAdjudicacion"/>','${NMBbien.adjudicacion.tipoDocAdjudicacion.descripcion}', {labelStyle:labelStyle});

	//IMPORTES
	var  txtImporteAdjudicacion = app.creaLabel('<s:message code="bienesAdjudicacion.importeAdjudicacion" text="**importeAdjudicacion"/>','${NMBbien.adjudicacion.importeAdjudicacion}', {labelStyle:labelStyle});	
	var  importeCesionRemate = app.creaLabel('<s:message code="bienesAdjudicacion.importeCesionRemate" text="**importeCesionRemate"/>','${NMBbien.adjudicacion.importeCesionRemate}', {labelStyle:labelStyle});	
	
	
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
	    ,items : [{items:[fechaDecretoNoFirme,fechaDecretoFirme,gestoriaAdjudicataria,fechaEntregaGestor,fechaPresentacionHacienda,fechaSegundaPresentacion,txtImporteAdjudicacion,fechaContabilidad]},
				  {items:[entidadAdjudicataria,<sec:authorize ifAllGranted="VER_DOC_ADJUDICACION">tipoDocAdjudicacion,</sec:authorize>fondo,fechaPresentacionRegistro,fechaRecepcionTitulo,fechaInscripcionTitulo,fechaEnvioAdicion,situacionTitulo,cesionRemate,importeCesionRemate]}
				 ]
	});
	
	var usuarioEntidad = app.usuarioLogado.codigoEntidad;

	if(usuarioEntidad == 'HCJ' || usuarioEntidad == 'CAJAMAR'){
		datosAdjudicacion.items.items[1].add(postores);
        datosAdjudicacion.doLayout();
	}
		
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
				  {items:[fechaSolicitudMoratoria,resolucionMoratoria,fechaResolucionMoratoria,necesariaFuerzaPublica,existeInquilino,fechaContratoArrendamiento,nombreArrendatario,entregaVoluntaria]}
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
		    text: '<s:message code="app.editar" text="**Editar" />'
			<app:test id="btnEditarSolvencia" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		    	var w = app.openWindow({
					flow : 'editbien/editarAdjudicacion'
					,width: 825
					,height: 600
					,autoScroll:true
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabAdjudicacion.titleEditarAdjudicacion" text="**Editar adjudicacion" />'
					,params : {idBien:${NMBbien.id}}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
	</sec:authorize>
	 

	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		title:'<s:message code="contrato.consulta.tabAdjudicacion.titulo" text="**Adjudicacion y posesion"/>'
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
		,items : [datosAdjudicacion,datosPosesion,gestionLLaves]
		,nombreTab : 'adjudicacion'
		,bbar:new Ext.Toolbar()
	});
	
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		panel.getBottomToolbar().addButton([btnEditar]);
	</sec:authorize>
	
		
	return panel;
})()