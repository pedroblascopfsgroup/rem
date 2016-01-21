<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

var idSolicitud;
var idDocumento;
var rowsSelected=new Array(); 
var arrayIdDocumentos=new Array();
var arrayEsDocumento=new Array();
var arrayTieneSolicitud=new Array();
var arrayCodigoEstadoDocumento=new Array();

var myCboxSelModel2 = new Ext.grid.CheckboxSelectionModel({
 		handleMouseDown : function(g, rowIndex, e){
  		 	var view = this.grid.getView();
    		var isSelected = this.isSelected(rowIndex);
    		if(isSelected) {
      			this.deselectRow(rowIndex);
    		} 
    		else if(!isSelected || this.getCount() > 1) {
      			this.selectRow(rowIndex, true);
      			view.focusRow(rowIndex);
    		}
    		
  		},
  		singleSelect: false
	});
	
var documentosRecord = Ext.data.Record.create([
	{name:'idIdentificativo'},
	{name:'id'},
	{name:'idDoc'},
	{name:'solicitante'},	
	{name:'esDocumento'},	
	{name:'tieneSolicitud'},	
	{name:'codigoEstadoDocumento'},		
	{name:'contrato'},
	{name:'descripcionUG'},
	{name:'tipoDocumento'},
	{name:'estado'},
	{name:'adjunto'},
	{name:'ejecutivo'},
	{name:'tipoActor'},	
	{name:'actor'},
	{name:'fechaSolicitud'},	
	{name:'fechaResultado'},	
	{name:'fechaEnvio'},	
	{name:'fechaRecepcion'},	
	{name:'resultado'},
	{name:'comentario'}	
]);

var storeDocumentos = page.getStore({
      eventName : 'listado'
      ,flow:'documentopco/getSolicitudesDocumentosPorProcedimientoId'
      ,reader: new Ext.data.JsonReader({
              root: 'solicitudesDocumento'
      }, documentosRecord)
      ,remoteSort : true
});

storeDocumentos.on(
	'load',
	function (store, data, options) {
		actualizarBotonesDocumentos();	
	}
);

var myRenderer =  'background-color:lavender;';

var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"Cargando..."});

var cmDocumento = [
 	myCboxSelModel2,
	{header : '<s:message code="precontencioso.grid.documento.unidadGestion" text="**Unidad de Gestión" />', dataIndex : 'contrato'},
	{header : '<s:message code="precontencioso.grid.documento.descripcion" text="**Descripción" />', dataIndex : 'descripcionUG'},
	{header : '<s:message code="precontencioso.grid.documento.tipoDocumento" text="**Tipo Documento" />', dataIndex : 'tipoDocumento'},
	{header : '<s:message code="precontencioso.grid.documento.estado" text="**Estado" />', dataIndex : 'estado'},
	{header : '<s:message code="precontencioso.grid.documento.adjunto" text="**Adjunto" />', dataIndex : 'adjunto'},
	{header : '<s:message code="precontencioso.grid.documento.ejecutivo" text="**Ejecutivo" />', dataIndex : 'ejecutivo'},
	{header : '<s:message code="precontencioso.grid.documento.tipoActor" text="**Tipo Actor" />', dataIndex : 'tipoActor', css: myRenderer},
	{header : '<s:message code="precontencioso.grid.documento.actor" text="**Actor" />', dataIndex : 'actor', css: myRenderer, hidden:'true'},
	{header : '<s:message code="precontencioso.grid.documento.fechaSolicitud" text="**Fecha Solicitud" />', dataIndex : 'fechaSolicitud', css: myRenderer},	
	{header : '<s:message code="precontencioso.grid.documento.fechaResultado" text="**Fecha Resultado" />', dataIndex : 'fechaResultado', css: myRenderer},	
	{header : '<s:message code="precontencioso.grid.documento.fechaEnvio" text="**Fecha Envio" />', dataIndex : 'fechaEnvio', css: myRenderer},	
	{header : '<s:message code="precontencioso.grid.documento.fechaRecepcion" text="**Fecha Recepcion" />', dataIndex : 'fechaRecepcion', css: myRenderer},	
	{header : '<s:message code="precontencioso.grid.documento.resultado" text="**Resultado" />', dataIndex : 'resultado', css: myRenderer},
	{header : '<s:message code="precontencioso.grid.documento.comentario" text="**Comentario" />', dataIndex : 'comentario', css: myRenderer},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.solicitante" text="**Solicitante" />', dataIndex: 'solicitante', hidden: true,css:myRenderer}
]; 

