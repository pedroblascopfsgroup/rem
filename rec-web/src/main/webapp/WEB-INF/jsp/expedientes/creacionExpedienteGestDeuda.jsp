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

	var txtComite			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.comite" text="**Comite"/>','${expediente.comite.nombre}');
	var txtFechaComite		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.fechavto" text="**Fecha Comite"/>',"<fwk:date value='${expediente.fechaAComite}' />");

	var txtOficina			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.oficina" text="**Oficina"/>','${expediente.oficina.nombre}');

	var txtGestor			= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.gestor" text="**Gestor"/>','${expediente.gestorActual}');
	var txtSupervisor		= app.creaLabel('<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>','${expediente.supervisorActual}');


	var perfilGestor = '${clienteActivo.idGestorActual}';
	var perfilSupervisor = '${clienteActivo.idSupervisorActual}';

	var isGestor=false;
	var isSupervisor=false;
	if(permisosVisibilidadGestorSupervisor(perfilGestor)) {
		isGestor=true;
	}
	if(permisosVisibilidadGestorSupervisor(perfilSupervisor)) {
		isSupervisor=true;
	}
	var proponer=${proponer}!=null?${proponer}:'';
	
	//si viene proponer en false, es como si fuera supervisor -> puede activar el expediente directamente sin proponerlo
	isSupervisor = isSupervisor || !proponer ;
	

    var crearExpediente = function(borrar) {
        if(borrar != 'yes') {
            return;
        }
        page.webflow({
            flow: 'expedientes/creacionManualExpedientesGestionDeuda2'
            ,params: {
                    idExpediente:'${expediente.id}'
                    ,idPersona:'${idPersona}'
                    ,codigoMotivo:comboMotivos.getValue()
                    ,observaciones:observaciones.getValue()
                    ,idPropuesta:'${propuesta.id}' || -1
                    ,isSupervisor:isSupervisor
                    ,idArquetipo:${idArquetipo}
                }
            ,success: function(){
                page.fireEvent(app.event.DONE);
            }
          });
    };

    var arquetipo = '${expediente.arquetipo.nombre}';
    var perfilGestor = '${expediente.gestorActual}';
    var perfilSupervisor = '${expediente.supervisorActual}';

	var updatePropuesta = function() {
		if (comboMotivos.getValue() == '') {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expediente.error.motivos"/>');
			return;	
		}
		if (!observaciones.validate()) {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="error.maxLenght" arguments="'+observaciones.maxLength+'"/>');
			return;
		}

        Ext.Msg.confirm('<s:message code="expediente.manual.confirmarCreacion.titulo"/>', 
                        '<s:message code="expediente.manual.confirmarCreacion.mensaje" arguments="'+arquetipo+', '+perfilGestor+', '+perfilSupervisor+'"/>',
                        crearExpediente);


	  };

	var btnNext = new Ext.Button({
		disabled: true
		,iconCls: 'icon_siguiente'
		,handler: updatePropuesta
	  });

	var decide = function(boton) {
		debugger;
		if (boton=='yes') {
			page.webflow({
				flow: 'expedientes/borrarCreacionManualExpediente'
				,params: {idExpediente : '${expediente.id}', idPersona : '${idPersona}' }
				,success: function() { page.fireEvent(app.event.DONE); }
				,scope:this
			});
		}
	};


	var btnCancelar = new Ext.Button({
		text: '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls: 'icon_cancel'
		,handler: function() {
			Ext.Msg.confirm(fwk.constant.confirmar
			                ,'<s:message code="expedientes.creacion.cancelar" text="**�Cancelar y borrar el expediente creado?" />'
			                ,decide
			                ,this);
		  }
	  });

	
	if (isSupervisor==true) {
		btnNext.setText('<s:message code="expedientes.creacion.activar" text="**Activar"/>');
		btnNext.enable();
	} else if('${propuesta.id}'!='') {
		btnNext.setText('Proponer');
		btnNext.disable();
	} else if (isGestor==true || (isGestor==false && isSupervisor==false) ) {
		btnNext.setText('<s:message code="expedientes.creacion.proponer" text="**Proponer"/>');
		btnNext.enable();
	}

	var contratos = <json:object>
		<json:array name="contratos" items="${expediente.contratos}" var="expContrato">
			<json:object>
				<json:property name="vencido" value="${expContrato.contrato.vencido}" />
				<json:property name="cc" value="${expContrato.contrato.codigoContrato}" />
		 		<json:property name="tipo" value="${expContrato.contrato.tipoProducto.descripcion}" />
		 	 	<json:property name="diasIrregular" value="${expContrato.contrato.diasIrregular}" />
		 	 	<json:property name="saldoNoVencido" value="${expContrato.contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
		 	 	<json:property name="saldoIrregular" value="${expContrato.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
				<json:property name="estadoFinanciero" value="${expContrato.contrato.estadoFinanciero.descripcion}" />
				<json:property name="pase">
					<c:if test="${expContrato.pase==1}">
						<s:message code="mensajes.si" text="**S�" />
					</c:if>
					<c:if test="${expContrato.pase!=1}">
						<s:message code="mensajes.no" text="**No" />
					</c:if>
				</json:property>
			</json:object>
		</json:array>
	</json:object>;

	var personas = <json:object>
		<json:array name="personas" items="${expediente.personas}" var="expPersona">
			<json:object>
				<json:property name="nombre" value="${expPersona.persona.apellidoNombre}" />
				<json:property name="id" value="${expPersona.persona.id}" />
				<json:property name="docId" value="${expPersona.persona.docId}" />
				<json:property name="deudaIrregular" value="${expPersona.persona.riesgoTotal}" />
				<json:property name="totalSaldo" value="${expPersona.persona.riesgoDirecto}" />
				<json:property name="numContratos" value="${expPersona.persona.numContratos}" />
				<json:property name="pase">
					<c:if test="${expPersona.pase==1}">
						<s:message code="mensajes.si" text="**S�" />
					</c:if>
					<c:if test="${expPersona.pase!=1}">
						<s:message code="mensajes.no" text="**No" />
					</c:if>
				</json:property>
			</json:object>
		</json:array>
	</json:object>
	
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
		 hideLabel:true
		,name:'observaciones'
		,width:155
		,maxLength:1024
		,value : '<s:message text="${propuesta.observaciones}" javaScriptEscape="true" />'
	});

	var propuesta = '${propuesta.id}';
	if (propuesta!=null && propuesta != '') {
		comboMotivos.disabled = true;
	}
	if (!isSupervisor) {
		observaciones.disabled = true;
	}
	
	var panelObs = {
		xtype:'fieldset'
		,autoHeight:'true'
		,border:false
		,items:[labelMotivos,comboMotivos,labelObservaciones,observaciones]
	}

	var cntStore = new Ext.data.JsonStore({
    	data: contratos
    	,root: 'contratos'
    	,fields: [ 'cc',{name:'vencimiento', type:'date'}
                   ,'tipo','diasIrregular','saldoIrregular','saldoNoVencido','estadoFinanciero','pase' ]
	});

	var perStore = new Ext.data.JsonStore({
    	data: personas
    	,root: 'personas'
    	,fields: [ 'nombre', 'id', 'docId', 'deudaIrregular', 'totalSaldo', 'numContratos', 'pase' ]
	});

	//ColumnModel para grids contratos
	var contratosCm = new Ext.grid.ColumnModel([
		    {header: '<s:message code="listadocontratos.cc" text="**CC"/>', width: 140,  dataIndex: 'cc'}
		    ,{header: '<s:message code="listadocontratos.tipoproducto" text="**Tipo Producto"/>', width: 120,  dataIndex: 'tipo'}
			,{header: '<s:message code="listadocontratos.saldoirregular" text="**Saldo Irregular"/>', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'}
			,{header: '<s:message code="listadocontratos.saldonovencido" text="**Saldo No Vencido"/>', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'}
		    ,{header: '<s:message code="listadocontratos.diasirregular" text="**Dias Irregular"/>', width: 120, 	dataIndex: 'diasIrregular'}
			,{header: '<s:message code="listadocontratos.estadofinanc" text="**Estado Financ"/>', width: 135, dataIndex: 'estadoFinanciero'}
			,{header: '<s:message code="listadocontratos.pase" text="**Pase" />',dataIndex:'pase',sortable:true,width:60}
		]
	);

	//ColumnModel para grids personas
	var personasCm = new Ext.grid.ColumnModel([
			{header: '<s:message code="menu.clientes.listado.lista.nombre" text="**Nombre" />',dataIndex:'nombre',sortable:true,width:140}
			,{header: '<s:message code="listadopersonas.codInterno" text="**C�d. Interno" />', dataIndex: 'id',fixed:true}
			,{header: '<s:message code="listadopersonas.nroDoc" text="**N� Documento" />',dataIndex:'docId',sortable:true,width:80}
			,{header: '<s:message code="listadopersonas.deudaIrregular" text="**Deuda Irregular" />',dataIndex:'deudaIrregular',sortable:true,renderer:app.format.moneyRenderer,width:100,align:'right'}
			,{header: '<s:message code="listadopersonas.riesgoTotal" text="**Riesgo Total" />',dataIndex:'totalSaldo',sortable:true,renderer:app.format.moneyRenderer,width:100,align:'right'}
			,{header: '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos" />',dataIndex:'numContratos',sortable:true,width:50,align:'right'}
			,{header: '<s:message code="listadopersonas.pase" text="**Pase" />',dataIndex:'pase',sortable:true,width:60}
		]
	);

   var contratosGrid = app.crearGrid(cntStore,contratosCm,{
         title: '<s:message code="expedientes.consulta.tabcabecera.contratos" text="**Contratos del expediente"/>'
         ,style:'margin-bottom:10px;padding-right:10px'
         ,height: 150
         ,iconCls: 'icon_contratos_pase'
		 ,viewConfig: {forceFit:true}
   });

   var personasGrid = app.crearGrid(perStore,personasCm,{
         title: '<s:message code="expedientes.consulta.tabcabecera.personas" text="**Personas del expediente"/>'
         ,style:'margin-bottom:10px;padding-right:10px'
         ,height: 150
         ,iconCls: 'icon_cliente'
		 ,viewConfig: {forceFit:true}
   });


	var panel = new Ext.form.FormPanel({
		autoWidth:true
		,id:'panelExpedienteManual'
		,bodyStyle: 'padding:10px'
		,autoScroll:true
		,border:false
		,height:500
		//,width: 730
		,tbar:[btnCancelar, '->', btnNext]
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
							txtGestor,txtSupervisor
							,txtComite
							,txtOficina]}
						,{}
						,panelObs
					]
				}
				,personasGrid
				,contratosGrid				
			]
	});


	page.add(panel);

</fwk:page>
