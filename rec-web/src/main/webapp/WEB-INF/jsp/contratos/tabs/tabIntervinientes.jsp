<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
		
	/* Grid Intervinientes en el Contrato */

	var intervinientes = <json:object>
			<json:array name="intervinientes" items="${contrato.contratoPersonaOrdenado}" var="obs">
				 <json:object>
				   	<json:property name="nombre">${obs.persona.nombre}</json:property>
				   	<json:property name="apellido1">${obs.persona.apellido1}</json:property>
				   	<json:property name="apellido2">${obs.persona.apellido2}</json:property>
				   	<json:property name="codClienteEntidad">${obs.persona.codClienteEntidad}</json:property>
				   	<json:property name="nif">${obs.persona.docId}</json:property>
				   	<json:property name="saldoVencido">${obs.persona.totalSaldo}</json:property>
				   	<json:property name="totalRiesgo">${obs.persona.riesgoDirecto}</json:property>
				   	<json:property name="numContratos">${obs.persona.numContratos}</json:property>
				   	<json:property name="situacion">${obs.persona.situacion}</json:property>
				   	<json:property name="tipoIntervencion">${obs.tipoIntervencion.descripcion} ${obs.orden}</json:property>
					<<json:property name="id" value="${obs.persona.id}" />
					<json:property name="apellidoNombre" value="${obs.persona.apellidoNombre}"/>
				 </json:object>
			</json:array>
		</json:object>
		;

	var intervinientesStore = new Ext.data.JsonStore({
		data : intervinientes
		,root : 'intervinientes'
		,fields : ['nombre','apellido1','apellido2','codClienteEntidad','nif','saldoVencido','totalRiesgo','numContratos'
				,'situacion','tipoIntervencion','id','apellidoNombre']
	});

	var intervinientesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.nombre" text="**Nombre" />', dataIndex : 'nombre', sortable:true, width:130 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.apellido1" text="**Primer Apellido" />', dataIndex : 'apellido1', sortable:true, width:130 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.apellido2" text="**Segundo Apellido" />', dataIndex : 'apellido2', sortable:true, width:130 }	
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.codClienteEntidad" text="**Código interno" />', dataIndex : 'codClienteEntidad', sortable:true, width:80 }	
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.nif" text="**Nro. Documento" />', dataIndex : 'nif', sortable:true, width:80 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.saldoVencido" text="**Saldo Vencido" />', dataIndex : 'saldoVencido', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}	
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.totalRiesgo" text="**Riesgo Total" />', dataIndex : 'totalRiesgo', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.numContratos" text="**Contratos" />', dataIndex : 'numContratos', sortable:true, align:'right', width:50 }
		,{header : '<s:message code="contrato.consulta.tabIntervinientes.clientes.situacion" text="**Situación" />', dataIndex : 'situacion', sortable:true, width:100 }
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

	var panel = new Ext.Panel({
		title:'<s:message code="contrato.consulta.tabIntervinientes.titulo" text="**Intervinientes"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [grid]
		,nombreTab : 'tabIntervinientes'
	});
	
	return panel;
})()