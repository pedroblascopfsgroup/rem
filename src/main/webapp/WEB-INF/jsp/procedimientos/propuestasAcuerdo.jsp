<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var tramite=app.creaLabel('<s:message code="propuestasacuerdo.tramite" text="**Tramite"/>','TRÁMITE DE SUBASTA');
	var tarea=app.creaLabel('<s:message code="propuestasacuerdo.tarea" text="**Tarea"/>','Solicitud de subasta');
	var asunto=app.creaLabel('<s:message code="propuestasacuerdo.asunto" text="**Asunto"/>','23143124');
	var contrato=app.creaLabel('<s:message code="propuestasacuerdo.contrato" text="**Contrato"/>','34562345698745');
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
        ,fieldLabel: '<s:message code="propuestasacuerdo.clientes" text="**Clientes" />'
        ,displayField:'nombre'
        ,valueField: 'codigo'
        ,labelStyle:'font-weight:bolder'
        ,height : 80
        ,width : 200
    });
    var acuerdos = {acuerdos:[	
    	{solicitante: 'Pepito', tipopago : 'Total',tipoacuerdo:'Dación en pago',periodicidad:'Único',importepago:'100.000',periodopago:'-',estado:'Propuesto'}
    	,{solicitante: 'Juanito', tipopago : 'Parcial',tipoacuerdo:'Efectivo',periodicidad:'Periódico',importepago:'10.000',periodopago:'60 dias',estado:'Aceptado'}
    	,{solicitante: 'Pedrito', tipopago : 'Total',tipoacuerdo:'Refinanciación',periodicidad:'Periódico',importepago:'1.000',periodopago:'30 dias',estado:'Aceptado'}
    	]};
    var acuerdosStore = new Ext.data.JsonStore({
    	data : acuerdos
    	,root : 'acuerdos'
    	,fields : ['solicitante', 'tipopago','tipoacuerdo','periodicidad','importepago','periodopago','estado']
    });
    

    var acuerdosCm = new Ext.grid.ColumnModel([
    	{header : '<s:message code="propuestasacuerdo.grid.solicitante" text="**Solicitante"/>', dataIndex : 'solicitante' }
    	,{header : '<s:message code="propuestasacuerdo.grid.tipopago" text="**Tipo Pago"/>', dataIndex : 'tipopago' }
    	,{header : '<s:message code="propuestasacuerdo.grid.tipoacuerdo" text="**Tipo Acuerdo"/>', dataIndex : 'tipoacuerdo' }
    	,{header : '<s:message code="propuestasacuerdo.grid.periodicidad" text="**Periodicidad"/>', dataIndex : 'periodicidad' }
    	,{header : '<s:message code="propuestasacuerdo.grid.importepago" text="**Importe Pago"/>', dataIndex : 'importepago' }
    	,{header : '<s:message code="propuestasacuerdo.grid.periodopago" text="**Periodo Pago"/>', dataIndex : 'periodopago' }
    	,{header : '<s:message code="propuestasacuerdo.grid.estado" text="**Estado"/>', dataIndex : 'estado' }
    ]);
    var btnNuevoAcuerdo = app.crearBotonAgregar({
    	text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'fase2/acuerdos'
		,width:900
		,title : '<s:message code="propuestasacuerdo.alta" text="**Alta Acuerdo" />' 
		//,params:
		//,success:
    });
    
    var btnEditarAcuerdo= app.crearBotonEditar({
        text:'<s:message code="app.editar" text="**Editar" />'
		,flow : 'fase2/acuerdos'
		,width:900
		,title : '<s:message code="propuestasacuerdo.edicion" text="**Editar Acuerdo" />' 
		//,params : 
		//,success:
	});
    var acuerdosGrid = app.crearGrid(acuerdosStore,acuerdosCm,{
    	title:'<s:message code="propuestasacuerdo.grid.titulo" text="**acuerdos ya existentes en el asunto" />'
    	//,width : 700
    	,height : 250
    	,style:'padding-right:10px'
    	,bbar:[btnNuevoAcuerdo,btnEditarAcuerdo]
    });
    var panel = new Ext.form.FormPanel({
    	autoHeight : true
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
			,acuerdosGrid
		]
		,tbar:new Ext.Toolbar()
    });
    page.add(panel);
	
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
</fwk:page>