<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	
	<pfs:defineParameters name="itinerarioParam" paramId="${itinerario.id}"/>
	
	<pfs:defineRecordType name="EstadosItiRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="estadoItinerario"/>
		<pfs:defineTextColumn name="gestorPerfil"/>
		<pfs:defineTextColumn name="supervisor"/>
		<pfs:defineTextColumn name="plazo"/>
		
	</pfs:defineRecordType>
	
	var estados = Ext.data.Record.create([
		{name:'id',sortType:Ext.data.SortTypes.asInt}
		,'estadoItinerario'
		,'gestorPerfil'
		,'supervisor'
		,'plazo'
	]);
	
	var estadosDS = page.getStore({
		eventName : 'getData'
		,flow : 'plugin/itinerarios/plugin.itienerarios.modificarEstadosItinerario' 
		,reader: new Ext.data.JsonReader({
    		root : 'estadosItinerario'
   	 	}, estados)
	});

	estadosDS.webflow();
	
	<%-- 	--%>
	var btnGuardar = new Ext.Button({
	text : '<s:message code="plugin.itinerarios.editarEstados.guardar" text="**Guardar" />'
	,iconCls:'icon_ok'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.itinerarios.editarEstados.guardar" text="**Guardar" />','<s:message code="plugin.itinerarios.editarEstados.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
		//this.guardar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
	,guardar : function(){
			page.webflow({
				flow : 'plugin/itinerarios/plugin.itienerarios.modificarEstadosItinerario' 
				,eventName : 'update'
				,success : function(){ page.fireEvent(app.event.DONE); }
				,params : grid.modifiedData
			});
		}
	});
	
	
	var btnCancelar = new Ext.Button({
	text : '<s:message code="plugin.itinerarios.editarEstados.cancelar" text="**Cancelar" />'
	,iconCls:'icon_cancel'
	,handler : function(){
		Ext.Msg.confirm('<s:message code="plugin.itinerarios.editarEstados.cancelar" text="**Cancelar" />','<s:message code="plugin.itinerarios.editarEstados.seguroCancelar" text="**¿Seguro que desea descartar los cambios?" />',this.decide,this);
		//this.cancelar();
		}
	,decide : function(boton){
			if (boton=='yes'){
				this.cancelar();
			}
		}
	,cancelar : function(){
			page.webflow({
				flow : 'plugin/itinerarios/plugin.itienerarios.modificarEstadosItinerario' 
				,eventName : 'fin1'
				,success : function(){ page.fireEvent(app.event.CANCEL); }
			});
		}
	});
	
	<pfsforms:ddCombo name="gestor_edit" labelKey="" label="" value="" dd="${gestores}"/>
	
	var gestores = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion'],
		data : gestor_editDiccionario,
		root : 'diccionario'
	});

	var gestor_nombre = function(val){
		return gestores.queryBy(function(rec){
			return rec.data.codigo == val;
		}).itemAt(0).data.descripcion;
	}
	
	<pfsforms:ddCombo name="supervisor_edit" labelKey="" label="" value="" dd="${supervisores}"/>
	
	
	var supervisores = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion'],
		data : supervisor_editDiccionario,
		root : 'diccionario'
	});
	
	var supervisor_nombre = function(val){
		return supervisores.queryBy(function(rec){
			return rec.data.codigo == val;
		}).itemAt(0).data.descripcion;
	}
	
	
	
	var plazo_edit = new Ext.form.TextField();
	
	
	Ext.util.CSS.createStyleSheet(".icon_estados { background-image: url('../img/plugin/itinerarios/arrow-transition.png');}");
	
	
	var grid = new Ext.grid.EditorGridPanel({
		title: '<s:message code="plugin.itinerarios.editarEstados.titulo" text="**Estados del itinerario" arguments="${itinerario.nombre}"/>',
		stripeRows: true,
		resizable:true, 
		autoHeight: true,
		cls:'cursor_pointer',
		clickstoEdit: 1,
		store: estadosDS,
		iconCls:'icon_estados',
		columns: [
			{header: '<s:message code="plugin.itinerarios.estados.tipoEstado" text="**Tipo de Estado" />', dataIndex: 'estadoItinerario'},
			{header: '<s:message code="plugin.itinerarios.estados.gestor" text="**Perfil del gestor" />', dataIndex: 'gestorPerfil',renderer: gestor_nombre, editor:gestor_edit},
			{header: '<s:message code="plugin.itinerarios.estados.supervisor" text="**Perfil del supervisor" />', dataIndex: 'supervisor',renderer: gestor_nombre, editor:gestor_edit},	
			{header: '<s:message code="plugin.itinerarios.estados.plazo" text="**Plazo" />', dataIndex: 'plazo',  editor:plazo_edit}
		],
		bbar:[btnGuardar,btnCancelar]		
	});
	
	grid.modifiedData={};
	grid.on('afteredit', function(editEvent){
			grid.modifiedData['dtoEstados['+editEvent.row+'].'+editEvent.field]=((editEvent.field=='plazo')?(editEvent.value*86400000):editEvent.value);
		});
	
	<%--
	grid.on('afteredit', function(editEvent){
		if (editEvent.field=='plazo'){
			grid.modifiedData['estados['+editEvent.row+'].'+editEvent.field]=editEvent.value*86400000;
		} else {
			grid.modifiedData['estados['+editEvent.row+'].'+editEvent.field]=editEvent.value;
		}
	});
	
	//grid.on('rowdblclick', function(grid, rowIndex, e){
	//	var rec = estadosDS.getAt(rowIndex);
	//	openWindow('/pfs/admin/editUsuario.htm',{id : rec.get('username')});
	//}); --%>
	
	
	page.add(grid);
	

</fwk:page>