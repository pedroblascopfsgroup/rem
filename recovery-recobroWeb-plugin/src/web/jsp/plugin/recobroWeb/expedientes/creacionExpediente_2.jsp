<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var txtCodExpediente	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.codigo" text="**Codigo"/>','${expediente.id}');
	var txtSituacion		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.situacion" text="**Situacion"/>','${expediente.estadoItinerario.descripcion}');
	var txtEstado			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.estado" text="**Estado"/>','${expediente.estadoExpediente.descripcion}');
	var txtDescripcion		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.descripcion" text="**Descripcion"/>','<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />');

	<%--
	var txtVolRiesgos		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.riesgos" text="**Volumen riesgos"/>',app.format.moneyRenderer('expediente.volumenRiesgoAbsoluto'));
	var txtVolRiesgosVenc	= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.riesgosvencidos" text="**Volumen riesgos Vencidos"/>',app.format.moneyRenderer('expediente.volumenRiesgoVencidoAbsoluto'));
	--%>
	//------------------
	
	var txtComite			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.comite" text="**Comite"/>','${expediente.comite.nombre}');
	var txtFechaComite		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.fechavto" text="**Fecha Comite"/>',"<fwk:date value='${expediente.fechaAComite}' />");
	
	var txtOficina			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.oficina" text="**Oficina"/>','${expediente.oficina.nombre}');

	var txtGestor			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.gestor" text="**Gestor"/>','${expediente.gestorActual}');
	var txtSupervisor		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>','${expediente.supervisorActual}');
	var isGestor = '${isGestor}';
	var isSupervisor = '${isSupervisor}';
	var proponer = '${proponer}';

	var contVenc = <json:object name="contVenc">
			<json:array name="contVenc" items="${expediente.listaContratoPase}" var="contrato">	
					<json:object>
						<json:property name="id" value="${id}" />
						<json:property name="vencido" value="${contrato.vencido}" />
						<json:property name="cc" value="${contrato.codigoContrato}" />
				 		<json:property name="tipo" value="${contrato.tipoProductoEntidad.descripcion}" />
				 	 	<json:property name="diasIrregular" value="${contrato.diasIrregular}" />
				 	 	<json:property name="saldoNoVencido" value="${contrato.lastMovimiento.posVivaNoVencida}" />
				 	 	<json:property name="saldoIrregular" value="${contrato.lastMovimiento.posVivaVencida}" />
				 	 	<json:property name="idPersona" value="${contrato.contratoPersona[0].persona.id}" />
				 	 	<json:property name="otrosint" value="${contrato.contratoPersona[0].persona.apellidoNombre}" />
						<json:property name="apellido1" value="${contrato.contratoPersona[0].persona.apellido1}" />
						<json:property name="apellido2" value="${contrato.contratoPersona[0].persona.apellido2}" />
				 	 	<json:property name="tipointerv" value="${contrato.contratoPersona[0].tipoIntervencion.descripcion}" />
						<json:property name="estadoFinanciero" value="${c.estadoFinanciero.descripcion}" />
					</json:object>
					
					<c:forEach items="${contrato.contratoPersona}" var="cp">
						<c:if test="${cp.persona.id!=contrato.contratoPersona[0].persona.id}">
							<json:object>
								<json:property name="idPersona" value="${cp.persona.id}" />
								<json:property name="tipointerv" value="${cp.tipoIntervencion.descripcion}" />
								<json:property name="otrosint" value="${cp.persona.apellidoNombre}" />
								<json:property name="apellido1" value="${cp.persona.apellido1}" />
								<json:property name="apellido2" value="${cp.persona.apellido2}" />
								<json:property name="saldoNoVencido" value="---" />
				 	 			<json:property name="saldoIrregular" value="---" />
							</json:object>
					</c:if>
					</c:forEach>
					
			</json:array>
		</json:object>;

	var contNoVenc = <json:object name="contNoVenc">
			<json:array name="contNoVenc" items="${expediente.contratosNoPaseActivos}" var="contrato">	
					<json:object>
						<json:property name="id" value="${id}" />
						<json:property name="vencido" value="${contrato.vencido}" />
						<json:property name="cc" value="${contrato.codigoContrato}" />
				 		<json:property name="tipo" value="${contrato.tipoProductoEntidad.descripcion}" />
				 	 	<json:property name="diasIrregular" value="${contrato.diasIrregular}" />
				 	 	<json:property name="saldoNoVencido" value="${contrato.lastMovimiento.posVivaNoVencida}" />
				 	 	<json:property name="saldoIrregular" value="${contrato.lastMovimiento.posVivaVencida}" />
				 	 	<json:property name="idPersona" value="${contrato.contratoPersona[0].persona.id}" />
				 	 	<json:property name="otrosint" value="${contrato.contratoPersona[0].persona.apellidoNombre}" />
						<json:property name="apellido1" value="${contrato.contratoPersona[0].persona.apellido1}" />
						<json:property name="apellido2" value="${contrato.contratoPersona[0].persona.apellido2}" />
				 	 	<json:property name="tipointerv" value="${contrato.contratoPersona[0].tipoIntervencion.descripcion}" />
						<json:property name="estadoFinanciero" value="${c.estadoFinanciero.descripcion}" />
					</json:object>
					
					<c:forEach items="${contrato.contratoPersona}" var="cp">
						<c:if test="${cp.persona.id!=contrato.contratoPersona[0].persona.id}">
							<json:object>
								<json:property name="idPersona" value="${cp.persona.id}" />
								<json:property name="tipointerv" value="${cp.tipoIntervencion.descripcion}" />
								<json:property name="otrosint" value="${cp.persona.apellidoNombre}" />
								<json:property name="apellido1" value="${cp.persona.apellido1}" />
								<json:property name="apellido2" value="${cp.persona.apellido2}" />
								<json:property name="saldoNoVencido" value="---" />
				 	 	<json:property name="saldoIrregular" value="---" />
							</json:object>
					</c:if>
					</c:forEach>
					
			</json:array>
		</json:object>;
	
	var dictMotivos = <app:dict value="${motivos}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	//store generico de combo diccionario
	var optionsMotivosStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictMotivos
	       ,id: 'optionsMotivosStore'
	});

	// Los labels para 'Motivo' y 'Observaciones' se ponen arriba de los componentes
	// para que entre todo bien, porque el form es muy grande, y al ser tan ancho
	// en IE no anda bien
	var labelMotivos = new Ext.form.Label({
	    	text:'<s:message code="expedientes.creacion.motivos" text="**Motivos:" />'
			,style:'font-weight:bolder; font-size:11'
			,id: 'labelMotivos'
	});
	
	
	
	
	var agenciasRecobroRecord = <json:object>
		<json:array name="listado" items="${agenciasRecobro}" var="d">				 
		 <json:object>
		 	<json:property name="id" value="${d.id}" />
		   <json:property name="codigo" value="${d.codigo}" />
		   <json:property name="nombre" value="${d.nombre}" />
		   <json:property name="despacho" value="${d.despacho.id}" />
		 </json:object>
		</json:array>
	</json:object>;
	
	var optionsAgenciasRecobroStore = new Ext.data.JsonStore({
	       fields: ['id', 'codigo', 'nombre', 'despacho']
	       ,root: 'listado'
	       ,data : agenciasRecobroRecord
	       ,id: 'optionsAgenciasRecobroStore'
	});
	
	var comboAgenciasRecobro = new Ext.form.ComboBox ({
	   store: optionsAgenciasRecobroStore
	  	,name:'comboAgenciasRecobro'
	  	,id:'comboAgenciasRecobro'
		,displayField:'nombre'
		,valueField:'codigo'
		,mode: 'local'
		,triggerAction: 'all'
		,emptyText:'----'
		,labelStyle:'font-weight:bolder'
		//,hideLabel:true
		,fieldLabel : '<s:message code="plugin.recobroWeb.creacionExpediente.agencias" text="**Agencia" />'
	    ,width:150
	    ,editable:false
	 });
					 
	 comboAgenciasRecobro.on('select', function(){
	 	debugger;
	 	var record = optionsAgenciasRecobroStore.findExact('codigo', comboAgenciasRecobro.getValue());
		if (record != -1) {
			optionsUsuarioStore.webflow({'idAgencia': optionsAgenciasRecobroStore.getAt(record).get('id') }); 
			comboTipoUsuario.reset();		
			comboTipoUsuario.setDisabled(false);
		}
	});	
	 
	var tipoUsuario = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
	]);
	
	var optionsUsuarioStore = page.getStore({
	       flow: 'expedienterecobro/getListSupervisoresAgencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'diccionario'
	    }, tipoUsuario)	       
	});		
	
	var comboTipoUsuario = new Ext.form.ComboBox ({
		store:  optionsUsuarioStore,
		emptyText:'---',
		disabled:true,
		displayField: 'nombre',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.recobroWeb.creacionExpediente.supervisor" text="**Supervisor" />',
		loadingText: 'Buscando...',
		labelStyle:'font-weight:bolder',
		width: 150,
		pageSize: 10,
		mode: 'local',
		triggerAction: 'all',
		editable:false
	});
	
	comboTipoUsuario.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	
	
	<%-- comboTipoDespacho.on('select', function(){

		optionsUsuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue(),'idTipoGestor': comboTipoGestor.getValue()}); 
		comboTipoUsuario.reset();		
		comboTipoUsuario.setDisabled(false);
	}); --%>	
	
	
	<%-- var comboGestoresAgencia = new Ext.form.ComboBox ({
		store:  optionsGestoresStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		displayField: 'nombre',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.recobroWeb.creacionExpediente.gestores" text="**Gestores2" />',
		loadingText: 'Buscando...',
		labelStyle:labelStyleCombo,
		width: 200,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	}); --%>
			
	var modeloFacturacionRecord = <json:object>
		<json:array name="listado" items="${modeloFacturacion}" var="d">				 
		 <json:object>
		   <json:property name="nombre" value="${d.nombre}" />
		   <json:property name="descripcion" value="${d.descripcion}" />
		 </json:object>
		</json:array>
	</json:object>;
	
	var optionsModelosStore = new Ext.data.JsonStore({
	       fields: ['nombre', 'descripcion']
	       ,root: 'listado'
	       ,data : modeloFacturacionRecord
	       ,id:'optionsModelosStore'
	});
	
	
	var dictTipoRiesgo = <app:dict value="${tipoRiesgo}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
	var optionsTipoRiesgoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictTipoRiesgo
	       ,id:'optionsTipoRiesgoStore'
	});
	
	

	var labelObservaciones = new Ext.form.Label({
	    	text:'<s:message code="expedientes.creacion.observaciones" text="**Observaciones Supervisor:"/>'
			,style:'font-weight:bolder; font-size:11'
			,id:'labelObservaciones'
	});

	var comboMotivos = new Ext.form.ComboBox({
				store:optionsMotivosStore
				,name:'comboMotivo'
				,id:'comboMotivo'
				,displayField:'descripcion'
				,valueField:'codigo'				
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:'font-weight:bolder'
				,hideLabel:true
				//,fieldLabel : '<s:message code="expedientes.creacion.motivos" text="**Motivos" />'
				,value : '${propuesta.motivo.codigo}'
				,width:155
				,editable:false
	});

