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

var myCboxSelModel = new Ext.grid.CheckboxSelectionModel({
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
	{name:'id'},
	{name:'idDoc'},	
	{name:'contrato'},
	{name:'descripcionUG'},
	{name:'tipoDocumento'},
	{name:'estado'},
	{name:'adjunto'},
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


var cmDocumento = [ 
 	myCboxSelModel, 
 	{header: 'id',dataIndex:'id',hidden:'true'},
 	{header: 'idDoc',dataIndex:'idDoc',hidden:'true'},	
	{header : '<s:message code="precontencioso.grid.documento.unidadGestion" text="**Unidad de Gestión" />', dataIndex : 'contrato'},
	{header : '<s:message code="precontencioso.grid.documento.descripcion" text="**Descripción" />', dataIndex : 'descripcionUG'},
	{header : '<s:message code="precontencioso.grid.documento.tipoDocumento" text="**Tipo Documento" />', dataIndex : 'tipoDocumento'},
	{header : '<s:message code="precontencioso.grid.documento.estado" text="**Estado" />', dataIndex : 'estado'},
	{header : '<s:message code="precontencioso.grid.documento.adjunto" text="**Adjunto" />', dataIndex : 'adjunto'},
	{header : '<s:message code="precontencioso.grid.documento.actor" text="**Actor" />', dataIndex : 'actor'},
	{header : '<s:message code="precontencioso.grid.documento.fechaSolicitud" text="**Fecha Solicitud" />', dataIndex : 'fechaSolicitud'},	
	{header : '<s:message code="precontencioso.grid.documento.fechaResultado" text="**Fecha Resultado" />', dataIndex : 'fechaResultado'},	
	{header : '<s:message code="precontencioso.grid.documento.fechaEnvio" text="**Fecha Envio" />', dataIndex : 'fechaEnvio'},	
	{header : '<s:message code="precontencioso.grid.documento.fechaRecepcion" text="**Fecha Recepcion" />', dataIndex : 'fechaRecepcion'},	
	{header : '<s:message code="precontencioso.grid.documento.resultado" text="**Resultado" />', dataIndex : 'resultado'},
	{header : '<s:message code="precontencioso.grid.documento.comentario" text="**Comentario" />', dataIndex : 'comentario'}	
]; 

var validacion=false;
var incluirDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.incluirDocumento" text="**Incluir Documento" />'
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
						,params: {idSolicitud:idSolicitud}
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
		,iconCls : 'icon_menos'
		,disabled : false
		,cls: 'x-btn-text-icon'
		,handler:function(){
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			}
			else {
				if (rowsSelected.length > 1){
					Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleDocSeleccionado" text="**Solo debe seleccionar un documento." />');
				}
				else {		
						Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.excluirDocumento.confirmacion" text="**Va a exlcuir documentos y las solicitudes asociadas ¿Desea continuar?" />', function(btn){
		    				if (btn == 'yes'){
								Ext.Ajax.request({
										url : page.resolveUrl('documentopco/excluirDocumentos'), 
										params : {idDocumento:idDocumento} ,
										method: 'POST',
										success: function ( result, request ) {
											refrescarDocumentosGrid();
										}
								});
		    				}
						});						
				}
			}
	    }
	});	
	
<%-- 	var validateExcluir = function(){	
		rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
		if (rowsSelected == '') {
			Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.exluirDocumento.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
		}
		else if (rowsSelected.length > 1){
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.exluirDocumento.multipleDocSeleccionado" text="**Solo debe seleccionar un documento." />');
			 }
			 else {
	        	Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', 
	        		'<s:message code="precontencioso.grid.documento.excluiDocumento.avisoExcluir" 
	        		text="**Se borrará el documento y todas sus solicitudes ¿Desea continuar?" />', 
	        		function(btn){
	    				if (btn == 'yes'){
	    					return true;
	    				}
	    				else {
	    					return false;
	    				}
					});	
	        }

		return true;
	}		 --%>


var descartarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.descartarDocumentos" text="**Descartar Documentos" />'
		,iconCls : 'icon_cancel'
		,disabled : false
		,cls: 'x-btn-text-icon'
		,handler:function(){
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			}
			else {
				if (rowsSelected.length > 1){
					Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleDocSeleccionado" text="**Solo debe seleccionar un documento." />');
				}
				else {	
						Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.descartarDocumento.confirmacion" text="**Va a descartar documentos ¿Desea continuar?" />', function(btn){
		    				if (btn == 'yes'){
								Ext.Ajax.request({
										url : page.resolveUrl('documentopco/descartarDocumentos'), 
										params: {idDocumento:idDocumento} ,
										method: 'POST',
										success: function ( result, request ) {
											refrescarDocumentosGrid();
										}
								});
		    				}
						});						
				}
			}
	    }
	});	

var validacionEditar=false;	
var solicitarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.crearSolicitudes" text="**Crear Solicitudes" />'
		,iconCls : 'icon_mas'
		,disabled : false
		,cls: 'x-btn-text-icon'
        ,handler:function() {
		rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
		if (rowsSelected == '') {
			Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
		}
		else {
			if (rowsSelected.length > 1){
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleDocSeleccionado" text="**Solo debe seleccionar un documento." />');
			}
			else {
	        	if(validacionEditar) {
		        	Ext.Msg.show({
					   title:'Aviso',
					   msg: '<s:message code="precontencioso.grid.documento.crearSolicitudes.aviso" text="**No se puede crear solicitud" />',
					   buttons: Ext.Msg.OK
					});
	        	}
	        	else {
			        var w = app.openWindow({
							flow: 'documentopco/abirCrearSolicitudes'
							,params: {idSolicitud:idSolicitud}
							,title: '<s:message code="precontencioso.grid.documento.crearSolicitudes" text="**Crear solicitudes" />'
							,width: 300
						});
					w.on(app.event.DONE, function() {
						refrescarDocumentosGrid();					
						w.close(); 
						
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					}
				}
			}
		}				
	});	


