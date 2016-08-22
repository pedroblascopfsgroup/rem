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
	   
//DATOS HARCODE
var comites = {comites :[	
	{id: '1', nombre : 'Comite1'}
	,{id: '2', nombre : 'Comite2'}
]};

var comitesStore = new Ext.data.JsonStore({
	data : comites
	,root : 'comites'
	,fields : [{name:'id'}
	      ,{name : 'nombre'}
	      ,{name : 'estado'}
	      ,{name : 'atrmin', type: 'float'}
	      ,{name : 'atrmax', type: 'float'}
          ,{name : 'pendientes'}
	      ,{name : 'prioridad'}
          ,{name : 'fechaVencimiento'}
	      ,{name : 'zona'}   ]
});
//////////////////////////////////////////////

	//var comitesStore = page.getStore({
	//   eventName : 'listadoJSON'
	//   ,flow:'comites/listadoComitesUsuario'
	//   ,reader: new Ext.data.JsonReader({
	//     root : 'comitesJSON'
	//   } , Comite)
	//  });
	  
	//comitesStore.webflow();
	
	var gridComitesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="comiteusuario.listado.nombre" text="**Nombre"/>', dataIndex : 'nombre',width:80}
		,{header : '<s:message code="comiteusuario.listado.estado" text="**Estado"/>', dataIndex : 'estado',width:80 }
		,{header : '<s:message code="comiteusuario.listado.atrmin" text="**Atribucion Minima"/>', dataIndex : 'atrmin', renderer: app.format.moneyRenderer,width:80}
		,{header : '<s:message code="comiteusuario.listado.atrmax" text="**Atribucion Maxima"/>', dataIndex : 'atrmax', renderer: app.format.moneyRenderer,width:80}
        ,{header : '<s:message code="comiteusuario.listado.puntospend" text="**Puntos Pendientes"/>', dataIndex : 'pendientes' ,width:80}
		,{header : '<s:message code="comiteusuario.listado.prioridad" text="**Prioridad"/>', dataIndex : 'prioridad' ,width:80}
        ,{header : '<s:message code="comiteusuario.listado.fvencim" text="**Fecha de Vencimiento"/>', dataIndex : 'fechaVencimiento',width:80 }
		,{header : '<s:message code="comiteusuario.listado.zona" text="**Zona"/>', dataIndex : 'zona' ,width:80}
	]);
	var submitForm=function(){
		// TODO: hacer el submit, por ahora solo lanzamos el evento
		//page.submit({
		//	eventName : 'update'
		//	,formPanel : panelEdicion
		//	,success : function(){ page.fireEvent(app.event.DONE) }
		//});
		page.fireEvent(app.event.DONE)
	};
	var gridComitesGrid = app.crearGrid(comitesStore,gridComitesCm,{
		title:'<s:message code="comiteusuario.listado.titulo" text="**default" />'
		,style:'padding-right:10px'
		,cls:'cursor_pointer'
        <app:test id="comitesGrid" addComa="true" />
	});
	gridComitesGrid.on('rowdblclick',function(){
		submitForm();
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			submitForm();
		}
	});
	
	var panelEdicion=new Ext.form.FormPanel({
		//height:100
		autoHeight:true
		,xtype:'fieldset'
		,bodyStyle:'padding:20px'
		,items:gridComitesGrid
		,bbar:[btnGuardar,btnCancelar]
	});
	page.add(panelEdicion);
</fwk:page>