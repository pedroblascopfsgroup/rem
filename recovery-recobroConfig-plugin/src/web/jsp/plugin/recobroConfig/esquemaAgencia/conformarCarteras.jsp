<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_SIMULADO" value="${ESTADO_SIMULADO}"/>
	<pfs:hidden name="ESTADO_PENDIENTESIMULAR" value="${ESTADO_PENDIENTESIMULAR}"/>
	<pfs:hidden name="ESTADO_EXTINCION" value="${ESTADO_EXTINCION}"/>
	<pfs:hidden name="ESTADO_DESACTIVADO" value="${ESTADO_DESACTIVADO}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:hidden name="idEsquema" value="${idEsquema}"/>
	<pfs:hidden name="notInEsquema" value="true" />
	<pfs:defineParameters name="params" paramId="" idEsquema="idEsquema" notInEsquema="notInEsquema"/>

	<pfs:defineRecordType name="carteras">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="descripcion" />
			<pfs:defineTextColumn name="fechaAlta" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="esquema" />	
			<pfs:defineTextColumn name="idRegla" />			
	</pfs:defineRecordType>

	<pfs:remoteStore name="carterasDS" resultRootVar="carteras" recordType="carteras" parameters="params" dataFlow="recobrocartera/buscaCarterasDisponibles" autoload="true"/>
	
	<pfs:defineColumnModel name="carterasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.descrpicion" caption="**Descripción"
			sortable="true" />
		<pfs:defineHeader dataIndex="fechaAlta"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.fechaAlta" caption="**Fecha alta"
			sortable="true" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="esquema"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.esquemaVigor" caption="**Esquema en Vigor"
			sortable="true" />		
		<pfs:defineHeader dataIndex="idRegla"
			captionKey="plugin.recobroConfig.conformarCarteas.listado.regla" caption="**Regla"
			sortable="true" hidden="true"/>
	</pfs:defineColumnModel>
	
	var asignarCartera = function() {
    	if (gridCarteras.getSelectionModel().getCount()>0){
			var idCartera = gridCarteras.getSelectionModel().getSelected().get('id');
			var nomCartera = gridCarteras.getSelectionModel().getSelected().get('nombre');
			if (idCartera != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmCarteraEsquema'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.conformarCarteas.listado.win.title" text="**Asignar Cartera: {0}" arguments="'+nomCartera+'"/>'
					,params: {idEsquema:idEsquema.getValue(),
							idCartera:idCartera}
				});
				w.on(app.event.DONE, function(){
					recargarGrids();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
		}
    };
    
	var btnAsignar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.conformarCarteas.listado.btnAsignar" text="**Asignar cartera" />'
        ,iconCls:'icon_ok'
        ,disabled:false			
    });
    
   
    btnAsignar.on('click',asignarCartera);
    
    var pagingCarterasBar=fwk.ux.getPaging(carterasDS);

	var gridCarteras = new Ext.grid.GridPanel({
        store: carterasDS
        ,cm: carterasCM
        ,title: '<s:message code="plugin.recobroConfig.conformarCarteas.listado.title" text="**Carteras Existentes"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCarterasBar,btnAsignar]
    });		 

	var abreModificarCartera = function() {
    	if (gridCarterasEsquema.getSelectionModel().getCount()>0){
			var idCarteraEsquema = gridCarterasEsquema.getSelectionModel().getSelected().get('idCarteraEsquema');
			var nomCartera = gridCarterasEsquema.getSelectionModel().getSelected().get('nombre');
			if (idCarteraEsquema != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmCarteraEsquema'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.conformarCarteas.listado2.win.title" text="**Modificar Cartera: {0}" arguments="'+nomCartera+'"/>'
					,params: {idCarteraEsquema:idCarteraEsquema}
				});
				w.on(app.event.DONE, function(){
					recargarGrids();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
		}
    };
    
	var btnModificar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.conformarCarteas.listado.btnModificar" text="**Modificar" />'
        ,iconCls:'icon_edit'
        ,disabled:false		
        ,hidden:true	
    });    
    
    btnModificar.on('click',function() {
    	abreModificarCartera();
    });
    
	var btnDesasignar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.conformarCarteas.listado.btnDesasignar" text="**Desasignar" />'
        ,iconCls:'icon_cancel'
        ,disabled:false		
        ,hidden:true	
    });    
    
    btnDesasignar.on('click',function() {
    	if (gridCarterasEsquema.getSelectionModel().getCount()>0){
			var idCarteraEsquema = gridCarterasEsquema.getSelectionModel().getSelected().get('idCarteraEsquema');
			var nomCartera = gridCarterasEsquema.getSelectionModel().getSelected().get('nombre');
			if (idCarteraEsquema != ''){
				Ext.Msg.confirm('<s:message code="app.borrar" text="**Borrar" />', '<s:message code="plugin.recobroConfig.conformarCarteas.listado2.preguntaBorrar" text="**¿Está seguro de desasignar la cartera {0}?" arguments="'+nomCartera+'" />', function(btn){				
    				if (btn == "yes") {
	    				Ext.Ajax.request({
							url: app.resolveFlow('recobroesquema/borrarRecobroCarteraEsquema')
							,params: {idCarteraEsquema:idCarteraEsquema}
							,method: 'POST'
							,success : function(){
								recargarGrids();
								}
							,failure: function(){
									Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado2.noPuedoBorrar" text="**Ha ocurrido un error y no se ha podido desasignar la cartera" />');
								}
							})
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.conformarCarteas.listado.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
		}
    });
    
    <sec:authorize ifAllGranted="ROLE_CONF_CARTERASESQUEMA">
    	btnModificar.show();
		btnDesasignar.show();
	</sec:authorize>	
	
    var recargarGrids = function(){ 
    	var paramRecargar = {idEsquema: idEsquema.getValue(), notInEsquema: notInEsquema.getValue()};
        carterasDS.webflow(paramRecargar);
        carterasEsquemaDS.webflow(paramRecargar);
    }
    
    <pfs:defineRecordType name="carterasEsquema">
			<pfs:defineTextColumn name="idCarteraEsquema" />
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="tipoCartera" />
			<pfs:defineTextColumn name="prioridad" />
			<pfs:defineTextColumn name="tipoGestion" />
			<pfs:defineTextColumn name="generacionExpediente" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="carterasEsquemaCM">
		<pfs:defineHeader dataIndex="idCarteraEsquema"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.idCarteraEsquema" caption="**IdCarteraEsquema"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.id" caption="**Id"
			sortable="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.nombre" caption="**Nombre"
			sortable="true" />	
		<pfs:defineHeader dataIndex="tipoCartera"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.tipoCartera" caption="**Tipo cartera"
			sortable="true" />	
		<pfs:defineHeader dataIndex="prioridad"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.prioridad" caption="**Prioridad"
			sortable="true" />	
		<pfs:defineHeader dataIndex="tipoGestion"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.tipoGestion" caption="**Tipo gestión"
			sortable="true" />	
		<pfs:defineHeader dataIndex="generacionExpediente"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.generacionExpediente" caption="**Generación de expediente"
			sortable="true" />						
	</pfs:defineColumnModel>
    
    <pfs:remoteStore name="carterasEsquemaDS" resultRootVar="carteras" recordType="carterasEsquema" parameters="params" dataFlow="recobroesquema/buscaCarterasEsquema" autoload="true"/>
    
    var pagingCarterasEsquemaBar=fwk.ux.getPaging(carterasEsquemaDS);

	var gridCarterasEsquema = new Ext.grid.GridPanel({
        store: carterasEsquemaDS
        ,cm: carterasEsquemaCM
        ,title: '<s:message code="plugin.recobroConfig.conformarCarteas.listado2.title" text="**Carteras Esquema"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCarterasEsquemaBar,btnModificar,btnDesasignar]
    });		 
    
    var panel = new Ext.Panel({    
	    autoHeight : true
	    ,border: false	    
	    ,items: [ 
	    	{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[gridCarteras]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[gridCarterasEsquema]
			}   
		     ]
	});
	
	ultimaVersionDelEsquema=${ultimaVersionDelEsquema};
	NoEsVersionDelEsquemaliberado=${!esVersionDelEsquemaliberado};
	if (!ultimaVersionDelEsquema) {
   		btnAsignar.setDisabled(true);
  		btnModificar.setDisabled(true);
  		btnDesasignar.setDisabled(true);
    } else {
    	if ('${esquema.propietario.id}' == usuarioLogado.getValue() && NoEsVersionDelEsquemaliberado) {
   			btnAsignar.setDisabled(false);
  			btnModificar.setDisabled(false);
  			btnDesasignar.setDisabled(false);
  			gridCarterasEsquema.on('rowdblclick',abreModificarCartera);
    		gridCarteras.on('rowdblclick',asignarCartera);	
    	} else {
    		btnAsignar.setDisabled(true);
  			btnModificar.setDisabled(true);
  			btnDesasignar.setDisabled(true);
    	}
    	
    }
	
	page.add(panel);
			
	
</fwk:page>	