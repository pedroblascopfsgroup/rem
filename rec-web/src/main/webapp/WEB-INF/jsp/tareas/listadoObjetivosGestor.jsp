<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var politica=Ext.data.Record.create([
         'id'
		 ,'cliente'
		 ,'idPersona'
		 ,{name:'fvencimiento',type:'date', dateFormat:'d/m/Y'}
		 ,'politica'
		 ,'resumen'
		 ,{name:'finiciopolitica',type:'date', dateFormat:'d/m/Y'}
		 ,'group'
		 ,'objetivos'
	]);
	
	var politicaStore = page.getGroupingStore({
      flow:'tareas/listadoObjetivosGestorData'
	  ,sortInfo:{field: 'fvencimiento', direction: "ASC"}
		,groupField:'group'
		,groupOnSort:'true'
      ,reader: new Ext.data.JsonReader({
        root : 'objetivos'
      } , politica)
     });
	 var groupRenderer=function(val){
		if(val==0)
			return '<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />';
		if(val==1)
			return '<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" />';
		if(val==2)
			return '<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" />';
		if(val==3)
			return '<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />';
		if(val==4)
			return '<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" /> ';
		if(val==5)
			return '<s:message code="main.arbol_tareas.groups.mesesanteriores" text="**meses Anteriores" /> ';
	}
	var politicasCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="politicasgestor.resumen" text="**resumen"/>' ,dataIndex : 'resumen',width:150}
		,{header : '<s:message code="politicasgestor.cliente" text="**Cliente"/>', dataIndex : 'cliente' }
		,{header : '<s:message code="politicasgestor.fvencimiento" text="**Fecha Vencimiento"/>', dataIndex : 'fvencimiento',renderer: app.format.dateRenderer,align:'right',width:40 }
		,{header : '<s:message code="politicasgestor.politica" text="**Politica"/>', dataIndex : 'politica',width:50 }
		,{header : '<s:message code="politicasgestor.finiciopolitica" text="**F. Inicio Politica"/>', dataIndex : 'finiciopolitica',renderer: app.format.dateRenderer,align:'right',width:40 }
		,{header : '<s:message code="politicasgestor.objetivos" text="**Nº Objetivos"/>', dataIndex : 'objetivos',width:35,align:'right' }
		,{header : '<s:message code="politicasgestor.vencimiento" text="**Vencimiento"/>', 	sortable: true, dataIndex: 'group', hidden:true,renderer:groupRenderer}		
		
	]);
	
	var pagingBar=fwk.ux.getPaging(politicaStore);
	
	var grid = app.crearGrid(politicaStore,politicasCm,{
		title:'<s:message code="politicasgestor.grid.titulo" text="**Objetivos Pendientes"/>'
		,iconCls:'icon_objetivos_pendientes'
		,style:'padding-right: 10px'
		,bbar:[pagingBar]
		,cls:'cursor_pointer'
		,frame:false
		//,autoHeight:true
		,height:400
		,view: new Ext.grid.GroupingView({
            forceFit:true
            ,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			//,enableNoGroups:true
        })
	});
	politicaStore.addListener('load', function(store, meta) {
		store.sort('fvencimiento');
		store.groupBy('group', true);
    });

	grid.on('rowdblclick',function(grid, rowIndex, e){
		
		var rec = politicaStore.getAt(rowIndex);
		app.abreClienteTab(rec.get('idPersona'), rec.get('cliente'),'politicaPanel');
		
	});
	var panel=new Ext.Panel({
		autoHeight:true
		,border:false
		,bodyStyle:'padding: 10px'
		,items:[grid]
	});
	
	politicaStore.webflow();
	page.add(panel);
</fwk:page>