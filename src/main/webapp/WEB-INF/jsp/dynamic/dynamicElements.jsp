<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"  %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

 
<fwk:page>

	var element = Ext.data.Record.create([
		{name : 'entity'}
		,{name : 'name'}
	]);
	
	var store = page.getStore({
		flow : 'dynamic/dynamicElementsData'
		,reader : new Ext.data.JsonReader({	root : 'data'}, element)
	});

	var rend = function(data){
		if(data.charAt(0)=="-"){
			return "<span style='color:red'>"+data+"</span>";
		}
		return data;
	}

	var cm = new Ext.grid.ColumnModel([
		{header : 'Entity', dataIndex : 'entity' , renderer : rend}
		,{header : 'Name', dataIndex : 'name' }
	]);

	var grid = app.crearGrid( store, cm, {
		title : 'elementos'
		,autoWidth : true
		,height : 400
	});


	var refresh = new Ext.Button({
		text : 'refresh'
		,handler : function(){
			store.webflow();
			}
	});


	
	var enable = new Ext.Button({
		text : 'enable/disable'
		,handler : function(){
			var rec = grid.getSelectionModel().getSelected();
			if (!rec) return;
			var params = {};
			params.entity = rec.get("entity");
			params.name = rec.get("name");
			if (params.entity.charAt(0)=="-"){
				params.newEntity = params.entity.substr(1,100);
			}else{
				params.newEntity = "-"+params.entity;
			}
			
			page.webflow({
				flow : 'dynamic/dynamicElementChangeEntity'
				,params : params
				,success : function() { store.webflow(); }
			});
		}
	});

	var panel = new Ext.Panel({
		title : 'elementos dinamicos'
		,autoWidth : true
		,items : [ grid ]
		,bbar : [ refresh, enable ]
	});
	
	page.add( panel );


</fwk:page>