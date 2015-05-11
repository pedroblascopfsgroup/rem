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
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="menu.clientes.listado.filtro.riesgototal" text="**Riesgo Total" />', 'riesgo',{width : 80});
	var mmSVencido = app.creaMinMaxMoneda('<s:message code="menu.clientes.listado.filtro.svencido" text="**S. Vencido" />', 'svencido',{width : 80});
	var mmDVencido = app.creaMinMax('<s:message code="menu.clientes.listado.filtro.dvencido" text="**D&iacute;as Vencido" />', 'dvencido',{width : 80, maxLength : "6"});

	//Deshabilitamos los input
	mmRiesgoTotal.min.setDisabled(true);
	mmRiesgoTotal.max.setDisabled(true);

	mmSVencido.min.setDisabled(true);
	mmSVencido.max.setDisabled(true);

	mmDVencido.min.setDisabled(true);
	mmDVencido.max.setDisabled(true);


	//diccionario de tiposProducto
	var diccTiposProducto= <app:dict value="${tiposProducto}" blankElement="true" blankElementValue="" blankElementText="---" />; 

 
	//diccionario de estados
	var estados=<app:dict value="${estados}" />;

    //diccionario de estados financieros
    var estadosFinancieros=<app:dict value="${estadosFinancieros}" />;

	//diccionario de los tipos de riesgos
	var diccTiposRiesgo={diccionario:[
		{codigo:'',descripcion:'---'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_RIESGO_DIRECTO"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.tipoRiesgo.directo" text="**Riesgo directo" />'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_RIESGO_INDIRECTO"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.tipoRiesgo.indirecto" text="**Riesgo indirecto" />'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_RIESGO_TOTAL"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.tipoRiesgo.total" text="**Riesgo total" />'}
		]};


	var dictIntervencion = {diccionario:[
		{codigo:'',descripcion:'---'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_PRIMER_TITULAR"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.intervencion.primerTitular" text="**Primeros Titulares" />'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_TITULARES"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.intervencion.titulares" text="**Titulares" />'}
		,{codigo:'<fwk:const value="es.capgemini.pfs.persona.dao.PersonaDao.BUSQUEDA_AVALISTAS"/>',descripcion:'<s:message code="menu.clientes.listado.filtro.intervencion.avalistas" text="**Avalistas" />'}
	]};

	var comboIntervencion= app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: dictIntervencion
		,name : 'intervencion'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.intervencion" text="**Tipo de Intervención" />'
		,width : 175
	});

	var comboTiposProducto= app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: diccTiposProducto
		,name : 'tiposProducto'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tiposProducto" text="**Tipo de Producto" />'
		,width : 175
		,editable : true
		, forceSelection : true
	});

	comboTiposProducto.editable = true;
	comboTiposProducto.forceSelection = true;

	//diccionario de segmentos
	var segmentos=<app:dict value="${segmentos}" />;

	//diccionario de zonas
	var zonas=<app:dict value="${zonas}" />;

    var gestion = <app:dict value="${gestion}" blankElement="true" blankElementValue="" blankElementText="---" />;
    gestion.diccionario.push({codigo:'<fwk:const value="es.capgemini.pfs.itinerario.model.DDTipoItinerario.ITINERARIO_ESPECIAL_SIN_GESTION" />', descripcion:'<s:message code="menu.clientes.listado.filtro.gestion.sinGestion" text="**Sin Gestion" />'});
    
    var comboGestion = app.creaCombo({data:gestion, 
    									triggerAction: 'all', 
    									value:gestion.diccionario[0].codigo, 
    									name : 'codigoGestion', 
    									width : 175,
    									fieldLabel : '<s:message code="menu.clientes.listado.filtro.gestion" text="**Gestion" />'
    									<app:test id="idComboGestion" addComa="true"/>	
    								});


	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all'
		<app:test id="jerarquiaCombo" addComa="true" />
		,data:jerarquia
   		,value:jerarquia.diccionario[0].codigo
		,name : 'jerarquia'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'
	});
	              
	var tiposPersona = <app:dict value="${tiposPersona}" blankElement="true" blankElementValue="" blankElementText="---" />;

	var comboTipoRiesgo = app.creaCombo({triggerAction: 'all'
		<app:test id="comboTipoRiesgo" addComa="true" />
		,data:diccTiposRiesgo
   		//,value:diccTiposRiesgo.diccionario[0].codigo
		,name : 'tipoRiesgo'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipoRiesgo" text="**Tipo de Riesgo" />'
		,width : 150
	});

	comboTipoRiesgo.on('select', function(){

		//Si ha desactivado el combo
		if (comboTipoRiesgo.getValue() == '')
		{
			//Borramos los input
			mmRiesgoTotal.min.setValue(null);
			mmRiesgoTotal.max.setValue(null);
		
			mmSVencido.min.setValue(null);
			mmSVencido.max.setValue(null);
		
			mmDVencido.min.setValue(null);
			mmDVencido.max.setValue(null);

			//Deshabilitamos los input
			mmRiesgoTotal.min.setDisabled(true);
			mmRiesgoTotal.max.setDisabled(true);
		
			mmSVencido.min.setDisabled(true);
			mmSVencido.max.setDisabled(true);
		
			mmDVencido.min.setDisabled(true);
			mmDVencido.max.setDisabled(true);
		}
	
		//Si ha seleccionado cualquier otra cosa que no sea la vacía
		else 
		{
			//Habilitamos los input
			mmRiesgoTotal.min.setDisabled(false);
			mmRiesgoTotal.max.setDisabled(false);
		
			mmSVencido.min.setDisabled(false);
			mmSVencido.max.setDisabled(false);
		
			mmDVencido.min.setDisabled(false);
			mmDVencido.max.setDisabled(false);
		}

	});


    var comboEstados = app.creaDblSelect(estados
                                         ,'<s:message code="menu.clientes.listado.filtro.situacion" text="**Situacion" />'
                                         ,{<app:test id="comboEstados" />});
    

    var comboEstadosFinancieros = app.creaDblSelect(estadosFinancieros
                                         ,'<s:message code="menu.clientes.listado.filtro.situacionFinanciera" text="**Situacion" />');    

    var comboEstadosFinancierosContrato = app.creaDblSelect(estadosFinancieros
                                         ,'<s:message code="menu.clientes.listado.filtro.situacionFinancieraContrato" text="**Situacion contrato" />');    


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
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	};
	
    recargarComboZonas();
    
    var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
    
    //comboJerarquia.on('select',recargarComboZonas);
    
    var comboSegmentos = app.creaDblSelect(segmentos, '<s:message code="menu.clientes.listado.filtro.segmento" text="**Segmento" />');
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta objeto debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> comboZonas = app.creaDblSelect(zonas
                                       ,'<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />'
                                       ,{store:optionsZonasStore
                                         <app:test id="zonasCombo" addComa="true" />
                                         ,funcionReset:recargarComboZonas});
 
    var comboTipoPersona = app.creaCombo({
		data:tiposPersona
    	,name : 'tipopersona'
    	,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tipopersona" text="**Tipo Persona" />' <app:test id="comboTipoPersona" addComa="true" />
		,width : 175
    });


	var Cliente = Ext.data.Record.create([
		{name:'id'}
		,{name : 'nombre', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellido2', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'segmento', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipo', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'codClienteEntidad', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'direccion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'telefono1', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'docId', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoPersona', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'deudaIrregular',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'totalSaldo',type: 'float', sortType:Ext.data.SortTypes.asFloat}
		,{name : 'diasVencido', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numContratos'}
		,{name : 'situacion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'apellidoNombre', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'diasCambioEstado', sortType:Ext.data.SortTypes.asInt}
        ,{name : 'ofiCntPase', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'arquetipo', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'deudaDirecta', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'riesgoDirectoNoVencidoDanyado', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'situacionFinanciera', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name : 'relacionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'itinerario'}
	]);
	
	//utilizamos implicitamente el mismo flow que ha cargado el grid, si no, le pasaríamos flow : 'admin/listadoUsuarios'
	var clientesStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,remoteSort : true
		,loading:false
		,flow:'clientes/listadoClientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'personas'
	    	,totalProperty : 'total'
	    }, Cliente)
	});
	
	//si entramos por gestión de vencidos, el combo se seleccionará con el valor de gestión de vencidos automáticamente, 
	//y la carga inicial será con este filtro
	if (('${isGestionVencidos}'=='true') 
		|| ('${isGestionSeguimientoSintomatico}'=='true') 
		|| ('${isGestionSeguimientoSistematico}'=='true')){
		comboEstados.on('render', function(){	
			this.setValue('GV');	
		});
		chkPrimerTitular.on('render', function(){	
			this.setValue(true);	
		});
		
		var codigoGestionSeleccionado = '';
		
		if ('${isGestionVencidos}'=='true'){
			codigoGestionSeleccionado = 'REC';
		}
		else if ('${isGestionSeguimientoSintomatico}'=='true'){
			codigoGestionSeleccionado = 'SIN';
		}
		else if ('${isGestionSeguimientoSistematico}'=='true'){
			codigoGestionSeleccionado = 'SIS';
		}
		 
		comboGestion.on('render', function(){	
			this.setValue(codigoGestionSeleccionado);	
		});
		
		
		clientesStore.webflow({	situacion:'GV', isPrimerTitContratoPase:true, isBusquedaGV:true, codigoGestion: codigoGestionSeleccionado });
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
	var filtroApellido=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.apellido1" text="**Primer Apellido" />'
		,enableKeyEvents: true
		,style : 'margin:0px'
		,listeners : {
			keypress : function(target, e){
				if(e.getKey() == e.ENTER && this.getValue().length > 0) {
      				buscarFunc();
  				}
  			}
		}
	});

    var filtroApellido2=new Ext.form.TextField({
        fieldLabel:'<s:message code="menu.clientes.listado.filtro.apellido2" text="**Segundo Apellido" />'
        ,enableKeyEvents: true
		,style : 'margin:0px'
        ,listeners : {
            keypress : function(target, e){
                if(e.getKey() == e.ENTER && this.getValue().length > 0) {
                    buscarFunc();
                }
            }
        }
    });


    var filtroNif=new Ext.form.TextField({
        fieldLabel:'<s:message code="menu.clientes.listado.filtro.nif" text="**NIF" />'
        ,enableKeyEvents: true
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
        ,listeners : {
            keypress : function(target, e){
                if(e.getKey() == e.ENTER && this.getValue().length > 0) {
                    buscarFunc();
                }
            }
        }
    });


	var filtroCodCli=new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.codigoCliente" text="**Codigo Cliente" />'
		,style : 'margin:0px'
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
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});
	 
	var filtroContrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,style : 'margin:0px'
		,maxLength:10 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
		,autoCreate : {tag: "input", type: "text",maxLength:"10", autocomplete: "off"}
	});
	
	var validarForm = function(){
		if (filtroNombre.getValue().trim() != ''){
			return true;
		}
		if (filtroApellido.getValue() != '' ){
			return true;
		}
        if (filtroApellido2.getValue() != '' ){
            return true;
        }
		if (comboSegmentos.getValue() != '' ){
			return true;
		}
		if (comboZonas.getValue() != '' ){
			return true;
		}
		if (comboTiposProducto.getValue() != ''){
			return true;
		}
		if (comboEstados.getValue() != '' ){
			return true;
		}        
		if (comboEstadosFinancieros.getValue() != '' ){
            return true;
        }		
		if (comboEstadosFinancierosContrato.getValue() != '' ){
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
		if (comboGestion.getValue() != ''){
			return true;
		}
		if (comboIntervencion.getValue() != '' ){
			return true;
		}
		if (filtroCodCli.getValue() != '' ){
			return true;
		}
		if (comboTipoPersona.getValue() != '' ){
			return true;
		}
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
		if (!(mmDVencido.min.getValue() === '' )){
			return true;
		}
		if (!(mmDVencido.max.getValue() === '' )){
			return true;
		}	
		if (!(filtroContrato.getValue() === '')){
			return true;
		}
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
	
	var buscarFunc = function(){
		if (validarForm()){
			if (validaMinMax()){
				filtroForm.collapse(true);
				
                var params= getParametros();
                params.start=0;
                params.limit=limit;
                clientesStore.webflow(params);
				
				//Cerramos el panel de filtros y esto hará que se abra el listado de clientes
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>')
		}
	};
	
    var btnExportar=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar" text="**exportar" />'
        ,iconCls:'icon_exportar_csv'
        ,handler : function() { 
            app.openBrowserWindow("exportClientesData",getParametros());
        }
    });

    var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
                    var flow='clientes/exportClientes';
                    var params= getParametros();
                    params.REPORT_NAME='busqueda.pdf';
                    app.openBrowserWindow(flow,params);
                }
        }
    );

    var getParametros = function() {
        return {
                nombre:filtroNombre.getValue()
                ,apellido1:filtroApellido.getValue()
                ,apellido2:filtroApellido2.getValue()
                ,segmento:comboSegmentos.getValue()
				,tipoProducto:comboTiposProducto.getValue()
                ,codigoZona:comboZonas.getValue()
                ,situacion:comboEstados.getValue()
                ,situacionFinanciera:comboEstadosFinancieros.getValue()
                ,situacionFinancieraContrato:comboEstadosFinancierosContrato.getValue()                
                ,docId:filtroNif.getValue()
				,tipoRiesgo:comboTipoRiesgo.getValue()
                ,isPrimerTitContratoPase:chkPrimerTitular.getValue()
				,tipoIntervercion:comboIntervencion.getValue()
                ,jerarquia:comboJerarquia.getValue()
                ,codigoGestion:comboGestion.getValue()
                ,codigoEntidad:filtroCodCli.getValue()
                ,tipoPersona:comboTipoPersona.getValue()
                ,minRiesgoTotal:mmRiesgoTotal.min.getValue()
                ,maxRiesgoTotal:mmRiesgoTotal.max.getValue()
                ,minSaldoVencido:mmSVencido.min.getValue()
                ,maxSaldoVencido:mmSVencido.max.getValue()
                ,minDiasVencido:mmDVencido.min.getValue()
                ,maxDiasVencido:mmDVencido.max.getValue()
                ,nroContrato:filtroContrato.getValue()
            };
    }

	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnReset = app.crearBotonResetCampos([
		filtroNombre
		,filtroApellido
        ,filtroApellido2
		,comboSegmentos
		,comboTiposProducto
		,comboEstados
        ,comboEstadosFinancieros
        ,comboEstadosFinancierosContrato
		,filtroNif
		,comboJerarquia
		,comboGestion
		,comboZonas
		,filtroCodCli
		,comboTipoPersona
		,comboTipoRiesgo
		,mmRiesgoTotal.min
		,mmRiesgoTotal.max
		,mmSVencido.min
		,mmSVencido.max
		,mmDVencido.min
		,mmDVencido.max
		,chkPrimerTitular
		,filtroContrato
	]);
	
	var muestraAyuda=function(){
		//app.openUrl("Ayuda",'ayuda/Tareas_Pendientes.html');
		//window.open("/ayuda/Tareas_Pendientes.html");
	}

	var formRiesgos=new Ext.form.FormPanel({
		items:[
			comboTipoRiesgo, mmRiesgoTotal.panel, mmSVencido.panel, mmDVencido.panel
		]
		,border:false
	});

	var fieldSetRiesgos=new Ext.form.FieldSet({
			items:formRiesgos
			,title:'<s:message code="menu.clientes.listado.filtro.fieldSetRiesgos" text="**Datos de solvencia" />'
			,bodyStyle:'padding-top:0px;padding-bottom:0px;padding-right:5px;padding-left:5px'
			,width:'310px'
			,autoHeight:true
	});

	var filtroForm = new Ext.Panel({
		title : '<s:message code="menu.clientes.listado.filtro.filtrodeclientes" text="**Filtro de clientes" />'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {
			columns:3
		}
		//,style:'margin-right:20px;margin-left:10px'
		//,bodyStyle:'padding:5px;cellspacing:20px;padding-bottom: 0px;'
		//,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:10px'
				,width:'320px'
				 ,items:[filtroCodCli, filtroNombre,filtroApellido,filtroApellido2,filtroNif,comboTipoPersona,comboTiposProducto, <c:if test="${isGestionVencidos || isGestionSeguimientoSistematico || isGestionSeguimientoSintomatico}">chkPrimerTitular,comboIntervencion,</c:if>fieldSetRiesgos,comboGestion]
			},{
				layout:'form' 
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[ filtroContrato, comboSegmentos,comboEstados, comboEstadosFinancieros, comboEstadosFinancierosContrato, comboJerarquia, comboZonas]
			}  
			,{
				items : [ {html :'&nbsp;',border:false},{html :'&nbsp;',border:false}]
			}
		]              
		,tbar : [btnBuscar, btnReset, btnExportar,btnExportarXls, '->', app.crearBotonAyuda(muestraAyuda)]
		,listeners:{	
			beforeExpand:function(){
				grid.setHeight(0);				
				grid.collapse(true);
			}
			,beforeCollapse:function(){
				grid.setHeight(435);
				grid.expand(true);
			}
		}
	});
	

	var clientesCm=new Ext.grid.ColumnModel([
			{header : '<s:message code="menu.clientes.listado.lista.nombre" text="**Nombre" />'
			, dataIndex : 'nombre' ,sortable:true,width:120}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido1" text="**Apellido1" />'
			, dataIndex : 'apellido1' ,sortable:true,width:100}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido2" text="**Apellido2" />'
			, dataIndex : 'apellido2',sortable:true,width:120}
			,{header : '<s:message code="menu.clientes.listado.lista.codigo" text="**Codigo" />'
			, dataIndex : 'codClienteEntidad',sortable:true,width:70,align:'right',hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.direccion" text="**Direccion" />'
			, dataIndex : 'direccion',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.nif" text="**CIF/NIF" />'
			, dataIndex : 'docId',sortable:true,width:80,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.itinerario" text="**Itinerario" />'
			, dataIndex : 'itinerario',sortable:false,width:70,align:'right',hidden:false}
			,{header : '<s:message code="menu.clientes.listado.lista.segmento" text="**Segmento" />'
			, dataIndex : 'segmento',sortable:false,width:90}
			,{header : '<s:message code="menu.clientes.listado.lista.tipo" text="**Tipo" />'
			, dataIndex : 'tipo',sortable:false,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.telefono" text="**Telefono" />'
			, dataIndex : 'telefono1',sortable:true,hidden:true}
			,{header : '<s:message code="menu.clientes.listado.lista.totaldeuda" text="**Total Deuda Irregular" />'
			, dataIndex : 'deudaIrregular',sortable:true,renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.totalsaldo" text="**Total Saldo" />'
			, dataIndex : 'totalSaldo',sortable:true, renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirecto" text="**riesgo Directo" />'
			, dataIndex: 'deudaDirecta',sortable:true, renderer: app.format.moneyRenderer,align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirectoDaniado" text="**RDD" />',hidden:true
			, dataIndex: 'riesgoDirectoNoVencidoDanyado',sortable:true, renderer: app.format.moneyRenderer,align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos" />'
			, dataIndex : 'numContratos',sortable:true,width:70, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.posantigua" text="**Posicion antigua" />'
			, dataIndex : 'diasVencido',sortable:false,width:90, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.situacion" text="**Situaci&oacute;n" />'
			, dataIndex : 'situacion',sortable:false,width:65}
			,{header : 'id', dataIndex: 'id', hidden:true,fixed:true}
			,{header : 'apellidoNombre', dataIndex: 'apellidoNombre', hidden:true,fixed:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.diaspase" text="**Dias para pase" />', dataIndex: 'diasCambioEstado', sortable:false, fixed:true, align:'right',hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.ofiCntPase" text="**Oficina del contrato de pase" />'
            , dataIndex: 'ofiCntPase', sortable:false,width:80,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.arquetipo" text="**Arquetipo" />', dataIndex: 'arquetipo', sortable:false, hidden:true,width:80}
            ,{header : '<s:message code="menu.clientes.listado.lista.situacionFinanciera" text="**Situacion Financiera" />', dataIndex: 'situacionFinanciera', sortable:false ,hidden:true}
            ,{header : '<s:message code="menu.clientes.listado.lista.relacionExpediente" text="**Relacion Expediente" />', dataIndex: 'relacionExpediente', sortable:false, hidden:true}
		]);
	
	var pagingBar=fwk.ux.getPaging(clientesStore);
	var cfg={
		title: '<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="0"/>'
		,style:'padding: 10px;'
		,cls:'cursor_pointer'
		,iconCls : 'icon_cliente'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true
		,height:200
		,bbar : [  pagingBar ]
		<app:test id="clientesGrid" addComa="true" />
	};
	var grid=app.crearGrid(clientesStore,clientesCm,cfg);


	clientesStore.on('load', function(){
		grid.setTitle('<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="'+clientesStore.getTotalCount()+'"/>');
		filtroForm.collapse(true);
	});

	grid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_cliente=rec.get('apellidoNombre');
    	app.abreCliente(rec.get('id'), nombre_cliente);
    });
    
    var compuesto = new Ext.Panel({
	    items : [
              {
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [filtroForm]
			  },{
				bodyStyle:'padding:5px;cellspacing:10px'
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,items : [grid]
			  }
    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	
	//añadimos al padre y hacemos el layout
	page.add(compuesto);   

</fwk:page>
