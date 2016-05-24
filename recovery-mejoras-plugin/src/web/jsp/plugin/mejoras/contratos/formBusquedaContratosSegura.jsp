<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

var formBusquedaContratos=function(){

	var limit=25;
	
	var busquedaContratosMask = new Ext.LoadMask(Ext.getBody(), {msg:"Cargando ..."});
	
	
	//numero contrato
	var txtContrato = app.creaText('contrato1', '<s:message code="listadoContratos.numContrato" text="**Num. Contrato" />'); 
	//codigo de recibo
	var txtCodRecibo = app.creaText('codRecibo', '<s:message code="listadoContratos.codigoRecibo" text="**Cod. recibo" />'); 
	//codigo de efecto
	var txtCodEfecto = app.creaText('codEfecto', '<s:message code="listadoContratos.codigoEfecto" text="**Cod. efecto" />'); 
	//codigo de disposicion
	var txtCodDisposicion = app.creaText('codDisposicion', '<s:message code="listadoContratos.codigoDisposicion" text="**Cod. disposición" />'); 
	
	var ddCondicionesRemuneracion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		,{name:'codigo'}
	]);
	
	var optionsCondicionesRemuneracionStore = page.getStore({
	       flow: 'mejacuerdo/getListDDCondicionesRemuneracionData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'condicionesRemuneracion'
	    }, ddCondicionesRemuneracion)	       
	});	

	var comboMotivoGestionHRE = new Ext.form.ComboBox({
		store:optionsCondicionesRemuneracionStore
		,id:'motivoGestionHRE'
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="listadoContratos.motivoGestion" text="**Motivo Gestión" />'
		,width: 220		
	});
	
	comboMotivoGestionHRE.on('afterrender', function(combo) {
		optionsCondicionesRemuneracionStore.webflow();
	});
	<%--nuevo combo buscador --%>
	var ddSituacionGestion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
		,{name:'codigo'}
	]);
	
	var optionsSituacionGestion = page.getStore({
	       flow: 'mejacuerdo/getListSituacionGestion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'situacionGestion'
	    }, ddSituacionGestion)
	});	

	var comboSituacionGestion = new Ext.form.ComboBox({
		store:optionsSituacionGestion
		,id:'situacionGestion'
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,resizable: true
		,forceSelection: true
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="listadoContratos.situacionGestion" text="**Situación Gestión" />'
		,width: 220		
	});
	comboSituacionGestion.on('afterrender', function(combo) {
		optionsSituacionGestion.webflow();
	});
	<%------------------------------------------------------------ --%>
	//nombre
	var txtNombre = app.creaText('nombre', '<s:message code="listadoContratos.nombre" text="**Nombre" />');

	//apellido1
	var txtApellido1 = app.creaText('apellido1', '<s:message code="plugin.mejoras.listadoContratos.apellidos" text="**Apellidos" />');

	<%--//apellido2
	var txtApellido2 = app.creaText('apellido2', '<s:message code="listadoContratos.apellido2" text="**Apellido2" />'); --%>

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

	var comboEstadoContrato = app.creaDblSelect(dictEstados, '<s:message code="listadoContratos.estado" text="**Estado" />',{width:220});

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

	var comboJerarquia = app.creaCombo({triggerAction: 'all',
	 	data:jerarquia, 
	 	value:jerarquia.diccionario[0].codigo, 
	 	name : 'jerarquia', 
	 	fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'});

	 	var comboJerarquiaAdministrativa = app.creaCombo({triggerAction: 'all',
	 	data:jerarquia, 
	 	value:jerarquia.diccionario[0].codigo, 
	 	name : 'jerarquia', 
	 	fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquiaAdministrativa" text="**Jerarquia administrativa" />'});

	var listadoCodigoZonas = [];
	var listadoCodigoZonasAdm = [];

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

    comboJerarquia.on('select',function(){
		if(comboJerarquia.value != '') {
			comboZonas.setDisabled(false);
			optionsZonasStore.setBaseParam('idJerarquia', comboJerarquia.getValue());
		}else{
			comboZonas.setDisabled(true);
		}
	});
	
    comboJerarquiaAdministrativa.on('select',function(){
		if(comboJerarquiaAdministrativa.value != '') {
			comboZonasAdm.setDisabled(false);
			optionsZonasAdmStore.setBaseParam('idJerarquia', comboJerarquiaAdministrativa.getValue());
		}else{
			comboZonasAdm.setDisabled(true);
		}
	});
	
	var codZonaSel='';
	var desZonaSel='';
	
	var codZonaSelAdm='';
	var desZonaSelAdm='';

 	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var zonasAdmRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	//Template para el combo de zonas
    var zonasTemplate = new Ext.XTemplate(
        '<tpl for="."><div class="search-item">',
            '<p>{descripcion}&nbsp;&nbsp;&nbsp;</p><p>{codigo}</p>',
        '</div></tpl>'
    );
    
    //Template para el combo de zonas
    var zonasAdmTemplate = new Ext.XTemplate(
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
	
	 var optionsZonasAdmStore = page.getStore({
	       flow: 'mejexpediente/getZonasInstant'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasAdmRecord)
	       
	});

  	//Combo de zonas
    var comboZonas = new Ext.form.ComboBox({
        name: 'comboZonas'
        ,disabled:true 
        ,allowBlank:true
        ,store:optionsZonasStore
        ,width:220
        ,fieldLabel: '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro"/>'
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
    
 	//Combo de zonas
    var comboZonasAdm = new Ext.form.ComboBox({
        name: 'comboZonasAdm'
        ,disabled:true 
        ,allowBlank:true
        ,store:optionsZonasAdmStore
        ,width:220
        ,fieldLabel: '<s:message code="menu.clientes.listado.filtro.centroAdministrativo" text="**Centro administrativo"/>'
        ,tpl: zonasAdmTemplate  
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
        	btnAdmIncluir.setDisabled(false);
        	codZonaSelAdm=record.data.codigo;
        	desZonaSelAdm=record.data.descripcion;
         }
    });	
    
  	var recordZona = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigoZona'},
		{name: 'descripcionZona'}
	]);
	
  	var recordAdmZona = Ext.data.Record.create([
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
	
  	var zonasAdmStore = page.getStore({
		flow:''
		,reader: new Ext.data.JsonReader({
	  		root : 'data'
		} 
		, recordAdmZona)
	});
 
      var zonasCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="expedientes.listado.centros.codigo" text="**Código" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="expedientes.listado.centros.nombre" text="**Nombre" />', dataIndex : 'descripcionZona',sortable:false, hidden:false, width:300}
	]);
	
     var zonasAdmCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="expedientes.listado.centros.codigo" text="**Código" />', dataIndex : 'codigoZona' ,sortable:false, hidden:false, width:80}
		,{header : '<s:message code="expedientes.listado.centros.nombre" text="**Nombre" />', dataIndex : 'descripcionZona',sortable:false, hidden:false, width:300}
	]);
	
	var zonasGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="expedientes.listado.centros" text="**Centros" />'
	    ,cm: zonasCM
	    ,store: zonasStore
	    ,autoWidth: true
	    ,height: 150
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,clicksToEdit: 1
	});
	
	var zonasAdmGrid = new Ext.grid.EditorGridPanel({
	    title : '<s:message code="expedientes.listado.centros" text="**Centros" />'
	    ,cm: zonasAdmCM
	    ,store: zonasAdmStore
	    ,autoWidth: true
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
	
	var incluirAdmZona = function() {
	    var zonaAInsertar = zonasAdmGrid.getStore().recordType;
   		var p = new zonaAInsertar({
   			codigoZona: codZonaSelAdm,
   			descripcionZona: desZonaSelAdm
   		});
		zonasAdmStore.insert(0, p);
		listadoCodigoZonasAdm.push(codZonaSelAdm);
	}
	
	var btnIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirZona();
			codZonaSel='';
   			desZonaSel='';
   			btnIncluir.setDisabled(true);
			comboZonas.focus();
		}
	});

	var btnAdmIncluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.incluir" text="Incluir" />'
		,iconCls : 'icon_mas'
		,disabled: true
		,minWidth:60
		,handler : function(){
			incluirAdmZona();
			codZonaSelAdm='';
   			desZonaSelAdm='';
   			btnAdmIncluir.setDisabled(true);
			comboZonasAdm.focus();
		}
	});
		
	var zonaAExcluir = -1;
	var codZonaExcluir = '';
	
	var zonaAExcluirAdm = -1;
	var codZonaExcluirAdm = '';
	
	zonasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codZonaExcluir = grid.selModel.selections.get(0).data.codigoZona;
   		zonaAExcluir = rowIndex;
   		btnExcluir.setDisabled(false);
	});
	
	zonasAdmGrid.on('cellclick', function(grid, rowIndex, columnIndex, e) {
   		codZonaExcluirAdm = grid.selModel.selections.get(0).data.codigoZona;
   		zonaAExcluirAdm = rowIndex;
   		btnAdmExcluir.setDisabled(false);
	});
	
	var btnExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (zonaAExcluir >= 0) {
				zonasStore.removeAt(zonaAExcluir);
				listadoCodigoZonas.remove(codZonaExcluir);
			}
			zonaAExcluir = -1;
	   		btnExcluir.setDisabled(true);
		}
	});
	
	var btnAdmExcluir = new Ext.Button({
		text : '<s:message code="rec-web.direccion.form.excluir" text="Excluir" />'
		,iconCls : 'icon_menos'
		,disabled: true
		,minWidth:60
		,handler : function(){
			if (zonaAExcluirAdm >= 0) {
				zonasAdmStore.removeAt(zonaAExcluirAdm);
				listadoCodigoZonasAdm.remove(codZonaExcluirAdm);
			}
			zonaAExcluirAdm = -1;
	   		btnAdmExcluir.setDisabled(true);
		}
	});