var anularSolicitudes = {
		text : '<s:message code="precontencioso.grid.documento.anularSolicitudes" text="**Anular Solicitudes" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
	};	
var anularSolicitudesButton = new Ext.Button(anularSolicitudes);

var validacionEstado=false;
var informarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.informarDocumento" text="**Informar Documento" />'
		,iconCls : 'icon_edit'
		,disabled : false
		,cls: 'x-btn-text-icon'
        ,handler:function() {
			rowsSelected=gridDocumentos.getSelectionModel().getSelections(); 
			if (rowsSelected == '') {
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.sinSolSeleccionada" text="**Debe seleccionar alguna solicitud de documento." />');
			}
			else if (rowsSelected.length > 1){
				Ext.Msg.alert('Aviso', '<s:message code="precontencioso.grid.documento.aviso.multipleSolSeleccionada" text="**No se puede seleccionar más de una solicitud de documento." />');
			}
			else if(validacionEstado) {
	        	Ext.Msg.show({title:'Aviso',msg: '<s:message code="precontencioso.grid.documento.informarDocumento.aviso" text="**No se puede Informar" />',buttons: Ext.Msg.OK});
        	} 
        	else {
		        var w = app.openWindow({
						flow: 'documentopco/informarSolicitud'
						,params: {idSolicitud:rowsSelected[0].get('id'), actor:rowsSelected[0].get('actor'), idDoc:rowsSelected[0].get('idDoc'), 
							estado:rowsSelected[0].get('estado'),adjuntado:rowsSelected[0].get('adjunto'),
							fechaResultado:rowsSelected[0].get('fechaResultado'),resultado:rowsSelected[0].get('resultado'),
							fechaEnvio:rowsSelected[0].get('fechaEnvio'),fechaRecepcion:rowsSelected[0].get('fechaRecepcion'),
							comentario:rowsSelected[0].get('comentario')}
						,title: '<s:message code="precontencioso.grid.documento.informarDocumento" text="**Informar Documento" />'
						,width: 640
					});
					w.on(app.event.DONE, function() {
						w.close(); });
					w.on(app.event.CANCEL, function(){ w.close(); });
			}
		}				
	});
	
var validacionEditar=false;	
var editarDocButton = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.editarDocumento" text="**Editar Documento" />'
		,iconCls : 'icon_edit'
		,disabled : false
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
	

//Definimos eventos checkselectionmodel
Ext.namespace('Ext.ux.plugins');
	
	Ext.ux.plugins.CheckBoxMemory = Ext.extend(Object,{
   		constructor: function(config){
	      	if (!config)
				config = {};

      		this.prefix = 'id_';
      		this.items = {};
      		this.idArray = new Array();
      		this.idProperty = config.idProperty || 'id';
   		},

   		init: function(grid){
			this.store = grid.getStore();
      		this.sm = grid.getSelectionModel();
      		this.sm.on('rowselect', this.onSelect, this);
      		this.sm.on('rowdeselect', this.onDeselect, this);
      		this.store.on('load', this.restoreState, this);
      		//btnPreparar.disabled=true;
      		
   		},

   		onSelect: function(sm, idx, rec){
      		this.items[this.getId(rec)] = true;
      		if (this.idArray.indexOf(rec.get(this.idProperty)) < 0){
      			this.idArray.push(rec.get(this.idProperty));
      		}
      		//btnPreparar.setDisabled(false);
   		},

   		onDeselect: function(sm, idx, rec){
      		delete this.items[this.getId(rec)];
      		var i = this.idArray.indexOf(rec.get(this.idProperty));
      		if (i >= 0){
      			delete this.idArray.splice(i,1);
      		}
      		
      		if(myCboxSelModel.getCount() == 0){
      			//btnPreparar.setDisabled(true);
      		}
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

var gridDocumentos = new Ext.grid.GridPanel({
		title: '<s:message code="precontencioso.grid.documento.titulo" text="**Documentos" />'	
		,columns: cmDocumento
		,store: storeDocumentos
		,height: 170
		,loadMask: true
        ,sm: myCboxSelModel
        ,clicksToEdit: 1
        ,viewConfig: {forceFit:true}
        ,plugins: [columMemoryPlugin]
		,cls:'cursor_pointer'
		,height: 250
		,autoWidth: true			
		,bbar : [ incluirDocButton, excluirDocButton, descartarDocButton, anularSolicitudesButton, editarDocButton, separadorButtons, solicitarDocButton, informarDocButton ]
	});
	

gridDocumentos.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		var rec = gridDocumentos.getStore().getAt(rowIndex);
		idSolicitud = rec.get('id');
		idDocumento = rec.get('idDoc');
});

var refrescarDocumentosGrid = function() {
	storeDocumentos.webflow({idProcedimientoPCO: '100353078'});
}

refrescarDocumentosGrid();	



