<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page, entidad) {

	var panel = new Ext.Panel({
		title: '<s:message code="grupo.titulo" text="**Grupo" />'
		,height: 440
		,autoWidth: true
		,bodyStyle:'padding:5px;margin:5px'
		,nombreTab : 'grupoClientePanel'
	});

	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-cliente-'+id});
	}
	
	// Límite paginado del grid
	var limit = 20;
	var labelStyle='font-weight:bold;width:160px';
	var mensajeLabel = new Ext.form.Label({
	   	text:'<s:message code="grupo.personaSinGrupo" text="**Esta persona no pertenece a ningún grupo" />'
		,style:'font-weight:bold;font-size:13px;color:red;'
	});
	
	var txtNombre 		= label('grupoNombre','<s:message code="grupo.nombre" text="**Nombre"/>');
	var txtTipo 		= label('grupoTipo','<s:message code="grupo.tipo" text="**Tipo"/>');
	var txtNumComp 		= label('grupoComp','<s:message code="grupo.numComp" text="**N componentes"/>');
	var txtVolRiesgo	= label('grupoRiesgo','<s:message code="grupo.volRiesgoGrupo" text="**V. R. Grupo"/>');
	var txtVolRiesgoInd	= label('riesgoIndirecto','<s:message code="grupo.volRiesgoIndirecto" text="**V. R. Indirecto"/>');
	var txtVolRiesgoV	= label('grupoRiesgoV','<s:message code="grupo.volRiesgoVencidoGrupo" text="**V. R. Vencido Grupo"/>');
	var txtVolRiesgoDDG	= label('grupoRiesgoDDG', '<s:message code="grupo.volRiesgoDDG" text="**V. R. Directo Dañado del Grupo"/>');
	
	var panelComponentes = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:2
		}
		,title:'<s:message code="grupo.titulo" text="**Grupo" />'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [{items:[txtNombre,txtTipo,txtNumComp]},
				  {items:[txtVolRiesgo,txtVolRiesgoInd,txtVolRiesgoV,txtVolRiesgoDDG]}
				 ]
	});

    var record = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
		,{name:'nif'}
		,{name:'tipoPersona'}
		,{name: 'tipoRelacionGrupo'}
		,{name:'volRiesgoCliente'}
		,{name:'volRiesgoVencidoCliente'}
		,{name:'segmento'}
		,{name:'situacion'}
	]);
	
	var store = page.getStore({
		eventName : 'listado'
		,limit:limit
		,storeId : 'grupoClienteStore'
		,flow:'clientes/tabGrupoClienteData'
		,reader: new Ext.data.JsonReader({
			root: 'data'
			,totalProperty : 'total'
		}, record)
	});
	
	var colM = new Ext.grid.ColumnModel([
			{dataIndex: 'id', hidden:true},
			{header: '<s:message code="grupo.grid.nombre" text="**Nombre" />', width:180, sortable: true, dataIndex: 'nombre'},
			{header: '<s:message code="grupo.grid.nif" text="**NIF" />', width: 70, sortable: true, dataIndex: 'nif'},
			{header: '<s:message code="grupo.grid.tipoPersona" text="**Tipo persona" />', width:80, sortable: true, dataIndex: 'tipoPersona'},
			{header: '<s:message code="grupo.grid.tipoRelacionGrupo" text="**Tipo relacion" />', width:80, sortable: true, dataIndex: 'tipoRelacionGrupo'},
			{header: '<s:message code="grupo.grid.volRiesgoCliente" text="**Vol. Riesgo Cliente" />', width: 110, sortable: true, dataIndex: 'volRiesgoCliente', renderer: app.format.moneyRenderer, align: 'right'},
			{header: '<s:message code="grupo.grid.volRiesgoVencidoCliente" text="**Vol. Riesgo Vencido Cliente" />', width:140, sortable: true, dataIndex: 'volRiesgoVencidoCliente', renderer: app.format.moneyRenderer, align: 'right'},
			{header: '<s:message code="grupo.grid.segmento" text="**Segmento" />', width: 80, sortable: true, dataIndex: 'segmento'},
			{header: '<s:message code="grupo.grid.situacion" text="**Situación" />', width: 80, sortable: true, dataIndex: 'situacion'}
	]);

	//Seteamos el numero de componentes dependiendo de la consulta que nos devuelva
	store.on('load', function(){
		txtNumComp.setValue(store.getTotalCount());
	});

	var grid = new Ext.grid.GridPanel({
		title:'<s:message code="grupo.grid.titulo" text="**Personas pertenecientes al Grupo"/>'
		,border: true
		,cls:'cursor_pointer'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,store: store
		,cm: colM
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,autoWidth: true
		,height: 300
		,viewConfig : {  forceFit : true}
		,doLayout: function() {
			if(this.isVisible()){
				var margin = 20;
				var parentSize = app.contenido.getSize(true);
				var width = (parentSize.width) - (2*margin);
				this.setWidth(width);
				Ext.grid.GridPanel.prototype.doLayout.call(this);
			}

		}
		,bbar: [ fwk.ux.getPaging(store) ]
	});

	grid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var nombre_cliente=rec.get('nombre');
		app.abreCliente(rec.get('id'), nombre_cliente);
	});


	panel.add({items:[mensajeLabel],border:false});		
	panel.add({items:[panelComponentes],border:false});
	panel.add({items:[grid],border:false});

	entidad.cacheStore(grid.getStore());

	panel.getValue = function(){}
	
	panel.setValue = function(){
		var data=entidad.get("data");
		if (data.grupo.id!=''){
			entidad.cacheOrLoad(data,grid.getStore(), {idGrupo:data.grupo.id});
		} else {
			entidad.cacheOrLoad(data,grid.getStore(), {idGrupo:-1});
		}
		
		var esVisible = [
			[mensajeLabel, data.grupo.isNull]
			,[txtTipo,         !data.grupo.isNull]
			,[txtNombre,       !data.grupo.isNull]
			,[txtNumComp,      !data.grupo.isNull]
			,[txtVolRiesgo,    !data.grupo.isNull]
			,[txtVolRiesgoInd, !data.grupo.isNull]
			,[txtVolRiesgoV,   !data.grupo.isNull]
			,[txtVolRiesgoDDG, !data.grupo.isNull]
		];

		 entidad.setLabel("grupoNombre", data.grupo.nombre);
		 entidad.setLabel("grupoTipo", data.grupo.tipo);
		 entidad.setLabel("grupoComp", data.grupo.numComp);
		 entidad.setLabel("grupoRiesgo", app.format.moneyRenderer(data.grupo.volRiesgo));
		 entidad.setLabel("riesgoIndirecto", app.format.moneyRenderer(data.grupo.riesgoIndirecto));
		 entidad.setLabel("grupoRiesgoV", app.format.moneyRenderer(data.grupo.volRiesgoV));
		 entidad.setLabel("grupoRiesgoDDG", app.format.moneyRenderer(data.grupo.volRiesgoDDG));

		 entidad.setVisible(esVisible);
	}

	return panel;
})
