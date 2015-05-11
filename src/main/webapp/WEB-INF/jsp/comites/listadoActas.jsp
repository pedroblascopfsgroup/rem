<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>   

   var Comite = Ext.data.Record.create([
         {name:'sesionId'}
         ,{name : 'nombre'}
         ,{name : 'estado'}
         ,{name : 'atrmin', type: 'float', sortType:Ext.data.SortTypes.asFloat}
         ,{name : 'atrmax', type: 'float', sortType:Ext.data.SortTypes.asFloat}
         ,{name : 'prioridad'}
         ,{name : 'zona'}
         ,{name : 'fechaini',type:'date', dateFormat:'d/m/Y'} 
         ,{name : 'fechafin',type:'date', dateFormat:'d/m/Y'}    
         ,{name : 'expedientes'}
      ]);

   var comitesStore = page.getStore({
      flow:'comites/listadoActasData'
      ,reader: new Ext.data.JsonReader({
        root : 'comitesJSON'
      } , Comite)
     ,remoteSort : false
     });
     

	var gridComitesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="actas.listado.nombre" text="**Nombre"/>', dataIndex : 'nombre', sortable:true  }
		,{header : '<s:message code="actas.listado.estado" text="**Estado"/>', dataIndex : 'estado', sortable:true }
		,{header : '<s:message code="actas.listado.atrmin" text="**Atribucion Minima"/>', dataIndex : 'atrmin', renderer: app.format.moneyRenderer, sortable:true}
		,{header : '<s:message code="actas.listado.fechaini" text="**Fecha inicio"/>', dataIndex : 'fechaini', sortable:true ,renderer:app.format.dateRenderer}
		,{header : '<s:message code="actas.listado.fechafin" text="**Fecha fin"/>', dataIndex : 'fechafin' , sortable:true,renderer:app.format.dateRenderer}
		,{header : '<s:message code="actas.listado.atrmax" text="**Atribucion Maxima"/>', dataIndex : 'atrmax', renderer: app.format.moneyRenderer, sortable:true }
		,{header : '<s:message code="actas.listado.prioridad" text="**Prioridad"/>', dataIndex : 'prioridad',hidden:true , sortable:true}
		,{header : '<s:message code="actas.listado.zona" text="**Zona"/>', dataIndex : 'zona', sortable:true}
		,{header : '<s:message code="actas.listado.puntosTratados" text="**Puntos Tratados"/>', dataIndex : 'expedientes', sortable:true }
	]);
	
	//var botonesTabla = fwk.ux.getPaging(comitesStore);
	//botonesTabla.hide();

	var gridComitesGrid = app.crearGrid(comitesStore,gridComitesCm,{
		title:'<s:message code="actas.listado.grid" text="**default" />'
		,style:'padding-right:10px'
		,cls:'cursor_pointer'
		,height:400
//		,bbar : [ botonesTabla  ]	
        <app:test id="actasGrid" addComa="true" />
	});
	

	gridComitesGrid.on('rowdblclick', function(grid, rowIndex, e){
	   var rec = grid.getStore().getAt(rowIndex);
      app.openTab( "<s:message code="actas.consulta.sesion" text="**Consulta sesion del comite" />" 
                   ,'comites/actaComite'
                   ,{idSesion : rec.get('sesionId')}
				   ,{id:'acta'+rec.get('sesionId') , iconCls:'icon_comite'});
	});


	var panel = new Ext.Panel({
	    items : [
	    	gridComitesGrid
	    ]
	    ,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight : true
	    ,border: false  
		,tbar:new Ext.Toolbar()
    });
    panel.on(app.event.DONE, function(){comitesStore.webflow();});
	//añadimos al padre y hacemos el layout
	page.add(panel);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
	Ext.onReady(function(){
	   comitesStore.webflow();
    });
    
</fwk:page>