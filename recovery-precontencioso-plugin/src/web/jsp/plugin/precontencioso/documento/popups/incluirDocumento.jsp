<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


<fwk:page>	

var rowsSelected=new Array(); 

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

	var config = {width: 150, labelStyle:"width:100px"};
	
	//unidades Gestion
	var unidadesGestion=<app:dict value="${unidadesGestion}" />;
	var comboUnidadesGestion = app.creaDblSelect(unidadesGestion,
		'<s:message code="precontencioso.grid.documento.incluirDocumento.unidadGestion" text="**Unidad de Gestión" />',config); 
	
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var handlerGuardar = function() {
		var p = getParametros();
    	Ext.Ajax.request({
				url : page.resolveUrl('documentopco/saveIncluirDocumentos'), 
				params : p ,
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
		});
	}
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
			if (validateForm()) {		    
		    	handlerGuardar();
			}
	     }
	});
	
	var btnAgregarUnidadGestion = new Ext.Button({
		text : '<s:message code="precontencioso.grid.documento.incluirDocumento.buscar" text="**Buscar" />'
		,iconCls : 'icon_busquedas'
		,handler : function(){
			agregarUnidadesGestion();
		}
	});
	
	var agregarUnidadesGestion = function(funcion) {
		// Agrega o quita las unidades de gestion		
		var uniGestion=comboUnidadesGestion.getValue();
		storeDocs.webflow({uniGestionIds:uniGestion, idPrc:data.id});
	};

	var validateForm = function(){	
		var validate = true;
		rowsSelected=gridDocs.getSelectionModel().getSelections(); 
		if (rowsSelected.length == 0) {
			Ext.Msg.alert('Error', '<s:message code="precontencioso.grid.documento.incluirDocumento.sinDocSeleccionado" text="**Debe seleccionar algún documento." />');
			validate = false;
		}else if (comboTipoDocumento.getValue() == ''){
			Ext.Msg.alert('Error', '<s:message code="precontencioso.grid.documento.incluirDocumento.sinTipoDocumento" text="**Debe de elegir un tipo de documento." />');
			validate = false;
		}else if(protocolo.getValue() == '') {
			validate = false;
			Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.incluirDocumento.sinProtocolo" text="**No se ha informado el campo PROTOCOLO ¿Desea continuar?" />', function(btn){
   				if (btn == 'yes'){
   					handlerGuardar();
   				}
   				else {
   					return false;
   				}
			});	
		}else{
			validate = false;
			Ext.Ajax.request({
					url : page.resolveUrl('documentopco/validacionDuplicadoDocumento'), 
					params : getParametros() ,
					method: 'POST',
					success: function ( result, request ) {
						var resultado = Ext.decode(result.responseText);
						if(resultado.documento_duplicado){
							Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.incluirDocumento.documentoDuplicado" text="**Ya existe un documento del mismo tipo, siendo el mismo protocolo y notario en la unidad de gestión seleccionada." />', function(btn){
								if (btn == 'yes'){
				   					handlerGuardar();
				   				}
							});
						}else{
							handlerGuardar();
						}
					}
			});
		}
		return validate;
	}	
	
	var getParametros = function() {
		var rowsSelected=new Array(); 
		var arrayIdDocumentos=new Array();	
		var arrayIdUG=new Array();
		rowsSelected = gridDocs.getSelectionModel().getSelections(); 
		for (var i=0; i < rowsSelected.length; i++){
		  	arrayIdDocumentos.push(rowsSelected[i].get('id'));		
		  	arrayIdUG.push(rowsSelected[i].get('unidadGestionId'));	
		}
		
		var arrayIdDocumentos = Ext.encode(arrayIdDocumentos);
		var arrayIdUG = Ext.encode(arrayIdUG);
		
	 	var parametros = {};
	 	parametros.arrayIdDocumentos = arrayIdDocumentos;
	 	parametros.arrayIdUG = arrayIdUG;
		parametros.comboTipoDocumento = comboTipoDocumento.getValue();	 	
 		parametros.protocolo = protocolo.getValue();
	 	parametros.notario = notario.getValue();
	 	if (fechaEscritura.getValue()=='')
	 		parametros.fechaEscritura = '';
	 	else
	 		parametros.fechaEscritura = fechaEscritura.getValue().format('d/m/Y');
	 	parametros.asiento = asiento.getValue();
	 	parametros.finca = finca.getValue();
	 	parametros.tomo = tomo.getValue();
	 	parametros.libro = libro.getValue();
	 	parametros.folio = folio.getValue();
	 	parametros.numFinca = numFinca.getValue();
	 	parametros.numRegistro = numRegistro.getValue();
	 	parametros.plaza = plaza.getValue();
	 	parametros.idufir = idufir.getValue();	 	
	 	
		parametros.idPrc = data.id;

	 	return parametros;
	 }	
	
	
var docsRecord = Ext.data.Record.create([
	{name:'id'},
	{name:'unidadGestionId'},	
	{name:'contrato'},
	{name:'descripcionUG'}
]);

var storeDocs = page.getStore({
      eventName : 'listado'
      ,flow:'documentopco/agregarDocumentosUG'
      ,reader: new Ext.data.JsonReader({
              root: 'documentosUG'
      }, docsRecord)
      ,remoteSort : true
});


