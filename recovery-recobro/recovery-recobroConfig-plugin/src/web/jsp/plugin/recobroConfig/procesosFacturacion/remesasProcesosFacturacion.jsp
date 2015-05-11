<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var ahora = new Date();

	<pfs:hidden name="ESTADO_CANCELADO" value="${ESTADO_CANCELADO}"/>
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_PROCESADO" value="${ESTADO_PROCESADO}"/>
		
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.procesosFacturacion.remesas.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.procesoFacturacion.remesas.estadoProceso"
		label="**Estado proceso facturacion" value="" dd="${ddEstadosProceso}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
			
	var fechaInicioDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.fechaInicioDesde" text="**Fecha facturación inicio desde" />'
		,name:'fechaInicioDesde'
		,style:'margin:0px'
		,maxValue: ahora 
	});
	
	var fechaInicioHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.fechaInicioHasta" text="**Fecha facturación inicio hasta" />'
		,name:'fechaInicioHasta'
		,style:'margin:0px'
		,maxValue: ahora
	});

	fechaInicioDesde.on('change',function( field, newValue, oldValue ) {
		if (newValue != '') {
			fechaInicioHasta.setMinValue(newValue);
		} else {
			fechaInicioHasta.setMinValue();
		}
	});
	
	fechaInicioHasta.on('change',function( field, newValue, oldValue ) {
		if (newValue != '') {
			fechaInicioDesde.setMaxValue(newValue);
		} else {
			fechaInicioDesde.setMaxValue(ahora);
		}
	});

	var panelFechasDesde=new Ext.Panel({
		layout : 'column'
		,viewConfig : {columns : 4}
		,border : false
		,autoHeight : true
		,width: 350
		,bodyStyle:'padding:0px;cellspacing:10px'
		,defaults : {bodyStyle : 'margin-right:5px;cellspacing:10px;'}
		,items : [{html:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.panelFechaDesde" text="**Fecha facturación inicio:" />', border: false, width : 105, cls: 'x-form-item'},fechaInicioDesde,{html:'', padding:5, border: false, width : 5, cls: 'x-form-item'},fechaInicioHasta]
	});

	var fechaFinDesde = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.fechaFinDesde" text="**Fecha facturación fin desde" />'
		,name:'fechaFinDesde'
		,style:'margin:0px'
		,maxValue: ahora 
	});
	
	var fechaFinHasta = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.fechaFinHasta" text="**Fecha facturación fin hasta" />'
		,name:'fechaFinHasta'
		,style:'margin:0px'
		,maxValue: ahora
	});

	var panelFechasHasta=new Ext.Panel({
		layout : 'column'
		,viewConfig : {columns : 4}
		,border : false
		,autoHeight : true
		,width: 350
		,bodyStyle:'padding:0px;cellspacing:10px'
		,defaults : {bodyStyle : 'margin-right:5px;cellspacing:10px;'}
		,items : [{html:'<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.panelFechaHasta" text="**Fecha facturación fin:" />', border: false, width : 105, cls: 'x-form-item'},fechaFinDesde,{html:'', padding:5, border: false, width : 5, cls: 'x-form-item'},fechaFinHasta]
	});

	fechaFinDesde.on('change',function( field, newValue, oldValue ) {
		if (newValue != '') {
			fechaFinHasta.setMinValue(newValue);
		} else {
			fechaFinHasta.setMinValue();
		}
	});
	
	fechaFinHasta.on('change',function( field, newValue, oldValue ) {
		if (newValue != '') {
			fechaFinDesde.setMaxValue(newValue);
		} else {
			fechaFinDesde.setMaxValue(ahora);
		}
	});
	
	var facturacionRecord = Ext.data.Record.create([
    	{name: 'id', type:'float'}
    	,{name: 'nombre'}
    	,{name: 'fechaDesde'}
    	,{name: 'fechaHasta'}
    	,{name: 'usuarioCreacion'}
    	,{name: 'usuarioLiberacion'}
    	,{name: 'usuarioCancelacion'}
    	,{name: 'fechaCreacion'}
    	,{name: 'fechaLiberacion'}
    	,{name: 'fechaCancelacion'}
    	,{name: 'estadoProcesoFacturable'}
    	,{name: 'estadoProcesoFacturableCod'}
    	,{name: 'totalImporteFacturable', type:'float'}
    ]);
	
	var facturacionCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.id" text="**Id" />', hidden:true, dataIndex : 'id',sortable:true}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.nombre" text="**Nombre" />', hidden:false, dataIndex : 'nombre',sortable:true}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.fDesde" text="**Fecha desde" />', dataIndex : 'fechaDesde' ,sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.fHasta" text="**Fecha hasta" />', dataIndex : 'fechaHasta' ,sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.importe" text="**Importe" />', dataIndex : 'totalImporteFacturable',sortable:false, hidden:false, renderer: app.format.moneyRenderer,align:'right'}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.estado" text="**Estado petición" />', dataIndex : 'estadoProcesoFacturable',sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.fLiberacion" text="**Fecha liberación" />', dataIndex : 'fechaLiberacion',sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.usuLiberacion" text="**Usuario liberación" />', dataIndex : 'usuarioLiberacion',sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.fCancelacion" text="**Fecha cancelación." />', dataIndex : 'fechaCancelacion',sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.usuCancelacion" text="**Usuario cancelación" />', dataIndex : 'usuarioCancelacion',sortable:true, hidden:false}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.fCreacion" text="**Fecha creación" />', dataIndex : 'fechaCreacion',sortable:true, hidden:true}
		,{header : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.gridRemesas.usuCreacion" text="**Usuario creación" />', dataIndex : 'usuarioCreacion',sortable:true, hidden:true}
	]);
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" estadoProcesoFacturable="filtroEstado" 
		fechaInicioDesde="fechaInicioDesde" fechaInicioHasta="fechaInicioHasta" 
		fechaFinDesde="fechaFinDesde" fechaFinHasta="fechaFinHasta" />

	<pfs:remoteStore name="dataStore" 
		resultRootVar="procesosFacturacion" 
		resultTotalVar="total" 
		recordType="facturacionRecord" 
		dataFlow="recobroprocesosfacturacion/buscaProcesosFacturacion" />
	
	var callCancelar = function(btn){
		if (btn == 'yes'){    					
			var parms = {};
			parms.idProcesoFacturacion = procesosFacturacionGrid.getSelectionModel().getSelected().get('id');
			page.webflow({
				flow: 'recobroprocesosfacturacion/cancelarProcesoFacturacion'
				,params: parms
				,success : function(){
					btBorrar.setDisabled(true); 
					btDescargar.setDisabled(true);
					buscarFunc();
				}
			});
		}
	};
	
	var btBorrar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar facturación" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,hidden: true
		,handler : function(){
			if (procesosFacturacionGrid.getSelectionModel().getCount()>0){
				var nombre =  procesosFacturacionGrid.getSelectionModel().getSelected().get('nombre');
				var estado = procesosFacturacionGrid.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_LIBERADO.getValue()) {
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar facturación" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.preguntaLiberado" text="**Este proceso de facturación ya se ha liberado y no se puede eliminar.<br>¿Está seguro de cancelar el detalle de facturación \"{0}\"?" arguments="'+nombre+'"/>', function(btn){
		   				callCancelar(btn);
					});
				} else {						
					Ext.Msg.confirm('<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.cancelar" text="**Cancelar facturación" />', '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.preguntaNoLiberado" text="**¿Está seguro de eliminar físicamente el detalle de facturación \"{0}\"?" arguments="'+nombre+'"/>', function(btn){
		   				callCancelar(btn);
					});
				}
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.noSeleccionado" text="**Debe seleccionar un registro" />');
			}
		}
	});	

	var btDescargar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.descargar" text="**Descargar fichero" />'
		,iconCls : 'icon_download'
		,disabled:true
		,handler : function(){
			if (procesosFacturacionGrid.getSelectionModel().getCount()>0){
				var estado = procesosFacturacionGrid.getSelectionModel().getSelected().get('estadoProcesoFacturableCod');
				if (estado == ESTADO_LIBERADO.getValue() || estado == ESTADO_PROCESADO.getValue()) {
					var id = procesosFacturacionGrid.getSelectionModel().getSelected().get('id');
					var params = {idProcesoFacturacion : id};					
					var flow = '/pfs/recobroprocesosfacturacion/descargarFichero';
					app.openBrowserWindow(flow,params);
				}
			}
		}
	});
		
	var validarAntesDeBuscar = function(){
		buscarFunc();
	};

	var limit=25;
	var DEFAULT_WIDTH=700;

	var buscarFunc = function(){
                var params= getParametros();
                params.start=0;
                params.limit=limit;
                dataStore.webflow(params);
				//Cerramos el panel de filtros y esto hará que se abra el listado de personas
				filtroForm.collapse(true);
	};	
	
	var btnBuscar=app.crearBotonBuscar({
		handler : validarAntesDeBuscar
	});
	
	var btnReset = app.crearBotonResetCampos(getParametros_camposFormulario);
	
	var filtroForm = new Ext.Panel({
		title : '<s:message code="plugin.recobroConfig.procesosFacturacion.remesas.tabName" text="**Listado procesos de facturación" />'
		,autoHeight:true
		,autoWidth:true
		,layout:'table'
		,layoutConfig:{columns:2}
		,titleCollapse : true
		,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[
			{
				layout:'form'
				,items:[filtroNombre]
			},{
				layout:'form'
				,items:[filtroEstado]
			},{
				layout:'form'
				,items:[panelFechasDesde]
			},{
				layout:'form'
				,items:[panelFechasHasta]
			}
			
		]
		,tbar : [btnBuscar, btnReset]
		,listeners:{	
			beforeExpand:function(){
				procesosFacturacionGrid.collapse(true);
				procesosFacturacionGrid.setHeight(200);
			}
			,beforeCollapse:function(){
				procesosFacturacionGrid.expand(true);
				procesosFacturacionGrid.setHeight(200);
			}
		}
		
	});	
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	
	var procesosFacturacionGrid = new Ext.grid.GridPanel({
        store: dataStore
        ,cm: facturacionCM
        ,title : '<s:message code="plugin.recobroConfig.procesosFacturacion.gridProcesosFacturacion.title" text="**Procesos de facturacion" />'
        ,collapsible : true
		,collapsed: true
		,titleCollapse : true
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar : [pagingBar, btDescargar, btBorrar]
    });	
	
	procesosFacturacionGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var estado = procesosFacturacionGrid.getStore().getAt(rowIndex).get('estadoProcesoFacturableCod');
		btBorrar.setDisabled(estado == ESTADO_CANCELADO.getValue());
		btDescargar.setDisabled(estado != ESTADO_LIBERADO.getValue() && estado != ESTADO_PROCESADO.getValue());
	});
	
    var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[filtroForm]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[procesosFacturacionGrid]
    		}
    	]
	    ,autoHeight : true
	    ,border: false
    });
	
	//añadimos al padre y hacemos el layout
	page.add(mainPanel);			
	
	<sec:authorize ifAllGranted="ROLE_CONF_PROC_FACTURACION">
		btBorrar.show();
	</sec:authorize>
	
</fwk:page>	