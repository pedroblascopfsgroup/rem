<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createCabeceraProcedimientoTab=function(){
	
	var labelStyle='font-weight:bolder;width:150px';
	var labelStyle2='font-weight:bolder;width:200px';

	var asunto = new Ext.ux.form.StaticTextField(
	{
		fieldLabel : '<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>'
		,rawvalue : "<a href='javascript:app.abreAsunto(${procedimiento.asunto.id}, &quot;${procedimiento.asunto.nombre}&quot;,null);'>${procedimiento.asunto.nombre}</a>"
		,labelStyle : labelStyle2
		,itemCls : 'no-margin'
	});

	var despacho=app.creaLabel('<s:message code="asunto.tabcabecera.despacho" text="**Despacho"/>','${procedimiento.asunto.gestor.despachoExterno.despacho}',{labelStyle:labelStyle2});
	var gestor=app.creaLabel('<s:message code="asunto.tabcabecera.gestor" text="**Gestor"/>','${procedimiento.asunto.gestor.usuario.apellidoNombre}',{labelStyle:labelStyle2});
	var supervisor=app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>','${procedimiento.asunto.supervisor.usuario.apellidoNombre}',{labelStyle:labelStyle2});
	var procurador=app.creaLabel('<s:message code="asunto.tabcabecera.procurador" text="**procurador"/>','${procedimiento.asunto.procurador.usuario.apellidoNombre}',{labelStyle:labelStyle2});
	var fechaInicio=app.creaLabel('<s:message code="procedimiento.tabcabecera.fechainicio" text="**Fecha Inicio"/>',"<fwk:date value='${procedimiento.auditoria.fechaCrear}' />",{labelStyle:labelStyle2});
	
	var panelAsunto = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:380}
		    ,items : [{items:[asunto,despacho,fechaInicio]},
					  {items:[gestor,supervisor,procurador]}
					 ]
		});

	
	var procedimiento=app.creaLabel('<s:message code="procedimiento.tabcabecera.procedimiento" text="**Procedimiento"/>','${procedimiento.tipoProcedimiento.descripcion}',{labelStyle:labelStyle2 <app:test id="tipoProcedimientoLabel" addComa="true" />});
	var procedimientoInterno=app.creaLabel('<s:message code="procedimiento.tabcabecera.procinterno" text="**Nro. Proc. Interno"/>','${procedimiento.id}',{labelStyle:labelStyle2 <app:test id="procedimientoInternoLabel" addComa="true" />});
	var procedimientoJuzgado=app.creaLabel('<s:message code="procedimiento.tabcabecera.procjuzgado" text="**Nro. Proc. en Juzgado"/>','${procedimiento.codigoProcedimientoEnJuzgado}',{labelStyle:labelStyle2});
	var juzgado=app.creaLabel('<s:message code="procedimiento.tabcabecera.juzgado" text="**Juzgado"/>','${procedimiento.juzgado.descripcion}',{labelStyle:labelStyle2});
    var plazaJuzgado=app.creaLabel('<s:message code="procedimiento.tabcabecera.plaza" text="**Plaza"/>','${procedimiento.juzgado.plaza.descripcion}',{labelStyle:labelStyle2});
	var reclamacion=app.creaLabel('<s:message code="procedimiento.tabcabecera.reclamacion" text="**Reclamacion"/>','${procedimiento.tipoReclamacion.descripcion}',{labelStyle:labelStyle2 <app:test id="reclamacionLabel" addComa="true" />});
	var estado=app.creaLabel('<s:message code="procedimiento.tabcabecera.estado" text="**Estado"/>','${procedimiento.estadoProcedimiento.descripcion}',{labelStyle:labelStyle2 <app:test id="estadoLabel" addComa="true" />});
	
		var panelProcedimiento = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="procedimiento.tabcabecera.procedimiento" text="**Procedimiento"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:380}
		    ,items : [{items:[procedimiento,procedimientoInterno,procedimientoJuzgado]},
					  {items:[juzgado,plazaJuzgado, estado]}
					 ]
		});
	



	var saldoVencido=app.creaLabel('<s:message code="procedimiento.tabcabecera.saldovencido" text="**Saldo Vencido Actual"/>',app.format.moneyRenderer('${procedimiento.saldoVencidoActual}'),{labelStyle:labelStyle2 <app:test id="saldoVencidoLabel" addComa="true" />});
	var saldoNoVencido=app.creaLabel('<s:message code="procedimiento.tabcabecera.saldonovencido" text="**Saldo No Vencido Actual"/>',app.format.moneyRenderer('${procedimiento.saldoNoVencidoActual}'),{labelStyle:labelStyle2});
	var saldoOriginalVencido=app.creaLabel('<s:message code="procedimiento.tabcabecera.saldovencidooriginal" text="**Saldo Original Vencido"/>',app.format.moneyRenderer('${procedimiento.saldoOriginalVencido}'),{labelStyle:labelStyle2});
	var saldoOriginalNoVencido=app.creaLabel('<s:message code="procedimiento.tabcabecera.saldonovencidooriginal" text="**Saldo Original No Vencido"/>',app.format.moneyRenderer('${procedimiento.saldoOriginalNoVencido}'),{labelStyle:labelStyle2});
	var saldoRecuperar=app.creaLabel('<s:message code="procedimiento.tabcabecera.saldorecuperar" text="**Saldo a Recuperar"/>',app.format.moneyRenderer('${procedimiento.saldoRecuperacion}'),{labelStyle:labelStyle2});
	var recuperacion=app.creaLabel('<s:message code="procedimiento.tabcabecera.recuperacion" text="**% Recuperacion"/>','${procedimiento.porcentajeRecuperacion} %',{labelStyle:labelStyle2 <app:test id="porcentajeRecuperacionLabel" addComa="true" />});
	var meses=app.creaLabel('<s:message code="procedimiento.tabcabecera.tiempo" text="**Tiempo"/>','${procedimiento.plazoRecuperacion} <s:message code="procedimiento.tabcabecera.meses" text="**meses"/>',{labelStyle:labelStyle2 <app:test id="mesesRecuperacionLabel" addComa="true" />});
	
			var panelRecuperacion = new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="procedimiento.tabcabecera.estimacionrecuperacion" text="**Estimacion Recuperacion"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:380}
		    ,items : [{items:[saldoVencido,saldoNoVencido,saldoOriginalVencido, saldoOriginalNoVencido]},
					  {items:[reclamacion,saldoRecuperar,recuperacion,meses]}
					 ]
		});
	
	

