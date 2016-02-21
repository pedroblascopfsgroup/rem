<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
	
	var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabClientes.grid.titulo" text="**Clientes"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[]
        ,autoHeight:true
        ,nombreTab : 'clientesTab'
    });
    var clientesExpediente = new Ext.data.JsonStore({
        data : { clientes : [] } 
		,root: "clientes"
		,fields:[
        'id'
			 ,'idPersona'
			 ,'pase'
			 ,'bPase'
			 ,'cliente'
			 ,'vrDirecto'
			 ,'vrIndirecto'
			 ,'vrIrregular'
			 ,'riesgoDirectoDanyado'
			 ,'vrDirectoNoG'
			 ,'contratosActivos'
			 ,'prePolitica'
			 ,'politica'
			 ,'fechaUltRevision'
			 //,{name:'fechaUltRevision',type:'date', dateFormat:'d/m/Y'}
			 ,'scoring'
			 ,'rating'
	        
	    ]
    });
	
	var limit = 20;
	var labelStyle = 'width:150px;font-weight:bolder';
	
	
	var clientesExpedienteCm= new Ext.grid.ColumnModel([
         {header: '<s:message code="expediente.consulta.clientesExpediente.grid.pase" text="**Pase" />', width: 60, dataIndex:'bPase'}
		 //Cliente
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.cliente" text="**Cliente" />', width: 200,dataIndex:'cliente'}
		 //VR Directo
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.vrDirecto" text="**vrDirecto" />',dataIndex:'vrDirecto',renderer: app.format.moneyRenderer,align:'right'}
		 //VR Indirecto
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.vrIndirecto" text="**vrIndirecto" />',dataIndex:'vrIndirecto',renderer: app.format.moneyRenderer,align:'right'}
		 //VR Irregular
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.vrIrregular" text="**vrIrregular" />',dataIndex:'vrIrregular',renderer: app.format.moneyRenderer,align:'right'}
		 //riesgoDirectoDanyado
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.riesgoDirectoDanyado" text="**riesgoDirectoDanyado" />',dataIndex:'riesgoDirectoDanyado',hidden:true,renderer: app.format.moneyRenderer,align:'right'}
		 //VR Directo no G
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.vrDirectoNoG" text="**vrDirectoNoG" />',hidden:true,dataIndex:'vrDirectoNoG',renderer: app.format.moneyRenderer,align:'right'}
		 //Num Clientes activo
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.contratosActivos" text="**contratosActivos" />',dataIndex:'contratosActivos'}
		 //Pre - Politica
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.prePolitica" text="**prePolitica" />',dataIndex:'prePolitica'}
		 //Politica
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.politica" text="**politica" />',dataIndex:'politica'}
		 //Fecha Ultima revision 
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.fechaUltRevision" text="**fechaUltRevision" />',dataIndex:'fechaUltRevision',hidden:false}
		 //Scoring
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.scoring" text="**scoring" />',dataIndex:'scoring',hidden:true}
		 //Rating
		 ,{header: '<s:message code="expediente.consulta.clientesExpediente.grid.rating" text="**rating" />',dataIndex:'rating',hidden:true}
        ]
    );
	
	 var clientesGrid=app.crearGrid(clientesExpediente,clientesExpedienteCm,{
            title:'<s:message code="expedientes.consulta.tabClientes" text="**Clientes del Expediente"/>'
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,height : 415
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_cliente'
			//,plugins: checkColumn
            //,bbar : [ fwk.ux.getPaging(clientesExpediente) ]

        });
	clientesGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=clientesExpediente.getAt(rowIndex);
		if(!rec) return;
		var nombre_cliente=rec.get('cliente');
		
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	})

  panel.add(clientesGrid);

  panel.getValue = function(){};
  panel.setValue = function(){
    var data = entidad.get("data");

    clientesExpediente.loadData(data.clientes);

  };

	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
  }

	return panel;
})
