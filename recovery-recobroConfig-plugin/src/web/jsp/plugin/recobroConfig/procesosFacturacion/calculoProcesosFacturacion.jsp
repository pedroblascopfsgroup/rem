<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="ESTADO_CANCELADO" value="${ESTADO_CANCELADO}"/>
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_PROCESADO" value="${ESTADO_PROCESADO}"/>
	<pfs:hidden name="ESTADO_PENDIENTE" value="${ESTADO_PENDIENTE}" />
	<pfs:hidden name="ESTADO_ERRORES" value="${ESTADO_ERRORES}" />

	<pfsforms:textfield name="ultimoPeriodo" labelKey="plugin.recobroConfig.procesoFacturacion.ultimoPeriodo" 
		label="**Último periodo facturado y liberado " value="${ultimoPeriodo}" readOnly="true" width="800" />
		
	ultimoPeriodo.labelStyle='font-weight:bold; width:210px;';	
		
	var periodos = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:1
		}
		,autoWidth:true
		,title:'<s:message code="plugin.recobroConfig.procesoFacturacion.titulo.ultimoPeriodo" text="**Periodo de Facturacion"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:800}
		,items :[{items:[ultimoPeriodo]} ]
	});
	
		
	<pfs:defineRecordType name="procesosFacturacion">
			<pfs:defineTextColumn name="id" />
			<pfs:defineDateColumn name="fechaDesde" />
			<pfs:defineDateColumn name="fechaHasta" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="totalImporteFacturable" />
			<pfs:defineTextColumn name="totalImporteCobros" />
			<pfs:defineTextColumn name="usuarioCreacion" />
			<pfs:defineTextColumn name="estadoProcesoFacturable" />
			<pfs:defineTextColumn name="estadoProcesoFacturableCod"/>
			<pfs:defineTextColumn name="errorBatch"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="procesosFacturacionCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.id" caption="**Id"
			sortable="true"  firstHeader="true"/>
		<pfs:defineHeader dataIndex="fechaDesde"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.fechaDesde" caption="**Fecha desde"
			sortable="true" />	
		<pfs:defineHeader dataIndex="fechaHasta"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.fechaHasta" caption="**Fecha hasta"
			sortable="true" />	
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.nombre" caption="**Nombre"
			sortable="true" />	
		<pfs:defineHeader dataIndex="totalImporteCobros"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.totalImporteCobros" caption="**Total cobros"
			sortable="false" align="right"/>	
		<pfs:defineHeader dataIndex="totalImporteFacturable"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.totalImporteFacturable" caption="**Total facturable"
			sortable="false" renderer="app.format.moneyRenderer" align="right" />
		<pfs:defineHeader dataIndex="usuarioCreacion"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.usuarioCreacion" caption="**Usuario"
			sortable="true" />
		<pfs:defineHeader dataIndex="estadoProcesoFacturable"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.estadoProcesoFacturable" caption="**Estado"
			sortable="true" />	
		<pfs:defineHeader dataIndex="errorBatch"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaProceso.errorBatch" caption="**Error de procesado"
			sortable="true" />								
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" />
	
    
   	<pfs:remoteStore name="procesosFacturacionDS" resultRootVar="procesosFacturacion" recordType="procesosFacturacion" 
   		dataFlow="recobroprocesosfacturacion/buscaProcesosFacturacion" parameters="getParametros" autoload="true"/>
    	
    var pagingBar=fwk.ux.getPaging(procesosFacturacionDS);
    
    var btnNuevo = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesoFacturacion.nuevo" text="**Nuevo proceso de facturación" />'
		<app:test id="btnNuevo" addComa="true" />
		,iconCls : 'icon_mas'
		,disabled : false
		,handler :  function(){
		    	var w= app.openWindow({
								flow: 'recobroprocesosfacturacion/altaProdesoFacturacion'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.procesoFacturacion.nuevo" text="**Nuevo proceso de facturación" />'
								,params: {}
							});
							w.on(app.event.DONE, function(){
								gridProcesosFacturacion.store.webflow(getParametros());
								w.close();
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
		}
	});	
	
	var callCancelar = function(btn){
		if (btn == 'yes'){    					
			var parms = {};
			parms.idProcesoFacturacion = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');
			page.webflow({
				flow: 'recobroprocesosfacturacion/cancelarProcesoFacturacion'
				,params: parms
				,success : function(){ 
					gridProcesosFacturacion.store.webflow(getParametros());
					gridSubcarteras.store.webflow({idProcesoFacturacion:gridProcesosFacturacion.getSelectionModel().getSelected().get('id')}); 
				}
			});
		}
	};
	
	var btBorrar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar facturación" />'
		,iconCls : 'icon_menos'
		,disabled : true
		,handler : function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var nombre =  gridProcesosFacturacion.getSelectionModel().getSelected().get('nombre');
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_LIBERADO.getValue()) {
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar facturación" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.preguntaLiberado" text="**Este proceso de facturación ya se ha liberado y no se puede eliminar.<br>¿Está seguro de cancelar el detalle de facturación \"{0}\"?" arguments="'+nombre+'"/>', function(btn){
		   				callCancelar(btn);
					});
				} else {						
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.eliminar" text="**Eliminar facturación" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.preguntaNoLiberado" text="**¿Está seguro de eliminar físicamente el detalle de facturación \"{0}\"?" arguments="'+nombre+'"/>', function(btn){
		   				callCancelar(btn);
					});
				}
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.noSeleccionado" text="**Debe seleccionar un registro" />');
			}
		}
	});
	
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,handler : function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var nombre =  gridProcesosFacturacion.getSelectionModel().getSelected().get('nombre');
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_PROCESADO.getValue()) {
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.liberar" text="**Liberar facturación" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.liberarFacturacion.pregunta" text="¿Está seguro de liberar el proceso de facturación seleccionado?"/>', function(btn){
		   				if (btn == 'yes'){    					
						var parms = {};
						parms.idProcesoFacturacion = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');
							page.webflow({
								flow: 'recobroprocesosfacturacion/liberarProcesoFacturacion'
								,params: parms
								,success : function(){ 
										gridProcesosFacturacion.store.webflow(getParametros());
										gridSubcarteras.store.webflow({idProcesoFacturacion:gridProcesosFacturacion.getSelectionModel().getSelected().get('id')});
										btLiberar.setDisabled(true);
								}
							});
						}
					});
				} else {						
					Ext.Msg.alert('<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.Error" text="**Error al Liberar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.estadoIncorrecto" text="**Solo se pueden liberar los procesos que están en estado procesado"/>');
					}
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.liberar" text="**Liberar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.noSeleccionado" text="**Debe seleccionar un registro" />');
			}
		}
	});
	
	var btPendiente= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.pasarPte" text="**Marcar pendiente" />'
		,iconCls : 'icon_marcar_pte'
		,disabled : true
		,handler : function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var nombre =  gridProcesosFacturacion.getSelectionModel().getSelected().get('nombre');
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_PROCESADO.getValue()  || estado == ESTADO_ERRORES.getValue()) {
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.pasarPte" text="**Marcar pendiente" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.pasarPendiente.pregunta" text="**¿Está seguro de pasar el pendiente el proceso de facturación seleccionado?"/>', function(btn){
		   				if (btn == 'yes'){    					
						var parms = {};
						parms.idProcesoFacturacion = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');
							page.webflow({
								flow: 'recobroprocesosfacturacion/marcarPendienteProcesoFacturacion'
								,params: parms
								,success : function(){ 
										gridProcesosFacturacion.store.webflow(getParametros());
										gridSubcarteras.store.webflow({idProcesoFacturacion:gridProcesosFacturacion.getSelectionModel().getSelected().get('id')});
										btPendiente.setDisabled(true);
								}
							});
						}
					});
				} else {						
					Ext.Msg.alert('<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.Error" text="**Error al Liberar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.estadoIncorrecto" text="**Solo se pueden liberar los procesos que están en estado procesado"/>');
					}
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.liberar" text="**Liberar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.noSeleccionado" text="**Debe seleccionar un registro" />');
			}
		}
	});
	
	var btDescargar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.descargar" text="**Descargar fichero" />'
		,iconCls : 'icon_download'
		,disabled:true
		,handler : function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_LIBERADO.getValue() || estado == ESTADO_PROCESADO.getValue()) {
					var id = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');
					var params = {idProcesoFacturacion : id};					
					var flow = '/pfs/recobroprocesosfacturacion/descargarFichero';
					app.openBrowserWindow(flow,params);
				}
			}
		}
	});	
	
	var btDescargarReducido= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.descargarReducido" text="**Descargar fichero reducido" />'
		,iconCls : 'icon_download'
		,disabled:true
		,handler : function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_LIBERADO.getValue() || estado == ESTADO_PROCESADO.getValue()) {
					var id = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');
					var params = {idProcesoFacturacion : id};					
					var flow = '/pfs/recobroprocesosfacturacion/descargarFicheroReducido';
					app.openBrowserWindow(flow,params);
				}
			}
		}
	});	
    		
	var gridProcesosFacturacion = new Ext.grid.GridPanel({
        store: procesosFacturacionDS
        ,cm: procesosFacturacionCM
        ,title: '<s:message code="plugin.recobroConfig.procesoFacturacion.gridProcesosFacturacion.title" text="**Procesos de facturación generados"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingBar, btnNuevo, btBorrar, btLiberar,btPendiente, btDescargar, btDescargarReducido]
    });	
    
    
    <pfs:defineRecordType name="subcarteraFacturacion">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="idProcesoFacturacion" />
			<pfs:defineTextColumn name="cartera" />
			<pfs:defineTextColumn name="subCartera" />
			<pfs:defineTextColumn name="modeloFacturacionInicial" />
			<pfs:defineTextColumn name="modeloFacturacionActual" />
			<pfs:defineTextColumn name="totalImporteCobros" />
			<pfs:defineTextColumn name="totalImporteFacturable" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="subcarterasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.id" caption="**Id"
			sortable="true" hidden="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="idProcesoFacturacion"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.idProcesoFacturacion" caption="**IdProcesoFacturacion"
			sortable="true" hidden="true" />	
		<pfs:defineHeader dataIndex="cartera"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.cartera" caption="**Cartera"
			sortable="true" />	
		<pfs:defineHeader dataIndex="subCartera"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.subCartera" caption="**Subcartera"
			sortable="true" />	
		<pfs:defineHeader dataIndex="modeloFacturacionInicial"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.modeloFacturacionInicial" caption="**Modelo Factur."
			sortable="true" />	
		<pfs:defineHeader dataIndex="modeloFacturacionActual"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.modeloFacturacionActual" caption="**Modelo Factur. Corregido"
			sortable="true" />	
		<pfs:defineHeader dataIndex="totalImporteCobros"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.totalImporteCobros" caption="**Cobros"
			sortable="true" align="right" />
		<pfs:defineHeader dataIndex="totalImporteFacturable"
			captionKey="plugin.recobroConfig.procesoFacturacion.columnaSubcarteraProceso.totalImporteFacturable" caption="**Facturable"
			sortable="true" renderer="app.format.moneyRenderer" align="right" />							
	</pfs:defineColumnModel>
    
   	<pfs:remoteStore name="subcarterasDS" resultRootVar="subcarteras" recordType="subcarteraFacturacion"  dataFlow="recobroprocesosfacturacion/listaSubcarterasProcesoFacturacion" autoload="false"/>
	
	<%-- 
	
	var btBorrarDetalle= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.borrarDetalle" text="**Borrar detalle" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridSubcarteras.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.calculo.borrarDetalle" text="**Borrar detalle" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.borrarDetalleFacturacion.pregunta" text="¿Está seguro de borrar el detalle de facturación?"/>', function(btn){
		   				if (btn == 'yes'){    					
						var parms = {};
						parms.idDetalleFacturacion = gridSubcarteras.getSelectionModel().getSelected().get('id');
							page.webflow({
								flow: 'recobroprocesosfacturacion/borrarDetalleFacturacion'
								,params: parms
								,success : function(){ 
										gridProcesosFacturacion.store.webflow(getParametros());
										gridSubcarteras.store.webflow({idProcesoFacturacion:gridSubcarteras.getSelectionModel().getSelected().get('idProcesoFacturacion')}); 
								}
							});
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.noSeleccionado" text="**Debe seleccionar un registro" />');
			}
		}
	});
	--%>
		 
	var btnCorregirModelosFacturacion = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesoFacturacion.corregirModelo" text="**Corregir modelos de facturación" />'
		<app:test id="btnCorregirModelosFacturacion" addComa="true" />
		,iconCls : 'icon_edit'
		,disabled : true
		,handler :  function(){
			if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var parms = {};
				parms.idProcesoFacturacion = gridProcesosFacturacion.getSelectionModel().getSelected().get('id');		
		    	var w= app.openWindow({
								flow: 'recobroprocesosfacturacion/corregirModelosFacturacion'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.procesoFacturacion.corregirModelo" text="**Corregir modelos de facturación" />'
								,params: parms
							});
							w.on(app.event.DONE, function(){
								gridProcesosFacturacion.store.webflow(getParametros());
								gridSubcarteras.store.webflow({idProcesoFacturacion:gridProcesosFacturacion.getSelectionModel().getSelected().get('id')});
								w.close();
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.procesoFacturacion.corregirModelo" text="**Corregir modelos de facturación" />','<s:message code="plugin.recobroConfig.procesosFacturacion.corregirModelos.noSeleccionado" text="**Debe seleccionar un proceso de facturación" />');
			}			
		}
	});	
    		
	var gridSubcarteras = new Ext.grid.GridPanel({
        store: subcarterasDS
        ,cm: subcarterasCM
        ,title: '<s:message code="plugin.recobroConfig.procesoFacturacion.gridSubcarteras.title" text="**Listado de subcarteras: Modelos de facturación + importes"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[btnCorregirModelosFacturacion]
    });	
    
    gridProcesosFacturacion.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var rec = gridProcesosFacturacion.getStore().getAt(rowIndex);
    	var idProcesoFacturacion = rec.get('id');
    	subcarterasDS.webflow({idProcesoFacturacion:idProcesoFacturacion});
    	if (gridProcesosFacturacion.getSelectionModel().getCount()>0){
				var estado = gridProcesosFacturacion.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				btBorrar.setDisabled(false); 
    			if (estado == ESTADO_PROCESADO.getValue() || estado == ESTADO_PENDIENTE.getValue()){
    				btnCorregirModelosFacturacion.setDisabled(false);
    				btBorrar.setText('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.eliminar" text="**Eliminar" />');
    			}  else {
    				btnCorregirModelosFacturacion.setDisabled(true);
    			}
    			if (estado == ESTADO_PROCESADO.getValue() || estado == ESTADO_LIBERADO.getValue()){
    				btDescargar.setDisabled(false);
    				btDescargarReducido.setDisabled(false);
    				if (estado == ESTADO_LIBERADO.getValue()) {
    					btBorrar.setText('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar" />');
    				}
    			}  else {
    				btDescargar.setDisabled(true);
    				btDescargarReducido.setDisabled(true);
    			}
    			if (estado == ESTADO_ERRORES.getValue() || estado==ESTADO_PROCESADO.getValue() ){
    				/* Solo un proceso de facturación en estado pendiente */
    				if (procesosFacturacionDS.findExact('estadoProcesoFacturableCod', ESTADO_PENDIENTE.getValue())==-1) {
    					btPendiente.setDisabled(false);
    				} else {
    					btPendiente.setDisabled(true);
    				}
    			} else {
    				btPendiente.setDisabled(true);
    			}
				if (estado == ESTADO_PROCESADO.getValue()) {
					btLiberar.setDisabled(false);
				} else {
					btLiberar.setDisabled(true);
				}
		} else {
			btBorrar.setDisabled(true); 
    		btDescargar.setDisabled(true);
    		btDescargarReducido.setDisabled(true); 
    		btnCorregirModelosFacturacion.setDisabled(true);
    		btLiberar.setDisabled(true);
    		btPendiente.setDisabled(true);
		}		
    	
    });
	
	var panel = new Ext.Panel({
		height:700
		,autoWidth:true
		,bodyStyle:'padding: 10px'
		,items:[periodos
				,gridProcesosFacturacion
				,gridSubcarteras
			]
	});
	
	page.add(panel);

</fwk:page>