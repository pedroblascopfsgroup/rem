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
	
	Ext.util.CSS.createStyleSheet("Button.icon_buildingEdit { background-image: url('../img/plugin/nuevoModeloBienes/building_edit.png');}");

	var idBienSeleccionado;
    
	var funcionEditarBien= function(){
		var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
        var idEmbargo = rec.get('idEmbargo');
        var id= rec.get('id');
		if(!id)
			return;
        var w = app.openWindow({
            <%--flow : 'procedimientos/embargoProcedimiento/embargoProcedimiento' --%>
			flow : 'editbien/openEmbargoProcedimiento'
			,width:650
			,title : '<s:message code="procedimiento.marcadoBien" text="**Marcado Bien" />'
            ,params : {idEmbargo:idEmbargo,idProcedimiento:panel.getProcedimientoId(),idBien:id}
        });
        w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var funcionEditarBienMultiple= function(){
        var w = app.openWindow({
			flow : 'editbien/openEmbargoProcedimientoMultiple'
			,width:850			
			,title : '<s:message code="procedimiento.marcadoBien" text="**Marcado Bien Multiple" />'
            ,params : {idProcedimiento:panel.getProcedimientoId(), idBien:id}
        });
        w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var funcionAgregarBien= function(){
        var w = app.openWindow({
			flow : 'editbien/winAgregarExcluirBien'
			,width:850			
			,title : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.agregarBien" text="**Agregar Bienes" />'
            ,params : {idProcedimiento:panel.getProcedimientoId(),accion:'AGREGAR'}
        });
        w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var funcionExcluirBien= function(){
        var w = app.openWindow({
			flow : 'editbien/winAgregarExcluirBien'
			,width:850			
			,title : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.excluirBien" text="**Excluir Bienes" />'
            ,params : {idProcedimiento:panel.getProcedimientoId(), accion:'EXCLUIR'}
        });
        w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var embargoProcedimiento = Ext.data.Record.create([
		{name:"fechaSolicitud"}
		,{name:"fechaDecreto"}
		,{name:"fechaDenegacion"}
		<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
           	,{name:"origen"}
        </sec:authorize>
/*      <sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
           	,{name:"marca"}
        </sec:authorize> */
		,{name:"id"}
		,{name:"idEmbargo"}
		,{name:"codigo"}
		,{name:"descripcion"}
		,{name:"tipo"}
		,{name:"fechaRegistro"}
		,{name:"importeTasacion"}
		,{name:"fechaAdjudicacion"}
		,{name:"cargaBien"}
		,{name:"titular"}
		,{name:"instrucciones"}
		,{name:"idInstrucciones"}
		,{name:"letra"}
		,{name:"observaciones"}
       	,{name:"numeroActivo"}
		,{name:"referenciaCatastral"}
		,{name:"numFinca"}		
	]);
	
	var embargoProcedimientoStore = page.getStore({
		event:'listado'
		,storeId : 'embargoProcedimientoStore'
		,flow : 'plugin/nuevoModeloBienes/procedimientos/plugin.nuevoModeloBienes.procedimientos.listadoEmbargoProcedimiento_NMB'
		,reader : new Ext.data.JsonReader({root:'listado'}
		, embargoProcedimiento)
	});
	
	entidad.cacheStore(embargoProcedimientoStore);
	
	var embargoProcedimientoCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="procedimiento.embargos.grid.codigo" text="**Codigo"/>', hidden:true, dataIndex : 'codigo' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroFinca" text="**N&uacute;mero finca"/>', sortable: true, dataIndex : 'numFinca' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.referenciaCatastral" text="**Referencia catastral"/>', sortable: true, dataIndex : 'referenciaCatastral' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.numeroActivo" text="**Número activo"/>', sortable: true, dataIndex : 'numeroActivo' }
		,{header : '<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.grid.origen" text="**Carga"/>', width: 67, sortable: true, dataIndex : 'origen' }
		,{header : '<s:message code="procedimiento.embargos.grid.descripcion" text="**Descripcion"/>', sortable: true, dataIndex : 'descripcion' }
		,{header : '<s:message code="procedimiento.embargos.grid.tipo" text="**Tipo"/>', sortable: true, dataIndex : 'tipo' }
		,{header : '<s:message code="procedimiento.embargos.grid.letra" text="**Letra"/>', sortable: true, dataIndex : 'letra' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaSol" text="**fechaSolicitud"/>', sortable: true, dataIndex : 'fechaSolicitud' }
		,{header : '<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />', sortable: false, dataIndex : 'importeTasacion',renderer: app.format.moneyRenderer}
		,{header : '<s:message code="procedimiento.embargos.grid.fechaDec" text="**fechaDecreto"/>', sortable: true, dataIndex : 'fechaDecreto' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaRef" text="**fechaRegistro"/>', sortable: true, dataIndex : 'fechaRegistro' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaAdj" text="**fechaAdjudicacion"/>', sortable: true, dataIndex : 'fechaAdjudicacion' }
		,{header : '<s:message code="procedimiento.embargos.grid.fechaDene" text="**fechaDenegacion"/>', sortable: true, dataIndex : 'fechaDenegacion' }
		,{header : '<s:message code="procedimiento.embargos.grid.cargaBien" text="**cargaBien"/>', sortable: true, dataIndex : 'cargaBien'}
		,{header : '<s:message code="procedimiento.embargos.grid.titular" text="**titular"/>', sortable: true, dataIndex : 'titular'}
		,{header : '<s:message code="procedimiento.embargos.grid.Instrucciones" text="**Instrucciones"/>', sortable: true, dataIndex : 'instrucciones', renderer: function (val){if (val==1) {return "SI";} else {return "NO"}} }		
	]);

	<%-- Si el usuario pertenece a la entidad CAJAMAR no se mostrará la columna Numero Activo --%>	
	if ('${usuario.entidad.descripcion}' == 'CAJAMAR') {
		embargoProcedimientoCm.config[3].hidden=true;
	}

	btnVerificarBien = new Ext.Button({
		text:'<s:message code="app.consultar" text="**Consultar" />'
		<app:test id="btnAgregarIngreso" addComa="true" />
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,disabled: true
		,handler:function(){
			var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
			if (!rec) return;
			var idBien=rec.get("id");
			var w = app.openWindow({
				flow : 'editbien/openByIdBien'
				,width:760
				,title : '<s:message code="clientes.consultacliente.solvenciaTab.editarBienes" text="**Editar bienes" />'
				,params : {id:idBien}
			});
			w.on(app.event.DONE, function(){
				w.close();
				embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
				btnDictarInstruccionesNotarial.disable();
				btnDictarInstruccionesApremio.disable();
            	btnVerificarBien.disable();
            	btnEditar.disable();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});
			
	var funVerificarBien = function() {
		var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
        if (!rec) return;
        var idBien=rec.get("id");
        var desc = idBien + ' ' +  rec.get('tipo');
        app.abreBien(idBien,desc);
		btnDictarInstruccionesNotarial.disable();
		btnDictarInstruccionesApremio.disable();
        btnVerificarBien.disable();
        btnEditar.disable();
	};
	
	<sec:authorize ifAllGranted="ESTRUCTURA_COMPLETA_BIENES">
		btnVerificarBien = new Ext.Button({
	        text:'<s:message code="app.consultar" text="**Consultar" />'
			<app:test id="btnAgregarIngreso" addComa="true" />
           	,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,disabled: true
           	,handler:function(){
				funVerificarBien();
       		}
		});
	</sec:authorize>
	
	var btnEditar = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.marcar" text="**Marcar" />'
        ,iconCls : 'icon_buildingEdit'
        ,cls: 'x-btn-text-icon'
        ,disabled:true
        ,handler:funcionEditarBien
        <app:test id="btnEditarABM" addComa="true"/>
    });

    var btnEditarMultiple = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.marcarMultiple" text="**Marcar Multiple" />'
        ,iconCls : 'icon_buildingEdit'
        ,cls: 'x-btn-text-icon'
        ,disabled:false
        ,handler:funcionEditarBienMultiple
        <app:test id="btnEditarABM" addComa="true"/>
    });

	var btnAgregarBien = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.agregarBien" text="**Agregar Bienes" />'
        ,iconCls : 'icon_mas'
        ,cls: 'x-btn-text-icon'
        ,disabled:false
        ,handler:funcionAgregarBien
    });
    
    var btnExcluirBien = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.excluirBien" text="**Excluir Bienes" />'
        ,iconCls : 'icon_menos'
        ,cls: 'x-btn-text-icon'
        ,disabled:false
        ,handler:funcionExcluirBien
    });

	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		var btnMarcarGarantia = new Ext.Button({
			 text : '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien" text="**Marcar / Desmarcar" />'
			,iconCls : 'icon_edit'
			,disabled:true
			,cls: 'x-btn-text-icon'
			,handler : function(){
				var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
				if (!rec){
					Ext.Msg.alert('<s:message code="app.error" text="**Error"/>','<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.debeSeleccionar" text="**Debe seleccionar el bien que desea Marcar o Desmarcar"/>');
					return;
				}	
				Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="plugin.nuevoModeloBienes.tabSolvencia.btnMarcarBien.mensajeConfirmacion" text="**Seguro que desea marcar la solvencia seleccionada?" />', this.decide, this);
			}
			,decide : function(boton){
				if (boton=='yes') this.marcar();
			}
			,marcar : function(){
				page.webflow({
					 flow : 'plugin/nuevoModeloBienes/clientes/marcarBien'
					,params : {idBien:embargoProcedimientoGrid.getSelectionModel().getSelected().get("id")}
					,success : function(){
						embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
					}
				})
			}
		});
	</sec:authorize>

	var funcionDictarInstruccionesNotarial= function(){
		var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
        var idBien= rec.get('id');
		var idInstrucciones= rec.get('idInstrucciones');
		if(!idBien)
			return;
        var w = app.openWindow({
			flow : 'instruccionessubasta/dictarInstrucciones'
			,width:805
			,title : '<s:message code="plugin.nuevoModeloBienes.procedimiento.dictarInstrucciones.tituloDictarInstrucciones" text="**Dictar instrucciones" />'
			,params : {idBien:idBien, 
					   idProcedimiento: panel.getProcedimientoId(),
					   tipoSubasta: 'notarial',
					   idInstrucciones: idInstrucciones}
		});
		w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
            /*btnDictarInstruccionesNotarial.disable();
            btnVerificarBien.disable();
            btnEditar.disable();*/
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};

	var funcionDictarInstruccionesApremio= function(){
		var rec = embargoProcedimientoGrid.getSelectionModel().getSelected();
        var idBien= rec.get('id');
		var idInstrucciones= rec.get('idInstrucciones');
		if(!idBien)
			return;
        var w = app.openWindow({
			flow : 'instruccionessubasta/dictarInstrucciones'
			,width:805
			,title : '<s:message code="plugin.nuevoModeloBienes.procedimiento.dictarInstrucciones.tituloDictarInstrucciones" text="**Dictar instrucciones" />'
			,params : {idBien:idBien, 
					   idProcedimiento: panel.getProcedimientoId(),
					   tipoSubasta: 'apremio',
					   idInstrucciones: idInstrucciones}
		});
		w.on(app.event.DONE, function(){
			w.close();
            embargoProcedimientoStore.webflow({idProcedimiento:panel.getProcedimientoId()});
			/*btnDictarInstruccionesApremio.disable();
            btnVerificarBien.disable();
            btnEditar.disable();*/
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var btnDictarInstruccionesNotarial = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.dictarInstrucciones" text="**Dictar instrucciones" />'
        ,iconCls : 'icon_buildingEdit'
        ,cls: 'x-btn-text-icon'
        ,disabled:true
        ,handler:funcionDictarInstruccionesNotarial
    });
    
	var btnDictarInstruccionesApremio = new Ext.Button({
        text:'<s:message code="plugin.nuevoModeloBienes.procedimiento.embargos.dictarInstrucciones" text="**Dictar instrucciones" />'
        ,iconCls : 'icon_buildingEdit'
        ,cls: 'x-btn-text-icon'
        ,disabled:true
        ,handler:funcionDictarInstruccionesApremio
    });
    
	var buttonBar = []

	<sec:authorize ifAllGranted="BOTON_MARCAR_EMBARGOS_MULTIPLE">
		buttonBar.push(btnEditarMultiple);
	</sec:authorize>
	<sec:authorize ifAnyGranted="ROLE_PUEDE_VER_BOTONES_EMBARGO_PROCEDIMIENTO">
	buttonBar.push(btnAgregarBien);
	buttonBar.push(btnExcluirBien);
	buttonBar.push(btnEditar);
	/*buttonBar.push(btnDictarInstruccionesNotarial);*/
	buttonBar.push(btnDictarInstruccionesApremio);
	</sec:authorize>
	
	buttonBar.push(btnVerificarBien);

	<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
		buttonBar.push(btnMarcarGarantia);
	</sec:authorize>
	
	var embargoProcedimientoGrid = app.crearGrid(embargoProcedimientoStore,embargoProcedimientoCm,{
		title:'<s:message code="procedimiento.embargos.grid" text="**Marcado Bienes" />'
		,height : 400
		,style:'padding-right:10px'
		,bbar:buttonBar
	});
  
	embargoProcedimientoGrid.on('rowclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
        var id= rec.get('id');
		if(!id){
			btnEditar.disable();
			btnVerificarBien.disable();
			<sec:authorize ifAllGranted="BOTON_INSTRUCCIONES_SUBASTA">
				if (!btnDictarInstruccionesNotarial.hidden) btnDictarInstruccionesNotarial.disable();
				if (!btnDictarInstruccionesApremio.hidden) btnDictarInstruccionesApremio.disable();
			</sec:authorize>
			<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
				btnMarcarGarantia.disable();
			</sec:authorize>
		} else {
			btnEditar.enable();
			btnVerificarBien.enable();
			<sec:authorize ifAllGranted="BOTON_INSTRUCCIONES_SUBASTA">
				if (!btnDictarInstruccionesNotarial.hidden) btnDictarInstruccionesNotarial.enable();
				if (!btnDictarInstruccionesApremio.hidden) btnDictarInstruccionesApremio.enable();
			</sec:authorize>
			<sec:authorize ifAllGranted="BOTON_MARCAR_BIENES_PARA_EXTERNOS">
				if(rec.get('origen')=='Manual'){btnMarcarGarantia.disable();}
				else {btnMarcarGarantia.enable()};
			</sec:authorize>
		}
	});
	
	embargoProcedimientoGrid.on('rowdblclick', function(grid, rowIndex, e) {
		funVerificarBien();
	});

	var panel = new Ext.Panel({
		autoHeight : true
		,title:'<s:message code="procedimiento.embargos" text="**Bienes" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items :embargoProcedimientoGrid
		,nombreTab : 'embargosProcedimiento'
	});

	panel.getValue = function(){
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, embargoProcedimientoStore, {idProcedimiento : data.id});
	
		var visibles = [
			[btnAgregarBien,btnExcluirBien,btnEditarMultiple, data.procedimientoAceptado && (data.esGestor || data.esSupervisor)]
			,[btnEditar, data.procedimientoAceptado && (data.esGestor || data.esSupervisor) ]
			/*,[btnDictarInstruccionesNotarial, data.cabecera.codigoTipoProcedimiento == 'P65' ]*/
			,[btnDictarInstruccionesApremio, data.cabecera.codigoTipoProcedimiento != 'P66' ]
		];
		entidad.setVisible(visibles);
		
		var enabled = [
			[ btnExcluirBien, true]
			,[ btnAgregarBien , true]
			,[ btnEditarMultiple , true ]
			,[ btnEditar , false ]
			/*,[ btnDictarInstruccionesNotarial , false ]*/
			,[ btnDictarInstruccionesApremio , false ]
			,[btnVerificarBien, false]
		];
		entidad.setEnabled(enabled);
		
	}

	panel.getProcedimientoId = function(){
		return entidad.get("data").id;
	}

	return panel;
})