/*
	var tarAnterior=app.creaLabel('<s:message code="procedimiento.tabcabecera.taranterior" text="**Tarea Anterior"/>','TODO! artf450119 WEB-06',{labelStyle:labelStyle2});
	var tarActual=app.creaLabel('<s:message code="procedimiento.tabcabecera.taractual" text="**Tarea Actual"/>','TODO! artf450119 WEB-06',{labelStyle:labelStyle2});
	var tarProxima=app.creaLabel('<s:message code="procedimiento.tabcabecera.tarproxima" text="**Tarea Siguiente"/>','TODO! artf450119 WEB-06',{labelStyle:labelStyle2});
	
	var panelTareas=new Ext.form.FieldSet({
		title:'<s:message code="procedimiento.tabcabecera.tareas" text="**Tareas"/>'
		,autoHeight:true
		,border:true
		,items:[tarAnterior,tarActual,tarProxima]
	});
*/	
	
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
	

/*
	var clientesIncluir = 
	<json:object name="clientes">
			<json:array name="clientes" items="${procedimiento.expedienteContratos}" var="ec">	
				<c:forEach items="${ec.contrato.contratoPersona}" var="per">
					<json:object>
						<json:property name="id" value="${per.persona.id}"/>
						<json:property name="apellidoNombre" value="${per.persona.apellidoNombre}"/>
						<json:property name="nombre" value="${per.persona.nombre}"/>
						<json:property name="apellido1" value="${per.persona.apellido1}"/>
						<json:property name="apellido2" value="${per.persona.apellido2}"/>
				 		<json:property name="deudaIrregular" value="${per.persona.deudaIrregular}"/>
				 	 	<json:property name="totalSaldo" value="${per.persona.totalSaldo}"/>
				 	 	<json:property name="tipoIntervencion" value="${per.tipoIntervencion.descripcion}"/>
				 	 	<c:forEach items="${procedimiento.personasAfectadas}" var="pa">
					 	 	<c:if test="${per.persona.id==pa.id}">
					 	 		<json:property name="asiste" value="true" />
					 	 	</c:if>
				 	 	</c:forEach>
	 				</json:object>
		 	 	</c:forEach>
			</json:array>
		</json:object>;
*/


	var clientesIncluir = 
	<json:object name="clientes">
			<json:array name="clientes" items="${procedimiento.personasAfectadas}" var="per">	
				<json:object>
					<json:property name="id" value="${per.id}"/>
					<json:property name="apellidoNombre" value="${per.apellidoNombre}"/>
					<json:property name="nombre" value="${per.nombre}"/>
					<json:property name="apellido1" value="${per.apellido1}"/>
					<json:property name="apellido2" value="${per.apellido2}"/>
			 		<json:property name="deudaIrregular" value="${per.deudaIrregular}"/>
			 	 	<json:property name="totalSaldo" value="${per.totalSaldo}"/>			 	 	
		 	 		<json:property name="asiste" value="true" />
 				</json:object>
			</json:array>
		</json:object>;

		
	var clientesIncluirStore = new Ext.data.JsonStore({
		data : clientesIncluir
		,root : 'clientes'
		,fields : ['id','apellidoNombre','nombre', 'apellido1','apellido2','deudaIrregular','totalSaldo','tipoIntervencion','asiste']
	});
	var checkColumn = new Ext.grid.CheckColumn({ 
		header : '<s:message code="procedimientos.edicion.grid.incluido" text="**Incluido"/>'
		, dataIndex : 'asiste'
		,width:40
	});
	var clientesIncluirCm = new Ext.grid.ColumnModel([
		{hidden:true, fixed:true, dataIndex : 'id' }
		,{hidden:true,  dataIndex : 'apellidoNombre' }
		,{header : '<s:message code="procedimientos.edicion.grid.nombre" text="**Nombre"/>', dataIndex : 'nombre' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido1" text="**Apellido1"/>', dataIndex : 'apellido1' }
		,{header : '<s:message code="procedimientos.edicion.grid.apellido2" text="**Apellido2"/>', dataIndex : 'apellido2' }
		,{header : '<s:message code="procedimientos.edicion.grid.totaldeudairr" text="**Deuda Irr"/>', dataIndex : 'deudaIrregular' ,renderer: app.format.moneyRenderer,align:'right'}
		,{header : '<s:message code="procedimientos.edicion.grid.totalsaldo" text="**totalsaldo"/>', dataIndex : 'totalSaldo' ,renderer: app.format.moneyRenderer,align:'right'}
		,checkColumn
	]);
	var clientesGrid = app.crearGrid(clientesIncluirStore,clientesIncluirCm,{
		title:'<s:message code="procedimientos.edicion.grid.titulo" text="**Clientes A Incluir" />'
		,iconCls:'icon_cliente'
		,style:'padding-right:10px'
		//,plugins: checkColumn
		,height : 140
	});
	
	clientesGrid.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
		
		var idPersona = rec.get('id');
		var otrosint = rec.get('apellidoNombre');
		app.abreCliente(idPersona, otrosint);
		}
	);
	
	var panel = new Ext.Panel({
		title:'<s:message code="procedimiento.tabcabecera.titulo" text="**Cabecera"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px;'
		,items:[{
					layout : 'table'
					,border : false
					,layoutConfig:{
						columns:1
					}
					,defaults : {autoHeight : true, border : true ,cellCls : 'vtop', width:780,style:'cellspacing:5px'}
					,items:[panelAsunto,panelProcedimiento,panelRecuperacion]
				},clientesGrid
			]
	});
		
	return panel;
};
