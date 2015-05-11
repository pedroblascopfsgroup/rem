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
	
	var rowCobro=0;
	<pfs:hidden name="idModFact" value="${idModFact}"/>
	<pfs:hidden name="numTramos" value="${numTramos}"/>

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
	
    <pfs:remoteStore name="cobrosHabDS" resultRootVar="cobros" recordType="cobrosRecord" parameters="params_hab" dataFlow="recobromodelofacturacion/buscaCobros" autoload="true"/>
    
    var pagingCobrosHabBar=fwk.ux.getPaging(cobrosHabDS);

	var gridCobrosHab = new Ext.grid.GridPanel({
        store: cobrosHabDS
        ,cm: cobrosCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.cobros.grid_hab.title" text="**Cobros habilitados"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCobrosHabBar]
    });		 
    
    gridCobrosHab.on('rowclick', function(grid, rowIndex, e){
    	var rec = gridCobrosHab.getStore().getAt(rowIndex);
    	var idCobro = rec.get('id');
    	conceptosDS.webflow({idModFact:idModFact.getValue(),idCobro:idCobro});
    });
    
    var btnModificar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.btnModificar" text="**Modificar" />'
        ,iconCls:'icon_edit'
        ,disabled:false
    });
    
    var abreModificarConceptos = function() {
    	if(!btnModificar.disabled)
    	{
	    	if (gridCobrosHab.getSelectionModel().getCount()>0){
				var idCobro = gridCobrosHab.getSelectionModel().getSelected().get('id');
				var nomCobro = gridCobrosHab.getSelectionModel().getSelected().get('descripcion');
				if (idCobro != ''){
	    			var allowClose= false;
					var w = app.openWindow({
						flow: 'recobromodelofacturacion/abrirEditTarifas'
						,closable: true
						,width : 750
						,title :  '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.win.title" text="**Modificar conceptos cobro: {0}" arguments="'+nomCobro+'"/>'
						,params: {idModFact:idModFact.getValue(),idCobro:idCobro}
					});
					w.on(app.event.DONE, function(){
						conceptosDS.webflow({idModFact:idModFact.getValue(),idCobro:idCobro});
						w.close();
					});
					w.on(app.event.CANCEL, function(){
						 w.close(); 
					});
		 		}else{
					Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
				}
			}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.debeSeleccionarCobro" text="**Debe seleccionar un cobro" />');
			}
		}
    };
    
    btnModificar.on('click',abreModificarConceptos);
          
    var conceptosRecord = Ext.data.Record.create([
    	{name: 'id'}
    	,{name: 'idCobroFacturacion'}
    	,{name: 'concepto'}
    	,{name: 'minimo'}
    	,{name: 'maximo'}
    	,{name: 'porcentajeDefecto'}
    	<c:if test="${numTramos > 0}">
	    	<c:forEach var="i" begin="0" end="${numTramos-1}">
	    	,{name: 'idTramo${tramos[i].id}'}
	    	,{name: 'tramo${tramos[i].id}'}
	    	</c:forEach>
    	</c:if>
    ]);
    
    <pfs:remoteStore name="conceptosDS" resultRootVar="tarifas" 
    	recordType="conceptosRecord" dataFlow="recobromodelofacturacion/buscaTarifasConcepCobros"/>
    
    var headerGridConceptos = [
    	[
    		 {colspan: 5}
    		 <c:if test="${numTramos > 0}">
    		 	,{header: '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.grid.header.tramos" text="**Tramos días desde entrega"/>', colspan: ${numTramos*2}, align: 'center'}
    		 </c:if>
    		 ,{header: '<s:message text=""/>', align: 'center'}
    	]
    ];
	
	var renderer_percent = function(value, metaData, record, rowIndex, colIndex, store)
	{
		if (''+value != '') {
			return value+'%';
		} else {
			return '0%';
		}
	};
	    
    var conceptosCM = new Ext.grid.ColumnModel([
		{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.id" text="**Id" />', hidden: 'true', dataIndex : 'id',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.idCobroFacturacion" text="**Id cobro" />', hidden: 'true', dataIndex : 'idCobroFacturacion',sortable:true}	
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.concepto" text="**Concepto de cobro" />', dataIndex : 'concepto' ,sortable:true, hidden:false, width:300}
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.limiteMin" text="**Límite Min." />', dataIndex : 'minimo' ,sortable:true, hidden:false,renderer: app.format.moneyRenderer, align: 'right'}
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.limiteMax" text="**Límite Max." />', dataIndex : 'maximo',sortable:true, hidden:false, renderer: app.format.moneyRenderer, align: 'right'}
		<c:if test="${numTramos > 0}">
			<c:forEach var="i" begin="0" end="${numTramos-1}">
				,{header : 'id tramo ${tramos[i].tramoDias} d&iacute;as', dataIndex : 'idTramo${tramos[i].id}' ,sortable:true, hidden:true}
				,{header : '< ${tramos[i].tramoDias} d&iacute;as', dataIndex : 'tramo${tramos[i].id}' ,sortable:true, hidden:false, renderer: renderer_percent, align: 'right', css : 'padding-right: 20px'}
			</c:forEach>
		</c:if>
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.porcentajePorDefecto" text="**% por defecto" />', dataIndex : 'porcentajeDefecto',sortable:true, hidden:false, renderer: renderer_percent, align: 'right', css : 'padding-right: 20px'}
	]);

	var gridConceptos = new Ext.grid.GridPanel({
        store: conceptosDS
        ,cm: conceptosCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.title" text="**Conceptos de cobro"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,plugins: [new Ext.ux.grid.ColumnHeaderGroup({rows: headerGridConceptos})]
		,bbar:[btnModificar]
    });	
    
    gridCobrosHab.on('rowdblclick',abreModificarConceptos);
    gridConceptos.on('rowdblclick',abreModificarConceptos);

	var panel = new Ext.Panel({    
	    autoHeight : true
	    ,border: false	    
	    ,items: [ 
	    	{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
				,items:[gridCobrosHab]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[gridConceptos]
			}   
		     ]
	});
	
	if ('${modelo.estado.codigo}'==ESTADO_BLOQUEADO.getValue() || '${modelo.propietario.id}' != usuarioLogado.getValue()){
		btnModificar.setDisabled(true);
	} else {
		btnModificar.setDisabled(false);
	}	
	
	page.add(panel);
			
	
</fwk:page>	