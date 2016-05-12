<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>

	var style='margin-bottom:1px;margin-top:1px;width:250px';
	var labelStyle='font-weight:bolder;margin-bottom:1px;margin-top:1px;';
	var labelStyle2='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:30px';
	
	var cambioGestor=false;
	var cambioSupervisor=false;
	var esGestor=false;
	
	<c:if test="${asuntoEditar!=null}" >
		var idAsunto = ${asuntoEditar.id};
	</c:if>
	
	var porUsuario = false;
	var adicional = false;
	var procuradorAdicional = false;
	<sec:authorize ifAllGranted="ASU_GESTOR_SOLOPROPIAS">
		porUsuario = true;
		<sec:authorize ifAllGranted="ASU_GESTOR_SOLOPROPIAS_ADIC">
		 adicional = true;
		</sec:authorize>
		<sec:authorize ifAllGranted="ASU_PROCURADOR_SOLOPROPIAS_ADIC">
		 procuradorAdicional = true;
		</sec:authorize>
	</sec:authorize>
	
	var ugCodigo = '3';
	var gestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idGestor'}
		,{name:'usuarioId'}
		,{name:'usuario'}
		,{name:'tipoGestorId'}
		,{name:'tipoGestorDescripcion'}
		,{name:'tipoDespachoId'}
		,{name:'fechaDesde'}
		,{name:'fechaHasta'}
		,{name: 'tipoVia'}
		,{name: 'domicilio'}
		,{name: 'domicilioPlaza'}
		,{name: 'telefono1'}
		,{name: 'email'}
		
		
    ]);
    
    var gestorStore = page.getStore({
		event:'listado'
		,storeId : 'idGestorStore'
		,flow:'extasunto/getGestoresAdicionalesAsunto'
		,reader : new Ext.data.JsonReader({root:'gestor',totalProperty : 'total'}, gestor)
	});
	
	var coloredRender = function (value, meta, record) {
		/*
		if (meta.id==5 || meta.id==6) { //Columnas de fechas
			var formateadorFecha = Ext.util.Format.dateRenderer('d/m/Y');
			value = formateadorFecha(value);
		}
		
		var fechaHasta = record.get('fechaHasta');
		if (fechaHasta){
			return '<span style="color: #CC6600; font-weight: bold;">'+value+'</span>';
			//return value;
		}
		else {
		*/
			return '<span style="color: #4169E1; font-weight: bold;">'+value+'</span>';
		/*
		}
		return value;
		*/
	};	
	
	var dateColoredRender = function (value, meta, record) {
		<%--var valor = app.format.dateRenderer(value, meta, record); --%>
		return coloredRender(value, meta, record);
	};	
		
	var gestorCM  = new Ext.grid.ColumnModel([
        {header: 'Id',sortable: false, dataIndex: 'id', hidden:'true'}
        ,{header: 'IdGestor',sortable: false, dataIndex: 'idGestor', hidden:'true'}
        ,{header: '<s:message code="plugin.coreextension.multigestor.descripcion" text="**Descripcion" />',sortable: false, dataIndex: 'tipoGestorDescripcion',width:100, renderer: coloredRender}
        ,{header: '<s:message code="plugin.coreextension.multigestor.usuario" text="**Usuario" />',sortable: false, dataIndex: 'usuario',width:150, renderer: coloredRender}
        ,{header: 'TipoGestorId', sortable: false, dataIndex: 'tipoGestorId', hidden:'true'}
        ,{header: 'Desde',sortable: false, dataIndex: 'fechaDesde', hidden: 'true'}       
		,{header: 'Hasta',sortable: false, dataIndex: 'fechaHasta', hidden: 'true'}
		,{header: 'TipoVia',sortable: false, dataIndex: 'tipoVia', hidden: 'true'}
		,{header: '<s:message code="plugin.coreextension.multigestor.domicilio" text="**Domicilio" />',sortable: false, dataIndex: 'domicilio',width:150, renderer: coloredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.localidad" text="**Localidad" />',sortable: false, dataIndex: 'domicilioPlaza',width:100, renderer: coloredRender}
		,{header: '<s:message code="plugin.coreextension.multigestor.telefono" text="**Teléfono" />',sortable: false, dataIndex: 'telefono1',width:50, renderer: coloredRender} 
		,{header: 'eMail',sortable: false, dataIndex: 'email', hidden: 'true'}      
    ]);

    var recargar = function(){
    	<c:if test="${asuntoEditar!=null}" >
			gestorStore.webflow({idAsunto: idAsunto});
		</c:if>
	}	
	
	<c:if test="${asuntoEditar!=null}" >
		recargar();
	</c:if>
	
	<c:if test="${cambioGestor!=null}">
		cambioGestor=true;
	</c:if> 
	<c:if test="${cambioSupervisor!=null}">
		cambioSupervisor=true;
	</c:if> 
	
	var listTiposGestorAsuntoUsuarioLogado = [
	    <c:if test="${listTiposGestorAsuntoUsuarioLogado!=null}">	
	    	<c:forEach items="${listTiposGestorAsuntoUsuarioLogado}" var="lista" varStatus="loop">
	     	   "${lista.codigo}" ${!loop.last ? ',' : ''}
	   		</c:forEach>  
        </c:if>  
     ];
	
	var soyDeEsteTipoGestor=function(strCodTipogestor){
	    var bReturn = false;
	    var i;	    	    	 	    	    	    	
	        
	    for (i=0; i<=(listTiposGestorAsuntoUsuarioLogado.length-1); i++)
	    {	    
	    	if(listTiposGestorAsuntoUsuarioLogado[i] == strCodTipogestor)
	    	{
	    	    bReturn = true;
	    	    break;
	    	}	    	
	    }	
		    
	    <c:if test="${listTiposGestorAsuntoUsuarioLogado==null}">
		    bReturn = true;
	    </c:if>		    	       	   
	        	    
	    <sec:authorize ifAllGranted="CAMBIAR-GESTORHP">    	       	   
	    	    bReturn = true;
 	    </sec:authorize>	        	    
	        	    
	    return bReturn;
	};

	// Sergio, los supervisores pueden cambiar el despacho cex
	if (soyDeEsteTipoGestor("SUP")) {
		listTiposGestorAsuntoUsuarioLogado[listTiposGestorAsuntoUsuarioLogado.length] = 'SUPCEXP';
	}
	if (soyDeEsteTipoGestor("SUPCEXP")) {
		listTiposGestorAsuntoUsuarioLogado[listTiposGestorAsuntoUsuarioLogado.length] = 'SUP';
	}
	// Fin sergio

    var getStrTipoDespacho=function(){
        var strTipoDespacho = "";
        
        if(!cambioGestor && !cambioSupervisor)
            strTipoDespacho = "COMITE";
        else
        {
	    	if(soyDeEsteTipoGestor("<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO" />") || soyDeEsteTipoGestor("<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR" />")) 
	    	    strTipoDespacho =  '<fwk:const value="es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO" />';  	
	    	else if(soyDeEsteTipoGestor("<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP" />") || soyDeEsteTipoGestor("<fwk:const value="es.capgemini.pfs.multigestor.model.EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP" />"))
	    	    strTipoDespacho =  '<fwk:const value="es.pfsgroup.plugin.recovery.mejoras.PluginMejorasCodigosConstants.CODIGO_DESPACHO_CONFECCION_EXPEDIENTE" />';
    	}    
    	
    	return strTipoDespacho; 
    } 					
			
    // Emilio Fin	
    	
	
	var txtNombreAsunto = app.creaText('asunto',
		'<s:message code="edicionAsunto.asunto" text="**Asunto" />',
		<c:if test="${asuntoEditar!=null}" >
			'<s:message text="${asuntoEditar.nombre}" javaScriptEscape="true" />',
		</c:if>
		<c:if test="${asuntoEditar==null}" >
			'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />',
		</c:if>
		{style:style,labelStyle:labelStyle,disabled:cambioGestor||cambioSupervisor});
		
	/*Jerarquía*/
	var zonas=<app:dict value="${zonas}" />;
	
	var listaJerarquia = <fwk:json>
							<json:array name="jerarquia" items="${niveles}" var="s">
								<json:object>
									<json:property name="id" value="${s.id}" />
									<json:property name="descripcion" value="${s.descripcion}" />
								</json:object>
							</json:array>
						</fwk:json>;
	
	<pfsforms:combo name="comboJerarquia" 
		dict="listaJerarquia" 
		displayField="descripcion" 
		root="jerarquia" 
		labelKey="menu.clientes.listado.filtro.jerarquia"
		label="**Jerarquia"
		value="0" 
		valueField="id"
		labelStyle="font-weight:bolder;"
		 />
		
	comboJerarquia.disabled=cambioGestor||cambioSupervisor;	
	
	<%-- Creamos el combo tipo de asunto --%>
	var listaTiposDeAsunto = <fwk:json>
						<json:array name="tipoAsunto" items="${tiposDeAsunto}" var="tasu">
							<json:object>
								<json:property name="id" value="${tasu.id}" />
								<json:property name="descripcion" value="${tasu.descripcion}" />
							</json:object>
						</json:array>
					</fwk:json>;
	
	<pfsforms:combo name="tipoDeAsunto" 
		dict="listaTiposDeAsunto" 
		displayField="descripcion" 
		root="tipoAsunto" 
		labelKey="expedientes.nuevo.asunto.tipo.asunto"
		label="**Tipo de asunto"
		value="0" 
		valueField="id"
		labelStyle="font-weight:bolder;"
		 />
		 
	tipoDeAsunto.setValue("${asuntoEditar.tipoAsunto.id}");	 
	
	<%-- Fin creacion combo tipo de asunto  --%>
	
	
		var insertarFunctionAutomatica= function(listados){
			var lonlistadoGestores= listados.listadoGestores.length;
			var lonlistadoDespachos= listados.listadoDespachos.length;
			var lonlistadoUsuarios= listados.listadoUsuarios.length;
			if(lonlistadoGestores == lonlistadoDespachos && lonlistadoDespachos == lonlistadoUsuarios && lonlistadoUsuarios>0){
				for(var i=0; i<=listados.listadoGestores.length-1; i++){
					var nuevoGestorRecord = new gestor();
					nuevoGestorRecord.data.tipoGestorId = listados.listadoGestores[i].id;
					nuevoGestorRecord.data.tipoGestorDescripcion = listados.listadoGestores[i].descripcion; 
					nuevoGestorRecord.data.usuarioId = listados.listadoUsuarios[i].id;
					nuevoGestorRecord.data.usuario = listados.listadoUsuarios[i].username;
					//nuevoGestorRecord.data.fechaDesde = new Date();
					
					//var tipoDespachoRec = comboTipoDespacho.getStore().getById(comboTipoDespacho.getValue()).data;
				
					nuevoGestorRecord.data.tipoDespachoId = listados.listadoDespachos[i].cod;
						
					nuevoGestorRecord.data.domicilio = listados.listadoDespachos[i].domicilio;
					nuevoGestorRecord.data.domicilioPlaza = listados.listadoDespachos[i].localidad;
					nuevoGestorRecord.data.telefono1 = listados.listadoDespachos[i].telefono;
					
					if(!tipoInsertado(listados.listadoGestores[i].id)){
						if(indexGestor(listados.listadoGestores[i].id,listados.listadoDespachos[i].cod,listados.listadoUsuarios[i].id)==-1){
							gestorStore.add(nuevoGestorRecord);
						}
						else {
							Ext.Msg.show({
								title:'Atención: Operación no válida',
								msg: 'Este usuario ya existe agregado como gestor',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING});
						}					
					}
					else {
						Ext.Msg.show({
							title:'Atención: Operación no válida',
							msg: 'Ya existe otro usuario con el mismo tipo de gestor',
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.WARNING});		
					}
				}
			
			}
			
	
		};
	
	
	tipoDeAsunto.on('select', function(){
		var idExpediente= ${idExpediente};
    	if(tipoDeAsunto.getValue() == 1){
	    	if(gestorStore.data.length>0){
	    		gestorStore.removeAll();
	    	}
	    	page.webflow({
				flow: 'coreextension/getListUsuariosDefectoByTipoAsunto'
				,params:{'idTipoAsunto': '01', 'idExpediente': idExpediente} 
				,success: function (result, request){
					insertarFunctionAutomatica(result);
				}
				,failure : function(result,request){
                    Ext.getCmp('Error en la carga automática de gestores');
                 }
			});	
    	}
    	
    	else if(tipoDeAsunto.getValue() == 2){
    		if(gestorStore.data.length>0){
	    		gestorStore.removeAll();
	    	}
	    	page.webflow({
				flow: 'coreextension/getListUsuariosDefectoByTipoAsunto'
				,params:{'idTipoAsunto': '02', 'idExpediente': idExpediente} 
				,success: function (result, request){
					insertarFunctionAutomatica(result);
				}
				,failure : function(result,request){
                    Ext.getCmp('Error en la carga automática de gestores');
                 }
			});	
    	}
    	
    	else if(tipoDeAsunto.getValue() == 21){
    		if(gestorStore.data.length>0){
	    		gestorStore.removeAll();
	    	}
	    	page.webflow({
				flow: 'coreextension/getListUsuariosDefectoByTipoAsunto'
				,params:{'idTipoAsunto': '21', 'idExpediente': idExpediente} 
				,success: function (result, request){
					insertarFunctionAutomatica(result);
				}
				,failure : function(result,request){
                    Ext.getCmp('Error en la carga automática de gestores');
                 }
			});	
    	}
    	
    });
    

    var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'clientes/buscarAllZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
    
    
	var comboZonas = app.creaDblSelect(zonas, '<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',{store:optionsZonasStore, funcionReset:recargarComboZonas,disabled:cambioGestor||cambioSupervisor,labelStyle:labelStyle2});

	comboZonas.on('change',function(){
		if (comboTipoGestor.getValue()!='' && comboZonas.getValue()!='') {
			recargarDespachos();
		} else {
			if (comboZonas.getValue()=='') {
				comboTipoDespacho.reset();
				comboTipoUsuario.reset();
				comboTipoDespacho.setDisabled(true);
				comboTipoUsuario.setDisabled(true);
			}
		}
	});
	
	var recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
			comboZonas.setValue('');
			optionsZonasStore.removeAll();
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([comboZonas]);
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
	
	recargarComboZonas();
	
	var tipoGestor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsGestorStore = page.getStore({
	       flow: 'coreextension/getListTipoGestorAdicionalData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoGestores'
	    }, tipoGestor)	       
	});
	var tituloTipoGestor = new Ext.form.Label({
   		text:'<s:message code="menu.clientes.filtrado.tipoGestor" text="**Tipo gestor: " />'
		,style:'font-size:11'
	}); 
	var comboTipoGestor = new Ext.form.ComboBox({
		store:optionsGestorStore
		,displayField:'descripcion'
		,valueField:'id'
		//,disabled:true
		,editable: false
		,mode: 'remote'
		,forceSelection: true
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoGestor" text="**Tipo gestor" />'
	});	
	
	var tipoDespacho = Ext.data.Record.create([
		 {name:'cod'}
		,{name:'descripcion'}
		,{name:'domicilio'}
		,{name:'localidad'}
		,{name:'telefono'}
	]);
	
	var optionsDespachoStore = page.getStore({
	       flow: 'coreextension/getListTipoDespachoData'
	       //flow: 'asuntos/buscarDespachosPorZonaTipoGestor'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoDespachos'
	    	 ,idProperty: 'cod'
	    }, tipoDespacho)	       
	});
	var tituloDespacho = new Ext.form.Label({
   		text:'<s:message code="menu.clientes.filtrado.despacho" text="**Despacho: " />'
		,style:'font-size:11'
	}); 	
	var comboTipoDespacho = new Ext.form.ComboBox({
		store:optionsDespachoStore
		,displayField:'descripcion'
		,valueField:'cod'
		,mode: 'remote'
		,disabled:true
		,forceSelection: true
		,editable: false
		,emptyText:'Seleccionar'
		,triggerAction: 'all'
		,fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoDespacho" text="**Tipo despacho" />'
	});	
	
	var tipoUsuario = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	
	var optionsUsuarioStore = page.getStore({
	       flow: 'coreextension/getListUsuariosPaginatedData'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, tipoUsuario)	       
	});
	var tituloUsuario = new Ext.form.Label({
   		text:'<s:message code="menu.clientes.filtrado.usuario" text="**Usuario: " />'
		,style:'font-size:11'
	}); 	
	var comboTipoUsuario = new Ext.form.ComboBox ({
		store:  optionsUsuarioStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		disabled:true,
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbUsuario" text="**Usuario" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});
	
	comboTipoUsuario.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	

	var recargarDespachos = function() {
		comboTipoUsuario.reset();
		comboTipoDespacho.reset();
		
		<%-- if (comboZonas.getValue()!='') {
			optionsDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue(), 'zonas': comboZonas.getValue()}); 
			comboTipoDespacho.setDisabled(false);
		} else {
			comboTipoDespacho.setDisabled(true);
			Ext.Msg.show({
				title:'Zonas',
				msg: 'Debe seleccionar una zona para ver los correspondientes despachos.',
				buttons: Ext.Msg.OK,
				icon:Ext.MessageBox.WARNING});			
		} --%>
		
		if (comboTipoGestor.getValue()!='') {
			optionsDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue()}); 
			comboTipoDespacho.setDisabled(false);
		} else {
			comboTipoDespacho.setDisabled(true);
			Ext.Msg.show({
				title:'Zonas',
				msg: 'Debe seleccionar un tipo gestor.',
				buttons: Ext.Msg.OK,
				icon:Ext.MessageBox.WARNING});			
		}
		
		comboTipoUsuario.setDisabled(true);
	}

	comboTipoGestor.on('select', function(){
		recargarDespachos();		
	});
	
	comboTipoDespacho.on('select', function(){

		optionsUsuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue()}); 
		comboTipoUsuario.reset();		
		comboTipoUsuario.setDisabled(false);
	});	
	
	
	var validar = function(){
	
		if(comboTipoDespacho.getValue()==''){
			return false;
		}	
		if(comboTipoGestor.getValue()==''){
			return false;
		}	
		if(comboTipoUsuario.getValue()==''){
			return false;
		}
		return true;
	};
	
	
	
	var resetCombos = function(){
		comboTipoDespacho.reset();
		comboTipoUsuario.reset();
		comboTipoGestor.reset();
		
		comboTipoDespacho.setDisabled(true);
		comboTipoUsuario.setDisabled(true);
		comboTipoGestor.setValue('');
	}; 
	
	comboZonas.hidden= true;
	comboJerarquia.hidden= true;
	
	var insertar = new Ext.Button({
		text:'<s:message code="app.agregar" text="**Agregar" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
		//,disabled:true
		,handler:function(){
			
			if(validar()){
				usuario = optionsUsuarioStore.getById(comboTipoUsuario.getValue());
				insertarFunction(usuario.data);
			}else{
				Ext.Msg.show({
					title:'Atención: Operación no válida',
					msg: 'Tipo gestor, Despacho y Usuario son datos obligatorios.',
					buttons: Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING});
			}
		}
	});

	var indexGestor = function(idTipoGestor,idTipoDespacho,idUsuario) {
		return match = gestorStore.findBy(function(record, id) {
			if (record.get('tipoGestorId')==idTipoGestor
				&& record.get('tipoDespachoId')==idTipoDespacho
				&& record.get('usuarioId') == idUsuario)
					return true;
		});
	}
	
	var tipoInsertado = function(idTipoGestor) {
		if (gestorStore.find('tipoGestorId', idTipoGestor)==-1) {
			return false;
		} else {
			return true;
		}
	}


	var insertarFunction = function(usuario){
		//Comprobamos que no este ya insertado este tipo gestor
		if (!tipoInsertado(comboTipoGestor.getValue())) {
			//Comprobamos que el usuario no está ya en la grid
			if (indexGestor(comboTipoGestor.getValue(), comboTipoDespacho.getValue(), usuario.id)==-1) {
				//Insertamos los datos que tenemos en el record de la grid
				var nuevoGestorRecord = new gestor();
				nuevoGestorRecord.data.tipoGestorId = comboTipoGestor.getValue();
				nuevoGestorRecord.data.tipoGestorDescripcion = comboTipoGestor.getRawValue(); 
				nuevoGestorRecord.data.usuarioId = usuario.id;
				nuevoGestorRecord.data.usuario = usuario.username;
				//nuevoGestorRecord.data.fechaDesde = new Date();
				
				var tipoDespachoRec = comboTipoDespacho.getStore().getById(comboTipoDespacho.getValue()).data;
				
				nuevoGestorRecord.data.tipoDespachoId = tipoDespachoRec.cod;
				
				nuevoGestorRecord.data.domicilio = tipoDespachoRec.domicilio;
				nuevoGestorRecord.data.domicilioPlaza = tipoDespachoRec.localidad;
				nuevoGestorRecord.data.telefono1 = tipoDespachoRec.telefono;
				
				gestorStore.add(nuevoGestorRecord);
				
			} else {
				Ext.Msg.show({
					title:'Atención: Operación no válida',
					msg: 'Este usuario ya existe agregado como gestor',
					buttons: Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING});
			}
		} else {
			Ext.Msg.show({
				title:'Atención: Operación no válida',
				msg: 'Ya existe otro usuario con el mismo tipo de gestor',
				buttons: Ext.Msg.OK,
				icon:Ext.MessageBox.WARNING});		
		}
	}; 
	
	var findGestoresPanel = new Ext.Panel({
		layout:'table'
		,layoutConfig:{columns:2,tableAttrs:{style:'border-spacing:5px'}}
		,autoHeight:true	
		,title: '<s:message code="menu.clientes.filtrado.findGestores" text="**Modificar Gestores" />'
		,collapsible: false
		,items: [
		
		
				tituloTipoGestor,comboTipoGestor
				,tituloDespacho,comboTipoDespacho
				,tituloUsuario,comboTipoUsuario ]
		,bbar: [insertar]
	});
	
	var borrar = new Ext.Button({
		text : '<s:message code="app.borrar" text="**borrar" />'
		,iconCls : 'icon_menos'
		,cls: 'x-btn-text-icon'
		,disabled:true
		,handler:function(){
				borrarFunction();
				borrar.setDisabled(true);
		}
	}); 
	
	 var grid = new Ext.grid.GridPanel({
		title:'<s:message code="plugin.coreextension.multigestor.gridGestores.titulo" text="**Lista gestores" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_bienes'
       ,height: 200
	   //,width:100
	   ,autoWidth:false
	   ,store: gestorStore
	   ,cm:gestorCM
	   ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	   ,collapsible :false
	   //,resizable:true
	   ,viewConfig : {  forceFit : true}
	   ,monitorResize: true
	   	 <sec:authorize ifAllGranted="EDIT_GESTORES">
	   ,bbar:[borrar] 
		</sec:authorize>
	   
	});
	
	 grid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
   		borrar.setDisabled(false);
	  }); 
	
	 grid.getSelectionModel().on('rowdeselect', function(sm, rowIndex, r) { 
   		borrar.setDisabled(true);
	  }); 	
	
	
	var idGestorBorrado=  '';
	var idTipoGestorBorrado=  '';
	var borrarFunction=function(){
		var gestorSel = grid.getSelectionModel().getSelected();
		if (gestorSel) {
			idGestorBorrado=  gestorSel.get('idGestor') + ',' + idGestorBorrado ;
			idTipoGestorBorrado= gestorSel.get('tipoGestorId') + ',' + idTipoGestorBorrado;
			grid.getStore().remove(gestorSel);
		}
	}; 	
	
	
	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,style:'font-weight:bolder; font-size:11'
	}); 
	
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,width:810
		//,hideLabel:true
		,height:100
		,labelSeparator:''
		,labelStyle:labelStyle
		,disabled:cambioGestor||cambioSupervisor
		<c:if test="${asuntoEditar!=null}" >
			,value:'<s:message text="${asuntoEditar.observacion}" javaScriptEscape="true" />'
		</c:if>	
		<app:test id="observaciones" addComa="true"/>	
	});
	
	var getGestoresId = function() {
		var resultado = '';
		for (key=0;key < gestorStore.data.length;key++) {
			var rec = gestorStore.data.items[key].data;
			
			resultado = resultado + '{tipoGestor:' + rec.tipoGestorId + ',tipoDespacho:' + rec.tipoDespachoId + ',usuarioId:' + rec.usuarioId + '};';
		}
		
		return resultado;
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				formPanel: panelAlta
				,eventName : 'saveAsunto'
				,params: {
					nombreAsunto:txtNombreAsunto.getValue()
                    <c:if test="${idExpediente!=null}" >
					   ,idExpediente:${idExpediente}
                    </c:if>     
					,observaciones:observaciones.getValue()
					<c:if test="${asuntoEditar!=null}" >
						,idAsunto: ${asuntoEditar.id}
					</c:if>
 					<c:if test="${codigoEstadoAsunto!=null}" >
                    	,codigoEstadoAsunto: '${codigoEstadoAsunto}'
                    </c:if>
                    ,listaGestoresId: Ext.encode(getGestoresId())
                    ,tipoDeAsunto: tipoDeAsunto.getValue()
                    ,idGestorBorrado: idGestorBorrado
                    ,idTipoGestorBorrado: idTipoGestorBorrado
                    				
				}
				,success :  function(){ 
                  				page.fireEvent(app.event.DONE);
                  			}
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});

	var panelAlta = new Ext.form.FormPanel({
		bodyStyle : 'padding-left:5px;padding-top:5px'
		,layout:'anchor'
		,autoHeight : true
		,defaults:{
			border:false
		}
		,items : [
		 	{ xtype : 'errorList', id:'errL' }
		 	,{
		 		autoHeight:true
		 		,border:false
		 		,defaults:{border:false,xtype:'fieldset',autoHeight:true}
		 		,items:[ 
		 			{
						layout:'table'
						,layoutConfig:{columns:3}
						,autoHeight:true
						,border:false
						,style:'padding-left:10px'
						,cellCls:'vtop'
						,width:900
						,defaults:{xtype:'fieldset',border:false,autoHeight:true}
						,items:[
							{
								items:[txtNombreAsunto,comboJerarquia,tipoDeAsunto]
							},{
								items:[comboZonas]
								,style:'padding:5px'
							}
						]
					}
					,{
						items:[findGestoresPanel]
					}
					,{
						items:[grid]
					}
		 			,{
						items:[observaciones]
						,labelAlign:'top'
					}
		 		]
		 	}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});

	page.add(panelAlta);

</fwk:page>