var cmDoc = [
	myCboxSelModel,
	{header: 'id',dataIndex:'id',hidden:'true'},
	{header: 'unidadGestionId',dataIndex:'unidadGestionId',hidden:'true'},
	{header : '<s:message code="precontencioso.grid.documento.incluirDocumento.unidadGestion" text="**Unidad de Gestión" />', dataIndex : 'contrato'},
	{header : '<s:message code="precontencioso.grid.documento.incluirDocumento.descripcion" text="**Descripción" />', dataIndex : 'descripcionUG'}
];

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

var gridDocs = new Ext.grid.GridPanel({
		title: '<s:message code="precontencioso.grid.documento.titulo" text="**Documentos" />'	
		,columns: cmDoc
		,store: storeDocs
		,loadMask: true
        ,sm: myCboxSelModel
        ,clicksToEdit: 1
        ,viewConfig: {forceFit:true}
        ,plugins: [columMemoryPlugin]
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:150
	});

   var tipoDocRecord = Ext.data.Record.create([
         {name:'codigo'}
        ,{name:'descripcion'}
    ]);
    
    var optionsTipoDocStore = page.getStore({
           flow: 'expedientes/buscarTiposDocumento'
           ,reader: new Ext.data.JsonReader({root : 'tiposDocumento'}, tipoDocRecord)           
    }); 
    
    var style='margin-bottom:1px;margin-top:1px';
    var labelStyle='width:100';
    
<pfsforms:ddCombo name="comboTipoDocumento"
		labelKey="precontencioso.grid.documento.incluirDocumento.tipodocumento" 
 		label="**Tipo Documento" value="" dd="${tiposDocumento}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />
	comboTipoDocumento.labelStyle=labelStyle;
	    
	var protocolo = new Ext.form.TextField({
		name : 'protocolo'
		,value : '<s:message text="${dtoDoc.protocolo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.protocolo" text="**Protocolo" />'
	});    
	
	var notario = new Ext.form.TextField({
		name : 'notario'
		,value : '<s:message text="${dtoDoc.notario}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.notario" text="**Notario" />'
	});  
	
	
	var fechaEscritura = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.fechaEscritura" text="**Fecha escritura" />'
		,style:'margin:0px'
	});	
	
	var asiento = new Ext.form.TextField({
		name : 'asiento'
		,value : '<s:message text="${dtoDoc.asiento}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.asiento" text="**Asiento" />'
	});  
	
	var finca = new Ext.form.TextField({
		name : 'finca'
		,value : '<s:message text="${dtoDoc.finca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.finca" text="**Finca" />'
	});  
	
	var tomo = new Ext.form.TextField({
		name : 'tomo'
		,value : '<s:message text="${dtoDoc.tomo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.tomo" text="**Tomo" />'
	});  
	
	var libro = new Ext.form.TextField({
		name : 'libro'
		,value : '<s:message text="${dtoDoc.libro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.libro" text="**Libro" />'
	}); 
	
	var folio = new Ext.form.TextField({
		name : 'folio'
		,value : '<s:message text="${dtoDoc.folio}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.folio" text="**Folio" />'
	});  
	
	var numFinca = new Ext.form.TextField({
		name : 'numFinca'
		,value : '<s:message text="${dtoDoc.numFinca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.numFinca" text="**Número Finca" />'
	});  
	
	var numRegistro = new Ext.form.TextField({
		name : 'numRegistro'
		,value : '<s:message text="${dtoDoc.numRegistro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.numRegistro" text="**Número Registro" />'
	});  
	
	var plaza = new Ext.form.TextField({
		name : 'documento.plaza'
		,value : '<s:message text="${plaza}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.plaza" text="**Plaza" />'
	});  	
	
	var idufir = new Ext.form.TextField({
		name : 'idufir'
		,value : '<s:message text="${dtoDoc.idufir}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.idufir" text="**IDUFIR" />'
	});  	

	
	var panelSuperior={
			layout:'table'
			,autoHeight : true
    	    ,autoWidth : true
			,layoutConfig:{
				columns:3
			}
			,defaults:{xtype:'fieldset',cellCls : 'vtop'}
			,style:'padding:1px;cellspacing:2px'
			,items:[
				{
					colspan:2
					,height:80
					,width:450
					,border:false
					,items:comboUnidadesGestion
				},
				{
					items:btnAgregarUnidadGestion
					,height:80
					,width:100
					,border:false
				},				
				{
					colspan:3
					,width:580
					,autoHeight:true
					,border:false
					,items: gridDocs
				}

				
			]
	};
	
	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="precontencioso.grid.documento.incluirDocumento.infoDocumentos" text="**Información Documentos" />'
		,layout:'table'
		,layoutConfig:{columns:2}
		,border:true
		,autoHeight : true
   	    ,autoWidth : true
		,defaults : {xtype : 'fieldset', border:false , cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,items:[{items: [ comboTipoDocumento, notario, asiento, finca, numFinca, numRegistro, plaza]}
				,{items: [ protocolo, fechaEscritura, tomo, libro, folio, idufir]}
		]
	});	
	
	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,autoHeight:true
		,autoScroll:true
		,width:600
		,height:620
		,defaults:{xtype:'fieldset',cellCls : 'vtop',width:600,autoHeight:true}
		,items:[panelSuperior,panelEdicion]
		,bbar:[btnGuardar, btnCancelar]
	});	
	

	page.add(panel);
	
</fwk:page>