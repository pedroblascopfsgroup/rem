<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var limit=25;
	var j=0;
    var parametrosTab = new Array();
    var tabDatos=false;
    var tabRiesgos=false;
    var tabJerarquia=false;
	
	//envuelve una lista de controles en un fieldSet
	var creaFieldSet = function(items, config){
		var cfg={
			autoHeight:true
			,labelStyle:'font-weight:bolder'
			,border : false
			,items:items
		};
		var ft = new Ext.form.FieldSet(cfg);
		return ft;
	};
	//diccionarios
	var segmentos = <app:dict value="${segmentos}" />;
	var situaciones = <app:dict value="${situacion}" />;
	var zonas = <app:dict value="${zonas}" />;
	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;
	var comites = <app:dict value="${comites}" blankElement="true" blankElementValue="" blankElementText="---" />;


	var comboSituacion = app.creaDblSelect(situaciones
                              ,'<s:message code="expedientes.listado.situacion" text="**Situacion" />'
                              ,{<app:test id="comboSituacion" />});
    
	var mmRiesgoTotal = app.creaMinMax('<s:message code="expedientes.listado.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 60});
	var mmSVencido    = app.creaMinMax('<s:message code="expedientes.listado.sVencido" text="**S. Vencido" />', 'svencido',{width : 60});
	
	
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="expedientes.listado.codigo" text="**Codigo" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
		//,vtype:'numeric'
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER && txtCodExpediente.getValue() > 0) {
      					buscarFunc();
  					}
  				}
		}
		<app:test id="campoCodigoExpediente" addComa="true"/>
	});

	var txtDescripcion=new Ext.form.TextField({
		fieldLabel:'<s:message code="expedientes.listado.descripcion" text="**Descripcion" />'
		,enableKeyEvents: true
		,style : 'margin:0px'
		,listeners : {
			keypress : function(target,e){
					//Ext.Msg.alert("AA","EE");
					if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      					buscarFunc();
  					}
  				}
		}
	});

    var gestion = <app:dict value="${gestion}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboGestion = app.creaCombo({data:gestion, 
    									triggerAction: 'all', 
    									value:gestion.diccionario[0].codigo, 
    									name : 'codigoGestion', 
    									fieldLabel : '<s:message code="expedientes.listado.gestion" text="**Gestion" />'
    									<app:test id="idComboGestion" addComa="true"/>	
    								});

	
    var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
    
    var comboJerarquia = app.creaCombo({data:jerarquia, 
    									triggerAction: 'all', 
    									value:jerarquia.diccionario[0].id, 
    									name : 'jerarquia', 
    									fieldLabel : '<s:message code="expedientes.listado.jerarquia" text="**Jerarquia" />'
    									<app:test id="idComboJerarquia" addComa="true"/>	
    								});

	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
	</c:if> 
	
	var listadoCodigoZonas = [];
	
	comboJerarquia.on('select',function(){
		listadoCodigoZonas = [];
		if(comboJerarquia.value != '') {
			comboZonas.setDisabled(false);
			optionsZonasStore.setBaseParam('idJerarquia', comboJerarquia.getValue());
		}else{
			comboZonas.setDisabled(true);
		}
	});
	
	var codZonaSel='';
	var desZonaSel='';
	
	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	//Template para el combo de zonas
    var zonasTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{descripcion}&nbsp;&nbsp;&nbsp;</p><p>{codigo}</p>',
        '</div></tpl>'
    );
    
    
    var optionsZonasStore = page.getStore({
	       flow: 'mejexpediente/getZonasInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
    
    //Combo de zonas
    var comboZonas = new Ext.form.ComboBox({
        name: 'comboZonas'
        ,disabled:true 
        ,allowBlank:true
        ,store:optionsZonasStore
        ,width:240
        ,fieldLabel: '<s:message code="expedientes.listado.centros" text="**Centros"/>'
        ,tpl: zonasTemplate  
        ,forceSelection:true
        ,style:'padding:0px;margin:0px;'
        ,enableKeyEvents: true
        ,typeAhead: false
        ,hideTrigger:true     
        ,minChars: 2 
        ,hidden:false
        ,maxLength:256 
        ,itemSelector: 'div.search-item'
        ,loadingText: '<s:message code="app.buscando" text="**Buscando..."/>'
        ,onSelect: function(record) {
        	btnIncluir.setDisabled(false);
        	codZonaSel=record.data.codigo;
        	desZonaSel=record.data.descripcion;
         }
    });	
    
    var recordZona = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigoZona'},
		{name: 'descripcionZona'}
	]);
    
    
   	var zonasStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordZona)
	});
    
    
    var zonasCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="expedientes.listado.centros.codigo" text="**Código" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="expedientes.listado.centros.nombre" text="**Nombre" />', dataIndex : 'descripcionZona',sortable:false, hidden:false, width:200}
	]);
	
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="expedientes.listado.centros" text="**Centros" />'
	    ,cm: zonasCM
	    ,store: zonasStore
	    ,width: 300
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});

	var incluirZona = function() {
	    var zonaAInsertar = zonasGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoZona: codZonaSel,
   			descripcionZona: desZonaSel
   		});
		zonasStore.insert(0, p);
		listadoCodigoZonas.push(codZonaSel);
	}

	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,handler : function(){
			incluirZona();
			codZonaSel='';
   			desZonaSel='';
   			btnIncluir.setDisabled(true);
			comboZonas.focus();
		}
	});

	var zonaAExcluir = -1;
	var codZonaExcluir = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codZonaExcluir = grid.selModel.selections.get(0).data.codigoZona;
   		zonaAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});

	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,handler : function(){
			if (zonaAExcluir >= 0) {
				zonasStore.removeAt(zonaAExcluir);
				listadoCodigoZonas.remove(codZonaExcluir);
			}
			zonaAExcluir = -1;
	   		btnExcluir.setDisabled(true);
		}
	});

	var estados = <app:dict value="${estado}" blankElement="true" blankElementValue="" blankElementText="---" />;

	//var comboSegmentos = app.creaDblSelect(segmentos, '<s:message code="menu.clientes.listado.filtro.segmento" text="**Segmento" />');

	var comboTipoPersona = app.creaCombo({data:tiposPersona, name : 'tipopersona', fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />,width : 160});

	var comboComite = app.creaCombo({data:comites, name : 'comites', fieldLabel : '<s:message code="expedientes.listado.comite" text="**Comite" />' <app:test id="comboComite" addComa="true" />,width : 160});


	//store generico de combo diccionario
	var optionsEstadoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : estados
	});
	
	var comboEstado = new Ext.form.ComboBox({
				store:optionsEstadoStore
				<app:test id="comboEstado" addComa="true" />
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,style : 'margin:0px'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="expedientes.listado.estado" text="**Estado" />'
	});
	 
	var filtroContrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtrocontrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,maxLength:50
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"50", autocomplete: "off"} 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
	});

	Ext.apply(Ext.form.VTypes, {
		numeric: function(val, field) {
			if(app.validate.validateInteger(val)) {
				return true;
			}
			field.focus();
			return false;
		}, numericText: '<s:message code="error.campoNumerico" text="**El campo debe ser un número" />'
	});

	var Expediente = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'fechacrear',type:'string'}
		,{name:'origen'}
		,{name:'estadoItinerario', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'oficina', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'estadoExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'volumenRiesgo', sortType:Ext.data.SortTypes.asFloat}
		,{name:'volumenRiesgoVencido', sortType:Ext.data.SortTypes.asFloat}
		,{name:'gestorActual', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name:'fechaVencimiento',type:'string'}
		,{name:'comite', type:'string', sortType:Ext.data.SortTypes.asText}	
		,{name:'tipoExpediente', type:'string', sortType:Ext.data.SortTypes.asText}	
		,{name:'itinerario'}
	]);

	var expStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'expedientes/listadoExpedientesDataDinamico'
		,reader: new Ext.data.JsonReader({
	    	root : 'expedientes'
	    	,totalProperty : 'total'
	    }, Expediente)
		,remoteSort : true
	});
	
	 expStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	
	//Hace la búsqueda inicial
	//expStore.webflow();
	
	var validarEmptyFormDatos = function(){
		if (tabDatos) {
			if (txtCodExpediente.getValue() != '' && app.validate.validateInteger(txtCodExpediente.getValue())){
				return true;
			}
			if (comboEstado.getValue() != '' ){
				return true;
			}
			if (comboSituacion.getValue() != '' ){
				return true;
			}
			if (txtDescripcion.getValue() != '' ){
				return true;
			}
			if (comboTipoPersona.getValue() != '' ){
				return true;
			}
			if (comboComite.getValue() != '' ){
				return true;
			}
			if (comboGestion.getValue() != ''){
				return true;
			}
		}
		return false;
	};
	
	var validarEmptyFormRiesgos = function() {
		if (tabRiesgos) {			
			if (!(mmRiesgoTotal.min.getValue() === '' )){
				return true;
			}
			if (!(mmRiesgoTotal.max.getValue() === '' )){
				return true;
			}
			if (!(mmSVencido.min.getValue() === '' )){
				return true;
			}
			if (!(mmSVencido.max.getValue() === '' )){
				return true;
			}
			if (!(filtroContrato.getValue() === '')){
				return true;
			}
		}			
		return false;			
	};	
	
	var validarEmptyFormJerarquia = function() {
		if (tabJerarquia) {
			if (comboJerarquia.getValue() != '' ){
				return true;
			}
			if (listadoCodigoZonas.length > 0 ){
				return true;
			}			
		}			
		return false;			
	};
		
	var validaMinMax = function(){
		if (tabRiesgos) {
			if (!app.validaValoresDblText(mmRiesgoTotal)){
				return false;
			}
			if (!app.validaValoresDblText(mmSVencido)){
				return false;
			}
		}
		return true;
	}

    var getParametrosDatos = function() {
    	if (tabDatos) {
	    	if(txtCodExpediente.getValue()=='undefined' || !txtCodExpediente.getValue()){
				txtCodExpediente.setValue('');
			}
			if(txtDescripcion.getValue()=='undefined' || !txtDescripcion.getValue()){
				txtDescripcion.setValue('');
			}
			if(comboTipoPersona.getValue()=='undefined' || !comboTipoPersona.getValue()){
				comboTipoPersona.setValue('');
			}
			if(comboEstado.getValue()=='undefined' || !comboEstado.getValue()){
				comboEstado.setValue('');
			}
			if(comboSituacion.getValue()=='undefined' || !comboSituacion.getValue()){
				comboSituacion.setValue('');
			}
			if(comboGestion.getValue()=='undefined' || !comboGestion.getValue()){
				comboGestion.setValue('');
			}
			if(comboComite.getValue()=='undefined' || !comboComite.getValue()){
				comboComite.setValue('');
			}
			
		}
		
		var param = new Object();
   		if (tabDatos) {
	       	param.codigo=txtCodExpediente.getValue();
			param.descripcion=txtDescripcion.getValue();
			param.idEstado=comboEstado.getValue();
			param.codigoSituacion=comboSituacion.getValue();
			param.codigoGestion=comboGestion.getValue();
			param.tipoPersona=comboTipoPersona.getValue();
			param.comiteBusqueda=comboComite.getValue();
		}
		param.busqueda=true;
		
		return param;
	}
	
	var getParametrosRiesgos = function() {  
		
		if (tabRiesgos) {
			if(mmRiesgoTotal.min.getValue()=='undefined' || !mmRiesgoTotal.min.getValue()){
				mmRiesgoTotal.min.setValue('');
			}
			if(mmRiesgoTotal.max.getValue()=='undefined' || !mmRiesgoTotal.max.getValue()){
				mmRiesgoTotal.max.setValue('');
			}
			if(mmSVencido.min.getValue()=='undefined' || !mmSVencido.min.getValue()){
				mmSVencido.min.setValue('');
			}
			if(mmSVencido.max.getValue()=='undefined' || !mmSVencido.max.getValue()){
				mmSVencido.max.setValue('');
			}
			if(filtroContrato.getValue()=='undefined' || !filtroContrato.getValue()){
				filtroContrato.setValue('');
			}
		}
		var param = new Object();   		
		if (tabRiesgos) {
			param.minRiesgoTotal=mmRiesgoTotal.min.getValue();
			param.maxRiesgoTotal=mmRiesgoTotal.max.getValue();
			param.minSaldoVencido=mmSVencido.min.getValue();
			param.maxSaldoVencido=mmSVencido.max.getValue();
			param.nroContrato=filtroContrato.getValue();
		}
		param.busqueda=true;
		
		return param;
	};
		
	var getParametrosJerarquia = function() {  
		
		if (tabJerarquia) {		
			if (comboZonas.getValue()=='undefined' || !comboZonas.getValue()){
				comboZonas.setValue('');
			}
			if(filtroContrato.getValue()=='undefined' || !filtroContrato.getValue()){
				filtroContrato.setValue('');
			}
		}		
   		var param = new Object();   		
		if (tabJerarquia) {
			param.codigoEntidad=comboJerarquia.getValue();
			param.codigoZona=listadoCodigoZonas.toString();
		}
		param.busqueda=true;
		
		return param;
	};

	var buscarFunc = function(excel) {
      	var pars = panelFiltros.getForm().getFieldValues(true);
      	var parametros = new Array();
        var hayParametros = false;
        var anadirParametros = function(newParametros) {
        	for (var i in newParametros) {
				hayParametros = true;
				parametros[i] = newParametros[i];
            	if(i == 'params'){
                 	parametrosTab[j] = newParametros[i];
                  	j++;
            	}
        	}
    };
          
        var error=false;
          
        var hayError = function() {
              error = true;
        };
          
        for (var tab=0;tab < filtroTabPanel.items.length && error==false;tab++) {
          	 filtroTabPanel.items.get(tab).fireEvent('getParametros', anadirParametros, hayError);
        }
        
        if (hayParametros) {
        	if (!validaMinMax()) {
        		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
        	} else {
	          	var paramAux='';
				var y = 0;
			
				for(var i in parametrosTab){
					paramAux = paramAux+'_param_'+parametrosTab[i];	
				}
				parametros['params'] = paramAux;
				if (excel==1) {
					var flow='expedientes/listadoExpedientesExcelDataDinamico';
                    
                    parametros['REPORT_NAME'] = 'busqueda.xls';
                    app.openBrowserWindow(flow,parametros);
				} else {
					panelFiltros.collapse(true);
		        	botonesTabla.show();
					panelFiltros.getTopToolbar().setDisabled(true); 
					expStore.webflow(parametros);
				} 
				parametrosTab = new Array();            
            }
        } else {
            Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel" />','<s:message	code="expedientes.listado.criterios" />');
        }
    };
    			
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;

	var tabsBusqueda = <app:includeArray files="${tabsBusqueda}" />
	
	//Agrego los filtros al panel
	var filtrosTabDatosExpediente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.expedientes.busqueda.datosGenerales" text="**Datos del expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtCodExpediente,txtDescripcion,comboEstado,comboTipoPersona]
				},{
					layout:'form'
					,items: [comboComite,comboGestion,comboSituacion]
				}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
				if (validarEmptyFormDatos()){
					anadirParametros(getParametrosDatos());
				}
			}			
			,limpiar: function() {
    		   app.resetCampos([      
    		   			txtCodExpediente
    		           ,txtDescripcion
    		           ,comboEstado
    		           ,comboTipoPersona
    		           ,comboComite
    		           ,comboGestion
    		           ,comboSituacion
	           ]); 
    		}
		}
	});
	
	filtrosTabDatosExpediente.on('activate',function(){
		tabDatos=true;
		tabJerarquia=false;
		tabRiesgos=false;
	});
	
