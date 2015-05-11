<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page>
	var limit=25;	
	var chkPrimerTitular = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.primertitular" text="**Primer Titular" />'
		,name:'primertitular'
		<app:test id="chkPrimerTitular" addComa="true" />
	});	
	var mmRiesgoTotal = app.creaMinMax('<s:message code="menu.clientes.listado.filtro.riesgototal" text="**Riesgo Total" />', 'riesgo');
	var mmSVencido = app.creaMinMax('<s:message code="menu.clientes.listado.filtro.svencido" text="**S. Vencido" />', 'svencido');
	var mmDVencido = app.creaMinMax('<s:message code="menu.clientes.listado.filtro.dvencido" text="**D&iacute;as Vencido" />', 'dvencido');

	//diccionario de estados
	var estados=<app:dict value="${estados}" />;

	//diccionario de segmentos
	var segmentos=<app:dict value="${segmentos}" />;

	//diccionario de zonas
	var zonas=<app:dict value="${zonas}" />;

	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});
	              
	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;


    var comboEstados = app.creaDblSelect(estados,'<s:message code="menu.clientes.listado.filtro.situacion" text="**Situacion" />', {<app:test id="comboEstados" />})
    
    
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
    
    var comboSegmentos = app.creaDblSelect(segmentos, '<s:message code="menu.clientes.listado.filtro.segmento" text="**Segmento" />');
    var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas});

    var comboTipoPersona = app.creaCombo({data:tiposPersona, name : 'tipopersona', fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />});
    

	var Cliente = Ext.data.Record.create([
		{name:'id'}
		,{name : 'nombre'}
		,{name : 'apellido1'}
		,{name : 'apellido2'}
		,{name : 'segmento'}
		,{name : 'tipo'}
		,{name : 'codigo'}
		,{name : 'direccion'}
		,{name : 'telefono'}
		,{name : 'nif'}
		,{name : 'tipoPersona'}
		,{name : 'totalDeuda',type: 'float'}
		,{name : 'totalSaldo',type: 'float'}
		,{name : 'posAntigua'}
		,{name : 'contratos'}
		,{name : 'situacion'}
	]);
	//utilizamos implicitamente el mismo flow que ha cargado el grid, si no, le pasaríamos flow : 'admin/listadoUsuarios'
	var clientesStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,loading:false
		,flow:'clientes/listadoClientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'personas'
	    	,totalProperty : 'total'
	    }, Cliente)
	});
	
	
	//si entramos por gestión de vencidos, el combo se seleccionará con el valor de gestión de vencidos automáticamente, 
	//y la carga inicial será con este filtro
	if ('${isGestionVencidos}'=='true'){
		comboEstados.on('render', function(){	
			this.setValue('GV');	
		});
		chkPrimerTitular.on('render', function(){	
			this.setValue(true);	
		});
		
		clientesStore.webflow({	situacion:'GV', isPrimerTitContratoPase:true });
	}else{
		//NO se debe buscar al entrar al caso de uso
		//clientesStore.webflow();
	}
	
	var myKeyListener = function(e){
		//Ext.Msg.alert("AA","EE");
		if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      			buscarFunc();
  		}
	}
	var filtroNombre=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.nombre" text="**Nombre" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target,e){
					//Ext.Msg.alert("AA","EE");
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});
	var filtroApellido=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.apellido1" text="**Apellido" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
				if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      				buscarFunc();
  				}
  			}
		}
	});
	var filtroSituac=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.situacion" text="**Situacion" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});
	/*var filtroNif=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.nif" text="**NIF" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
		//,vtype:'numeric'
	});*/
	var filtroNif=new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.nif" text="**NIF" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
	});
	var filtroCodCli=new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.codigoCliente" text="**Codigo Cliente" />'
		,enableKeyEvents: true
		,listeners : {
			keypress : function(target, e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
	});
	 
	var filtroContrato =new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:10 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
	});
	
	var validarForm = function(){
		if (filtroNombre.getValue().trim() != ''){
			return true;
		}
		if (filtroApellido.getValue() != '' ){
			return true;
		}
		if (comboSegmentos.getValue() != '' ){
			return true;
		}
		if (comboZonas.getValue() != '' ){
			return true;
		}
		if (comboEstados.getValue() != '' ){
			return true;
		}
		if (filtroNif.getValue() != '' ){
			return true;
		}
		if (chkPrimerTitular.getValue() != '' ){
			return true;
		}
		if (comboJerarquia.getValue() != '' ){
			return true;
		}
		if (filtroCodCli.getValue() != '' ){
			return true;
		}
		if (filtroContrato.getValue() != '' ){
			return true;
		}
		if (comboTipoPersona.getValue() != '' ){
			return true;
		}
		if (mmRiesgoTotal.min.getValue() != '' ){
			return true;
		}
		if (mmRiesgoTotal.max.getValue() != '' ){
			return true;
		}
		if (mmSVencido.min.getValue() != '' ){
			return true;
		}
		if (mmSVencido.max.getValue() != '' ){
			return true;
		}
		if (mmDVencido.min.getValue() != '' ){
			return true;
		}
		if (mmDVencido.max.getValue() != '' ){
			return true;
		}	
		return false;
			
	}
	
	
	var buscarFunc = function(){
		if (validarForm()){
			clientesStore.webflow({
				//start:0
				nombre:filtroNombre.getValue()
				//,limit:limit
				,apellido1:filtroApellido.getValue()
				,segmento:comboSegmentos.getValue()
				,codigoZona:comboZonas.getValue()
				,situacion:comboEstados.getValue()
				,nif:filtroNif.getValue()
				,isPrimerTitContratoPase:chkPrimerTitular.getValue()
				,jerarquia:comboJerarquia.getValue()
				,codigoEntidad:filtroCodCli.getValue()
				,tipoPersona:comboTipoPersona.getValue()
				,minRiesgoTotal:mmRiesgoTotal.min.getValue()
				,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
				,minSaldoVencido:mmSVencido.min.getValue()
				,maxSaldoVencido:mmSVencido.max.getValue()
				,minDiasVencido:mmDVencido.min.getValue()
				,maxDiasVencido:mmDVencido.max.getValue()
			});
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}
	};
	
