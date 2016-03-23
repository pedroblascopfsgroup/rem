<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

<%@ include file="/WEB-INF/jsp/plugin/mejoras/acuerdos/tabs/acuerdosGeneric.jsp" %>

   	function label(id,text){
		  return app.creaLabel(text,"",  {id:'entidad-asunto-'+id});
	 }
	 
	 var sinoRender = function (value, meta, record) {
		if(value){
			return 'Sí';
		} else {
			return 'No';
		}
	};
	
	var labelStyle='font-weight:bolder;width:150px';
  	var asunto = label('asunto', '<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>');
  	var codigoAsunto = label('codigoAsunto','<s:message code="asuntos.listado.codigo" text="**Codigo"/>');
  	var fecha = label('fecha', '<s:message code="asunto.tabcabecera.fechaconformacion" text="**Fecha Conformacion"/>');
  	var estado = label('estado', '<s:message code="asunto.tabcabecera.estado" text="**Estado"/>');
  	var codigoExterno = label('codigoExterno', '<s:message code="asunto.tabcabecera.codigoExterno" text="**codigoExterno"/>');
  	var propiedadAsunto = label('propiedadAsunto', '<s:message code="asunto.tabcabecera.propiedadAsunto" text="**propiedadAsunto"/>');
  	var gestionAsunto = label('gestionAsunto', '<s:message code="asunto.tabcabecera.gestionAsunto" text="**gestionAsunto"/>');
  	var despacho = label('despacho', '<s:message code="asunto.tabcabecera.despacho" text="**Despacho"/>');
  	var gestor = label('gestor', '<s:message code="asunto.tabcabecera.gestor" text="**Gestor"/>');
  	var supervisor = label('supervisor', '<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>');
  	var procurador = label('procurador', '<s:message code="asunto.tabcabecera.procurador" text="**Procurador"/>');
  	var expediente = label('expediente','<s:message code="expedientes.consulta.titulo" text="**Expediente"/>');
  	var comite = label('comite','<s:message code="comite.edicion.comite" text="**Comite"/>');
  	var tipoAsunto = label('tipoAsunto','<s:message code="asunto.tabcabecera.tipo.asunto" text="**Tipo Asunto"/>');
	var provision = label('provision', '<s:message code="asunto.tabcabecera.provision" text="**Provisión"/>');
	var titulizada = label('titulizada','<s:message code="asunto.tabcabecera.titulizada" text="**Titulizada*"/>')
  	var fondo = label('fondo','<s:message code="asunto.tabcabecera.fondo" text="**Fondo"/>')
        var msgErrorEnvioCDD = new Ext.form.Label({text : '', id : 'entidad-asunto-msgErrorEnvioCDD', style: 'color:red; font-size:smaller' });
  	
  	<%--ASUNTO TIPO ACUERDO variables para montar el panel "datos principales" --%>
  	var asuntoAcuerdo = label('asuntoAcuerdo', '<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>');
  	var codigoAsuntoAcuerdo = label('codigoAsuntoAcuerdo','<s:message code="asuntos.listado.codigo" text="**Codigo"/>');
  	var estadoAcuerdo = label('estadoAcuerdo', '<s:message code="asunto.tabcabecera.estado" text="**Estado"/>');
  	var fechaAcuerdo = label('fechaAcuerdo', '<s:message code="asunto.tabcabecera.fechaconformacion" text="**Fecha Conformacion"/>');
  	var tipoAsuntoAcuerdo = label('tipoAsuntoAcuerdo','<s:message code="asunto.tabcabecera.tipo.asunto" text="**Tipo Asunto"/>');
  	var codigoExternoAcuerdo = label('codigoExternoAcuerdo', '<s:message code="asunto.tabcabecera.codigoExterno" text="**codigoExterno"/>');
  	
	var origen = new Ext.ux.form.StaticTextField(
	{
		fieldLabel: '<s:message code="asunto.tabcabecera.origen" text="**Origen"/>'
		,labelStyle: 'font-weight: bolder; padding-bottom: 20px'
	});
  	
	// formulario para editar el nombre del asunto.
		
	var btnEditarNombre = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonedit.modificar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,handler : 	function() {
						var allowClose= false;
						var w= app.openWindow({
							flow: 'editasunto/open'
							,closable: allowClose
							,width : 700
							,title : '<s:message code="plugin.mejoras.asunto.tabCabecera.editar" text="plugin.mejoras.asunto.tabCabecera.editar" />'
							,params: {id: panel.getAsuntoId()}
						});
						w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
						});
						w.on(app.event.CANCEL, function(){
							 w.close(); 
						});
					}
	});
	
	var btnEditarNombreAcuerdo = new Ext.Button({
		text : '<s:message code="pfs.tags.buttonedit.modificar" text="**Modificar" />'
		,iconCls : 'icon_edit'
		,handler : 	function() {
						var allowClose= false;
						var w= app.openWindow({
							flow: 'editasunto/open'
							,closable: allowClose
							,width : 700
							,title : '<s:message code="plugin.mejoras.asunto.tabCabecera.editar" text="plugin.mejoras.asunto.tabCabecera.editar" />'
							,params: {id: panel.getAsuntoId()}
						});
						w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
						});
						w.on(app.event.CANCEL, function(){
							 w.close(); 
						});
					}
	});
	
	<%--
	var recargar = function(){		
		Ext.Ajax.request({
			url: page.resolveUrl('plugin.analisisAsunto.getAnalisis')
			,params: {id: panel.getAsuntoId()}
			,method: 'POST'
			,success: function (result, request){
				var r = Ext.util.JSON.decode(result.responseText);
				observaciones.setValue(r.analisis.observacion);
	}})};
	 --%>
	 
	<pfs:panel name="panelNombreAsunto" columns="2" collapsible="false" hideBorder="true">
		<pfs:items items="asunto"/>
		<pfs:items items="btnEditarNombre"/>
	</pfs:panel>
	
	panelNombreAsunto.setWidth(350);	
	asunto.autoHeight = true;
    panelNombreAsunto.autoHeight = true;
    panelNombreAsunto.style='margin:0px';   
			
	btnEditarNombre.hide();
	
	<pfs:panel name="panelNombreAsuntoAcuerdo" columns="2" collapsible="false" hideBorder="true">
		<pfs:items items="asuntoAcuerdo"/>
		<pfs:items items="btnEditarNombreAcuerdo"/>
	</pfs:panel>
	
	panelNombreAsuntoAcuerdo.setWidth(350);	
	asuntoAcuerdo.autoHeight = true;
    panelNombreAsuntoAcuerdo.autoHeight = true;
    panelNombreAsuntoAcuerdo.style='margin:0px';   
    btnEditarNombreAcuerdo.hide();
	<sec:authorize ifAllGranted="ROLE_EDIT_CABECERA_ASUNTO">
		btnEditarNombre.show();
		btnEditarNombreAcuerdo.show();
	</sec:authorize>

	<%--Creamos un fieldset para el asunto de tipo acuerdo
		el cual activaremos o desactivaremos dependiendo del asunto --%>
	var DatosFieldSetAcuerdo = new Ext.form.FieldSet({
		id:'datos1'
		,autoHeight:'false'
		,style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,width:785
		,title:'<s:message code="asunto.tabcabecera.fieldset.titulo" text="**Datos Principales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
				  
				  { items:[ panelNombreAsuntoAcuerdo,codigoAsuntoAcuerdo,fechaAcuerdo,tipoAsuntoAcuerdo]}
				,{ items:[ codigoExternoAcuerdo, origen, estadoAcuerdo]}
		 	 
		]
	});	

	var DatosFieldSet = new Ext.form.FieldSet({
		id:'datos2'
		,autoHeight:'false'
		,style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,width:785
		,title:'<s:message code="asunto.tabcabecera.fieldset.titulo" text="**Datos Principales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		,items : [
				  
				  { items:[ panelNombreAsunto,codigoAsunto,fecha,estado,expediente,comite,tipoAsunto<sec:authorize ifAllGranted="PUEDE_VER_PROVISIONES">,provision</sec:authorize>]}
				,{ items:[ codigoExterno,propiedadAsunto,gestionAsunto,despacho,gestor,supervisor,procurador<sec:authorize ifAllGranted="PUEDE_VER_TITULZADA">,titulizada,fondo</sec:authorize><sec:authorize ifAllGranted="ENVIO_CIERRE_DEUDA">,msgErrorEnvioCDD</sec:authorize>]}
		 	 
		]
	});	
	
	
	 var procedimiento = Ext.data.Record.create([
         'id'
         ,'activo'
		 ,'nombre'
		 ,'tipoProcedimiento'
		 ,{name:'saldoARecuperar',sortType:Ext.data.SortTypes.asInt}
		 ,'tipoReclamacion'
		 ,'pVencido'
		 ,'pNoVencido'
		 ,'porcRecup'
		 ,'meses'
		 ,'estado'
		 ,'nivel'
		 ,'procedimientoPadre'
		 ,'demandados'
		 ,'descripcionProcedimiento'
		 ,'fechaInicio'
		 ,'codProcEnJuzgado'		 
      ]);

   var procedimientosStore = page.getStore({
      flow:'plugin/coreextension/asunto/core.listadoActuacionesAsuntoOptimizado'
      ,reader: new Ext.data.JsonReader({
        root : 'listado'
      ,storeId : 'procedimientosStore'
      } , procedimiento)
     });
     
  
		
	var nivelRenderer=function(val){
		if(!val && val !=0)return;
		var str="";
		for(i=1;i<=val;i++){
			str +='-';
		}
		str +=val!=0?'> ':''; 
		return str + val;
	}

	var coloredRender = function (value, meta, record) {
		var activo = record.get('activo');
		if (activo){
			return '<span style="color: #4169E1; font-weight: bold;">'+value+'</span>';
		}
		return value;
	};

	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asunto.tabcabecera.grid.numero" text="**Numero" />',dataIndex : 'id' ,width:52, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.nombre" text="**Nombre"/>', dataIndex : 'nombre' , renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.tipoprocedimiento" text="**tipo procedimiento"/>', dataIndex : 'tipoProcedimiento', renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.procedimientoPadre" text="**Procedimiento Padre"/>', dataIndex : 'procedimientoPadre',align:'right', renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldoARecuperar" text="**Saldo a recuperar"/>', dataIndex : 'saldoARecuperar',align:'right',width:82, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.tiporeclamacion" text="**tipo reclamacion"/>', dataIndex : 'tipoReclamacion',hidden:true, renderer: coloredRender }
		,{header : '<s:message code="asunto.tabcabecera.grid.fechainicio" text="**fecha inicio"/>', dataIndex : 'fechaInicio', hidden:true, width:65, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldovencido" text="**P. Vencido"/>', dataIndex : 'pVencido',align:'right',hidden:true,width:90, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.saldonovencido" text="**P. No Vencido"/>', dataIndex : 'pNoVencido',align:'right',hidden:true,width:90, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.recuperacion" text="**recuperacion %"/>', dataIndex : 'porcRecup',align:'right' ,hidden:true, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.meses" text="**Meses recuperacion"/>', dataIndex : 'meses',align:'right' ,hidden:true, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.nroprocjuzgado" text="**Nro Proc Juzgado"/>', dataIndex : 'codProcEnJuzgado' ,width:65, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.estado" text="**Estado"/>', dataIndex : 'estado' ,width:65, renderer: coloredRender}
		,{header : '<s:message code="asunto.tabcabecera.grid.demandados" text="**Demandados"/>', dataIndex : 'demandados' ,width:120, renderer: coloredRender}
	]);
	
	var btnCargaListaPrc=new Ext.Button({
	      text:'<s:message code="plugin.mejoras.asuntos.cabecera.button.cargaPrc" text="**Cargar actuaciones" />'
	      ,iconCls:'icon_marcar_pte'
	      ,handler: function() {
	              procedimientosStore.webflow({id:data.id});
	      }
	});
	
	btnCargaListaPrc.on('click', function(){
		btnCargaListaPrc.setDisabled(true);
	});
       
        
	
	var procedimientosGrid = app.crearGrid(procedimientosStore,procedimientosCm,{
		title:'<s:message code="asunto.tabcabecera.grid.titulo" text="**Procedimientos"/>'
		<app:test id="procedimientosGrid" addComa="true" />
		,width : 770
		,iconCls:'icon_procedimiento'
		,style:'padding-right: 5px'
		,cls:'cursor_pointer'
		,height : 250
	});
	
	
	
	entidad.cacheStore(procedimientosGrid.getStore());
	
	procedimientosGrid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	//var nombre_procedimiento='<s:message text="${asunto.nombre}" javaScriptEscape="true" />'+'-'+rec.get('tipoProcedimiento');
    	var nombre_procedimiento=rec.get('nombre');
    	var id=rec.get('id');
    	if (id != null && id != ''){
    		app.abreProcedimiento(id, nombre_procedimiento);
    	}
    });
    
    var reiniciarKOCDD =  function() {
           Ext.Ajax.request({
                   url: page.resolveUrl('extasunto/getMsgErrorEnvioCDDCabecera')
                   ,method: 'POST'
                   ,params:{
                              idAsunto:panel.getAsuntoId()
                           }
                   ,success: function (result, request){
                          msgErrorEnvioCDD.setText(''); 
                           var r = Ext.util.JSON.decode(result.responseText);
                           var h = r.okko == 'NoCDDError' ? '': r.okko;
                           msgErrorEnvioCDD.setText(h);
                   }
           });
   }
	var panel = new Ext.Panel({
		title:'<s:message code="asunto.tabcabecera.titulo" text="**Cabecera"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[
				DatosFieldSetAcuerdo
				,DatosFieldSet
				,panelAcu
				,btnCargaListaPrc
				,procedimientosGrid
			]
		,nombreTab : 'cabeceraAsunto'
	});

        	panel.getValue = function(){
	}
        
      
	panel.procedimientosGrid=procedimientosGrid;

	panel.getValue = function(){
		return {};
	}

	panel.setValue = function(){
		var data = entidad.get("data");

		cabecera = data.cabecera;
		entidad.setLabel("asunto", cabecera.asunto);
		entidad.setLabel("procurador", cabecera.procurador.apellidoNombre);
		entidad.setLabel("codigoAsunto", data.id);
		entidad.setLabel("fecha", cabecera.fechaConformacion);
		entidad.setLabel("estado", cabecera.estado);
		entidad.setLabel("tipoAsunto", cabecera.tipoAsunto);
		entidad.setLabel("gestor", cabecera.gestor);
		entidad.setLabel("codigoExterno", cabecera.codigoExterno);
		entidad.setLabel("propiedadAsunto", cabecera.propiedadAsunto);
		entidad.setLabel("gestionAsunto", cabecera.gestionAsunto);
		entidad.setLabel("despacho", cabecera.despacho);
		entidad.setLabel("supervisor", cabecera.supervisor);
		entidad.setLabel("expediente", cabecera.expediente);
		entidad.setLabel("comite", cabecera.comite.nobmre);
		entidad.setLabel("provision", sinoRender(data.toolbar.provision));
		entidad.setLabel("titulizada", cabecera.titulizada);
		entidad.setLabel("fondo", cabecera.fondo);
		entidad.setLabel("cdd", (cabecera.errorEnvioCDD != '' ? '<s:message code="plugin.mejoras.asuntos.cabecera.errorEnvioCDDValidacionesPre" text="**Este asunto tiene un error de envío a CDD" /> '+cabecera.errorEnvioCDD : ''));
                entidad.setLabel("msgErrorEnvioCDD", cabecera.msgErrorEnvioCDD == 'NoCDDError' ? '': cabecera.msgErrorEnvioCDD);
		
		panel.getAsuntoId = function(){
			return entidad.get("data").id;
		}
		
		reiniciarKOCDD();
		procedimientosStore.removeAll();
		btnCargaListaPrc.setDisabled(false);
		
		// Muestra botones de ficha global o no
		var buttonInformeFGConcurso = Ext.getCmp('btn-exportar-informes-asunto-fg-concurso');
		var buttonInformeFGLitigio = Ext.getCmp('btn-exportar-informes-asunto-fg-litigio');
		if (buttonInformeFGLitigio!=null) buttonInformeFGConcurso.hide();
		if (buttonInformeFGLitigio!=null) buttonInformeFGLitigio.hide();
		if (buttonInformeFGLitigio!=null && cabecera.tipoAsuntoCodigo=='01') {
			buttonInformeFGLitigio.show();
		}
		if (buttonInformeFGConcurso!=null && cabecera.tipoAsuntoCodigo=='02') {
			buttonInformeFGConcurso.show();
		}
		<%--llamamos a esta funcion para aplicar las modificaciones a los asuntos de tipo acuerdo --%>
		refreshTipoAsuntoAcuerdo();
	}
        
     function refreshTipoAsuntoAcuerdo(){
    	var codigoAsunto = data.cabecera.tipoAsuntoCodigo;
    	var idAsuOrigen = data.cabecera.idAsuOrigen;
    	var idExpOrigen = data.cabecera.idExpOrigen;
    	if(codigoAsunto == "ACU"){
			entidad.cacheOrLoad(data, acuerdosStoreAcu, {id: data.id });
			btnCumplimientoAcuerdo.setVisible(false);
			
    		entidad.setLabel("asuntoAcuerdo", cabecera.asunto);
    		entidad.setLabel("codigoAsuntoAcuerdo", data.id);
    		entidad.setLabel("fechaAcuerdo", cabecera.fechaConformacion);
			entidad.setLabel("estadoAcuerdo", cabecera.estado);
			entidad.setLabel("tipoAsuntoAcuerdo", cabecera.tipoAsunto);
			entidad.setLabel("codigoExternoAcuerdo", cabecera.codigoExterno);

			if(idAsuOrigen != null){
				var nombreOrigen = data.cabecera.nombreOrigen;
				var codigoOrigen = data.cabecera.codigoOrigen;
				var tipoAsu = "Litigio";
				if(codigoOrigen == "02"){
					tipoAsu = "Concurso";
				}
				var href = 'javascript:app.abreAsunto('+idAsuOrigen+', &quot;'+nombreOrigen+'&quot;,null);'
				var link = tipoAsu+' - <a href="'+href+'">'+nombreOrigen+'</a>';
				origen.setRawValue(link);
			}else if(idExpOrigen != null){
				var nombreOrigen = data.cabecera.nombreExp;
				var href = 'javascript:app.abreExpediente('+idExpOrigen+', &quot;'+nombreOrigen+'&quot;,null);'
				var link = 'Expediente - <a href="'+href+'">'+nombreOrigen+'</a>';
				origen.setRawValue(link);
			}else{
				origen.setRawValue("");
			}
    		DatosFieldSet.hide();
    		DatosFieldSetAcuerdo.show();
    		ocultarBotones();
    		btnProponerAcuerdo.hide();
    		panelAcu.show();
    		btnAltaAcuerdo.hide();
    	}else{
    		DatosFieldSetAcuerdo.hide();
    		panelAcu.hide();
    		DatosFieldSet.show();
    	}
    }
       
	return panel;
})


