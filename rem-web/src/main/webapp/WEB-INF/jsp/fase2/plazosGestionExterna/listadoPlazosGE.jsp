<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var plazos = {plazos :[	
		{plaza:1,juzgado:2,procedimiento:3,tarea:4,dias:5}
		,{plaza:6,juzgado:'*',procedimiento:'*',tarea:'*',dias:5}
		,{plaza:6,juzgado:2,procedimiento:'*',tarea:'*',dias:5}
	]};
	
	var plazosStore = new Ext.data.JsonStore({
		data : plazos
		,root : 'plazos'
		,fields : ['plaza', 'juzgado','procedimiento','tarea','dias']
	});
	var plazosCm = new Ext.grid.ColumnModel([
		{header :  '<s:message code="plazos.plaza" text="**Plaza"/>', dataIndex : 'plaza' }
		,{header : '<s:message code="plazos.juzgado" text="**Juzgado"/>', dataIndex : 'juzgado' }
		,{header : '<s:message code="plazos.procedimiento" text="**Procedimiento"/>', dataIndex : 'procedimiento' }
		,{header : '<s:message code="plazos.tarea" text="**Tarea"/>', dataIndex : 'tarea' }
		,{header : '<s:message code="plazos.dias" text="**Dias"/>', dataIndex : 'dias' }
	]);
	
	var btnAgregar = app.crearBotonAgregar({
		flow:'fase2/plazosGestionExterna/altaEdicionPlazoGE'
		,title : '<s:message code="plazos.agregar" text="**Agregar Plazo" />'
		,width:500
		,page : page
	});
	var btnEditar = app.crearBotonEditar({
		flow:'fase2/plazosGestionExterna/altaEdicionPlazoGE'
		,title : '<s:message code="plazos.edicion" text="**Editar Plazo" />'
		,width:500
		,page : page
	});
	var btnBorrar = app.crearBotonBorrar({
		flow : ''
		,page : page
	});
	var plazosGrid = app.crearGrid(plazosStore,plazosCm,{
		title:'<s:message code="listadoplazos.titulo" text="**Lista de Plazos Configurados" />'
		,style:'padding-right:10px'
		,bbar:[btnAgregar,btnEditar,btnBorrar]
		
	});
	var panel=new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:plazosGrid
		
	})
	page.add(panel);
</fwk:page>