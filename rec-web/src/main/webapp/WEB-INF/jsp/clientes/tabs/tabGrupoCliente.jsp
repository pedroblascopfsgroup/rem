<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function() {

	var panel = new Ext.Panel({
		title: '<s:message code="grupo.titulo" text="**Grupo" />'
		,height: 440
		,autoWidth: true
		,bodyStyle:'padding:5px;margin:5px'
		,nombreTab : 'grupoClientePanel'
	});

	panel.on('render', function(){
	
	
		// Límite paginado del grid
		var limit = 20;
	
		var labelStyle='font-weight:bold;width:160px';
	
		<c:if test="${persona.grupo==null}">
			var mensajeLabel = new Ext.form.Label({
		    	text:'<s:message code="grupo.personaSinGrupo" text="**Esta persona no pertenece a ningún grupo" />'
				,style:'font-weight:bold;font-size:13px;color:red;'
			});
	
			var nombre = '';
			var tipo = '';
			var numComp = '';
			var volRiesgo = '';
			var volRiesgoV = '';
			var riesgoIndirecto = '';
			var VolRiesgoDDG = '';
		</c:if>
		<c:if test="${persona.grupo!=null}">
			var nombre = '${persona.grupo.grupoCliente.nombre}';
			var tipo = '${persona.grupo.grupoCliente.tipoGrupoCliente.descripcion}';
			var numComp = '${personasMismoGrupoCount}';
			var volRiesgo = app.format.moneyRenderer(${persona.grupo.grupoCliente.riesgoDirecto});
			var volRiesgoV = app.format.moneyRenderer(${persona.grupo.grupoCliente.riesgoDirectoVencido});
			var riesgoIndirecto = app.format.moneyRenderer(${persona.grupo.grupoCliente.riesgoIndirecto});
			var VolRiesgoDDG=app.format.moneyRenderer(${persona.grupo.grupoCliente.riesgoDirectoDanyado});
		</c:if>
	
		var txtNombre 		= app.creaLabel('<s:message code="grupo.nombre" text="**Nombre"/>'
	                                        ,nombre,{labelStyle:labelStyle});
		var txtTipo 		= app.creaLabel('<s:message code="grupo.tipo" text="**Tipo"/>'
	                                        ,tipo,{labelStyle:labelStyle});
		var txtNumComp 		= app.creaLabel('<s:message code="grupo.numComp" text="**N° componentes"/>'
	                                        ,0,{labelStyle:labelStyle});
		var txtVolRiesgo	= app.creaLabel('<s:message code="grupo.volRiesgoGrupo" text="**V. R. Grupo"/>'
	                                        ,volRiesgo,{labelStyle:labelStyle});
	    var txtVolRiesgoInd=app.creaLabel('<s:message code="grupo.volRiesgoIndirecto" text="**V. R. Indirecto"/>'
	                                        ,riesgoIndirecto,{labelStyle:labelStyle});                                    
		var txtVolRiesgoV	= app.creaLabel('<s:message code="grupo.volRiesgoVencidoGrupo" text="**V. R. Vencido Grupo"/>'
	                                        ,volRiesgoV,{labelStyle:labelStyle});
	
	    var txtVolRiesgoDDG	= app.creaLabel('<s:message code="grupo.volRiesgoDDG" text="**V. R. Directo Dañado del Grupo"/>'
	                                        ,VolRiesgoDDG,{labelStyle:labelStyle});
		
		
		
		
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
						  {items:[txtVolRiesgo,txtVolRiesgoInd, txtVolRiesgoV,txtVolRiesgoDDG]}
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
	
		//Seteamos el nº de componentes dependiendo de la consulta que nos devuelva
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
	        //,width: 775    
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
	        ,height: 315
	        ,bbar: [ fwk.ux.getPaging(store) ]
		});
	
		grid.on('rowdblclick', function(grid, rowIndex, e) {
	    	var rec = grid.getStore().getAt(rowIndex);
	    	var nombre_cliente=rec.get('nombre');
	    	app.abreCliente(rec.get('id'), nombre_cliente);
	    });
	
	
		<c:if test="${persona.grupo!=null}">
			store.webflow({idGrupo:${persona.grupo.grupoCliente.id}});
		</c:if>
	
	
		<c:if test="${persona.grupo==null}">
			panel.add({items:[mensajeLabel],border:false});		
		</c:if>
		panel.add({items:[panelComponentes],border:false});
		panel.add({items:[grid],border:false});

	});

	return panel;
})()