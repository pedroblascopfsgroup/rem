<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createTitulosAsuntoTab=function(){

	var Titulo = Ext.data.Record.create([
		{name:'id'}
		,{name:'codigo'}
		,{name:'tipo'}
		,{name:'tipodocumento'}
		,{name:'incidencias'}
		,{name:'intervencion'}
		,{name:'comentario'}	
	]);
	
    
    var titulosStore = page.getStore({
            flow:'asuntos/tabTitulosAsuntos'
            ,reader: new Ext.data.JsonReader({
                root: 'contratos'
            }, Titulo)
        });
	var titulosCM  = new Ext.grid.ColumnModel([
		{hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		{header:'<s:message code="asunto.tabcabecera.grid.contrato" text="**Contrato"/>',dataIndex:'codigo',width:100},
		{header:'<s:message code="expedientes.consulta.tabtitulos.tipo" text="**Tipo"/>',dataIndex:'tipo',width:80},
		{header:'<s:message code="expedientes.consulta.tabtitulos.tipodocumento" text="**Tipo Documento"/>',dataIndex:'tipodocumento',width:80},
		{header:'<s:message code="expedientes.consulta.tabtitulos.incidencias" text="**Incidencias"/>',dataIndex:'incidencias',width:80},
		{header:'<s:message code="expedientes.consulta.tabtitulos.intervencion" text="**Intervencion"/>',dataIndex:'intervencion',width:76,renderer:app.format.booleanToYesNoRenderer},
		{header:'<s:message code="expedientes.consulta.tabtitulos.comentario" text="**Comentario"/>',dataIndex:'comentario',width:170}
	]);
	
	var titulosGrid = app.crearGrid(titulosStore,titulosCM,{
		title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
		,style:'padding-right:10px;'
		,iconCls:'icon_titulo'
		,width : 700
		,height : 420
	});
	var panel = new Ext.Panel({
		title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[titulosGrid]
	});
	titulosStore.webflow({id:'${asunto.id}'});
	return panel;
};
