<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var labelStyle='font-weight:bolder;width:150px';
	var labelStyle2='font-weight:bolder;width:100px';
  
	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-procedimiento-'+id, labelStyle:labelStyle2});
	}

	function fieldset(title, items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{ columns:2 }
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:380}
			,items : items
		});
	}

	var asunto = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>'
		,rawvalue: ""
		,labelStyle : labelStyle2
		,itemCls : 'no-margin'
		,autoHeight: true
	});

	var gestor = label('gestor', '<s:message code="asunto.tabcabecera.gestor" text="**Gestor"/>');
	var despacho = label('despacho', '<s:message code="asunto.tabcabecera.despacho" text="**Despacho"/>');
	var supervisor = label('supervisor', '<s:message code="expedientes.consulta.tabcabecera.supervisor" text="**Supervisor"/>');
	var procurador = label('procurador', '<s:message code="asunto.tabcabecera.procurador" text="**procurador"/>');
	var fechaInicio = label('fechaInicio', '<s:message code="procedimiento.tabcabecera.fechainicio" text="**Fecha Inicio"/>');
	var contratoPase = label('contratoPase', '<s:message code="plugin.mejoras.procedimiento.tabcabecera.contratoPase" text="**Contrato pase"/>');
	var nExpedienteInterno = label('nExpedienteInterno', '<s:message code="plugin.precontencioso.cabecera.nroexpedienteInt" text="**Nro. expediente interno"/>');

	var panelAsunto = fieldset('<s:message code="asunto.tabcabecera.asunto" text="**Asunto"/>',
		[{items:[asunto, despacho, fechaInicio, contratoPase]},
                 {items:[gestor,supervisor,procurador, nExpedienteInterno]}
	]);

	var nExpedienteExterno = label('nExpedienteExterno', '<s:message code="plugin.precontencioso.cabecera.nroexpedienteExt" text="**Nro. expediente externo:"/>');
	<sec:authentication var="user" property="principal" />
	<c:if test="${user.entidad.descripcion eq 'HAYA'}">
   		nExpedienteExterno = label('nExpedienteExterno', '<s:message code="plugin.precontencioso.cabecera.wfprelitigio" text="**WF Prelitigio:"/>');
	</c:if>
	var estadoProcedimiento = label('estadoProcedimiento', '<s:message code="plugin.precontencioso.cabecera.estadoExpediente" text="**Estado del expediente"/>');
	var procedimientoPropuesto = label('procedimientoPropuesto', '<s:message code="plugin.precontencioso.cabecera.procedimientoPropuesto" text="**Procedimiento propuesto"/>');
	var procedimientoIniciado = label('procedimientoIniciado', '<s:message code="plugin.precontencioso.cabecera.procedimientoAiniciar" text="**Procedimiento a iniciar"/>');
	var tipoPreparacion = label('tipoPreparacion', '<s:message code="plugin.precontencioso.cabecera.tipoPreparacion" text="**Tipo de preparación"/>');

	var historicoEstadosRecord = Ext.data.Record.create([
		{ name: 'id' },
		{ name: 'estado' },
		{ name: 'fechaInicio' },
		{ name: 'fechaFin' }
	]);

	var storeHistoricoEstados = page.getStore({
		eventName: 'resultado',
		flow: 'expedientejudicial/getHistoricoEstadosPorProcedimientoId',
		reader: new Ext.data.JsonReader({
			root: 'historicoEstados'
		}, historicoEstadosRecord)
	});

	var historicoEstadosGrid = new Ext.grid.GridPanel({
		title: '<s:message code="plugin.precontencioso.cabecera.estadosPreparacion" text="**Estados de la preparación" />',
		columns: [
			{ header: 'Estado',  dataIndex: 'estado' },
			{ header: 'Fecha Inicio', dataIndex: 'fechaInicio'},
			{ header: 'Fecha Fin', dataIndex: 'fechaFin' }
		],
		store: storeHistoricoEstados,
		height: 170,
		autoWidth: true,
	    viewConfig: { forceFit: true },
		loadMask: true,
		iconCls : 'icon_procedimiento'
	});

	var panelProcedimientoPrecontencioso = fieldset('<s:message code="plugin.precontencioso.cabecera.gestionExpediente" text="**Gestion Expediente"/>',
		[{items:[nExpedienteExterno, estadoProcedimiento, procedimientoPropuesto, procedimientoIniciado, tipoPreparacion]},
		{items:[historicoEstadosGrid]}]
	);

	var procedimiento = label('procedimiento', '<s:message code="procedimiento.tabcabecera.procedimiento" text="**Procedimiento"/>');
	var procedimientoInterno = label('procedimientoInterno', '<s:message code="procedimiento.tabcabecera.procinterno" text="**Nro. Proc. Interno"/>');
	var procedimientoJuzgado = label('procedimientoJuzgado', '<s:message code="procedimiento.tabcabecera.procjuzgado" text="**Nro. Proc. en Juzgado"/>');
	var juzgado = label('juzgado', '<s:message code="procedimiento.tabcabecera.juzgado" text="**Juzgado"/>');
	var plazaJuzgado = label('plazaJuzgado', '<s:message code="procedimiento.tabcabecera.plaza" text="**Plaza"/>');
	var reclamacion = label('reclamacion', '<s:message code="procedimiento.tabcabecera.reclamacion" text="**Reclamacion"/>');
	var estado = label('estado', '<s:message code="procedimiento.tabcabecera.estado" text="**Estado"/>');
  
  var panelProcedimiento = fieldset('<s:message code="procedimiento.tabcabecera.procedimiento" text="**Procedimiento"/>',
		 [{items:[procedimiento,procedimientoInterno,procedimientoJuzgado]},
                  {items:[juzgado,plazaJuzgado, estado]} ]
  );


  var saldoVencido = label('saldoVencido', '<s:message code="procedimiento.tabcabecera.saldovencido" text="**Saldo Vencido Actual"/>');
  var saldoNoVencido = label('saldoNoVencido', '<s:message code="procedimiento.tabcabecera.saldonovencido" text="**Saldo No Vencido Actual"/>');
  var saldoOriginalVencido = label('saldoOriginalVencido', '<s:message code="procedimiento.tabcabecera.saldovencidooriginal" text="**Saldo Original Vencido"/>');
  var saldoOriginalNoVencido = label('saldoOriginalNoVencido', '<s:message code="procedimiento.tabcabecera.saldonovencidooriginal" text="**Saldo Original No Vencido"/>');
  var saldoRecuperar = label('saldoRecuperar', '<s:message code="procedimiento.tabcabecera.saldorecuperar" text="**Saldo a Recuperar"/>');
  var recuperacion = label('recuperacion', '<s:message code="procedimiento.tabcabecera.recuperacion" text="**% Recuperacion"/>');
  var meses = label('meses', '<s:message code="procedimiento.tabcabecera.tiempo" text="**Tiempo"/>');
  
  var panelRecuperacion = fieldset('<s:message code="procedimiento.tabcabecera.estimacionrecuperacion" text="**Estimacion Recuperacion"/>',
                 [{items:[saldoVencido,saldoNoVencido,saldoOriginalVencido, saldoOriginalNoVencido]},
            {items:[reclamacion,saldoRecuperar,recuperacion,meses]} ]
  );
  
  
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
  



  var clientesIncluirStore = new Ext.data.JsonStore({
    data : { clientes :  [] } //ANGEL TODO cargar este store
    ,storeId : 'clientesIncluirStore'
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
		,height : 140
	});
  
	clientesGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var idPersona = rec.get('id');
		var otrosint = rec.get('apellidoNombre');
		app.abreCliente(idPersona, otrosint);
    });
  
  
  
	var funcionEditaCabeceraProcedimiento=function(){
		var flow = '';
		if (data.hayPrecontencioso) {
			flow = 'expedientejudicial/editar';
		}else{
			flow = 'editprocedimiento/open';
		}
		var w = app.openWindow({
             text:'<s:message code="plugin.mejoras.asuntos.cabecera.editar" text="**Editar" />'
			,flow: flow
			,width:850
			,title: '<s:message code="plugin.mejoras.asuntos.cabecera.editar" text="**Editar" />'
			,params:{
				id:panel.getProcedimientoId()
			}
		});
		w.on(app.event.DONE, function(){
			w.close();
			entidad.refrescar();
		});
		w.on(app.event.CANCEL, function(){ 
			w.close(); 
		});
	};
  
	var btnEditarCabeceraProcedimiento= new Ext.Button({
		text:'<s:message code="plugin.mejoras.asuntos.cabecera.editar" text="**Editar" />'
		<app:test id="btnEditarCabeceraProcedimiento" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:funcionEditaCabeceraProcedimiento
    });
	
