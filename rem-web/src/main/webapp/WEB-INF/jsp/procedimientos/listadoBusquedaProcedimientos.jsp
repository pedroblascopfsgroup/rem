<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var labelStyle1='';
	var labelStyle2='';
	//Código del procedimiento
	var codigoAsunto=app.creaNumber('codigo','<s:message code="procedimientos.busqueda.filtro.codigo" text="**Codigo Procedimiento" />','',{labelStyle:labelStyle1});
	//Tipo de procedimiento
	var dictTipoProcedimiento = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsTipoProcedimientoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoProcedimiento
	});
	
	var comboTipoProcedimiento = new Ext.form.ComboBox({
				store:optionsTipoProcedimientoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable:false
				,triggerAction: 'all'
				,labelStyle:labelStyle1
				,fieldLabel : '<s:message code="procedimientos.busqueda.filtro.tipoprocedimiento" text="**Tipo Procedimiento" />'
	});
	//Código del contrato (Entidad, Oficina y número de contrato) del procedimiento
	var codContrato = app.creaText('codContrato', '<s:message code="procedimientos.busqueda.filtro.numContrato" text="**Num. Contrato" />','',{width : 80,labelStyle:labelStyle1});
	//Tipo producto del contrato del procedimiento
	var dictTipoProducto = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

	//store generico de combo diccionario
	var optionsTipoProductoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoProducto
	});
	
	var comboTipoProducto = new Ext.form.ComboBox({
				store:optionsTipoProductoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,editable:false
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:labelStyle1
				,fieldLabel : '<s:message code="procedimientos.listado.filtro.tipoproducto" text="**Tipo Producto" />'
	});
	
	var mmSRexuperacion = app.creaMinMaxMoneda('<s:message code="procedimientos.listado.filtro.saldorecuperacion" text="**S. Recuperacion" />', 'srecuperacion');
	
	//Nombre asunto en el que está incluido el procedimiento.
	var nombreAsunto = app.creaText('nombreAsunto','<s:message code="procedimientos.busqueda.filtro.nombreasunto" text="**Nombre Asunto" />','',{labelStyle:labelStyle2});
	//Despacho asignado al asunto en el que está incluido el procedimiento.
	var dictDespachos = <app:dict value="${despachos}" />;

	//store generico de combo diccionario
	var optionsDespachosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictDespachos
	});
	
	var comboDespachos = new Ext.form.ComboBox({
				store:optionsDespachosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'---'
				,editable: false
				,triggerAction: 'all'
				,labelStyle:labelStyle2
				,fieldLabel : '<s:message code="procedimientos.busqueda.filtro.despacho" text="**Despacho"/>'
	});	
	//Gestor del despacho asignado al asunto en el que está incluido el procedimiento
	var gestores={diccionario:[]};
	var comboGestor = app.creaDblSelect(gestores,'<s:message code="procedimientos.busqueda.filtro.gestor" text="**Gestor" />',{labelStyle:labelStyle2})
	
	
	
	var zonas=<app:dict value="${zonas}" />;
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name : 'jerarquia', fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});

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
	
