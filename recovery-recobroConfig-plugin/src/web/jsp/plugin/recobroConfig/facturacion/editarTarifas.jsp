<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	
	<pfs:hidden name="idModFact" value="${idModFact}"/>
	<pfs:hidden name="idCobro" value="${tipoCobro.id}"/>
	
	<pfsforms:textfield name="descripcion" labelKey="plugin.recobroConfig.modeloFacturacion.editarTarifas.tipoCobro" 
		label="**Tipo" value="${tipoCobro.descripcion}" readOnly="true" />
	
	<pfsforms:textfield name="codigo" labelKey="plugin.recobroConfig.modeloFacturacion.editarTarifas.codigoCobro" 
		label="**Código" value="${tipoCobro.codigo}" readOnly="true" />
	
	<pfs:panel name="panel1" columns="2" collapsible="false">
		<pfs:items items="descripcion" width="400" />
		<pfs:items items="codigo" width="300"/>
	</pfs:panel>

	 var conceptosRecord = Ext.data.Record.create([
    	{name: 'id'}
    	,{name: 'idCobroFacturacion'}
    	,{name: 'concepto'}
    	,{name: 'minimo'}
    	,{name: 'maximo'}
    	,{name: 'porcentajeDefecto'}
    	<c:if test="${numTramos > 0}">
    		<c:forEach var="i" begin="0" end="${numTramos-1}">
    		,{name: 'idTramo${tramos[i].id}', type:'int'}
    		,{name: 'tramo${tramos[i].id}', type:'float'}
    		</c:forEach>
    	</c:if>
    ]);
    
    var colsTramos = [];
    <c:if test="${numTramos > 0}">
	    <c:forEach var="i" begin="0" end="${numTramos-1}">
	    	colsTramos.push('tramo${tramos[i].id}');
	    </c:forEach>
   	</c:if>
   	
    <pfs:remoteStore name="conceptosDS" resultRootVar="tarifas" recordType="conceptosRecord" dataFlow="recobromodelofacturacion/buscaTarifasConcepCobros"/>
    
    var headerGridConceptos = [
    	[
    		 {colspan: 5}
    		 <c:if test="${numTramos > 0}">
    		 	,{header: '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.grid.header.tramos" text="**Tramos días desde entrega"/>', colspan: ${numTramos*2}, align: 'center'}
    		 </c:if>
   		 	,{header: '<s:message text=""/>', align: 'center'}
    	]
    ];
    
    var num_edit = new Ext.form.NumberField({
    	minValue:0,
    	decimalPrecision:2,
    	selectOnFocus:true
    });

	var porcentaje_edit = new Ext.form.NumberField({
		maxValue:100,
		minValue:0,
		decimalPrecision:2,
		selectOnFocus:true
	});

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
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.limiteMin" text="**Límite Min." />', dataIndex : 'minimo' ,sortable:true, hidden:false, editor: num_edit, renderer: app.format.moneyRenderer, align: 'right'}
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.limiteMax" text="**Límite Max." />', dataIndex : 'maximo',sortable:true, hidden:false, editor: num_edit, renderer: app.format.moneyRenderer, align: 'right'}
		<c:if test="${numTramos > 0}">
			<c:forEach var="i" begin="0" end="${numTramos-1}">
				,{header : 'id tramo ${tramos[i].tramoDias} d&iacute;as', dataIndex : 'idTramo${tramos[i].id}' ,sortable:true, hidden: true}			
				,{header : '< ${tramos[i].tramoDias} d&iacute;as'
					, dataIndex : 'tramo${tramos[i].id}' 
					,sortable:true
					, hidden:false
					, editor: porcentaje_edit
					, renderer: renderer_percent
					, align: 'right',
					 css : 'padding-right: 20px'}					 
			</c:forEach>
		</c:if>
		,{header : '<s:message code="plugin.recobroConfig.modeloFacturacion.tarifas.gridConceptos.porcentajePorDefecto" text="**% por defecto" />'
		, dataIndex : 'porcentajeDefecto',
		sortable:true
		, hidden:false
		, editor: porcentaje_edit
		, renderer: renderer_percent
		, align: 'right'
		, css : 'padding-right: 20px'}
	]);

	
	conceptosDS.webflow({idModFact:idModFact.getValue(),idCobro:idCobro.getValue()});
		
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.guardar" text="**Guardar" />'
		,iconCls:'icon_ok'
		,handler : function(){
			if (storeValues.length == 0) {
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.nadaGuardar" text="**No hay nada modificado" />');
			} else { 
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.guardar" text="**Guardar" />',
				'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.seguro" text="**¿Seguro que desea guardar?" />',this.decide,this);
			}
		}
		,decide : function(boton){
			if (boton=='yes'){
				this.guardar();
			}
		}
		,guardar : function(){
			var parms = {};
			parms.conceptos=getArrayParam(storeValues);
			page.webflow({
				flow : 'recobromodelofacturacion/saveTarifas' 
				,params : parms
				,success : function(){ page.fireEvent(app.event.DONE); }				
			});
		}
	});
	
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			if (storeValues.length == 0) {
				page.fireEvent(app.event.CANCEL);
			} else { 
				Ext.Msg.confirm('<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.cancelar" text="**Cancelar" />',
				'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.seguroCancelar" text="**¿Seguro que desea descartar los cambios?" />', function(btn){				
	  				if (btn == "yes") {
	  					page.fireEvent(app.event.CANCEL);
					}
				});
			}
		}
	});
	
	var gridConceptos = new Ext.grid.EditorGridPanel({
        store: conceptosDS
        ,cm: conceptosCM
        ,title: '<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.gridConceptos.title" text="**Conceptos de cobro"/>'
        ,stripeRows: true
        ,height: 400
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,clickstoEdit: 1
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,plugins: [new Ext.ux.grid.ColumnHeaderGroup({rows: headerGridConceptos})]
		,bbar:[btnGuardar,btnCancelar]
    });	
	
	var storeValues=[];
	var storeIndices={};
		
	var validaDato = function(row, campo, dato) {
		if (campo == 'maximo') {
			var minimo = conceptosDS.getAt(row).get('minimo');
			if (minimo != '' && dato < minimo) {				
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />'
				,'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.maximoMenorMinimo" text="**El límite máximo no puede ser menor que el mínimo" />');					
				return false;
			}				
		}
		if (campo == 'minimo') {
			var maximo = conceptosDS.getAt(row).get('maximo');
			if (maximo != '' && dato > maximo) {
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />'
				,'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.maximoMenorMinimo" text="**El límite máximo no puede ser menor que el mínimo" />');					
				return false;
			}				
		}
		<%-- 
		var campoSplit = campo.split("tramo");
		if (campoSplit.length > 1) {		
			var suma = 0;
			for (i=0;i < colsTramos.length;i++) {
				suma += conceptosDS.getAt(row).get(colsTramos[i]);
			}
			if (suma > 100) {
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />'
					,'<s:message code="plugin.recobroConfig.modeloFacturacion.editarTarifas.maximoPorcentaje" text="**La suma de los porcentajes excede en {0}" arguments="'+(suma-100)+'" />');
				return false;				
			}
		}
		--%>
		return true;
	};
	
	gridConceptos.on('afteredit', function(editEvent){
		var campo = editEvent.field;
		
		if (!validaDato(editEvent.row,campo,editEvent.value)) {
			editEvent.record.reject();
			return false;
		}
				
		var indice = storeIndices['indice['+editEvent.row+'].'+editEvent.field];
		
		if (indice == undefined) {
			indice = storeValues.length;
			storeIndices['indice['+editEvent.row+'].'+editEvent.field]=indice;
		}
		
		var obj = {};
		
		var campoSplit = campo.split("tramo");
		if (campoSplit.length > 1) {
			obj.id = conceptosDS.getAt(editEvent.row).get('idTramo'+campoSplit[1]);
			obj.tabla = "tramos";
			obj.campo = "porcentaje";
		} else {
			obj.id = conceptosDS.getAt(editEvent.row).get('id');
			obj.tabla = "tarifas";
			obj.campo = editEvent.field;
		}
		obj.valor = editEvent.value;
						
		storeValues[indice]=obj;
		
		editEvent.record.commit();	
	});
	
	
	function getArrayParam(allRecords){
	    var myArrayParam = new MyArrayParam();
	    myArrayParam.conceptosItems = allRecords;
	    return Ext.encode(myArrayParam);
	}
	
	 
	MyArrayParam = function() {
	    var conceptosItems;
	}
	
	
	var compuesto = new Ext.Panel({
	    items : [{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[gridConceptos],border:false,style:'margin-top: 7px; margin-left:5px'}]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });

	page.add(compuesto);
	
</fwk:page>