//Agrego los filtros al panel
	var filtrosTabRiesgos = new Ext.Panel({
		title: '<s:message code="plugin.mejoras.expedientes.busqueda.riesgos" text="**Riesgos" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [mmRiesgoTotal.panel,mmSVencido.panel, filtroContrato]
				}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
				if (validarEmptyFormRiesgos()){
					anadirParametros(getParametrosRiesgos());
				}
			}			
			,limpiar: function() {
    		   app.resetCampos([      
						mmRiesgoTotal.min,
						mmRiesgoTotal.max,
						mmSVencido.min,
						mmSVencido.max,
						filtroContrato
	           ]); 
	           zonasStore.removeAll();
    		}
		}
	});
	
	filtrosTabRiesgos.on('activate',function(){
		tabJerarquia=false;
		tabRiesgos=true;
		tabDatos=false;
	});
	
	var filtrosTabJerarquia = new Ext.Panel({
		title: '<s:message code="expedientes.listado.jerarquia" text="**Jerarquia" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboJerarquia, comboZonas]
				},{
					layout:'form'
					,items: [btnIncluir, btnExcluir]
				},{
					layout:'form'
					,items: [zonasGrid]
				}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
				if (validarEmptyFormJerarquia()){
					anadirParametros(getParametrosJerarquia());
				}
			}			
			,limpiar: function() {
    		   app.resetCampos([      
						comboJerarquia,
						comboZonas
	           ]); 
	           zonasStore.removeAll();
    		}
		}
	});
	
	filtrosTabJerarquia.on('activate',function(){
		tabJerarquia=true;
		tabRiesgos=false;
		tabDatos=false;
	});

	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosExpediente, filtrosTabRiesgos, filtrosTabJerarquia]
		,id:'idTabFiltrosContrato'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});
	
	filtroTabPanel.add(tabsBusqueda);
	
	
	 var panelFiltros =  new Ext.FormPanel({
          title : '<s:message code="expedientes.listado.filtros" text="**Filtro de Expedientes" />'
		  ,defaults : {xtype:'panel' ,cellCls : 'vtop'}
          ,tbar : [buttonsL,'->', buttonsR, app.crearBotonAyuda()]
		  ,bodyStyle:'cellspacing:10px;'
          ,items:filtroTabPanel
          ,titleCollapse:true
          ,collapsible:true
          ,border:true
          ,listeners: {
              beforeExpand:function(){
                  expedientesGrid.setHeight(175);
              }
              ,beforeCollapse:function(){
                  expedientesGrid.setHeight(435);
              }
          }
      });
	
      var dateRendererJuniper = function(value) {
          var resultado = "";
          if (value.length > 10) {
	   	var dt = new Date();
	   	dt = Date.parseDate(value, "d/m/Y");
              if (dt != undefined) {
                 resultado = dt.format('d/m/Y');
              } else {
                 resultado = value.substring(8,10) + "/" + value.substring(5,7) + "/" + value.substring(0,4);
              }
          	// otra opcion resultado = app.format.dateRenderer(value, "d/m/y")
	   }
	   return resultado;
      }

	var expCm = new Ext.grid.ColumnModel([
			{	hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		    {	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', 
		    	width: 50,sortable: true, dataIndex: 'id'},
		    {	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', 
		    	width: 132,sortable: true, dataIndex: 'descripcionExpediente'},
			{	header: '<s:message code="expedientes.listado.itinerario" text="**Itinerario"/>', 
				sortable: false, dataIndex: 'itinerario'},
		    {	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>', 
		    	width: 75,sortable: true, dataIndex: 'fechacrear'},
		    {	header: '<s:message code="expedientes.listado.origen" text="**Origen"/>', 
		    	width: 40,sortable: false, dataIndex: 'origen'},
		    {	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',
				hidden:true,sortable: true,width: 80, dataIndex: 'estadoExpediente'},
		    {	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',
				width: 80,sortable: true, dataIndex: 'estadoItinerario'},
			{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', 
				width: 105,sortable: true, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', 
		    	width: 105,sortable: true, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', 
				width: 50,sortable: true, dataIndex: 'oficina'},
		    {	header: '<s:message code="expedientes.listado.gestor" text="**Gestor"/>', 
				width: 60,sortable: false, dataIndex: 'gestorActual'},
		    {	header: '<s:message code="expedientes.listado.fvenc" text="**Fecha Vencim."/>', 
				width: 88,sortable: true, dataIndex: 'fechaVencimiento'},
		    {	header: '<s:message code="expedientes.listado.comite" text="**Comité"/>', 
				hidden:true,sortable: true,width: 120, dataIndex: 'comite'},
			{	header: '<s:message code="expedientes.listado.tipoExpediente" text="**Tipo Expediente"/>', 
				hidden:false,sortable: true,width: 120, dataIndex: 'tipoExpediente'}
			]
		); 

	var botonesTabla = fwk.ux.getPaging(expStore);
	botonesTabla.hide();
		
	var expedientesGrid = app.crearGrid(expStore,expCm,{
			title:'<s:message code="expedientes.consulta.titulo" text="**Expedientes"/>'
			,style : 'padding:10px'
			,cls:'cursor_pointer'
			,iconCls : 'icon_expedientes'
			,dontResizeHeight:true
			,height:240		
			,bbar : [ botonesTabla  ]
			<app:test id="listaExpedientes" addComa="true"/>
		});
	var expedientesGridListener =	function(grid, rowIndex, e) {
		
	    	var rec = grid.getStore().getAt(rowIndex);
	    	if(rec.get('id')){
	    		var id = rec.get('id');
	    		var desc = rec.get('descripcionExpediente');
	    		app.abreExpediente(id,desc);
		    	
	    	}
	};
	    
	expedientesGrid.addListener('rowdblclick', expedientesGridListener);
	
	var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[panelFiltros]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
	   			,items:[expedientesGrid]
			}
		]
	    ,autoHeight : true
	    ,border: false
    });
	page.add(mainPanel);
</fwk:page>