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
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:hidden name="idModFact" value="${idModFact}"/>

	var params_deshab = function(){
		return {
			idModFact:idModFact.getValue()
			,habilitados:'false'
		}
	};

	var params_hab = function(){
		return {
			idModFact:idModFact.getValue()
			,habilitados:'true'
		}
	};
	


	var cobrosRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	<pfs:remoteStore name="cobrosDS" resultRootVar="cobros" recordType="cobrosRecord" parameters="params_deshab" dataFlow="recobromodelofacturacion/buscaCobros" autoload="true"/>
	
	<pfs:defineColumnModel name="cobrosCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.descripcion" caption="**Tipo de cobro"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigo"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.codigo" caption="**Código"
			sortable="true" />		
	</pfs:defineColumnModel>
	
	var habilitarCobro = function() {
    	if (gridCobrosNoHab.getSelectionModel().getCount()>0){
			var idTipo = gridCobrosNoHab.getSelectionModel().getSelected().get('id');
			var tipoCobro = gridCobrosNoHab.getSelectionModel().getSelected().get('descripcion');
			if (idTipo != ''){
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.habilitar" text="**Habilitar cobro" />', '<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.gridCobrosNoHab.preguntaHabilitar" text="**¿Está seguro de habilitar {0}?" arguments="'+tipoCobro+'" />', function(btn){				
    				if (btn == "yes") {
	    				Ext.Ajax.request({
							url: app.resolveFlow('recobromodelofacturacion/habilitarCobro')
							,params: {idModFact:idModFact.getValue(),idTipoCobro:idTipo}
							,method: 'POST'
							,success : function(){
								recargarGrids();
								}
							,failure: function(){
									Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.habilitar" text="**Habilitar cobro" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.gridCobrosNoHab.noPuedoHabilitar" text="**Ha ocurrido un error y no se ha podido habilitar el cobro" />');
								}
							})
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
		}
    };
    
	var btnHabilitar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.btnHabilitar" text="**Habilitar cobro" />'
        ,iconCls:'icon_ok'
        ,disabled:false			
    });
    
   
    btnHabilitar.on('click',habilitarCobro);
    
    var pagingCobrosBar=fwk.ux.getPaging(cobrosDS);

	var gridCobrosNoHab = new Ext.grid.GridPanel({
		id: 'gridCobrosNoHab'
        ,store: cobrosDS
        ,cm: cobrosCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.gridCobrosNoHab.title" text="**Cobros deshabilitados"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCobrosBar,btnHabilitar]
    });		 

	gridCobrosNoHab.on('rowdblclick',habilitarCobro);
	
    
	var btnDesHabilitar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.btnDesHabilitar" text="**Deshabilitar cobro" />'
        ,iconCls:'icon_cancel'
        ,disabled:false		
    });    
    
    var desHabilitarCobro = function() {
    	if (gridCobroshab.getSelectionModel().getCount()>0){
			var idTipo = gridCobroshab.getSelectionModel().getSelected().get('id');
			var tipoCobro = gridCobroshab.getSelectionModel().getSelected().get('descripcion');
			if (idTipo != ''){
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.deshabilitar" text="**Deshabilitar cobro" />', '<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.gridCobrosHab.preguntaBorrar" text="**Al desahabilitar el {0} se perderán todas las tarifas definidas, ¿Está seguro?" arguments="'+tipoCobro+'" />', function(btn){				
    				if (btn == "yes") {
	    				Ext.Ajax.request({
							url: app.resolveFlow('recobromodelofacturacion/desHabilitarCobro')
							,params: {idModFact:idModFact.getValue(),idTipoCobro:idTipo}
							,method: 'POST'
							,success : function(){
								recargarGrids();
								}
							,failure: function(){
									Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.deshabilitar" text="**Deshabilitar cobro" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.gridCobrosHab.noPuedoBorrar" text="**Ha ocurrido un error y no se ha podido deshabilitar el cobro" />');
								}
							})
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
		}
    };
    
    btnDesHabilitar.on('click',desHabilitarCobro);
    
    <sec:authorize ifAllGranted="ROLE_CONF_COBROS">
		btnDesHabilitar.show();
	</sec:authorize>	
	
    var recargarGrids = function(){
        cobrosDS.webflow({idModFact:idModFact.getValue(), habilitados:'false'});
        cobrosHabDS.webflow({idModFact:idModFact.getValue(), habilitados:'true'});
    }
    
    <pfs:defineColumnModel name="cobrosHabCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.descripcion" caption="**Tipo de cobro"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigo"
			captionKey="plugin.recobroConfig.modeloFacturacion.cobros.grid.codigo" caption="**Código"
			sortable="true" />		
	</pfs:defineColumnModel>
    
    
    <pfs:remoteStore name="cobrosHabDS" resultRootVar="cobros" recordType="cobrosRecord" parameters="params_hab" dataFlow="recobromodelofacturacion/buscaCobros" autoload="true"/>
    
    var pagingCobrosHabBar=fwk.ux.getPaging(cobrosHabDS);

	var gridCobroshab = new Ext.grid.GridPanel({
		id: 'gridCobrosHab'
        ,store: cobrosHabDS
        ,cm: cobrosHabCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid_hab.title" text="**Cobros habilitados"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCobrosHabBar,btnDesHabilitar]
    });		 
    
    gridCobroshab.on('rowdblclick',desHabilitarCobro);
     
	var panel = new Ext.Panel({    
	    autoHeight : true
	    ,border: false	    
	    ,items: [ 
	    	{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[gridCobrosNoHab]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[gridCobroshab]
			}   
		     ]
	});
	
	if ('${modelo.estado.codigo}'==ESTADO_BLOQUEADO.getValue() || '${modelo.propietario.id}' != usuarioLogado.getValue()){
		btnDesHabilitar.setDisabled(true);
		btnHabilitar.setDisabled(true);
	} else {
		btnDesHabilitar.setDisabled(false);
		btnHabilitar.setDisabled(false);
	}	
	
	page.add(panel);
			
	
</fwk:page>	