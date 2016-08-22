<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var arquetipos = {arquetipos :[	
		{id:'1',descripcion: 'Itinerario General', activo : 'Si',fechacreacion:'01/01/2008',fechaprimeruso:'01/01/2008',arqasociados:'1'}
		,{id:'2',descripcion: 'Sin Gestion', activo : 'No',fechacreacion:'01/01/2008',fechaprimeruso:'01/01/2008',arqasociados:'2'}
		]};
	
	var arquetiposStore = new Ext.data.JsonStore({
		data : arquetipos
		,root : 'arquetipos'
		,fields : ['descripcion', 'activo','fechacreacion','fechaprimeruso','arqasociados']
	});
	var arquetiposCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="itinerarios.descripcion" text="**descripcion"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="itinerarios.activo" text="**activo"/>', dataIndex : 'activo' }
		,{header : '<s:message code="itinerarios.fechacreacion" text="**Fecha Creacion"/>', dataIndex : 'fechacreacion' }
		,{header : '<s:message code="itinerarios.fechaprimeruso" text="**Fecha Primer Uso"/>', dataIndex : 'fechaprimeruso' }
		,{header : '<s:message code="itinerarios.arqasociados" text="**Arquetipos Asociados"/>', dataIndex : 'arqasociados' }
	]);
	
	var btnAgregar = app.crearBotonAgregar({
		flow:'fase2/arquetiposItinerarios/altaEdicionItinerario'
		,title : '<s:message code="itinerarios.alta" text="**Alta itinerarios" />'
		,width:600
		,page : page
	});
	var btnEditar = app.crearBotonEditar({
		flow:'fase2/arquetiposItinerarios/altaEdicionItinerario'
		,title : '<s:message code="itinerarios.edicion" text="**Edicion Itinerarios" />'
		,width:600
		,page : page
	});
	var btnBorrar = app.crearBotonBorrar({
		flow : ''
		,page : page
	});
	var arquetiposGrid = app.crearGrid(arquetiposStore,arquetiposCm,{
		title:'<s:message code="listadoitinerarios.title" text="**Configuracion de Itinerarios" />'
		,style:'padding-right:10px'
		,bbar:[btnAgregar,btnEditar,btnBorrar]
		
	});
	var panel=new Ext.Panel({
		autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:arquetiposGrid
		
	})
	page.add(panel);
</fwk:page>