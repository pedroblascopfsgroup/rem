<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	<pfs:hidden name="idProcesoFacturacion" value="${idProcesoFacturacion}"/>
	
	<pfs:defineParameters name="getParametros" paramId="" idProcesoFacturacion="idProcesoFacturacion" />
	
	<pfsforms:ddCombo name="modeloNuevo_edit" labelKey="" label="" value="" 
			dd="${modelos}" propertyCodigo="id" propertyDescripcion="nombre"/>	
			
	var modelos = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion'],
		data : modeloNuevo_editDiccionario,
		root : 'diccionario'
	});

	 
	var modeloFacturacion_nombre = function(val){
		var modelo = modelos.queryBy(function(rec){
			return rec.data.codigo == val;
		});
		
		if (modelo.getCount()>0)
			return modelo.itemAt(0).data.descripcion;
	}
	
	modeloNuevo_edit.on('select', function() {
		selModelId = this.getValue();
		actualModelId = gridSubcarteras.getSelectionModel().getSelected().data.idModeloFacturacionInicial;
		
		if (selModelId == actualModelId) {
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />'
				,'<s:message code="plugin.recobroConfig.procesoFacturacion.modificarModelosFacturacionSubcarteras.mismoModelo" text="**Debe seleccionar un módelo de facturación diferente al original" />');					
				this.setValue('');		
		}
	});
	
	 <pfs:defineRecordType name="subcarteraFacturacion">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="idSubcarteraFacturacion" />
			<pfs:defineTextColumn name="idProcesoFacturacion" />
			<pfs:defineTextColumn name="cartera" />
			<pfs:defineTextColumn name="subCartera" />
			<pfs:defineTextColumn name="idModeloFacturacionInicial" />
			<pfs:defineTextColumn name="modeloFacturacionInicial" />
			<pfs:defineTextColumn name="modeloFacturacionActual" />
			<pfs:defineTextColumn name="modeloFacturacion_id" />
			<pfs:defineTextColumn name="totalImporteCobros" />
			<pfs:defineTextColumn name="totalImporteFacturable" />
	</pfs:defineRecordType>
	
	var subcarterasCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.id" text="**Id" />', hidden: 'true', dataIndex : 'id',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.idProcesoFacturacion" text="**IdProcesoFacturacion" />', hidden: 'true', dataIndex : 'idProcesoFacturacion',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.cartera" text="**Cartera" />', dataIndex : 'cartera',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.subCartera" text="**SubCartera" />',  dataIndex : 'subCartera',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.idModeloFacturacionInicial" text="**Modelo Factur. Id" />', hidden: 'true', dataIndex : 'idModeloFacturacionInicial',sortable:true}
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.modeloFacturacionInicial" text="**Modelo Factur." />', dataIndex : 'modeloFacturacionInicial',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.modeloFacturacionActual" text="**Modelo Factur. Corregido" />', dataIndex : 'modeloFacturacion_id',renderer:modeloFacturacion_nombre , sortable:true,editor: modeloNuevo_edit}	
	]);	
			
		
    
   	<pfs:remoteStore name="subcarterasDS" resultRootVar="subcarteras" recordType="subcarteraFacturacion"  
   		 parameters="getParametros"  dataFlow="recobroprocesosfacturacion/listaSubcarterasProcesoFacturacion" autoload="true"/>
 
 	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloFacturacion.editarModelos.guardar" text="**Guardar" />'
		,iconCls:'icon_ok'
		,handler : function(){
			if (storeValues.length == 0) {
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.editarModelos.nadaGuardar" text="**No hay nada modificado" />');
			} else { 
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.editarModelos.guardar" text="**Guardar" />',
				'<s:message code="plugin.recobroConfig.modeloFacturacion.editarModelos.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
			}
		}
		,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
		,guardar : function(){
			var parms = {};
			parms.subcarteras=getArrayParam(storeValues);
			page.webflow({
				flow : 'recobroprocesosfacturacion/saveModelosFacturacionSubcarteras' 
				,params : parms
				,success : function(){ page.fireEvent(app.event.DONE); }				
			});
		}
	});
	
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			if (storeValues.length == 0) {
				page.fireEvent(app.event.CANCEL);
			} else { 
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.cancelar" text="**Cancelar" />',
				'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.seguroCancelar" text="**¿Seguro que desea descartar los cambios?" />', function(btn){				
	  				if (btn == "yes") {
	  					page.fireEvent(app.event.CANCEL);
					}
				});
			}
		}
	});
	
 	var gridSubcarteras = new Ext.grid.EditorGridPanel({
        store: subcarterasDS
        ,cm: subcarterasCM
        ,title: '<s:message code="plugin.recobroConfig.procesoFacturacion.gridSubcarteras.title" text="**Listado de subcarteras: Modelos de facturación + importes"/>'
        ,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,bbar:[btnGuardar,btnCancelar]
    });	
    
    var storeValues=[];
	var storeIndices={};
	
	gridSubcarteras.on('afteredit', function(editEvent){
		var campo = editEvent.field;
				
		var indice = storeIndices['indice['+editEvent.row+'].'+editEvent.field];
		
		if (indice == undefined) {
			indice = storeValues.length;
			storeIndices['indice['+editEvent.row+'].'+editEvent.field]=indice;
		}
		
		var obj = {};
		obj.idSubcarteraFacturacion = subcarterasDS.getAt(editEvent.row).get('id');
		obj.campo = editEvent.field;
		obj.valor = editEvent.value;
						
		storeValues[indice]=obj;

	});
	
	
	function getArrayParam(allRecords){
	    var myArrayParam = new MyArrayParam();
	    myArrayParam.subCarteraItems = allRecords;
	    return Ext.encode(myArrayParam);
	}
	
	 
	MyArrayParam = function() {
	    var subCarteraItems;
	}
	
	
	var compuesto = new Ext.Panel({
	    items : [{items:[gridSubcarteras],border:false,style:'margin-top: 7px; margin-left:5px'}]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	page.add(compuesto);

</fwk:page>