<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
		
	/* Grid Atipicos en el Contrato */

	var atipicos = <json:object>
			<json:array name="atipicos" items="${contrato.contratoPersonaOrdenado}" var="obs">
				 <json:object>
				   	<json:property name="nombre">${obs.persona.nombre}</json:property>
				   	<json:property name="apellidos">${obs.persona.apellido1} ${obs.persona.apellido2}</json:property>
				   	<json:property name="apellido1">${obs.persona.apellido1}</json:property>
				   	<json:property name="apellido2">${obs.persona.apellido2}</json:property>
				   	<json:property name="codClienteEntidad">${obs.persona.codClienteEntidad}</json:property>
				   	<json:property name="nif">${obs.persona.docId}</json:property>
				   	<json:property name="saldoVencido">${obs.persona.riesgoDirectoVencido}</json:property>
				   	<json:property name="totalRiesgo">${obs.persona.riesgoTotal}</json:property>
				   	<json:property name="numContratos">${obs.persona.numContratos}</json:property>
				   	<json:property name="situacion">${obs.persona.situacion}</json:property>
				   	<json:property name="tipoIntervencion">${obs.tipoIntervencion.descripcion} ${obs.orden}</json:property>
					<<json:property name="id" value="${obs.persona.id}" />
					<json:property name="apellidoNombre" value="${obs.persona.apellidoNombre}"/>
				 </json:object>
			</json:array>
		</json:object>
		;

	var atipicosStore = new Ext.data.JsonStore({
		data : atipicos
		,root : 'atipicos'
		,fields : ['fecha','codigo','tipo','nif','importe','fechaValor','motivo']
	});

	var atipicosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="contrato.consulta.tabAtipicos.listado.fecha" text="**Fecha" />', dataIndex : 'nombre', sortable:true, width:130 }
		,{header : '<s:message code="contrato.consulta.tabAtipicos.listado.codigo" text="**Código" />', dataIndex : 'apellidos', sortable:false, width:130 }
		,{header : '<s:message code="contrato.consulta.tabAtipicos.listado.tipo" text="**Tipo" />', dataIndex : 'codClienteEntidad', sortable:true, width:80 }	
		,{header : '<s:message code="contrato.consulta.tabAtipicos.listado.importe" text="**Importe" />', dataIndex : 'nif', sortable:true, width:80 }
		,{header : '<s:message code="contrato.consulta.tabAtipicos.listado.fechaValor" text="**Fecha valor" />', dataIndex : 'saldoVencido', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}	
		,{header : '<s:message code="contrato.consulta.tabAtipicos.listado.motivo" text="**Motivo" />', dataIndex : 'totalRiesgo', sortable:true, renderer: app.format.moneyRenderer, width:80, align:'right'}
		,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}
		,{header : 'apellidoNombre', dataIndex: 'apellidoNombre', hidden:true,fixed:true}
	]);	

	var pagingBar=fwk.ux.getPaging(atipicosStore);

	var grid = app.crearGrid(atipicosStore, atipicosCm, {
		title : '<s:message code="contrato.consulta.tabAtipicos.listado" text="**Listado de operaciones atípicas" />'
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
		title:'<s:message code="contrato.consulta.tabAtipicos.titulo" text="**Atipicos"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [grid]
		,nombreTab : 'tabAtipicos'
	});
	
	return panel;
})()