<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.cartera.listado.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreRecobroListaCarteras';		
			
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.cartera.listado.estado"
		label="**Estado" value="" dd="${ddEstado}" width="200"  propertyCodigo="id" propertyDescripcion="descripcion"/>	
	
	filtroEstado.setValue(${cartera.estado.id});
	
	filtroEstado.id='filtroEstadoRecobroListaCarteras';	
		
	<pfsforms:ddCombo name="filtroEsquema"
		labelKey="plugin.recobroConfig.cartera.esquema"
		label="**Esquema" value="" dd="${listaEsquemas}" width="170"  propertyCodigo="id" propertyDescripcion="nombre"/>	
	
	filtroEsquema.id='filtroEsquemaRecobroListaCarteras';	
	
	<pfsforms:datefield name="filtroFechaAltaDesde"
		labelKey="plugin.recobroConfig.cartera.listado.fechaAlta" 
		label="**Fecha alta" width="70"/>
		
	filtroFechaAltaDesde.id='filtroFechaAltaDesdeRecobroListaCarteras';		
	 
	var filtroFechaAltaHasta = new Ext.ux.form.XDateField({
		name : 'filtroFechaAltaHasta'
		,hideLabel:true
		,width:95
	});
	
	var filtroFechaAlta = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'filtroFechaAltaRecobroListaCarteras'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[filtroFechaAltaDesde]}
			,{layout:'form',items:[filtroFechaAltaHasta]}
		]
	}); 
	
	
 		
	<pfs:defineRecordType name="carteras">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="descripcion" />
			<pfs:defineTextColumn name="fechaAlta" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="enEsquemaVigente" />	
			<pfs:defineTextColumn name="idRegla" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="propietario" />
			<pfs:defineTextColumn name="idPropietario" />			
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="carterasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.cartera.listado.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.cartera.listado.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.recobroConfig.cartera.listado.descrpicion" caption="**Descripción"
			sortable="true" />
		<pfs:defineHeader dataIndex="fechaAlta"
			captionKey="plugin.recobroConfig.cartera.listado.fechaAlta" caption="**Fecha alta"
			sortable="true" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.cartera.listado.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="enEsquemaVigente"
			captionKey="plugin.recobroConfig.cartera.listado.esquemaVigor" caption="**Esquema en Vigor"
			sortable="false" />	
		<pfs:defineHeader dataIndex="propietario"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.propietario" caption="**Propietario"
			sortable="true" />			
		<pfs:defineHeader dataIndex="idRegla"
			captionKey="plugin.recobroConfig.cartera.listado.regla" caption="**Regla"
			sortable="true" hidden="true"/>
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="getParametros" paramId=""
	    nombre="filtroNombre" 
		idEsquema="filtroEsquema" 
		idEstado="filtroEstado"
		fechaAltaDesde_date="filtroFechaAltaDesde"
		fechaAltaHasta_date="filtroFechaAltaHasta"/>
	
	
	<pfs:button name="btRegla" caption="Ver regla"  captioneKey="plugin.arquetipos.modelo.consulta.verRegla" iconCls="icon_objetivos_pendientes">
 	   	var contenido = Ext.getCmp('contenido');
	    var sel=this.ownerCt.ownerCt.getSelectionModel().getSelected();
	    var idRegla = sel.get("idRegla") || sel.get("id");
		var editor= new Ext.Panel({
	   		closable:true,
	   		html:'<iframe src="/pfs/editor/editor3.htm?id='+idRegla+'" width="100%" height="100%" border="false" frameborder="false">',
	   		title:"Editor de reglas"
		});
	   
		contenido.add(editor);
		contenido.setActiveTab(editor);
   </pfs:button>
   
   	btRegla.disable();
   		
    var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarRecobroListaCarteras'
		,handler : function(){
			if (carterasGrid.getSelectionModel().getCount()>0){
				// comprobar estado != en definicion 
    					var parms = getParametros();
    					parms.id = carterasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobrocartera/liberarCartera'
							,params: parms
							,success : function(){ 
								carterasGrid.store.webflow(parms);
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />','<s:message code="plugin.recobroConfig.modeloRanking.liberar.error" text="**Debe seleccionar el modelo de ranking que desea liberar" />');
			}
		}
	});	
	
	var btBorrar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,disabled : true
		,id: 'btBorrarRecobroListaCarteras'
		,handler : function(){
			if (carterasGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.id = carterasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobrocartera/borrarCartera'
							,params: parms
							,success : function(){ 
								carterasGrid.store.webflow(parms);
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.politicaAcuerdos.noSeleccionado" text="**Debe seleccionar el modelo de ranking que desea liberar" />');
			}
		}
	});	
    
    var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btnCopiarRecobroListaCarteras'
		,disabled : true
		,handler : function(){
			if (carterasGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.id = carterasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobrocartera/copiarRecobroCartera'
							,params: parms
							,success : function(){ 
								carterasGrid.store.webflow(parms);
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.politicaAcuerdos.noSeleccionado" text="**Debe seleccionar la politica de acuerdos que desea copiar" />');
			}
		}
	});
    
    
    var btnNuevoRecargar = app.crearBotonAgregar({
		flow : 'cartera/altaCartera'
		,title : '<s:message code="plugin.recobroConfig.cartera.nuevaCartera" text="**Nueva cartera" />'
		,text : '<s:message code="plugin.recobroConfig.cartera.nuevaCartera" text="**Nueva cartera" />'
		,params : {}
		,success : function(){ 
								carterasGrid.store.webflow(getParametros());
								filtroForm.collapse(true);
							}
		,width: 700
		//,closable:true
		,iconCls:'icon_cartera'
	});	
		
	<pfs:searchPage searchPanelTitle="**Búsqueda de Carteras"  searchPanelTitleKey="plugin.recobroConfig.cartera.titulo" 
			columnModel="carterasCM" columns="2"
			gridPanelTitleKey="plugin.recobroConfig.cartera.carterasExistentes" gridPanelTitle="**Carteras Existentes" 
			createTitleKey="plugin.recobroConfig.cartera.nuevaCartera" createTitle="**Nueva cartera" 
			createFlow="cartera/altaCartera" 
			updateFlow="recobrocartera/editaCartera" 
			updateTitleData="nombre"
			dataFlow="recobrocartera/buscaCarteras"
			resultRootVar="carteras" resultTotalVar="total"
			recordType="carteras" 
			parameters="getParametros" 
			newTabOnUpdate="false"
			iconCls="icon_cartera"
			emptySearch="true"
			gridName="carterasGrid"
			buttonDelete="btRegla,btBorrar, btCopiar, btLiberar ">
			<pfs:items
			items="filtroNombre,filtroEsquema"
			/>
			<pfs:items
			items="filtroEstado,filtroFechaAlta" 
			/>
	</pfs:searchPage>	
	
	carterasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
		btRegla.enable();
		var codigoEstado = carterasGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = carterasGrid.getSelectionModel().getSelected().get('idPropietario');
    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
    		btCopiar.setDisabled(false);
    		btLiberar.setDisabled(true);
    		btBorrar.setDisabled(true);
    	} else {
    		if (idPropietario != usuarioLogado.getValue()){
    			btLiberar.setDisabled(true);
    			btBorrar.setDisabled(true);
    		} else {
    			btBorrar.setDisabled(false);
    			if (codigoEstado == ESTADO_DEFINICION.getValue()){
    				btLiberar.setDisabled(false);
    			} else {
    				btLiberar.setDisabled(true);
    			}
    		}
    		if (codigoEstado == ESTADO_DEFINICION.getValue()){
    			btCopiar.setDisabled(true);
    		} else {
    			btCopiar.setDisabled(false);
    		}
    	}
				
	});
	
	btnNuevo.hide();
	filtroForm.getTopToolbar().add(btnNuevoRecargar);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
</fwk:page>	