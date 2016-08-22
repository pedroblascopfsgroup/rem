<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
var getListadoAsuntos=function(){
	
	var Asunto = Ext.data.Record.create([
		{name:'id'}
		,{name:'fcreacion'}
		,{name:'gestor'}
		,{name:'estado'}
		,{name:'supervisor'}
		,{name:'despacho'}	
	]);
	
	asuntosStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/listadoAsuntosData'
		,reader: new Ext.data.JsonReader({
			root: 'asuntos'
		}, Asunto)
	});
	
	asuntosStore.webflow({id:'${expediente.id}', idSesion:${expediente.comite.ultimaSesion.id}});
	
	
	
	var asuntosCm = new Ext.grid.ColumnModel([{
		header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>',
		dataIndex: 'id'
	}, {
		header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>',
		dataIndex: 'fcreacion'
	}, {
		header: '<s:message code="asuntos.listado.estado" text="**Estado"/>',
		dataIndex: 'estado'
	}, {
		header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>',
		dataIndex: 'gestor'
	}, {
		header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>',
		dataIndex: 'despacho'
	}, {
		header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>',
		dataIndex: 'supervisor'
	}]);
	
	
	var btnNuevo = new Ext.Button({
		text : '<s:message code="app.nuevo" text="**Nuevo" />'
		,iconCls : 'icon_mas'
		,handler : function(){
			page.fireEvent(app.event.DONE);
			win = app.openWindow(
				{
					flow:'fase2/asuntos/altaAsuntos_fase2'
					,width:700 
					,title : '<s:message code="decisionComite.asuntos" text="**Alta Asuntos" />'
					,params: {idExpediente:${expediente.id}}
				}
			);
			win.on(app.event.CANCEL,function(){win.close();});
			win.on(app.event.DONE,
					function(){
						win.close();
						asuntosStore.webflow({id:${expediente.id}, idSesion:${expediente.comite.ultimaSesion.id}});
						cantidadAsuntos = asuntosStore.getCount();
					}
			);
		}
	});
	
	var btnEditar = new Ext.Button({
		text: '<s:message code="app.editar" text="**Editar" />',
		iconCls: 'icon_edit',
		handler: function(){
			var win=app.openWindow({
				flow: 'fase2/asuntos/altaAsuntos_fase2'
				,width:700 
				,title: '<s:message code="asuntos.window.editar" text="**Datos del asunto" />'
				,params: {idExpediente:${expediente.id}}
			});
			win.on(app.event.CANCEL,function(){win.close();});
			win.on(app.event.DONE,
					function(){
						win.close();
						//asuntosStore.webflow({id:${expediente.id}, idSesion:${expediente.comite.ultimaSesion.id}});
						//cantidadAsuntos = asuntosStore.getCount();
					}
			);
		}
	});
	
	var btnBorrar = new Ext.Button({
		text: '<s:message code="asuntos.boton.borrar" text="**Borrar este asunto" />',
		iconCls: 'icon_menos',
		handler: function(){
		}
	});
	
	var asuntosGrid = new Ext.grid.GridPanel({
		title: '<s:message code="asuntos.grid.titulo" text="**asuntos" />',
		store: asuntosStore,
		cm: asuntosCm,
		loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"},
		width: asuntosCm.getTotalWidth(),
		height: 200,
		bbar: [
			<c:if test="${expediente.estadoExpediente==2}"> 
				btnNuevo
			</c:if>	
			//TODO: botones editar y borrar son para fase 2
			,btnEditar
			,btnBorrar
		]
	});
	
	
	return asuntosGrid;

}