//    recargarComboZonas();
    comboJerarquia.on('select',recargarComboZonas);
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas});
	
	
	
	var buscarFunc=function(){
		
	};
	var btnReset = app.crearBotonResetCampos([
		codigoAsunto
		,comboTipoProcedimiento
		,codContrato	
		,comboTipoProducto
		,nombreAsunto
		,comboDespachos
		,comboGestor
		,comboZonas
		,comboJerarquia
		
	]);
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	var panelFiltros=new Ext.Panel({
		autoHeight:true
		,title : '<s:message code="procedimientos.busqueda.filtros" text="**Filtro de Procedimientos" />'
		,layout:'table'
		,layoutConfig:{columns:2}
		//,border:false
		,titleCollapse : true
		,collapsible:true
		,tbar : [btnBuscar,btnReset, '->', app.crearBotonAyuda()]
		,style:'margin-right:20px;margin-left:10px'
		,bodyStyle:'padding:2px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				,cellCls : 'vtop'
				//,bodyStyle:'padding:2px;margin-right:5px'
				,width:300
				,autoWidth:true
				,items:[
					codigoAsunto
					,comboTipoProcedimiento
					,codContrato
					,comboTipoProducto
					,mmSRexuperacion.panel
				]
			},{
				layout:'form'
				,cellCls : 'vtop'
				//,width:400
				,bodyStyle:'padding:5px;cellspacing:10px'
				//,bodyStyle:'padding:2px'
				,items:[
					nombreAsunto	
					,comboDespachos
					,comboGestor
					,comboJerarquia
					,comboZonas
				]
			}
		]
		,listeners:{	
			beforeExpand:function(){
				procedimientosGrid.setHeight(300);
			}
			,beforeCollapse:function(){
				procedimientosGrid.setHeight(500);
			}
		}
	});
	var procedimientos = {procedimientos :[	
		{codigo: '1', tipoprocedimiento:'Amistoso',estado:'Propuesto',saldorecuperacion:'25000',contrato:'4569874',tipoproducto:'Cuenta Corriente',tiporeclamacion:'Total',saldovencido:'1000',saldonovencido:'500',recuperacion:'80%',meses:'4',demandados:'Juan Garriguez'}
		,{demandados:'Pepe Gimeno'}
		,{codigo: '2',tipoprocedimiento:'Trámite Subasta',estado:'En Recurso',saldorecuperacion:'251000',contrato:'9845621',tipoproducto:'T. Credito',tiporeclamacion:'Vencida',saldovencido:'1000',saldonovencido:'500',recuperacion:'50%',meses:'10',demandados:'Bosnjak Juan Pablo'}
		,{codigo: '3',tipoprocedimiento:'Hipotecario',estado:'Derivado',saldorecuperacion:'2000',contrato:'65478654',tipoproducto:'Hipoteca',tiporeclamacion:'Vencida',saldovencido:'1800',saldonovencido:'600',recuperacion:'90%',meses:'20',demandados:'Anibal Ibarra'}
		
		]};
	
	var procedimientosStore = new Ext.data.JsonStore({
		data : procedimientos
		,root : 'procedimientos'
		,fields : ['codigo','tipoprocedimiento','estado','contrato','tipoproducto','asunto'
					,'tiporeclamacion','saldonovencido','saldovencido','saldorecuperacion','recuperacion','meses','demandados']
	});

	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimientos.listado.codigo" text="**Codigo"/>', dataIndex : 'codigo' }
		,{header : '<s:message code="procedimientos.listado.tipoprocedimiento" text="**tipo procedimiento"/>', dataIndex : 'tipoprocedimiento' }
		,{header : '<s:message code="procedimientos.listado.estado" text="**Estado"/>', dataIndex : 'estado' }
		,{header : '<s:message code="procedimientos.listado.contrato" text="**Contrato"/>', dataIndex : 'contrato' }
		,{header : '<s:message code="procedimientos.listado.asunto" text="**Asunto"/>', dataIndex : 'asunto' }
		,{header : '<s:message code="procedimientos.listado.tipoproducto" text="**Tipo Producto"/>', dataIndex : 'tipoproducto' }
		,{header : '<s:message code="procedimientos.listado.tiporeclamacion" text="**tipo reclamacion"/>', dataIndex : 'tiporeclamacion' }
		,{header : '<s:message code="procedimientos.listado.saldovencido" text="**P. Vencido"/>', dataIndex : 'saldovencido' }
		,{header : '<s:message code="procedimientos.listado.saldonovencido" text="**P. No Vencido"/>', dataIndex : 'saldonovencido' }
		,{header : '<s:message code="procedimientos.listado.saldorecuperacion" text="**Saldo Recuperacion %"/>', dataIndex : 'saldorecuperacion' }
		,{header : '<s:message code="procedimientos.listado.recuperacion" text="**recuperacion %"/>', dataIndex : 'recuperacion' }
		,{header : '<s:message code="procedimientos.listado.meses" text="**Meses recuperacion"/>', dataIndex : 'meses' }
		,{header : '<s:message code="procedimientos.listado.demandados" text="**Demandados"/>', dataIndex : 'demandados' }
	]);
	
	var procedimientosGrid = app.crearGrid(procedimientosStore,procedimientosCm,{
		title:'<s:message code="asunto.tabcabecera.grid.titulo" text="**Procedimientos"/>'
		//,width : 700
		,iconCls:'icon_procedimiento'
		,cls:'cursor_pointer'
		,style:'padding:10px'
		,height : 250
	});
	
	procedimientosGrid.on('rowdblclick',function(){ 
		app.openTab("Procedimiento","fase2/procedimientos/consultaProcedimiento",{},{iconCls:'icon_procedimiento'})
	});
	var panel = new Ext.Panel({
		//title:'<s:message code="asunto.tabcabecera.titulo" text="**Cabecera"/>'
		autoHeight:true
		//,bodyStyle:'padding: 10px'
		,items:[panelFiltros,procedimientosGrid	]
		,border:false
	});
	
	page.add(panel);
	
</fwk:page>