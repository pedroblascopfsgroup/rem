<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var arquetipos = {arquetipos :[	
		{id:'1',descripcion: 'Lista Blanca', activo : 'Si',fechacreacion:'01/01/2008',fechaprimeruso:'01/01/2008',prioridad:'1'}
		,{descripcion: 'Empleados/Consejeros', activo : 'No',fechacreacion:'01/01/2008',fechaprimeruso:'01/01/2008',prioridad:'2'}
		]};
	
	var arquetiposStore = new Ext.data.JsonStore({
		data : arquetipos
		,root : 'arquetipos'
		,fields : ['descripcion', 'activo','fechacreacion','fechaprimeruso','prioridad']
	});
	var arquetiposCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="arquetipos.descripcion" text="**descripcion"/>', dataIndex : 'descripcion' }
		,{header : '<s:message code="arquetipos.activo" text="**activo"/>', dataIndex : 'activo' }
		,{header : '<s:message code="arquetipos.fechacreacion" text="**Fecha Creacion"/>', dataIndex : 'fechacreacion' }
		,{header : '<s:message code="arquetipos.fechaprimeruso" text="**Fecha Primer Uso"/>', dataIndex : 'fechaprimeruso' }
		,{header : '<s:message code="arquetipos.prioridad" text="**Prioridad"/>', dataIndex : 'prioridad' }
	]);
	
	var btnAgregar = app.crearBotonAgregar({
		flow:'fase2/arquetiposItinerarios/altaEdicionArquetipo'
		,title : '<s:message code="arquetipos.alta" text="**Alta Arquetipos" />'
		,width:500
		,page : page
	});
	var btnEditar = app.crearBotonEditar({
		flow:'fase2/arquetiposItinerarios/altaEdicionArquetipo'
		,title : '<s:message code="arquetipos.edicion" text="**Edicion Arquetipos" />'
		,width:500
		,page : page
	});
	var btnBorrar = app.crearBotonBorrar({
		flow : ''
		,page : page
	});
	var arquetiposGrid = app.crearGrid(arquetiposStore,arquetiposCm,{
		title:'<s:message code="listadoarquetipos.titulo" text="**Lista de Arquetipos Configurados" />'
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