var comboTipoRiesgo = new Ext.form.ComboBox ({
		store: optionsTipoRiesgoStore
	  	,name:'comboTipoRiesgo'
	  	,id:'comboTipoRiesgo'
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode: 'local'
		,emptyText:'----'
		,labelStyle:'font-weight:bolder'
		,width:150
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.recobroWeb.creacionExpediente.tipoGestion" text="**Tipo gestión" />'
		,editable:false
	 });
	 	  
	 	  
	var comboModeloFacturacion = new Ext.form.ComboBox({
		store: optionsModelosStore
	  	,name:'comboModeloFacturacion'
	  	,id:'comboModeloFacturacion'
		,displayField:'descripcion'
		,valueField:'nombre'
		,mode: 'local'
		,emptyText:'----'
		,labelStyle:'font-weight:bolder'
		,width:150
		,triggerAction: 'all'
		,fieldLabel : '<s:message code="plugin.recobroWeb.creacionExpediente.modeloFacturacion" text="**Modelo facturacion" />'
		,editable:false
	});
	var observaciones = new Ext.form.TextArea({
		//fieldLabel:'<s:message code="expedientes.creacion.observaciones" text="**Supervisor"/>'
		 hideLabel:true
		,name:'observaciones'
		,id:'observaciones'
		,width:155
		,maxLength:1024
		,value : '<s:message text="${propuesta.observaciones}" javaScriptEscape="true" />'
	});
	var propuesta = '${propuesta.id}';
	var propuestaH = new Ext.form.Hidden({name:'idPropuesta', id:'idPropuesta', value :'${propuesta.id}'}) ;
	if (propuesta!=null && propuesta != ''){
		comboMotivos.disabled = true;
		observaciones.disabled = true;
	}
	
	var panelObs ={
		xtype:'fieldset'
		,autoHeight:'true'
		,id:'panelObs'
		,border:false
		,items:[labelMotivos,comboMotivos,labelObservaciones,observaciones]
	}
	var cntStore = new Ext.data.JsonStore({
	    	data: contVenc
	    	,root: 'contVenc'
	    	,id: 'cntStore'
	    	,fields: [
	    		'cc'
	    		,'idPersona'
	    		,{name:'vencimiento', type:'date'}
	    		,'tipo'
	    		,'tipointerv'
	    		,'otrosint'
	    		,'diasIrregular'
	    		,'apellido1'
	    		,'apellido2'
	    		,{name:'saldoIrregular'}
	    		,{name:'saldoNoVencido'}
	    		,{name:'estadoFinanciero'}
	    	]
	});
	//ColumnModel para grids contratos
	var contVencCm= new Ext.grid.ColumnModel([
		    {header: '<s:message code="listadocontratos.cc" text="**CC"/>', width: 120,  dataIndex: 'cc'},
		    {header: '<s:message code="listadocontratos.tipoproducto" text="**Tipo Producto"/>', width: 120,  dataIndex: 'tipo'},
			{header: '<s:message code="listadocontratos.saldoirregular" text="**Saldo Irregular"/>', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'},
			{header: '<s:message code="listadocontratos.saldonovencido" text="**Saldo No Vencido"/>', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {header: '<s:message code="listadocontratos.diasirregular" text="**Dias Irregular"/>', width: 120, 	dataIndex: 'diasIrregular'},
		    {header: '<s:message code="listadocontratos.otrosinterviniente" text="**Otros Interviniente"/>', width: 135,dataIndex: 'otrosint'},
			{header: '<s:message code="listadocontratos.tipointervencion" text="**Tipo Intervencion"/>', width: 135, dataIndex: 'tipointerv'},
			{header: '<s:message code="listadocontratos.estadofinanc" text="**Estado Financ"/>', width: 135, dataIndex: 'estadoFinanciero'},
			{hidden:true, dataIndex: 'idPersona',fixed:true}
		]
	);
	
	var cntNoVencStore = new Ext.data.JsonStore({
	    	data: contNoVenc
	    	,root: 'contNoVenc'
	    	,id: 'cntNoVencStore'
	    	,fields: [
	    		'cc'
	    		,'idPersona'
	    		,{name:'vencimiento', type:'date'}
	    		,'tipo'
	    		,'tipointerv'
	    		,'otrosint'
	    		,'diasIrregular'
	    		,'apellido1'
	    		,'apellido2'
	    		,{name:'saldoIrregular'}
	    		,{name:'saldoNoVencido'}
	    		,{name:'estadoFinanciero'}
	    	]
	});
	var contratosGrid= new Ext.grid.GridPanel({
			store:cntStore
			,cm:contVencCm
			,id: 'contratosGrid'
			,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
			,title:'<s:message code="expedientes.consulta.tabcabecera.contPase" text="**Contrato que genero el pase"/>'
			,style : 'margin-bottom:10px;padding-right:10px'
			,iconCls : 'icon_contratos_pase'
			,height:150
			,width:730
			,viewConfig:{forceFit:true}
	});	
	
	var contratosNoVencGrid = new Ext.grid.GridPanel({
		store : cntNoVencStore
		,id: 'contratosNoVencGrid'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="expedientes.consulta.tabcabecera.otrosCont" text="**Resto de Contratos"/>'
		,cm : contVencCm
		,style : 'margin-bottom:10px;padding-right:10px'
		,iconCls : 'icon_contratos_otros'
		,width:730
		,height : 150
		//,doLayout: function() {
		//	  var parentSize = panel.getSize(true); 
		//	  this.setWidth(parentSize.width-10);//el  -10 es un margen
		//	  Ext.grid.GridPanel.prototype.doLayout.call(this);
		//}
	});	
	var panel = new Ext.form.FormPanel({
		//autoHeight : true
		autoWidth:true
		,id:'panelExpedienteManual'
		,bodyStyle : 'padding:10px'
		,autoScroll:true
		,border:false
		,height:500
		,items:[
		 		{ xtype : 'errorList', id:'errL' }
				,{
					layout : 'table'
					,border : false
					,layoutConfig:{
						columns:5
					}
					,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'border-left:1px solid #ccc;padding-left:5px'}
					,items:[
						{ items:[
							txtCodExpediente
							,txtDescripcion
							,txtSituacion
							,txtEstado
							,comboModeloFacturacion]}
						,{}
						,{ items:[
							//txtVolRiesgos
							//,txtVolRiesgosVenc
							//,
							comboAgenciasRecobro							
							,comboTipoUsuario
							,propuestaH
							,txtComite
							,txtOficina
							,comboTipoRiesgo]}
						,{}
						,panelObs
					]
				}
				,contratosGrid
				,contratosNoVencGrid
				
			]
	});

	page.on('update', function(){ 
		//page.submit({
		//		eventName : 'update'
		//		,formPanel : panel
		//		,success : function(){ page.fireEvent(app.event.DONE); } 	
		//	});


		if (comboMotivos.getValue()  == '')
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expediente.error.motivos"/>');
			return;	
		}
		
		if (comboModeloFacturacion.getValue()  == '')
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobro.expedientes.error.modeloFacturacion" text="**Debe indicar el modelo de facturación"/>');
			return;	
		}
		
		if (!observaciones.validate())
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="error.maxLenght" arguments="'+observaciones.maxLength+'"/>');
			return;	
		}
		
		if (comboAgenciasRecobro.getValue()  == '')
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobro.expedientes.error.agencias" text="**Debe indicar la agencia"/>');
			return;	
		}

		if (comboTipoUsuario.getValue()  == '')
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.recobro.expedientes.error.supervisor" text="**Debe indicar el supervisor"/>');
			return;	
		}

		page.webflow({
			flow : 'plugin/recobroWeb/expedientes/creacionManualExpediente_3'
			,params : {
						idExpediente:'${expediente.id}'
						,idPersona:'${idPersona}'
						,codigoMotivo:comboMotivos.getValue()
						,observaciones:observaciones.getValue()
						,idPropuesta:'${propuesta.id}' || -1
						,isSupervisor:${isSupervisor}
						,modeloFacturacion:comboModeloFacturacion.getValue()
						,tipoRiesgo:comboTipoRiesgo.getValue()
						,agenciaRecobro: comboAgenciasRecobro.getValue()
						,idSupervisor: comboTipoUsuario.getValue()
					}
			,success : function(){
				page.fireEvent(app.event.DONE);
			}
		});


		}
	);

	var decide = function(boton) {
			//if (boton=='yes'){
			//		page.submit({
			//				eventName : 'cancel'
			//				,formPanel : panel
			//				,success : function() { page.fireEvent(app.event.CANCEL); }
			//			});
			//}
			if (boton=='yes') {
					page.webflow({
						flow : 'plugin/recobroWeb/expedientes/borrarCreacionManualExpediente'
						,params : {idExpediente : '${expediente.id}', idPersona : '${idPersona}' }
						,success : function() { page.fireEvent(app.event.CANCEL); }
						,scope:this
					});
			}
	};

	page.on('cancelar', function(){
		Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="expedientes.creacion.cancelar" text="**¿Cancelar y borrar el expediente creado?" />', decide, this);
		//page.submit({
		//		eventName : 'cancel'
		//		,formPanel : panel
		//		,success : function() { page.fireEvent(app.event.CANCEL); }
		//	});
	  }
	);
	page.add(panel);

	
</fwk:page>