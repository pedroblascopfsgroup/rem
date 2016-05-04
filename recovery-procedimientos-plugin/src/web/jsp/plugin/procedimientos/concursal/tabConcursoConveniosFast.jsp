<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


(function(page,entidad){

	<pfs:defineRecordType name="Convenio">
		<pfs:defineTextColumn name="idConvenio"/>
		<pfs:defineTextColumn name="numeroAuto"/>
		<pfs:defineTextColumn name="tipo"/>
		<pfs:defineTextColumn name="numeroAutoEnLinea"/>
		<pfs:defineTextColumn name="idProcedimiento"/>
		<pfs:defineTextColumn name="fechaPropuesta"/>
		<pfs:defineTextColumn name="numProponentes"/>
		<pfs:defineTextColumn name="totalMasa"/>
		<pfs:defineTextColumn name="porcentaje"/>
		<pfs:defineTextColumn name="estado"/>
		<pfs:defineTextColumn name="postura"/>
		<pfs:defineTextColumn name="inicio"/>
		<pfs:defineTextColumn name="descripProponentes"/>
		<pfs:defineTextColumn name="adhesion"/>
	</pfs:defineRecordType>
	
	var conveniosDS = page.getStore({
        flow: 'plugin/procedimientos/concursal/listadoConveniosData'
        ,storeId : 'conveniosDS'
        ,reader : new Ext.data.JsonReader(
            {root:'convenios'}
            , Convenio
        )
	}); 
    
	entidad.cacheStore(conveniosDS);
	
	<pfs:defineColumnModel name="convenioCM">
		<pfs:defineHeader dataIndex="numeroAuto" caption="**Auto" captionKey="asunto.concurso.tabConvenio.numeroAuto" sortable="false" firstHeader="true" />
		<pfs:defineHeader dataIndex="fechaPropuesta" caption="**Fecha propuesta" captionKey="asunto.concurso.tabConvenio.fechaPropuesta" sortable="false" />
		<pfs:defineHeader dataIndex="tipo" caption="**Tipo" captionKey="asunto.concurso.tabConvenio.tipo" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="numProponentes" caption="**Nº proponentes" captionKey="asunto.concurso.tabConvenio.numProponentes" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="totalMasa" caption="**Total masa" captionKey="asunto.concurso.tabConvenio.totalMasa" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="porcentaje" caption="**Porcentaje" captionKey="asunto.concurso.tabConvenio.porcentaje" sortable="false" align="right" width="100"/>
		<pfs:defineHeader dataIndex="inicio" caption="**Origen" captionKey="asunto.concurso.tabConvenio.inicio" sortable="false" />
		<pfs:defineHeader dataIndex="estado" caption="**Estado" captionKey="asunto.concurso.tabConvenio.Estado" sortable="false" />
		<pfs:defineHeader dataIndex="adhesion" caption="**Adhesion" captionKey="asunto.concurso.tabConvenio.Adhesion" sortable="false" />
		<pfs:defineHeader dataIndex="postura" caption="**Postura" captionKey="asunto.concurso.tabConvenio.Postura" sortable="false" />
		<pfs:defineHeader dataIndex="descripProponentes" caption="**Descripción proponentes" captionKey="asunto.concurso.tabConvenio.descripProponentes" sortable="false" />
	</pfs:defineColumnModel>
	
	var btAddConvenioProcedimiento = function(){
		if (conveniosGrid.getSelectionModel().getCount()>0){
			var numeroAuto =  conveniosGrid.getSelectionModel().getSelected().get('numeroAuto');
			if (numeroAuto != ''){
				var idProcedimiento =  conveniosGrid.getSelectionModel().getSelected().get('idProcedimiento');
				var parametros = {
						idProcedimiento : idProcedimiento,
						numeroAuto : numeroAuto
				};
				var w= app.openWindow({
							flow: 'plugin/procedimientos/concursal/agregarConvenio'
							,closable: true
							,width : 700
							,title : '<s:message code="app.agregar" text="**Agregar" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
				});
				w.on(app.event.CANCEL, function(){
							 w.close(); 
				});
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarNumAuto" text="**Debe seleccionar un nº de auto" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarNumAuto" text="**Debe seleccionar un nº de auto" />');
		}
	}
	<pfs:button name="btAddConvenio" caption="**Agregar"  captioneKey="app.agregar" iconCls="icon_mas">
		if (conveniosGrid.getSelectionModel().getCount()>0){
			var numeroAuto =  conveniosGrid.getSelectionModel().getSelected().get('numeroAuto');
			if (numeroAuto != ''){
				var idProcedimiento =  conveniosGrid.getSelectionModel().getSelected().get('idProcedimiento');
				var parametros = {
						idProcedimiento : idProcedimiento,
						numeroAuto : numeroAuto
				};
				var w= app.openWindow({
							flow: 'plugin/procedimientos/concursal/agregarConvenio'
							,closable: true
							,width : 700
							,title : '<s:message code="app.agregar" text="**Agregar" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
				});
				w.on(app.event.CANCEL, function(){
							 w.close(); 
				});
			}else{
				Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarNumAuto" text="**Debe seleccionar un nº de auto" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.agregar" text="**Agregar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarNumAuto" text="**Debe seleccionar un nº de auto" />');
		}
	</pfs:button>
		
	var btnEditConvenioProcedimiento = function(){ 
		if (conveniosGrid.getSelectionModel().getCount()>0){
			
			var numeroAutoEnLinea =  conveniosGrid.getSelectionModel().getSelected().get('numeroAutoEnLinea');	
			var idConvenio = conveniosGrid.getSelectionModel().getSelected().get('idConvenio');	
				
			if (idConvenio != '') {
				var parametros = {
						idConvenio : idConvenio,
						numeroAuto : numeroAutoEnLinea
				};
				var w= app.openWindow({
							flow: 'plugin/procedimientos/concursal/editarConvenio'
							,closable: true
							,width : 700
							,title : '<s:message code="app.editar" text="**Editar" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
				});
				w.on(app.event.CANCEL, function(){
							 w.close(); 
				});
			}else{
				Ext.Msg.alert('<s:message code="app.editar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarConvenio" text="**Debe seleccionar un convenio" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.editar" text="**Editar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarConvenio" text="**Debe seleccionar un convenio" />');
		}
	};
	
	<pfs:button name="btEditConvenio" caption="**Editar" captioneKey="app.editar" iconCls="icon_edit">
		btnEditConvenioProcedimiento();
	</pfs:button>
	
	 <pfs:button name="btRemoveConvenio" caption="**Borrar" captioneKey="app.borrar" iconCls="icon_cancel">
		if (conveniosGrid.getSelectionModel().getCount()>0){
			var idConvenio = conveniosGrid.getSelectionModel().getSelected().get('idConvenio');
			if (idConvenio != ''){
				Ext.Msg.confirm('<s:message code="app.borrar" text="**Borrar" />', '<s:message code="asunto.concurso.tabFaseComun.borrarConvenio" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == "yes") {
	    				var parametros = {
	    					idConvenio : idConvenio
	    				};
	   					page.webflow({
							flow: 'plugin/procedimientos/concursal/borrarConvenio'
							,params: parametros
							,success : function(){ 
								entidad.refrescar();
							}
						});
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarConvenio" text="**Debe seleccionar un convenio" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="asunto.concurso.tabFaseComun.debeSeleccionarConvenio" text="**Debe seleccionar un convenio" />');
		}
	</pfs:button>

	var convenioSeleccionado = null;

   	var conveniosStore = page.getStore({
        flow: 'plugin/procedimientos/concursal/listadoConveniosData'                                                                                                                                 
        ,reader : new Ext.data.JsonReader(
           			 	{root:'convenios'}
            			, Convenio
        		  )
   	}); 
   
   	var despuesDeNuevoConvenio = function(){
   		var ultimoRegistro = conveniosStore.getCount();
		conveniosGrid.getSelectionModel().selectRow((ultimoRegistro-1));
		conveniosGrid.fireEvent('rowclick', conveniosGrid, (ultimoRegistro-1));
		conveniosStore.un('load',despuesDeNuevoAcuerdo);
   	}
   
   	var despuesDeEvento = function(){
   		conveniosGrid.getSelectionModel().selectRow(convenioSeleccionado-1);
		conveniosGrid.fireEvent('rowclick', conveniosGrid, convenioSeleccionado-1);
		conveniosStore.un('load',despuesDeEvento);
   	}
    
    var cargarUltimoConvenio = function(){
   		panel.remove(panelAnterior);
		panelAnterior = recargarAcuerdo(-2);
		panel.add(panelAnterior);
		panel.doLayout();
		
   };   
       
	var grid_cfg={
		title : '<s:message code="asunto.concurso.tabConvenio.title" text="**Convenios" />'
		,collapsible : false
		,collapsed: false
		,titleCollapse : false
		,stripeRows:true
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,autoHeight : true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_CONCURSO_CONVENIO">,bbar : [btAddConvenio, btEditConvenio, btRemoveConvenio]</sec:authorize>
	};
	
	var conveniosGrid = app.crearGrid(conveniosDS,convenioCM,grid_cfg);

	// Evento doble click
	conveniosGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var idConvenio = conveniosGrid.getSelectionModel().getSelected().get('idConvenio');	
		if (idConvenio != '') {
			btnEditConvenioProcedimiento();
		} else {
			btAddConvenioProcedimiento();
		}
    });	
    	
	var reload = function(){
		panel.remove(panelAnterior);
		panelAnterior = recargarConvenio(convenioSeleccionado);
		panel.add(panelAnterior);
		panel.doLayout();
		//conveniosStore.webflow(params());
		entidad.refrescar();
	}
	
	// Función que provoca el evento al cambiar de registro
	var panelAnterior;
	conveniosGrid.on('rowclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var idConvenio = rec.get('idConvenio');
		if (idConvenio != '') {
   			convenioSeleccionado = idConvenio;
			panel.remove(panelAnterior);
				panelAnterior = recargarConvenio(idConvenio);
				panel.add(panelAnterior);
				conveniosDS.convenioSeleccionado = conveniosDS.convenioSeleccionado || {};
				conveniosDS.convenioSeleccionado[data.id] = idConvenio;
				panel.doLayout();			
		}
   	});

	
	var recargarConvenio = function(idConvenio){
		var url = '/${appProperties.appName}/plugin/procedimientos/concursal/detalleConveniosData.htm',
		config = config || {};
		var autoLoad = {url : url+"?"+Math.random()
				,scripts: true
				,params: {idConvenio:idConvenio}
				};
		var cfg = {
			autoLoad : autoLoad
			,id:idConvenio
			,border:false
			,bodyStyle:'padding:5px'
			,defaults:{
            	border:false            
        		}
		};
		var panel2 = new Ext.Panel(cfg);
		panel2.show();
		panel2.on(app.event.DONE, function(){
				  reload();
		       });
		return panel2;
	};

	var panel2 = recargarConvenio('-1');

	var panel = new Ext.Panel({
		title : '<s:message code="asunto.concurso.tabConvenio.title" text="**Convenios" />'
		,autoHeight : true
		,items : [conveniosGrid]
	});
	
	panel.getValue = function() {}

	panel.setValue = function() {
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, conveniosDS, {idAsunto : data.id });
	}
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").concursal.procedimientosConcursales > 0;
	}

	return panel;
	
})
