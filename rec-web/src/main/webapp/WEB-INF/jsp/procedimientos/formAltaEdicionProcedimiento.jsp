<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var formAltaEdicionProcedimiento=function(){
	/*
	Funciones auxiliares para hacer submit de los combos.
	*/
	
	var rearmarArray = function(elArray, valor){
		var esta = false;
		var nuevoArray = new Array();
		var j = 0;
		for (var i=0; i < elArray.length; i++){
			if(valor!=elArray[i]){
				//Si es distinto quiere decir que no esta deseleccionando un elemento,
				//por lo tanto lo tengo que pasar al nuevo array. 
				nuevoArray[j++]=elArray[i];
			}else{
				//Si es igual (lo esta deseleccionando), 
				//hay que sacarlo del listado de seleccionados.
				esta = true;
			}
		}
		if (!esta){
			//Si copio todo el array y no estaba lo agrego porque es nuevo.
			nuevoArray[nuevoArray.length] = valor;
		}
		return nuevoArray;
	}
	
	var armarString = function(elArray){
		var s = "";
		for (var i=0; i < elArray.length; i++){
			if (s!=""){
				s+="-";
			}
			s+=elArray[i];
		}
		return s;
	}
	
	/**/	
	var style='margin-bottom:1px;margin-top:1px';
	var labelStyleTextField='font-weight:bolder;margin-bottom:1px;margin-top:1px;width:160px'	
	var labelStyle='font-weight:bolder;width:160';
	var codigoContrato = app.creaLabel('<s:message code="procedimientos.edicion.contrato" text="**Codigo Contrato" />','${contrato.codigoContrato}',{labelStyle:labelStyle})
	var tipoContrato = app.creaLabel('<s:message code="procedimientos.edicion.tipocontrato" text="**Tipo Contrato" />','${contrato.tipoProducto.descripcion}',{labelStyle:labelStyle})
	var saldoOriginalVencido = app.creaLabel('<s:message code="procedimientos.edicion.saldovencido" text="**Saldo original " />',app.format.moneyRenderer(${contrato.lastMovimiento.posVivaVencida}),{labelStyle:labelStyle})
	var saldoOriginalNoVencido = app.creaLabel('<s:message code="procedimientos.edicion.saldonovencido" text="**Saldo original " />',app.format.moneyRenderer(${contrato.lastMovimiento.posVivaNoVencida}),{labelStyle:labelStyle})	
	var idProcedimiento = new Ext.form.Hidden({
		name:'idProcedimiento'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.id}'
		</c:if>
	});
	
	var idContrato = new Ext.form.Hidden({
		name:'idContrato'
		,value:'${idContrato}'
	});
		
	var seleccionPersonas = new Ext.form.Hidden({
		name:'seleccionPersonas'
	});
	
	var sOrigVenc = new Ext.form.Hidden({
		name:'saldoOriginalVencido'
		,value:'${contrato.lastMovimiento.posVivaVencida}'
	});
	
	var sOrigNoVenc = new Ext.form.Hidden({
		name:'saldoOriginalNoVencido'
		,value:'${contrato.lastMovimiento.posVivaNoVencida}'
	});
	
	var personasSeleccionadasString = "";
	
	var personasSeleccionadas = new Array();
	
	var saldoARecuperar = 
		app.creaNumber('saldorecuperar',
			'<s:message code="procedimientos.edicion.saldorecuperacion" text="**Saldo original " />',
			<c:if test="${procedimiento!=null}" >
				'${procedimiento.saldoRecuperacion}',
			</c:if>
			<c:if test="${procedimiento==null}" >
				'',
			</c:if>
			{labelStyle:labelStyleTextField
			,style:style
			,allowDecimals: true
			,allowNegative: false}
	)
	
	var recuperacion  = app.creaNumber('recuperacion',
		'<s:message code="procedimientos.edicion.recuperacion" text="**% Recuperacion " />',
		<c:if test="${procedimiento!=null}" >
				'${procedimiento.porcentajeRecuperacion}',
		</c:if>
		<c:if test="${procedimiento==null}" >
			'',
		</c:if>
		{labelStyle:labelStyleTextField
		,style:style
		,allowDecimals: true
		,allowNegative: false}
	)
	
	var meses = new Ext.form.NumberField({
		name : 'plazo'
		,allowDecimals: false
		,allowNegative: false
		,fieldLabel : '<s:message code="procedimientos.edicion.mesesrecuperacion" text="**Plazo (meses)" />'
		,labelStyle:labelStyleTextField
		,style:style
		<c:if test="${procedimiento!=null}" >
				,value:'${procedimiento.plazoRecuperacion}'
		</c:if>
		
	});
	
	var dictAsuntos = <json:array name="asuntos" items="${asuntos}" var="asunto">
						<json:object>
							<json:property name="codigo" value="${asunto.id}"/>
							<json:property name="descripcion">
								<s:message text="${asunto.nombre}" javaScriptEscape="true" />
							</json:property>
						</json:object>
					  </json:array>;
	
	//store generico de combo diccionario
	var optionsAsuntosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : dictAsuntos
	       
	});
	
	var comboAsuntos = new Ext.form.ComboBox({
				name:'asunto'
				,hiddenName:'asunto'
				,store:optionsAsuntosStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="" text="**Asuntos" />'
				<c:if test="${procedimiento!=null}" >
					,value:'${procedimiento.asunto.id}'
		   		</c:if>
	});
	
	var dictTipoActuacion = <app:dict value="${tiposActuacion}" />;
	
	var optionsTipoActuacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : dictTipoActuacion
	       ,root: 'diccionario'
	});
	
	var tipoActuacion = new Ext.form.ComboBox({
	    name:'actuacion'
	    ,hiddenName:'actuacion'
	    ,store: optionsTipoActuacionStore
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
		,labelStyle:labelStyle
	    ,editable : false
		,fieldLabel : '<s:message code="procedimientos.edicion.tipoactuacion" text="**Tipo" />'
		<c:if test="${procedimiento!=null}" >
			,value:'${procedimiento.tipoActuacion.codigo}'
		</c:if>
	    //,value : 'actual'
	});
	
	//completar con diccionario
	var dictTipoProcedimiento = <app:dict value="${tiposProcedimientos}" />;
	
	//store generico de combo diccionario
	var optionsTipoProcedimientoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoProcedimiento
	});
	
	var comboTipoProcedimiento = new Ext.form.ComboBox({
				name:'tipoProcedimiento'
				,hiddenName:'tipoProcedimiento'
				,store:optionsTipoProcedimientoStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="procedimientos.edicion.tipoprocedimiento" text="**Tipo Procedimiento" />'
				<c:if test="${procedimiento!=null}" >
					,value:'${procedimiento.tipoProcedimiento.codigo}'
				</c:if>
	});
	
	var dictTipoReclamacion = <app:dict value="${tiposReclamacion}" />;
	
	//store generico de combo diccionario
	var optionsTipoReclamacionStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoReclamacion
	});
	
	var comboTipoReclamacion = new Ext.form.ComboBox({
				name:'tipoReclamacion'
				,hiddenName:'tipoReclamacion'
				,store:optionsTipoReclamacionStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,triggerAction: 'all'
				,labelStyle:labelStyle
				,fieldLabel : '<s:message code="procedimientos.edicion.tiporeclamacion" text="**Tipo Reclamacion" />'
				<c:if test="${procedimiento!=null}" >
					,value:'${procedimiento.tipoReclamacion.codigo}'
				</c:if>
	});
	
	
	var fieldSetEstimacion = new Ext.form.FieldSet({
		title:'<s:message code="procedimientos.edicion.estimacion" text="**Estimacion" />'
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items:[{
				layout:'form'
				,bodyStyle:'padding:5px;cellspacing:20px'
				,autoHeight:true
				,items:[
					saldoOriginalVencido
					,saldoOriginalNoVencido
					,saldoARecuperar
					,recuperacion
					,meses
				]
				//,columnWidth:.5
			}
			
		]
	});
	
