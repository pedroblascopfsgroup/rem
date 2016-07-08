<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
var getListadoAsuntos=function(){
	
	var Asunto = Ext.data.Record.create([
		{name:'id', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'fcreacion',type:'date', dateFormat:'d/m/Y'}
		,{name:'gestor', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'estado', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'supervisor', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'despacho', type:'string', sortType:Ext.data.SortTypes.asText}	
	]);
	
	var asuntosStore = page.getStore({
		eventName : 'listado'
		,flow:'expedientes/listadoAsuntosExpedienteData'
		,reader: new Ext.data.JsonReader({
			root: 'asuntos'
		}, Asunto)
	});
	 
	asuntosStore.webflow({id:'${expediente.id}', idSesion:${expediente.comite.ultimaSesion.id}});
	
	
	
	var asuntosCm = new Ext.grid.ColumnModel([{
		header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>',
		dataIndex: 'id', sortable:true
	}, {
		header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>',
		dataIndex: 'fcreacion'
		,renderer:app.format.dateRenderer,sortable:true
	}, {
		header: '<s:message code="asuntos.listado.estado" text="**Estado"/>',
		dataIndex: 'estado',sortable:true
	}, {
		header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>',
		dataIndex: 'gestor',sortable:true
	}, {
		header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>',
		dataIndex: 'despacho',sortable:true
	}, {
		header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>',
		dataIndex: 'supervisor',sortable:true
	}]);
	
	
	var btnNuevo = new Ext.Button({
		text : '<s:message code="app.nuevo" text="**Nuevo" />'
		,iconCls : 'icon_mas'
		,handler : function(){
			page.fireEvent(app.event.DONE);
			win = app.openWindow(
				{
					flow:'asuntos/altaAsuntos', 
					title : '<s:message code="decisionComite.asuntos" text="**Alta Asuntos" />',
					params: {idExpediente:${expediente.id}},
					width: 780
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
			if (idAsuntoSeleccionado){
				var win = app.openWindow({
					flow: 'expedientes/editaAsuntos'
					,title: '<s:message code="decisionComite.asuntos.editar" text="**Datos del asunto" />'
					,closable:true
					,params:{idExpediente:${expediente.id},idAsunto:idAsuntoSeleccionado}
					,width: 780
				});
				win.on(app.event.CANCEL,function(){win.close();});
				win.on(app.event.DONE,
					function(){
						win.close();
						asuntosStore.webflow({id:${expediente.id}, idSesion:${expediente.comite.ultimaSesion.id}});
						cantidadAsuntos = asuntosStore.getCount();
					}
				);
			}else{
	           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.sinSeleccion"/>')	
	        }
		}
	});
	
	var btnBorrar = new Ext.Button({
		text: '<s:message code="asuntos.boton.borrar" text="**Borrar este asunto" />',
		iconCls: 'icon_menos',
		handler: function(){
			if (idAsuntoSeleccionado){
				//BORRAR EL ASUNTOS
				Ext.Msg.confirm('<s:message code="dc.asuntos.listado.borrar" text="**Borrar Asunto" />', 
	                    	       '<s:message code="dc.asuntos.listado.borrarMsg" text="**Est&aacute; seguro de que desea borrar el Asunto?" />',
	                    	       this.evaluateAndSend); 		
			}else{
	           	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.sinSeleccion"/>')	
	        }
		}
		,evaluateAndSend: function(seguir) {
	         			if(seguir== 'yes') {            
	            			page.webflow({
								flow: 'asuntos/borraAsunto' 
								,eventName: 'borrarAsunto'
								,params:{idAsunto:idAsuntoSeleccionado}
								,success: function(){
									asuntosStore.webflow({id:${expediente.id}, idSesion:${expediente.comite.ultimaSesion.id}});
									cantidadAsuntos = asuntosStore.getCount();
								}	 
							});
	         			}
	       			 } 
	});
	
	var asuntosGrid = new Ext.grid.GridPanel({
		title: '<s:message code="asuntos.grid.titulo" text="**asuntos" />',
		store: asuntosStore,
		loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"},
		cm: asuntosCm,
		width: asuntosCm.getTotalWidth(),
		height: 200,
		bbar: [
			<c:if test="${expediente.estaCongelado}"> 
				btnNuevo
				,btnEditar
				,btnBorrar
			</c:if>	
		]
	});
	
	var idAsuntoSeleccionado = 0;
	
	asuntosGrid.on('rowclick', function(grid, rowIndex, e){                                                                                                         
		var rec = grid.getStore().getAt(rowIndex);
		idAsuntoSeleccionado = rec.get('id');  
	
	});   
	
	asuntosGrid.refrescar = function(){
		asuntosStore.webflow({id:'${expediente.id}', idSesion:${expediente.comite.ultimaSesion.id}});
	}
	
	return asuntosGrid;

}
