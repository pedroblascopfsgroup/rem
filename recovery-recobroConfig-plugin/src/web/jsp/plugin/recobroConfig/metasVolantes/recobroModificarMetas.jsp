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
	
	<pfsforms:textfield name="plazoMaxGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoMaxGestion" 
		label="**Plazo máximo gestión" value="${itinerario.plazoMaxGestion}" readOnly="true" />
	
	<pfsforms:textfield name="plazoSinGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoGestionSin" 
		label="**Plazo sin gestión" value="${itinerario.plazoSinGestion}" readOnly="true" />
	
	<pfs:panel name="panel1" columns="2" collapsible="false">
		<pfs:items items="plazoMaxGestion" width="400" />
		<pfs:items items="plazoSinGestion" width="300"/>
	</pfs:panel>
	
	<pfs:defineRecordType name="MetasItiRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="orden"/>
		<pfs:defineTextColumn name="codigoYDesc"/>
		<pfs:defineTextColumn name="diasDesdeEntrega"/>
		<%--<pfs:defineTextColumn name="bloqueo"/>--%>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="parametros" paramId="${itinerario.id}" />
	
	var metasDS = page.getStore({
		eventName : 'getData'
		,flow : 'plugin/recobroConfig/metasVolantes/modificarMetasItinerarioRecobro' 
		,reader: new Ext.data.JsonReader({
    		root : 'metas'
   	 	}, MetasItiRT)
	});
	
	metasDS.webflow();
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.guardar" text="**Guardar" />'
		,iconCls:'icon_ok'
		,handler : function(){
			Ext.Msg.confirm('<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.guardar" text="**Guardar" />',
			'<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
		}
		,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
		,guardar : function(){
			page.webflow({
				flow : 'plugin/recobroConfig/metasVolantes/modificarMetasItinerarioRecobro' 
				,eventName : 'update'
				,success : function(){ page.fireEvent(app.event.DONE); }
				,params : grid.modifiedData
			});
		}
	});
	
	
	var btnCancelar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			Ext.Msg.confirm('<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.cancelar" text="**Cancelar" />',
			'<s:message code="plugin.recobroConfig.metasVolantes.editarMetas.seguroCancelar" text="**¿Seguro que desea descartar los cambios?" />',this.decide,this);
		}
		,decide : function(boton){
			if (boton=='yes'){
				this.cancelar();
			}
		}
		,cancelar : function(){
			page.webflow({
				flow : 'plugin/recobroConfig/metasVolantes/modificarMetasItinerarioRecobro' 
				,eventName : 'fin1'
				,success : function(){ page.fireEvent(app.event.CANCEL); }
			});
		}
	});
	
	 
	<pfsforms:ddCombo name="bloqueo_edit" labelKey="" label="" value="" 
			dd="${ddSiNo}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
	
	var ddSiNo = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion'],
		data : bloqueo_editDiccionario,
		root : 'diccionario'
	});

	
	var bloqueo_nombre = function(val){
		return ddSiNo.queryBy(function(rec){
			return  rec.data.codigo == val;
		}).itemAt(0).data.descripcion;
	};	
	
	var dias_edit = new Ext.form.NumberField();
	
	var grid = new Ext.grid.EditorGridPanel({
		title: '<s:message code="plugin.recobroConfig.metasVolantes.configuracion" text="**Configuración de condiciones de rotación de cartera"/>',
		stripeRows: true,
		resizable:true, 
		autoHeight: true,
		cls:'cursor_pointer',
		clickstoEdit: 1,
		store: metasDS,
		columns: [
			{header: '<s:message code="plugin.recobroConfig.metasVolantes.id" text="**Id" />', dataIndex: 'id', hidden:true},
			{header: '<s:message code="plugin.recobroConfig.metasVolantes.orden" text="**Orden" />', dataIndex: 'orden'},
			{header: '<s:message code="plugin.recobroConfig.metasVolantes.codigoYDesc" text="**Código + Descripción Evento" />', dataIndex: 'codigoYDesc', width:400},
			{header: '<s:message code="plugin.recobroConfig.metasVolantes.diasEntrega" text="**Días desde entrega" />', dataIndex: 'diasDesdeEntrega', editor:dias_edit, width:150}	
			//,{header: '<s:message code="plugin.recobroConfig.metasVolantes.bloqueo" text="**Bloqueo" />', dataIndex: 'bloqueo',renderer:bloqueo_nombre,  editor:bloqueo_edit, width:150}
		],
		bbar:[btnGuardar,btnCancelar]	
	});
	
	grid.modifiedData={};
	grid.on('afteredit', function(editEvent){
			grid.modifiedData['listaDtoMetas['+editEvent.row+'].'+editEvent.field]=editEvent.value;
		});
	
	
	var compuesto = new Ext.Panel({
	    items : [{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[grid],border:false,style:'margin-top: 7px; margin-left:5px'}]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	page.add(compuesto);
	

</fwk:page>