/******/
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
            	personasSeleccionadas = rearmarArray(personasSeleccionadas,record.data['id']);
            	personasSeleccionadasString = armarString(personasSeleccionadas);  
            	seleccionPersonas.setValue(personasSeleccionadasString);
            	//alert(this.dataIndex+" "+record.data['id'])
            	record.set(this.dataIndex, !record.data[this.dataIndex]);
        	}
    	},

	    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'"> </div>';
    	}
	}; 


		
/******/	
	var clientesIncluir = 
		<json:array name="gridClientesIncluir" items="${personas}" var="cp">
			<json:object>
				<json:property name="id" value="${cp.contratoPersona.persona.id}"/>
				<json:property name="nombre" value="${cp.contratoPersona.persona.nombre}"/>
				<json:property name="apellido1" value="${cp.contratoPersona.persona.apellido1}"/>
				<json:property name="apellido2" value="${cp.contratoPersona.persona.apellido2}"/>
				<json:property name="deudaIrregular" value="${cp.contratoPersona.persona.riesgoTotal}"/>
				<json:property name="totalSaldo" value="${cp.contratoPersona.persona.totalSaldo}"/>
				<json:property name="tipoIntervencion" value="${cp.contratoPersona.tipoIntervencion.descripcion}"/>
				<json:property name="asiste" value="${cp.asociada}"/>
			</json:object> 
		</json:array>;
	
	/**
	*Función para inicializar los elementos clientes seleccionados.
	*/
	var incializarSeleccionados = function(clientes){
		for (var i=0; i < clientes.length; i++){
			if(clientes[i].asiste==true){
				personasSeleccionadas[personasSeleccionadas.length] = clientes[i].id;
				if (personasSeleccionadasString != ""){
					personasSeleccionadasString += "-";
				}
				personasSeleccionadasString += clientes[i].id;
			}
		}
	}
	
	
	var clientesIncluirStore = new Ext.data.JsonStore({
		data : clientesIncluir
		//,root : 'gridClientesIncluir'
		,fields : ['id','nombre', 'apellido1','apellido2','deudaIrregular','totalSaldo','tipoIntervencion','asiste']
	});
	var checkColumn = new Ext.grid.CheckColumn({ 
		header : '<s:message code="procedimientos.edicion.grid.incluir" text="**Incluir"/>'
		, dataIndex : 'asiste'
		, hideable:false
		, hidden:false
	});
		
	var clientesIncluirCm = new Ext.grid.ColumnModel([
		{ dataIndex : 'id', hidden:true, fixed:true }
		,{header : '<s:message code="procedimientos.edicion.grid.nombre" text="**Nombre"/>', dataIndex : 'nombre' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido1" text="**Apellido1"/>', dataIndex : 'apellido1' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido2" text="**Apellido2"/>', dataIndex : 'apellido2' }
		,{header : '<s:message code="procedimientos.edicion.grid.totaldeudairr" text="**Deuda Irr"/>', dataIndex : 'deudaIrregular' ,renderer: app.format.moneyRenderer}
		,{header : '<s:message code="procedimientos.edicion.grid.totalsaldo" text="**totalsaldo"/>', dataIndex : 'totalSaldo' ,renderer: app.format.moneyRenderer}
		,{header : '<s:message code="procedimientos.edicion.grid.intervencion" text="**Intervencion"/>', dataIndex : 'tipoIntervencion' }
		,checkColumn
	]);
	
	var clientesIncluirGrid = new Ext.grid.GridPanel({
		store : clientesIncluirStore
		,title:'<s:message code="procedimientos.edicion.grid.titulo" text="**Clientes A Incluir" />'
		,cm : clientesIncluirCm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,style:'padding-right:10px'
		,plugins: checkColumn
		,autoWidth:true
		,height : 200
		,doLayout: function() {
			  var parentSize = panelEdicion.getSize(true); 
			  this.setWidth(parentSize.width-10);//el  -10 es un margen
			  Ext.grid.GridPanel.prototype.doLayout.call(this);
		}
	});	
	
	incializarSeleccionados(clientesIncluir);
	seleccionPersonas.setValue(personasSeleccionadasString);
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			
			page.submit({
				eventName : 'updateProcedimiento'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false ,width:372}
				,items : [
					{ items : [ codigoContrato, tipoContrato,tipoActuacion,comboTipoProcedimiento,comboTipoReclamacion,comboAsuntos,seleccionPersonas,seleccionPersonas, idProcedimiento, idContrato, sOrigVenc,sOrigNoVenc], style : 'margin-right:10px' }
					,{
						items : fieldSetEstimacion 
					}
					
				]
			},{
				border:false
				,items: clientesIncluirGrid
			}
		]
		//,bbar : [
		//	btnGuardar, btnCancelar
		//]
	});
	return panelEdicion;
}
