<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	var btnBuscar=app.crearBotonBuscar();

	var txtContrato1 = app.creaText('contrato1', '<s:message code="listadoContratos.numContrato" text="**Num. Contrato" />','',{width : 80});
	var txtContrato2 = new Ext.form.TextField({width : 80, style : 'margin-left : 10px'});
	var txtContrato3 = new Ext.form.TextField({width : 80, style : 'margin-left : 10px'});
	var txtContrato4 = new Ext.form.TextField({width : 80, style : 'margin-left : 10px'});

	var panelContrato = app.creaPanelH([app.creaFieldSet( [txtContrato1] ), txtContrato2, txtContrato3, txtContrato4]);

	var txtNombre = app.creaText('nombre', '<s:message code="listadoContratos.nombre" text="**Nombre" />');
	var txtApellido1 = app.creaText('apellido1', '<s:message code="listadoContratos.apellido1" text="**Apellido1" />');
	var txtApellido2 = app.creaText('apellido2', '<s:message code="listadoContratos.apellido2" text="**Apellido2" />');
	var panelNombre= app.creaPanelH([app.creaFieldSet([txtApellido1]), app.creaFieldSet([txtApellido2])]);
	
	var txtNIF = app.creaText('nif', '<s:message code="listadoContratos.nif" text="**NIF/CIF" />');
	var txtCodCliente = app.creaText('cliente', '<s:message code="listadoContratos.codigoCliente" text="**C&oacute;digo cliente" />');
	var txtCodExp = app.creaText('expediente', '<s:message code="listadoContratos.codigoExpediente" text="**C&oacute;digo expediente" />');

	var panelBajo = app.creaPanelH( app.creaFieldSet(txtCodExp), btnBuscar ); 

	var panelFiltros  = app.creaFieldSet([panelContrato, txtNombre, panelNombre, txtNIF, txtCodCliente, txtCodExp]);
	
	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:2}
			,border:false
			,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:[txtContrato1, txtNombre, txtApellido1,txtApellido2 ]
					//,columnWidth:.5
					//,width:500
				},{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					//,columnWidth:.5
					,items:[ txtNIF, txtCodCliente, txtCodExp,{items:btnBuscar,border:false,style:'text-align:right'}]
				}
			]
	});

	var btnIncorporar = new Ext.Button({
		text : '<s:message code="listadoContratos.boton.incorporar" text="**Incorporar" />'
		,handler : function(){
			page.fireEvent(app.event.DONE);
		}
	});

	var contrato = Ext.data.Record.create([
		{name : 'contrato' }
		,{name : 'tipo' }
		,{name : 'saldo' }
		,{name : 'dias' }
		,{name : 'riesgo' }
		,{name : 'asunto' }
		,{name : 'procedimiento' }
		,{name : 'estado' }
	]);

	
	var contratosStore = page.getStore({
		flow : 'expediente/listadoContratosData'
		,reader: new Ext.data.JsonReader({
	    	root : 'contratos'
	    	,totalProperty : 'total'
	    }, contrato)
	});

	var contratosCm = new Ext.grid.ColumnModel([
		    {	header: '<s:message code="listadoContratos.listado.contrato" text="**Num. Contrato"/>', width: 120, dataIndex: 'codigo'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>', width: 120, dataIndex: 'fcreacion'}
			,{	header: '<s:message code="listadoContratos.listado.saldo" text="**Saldo vencido"/>', width: 120, dataIndex: 'oficina'}
			,{	header: '<s:message code="listadoContratos.listado.dias" text="**D&iacute;as vencido"/>', width: 135, dataIndex: 'estado'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos."/>', width: 120, dataIndex: 'volumenRiesgosD'}
		    ,{	header: '<s:message code="listadoContratos.listado.asunto" text="**Asunto"/>', width: 120, dataIndex: 'volumenRiesgosI'}
		    ,{	header: '<s:message code="listadoContratos.listado.procedimiento" text="**Procedimiento"/>', width: 120, dataIndex: 'volumenRiesgosI'}
		    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>', width: 120, dataIndex: 'volumenRiesgosI'}
			]
		); 
		
	var contratosGrid = new Ext.grid.GridPanel({
			title:'<s:message code="listadoContratos.listado.titulo" text="**Contratos"/>'
			,cm : contratosCm
			,store : contratosStore
			,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
			,style : 'margin-bottom:10px'
			,iconCls : 'icon_expedientes'
			//,width : 700
			,height : 100
			//,bbar : [  fwk.ux.getPaging(contratosStore)  ]
			
	});

	
	var mainPanel = new Ext.Panel({
	    items : [
	    		panelFiltros
				,contratosGrid
				,btnIncorporar
	    	]
	    ,bodyStyle:'padding: 5px'
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(mainPanel);
</fwk:page>