/*	<pfs:defineParameters name="parametrosProcedimiento" paramId="${procedimiento.id}"/>
	
	var recargar = function (){
	 	app.abreProcedimientoTab(panel.getProcedimientoId()
	 		, '<s:message text="titicaca" javaScriptEscape="true" />'
	 		, procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
	};
	
	<pfs:buttonedit name="editarDatosProcedimiento" 
		flow="editprocedimiento/open"  
		windowTitleKey="plugin.mejoras.asuntos.cabecera.editar" 
		parameters="parametrosProcedimiento" 
		windowTitle="Editar datos del Procedimiento"
		on_success="recargar"/>
*/		
	
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
			,items:[panelAsunto,panelProcedimientoPrecontencioso,panelProcedimiento,panelRecuperacion]
		},clientesGrid]
		,nombreTab : 'cabeceraProcedimiento'
		,bbar:[<sec:authorize ifAllGranted="ROLE_EDIT_CABECERA_PROCEDIMIENTO">
					btnEditarCabeceraProcedimiento
			   </sec:authorize>
			  ]
	});
    
	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}
  
	panel.getValue = function(){
	}
 
	
	panel.setValue = function(){
		var data=entidad.get("data");
		var d = data.cabecera;
		var href = 'javascript:app.abreAsunto('+d.asuntoId+', &quot;'+d.asunto+'&quot;,null);'
		var link = '<a href="'+href+'">'+d.asunto+'</a>';
		asunto.setRawValue(link);
		entidad.setLabel('despacho',d.despacho);
		entidad.setLabel('gestor',d.gestor);
		entidad.setLabel('supervisor',d.supervisor);
		entidad.setLabel('procurador',d.procurador);
		entidad.setLabel('fechaInicio',d.fechaInicio);
		entidad.setLabel('procedimiento',d.procedimiento);
		entidad.setLabel('procedimientoInterno',d.procedimientoInterno);
		entidad.setLabel('procedimientoJuzgado',d.procedimientoJuzgado);
		entidad.setLabel('juzgado',d.juzgado);
		entidad.setLabel('plazaJuzgado',d.plazaJuzgado);
		entidad.setLabel('reclamacion',d.reclamacion);
		entidad.setLabel('estado',d.estado);
		entidad.setLabel('saldoVencido',app.format.moneyRenderer(''+d.saldoVencido));
		entidad.setLabel('saldoNoVencido',app.format.moneyRenderer(''+d.saldoNoVencido));
		entidad.setLabel('saldoOriginalVencido',app.format.moneyRenderer(''+d.saldoOriginalVencido));
		entidad.setLabel('saldoOriginalNoVencido',app.format.moneyRenderer(''+d.saldoOriginalNoVencido));
		entidad.setLabel('saldoRecuperar',app.format.moneyRenderer(''+d.saldoRecuperar));
		entidad.setLabel('recuperacion',d.recuperacion+" %");
		entidad.setLabel('meses',d.meses + " <s:message code="procedimiento.tabcabecera.meses" text="**meses"/>");

		entidad.setLabel('contratoPase',entidad.get("data").contratoPrincipal.codigoContrato);

		/*editarDatosProcedimiento.hide()
		<sec:authorize ifAllGranted="ROLE_EDIT_CABECERA_PROCEDIMIENTO">
			editarDatosProcedimiento.show();
		</sec:authorize>*/
		
		clientesIncluirStore.removeAll();
		clientesIncluirStore.loadData( d.clientes );

		refreshPrecontenciosoFields();
   	}

	function refreshPrecontenciosoFields() 
	{
		if (data.hayPrecontencioso) {
			storeHistoricoEstados.webflow({idProcedimiento: panel.getProcedimientoId()});

			panelProcedimientoPrecontencioso.show();
			nExpedienteInterno.show();
			recuperacion.hide();
			meses.hide();

			var cabeceraPCO = entidad.get("data").precontencioso;

			entidad.setLabel('nExpedienteInterno', cabeceraPCO.numExpInterno);
			entidad.setLabel('nExpedienteExterno', cabeceraPCO.numExpExterno);
			entidad.setLabel('estadoProcedimiento', cabeceraPCO.estadoActual);
			entidad.setLabel('procedimientoPropuesto', cabeceraPCO.tipoProcPropuestoDesc);
			entidad.setLabel('procedimientoIniciado', cabeceraPCO.tipoProcIniciadoDesc);
			entidad.setLabel('tipoPreparacion', cabeceraPCO.tipoPreparacionDesc);

			procedimientoInterno.label.update('<s:message code="plugin.precontencioso.cabecera.codigoExpediente" text="**Código expediente judicial"/>');
			procedimientoJuzgado.label.update('<s:message code="plugin.precontencioso.cabecera.nAuto" text="**Número de Auto"/>');

			comprobarExpedienteEditable();
			comprobarUsuarioGestoria();

		} else {
			panelProcedimientoPrecontencioso.hide();
			nExpedienteInterno.hide();
			recuperacion.show();
			meses.show();

			<sec:authorize ifAllGranted="ACCIONES_PRECONTENCIOSO">
				Ext.Element.get('prc-btnAccionesPrecontencioso-padre').hide();
			</sec:authorize>
			
			<sec:authorize ifAllGranted="GENERAR_DOC_PRECONTENCIOSO">
				Ext.Element.get('prc-btnGenerarDocPrecontencioso-padre').hide();
			</sec:authorize>

			procedimientoInterno.label.update('<s:message code="procedimiento.tabcabecera.procinterno" text="**Nro. Proc. Interno"/>');
			procedimientoJuzgado.label.update('<s:message code="procedimiento.tabcabecera.procjuzgado" text="**Nro. Proc. en Juzgado"/>');
			procedimientoInterno.setValue();
			entidad.setLabel('procedimientoInterno', entidad.get("data").cabecera.procedimientoInterno);
		}
	}
	
	var comprobarExpedienteEditable = function(){
	
		Ext.Ajax.request({
			url: page.resolveUrl('expedientejudicial/isExpedienteEditable')
			,params: {idProcedimiento:data.id}
			,method: 'POST'
			,success: function (result, request)
			{
				var r = Ext.util.JSON.decode(result.responseText);
				data.esExpedienteEditable = r.isEditable;
				
				<sec:authorize ifAllGranted="ACCIONES_PRECONTENCIOSO">
				if(!r.isEditable) {
					Ext.Element.get('prc-btnAccionesPrecontencioso-padre').hide();
				}
				else {
					Ext.Element.get('prc-btnAccionesPrecontencioso-padre').show();
				}
				</sec:authorize>
			}
		});
	}
	
	var comprobarUsuarioGestoria = function(){
	
		Ext.Ajax.request({
			url: page.resolveUrl('expedientejudicial/isGestoria')
			,params: {idProcedimiento:data.id}
			,method: 'POST'
			,success: function (result, request)
			{
				var r = Ext.util.JSON.decode(result.responseText);
				data.esGestoria = r.esGestoria;
			}
		});
	}
	
	return panel;
})
