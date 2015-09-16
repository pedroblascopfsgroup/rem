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
	//TODO: 02/04/2009: Se quitan estos campos momentaneamente porque esta dando error al calcular volumen de riesgos absoluto, aparentemente se esta intentando recuperar el valor antes de que el expediente este generado
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
				 		<json:property name="tipo" value="${contrato.tipoProducto.descripcion}" />
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
				 		<json:property name="tipo" value="${contrato.tipoProducto.descripcion}" />
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
	});

	// Los labels para 'Motivo' y 'Observaciones' se ponen arriba de los componentes
	// para que entre todo bien, porque el form es muy grande, y al ser tan ancho
	// en IE no anda bien
	var labelMotivos = new Ext.form.Label({
	    	text:'<s:message code="expedientes.creacion.motivos" text="**Motivos:" />'
			,style:'font-weight:bolder; font-size:11'
	}); 

	var labelObservaciones = new Ext.form.Label({
	    	text:'<s:message code="expedientes.creacion.observaciones" text="**Observaciones Supervisor:"/>'
			,style:'font-weight:bolder; font-size:11'
	});

	var comboMotivos = new Ext.form.ComboBox({
				store:optionsMotivosStore
				,name:'codigoMotivo'
				,displayField:'descripcion'
				,valueField:'codigo'				
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:'font-weight:bolder'
				,hideLabel:true
				//,fieldLabel : '<s:message code="expedientes.creacion.motivos" text="**Motivos" />'
				,value : '${propuesta.motivo.codigo}'
				,width:155
	});

	var observaciones = new Ext.form.TextArea({
		//fieldLabel:'<s:message code="expedientes.creacion.observaciones" text="**Supervisor"/>'
		 hideLabel:true
		,name:'observaciones'
		,width:155
		,maxLength:1024
		,value : '<s:message text="${propuesta.observaciones}" javaScriptEscape="true" />'
	});
	var propuesta = '${propuesta.id}';
	var propuestaH = new Ext.form.Hidden({name:'idPropuesta', value :'${propuesta.id}'}) ;
	if (propuesta!=null && propuesta != ''){
		comboMotivos.disabled = true;
		observaciones.disabled = true;
	}
	
	var panelObs ={
		xtype:'fieldset'
		,autoHeight:'true'
		,border:false
		,items:[labelMotivos,comboMotivos,labelObservaciones,observaciones]
	}
	var cntStore = new Ext.data.JsonStore({
	    	data: contVenc
	    	,root: 'contVenc'
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
							,txtEstado]}
						,{}
						,{ items:[
							//txtVolRiesgos
							//,txtVolRiesgosVenc
							//,
							txtGestor,txtSupervisor, propuestaH
							,txtComite
							,txtOficina]}
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


		if (!observaciones.validate())
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="error.maxLenght" arguments="'+observaciones.maxLength+'"/>');
			return;	
		}


		page.webflow({
			flow : 'expedientes/creacionManualExpediente_3_GV'
			,params : {
						idExpediente:'${expediente.id}'
						,idPersona:'${idPersona}'
						,codigoMotivo:comboMotivos.getValue()
						,observaciones:observaciones.getValue()
						,idPropuesta:'${propuesta.id}' || -1
						,isSupervisor:${isSupervisor}
						,idArquetipo:${idArquetipo}
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
						flow : 'expedientes/borrarCreacionManualExpediente_GV'
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