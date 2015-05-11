<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var titulo = Ext.data.Record.create([
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
	    ,storeId : 'titulosStore'
        ,reader: new Ext.data.JsonReader({
            root: 'contratos'
        }, titulo)
    });
	
	entidad.cacheStore(titulosStore);
	
	var titulosCM  = new Ext.grid.ColumnModel([
		{header:'<s:message code="asunto.tabcabecera.grid.id" text="**Id"/>',hidden:true,sortable: false, dataIndex: 'id',fixed:true},
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
		,nombreTab : 'titulosAsunto'
	});

	panel.getValue = function() {}

	panel.setValue = function() {
		var data = entidad.get("data");
		//ANGEL: TODO: fix this load!!!
   		entidad.cacheOrLoad(data, titulosStore, { id : data.id } );
	}
	
	panel.setVisibleTab = function(data){
		<sec:authorize ifAllGranted="ROLE_VER_TAB_DOCUMENTOS">
		return true;
		</sec:authorize>
		return false;
	}
	
	return panel;
})
