<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var Comite = Ext.data.Record.create([
	      {name:'id'}
	      ,{name : 'nombre'}
	      ,{name : 'estado'}
	      ,{name : 'atrmin', type: 'float'}
	      ,{name : 'atrmax', type: 'float'}
          ,{name : 'pendientes'}
	      ,{name : 'prioridad'}
          ,{name : 'fechaVencimiento'}
	      ,{name : 'zona'}   
	   ]);

	var comitesStore = page.getStore({
       flow:'comites/listadoComitesData'
	   ,reader: new Ext.data.JsonReader({
	     root : 'comitesJSON'
	   } , Comite)
	  });
	  
	
	
	var gridComitesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="comiteusuario.listado.nombre" text="**Nombre"/>', dataIndex : 'nombre',width:80}
		,{header : '<s:message code="comiteusuario.listado.estado" text="**Estado"/>', dataIndex : 'estado',width:80 }
		,{header : '<s:message code="comiteusuario.listado.atrmin" text="**Atribucion Minima"/>', dataIndex : 'atrmin', renderer: app.format.moneyRenderer,width:80}
		,{header : '<s:message code="comiteusuario.listado.atrmax" text="**Atribucion Maxima"/>', dataIndex : 'atrmax', renderer: app.format.moneyRenderer,width:80}
        ,{header : '<s:message code="comiteusuario.listado.puntospend" text="**Puntos Pendientes"/>', dataIndex : 'pendientes' ,width:80}
        ,{header : '<s:message code="comiteusuario.listado.prioridad" text="**Prioridad"/>', dataIndex : 'prioridad' ,width:80, hidden:true}
        ,{header : '<s:message code="comiteusuario.listado.fvencim" text="**Fecha de Vencimiento"/>', dataIndex : 'fechaVencimiento',width:80 }
		,{header : '<s:message code="comiteusuario.listado.zona" text="**Zona"/>', dataIndex : 'zona' ,width:80}
	]);
	
	var gridComitesGrid = app.crearGrid(comitesStore,gridComitesCm,{
		title:'<s:message code="comiteusuario.listado.titulo" text="**default" />'
		,style:'padding-right:10px'
		,cls:'cursor_pointer'
		,height:400
        <app:test id="comitesGrid" addComa="true" />
	});

	gridComitesGrid.on('rowdblclick', function(grid, rowIndex, e){
	   var rec = grid.getStore().getAt(rowIndex);
	   if(rec.get('estado') == "Iniciado") {
        app.openTab( "<s:message code="comite.expedientes.tabTitle" text="**Expediente del comité " />"+" "+rec.get('nombre') 
                 ,'comite/listadoComiteExpedientes'
                 , {idComite : rec.get('id')}
                 , {id:'ExpComite'+rec.get('id'),iconCls:'icon_comite'});
	   } else {
       if(rec.get('pendientes') == 0) {
          Ext.Msg.alert("<s:message code="comiteusuario.listado.error" text="**Error"/>",
                        "<s:message code="comiteusuario.listado.error.expedientes" text="**No se puede iniciar una sesion porque no hay expedientes pendientes"/>");
       } else {
		      var w = app.openWindow({
				    flow : 'comites/celebracion'
				    ,closable:true
				    ,title:'<s:message code="comite.edicion.titulo" text="**Celebración del comite" />' 
				    ,params :{idComite : rec.get('id')}
		 	      });
		      w.on(app.event.DONE, function(){w.close(); comitesStore.webflow();});
		  }
    }
	});

	var toolBar=new Ext.Toolbar();
	

	var panel = new Ext.Panel({
	    items : [
	    	gridComitesGrid
	    ]
	    ,bodyStyle: 'padding: 10px'
	    ,autoHeight : true
	    ,border: false
	    ,tbar:toolBar
    });
	//añadimos al padre y hacemos el layout
	page.add(panel);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
	Ext.onReady(function(){
		comitesStore.webflow()
	});
</fwk:page>