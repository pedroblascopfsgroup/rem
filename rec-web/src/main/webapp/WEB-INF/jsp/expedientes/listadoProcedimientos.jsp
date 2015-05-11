<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>

	var codContrato = '000 000 00235';
	var txtContrato = app.creaLabel('<s:message code="procedimientos.edicion.contrato" text="**Contrato"/>',codContrato);
	var procedimientos = {procedimientos :[	
		{campo1: 'dato1-1', campo2 : 'dato 1-2'}
		,{campo1: 'dato2-1', campo2 : 'dato 2-2'}
	]};

	var procedimientosStore = new Ext.data.JsonStore({
		data : procedimientos
		,root : 'procedimientos'
		,fields : ['campo1', 'campo2']
	});

	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimientos.edicion.listado.codigo" text="**Codigo"/>', dataIndex : 'codigo' }
		,{header : '<s:message code="procedimientos.edicion.listado.tipoprocedimiento" text="**Tipo Procedimiento"/>', dataIndex : 'tipoprocedimiento' }
		,{header : '<s:message code="procedimientos.edicion.listado.tiporeclamacion" text="**Tipo Reclamacion"/>', dataIndex : 'tiporeclamacion' }
		,{header : '<s:message code="procedimientos.edicion.listado.saldovencido" text="**Saldo Vencido"/>', dataIndex : 'saldovencido' }
		,{header : '<s:message code="procedimientos.edicion.listado.saldonovencido" text="**Saldo No Vencido"/>', dataIndex : 'saldonovencido' }
		
	]);


	var dictAsuntos = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsAsuntosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictAsuntos
	});
	
	var comboAsuntos = new Ext.form.ComboBox({
				store:optionsAsuntosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:'font-weight:bolder'
				,fieldLabel : '<s:message code="procedimientos.edicion.asunto" text="**Asuntos" />'
	});

	var btnNuevo = app.crearBotonAgregar({
           	text : '<s:message code="app.nuevo" text="**Nuevo" />'
			,flow : 'expedientes/editaProcedimiento'
			,width:760
			,title : '<s:message code="procedimientos.window.editar" text="**Datos del procedimiento" />' 
			,params : {idPersona:""}
			//,success : refrescarBienes
	});
		
	var btnEditar = new Ext.Button({
	           	text: '<s:message code="app.editar" text="**Editar" />'
	           	,iconCls : 'icon_edit'
				,cls: 'x-btn-text-icon'
	           	,handler:function(){
					var w = app.openWindow({
						flow : 'expedientes/editaProcedimiento'
						,width:760
						,title : '<s:message code="procedimientos.window.editar" text="**Datos del procedimiento" />' 
						,params : {id:''}
					});
					w.on(app.event.DONE, function(){
						w.close();
						//refrescar;
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
	         }
		});

	var btnBorrar = new Ext.Button({
		text : '<s:message code="procedimientos.boton.borrar" text="**Borrar este procedimiento" />'
		,iconCls : 'icon_menos'
		,handler : function(){
		}
	});

	var procedimientosGrid = new Ext.grid.GridPanel({
		title : '<s:message code="procedimientos.edicion.listado.titulo" text="**Procedimientos" />'
		,store : procedimientosStore
		,cm : procedimientosCm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,width : procedimientosCm.getTotalWidth()+25
		//,autoWidth:true
		,autoScroll:true
		,height : 200
		,bbar : [btnNuevo, btnEditar, btnBorrar]
	});

	var panelPrincipal = new Ext.Panel({
		bodyStyle : 'padding:5px'
		,autoHeight : true
		,items : [
			{
				xtype:'fieldset'
				,border:false
				,autoHeight:true
				,items:[txtContrato,comboAsuntos]
			}
			,procedimientosGrid
		]
	});


	page.add(panelPrincipal);

</fwk:page>