//	var exportarFunc = function(){
//		page.webflow({
//				start:0
//				,flow:'exportClientesData'
//				,params : {
//				nombre:filtroNombre.getValue()
//				,apellido1:filtroApellido.getValue()
//				,segmento:comboSegmentos.getValue()
//				,codigoZonas:comboZonas.getValue()
//				,situacion:comboEstados.getValue()
//				,nif:filtroNif.getValue()
//				,jerarquia:comboJerarquia.getValue()
//				,codigoEntidad:filtroCodCli.getValue()
//				,tipoPersona:comboTipoPersona.getValue()
//				,minRiesgoTotal:mmRiesgoTotal.min.getValue()
//				,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
//				,minSaldoVencido:mmSVencido.min.getValue()
//				,maxSaldoVencido:mmSVencido.max.getValue()
//				,minDiasVencido:mmDVencido.min.getValue()
//				,maxDiasVencido:mmDVencido.max.getValue()
//				}
//			});
//	};

	var exportarFunc = function() {
		// window.open("test/reportes.htm?reporte=test/reporteActa");
		app.openBrowserWindow(
			"exportClientesData",
			{
				nombre:filtroNombre.getValue()
				,apellido1:filtroApellido.getValue()
				,segmento:comboSegmentos.getValue()
				,codigoZonas:comboZonas.getValue()
				,situacion:comboEstados.getValue()
				,nif:filtroNif.getValue()
				,jerarquia:comboJerarquia.getValue()
				,codigoEntidad:filtroCodCli.getValue()
				,tipoPersona:comboTipoPersona.getValue()
				,minRiesgoTotal:mmRiesgoTotal.min.getValue()
				,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
				,minSaldoVencido:mmSVencido.min.getValue()
				,maxSaldoVencido:mmSVencido.max.getValue()
				,minDiasVencido:mmDVencido.min.getValue()
				,maxDiasVencido:mmDVencido.max.getValue()
			}
		)
	};
	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnReset = app.crearBotonResetCampos([
		filtroNombre
		,filtroApellido
		,comboSegmentos
		,comboEstados
		,filtroNif
		,comboJerarquia
		,comboZonas
		,filtroCodCli
		,comboTipoPersona
		,mmRiesgoTotal.min
		,mmRiesgoTotal.max
		,mmSVencido.min
		,mmSVencido.max
		,mmDVencido.min
		,mmDVencido.max
		,chkPrimerTitular
		,filtroContrato
	]);
	
	var btnExportar=new Ext.Button({
		text:'<s:message code="menu.clientes.listado.filtro.exportar" text="**exportar" />'
		,iconCls:'icon_exportar_csv'
		,handler : exportarFunc
	});
	var muestraAyuda=function(){
		//app.openUrl("Ayuda",'ayuda/Tareas_Pendientes.html');
		//window.open("/ayuda/Tareas_Pendientes.html");
	}
	var filtroForm = new Ext.Panel({
		title : '<s:message code="menu.clientes.listado.filtro.filtrodeclientes" text="**Filtro de clientes" />'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {
			columns:3
		}
		//,autoWidth:true
		//,border: false
		,style:'margin-right:20px;margin-left:10px'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				 ,items:[filtroCodCli, filtroNombre,filtroApellido,filtroNif,comboTipoPersona, mmRiesgoTotal.panel, mmSVencido.panel, mmDVencido.panel,chkPrimerTitular,filtroContrato]
			},{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[ comboSegmentos,comboEstados, comboJerarquia, comboZonas]
			} 
			,{
				items : [ {html :'&nbsp;',border:false},{html :'&nbsp;',border:false}]
			}
		]
		,tbar : [btnBuscar, btnReset, btnExportar, '->', app.crearBotonAyuda(muestraAyuda)]
		,listeners:{	
			beforeExpand:function(){
				grid.setHeight(200);
				
			}
			,beforeCollapse:function(){
				grid.setHeight(450);
			}
		}
	});
	
	var clientesCm=new Ext.grid.ColumnModel([
			{header : '<s:message code="menu.clientes.listado.lista.nombre" text="**Nombre" />'
			, dataIndex : 'nombre' ,sortable:true,width:100}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido1" text="**Apellido1" />'
			, dataIndex : 'apellido1',width:100}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido2" text="**Apellido2" />'
			, dataIndex : 'apellido2',width:100}
			,{header : '<s:message code="menu.clientes.listado.lista.codigo" text="**Codigo" />'
			, dataIndex : 'codigo',width:70,align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.direccion" text="**Direccion" />'
			, dataIndex : 'direccion',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.nif" text="**CIF/NIF" />'
			, dataIndex : 'nif',width:80}
			,{header : '<s:message code="menu.clientes.listado.lista.segmento" text="**Segmento" />'
			, dataIndex : 'segmento',width:60}
			,{header : '<s:message code="menu.clientes.listado.lista.tipo" text="**Tipo" />'
			, dataIndex : 'tipo',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.telefono" text="**Telefono" />'
			, dataIndex : 'telefono',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.totaldeuda" text="**Total Deuda Irregular" />'
			, dataIndex : 'totalDeuda',renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.totalsaldo" text="**Total Saldo" />'
			, dataIndex : 'totalSaldo', renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos" />'
			, dataIndex : 'contratos',width:50, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.posantigua" text="**Posicion antigua" />'
			, dataIndex : 'posAntigua',width:42, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.situacion" text="**Situaci&oacute;n" />'
			, dataIndex : 'situacion',width:120}
			,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}

		]);

	var pagingBar=fwk.ux.getPaging(clientesStore);
	g_paging=pagingBar;
	var cfg={
		title : '<s:message code="menu.clientes.listado.lista.title" text="**Clientes" />'
		,stripeRows:true
		,bbar : [  pagingBar ]
		,height:208
		,resizable:true
		,dontResizeHeight:true
		,style:'padding: 10px'
		<app:test id="clientesGrid" addComa="true" />
	};
	cfg.cls='cursor_pointer';
	
	var grid=app.crearGrid(clientesStore,clientesCm,cfg);
	
	grid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_cliente=rec.get('apellido1')+ " "+rec.get('apellido2') + ", "+rec.get('nombre');
    	//app.abreCliente(rec.get('id'), nombre_cliente);
		var id=rec.get('id');
		app.openTab(nombre_cliente, 'fase2/clientes/consultaCliente_fase2', {id : id}, {id:'cliente'+id,iconCls:'icon_cliente'} );
    });
    
    var compuesto = new Ext.Panel({
	    items : [
	    	filtroForm
			,grid
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	
	//añadimos al padre y hacemos el layout
	page.add(compuesto);   

</fwk:page>