var validacion=false;
var incluirDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.incluirDocumento" text="**Incluir Documento" />'
		,id: 'incluirDocButton'
		,iconCls : 'icon_mas'
		,disabled : false
		,cls: 'x-btn-text-icon'
        ,handler:function() {
        	if(validacion) {
	        	Ext.Msg.show({
				   title:'Aviso',
				   msg: '<s:message code="precontencioso.grid.documento.incluirDocumento.aviso" text="**No se puede incluir" />',
				   buttons: Ext.Msg.OK
				});
        	}else{
		        var w = app.openWindow({
						flow: 'documentopco/abrirIncluirDocumento'
						,title: '<s:message code="precontencioso.grid.documento.incluirDocumento" text="**Incluir Documento" />'
						,width: 640
					});
					w.on(app.event.DONE, function() {
						refrescarDocumentosGrid();
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}				
	});
	

var excluirDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.excluirDocumentos" text="**Excluir Documentos" />'
		,id: 'excluirDocButton'
		,iconCls : 'icon_menos'
		,disabled : true
		,cls: 'x-btn-text-icon'
		,handler:function(){
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			var p = getParametrosExcluirDescartarSolicitarDocs();			
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			}
			else {		
					Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.excluirDocumento.confirmacion" text="**Va a exlcuir documentos y las solicitudes asociadas ¿Desea continuar?" />', function(btn){
	    				if (btn == 'yes'){
	    					myMask.show();
							Ext.Ajax.request({
									url : page.resolveUrl('documentopco/excluirDocumentos'), 
									params : p,									<%-- {idDocumento:idDocumento} , --%>
									method: 'POST',
									success: function ( result, request ) {
										refrescarDocumentosGrid();
										gridDocumentos.getSelectionModel().clearSelections();
										myMask.hide();
									}
							});
	    				}
					});						
			}
	    }
	});
	
var getParametrosExcluirDescartarSolicitarDocs = function() {
		var rowsSelected=new Array(); 
		var arrayIdDocumentos=new Array();	
		rowsSelected = gridDocumentos.getSelectionModel().getSelections(); 
		for (var i=0; i < rowsSelected.length; i++){
		  	arrayIdDocumentos.push(rowsSelected[i].get('idDoc'));		
		}
		
		var arrayIdDocumentos = Ext.encode(arrayIdDocumentos);		
	 	var parametros = {};
	 	parametros.arrayIdDocumentos = arrayIdDocumentos;
	 	
	 	return parametros;
}			
	
var descartarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.descartarDocumentos" text="**Descartar Documentos" />'
		,id: 'descartarDocButton'
		,iconCls : 'icon_cancel'
		,disabled : true
		,cls: 'x-btn-text-icon'
		,handler:function(){
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			var p = getParametrosExcluirDescartarSolicitarDocs();			
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			}
			else {
				Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.descartarDocumento.confirmacion" text="**Va a descartar documentos ¿Desea continuar?" />', function(btn){
	   				if (btn == 'yes'){
	   					myMask.show();
						Ext.Ajax.request({
							url : page.resolveUrl('documentopco/descartarDocumentos'), 
							params: p, 			<%--{idDocumento:idDocumento} , --%>
							method: 'POST',
							success: function ( result, request ) {
								refrescarDocumentosGrid();
								myMask.hide();
							}
						});
					}
				});						
			}
	    }
});	

var validacionEditar=false;	
var solicitarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.crearSolicitudes" text="**Crear Solicitudes" />'
		,id: 'solicitarDocButton'
		,iconCls : 'icon_mas'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			var p = getParametrosExcluirDescartarSolicitarDocs();		
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			} else {
	        	if(validacionEditar) {
		       		Ext.Msg.show({
				   		title:'Aviso',
				   		msg: '<s:message code="precontencioso.grid.documento.crearSolicitudes.aviso" text="**No se puede crear solicitud" />',
				   		buttons: Ext.Msg.OK
					});
	        	} else {
			       var w = app.openWindow({
						flow: 'documentopco/abrirCrearSolicitudes'
						,params: p				<%--{idDocumento:idDocumento} --%>
						,title: '<s:message code="precontencioso.grid.documento.crearSolicitudes" text="**Crear solicitudes" />'
						,width: 430
					});
					w.on(app.event.DONE, function() {
						refrescarDocumentosGrid();				
						w.close(); 				
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			}
		}				
	});	
	
