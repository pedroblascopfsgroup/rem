<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var limit=25;
	
	var busquedaClientesMask = new Ext.LoadMask(Ext.getBody(), {msg:"Cargando ..."});

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

	var maskPanelShow=false;
	var timeoutID;
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			//filtroForm.collapse(true);
			maskPanel=new Ext.LoadMask(compuesto.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});			
			<%-- AS-144 Se comenta para deshabilitar el mensaje en caso de timeout
			noData.delay(50000); 
			--%>
		}
		maskPanel.show();
		maskPanelShow=true;
	};

<%-- AS-144 Se comenta para deshabilitar el mensaje en caso de timeout
	var noData = new Ext.util.DelayedTask(function(){
		if(maskPanel!=null) {		
			if (maskPanelShow) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.clientes.listado.noData" text="**No se han encontrado datos, pruebe a ajustar la b�squeda"/>')
				unmaskAll();
			}
		}	
	});
	--%>
	
	
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
			
		maskPanelShow=false
	};


 	//diccionario de tiposProductoEntidad
	var diccTiposProductoEntidad= <app:dict value="${tiposProductoEntidad}" blankElement="true" blankElementValue="" blankElementText="---" />; 
 
	//diccionario de estados
	var estados=<app:dict value="${estados}" />;

    //diccionario de estados financieros
    var estadosFinancieros=<app:dict value="${estadosFinancieros}" />;
    
    //diccionario de colectivo singular
    var dictColectivoSingular=<app:dict value="${ddColectivoSingular}" />;
    
    //diccionario de si/no n�mina o pensi�n
    var dictNominaPension=<app:dict value="${ddSiNo}" />;
    
    //diccionario de tipos de propietario
    var dictPropietario =<app:dict value="${ddPropietario}" />;

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
		,hidden: false
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.intervencion" text="**Tipo de Intervenci�n" />'
		,width : 175
	});

	var comboTiposProductoEntidad= app.creaCombo({
		fields: ['codigo', 'descripcion']
	    ,root: 'diccionario'
	    ,data: diccTiposProductoEntidad
		,name : 'tiposProductoEntidad'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.tiposProductoEntidad" text="**Tipo de Producto" />'
		,width : 175
		,editable : true
		, forceSelection : true
	});

	comboTiposProductoEntidad.editable = true;
	comboTiposProductoEntidad.forceSelection = true;

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
		,width : 175
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
	
	var comboColectivoSingular=app.creaCombo({triggerAction: 'all'
		<app:test id="comboColectivoSingular" addComa="true" />
		,data:dictColectivoSingular
   		//,value:diccTiposRiesgo.diccionario[0].codigo
		,name : 'colecivoSingular'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.colectivoSingular" text="**Colectivo singular" />'
		,width : 175
	});
	
	var comboNominaPension=app.creaCombo({
		triggerAction:'all'
		<app:test id="comboNominaPension" addComa="true" />
		,data:dictNominaPension
		,name : 'nominaPension'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.nominaPension" text="**N�mina o pension" />'
		,width : 175
	});

	comboPropietario=app.creaCombo({
		triggerAction:'all'
		<app:test id="comboPropietario" addComa="true" />
		,data: dictPropietario
		,name : 'propietario'
		,fieldLabel : '<s:message code="menu.clientes.listado.filtro.propietario" text="**Propietario" />'
		,width : 175
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
	
		//Si ha seleccionado cualquier otra cosa que no sea la vac�a
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
                                         ,'<s:message code="menu.clientes.listado.filtro.situacion" text="**Situacion" /> cliente'
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
		// Si estamos corriendo tests selenium esta funci�n debe ser global para que
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
		,{name : 'apellidos', type:'string', sortType:Ext.data.SortTypes.asText}
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
        ,{name : 'fechaDato'}
        ,{name : 'relacionExpediente', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'itinerario'}
		,{name : 'riesgoAutorizado', type:'float', sortType:Ext.data.SortTypes.asFloat}        
        ,{name : 'dispuestoVencido', type:'float', sortType:Ext.data.SortTypes.asFloat}        
        ,{name : 'dispuestoNoVencido', type:'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name : 'riesgoDispuesto', type:'float', sortType:Ext.data.SortTypes.asFloat}        
	]);
	
	//utilizamos implicitamente el mismo flow que ha cargado el grid, si no, le pasar�amos flow : 'admin/listadoUsuarios'
	var clientesStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,remoteSort : true
		,loading:false
		,flow:'clientes/listadoClientesData'
		<sec:authorize ifAllGranted="ROLE_PROVEEDOR_SOLVENCIA">
			,flow:'clientes/listadoClientesProvSolvenciaData'
		</sec:authorize>
		,reader: new Ext.data.JsonReader({
	    	root : 'personas'
	    	,totalProperty : 'total'
	    }, Cliente)
	});
	
	clientesStore.on('beforeload',function(){
			panelFiltros.collapse(true);	
			maskAll();
		});
	
	
	
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
	
	var filtroApellidos=new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.apellidos" text="**Apellidos" />'
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
	 
	var filtroContrato = new Ext.form.TextField({
		fieldLabel:'<s:message code="menu.clientes.listado.filtro.contrato" text="**Nro. Contrato" />'
		,enableKeyEvents: true
		,style : 'margin:0px'
		,maxLength:50 
		,listeners : {
			keypress : function(target,e){
					if(e.getKey() == e.ENTER) {
      					buscarFunc();
  					}
  				}
		}
		,allowNegative:false
		,allowDecimals:false
		//,autoCreate : {tag: "input", type: "text",maxLength:"50", autocomplete: "off"}
	});
	
	var filtroSolvenciaRevisada = new Ext.form.Checkbox({
		fieldLabel:'Solvencia completada'
		,name:'filtroSolvenciaRevisada'
		,style : 'margin:0px'
	
	})
	
	var filtroSolvenciaRevisada_dict = {"diccionario":[{"codigo":"T","descripcion":"---"},{"codigo":"SI","descripcion":"S�"},{"codigo":"NO","descripcion":"No"}]}; 

	var filtroSolvenciaRevisada_Store = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : filtroSolvenciaRevisada_dict
	});
	
	var filtroSolvenciaRevisada = new Ext.form.ComboBox({
				store:filtroSolvenciaRevisada_Store
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel:'Solvencia completada'
				

	});
	
	var TipoConcurso = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var optionsConcursoStore = page.getStore({
	       flow: 'cliente/getListTipoConcursoData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoConcursos'
	    }, TipoConcurso)	       
	});

	var comboTipoConcurso = new Ext.form.ComboBox({
		store:optionsConcursoStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'remote'
		,forceSelection: true
		,editable: false
		,emptyText:'---'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.mejoras.clientes.cmbTipoConcurso" text="**Concurso" />'
	});
	
	var filtroClientesCarterizados = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.mejoras.clientes.checkClientesCarterizada" text="**Mis Clientes Carterizados" />'
		,name:'filtroClientesCarterizados'
		,style : 'margin:0px'
		<sec:authorize ifAllGranted="BUSCADOR_CLIENTES_CARTERIZADO">
		,hidden : true
		</sec:authorize>
	
	})
	
	var validarForm = function(){
		 <sec:authorize ifAllGranted="ROLE_PROVEEDOR_SOLVENCIA">
		 	return true;
		 </sec:authorize>	
		if (tabDatos){ 
			if (filtroNombre.getValue().trim() != ''){
				return true;
			}
			if (filtroApellidos.getValue() != '' ){
				return true;
			}
			if (comboSegmentos.getValue() != '' ){
				return true;
			}
			if (filtroNif.getValue() != '' ){
				return true;
			}
			if (filtroCodCli.getValue() != '' ){
				return true;
			}
			if (comboTipoPersona.getValue() != '' ){
				return true;
			}
			if (comboTiposProductoEntidad.getValue() != ''){
				return true;
			}
			if (chkPrimerTitular.getValue() != '' ){
				return true;
			}
		}
		if (tabRiesgos){
			if (filtroContrato.getValue() != '' ){
				return true;
			}
			if (comboTipoRiesgo.getValue() != '' ){
				return true;
			}
			if (mmRiesgoTotal.min.getValue()!= '' ){
				return true;
			}
			if (mmRiesgoTotal.max.getValue()!= '' ){
				return true;
			}
			if (mmSVencido.min.getValue()!= '' ){
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
		}
		if (tabGestion){
			if (comboEstados.getValue()!= '' ){
				return true;
			}
			if (comboEstadosFinancieros.getValue()!= '' ){
				return true;
			}
			if (comboEstadosFinancierosContrato.getValue()!= '' ){
				return true;
			}
			if (comboColectivoSingular.getValue()!= '' ){
				return true;
			}
			if (comboNominaPension.getValue()!= '' ){
				return true;
			}
			if (comboPropietario.getValue()!= '' ){
				return true;
			}
			if (comboZonas.getValue()!= '' ){
				return true;
			}
			if (comboIntervencion.getValue() != '' ){
				return true;
			}
			if (comboJerarquia.getValue()!= '' ){
				return true;
			}
			if (comboGestion.getValue()!='') {
				return true;
			}			
		}	
		return false;	
	}
	
	var validaMinMax = function(){
		if (tabRiesgos){
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
	}
	
	
	var limiteClientes = Ext.data.Record.create([
		     {name : 'codigoResultado' }
		     ,{name : 'mensajeError' }
		     ,{name : 'nResultados' }
		]);
	
		
	var limiteClientesStore = page.getStore({
			flow : 'plugin.mejoras.clientes.superaLimiteExport'
			,reader: new Ext.data.JsonReader({
		    	root : 'resultados'
		    }, limiteClientes)
		});

	
	var codigoOk = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_OK" />';
	var codigoError = '<fwk:const value="es.capgemini.pfs.utils.ObjetoResultado.RESULTADO_ERROR" />';

	limiteClientesStore.on('load', function(){
		var rec = limiteClientesStore.getAt(0);
		var codigoResultado = rec.get('codigoResultado');

		if (codigoResultado == codigoError)
		{
			var mensaje = rec.get('mensajeError');
			busquedaClientesMask.hide();
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>',mensaje);
			return;
		}
		else if (codigoResultado == codigoOk)
		{
	        var flow='clientes/plugin.mejoras.clientes.exportClientes';
			var params= getParametros();
            params.REPORT_NAME='busqueda.pdf';
            <sec:authorize ifAllGranted="ROLE_PROVEEDOR_SOLVENCIA">
				var flow='clientes/plugin.mejoras.clientes.exportClientesSolvencias';
			</sec:authorize>
            app.openBrowserWindow(flow,params);
		}
		busquedaClientesMask.hide();
	});
	
	
	
	var buscarFunc = function(){
		if (validarForm()){
			if (validaTipoIntervencion()) {
				if (validaZonaJerarquia()) {
					if (validaMinMax()){
						panelFiltros.collapse(true);	
		                var params= getParametros();
		                params.start=0;
		                params.limit=limit;
		                clientesStore.webflow(params);
						//Cerramos el panel de filtros y esto har� que se abra el listado de clientes
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="validaciones.dblText.minMax"/>');
					}
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.zonaIntervencion"/>');
				}	
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.tipoIntervencion"/>');
			}
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="menu.clientes.listado.criterios"/>');
		}
	};
	
	
	var validaTipoIntervencion = function() {
		if (!tabGestion)
			return true;
			 
		if (comboIntervencion.getValue() == '' && comboJerarquia.getValue() == '')
			return true;

		if (comboIntervencion.getValue() != '' && comboJerarquia.getValue() != '')
			return true;

		return false;
	}
    
	var validaZonaJerarquia = function() {
		if (!tabGestion)
			return true; 	

		if (comboJerarquia.getValue() == '' && comboZonas.getValue() == '')
			return true;

		if (comboJerarquia.getValue() != '' && comboZonas.getValue() != '')
			return true;

		return false;
	}
   

    var getParametros = function() {
    	var p ={};
    	if (tabDatos){
    		p.nombre=filtroNombre.getValue();
    		p.apellidos=filtroApellidos.getValue();
    		p.segmento=comboSegmentos.getValue();
    		p.docId=filtroNif.getValue();
    		p.codigoEntidad=filtroCodCli.getValue();
    		p.tipoPersona=comboTipoPersona.getValue();
    		p.tipoProductoEntidad=comboTiposProductoEntidad.getValue();
    		p.isPrimerTitContratoPase=chkPrimerTitular.getValue();
    	}
    	if (tabRiesgos){
    		p.nroContrato=filtroContrato.getValue();
    		p.tipoRiesgo=comboTipoRiesgo.getValue();
    		p.minRiesgoTotal=mmRiesgoTotal.min.getValue();
            p.maxRiesgoTotal=mmRiesgoTotal.max.getValue();
            p.minSaldoVencido=mmSVencido.min.getValue();
            p.maxSaldoVencido=mmSVencido.max.getValue();
            p.minDiasVencido=mmDVencido.min.getValue();
            p.maxDiasVencido=mmDVencido.max.getValue();
    	}
    	if (tabGestion){
    		p.situacion=comboEstados.getValue();
            p.situacionFinanciera=comboEstadosFinancieros.getValue();
            p.situacionFinancieraContrato=comboEstadosFinancierosContrato.getValue();
            p.codigoColectivoSingular =comboColectivoSingular.getValue();
			p.nominaPension =comboNominaPension.getValue();
			p.propietario =comboPropietario.getValue();
			p.codigoZona=comboZonas.getValue();
    		p.tipoIntervercion=comboIntervencion.getValue();			
			p.jerarquia=comboJerarquia.getValue();
			p.codigoGestion=comboGestion.getValue();			
    	}
    	return p;
    }
	
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

	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;

	<%--*************PESTA�A DE DATOS DEL CLIENTE***************************************** --%>
	
	var tabDatos=false;
	var filtrosTabDatosCliente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.clientes.busqueda.datosGenerales" text="**Datos del cliente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroCodCli, filtroNombre,filtroApellidos,comboTiposProductoEntidad<c:if test="${isGestionVencidos || isGestionSeguimientoSistematico || isGestionSeguimientoSintomatico}">,chkPrimerTitular</c:if>]
				},{
					layout:'form'
					,items: [filtroNif,comboTipoPersona, comboSegmentos]
				}]
	});
	filtrosTabDatosCliente.on('activate',function(){
		tabDatos=true;
	});
	<%--*************PESTA�A DE RIESGOS DEL CLIENTE***************************************** --%>
	
	var tabRiesgos=false;
	var filtrosTabRiesgoCliente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.clientes.busqueda.riesgos" text="**Riesgos del cliente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [fieldSetRiesgos ]
				},{
					layout:'form'
					,items: [filtroContrato]
				}]
	});
	filtrosTabRiesgoCliente.on('activate',function(){
		tabRiesgos=true;
	});
	<%--*************PESTA�A GESTI�N ***************************************** --%>
	
	var tabGestion=false;
	var filtrosTabGestion = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.clientes.busqueda.gestion" text="*Gesti�n" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboEstados,comboGestion,comboEstadosFinancieros, comboColectivoSingular, comboNominaPension]
				},{
					layout:'form'
					,items: [comboEstadosFinancierosContrato<c:if test="${!isGestionVencidos  && !isGestionSeguimientoSistematico && !isGestionSeguimientoSintomatico}">,comboIntervencion</c:if>, comboJerarquia, comboZonas, comboPropietario]
				}]
	});
	filtrosTabGestion.on('activate',function(){
		tabGestion=true;
	});
	<%--*************************************************************************************
	*************TABPANEL QUE CONTIENE TODAS LAS PESTA�AS****************************************
	**************************************************************************************** --%>
	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosTabDatosCliente, filtrosTabRiesgoCliente , filtrosTabGestion]
		,id:'idTabFiltrosContrato'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});
	
	<%-- sustituimos filtroForm por panel filtros --%>
	var panelFiltros = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,title : '<s:message code="menu.clientes.listado.filtro.filtrodeclientes" text="**Filtro de clientes" />'
			,titleCollapse:true
			,collapsible:true
			<%--,tbar : [btnBuscar,btnClean,btnExportarXls,'->', app.crearBotonAyuda()] --%>
			,tbar : [buttonsL,'->', buttonsR,app.crearBotonAyuda()]
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
			,{header : '<s:message code="menu.clientes.listado.lista.apellidos" text="**Apellidos" />'
			, dataIndex : 'apellidos' ,sortable:true,width:200}
			<%-- 
			,{header : '<s:message code="menu.clientes.listado.lista.apellido1" text="**Apellido1" />'
			, dataIndex : 'apellido1' ,sortable:true,width:100}
			,{header : '<s:message code="menu.clientes.listado.lista.apellido2" text="**Apellido2" />'
			, dataIndex : 'apellido2',sortable:true,width:120}--%>
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
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.riesgoAutorizado" text="**Riesgo autorizado"/>'
			, dataIndex : 'riesgoAutorizado',sortable:true,renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoVencido" text="**Dispuesto vencido" />'
			, dataIndex : 'dispuestoVencido',sortable:false,renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.volRiesgoDirectoNoVencido" text="**Dispuesto no vencido" />'
			, dataIndex : 'dispuestoNoVencido',sortable:true,renderer: app.format.moneyRenderer, width:100, align:'right', hidden:true}
			,{header : '<s:message code="menu.clientes.consultacliente.datosTab.riesgoDispuesto" text="**Riesgo dispuesto"/>'
			, dataIndex : 'riesgoDispuesto',sortable:false,renderer: app.format.moneyRenderer, width:100, align:'right', hidden:true}
			<%--
			,{header : '<s:message code="menu.clientes.listado.lista.totaldeuda" text="**Total Deuda Irregular" />'
			, dataIndex : 'deudaIrregular',sortable:true,renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.totalsaldo" text="**Total Saldo" />'
			, dataIndex : 'totalSaldo',sortable:true, renderer: app.format.moneyRenderer, width:100, align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirecto" text="**riesgo Directo" />'
			, dataIndex: 'deudaDirecta',sortable:true, renderer: app.format.moneyRenderer,align:'right'}
			,{header : '<s:message code="menu.clientes.listado.lista.riesgoDirectoDaniado" text="**RDD" />',hidden:true
			, dataIndex: 'riesgoDirectoNoVencidoDanyado',sortable:true, renderer: app.format.moneyRenderer,align:'right'}
			--%>
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
            ,{header : '<s:message code="menu.clientes.listado.lista.fechaDato" text="**Fecha dato" />', dataIndex: 'fechaDato', sortable:false}
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
	grid.loadMask=false;

	clientesStore.on('load', function(){
		grid.setTitle('<s:message code="menu.clientes.listado.lista.title" text="**Clientes" arguments="'+clientesStore.getTotalCount()+'"/>');
		panelFiltros.collapse(true);	
		unmaskAll();
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
				,items : [panelFiltros]
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
    
	
	//a�adimos al padre y hacemos el layout
	page.add(compuesto);  
	
	Ext.onReady(function(){
		//si entramos por gesti�n de vencidos, el combo se seleccionar� con el valor de gesti�n de vencidos autom�ticamente, 
	//y la carga inicial ser� con este filtro
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
	}); 

</fwk:page>
