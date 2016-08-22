<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var tramite=app.creaLabel('<s:message code="interrupcionrecurso.tramite" text="**Tramite"/>','TRÁMITE DE SUBASTA');
	var tarea=app.creaLabel('<s:message code="interrupcionrecurso.tarea" text="**Tarea"/>','Solicitud de subasta');
	var asunto=app.creaLabel('<s:message code="interrupcionrecurso.asunto" text="**Asunto"/>','23143124');
	var contrato=app.creaLabel('<s:message code="interrupcionrecurso.contrato" text="**Contrato"/>','34562345698745');
	var clientes={clientes:[
		{codigo: '1',nombre:'Juan Lopez Cuerda'}
		,{codigo: '2',nombre:'Salvador Valero Marin'}
		,{codigo: '3',nombre:'Martin Martin Martin'}
	]};
	var clientesStore = new Ext.data.JsonStore({
        fields: ['codigo', 'nombre']
        ,root: 'clientes'
        ,data : clientes
    });
	var clientesList = new Ext.ux.Multiselect({
        store: clientesStore
        ,fieldLabel: '<s:message code="interrupcionrecurso.clientes" text="**Clientes" />'
        ,displayField:'nombre'
        ,valueField: 'codigo'
        ,labelStyle:'font-weight:bolder'
        ,height : 80
        ,width : 200
    });
    var recursos = {recursos:[	
    	{actor: 'Entidad XXX', tipo : 'Casación',causa:'Importe Incorrecto',fecha:'31/08/2008',resultado:'Favorable'}
    	,{actor: 'Parte Contraria', tipo : 'Casación',causa:'Documento Incorrecto',fecha:'31/08/2008',resultado:'Favorable'}
    	,{actor: 'Entidad YYY', tipo : 'Casación',causa:'Firma Incorrecta',fecha:'31/08/2008',resultado:'Desfavorable'}
    	]};
    var recursosStore = new Ext.data.JsonStore({
    	data : recursos
    	,root : 'recursos'
    	,fields : ['actor', 'tipo','causa','fecha','resultado']
    });
    
			
    
    var recursosCm = new Ext.grid.ColumnModel([
    	{header : '<s:message code="interrupcionrecurso.grid.actor" text="**Actor"/>', dataIndex : 'actor' }
    	,{header : '<s:message code="interrupcionrecurso.grid.tipo" text="**Tipo"/>', dataIndex : 'tipo' }
    	,{header : '<s:message code="interrupcionrecurso.grid.causa" text="**Causa"/>', dataIndex : 'causa' }
    	,{header : '<s:message code="interrupcionrecurso.grid.fecha" text="**Fecha Recurso"/>', dataIndex : 'fecha' }
    	,{header : '<s:message code="interrupcionrecurso.grid.resultado" text="**Resultado"/>', dataIndex : 'resultado' }
    ]);
    var btnNuevoRecurso = app.crearBotonAgregar({
    	text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'fase2/recursos'
		,width:820
		,title : '<s:message code="" text="**Alta Recurso" />' 
		//,params:
		//,success:
    });
    
    var btnEditarRecurso= app.crearBotonEditar({
        text:'<s:message code="app.editar" text="**Editar" />'
		,flow : 'fase2/recursos'
		,width:820
		,title : '<s:message code="" text="**Editar Recurso" />'
	});
    var recursosGrid = app.crearGrid(recursosStore,recursosCm,{
    	title:'<s:message code="interrupcionrecurso.grid.titulo" text="**Recursos ya existentes en el asunto" />'
    	//,width : 700
    	,style:'padding-right:10px'
    	,height : 200
		,cls:'cursor_pointer'
    	,bbar:[btnNuevoRecurso,btnEditarRecurso]
    });
    var panel = new Ext.form.FormPanel({
    	autoHeight : true
		//,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false,width:350 }
				,items : [
					{ items : [ tramite,tarea,asunto,contrato ], style : 'margin-right:10px' }
					,{
						items : clientesList 
					}
				]
			}
			,recursosGrid
		]
		,tbar:new Ext.Toolbar()
    });
    page.add(panel);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
</fwk:page>