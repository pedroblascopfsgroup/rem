<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){

	var cerrarDecision = function(yesNo) {
		if(yesNo=='yes') {
			page.webflow({
	     		flow: 'politica/cerrarDecisionPolitica'
				,params: {idExpediente:${expediente.id}}
	     		,success: function(){
	           		Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="cerrarDecisionPolitica.cerrado" text="**Se ha cerrado la decisión correctamente." />');
					recargarTab();
	           	}
		    });
		}
	};

	var cerrarHandler = function() {
		if(${expediente.comite.comiteMixto || expediente.comite.comiteSeguimiento}) {
			Ext.Msg.confirm(fwk.constant.confirmar,
			                '<s:message code="cerrarDecisionPolitica.quiereCerrar" text="**¿Esta seguro de que desea cerrar la decisión de política?" />',
			                cerrarDecision);
		} else {
			cerrarDecision('no');
		}
	};

	<c:if test="${expediente.estaCongelado}">  	
		var btnCerrar = new Ext.Button({
	           	text: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.btnCerrar" text="**Cerrar decisión de política" />'
	           	//,style:'margin-left:375px;'
	           	,iconCls : 'icon_comite_cerrar'  
	           	,border:false
				,handler:cerrarHandler
		});
	</c:if>

/*
	var marcadoObligatorio = <json:object name="marcadoObigatorio">
					<json:array name="personas" items="${marcadoObligatorio}" var="dto">	
						<json:object>
							<json:property name="idPersona" value="${dto.persona.id}" />
							<json:property name="cliente" value="${dto.persona.apellidoNombre}" />
							<json:property name="tipoPolitica" value="${dto.politicaUltima.tipoPolitica.descripcion}" />
							<json:property name="numObjetivos" value="${dto.politicaUltima.cantidadObjetivos}" />
							<json:property name="estado" value="${dto.politicaUltima.estadoPolitica.descripcion}" />
						</json:object>
					</json:array>
	</json:object>;

	var marcadoOpcional = <json:object name="marcadoOpcional">
					<json:array name="personas" items="${marcadoOpcional}" var="persona">	
						<json:object>
							<json:property name="idPersona" value="${dto.persona.id}" />
							<json:property name="cliente" value="${dto.persona.apellidoNombre}" />
							<json:property name="tipoPolitica" value="${dto.politicaUltima.tipoPolitica.descripcion}" />
							<json:property name="numObjetivos" value="${dto.politicaUltima.cantidadObjetivos}" />
							<json:property name="estado" value="${dto.politicaUltima.estadoPolitica.descripcion}" />
						</json:object>
					</json:array>
	</json:object>;

    var marcadoObligatorioStore = new Ext.data.JsonStore({
        data : marcadoObligatorio
		,root: "personas"
		,fields:[
	         'idPersona'
			 ,'cliente'
			 ,'tipoPolitica'
			 ,'numObjetivos'
			 ,'estado'
	    ]
    });

    var marcadoOpcionalStore = new Ext.data.JsonStore({
        data : marcadoOpcional
		,root: "personas"
		,fields:[
	         'idPersona'
			 ,'cliente'
			 ,'tipoPolitica'
			 ,'numObjetivos'
			 ,'estado'
	    ]
    });
*/
    
    
    var Personas = Ext.data.Record.create([    
		{name : "idPersona"}
		,{name : "cliente"}
		,{name : "tipoPolitica"}
		,{name : "numObjetivos"}
		,{name : "estado"}
    ]);
    
    
	var marcadoObligatorioStore = page.getStore({                                                                                                                                 
		event:'listado'
		,flow : 'expedientes/listadoPersonasMarcadoObligatorio'                                                                                                                          
		,reader : new Ext.data.JsonReader(
			{root:'personas'}
			, Personas
		)                                                                                                  
	});     


	var marcadoOpcionalStore = page.getStore({                                                                                                                                 
		event:'listado'
		,flow : 'expedientes/listadoPersonasMarcadoOpcional'                                                                                                                          
		,reader : new Ext.data.JsonReader(
			{root:'personas'}
			, Personas
		)                                                                                                  
	}); 

	
	Ext.onReady(function(){
		marcadoObligatorioStore.webflow({idExpediente:'${expediente.id}'});
		marcadoOpcionalStore.webflow({idExpediente:'${expediente.id}'});
	});
	
	
	var limit = 20;
	var labelStyle = 'width:150px;font-weight:bolder';
	
	var marcadoObigatorioCm = new Ext.grid.ColumnModel([
		 //Cliente
		 {header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nombre" text="**Nombre" />',dataIndex:'cliente'}
		 //Tipo de Política
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.tipoPolitica" text="**Tipo de Política" />',dataIndex:'tipoPolitica'}
		 //N° de Objetivos
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nroObjetivos" text="**N° de Objetivos" />',dataIndex:'numObjetivos'}
		 //Estado
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.estado" text="**Estado" />',dataIndex:'estado'}
        ]
    );
	
	var marcadoOpcionalCm = new Ext.grid.ColumnModel([
		 //Cliente
		 {header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nombre" text="**Nombre" />',dataIndex:'cliente'}
		 //Tipo de Política
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.tipoPolitica" text="**Tipo de Política" />',dataIndex:'tipoPolitica'}
		 //N° de Objetivos
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nroObjetivos" text="**N° de Objetivos" />',dataIndex:'numObjetivos'}
		 //Estado
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.estado" text="**Estado" />',dataIndex:'estado'}
        ]
    );

	 var obligatorioGrid = app.crearGrid(marcadoObligatorioStore,marcadoObigatorioCm,{
            title:'<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.titulo" text="**Listado de Clientes con Marcado Obligatorio"/>'
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_cliente'
	        ,height : 150
        });

	obligatorioGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=marcadoObligatorioStore.getAt(rowIndex);
		if(!rec) return;
		var nombre_cliente=rec.get('cliente');
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	})

	 var opcionalGrid=app.crearGrid(marcadoOpcionalStore,marcadoOpcionalCm,{
            title:'<s:message code="expediente.consulta.marcadoPolitica.gridOpcional.titulo" text="**Listado de Clientes con Marcado Opcional"/>'
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_cliente'
	        ,height : 150
        });


	opcionalGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=marcadoOpcionalStore.getAt(rowIndex);
		if(!rec) return;
		var nombre_cliente=rec.get('cliente');
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	})


	var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabMarcadoPoliticas.titulo" text="**Marcado de Políticas"/>'
        ,bodyStyle:'padding:10px'
		,layout:'table'
	    ,layoutConfig: {
	        columns: 1
	    }		
				,items : [
				
				{items:[obligatorioGrid],border:false,style:'padding:5px;padding-top:1px;padding-bottom:1px;margin-left:5px'}
				,{items:[opcionalGrid],border:false,style:'padding:5px;padding-top:1px;padding-bottom:1px;margin-left:5px'}
				<c:if test="${expediente.estaCongelado}">  	
					,{
						
						buttons:[btnCerrar]
						,buttonAlign:'right'
						,style:'padding-right:5px;'
						,border:false
					}
				</c:if>
				]
        ,autoHeight:true
        ,nombreTab : 'tabMarcadoPolitica'
    });
	return panel;
	
})()
