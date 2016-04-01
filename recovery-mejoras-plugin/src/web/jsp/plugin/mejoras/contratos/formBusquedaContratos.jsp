<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

var formBusquedaContratos=function(){

	var limit=25;

	//numero contrato
	var txtContrato = app.creaText('contrato1', '<s:message code="listadoContratos.numContrato" text="**Num. Contrato" />'); 
	//nombre
	var txtNombre = app.creaText('nombre', '<s:message code="listadoContratos.nombre" text="**Nombre" />');

	//apellido1
	var txtApellido1 = app.creaText('apellido1', '<s:message code="listadoContratos.apellido1" text="**Apellido1" />');

	//apellido2
	var txtApellido2 = app.creaText('apellido2', '<s:message code="listadoContratos.apellido2" text="**Apellido2" />');

	//documento
	var txtNIF = app.creaText('nif', '<s:message code="listadoContratos.nif" text="**NIF/CIF" />');

	<c:if test="${busquedaOrInclusion!='inclusion'}">
		//descripcion del expediente activo
		var txtExpediente = app.creaText('expediente', '<s:message code="listadoContratos.expediente" text="**Expediente" />');

		//nombre asunto activo
		var txtAsunto = app.creaText('asunto', '<s:message code="listadoContratos.asunto" text="**Asunto" />');
	</c:if>

	
	var dictEstados= <app:dict value="${estados}" />;

	var dictEstadosFinancieros = <app:dict value="${estadosFinancieros}" blankElement="true" blankElementValue="" blankElementText="---" />;

	//estado del contrato
	//var comboEstadoContrato = app.creaCombo({data:dictEstados,fieldLabel: '<s:message code="listadoContratos.estado" text="**Estado" />',name:'estadoContrato'});

	var comboEstadoContrato = app.creaDblSelect(dictEstados, '<s:message code="listadoContratos.estado" text="**Estado" />',{width:160});

	//var estadoActivo = '<fwk:const value="es.capgemini.pfs.contrato.model.DDEstadoContrato.ESTADO_CONTRATO_ACTIVO" />';
	//comboEstadoContrato.setValue(estadoActivo);

	//estado financiero
	var comboEstadoFinanciero = app.creaCombo({data:dictEstadosFinancieros,fieldLabel: '<s:message code="listadoContratos.estadofinanciero" text="**Estado Financiero" />',name:'estadoFinanciero'});

	//Riesgo total
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="menu.clientes.listado.filtro.riesgototal" text="**Riesgo Total" />', 'riesgo',{width : 80});

	//Saldo Vencido	
	var mmSVencido = app.creaMinMaxMoneda('<s:message code="menu.clientes.listado.filtro.svencido" text="**S. Vencido" />', 'svencido',{width : 80});

	//Días vencido	
	var mmDVencido = app.creaMinMax('<s:message code="menu.clientes.listado.filtro.dvencido" text="**D&iacute;as Vencido" />', 'dvencido',{width : 80, maxLength : "6"});
	var zonas=<app:dict value="${zonas}" />;

	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;

	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});

	<c:if test="${busquedaOrInclusion=='inclusion'}">
		//var dictTieneRiesgo = {diccionario:[{codigo:'',       descripcion:'---'}
		//								    ,{codigo:'true',  descripcion:'<s:message code="mensajes.si" text="**Sí" />'}
	    //                                    ,{codigo:'false', descripcion:'<s:message code="mensajes.no" text="**No" />'}]};
		//var comboTieneRiesgo = app.creaCombo({data:dictTieneRiesgo
		//	                                  ,value:''
		//	                                  ,name: 'tieneRiesgo'
		//                                      ,width:'32px'
		//	                                  ,fieldLabel: '<s:message code="menu.clientes.listado.filtro.tieneRiesgo" text="**Tiene riesgo" />'});
	</c:if>

 	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);

    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});

	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	}

    recargarComboZonas();

    comboJerarquia.on('select',recargarComboZonas);

	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, /*funcionReset:recargarComboZonas,*/ width:160});

	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		//recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);


	//diccionario de tiposProducto
	var diccTiposProducto= <app:dict value="${tiposProductoEntidad}" />;

    var comboTiposProducto = app.creaDblSelect(diccTiposProducto
            ,'<s:message code="menu.clientes.listado.filtro.tiposProducto" text="**Tipo de Producto" />'
            ,{
               	width:160
           	});

	 var getParametros = function() {
        return {
                nroContrato:txtContrato.getValue()
				,nombre:txtNombre.getValue()
				,apellido1:txtApellido1.getValue()
				,apellido2:txtApellido2.getValue()
				,documento:txtNIF.getValue()
				,stringEstadosContrato:comboEstadoContrato.getValue()
				,estadosFinancieros:comboEstadoFinanciero.getValue()
				<c:if test="${busquedaOrInclusion!='inclusion'}">
					,descripcionExpediente:txtExpediente.getValue()
					,nombreAsunto:txtAsunto.getValue()
				</c:if>
				,maxVolTotalRiesgo:mmRiesgoTotal.max.getValue()
				,minVolTotalRiesgo:mmRiesgoTotal.min.getValue()
				,maxVolRiesgoVencido:mmSVencido.max.getValue()
				,minVolRiesgoVencido:mmSVencido.min.getValue()
				,minDiasVencidos:mmDVencido.min.getValue()
				,maxDiasVencidos:mmDVencido.max.getValue()
				<c:if test="${busquedaOrInclusion=='inclusion'}">
        			//,tieneRiesgo:comboTieneRiesgo.getValue()
        		</c:if>
    			,codigoZona:comboZonas.getValue()
    			,jerarquia:comboJerarquia.getValue()
    			,tiposProducto:comboTiposProducto.getValue()
        		,busquedaOrInclusion:'${busquedaOrInclusion}'
        		, idProcedimiento: '${idProcedimiento}'
            };
    }

	var validarForm = function(){
		if (txtContrato.getValue().trim()!=''){
			return true;
		}
		if (txtNombre.getValue().trim()!=''){
			return true;
		}
		if (txtApellido1.getValue().trim()!=''){
			return true;
		}
		if (txtApellido2.getValue().trim()!=''){
			return true;
		}
		if (txtNIF.getValue().trim()!=''){
			return true;
		}
		if (comboEstadoContrato.getValue().trim()!=''){
			return true;
		}
		if (comboEstadoFinanciero.getValue().trim()!=''){
			return true;
		}
		<c:if test="${busquedaOrInclusion!='inclusion'}">
			if (txtExpediente.getValue().trim()!=''){
				return true;
			}
			if (txtAsunto.getValue().trim()!=''){
				return true;
			}
		</c:if>
		if (comboZonas.getValue().trim()!=''){
			return true;
		}
		if (comboJerarquia.getValue().trim()!=''){
			return true;
		}
		if(!(mmRiesgoTotal.max.getValue()==='')){
			return true;
		}
		if(!(mmRiesgoTotal.min.getValue()==='')){
			return true;
		}
		if(!(mmSVencido.max.getValue()==='')){
			return true;
		}
		if(!(mmSVencido.min.getValue()==='')){
			return true;
		}
		if(!(mmDVencido.min.getValue()==='')){
			return true;
		}
		if(!(mmDVencido.max.getValue()==='')){
			return true;
		}
		if(!(comboTiposProducto.getValue()==='')){
			return true;
		}
		<c:if test="${busquedaOrInclusion=='inclusion'}">
			//if(!(comboTieneRiesgo.getValue()==='')){
			//	return true;
			//}
		</c:if>
		return false;
	}
	
	var validaMinMax = function(){
		if (!app.validaValoresDblText(mmRiesgoTotal)){
			return false;
		}
		if (!app.validaValoresDblText(mmSVencido)){
			return false;
		}
		if (!app.validaValoresDblText(mmDVencido)){
			return false;
		}
		return true;
	}

	var buscarFunc=function(){

		/* El cliente ya no quiere este requisito de obligatorio
		if (comboEstadoContrato.getValue().trim() == ''){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.contratos.listado.faltaEstado" text="**El criterio de estado de contrato es obligatorios"/>')
			return;
		}
		*/

		if (validarForm()){
			if (validaMinMax()){
				panelFiltros.collapse(true);
								
				var params= getParametros();
        		params.start=0;
        		params.limit=limit;
				contratosStore.webflow(params);
				pagingBar.show();
				
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}

	};

	var btnReset = app.crearBotonResetCampos(
		[
			txtContrato
			,txtNombre
			,txtApellido1
			,txtApellido2
			,txtNIF
			,comboEstadoContrato
			,comboEstadoFinanciero
			<c:if test="${busquedaOrInclusion!='inclusion'}">
				,txtExpediente
				,txtAsunto
			</c:if>
			,mmRiesgoTotal.max
			,mmRiesgoTotal.min
			,mmSVencido.max
			,mmSVencido.min
			,mmDVencido.min
			,mmDVencido.max
    		,comboJerarquia
    		,comboZonas
    		,comboTiposProducto
    		<c:if test="${busquedaOrInclusion=='inclusion'}">
				//,comboTieneRiesgo
			</c:if>
		]);

	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});


	var limiteContratos = Ext.data.Record.create([
		     {name : 'codigoResultado' }
		     ,{name : 'mensajeError' }
		     ,{name : 'nResultados' }
		]);
	
		
		var limiteContratosStore = page.getStore({
			flow : 'contratos/superaLimiteExport'
			,reader: new Ext.data.JsonReader({
		    	root : 'resultados'
		    }, limiteContratos)
		});

	
	var codigoOk = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_OK" />';
	var codigoError = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_ERROR" />';

	limiteContratosStore.on('load', function(){
		var rec = limiteContratosStore.getAt(0);
		var codigoResultado = rec.get('codigoResultado');

		if (codigoResultado == codigoError)
		{
			var mensaje = rec.get('mensajeError');
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',mensaje);
			return;
		}
		else if (codigoResultado == codigoOk)
		{
	        var params=getParametros();
	        var flow='contratos/exportContratos';
	        app.openBrowserWindow(flow,params);
		}
	});


    var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
					if (validarForm()){
						if (validaMinMax()){
		                    var params=getParametros();
							limiteContratosStore.webflow(params);
						}else{
							Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
						}
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
					}
                }
             }
        );






	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,title : '<s:message code="listadoContratos.filtros" text="**Filtro de Contratos" />'
			,titleCollapse:true
			,collapsible:true
			,tbar : [btnBuscar,btnReset,btnExportarXls, '->', app.crearBotonAyuda()]
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,bodyStyle:'padding:5px;cellspacing:10px'
			,items:[{
					autoHeight:true
					,autoWidth:true
					,layout:'table'
					,titleCollapse:true
					<c:if test="${busquedaOrInclusion!='inclusion'}">,collapsible:true</c:if>
					,style:'margin-right:20px;margin-left:10px'
					,layoutConfig:{columns:2}
					,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:[{
							layout:'form'
							,items:[
									 txtContrato
									,txtNombre
									,txtApellido1
									,txtApellido2
									,txtNIF
							         <c:if test="${busquedaOrInclusion!='inclusion'}">
										,txtExpediente
										,txtAsunto
									</c:if>
									,mmRiesgoTotal.panel
									,mmSVencido.panel
									,mmDVencido.panel
									<c:if test="${busquedaOrInclusion=='inclusion'}">
									 	//,comboTieneRiesgo
									 </c:if>
								   ]
						},{
							layout:'form'
							,bodyStyle:'padding:5px;cellspacing:10px'
							,items:[
									comboEstadoContrato
									,comboEstadoFinanciero
									,comboJerarquia
									,comboZonas
									,comboTiposProducto
							  	 ]
						}
					]	

				}
			]
		,listeners:{	
			beforeExpand:function(){
				contratosGrid2.setHeight(125);
			}
			,beforeCollapse:function(){
				contratosGrid2.setHeight(435);
			}
		}
	});


	<c:if test="${busquedaOrInclusion=='inclusion'}">

			Ext.grid.CheckColumn = function(config){
			    Ext.apply(this, config);
			    if(!this.id){
			        this.id = Ext.id();
			    }
			    this.renderer = this.renderer.createDelegate(this);
			};

			Ext.grid.CheckColumn.prototype ={
			    init : function(grid){
			        this.grid = grid;
			        this.grid.on('render', function(){
			            var view = this.grid.getView();
			            view.mainBody.on('mousedown', this.onMouseDown, this);
			        }, this);
			    },

			    onMouseDown : function(e, t){
			        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
			            e.stopEvent();
			            var index = this.grid.getView().findRowIndex(t);
			            var record = this.grid.store.getAt(index);
			            record.set(this.dataIndex, !record.data[this.dataIndex]);
			        }
			    },
			
			    renderer : function(v, p, record){
			        p.css += ' x-grid3-check-col-td'; 
			        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
			};

			var checkColumn = new Ext.grid.CheckColumn({ 
		            header : '<s:message code="listadoContratos.listado.incluir" text="**Incluir" />'
		            ,dataIndex : 'incluir', width: 40});

	</c:if>


	var contrato = Ext.data.Record.create([
	     {name : 'id' }
		,{name : 'incluir' }
		,{name : 'codigoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProducto', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProductoEntidad', sortType:Ext.data.SortTypes.asTex }
		,{name : 'saldoVencido', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'diasIrregular', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'riesgo', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'titular', sortType:Ext.data.SortTypes.asTex }
		,{name : 'situacion', sortType:Ext.data.SortTypes.asTex}
		,{name : 'estadoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'estadoFinanciero', sortType:Ext.data.SortTypes.asTex }
	]);

	
	var contratosStore = page.getStore({
		flow : 'contratos/busquedaContratosData'
		,limit:limit
		,reader: new Ext.data.JsonReader({
	    	root : 'contratos'
	    	,totalProperty : 'total'
	    }, contrato)
		,remoteSort : true
	});

	

	var contratosCm = new Ext.grid.ColumnModel([
			 {	dataIndex: 'id', hidden:true, fixed:true }
			<c:if test="${busquedaOrInclusion=='inclusion'}">,checkColumn</c:if>
		    ,{	header: '<s:message code="listadoContratos.listado.contrato" text="**Num. Contrato"/>',sortable: false, width: 130, dataIndex: 'codigoContrato'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>',sortable: false , dataIndex: 'tipoProducto'}
			,{	header: '<s:message code="listadoContratos.listado.tipoEntidad" text="**Tipo Entidad"/>',sortable: false , dataIndex: 'tipoProductoEntidad'}
			,{	header: '<s:message code="listadoContratos.listado.dias" text="**D&iacute;as vencido"/>',sortable: false , width: 70, dataIndex: 'diasIrregular', align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.saldo" text="**Saldo vencido"/>',sortable: false , width: 70, dataIndex: 'saldoVencido', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos"/>',sortable: false , width: 70, dataIndex: 'riesgo', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.primertitular" text="**1er Titular"/>',sortable: false , width:130, dataIndex: 'titular'}
			,{	header: '<s:message code="listadoContratos.listado.situacion" text="**Situacion"/>',sortable: false , width:60, dataIndex: 'situacion'}
		    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>',sortable: false , width: 90, dataIndex: 'estadoContrato', hidden:true}
		    ,{	header: '<s:message code="listadoContratos.listado.estadoFinanciero" text="**Estado Financiero"/>',sortable: false , width: 90, dataIndex: 'estadoFinanciero'}
	]); 

	var pagingBar=fwk.ux.getPaging(contratosStore);
	pagingBar.hide();
	

	var cfg={
		title:'<s:message code="listadoContratos.listado.titulo" text="**Contratos"/>'
		,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_contratos'
		,height:100
		,bbar : [pagingBar]
		<app:test id="clientesGrid" addComa="true" />
       	<c:if test="${busquedaOrInclusion=='inclusion'}">,plugins:checkColumn</c:if>
		,resizable:true
		,dontResizeHeight:true
	};

	var contratosGrid2 = app.crearGrid(contratosStore,contratosCm,cfg);

	var contratosGridListener =	function(grid, rowIndex, e) {
		
	    	var rec = grid.getStore().getAt(rowIndex);
	    	if(rec.get('id')){
	    		var id = rec.get('id');
	    		var desc = rec.get('codigoContrato');
	    		app.abreContrato(id,desc);
		    	
	    	}
	    };
	    
	contratosGrid2.addListener('rowdblclick', contratosGridListener);

	var mainPanel = new Ext.Panel({
	    items : [{
					layout:'form'
					,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
					,defaults : {xtype:'panel' ,cellCls : 'vtop'}
					,border:false
					,items : [panelFiltros]
				  },{
					bodyStyle:'padding:5px;cellspacing:10px'
					,border:false
					,defaults : {xtype:'panel' ,cellCls : 'vtop'}
					,items : [contratosGrid2]
				  }]
	    ,autoHeight : true
	    ,border: false
    });

	mainPanel.contratosGrid2=contratosGrid2;
	return mainPanel;
}