var getParametrosAnularSolicitudes = function() {
		var rowsSelected=new Array(); 
		var arrayIdSolicitudes=new Array();	
		var arrayIdDocumentos=new Array();
		rowsSelected = gridDocumentos.getSelectionModel().getSelections(); 
		for (var i=0; i < rowsSelected.length; i++){
		  	arrayIdSolicitudes.push(rowsSelected[i].get('id'));	
		  	arrayIdDocumentos.push(rowsSelected[i].get('idDoc'));
		}
		
		var arrayIdSolicitudes = Ext.encode(arrayIdSolicitudes);		
		var arrayIdDocumentos = Ext.encode(arrayIdDocumentos);		
	 	var parametros = {};
	 	parametros.arrayIdSolicitudes = arrayIdSolicitudes;
	 	parametros.arrayIdDocumentos = arrayIdDocumentos;
	 	
	 	return parametros;
}			

var anularSolicitudesButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.anularSolicitudes" text="**Anular Solicitudes" />'
		,id: 'anularSolicitudesButton'
		,iconCls : 'icon_menos'
		,disabled : true
		,cls: 'x-btn-text-icon'
		,handler:function(){
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			var p = getParametrosAnularSolicitudes();			
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinSolSeleccionada" text="**Debe seleccionar algún documento." />');
			}
			else {
					Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.anularSolicitudes.confirmacion" text="**Va a anular solicitudes ¿Desea continuar?" />', function(btn){
		    			if (btn == 'yes'){
							Ext.Ajax.request({
									url : page.resolveUrl('documentopco/anularSolicitudes'), 
									params: p, 		<%--{idSolicitud:idSolicitud} , --%>
									method: 'POST',
									success: function ( result, request ) {
										refrescarDocumentosGrid();
									}
							});
		    			}
					});						
			}
	    }
	});
	

	var existeSolDisponible = function(solicitudSeleccionada, documentos) {
		var data = documentos.store.data;
		var items = data.items;
		for(i=0; i < items.length; i++) {
			if(solicitudSeleccionada.data.idDoc == items[i].data.idDoc) {
				if("DI" == items[i].data.codigoEstadoDocumento && solicitudSeleccionada.data.id != items[i].data.id) {
					return true;
				}
			}
		}
		return false;
	}


var validacionEstado=false;
var informarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.informarDocumento" text="**Informar Documento" />'
		,id: 'informarDocButton'
		,iconCls : 'icon_edit'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinSolSeleccionada" text="**Debe seleccionar alguna solicitud de documento." />');
			}<%--ya se puede informar más de una solicitud
			else if (rowsSelected.length > 1){
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleSolSeleccionada" text="**No se puede seleccionar más de una solicitud de documento." />');
			} --%>
			else if(validacionEstado) {
	        	Ext.Msg.show({title:'Aviso',msg: '<s:message code="precontencioso.grid.documento.informarDocumento.aviso" text="**No se puede Informar" />',buttons: Ext.Msg.OK});
        	} 
        	else if(validacionMultiple()){
        		Ext.Msg.show({title:'Aviso',msg: '<s:message code="precontencioso.grid.documento.informarDocumento.avisoMultiple" text="**Atención, ha seleccionado Solicitudes con distinta información y por tanto no es posible Informar por selección múltiple." />',buttons: Ext.Msg.OK});
        	}
        	else {
        		<%--creamos los arrays para mandar los id's --%>
        		var rowsSelected=new Array();
        		var arrayIdDocs=new Array();
        		var arrayIdSolicitudes=new Array();
        		rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 			
				for (var i=0; i < rowsSelected.length; i++){
					arrayIdDocs.push(rowsSelected[i].get('idDoc'));
					arrayIdSolicitudes.push(rowsSelected[i].get('id'));
				}
		        var w = app.openWindow({
						flow: 'documentopco/informarSolicitud'
						,params: {idSolicitud:rowsSelected[0].get('id'), actor:rowsSelected[0].get('actor'), idDoc:rowsSelected[0].get('idDoc'), 
									fechaResultado:rowsSelected[0].get('fechaResultado'),resultado:rowsSelected[0].get('resultado'),
									fechaEnvio:rowsSelected[0].get('fechaEnvio'),fechaRecepcion:rowsSelected[0].get('fechaRecepcion'),
									existeSolDisponible:existeSolDisponible(rowsSelected[0], gridDocumentos), arrayIdDocs:arrayIdDocs,
									arrayIdSolicitudes:arrayIdSolicitudes
								}
						,title: '<s:message code="precontencioso.grid.documento.informarDocumento" text="**Informar Documento" />'
						,width: 640
					});
					w.on(app.event.DONE, function() {
						refrescarDocumentosGrid(); 
						w.close(); 
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}				
	});
	