<%--
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		//recargarComboZonas();
	}
 
	comboJerarquia.on('select',limpiarYRecargar);--%>	

	//diccionario de tiposProducto
	
	var diccTiposProducto = 
		<json:object>
			<json:array name="diccionario" items="${tiposProductoEntidad}" var="d">	
			 <json:object>
			   <json:property name="codigo" value="${d.codigo}" />
			   <sec:authorize ifAllGranted="PERSONALIZACION-BCC">
			   		<json:property name="descripcion" value="${d.descripcion} (${d.codigo})" />
			   </sec:authorize>
			   <sec:authorize ifNotGranted="PERSONALIZACION-BCC">
			   		<json:property name="descripcion" value="(${d.codigo}) ${d.descripcion}" />
			   </sec:authorize>
			 </json:object>
			</json:array>
		</json:object>;

    var comboTiposProducto = app.creaDblSelect(diccTiposProducto
            ,'<s:message code="menu.clientes.listado.filtro.tiposProducto" text="**Tipo de Producto" />'
            ,{
            	height: 180
               	,width:220
           	});

	 var getParametros = function() {
	 	var p = {};
        p.busquedaOrInclusion='${busquedaOrInclusion}';
        	if (tabDatos){
        		p.nroContrato=txtContrato.getValue();
        		p.stringEstadosContrato=comboEstadoContrato.getValue();
        		p.tiposProductoEntidad=comboTiposProducto.getValue();
        		p.codRecibo=txtCodRecibo.getValue();
        		p.codEfecto=txtCodEfecto.getValue();
        		p.codDisposicion=txtCodDisposicion.getValue();
        		p.motivoGestionHRE=comboMotivoGestionHRE.getValue();
        		p.situacionGestion=comboSituacionGestion.getValue();
        	}
        	if(tabRelaciones){
        		p.nombre=txtNombre.getValue();
        		p.apellido1=txtApellido1.getValue();
				p.documento=txtNIF.getValue();
				<c:if test="${busquedaOrInclusion!='inclusion'}">
					p.descripcionExpediente=txtExpediente.getValue();
					p.nombreAsunto=txtAsunto.getValue();
				</c:if>
        	}
        	if (tabEconomicos){	
        		p.estadosFinancieros=comboEstadoFinanciero.getValue();
        		p.maxVolTotalRiesgo=mmRiesgoTotal.max.getValue();
				p.minVolTotalRiesgo=mmRiesgoTotal.min.getValue();
				p.maxVolRiesgoVencido=mmSVencido.max.getValue();
				p.minVolRiesgoVencido=mmSVencido.min.getValue();
				p.minDiasVencidos=mmDVencido.min.getValue();
				p.maxDiasVencidos=mmDVencido.max.getValue();
        	}
        	if (tabJerarquia){
        		p.jerarquia=comboJerarquia.getValue();
				p.codigoZona=listadoCodigoZonas.toString();
				p.jerarquiaAdm=comboJerarquiaAdministrativa.getValue();
				p.codigoZonaAdm=listadoCodigoZonasAdm.toString();	
        	}

		<c:if test="${busquedaOrInclusion=='inclusion'}">
        	//,tieneRiesgo:comboTieneRiesgo.getValue()
        </c:if>
        
        return p;
    };

	var validarForm = function(){
		<c:if test="${busquedaOrInclusion=='inclusion'}">
			//if(!(comboTieneRiesgo.getValue()==='')){
			//	return true;
			//}
		</c:if>
		if (tabDatos){
			if (txtContrato.getValue().trim()!=''){
				return true;
			}
			if (comboEstadoContrato.getValue().trim()!=''){
				return true;
			}
			if(!(comboTiposProducto.getValue()==='')){
				return true;
			}
			if (txtCodRecibo.getValue().trim()!=''){
				return true;
			}
			if (txtCodEfecto.getValue().trim()!=''){
				return true;
			}
			if (txtCodDisposicion.getValue().trim()!=''){
				return true;
			}
			if (comboMotivoGestionHRE.getValue().trim()!=''){
				return true;
			}
			if (comboSituacionGestion.getValue().trim()!=''){
				return true;
			}
		}
		if(tabRelaciones){
			if (txtNombre.getValue().trim()!=''){
				return true;
			}
			if (txtApellido1.getValue().trim()!=''){
				return true;
			}
			<%--if (txtApellido2.getValue().trim()!=''){
				return true;
			} --%>
			if (txtNIF.getValue().trim()!=''){
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
		}
		if (tabEconomicos){
			if (comboEstadoFinanciero.getValue().trim()!=''){
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
		}
		if (tabJerarquia){
			if (comboZonas.getValue().trim()!=''){
				return true;
			}
			if (comboJerarquia.getValue().trim()!=''){
				return true;
			}
			if (comboZonasAdm.getValue().trim()!=''){
				return true;
			}
			if(comboJerarquiaAdministrativa.getValue().trim()!=''){
				return true;
			}
		}
		
		return false;
	};
	
	var validaMinMax = function(){
		if (tabEconomicos){
			if (!app.validaValoresDblText(mmRiesgoTotal)){
				return false;
			}
			if (!app.validaValoresDblText(mmSVencido)){
				return false;
			}
			if (!app.validaValoresDblText(mmDVencido)){
				return false;
			}
		}
		return true;
	};
	
    
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
			busquedaContratosMask.hide();
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',mensaje);
			return;
		}
		else if (codigoResultado == codigoOk)
		{
	        var params=getParametros();
	        var flow='contratos/exportContratos';
	        app.openBrowserWindow(flow,params);
		}
		busquedaContratosMask.hide();
	});
	


	<%--*************PESTAÑA DE DATOS DEL CONTRATO***************************************** --%>
	
	var tabDatos=false;
	var filtrosTabDatosContrato = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.contratos.busqueda.datosGenerales" text="**Datos del contrato" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtContrato,txtCodRecibo,txtCodEfecto,txtCodDisposicion
					<sec:authorize ifAllGranted="PERSONALIZACION-HY">,comboMotivoGestionHRE</sec:authorize>, comboSituacionGestion]
				},{
					layout:'form'
					,items: [comboEstadoContrato,comboTiposProducto]
				}]
	});
	filtrosTabDatosContrato.on('activate',function(){
		tabDatos=true;
	});
	<%--*************PESTAÑA DE DATOS ECONOMICOS***************************************** --%>
	var tabEconomicos=false;
	var filtrosTabDatosEconomicos = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.contratos.busqueda.datosEconómicos" text="**Datos económicos" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboEstadoFinanciero,mmRiesgoTotal.panel]
				},{
					layout:'form'
					,items: [mmSVencido.panel,mmDVencido.panel]
				}]
	});
	filtrosTabDatosEconomicos.on('activate',function(){
		tabEconomicos=true;
	});
	<%--*************PESTAÑA DE RELACIONES ***************************************** --%>
	var tabRelaciones=false;
	var filtrosTabRelacionesContrato = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.contratos.busqueda.relaciones" text="**Relaciones del contrato" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [txtNombre,txtApellido1,<%--txtApellido2, --%>txtNIF]
				},{
					layout:'form'
					,items: [txtExpediente,txtAsunto]
				}]
	});
	filtrosTabRelacionesContrato.on('activate',function(){
		tabRelaciones=true;
	}); 
	<%-- *******************PESTAÑA DE JERARQUÍA****************************************** --%>
	var tabJerarquia=false;
	var filtrosTabJerarquia = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.contratos.busqueda.jerarquia" text="**Jerarquía" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : { border : false , layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;margin-right:40px'}
		,items:[{
					layout:'table'
                    ,layoutConfig:{columns:2}
                    ,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
					,items: [{items:[comboJerarquia,comboZonas]}, {autoWidth: true,items:[btnIncluir,btnExcluir]}]
				},{
					layout:'table'
                    ,layoutConfig:{columns:2}
                    ,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
					,items: [{items:[comboJerarquiaAdministrativa,comboZonasAdm]}, {autoWidth: true,items:[btnAdmIncluir,btnAdmExcluir]}]
				},{
					layout:'form'
					,items: [zonasGrid]
				},{
					layout:'form'
					,items: [zonasAdmGrid]
				}]
	});
	
	
	filtrosTabJerarquia.on('activate',function(){
		tabJerarquia=true;
	}); 
	
	<%--*************************************************************************************
	*************TABPANEL QUE CONTIENE TODAS LAS PESTAÑAS****************************************
	**************************************************************************************** --%>
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosContrato, filtrosTabRelacionesContrato, filtrosTabDatosEconomicos, filtrosTabJerarquia]
		,id:'idTabFiltrosContrato'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});

	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;

	<%--***********PANEL QUE CONTIENE EL PANEL DE PESTAÑAS******************** --%>
	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,title : '<s:message code="listadoContratos.filtros" text="**Filtro de Contratos" />'
			,titleCollapse:true
			,collapsible:true
			<%--,tbar : [btnBuscar,btnClean,btnExportarXls,'->', app.crearBotonAyuda()] --%>
			,tbar : [buttonsL,'->', buttonsR]
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,style:'padding-bottom:10px; padding-right:10px;'
			,items:[{items:[{
							layout:'form'
							,items:[
									filtroTabPanel
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
				contratosGrid2.expand(true);
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
		,{name : "fechaDato"}
		,{name : 'codigoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProducto', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProductoEntidad', sortType:Ext.data.SortTypes.asTex }
		,{name : 'condEspeciales', sortType:Ext.data.SortTypes.asTex }
		,{name : 'saldoVencido', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'diasIrregular', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'riesgo', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'titular', sortType:Ext.data.SortTypes.asTex }
		,{name : 'situacion', sortType:Ext.data.SortTypes.asTex}
		,{name : 'estadoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'estadoFinanciero', sortType:Ext.data.SortTypes.asTex }
		,{name : 'aplicativoOrigen', sortType:Ext.data.SortTypes.asTex }
		,{name :'cuotaImporte', sortType:Ext.data.SortTypes.asFloat }
		,{name :'dispuesto', sortType:Ext.data.SortTypes.asFloat }
		,{name :'limiteInicial', sortType:Ext.data.SortTypes.asFloat }
		,{name :'limiteFinal', sortType:Ext.data.SortTypes.asFloat }
		,{name :'situacion2', sortType:Ext.data.SortTypes.asTex}
		,{name :'oficina', sortType:Ext.data.SortTypes.asTex }
		,{name :'oficinaAdministrativa', sortType:Ext.data.SortTypes.asTex }
		,{name :'oficinaContable', sortType:Ext.data.SortTypes.asTex}		
	]);

	
	var contratosStore = page.getStore({
		flow : 'plugin.mejoras.contrato.buscaContratosData'
		,limit:limit
		,reader: new Ext.data.JsonReader({
	    	root : 'contratos'
	    	,totalProperty : 'total'
	    }, contrato)
		,remoteSort : true
	});

	

	var contratosCm = new Ext.grid.ColumnModel([
			 {	header: 'id', dataIndex: 'id', hidden:true, fixed:true }
			<c:if test="${busquedaOrInclusion=='inclusion'}">,checkColumn</c:if>
		    ,{	header: '<s:message code="listadoContratos.listado.contrato" text="**Num. Contrato"/>',sortable: false, width: 130, dataIndex: 'codigoContrato'}
		    ,{	header: '<s:message code="listadoContratos.listado.fechaDato" text="**Fecha dato"/>',sortable: false, width: 130, dataIndex: 'fechaDato'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>',sortable: false , dataIndex: 'tipoProducto', hidden: true}
			,{	header: '<s:message code="listadoContratos.listado.tipoEntidad" text="**Tipo Entidad"/>',sortable: false , dataIndex: 'tipoProductoEntidad'}
			,{	header: '<s:message code="listadoContratos.listado.codDisposicion" text="**Cód. disposición"/>',sortable: false , dataIndex: 'condEspeciales'}
			,{	header: '<s:message code="listadoContratos.listado.dias" text="**D&iacute;as vencido"/>',sortable: false , width: 70, dataIndex: 'diasIrregular', align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.saldo" text="**Saldo vencido"/>',sortable: false , width: 70, dataIndex: 'saldoVencido', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos"/>',sortable: false , width: 70, dataIndex: 'riesgo', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.primertitular" text="**1er Titular"/>',sortable: false , width:130, dataIndex: 'titular'}
			,{	header: '<s:message code="listadoContratos.listado.situacion" text="**Situacion"/>',sortable: false , width:60, dataIndex: 'situacion2'}
		    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>',sortable: false , width: 90, dataIndex: 'estadoContrato', hidden:true}
		    ,{	header: '<s:message code="listadoContratos.listado.estadoFinanciero" text="**Estado Financiero"/>',sortable: false , width: 90, dataIndex: 'estadoFinanciero'}
		    ,{	header: '<s:message code="listadoContratos.listado.aplicativoOrigen" text="**Aplicativo origen"/>',sortable: false , dataIndex: 'aplicativoOrigen', hidden:true}
			,{	header: '<s:message code="listadoContratos.listado.cuotaImporte" text="**Cuota importe"/>',sortable: false , dataIndex: 'cuotaImporte', renderer:app.format.moneyRenderer, hidden:true}
			,{	header: '<s:message code="listadoContratos.listado.dispuesto" text="**Dispuesto"/>',sortable: false , dataIndex: 'dispuesto', renderer:app.format.moneyRenderer, hidden:true}
			,{	header: '<s:message code="listadoContratos.listado.limiteInicial" text="**Limite inicial"/>',sortable: false , dataIndex: 'limiteInicial', renderer:app.format.moneyRenderer, hidden:true}
			,{	header: '<s:message code="listadoContratos.listado.limiteFinal" text="**Limite final"/>',sortable: false , dataIndex: 'limiteFinal', renderer:app.format.moneyRenderer, hidden:true}		
			,{	header: '<s:message code="listadoContratos.listado.oficina" text="**Oficina"/>',sortable: false , dataIndex: 'oficina', hidden:true}
			,{	header: '<s:message code="listadoContratos.listado.oficinaContable" text="**Oficina Cont."/>',sortable: false , dataIndex: 'oficinaContable', hidden:true}			
			,{	header: '<s:message code="listadoContratos.listado.oficinaAdministrativa" text="**Oficina Adm."/>',sortable: false , dataIndex: 'oficinaAdministrativa', hidden:true}
	]); 

	var pagingBar=fwk.ux.getPaging(contratosStore);
	pagingBar.hide();
	
	contratosStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	

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