<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
	
	var clientes = <json:object name="clientes">
					<json:array name="clientes" items="${expediente.personas}" var="expedientePersona">	
						<json:object>
							<json:property name="id" value="${expedientePersona.id}" />
							<json:property name="idPersona" value="${expedientePersona.persona.id}" />
							<json:property name='pase' value="${expedientePersona.pase}" />
							<json:property name='cliente' value="${expedientePersona.persona.apellidoNombre}" />
							<json:property name='vrDirecto' value="${expedientePersona.persona.riesgoTotal}" />
							<json:property name='vrIndirecto' value="${expedientePersona.persona.riesgoIndirecto}" />
							<json:property name='vrIrregular' value="${expedientePersona.persona.dispuestoVencido}" />
							<json:property name='riesgoDirectoDanyado' value="${expedientePersona.persona.riesgoDirectoDanyado}" />
							<json:property name='vrDirectoNoG' value="${expedientePersona.persona.grupo.grupoCliente.riesgoDirecto}" />
							<json:property name='contratosActivos' value="${expedientePersona.persona.numContratos}" />
							<json:property name='prePolitica' value="${expedientePersona.persona.prepolitica.descripcion}" />
							<json:property name='politica' value="${expedientePersona.persona.politicaVigente.tipoPolitica.descripcion}" />
							<json:property name='fechaUltRevision'>
								<fwk:date value="${expedientePersona.persona.politicaVigente.auditoria.fechaCrear}" />
							</json:property>
							<json:property name='scoring' value="${expedientePersona.persona.puntuacionTotalActiva.puntuacion}" />
							<json:property name='rating' value="${expedientePersona.persona.puntuacionTotalActiva.intervalo}" />
							<c:if test="${expedientePersona.pase==1}">
	                		<json:property name="bPase" value="Si" />
                			</c:if>
                			<c:if test="${expedientePersona.pase==0}">
	                		<json:property name="bPase" value="" />	
	                		</c:if>					
							</json:object>
					</json:array>
	</json:object>;

    var clientesExpediente = new Ext.data.JsonStore({
        data : clientes
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
		 //Nº Clientes activo
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
	var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabClientes.grid.titulo" text="**Clientes"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[clientesGrid]
        ,autoHeight:true
        ,nombreTab : 'clientesTab'
    });
	return panel;
})()