var validacionEditar=false;	
var editarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.editarDocumento" text="**Editar Documento" />'
		,id: 'editarDocButton'
		,iconCls : 'icon_edit'
		,disabled : true
		,cls: 'x-btn-text-icon'
        ,handler:function() {
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			}
			else if (rowsSelected.length > 1){
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleDocSeleccionado" text="**Solo debe seleccionar un documento." />');
			}
			else if(validacionEditar) {
			    Ext.Msg.show({title:'Aviso',msg: '<s:message code="precontencioso.grid.documento.editarDocumento.aviso" text="**No se puede Editar" />',buttons: Ext.Msg.OK});
			} 
			else {
			        var w = app.openWindow({
							flow: 'documentopco/abrirEditarDocumento'
							,params: {idDocumento:idDocumento}
							,title: '<s:message code="precontencioso.grid.documento.editarDocumento" text="**Editar Documento" />'
							,width: 640
						});
					w.on(app.event.DONE, function() {
						w.close(); });
						w.on(app.event.CANCEL, function(){ w.close(); });
					}
			}
	});	
<%--FUNCION: Controlar que todos los campos de una selección multiple son iguales para informar o no --%>
var validacionMultiple = function (){
	var rowsSelected=new Array(); 
	var arrayIdDocumentos=new Array();
	var arrayEsDocumento=new Array();
	var arrayTieneSolicitud=new Array();
	var arrayCodigoEstadoDocumento=new Array();	
	var arrayResultado=new Array();
	
	var arrayDescripcion=new Array();
	var arrayTipoDocumento=new Array();
	var arrayAdjunto=new Array();
	var arrayEjecutivo=new Array();
	var arrayTipoActor=new Array();
	var arrayFechaResultado=new Array();
	var arrayFechaEnvio=new Array();
	var arrayFechaRecepcion=new Array();
	var arrayComentario=new Array();
	
	rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 			
	for (var i=0; i < rowsSelected.length; i++){
		arrayEsDocumento.push(rowsSelected[i].get('esDocumento'));
		arrayTieneSolicitud.push(rowsSelected[i].get('tieneSolicitud'));
		arrayCodigoEstadoDocumento.push(rowsSelected[i].get('codigoEstadoDocumento'));				 
		arrayResultado.push(rowsSelected[i].get('resultado'));
		
		arrayAdjunto.push(rowsSelected[i].get('adjunto'));
		arrayEjecutivo.push(rowsSelected[i].get('ejecutivo'));
		arrayFechaResultado.push(rowsSelected[i].get('fechaResultado'));
		arrayFechaEnvio.push(rowsSelected[i].get('fechaEnvio'));
		arrayFechaRecepcion.push(rowsSelected[i].get('fechaRecepcion'));
		arrayComentario.push(rowsSelected[i].get('comentario'));
		
	}
	
	var dummy0 = arrayEsDocumento[0];
	var dummy1 = arrayTieneSolicitud[0];
	var dummy2 = arrayCodigoEstadoDocumento[0];
	var dummy3 = arrayFechaResultado[0];
	var dummy4 = arrayAdjunto[0];
	var dummy5 = arrayEjecutivo[0];
	var dummy6 = arrayResultado[0];
	var dummy7 = arrayFechaEnvio[0];
	var dummy8 = arrayFechaRecepcion[0];
	var dummy9 = arrayComentario[0];
	
	
	for(i=1; i < arrayEsDocumento.length; i++){
		if(dummy0 != arrayEsDocumento[i] || dummy1 != arrayTieneSolicitud[i] || dummy2 != arrayCodigoEstadoDocumento[i] || dummy3 != arrayFechaResultado[i] 
			|| dummy4 != arrayAdjunto[i] || dummy5 != arrayEjecutivo[i] || dummy6 != arrayResultado[i] || dummy7 != arrayFechaEnvio[i]
			|| dummy8 != arrayFechaRecepcion[i] || dummy9 != arrayComentario[i]) {
			return true;
		}
	}
	
	return false;
}
<%-- FUNCION: Control habilitar/deshabilitar los distintos botones --%>	
var habilitarDeshabilitarButtons = function (incluirB, excluirB, descartarB, editarB, anularB, solicitarB, informarB){
	incluirDocButton.setDisabled(incluirB);
	excluirDocButton.setDisabled(excluirB);
	descartarDocButton.setDisabled(descartarB);
	editarDocButton.setDisabled(editarB);	
	anularSolicitudesButton.setDisabled(anularB);
	solicitarDocButton.setDisabled(solicitarB);	
	informarDocButton.setDisabled(informarB);
}	

