<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
		
	var panel = new Ext.Panel({
		title:'<s:message code="contrato.consulta.tabIntervinientes.titulo" text="**Intervinientes"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,nombreTab : 'tabIntervinientes'
	});

	/* Grid Intervinientes en el Contrato */

	var intervinientesStore = new Ext.data.JsonStore({
		data :  { intervinientes : [] }
		,root : 'intervinientes'
		,fields : ['nombre','apellidos', 'apellido1','apellido2','codClienteEntidad','nif','saldoVencido','totalRiesgo','numContratos'
				,'situacion','tipoIntervencion','id','apellidoNombre']
	});

	entidad.cacheStore(intervinientesStore);

	var intervinientesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.nombre" text="**Nombre" />', dataIndex : 'nombre', sortable:true, width:130 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.apellidos" text="**Apellidos" />', dataIndex : 'apellidos', sortable:true, width:230 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.codClienteEntidad" text="**Código interno" />', dataIndex : 'codClienteEntidad', sortable:true, width:80 }	
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.nif" text="**Nro. Documento" />', dataIndex : 'nif', sortable:true, width:80 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.saldoVencido" text="**Saldo Vencido" />', dataIndex : 'saldoVencido', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}	
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.totalRiesgo" text="**Riesgo Total" />', dataIndex : 'totalRiesgo', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.numContratos" text="**Contratos" />', dataIndex : 'numContratos', sortable:true, align:'right', width:50 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.situacion" text="**Situacin" />', dataIndex : 'situacion', sortable:true, width:100 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.tipoIntervencion" text="**T. Intervencion" />', dataIndex : 'tipoIntervencion', sortable:true, width:100 }
		,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}
		,{header : 'apellidoNombre', dataIndex: 'apellidoNombre', hidden:true,fixed:true}
	]);	

	var pagingBar=fwk.ux.getPaging(intervinientesStore);

	var grid = app.crearGrid(intervinientesStore, intervinientesCm, {
		title : '<s:message code="contrato.consulta.tabIntervinientes.clientes" text="**Clientes" />'
		,width : 600
		,height: 448
		,bbar : [  pagingBar ]
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	}); 

	grid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_cliente=rec.get('apellidoNombre');
    	app.abreCliente(rec.get('id'), nombre_cliente);
    });

	panel.add(grid);

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		intervinientesStore.removeAll();
		intervinientesStore.loadData(data.intervinientes);
		window.inte=intervinientesStore;
		window.intedata=data.intervinientes;
	}
	
	return panel;
})