<%-- FUNCION: Chequeo estados para control botones --%>
var actualizarBotonesDocumentos = function(){	
		
		habilitarDeshabilitarButtons(true, true, true, true, true, true, true);
		incluirDocButton.setDisabled(false);
		
	    <%--Se comprueba que el procedimiento se encuentre en un estado que permita editar lOs documentos --%>
		if (data != null) {
			var estadoActualCodigoProcedimiento = data.precontencioso.estadoActualCodigo;
			if (!data.esExpedienteEditable || (estadoActualCodigoProcedimiento != 'PR'  && estadoActualCodigoProcedimiento != 'SU' && estadoActualCodigoProcedimiento != 'SC')) {
	    		habilitarDeshabilitarButtons(true, true, true, true, true, true, true);
	    		return;
			}
			else if(data.esGestoria) {
				habilitarDeshabilitarButtons(true, true, true, false, true, true, false);
			}
			else {
				if(myCboxSelModel2.getCount() == 0)	{
					return;
				}
				<%-- SI SOLO UN ELEMENTO SELECCIONADO --%>
				else if(myCboxSelModel2.getCount() == 1){
		     		<%-- Si el documento está PENDIENTE SOLICITAR O SOLICITADO --%>
					if((gridDocumentos.getSelectionModel().getSelected().get('codigoEstadoDocumento') == 'PS' ||
						gridDocumentos.getSelectionModel().getSelected().get('codigoEstadoDocumento') == 'EN' ||
						gridDocumentos.getSelectionModel().getSelected().get('codigoEstadoDocumento') == 'DI' ||
						gridDocumentos.getSelectionModel().getSelected().get('codigoEstadoDocumento') == 'SO') 
						&& gridDocumentos.getSelectionModel().getSelected().get('esDocumento') == true){
						<%-- Si es solicitud --%>
						if (gridDocumentos.getSelectionModel().getSelected().get('tieneSolicitud') == true){ 
							<%-- Si no tiene resultado --%>
							if (gridDocumentos.getSelectionModel().getSelected().get('resultado') == ''){
					      		habilitarDeshabilitarButtons(false, true, false, false, false, false, false);
					      		return;
					      	}
					      	<%-- Si la solicitud tiene resultado --%>
					      	else {
					      		habilitarDeshabilitarButtons(false, true, false, false, true, false, false);	
					      		return;	      					      		
					      	}
					    }
		      			<%-- Si no es solicitud --%>
		      			else {
		      				habilitarDeshabilitarButtons(false, false, false, false, true, false, true);
		      				return;
		      			}   
					}
					else {	
						<%-- Si el documento está DESCARTADO --%>
						if(gridDocumentos.getSelectionModel().getSelected().get('codigoEstadoDocumento') == 'DE'
							&& gridDocumentos.getSelectionModel().getSelected().get('esDocumento') == true){
							
							<%-- Si no tiene solicitud se permite excluir --%>
							if (gridDocumentos.getSelectionModel().getSelected().get('tieneSolicitud') == false){
								habilitarDeshabilitarButtons(false, false, true, false, true, false, false); 
							}
							<%-- Si tiene solicitud no se permite excluir --%>
							else {
								habilitarDeshabilitarButtons(false, true, true, false, true, false, false);
							}
								  
			      			return; 
						}
						else {		
				     		<%-- Si el documento es solicitud --%>				
							if(gridDocumentos.getSelectionModel().getSelected().get('tieneSolicitud') == true) {
								<%-- Si no tiene resultado --%>
								if (gridDocumentos.getSelectionModel().getSelected().get('resultado') == ''){
					      			habilitarDeshabilitarButtons(false, true, true, false, false, true, false);
					      			return;
					      		}
					      		<%-- Si la solicitud tiene resultado --%>
					      		else {
					      			habilitarDeshabilitarButtons(false, true, true, false, true, true, false);
					      			return;		      					      		
					      		}      						
							}		
						}
					}				
				}
				<%-- SI SELECCION MULTIPLE DE ELEMENTOS --%>
				else {
					// Inicialmente todos desahabilitados
					//habilitarDeshabilitarButtons(true, true, true, true, true, true, true);
					
					var rowsSelected=new Array(); 
					var arrayIdDocumentos=new Array();
					var arrayEsDocumento=new Array();
					var arrayTieneSolicitud=new Array();
					var arrayCodigoEstadoDocumento=new Array();	
					var arrayResultado=new Array();		
					rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 			
					for (var i=0; i < rowsSelected.length; i++){
					  arrayEsDocumento.push(rowsSelected[i].get('esDocumento'));
					  arrayTieneSolicitud.push(rowsSelected[i].get('tieneSolicitud'));
					  arrayCodigoEstadoDocumento.push(rowsSelected[i].get('codigoEstadoDocumento'));				 
					  arrayResultado.push(rowsSelected[i].get('resultado'));				 
					}
					<%-- Para realizar una acción multiple todos los elementos tienen que estar en el mismo estado --%>	
					<%-- Para saber si las filas seleccionadas todas están en el mismo estado, eliminamos los elementos duplicados del array
					entonces si todas las filas seleccionadas tienen el mismo estado el array tendrá un tamaño=1 --%>
					uniqueArray = arrayCodigoEstadoDocumento.filter(function(item, pos) {
			    			return arrayCodigoEstadoDocumento.indexOf(item) == pos;
					});	
					
					<%-- SI DOCUMENTOS ELEGIDOS DE DISTINTO ESTADO -> AVISO DE LA IMPOSIBILIDAD DE HACER NADA --%>
		<%-- 			if (uniqueArray.length > 1){ --%>
		<%-- 				habilitarDeshabilitarButtons(true, true, true, true, true, true, true); --%>
		<%-- 				Ext.MessageBox.alert('<s:message code="precontencioso.grid.documento.estadoDocumentosDistintos.titulo" text="**Estados de documento distintos" />' --%>
		<%--                  ,'<s:message code="precontencioso.grid.documento.estadoDocumentosDistintos.aviso" text="**Debe seleccionar documentos con el mismo estado" />'); --%>
		<%--                 return; --%>
		<%-- 			} --%>
								
					<%-- **** ESTADO PENDIENTE DE SOLICITAR --%>
					<%-- Vemos si tenemos solo un resultado y es PS (PENDIENTE SOLICITAR --%>
		<%-- 			if (uniqueArray.length == 1 && uniqueArray[0] == 'PS'){ --%>
						uniqueArray2 = arrayEsDocumento.filter(function(item, pos) {
			    			return arrayEsDocumento.indexOf(item) == pos;
						});
						<%-- Si todos los seleccionados son documentos --%>	
						if (uniqueArray2.length ==1 && uniqueArray2[0] == true){
							uniqueArray3 = arrayTieneSolicitud.filter(function(item, pos) {
				    			return arrayTieneSolicitud.indexOf(item) == pos;
							});
							<%-- Si hay documentos con solicitudes o sin solicitudes --%>
							if (uniqueArray3.length > 1){
								<%-- SOLICITAR MASIVAMENTE --%>
								habilitarDeshabilitarButtons(false, true, false, true, true, false, true);
								return;							
							}
							else {
								<%-- Y ademas no tienen solicitudes --%>
								if (uniqueArray3.length ==1 && uniqueArray3[0] == false){
									<%-- EXCLUIR DOCUMENTOS Y SOLICITAR MASIVAMENTE --%>
									habilitarDeshabilitarButtons(false, false, false, true, true, false, true);	
									return;	      					      									
								}
								<%-- Si todas tienen solicitudes --%>
								if (uniqueArray3.length ==1 && uniqueArray3[0] == true){
									uniqueArray4 = arrayResultado.filter(function(item, pos) {
						    			return arrayResultado.indexOf(item) == pos;
									});
									<%-- pero no tienen resultado --%>
									if (uniqueArray4.length ==1 && uniqueArray4[0] == ''){
										<%-- DESCARTAR DOCUMENTOS y ANULAR SOLICITUDES MASIVAMENTE --%>
										<%--habilitarDeshabilitarButtons(false, true, false, true, false, false, true); --%>
										habilitarDeshabilitarButtons(false, true, false, true, false, false, false);<%--habilitamos informar masivo --%>
										return;
									}		      					      									
								}
							}
						}
						<%-- Si no todos los seleccionado son documentos, tambien hay solicitudes --%>
						else {
							uniqueArray4 = arrayResultado.filter(function(item, pos) {
					    		return arrayResultado.indexOf(item) == pos;
							});
							<%-- Si todas las solicitudes no tienen resultado --%>
							if (uniqueArray4.length ==1 && uniqueArray4[0] == ''){
								<%-- ANULAR SOLICITUDES MASIVAMENTE --%>
								<%--habilitarDeshabilitarButtons(false, true, true, true, false, true, true); --%>
								habilitarDeshabilitarButtons(false, true, true, true, false, true, false);<%--habilitamos informar masivo --%>
								return;
							}		      					      																	
						}												
		<%-- 			} --%>
					<%-- **** ESTADO SOLICITADO --%>
					<%-- Vemos si tenemos solo un resultado y es SO (SOLICITADO) --%>
		<%-- 			if (uniqueArray.length == 1 && uniqueArray[0] == 'SO'){ --%>
						uniqueArray2 = arrayEsDocumento.filter(function(item, pos) {
			    			return arrayEsDocumento.indexOf(item) == pos;
						});
						<%-- Si todos los seleccionados son documentos --%>	
						if (uniqueArray2.length ==1 && uniqueArray2[0] == true){
							uniqueArray4 = arrayResultado.filter(function(item, pos) {
					    		return arrayResultado.indexOf(item) == pos;
							});
							<%-- Si todas las solicitudes no tienen resultado --%>
							if (uniqueArray4.length ==1 && uniqueArray4[0] == ''){
								<%-- DESCARTAR DOCUMENTOS Y ANULAR SOLICITUDES MASIVAMENTE --%>
								<%--habilitarDeshabilitarButtons(false, true, false, true, false, false, true); --%>
								habilitarDeshabilitarButtons(false, true, false, true, false, false, false);<%--habilitamos informar masivo --%>
								return;
							}
							<%-- Si hay alguna solicitud con resultado --%>
							else {
								<%-- SOLICITAR MASIVAMENTE --%>
								<%--habilitarDeshabilitarButtons(false, true, false, true, true, false, true); --%>
								habilitarDeshabilitarButtons(false, true, false, true, true, false, false);<%--habilitamos informar masivo --%>
								return;
							} 		      					      									
						}
						<%-- Si no todos los seleccionado son documentos, tambien hay solicitudes --%>
						else {
							uniqueArray4 = arrayResultado.filter(function(item, pos) {
					    		return arrayResultado.indexOf(item) == pos;
							});
							<%-- Si todas las solicitudes no tienen resultado --%>
							if (uniqueArray4.length ==1 && uniqueArray4[0] == ''){
								<%-- ANULAR SOLICITUDES MASIVAMENTE --%>
								<%--habilitarDeshabilitarButtons(false, true, false, true, false, true, true); --%>
								habilitarDeshabilitarButtons(false, true, false, true, false, true, false);<%--habilitamos informar masivo --%>
								return;
							}		      					      																	
						}				
		<%-- 			} --%>
					<%-- **** ESTADO DESCARTADO --%>
					<%-- Vemos si tenemos solo un resultado y es DE (DESCARTADO) --%>
		<%-- 			if (uniqueArray.length == 1 && uniqueArray[0] == 'DE'){ --%>
						uniqueArray2 = arrayEsDocumento.filter(function(item, pos) {
			    			return arrayEsDocumento.indexOf(item) == pos;
						});
						<%-- Si todos los seleccionados son documentos --%>	
						if (uniqueArray2.length ==1 && uniqueArray2[0] == true){
							<%-- SOLICITAR MASIVAMENTE --%>
							<%--habilitarDeshabilitarButtons(false, true, true, true, true, false, true); --%>
							habilitarDeshabilitarButtons(false, true, true, true, true, false, false);<%--habilitamos informar masivo --%>
							return;
						}
		<%-- 			} --%>
								
				}
			}
      	} 
      	else {
			habilitarDeshabilitarButtons(true,true, true, true, true, true, true);
			return;
      	}		

		
}	

<%-- States --%>

//Definimos eventos checkselectionmodel
Ext.namespace('Ext.ux.plugins');
	
	Ext.ux.plugins.CheckBoxMemory = Ext.extend(Object,{
   		constructor: function(config){
	      	if (!config)
				config = {};

      		this.prefix = 'id_';
      		this.items = {};
      		this.idArray = new Array();
      		this.idProperty = config.idProperty || 'idIdentificativo';
   		},

   		init: function(grid){
			this.store = grid.getStore();
      		this.sm = grid.getSelectionModel();
      		this.sm.on('rowselect', this.onSelect, this);
      		this.sm.on('rowdeselect', this.onDeselect, this);
      		this.store.on('load', this.restoreState, this);
      		
   		},

   		onSelect: function(sm, idx, rec){
      		this.items[this.getId(rec)] = true;
      		if (this.idArray.indexOf(rec.get(this.idProperty)) < 0){
      			this.idArray.push(rec.get(this.idProperty));
      		}
      		
      		actualizarBotonesDocumentos();
			
   		},

   		onDeselect: function(sm, idx, rec){
      		delete this.items[this.getId(rec)];
      		var i = this.idArray.indexOf(rec.get(this.idProperty));
      		if (i >= 0){
      			delete this.idArray.splice(i,1);
      		} 
      		     		
   			actualizarBotonesDocumentos();
   			
   		},

   		restoreState: function(){
      		var i = 0;
      		var sel = [];
      		this.store.each(function(rec){
         		var id = this.getId(rec);
         		if (this.items[id] === true)
            		sel.push(i);
		
         		++i;
      		}, this);
      		if (sel.length > 0)
         		this.sm.selectRows(sel);
   		},

	   getId: function(rec){
      		return this.prefix + rec.get(this.idProperty);
   		},
   	   getIds: function(){
   	   		return this.idArray;
   	   }	
	});
	
	var columMemoryPlugin = new Ext.ux.plugins.CheckBoxMemory();
	var separadorButtons = new Ext.Toolbar.Fill();	


	var botonRefresh = new Ext.Button({
			text : 'Refresh'
			,id: 'botonRefreshDoc'
			,iconCls : 'icon_refresh'
			,handler:function(){
				refrescarDocumentosGrid();
			}
	});
	
var gridDocumentos = new Ext.grid.GridPanel({
		title: '<s:message code="precontencioso.grid.documento.titulo" text="**Documentos" />'	
		,columns: cmDocumento
		,store: storeDocumentos
		,loadMask: true
        ,sm: myCboxSelModel2
        ,clicksToEdit: 1
        ,plugins: [columMemoryPlugin]
		,collapsible: true
		,height: 250
		,autoWidth: true	
		,collapsed : false
		,titleCollapse : false
		,monitorResize: true
		<sec:authorize ifAllGranted="TAB_PRECONTENCIOSO_DOC_BTN">
			,bbar : [ incluirDocButton, excluirDocButton, descartarDocButton, editarDocButton, separadorButtons, anularSolicitudesButton, solicitarDocButton, informarDocButton, botonRefresh]
		</sec:authorize>
		,doLayout: function() {
			if(this.isVisible()){
				var margin = 10;
				var parentSize = app.contenido.getSize(true);
				var width = (parentSize.width) - (2*margin);
				this.setWidth(width);
				Ext.grid.GridPanel.prototype.doLayout.call(this);
			}
		}
}); 

gridDocumentos.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		var rec = gridDocumentos.getStore().getAt(rowIndex);
		idSolicitud = rec.get('id');
		idDocumento = rec.get('idDoc');		
});

var refrescarDocumentosGrid = function() {
	storeDocumentos.webflow({idProcedimientoPCO: data.id});
}

var ponerVisibilidadBotonesDoc = function(visibles, invisibles) {
	for (var i=0; i < visibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(visibles[i].boton).setVisible(true);
		}
	}
	for (var i=0; i < invisibles.length; i++){
		if (typeof(Ext.getCmp(visibles[i].boton)) != 'undefined') {
			Ext.getCmp(invisibles[i].boton).setVisible(false);
		}
	}
}
