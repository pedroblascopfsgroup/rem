<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var objetivosStore;
var objetivosGrid;
var btnRechazar;
var btnNuevo;

var createDatosObjetivosPanel = function() {
    btnNuevo = new Ext.Button({
        text: '<s:message code="app.nuevo" text="**Nuevo" />'
        ,iconCls: 'icon_mas'
		,handler: function() {
				var idPolitica = pSeleccionado.items.items[6].getValue();
				
				var w = app.openWindow({ 
					flow: 'politica/editObjetivo'
					,params: {idPersona:${persona.id},idPolitica:idPolitica}
					,width: 900
					,title: '<s:message code="crear.objetivo" text="**Crear objetivo" />'
				});
				w.on(app.event.DONE, function(){
					w.close();
					cargarObjetivos(pSeleccionado);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
    });

    var btnModificar = new Ext.Button({
        text: '<s:message code="app.editar" text="**Modificar" />'
        ,iconCls: 'icon_edit'
		,handler: function() {
				var rec = objetivosGrid.getSelectionModel().getSelected();
                if (!rec) return;
				var idObjetivo = rec.get("id");
				var idPolitica = rec.get("idPolitica");
				if(!rec.get("estadoObjetivo")=='<fwk:const value="es.capgemini.pfs.politica.model.DDEstadoObjetivo.ESTADO_PROPUESTO" />') {
						Ext.Msg.show({
						   title: fwk.constant.alert
						   ,msg: '<s:message code="editar.objetivo.error.objNoPropuesto.noEditable" text="**El objetivo no está en estado 'Propuesto' por lo que no se puede editar." />'
						   ,buttons: Ext.Msg.OK, animEl: 'elId'
						});
						return;
				}
				var w = app.openWindow({
					flow: 'politica/editObjetivo'
					,width: 900
					,title: '<s:message code="editar.objetivo" text="**Editar objetivo" />'
					,params: {idPersona:${persona.id},idObjetivo:idObjetivo,idPolitica:idPolitica}
				});
				w.on(app.event.DONE, function(){
					w.close();
   				    cargarObjetivos(pSeleccionado);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
    });

     var verificarBorrarObjetivo = function(titulo, mensaje){ 
          Ext.Msg.confirm(titulo, mensaje, borrarObjetivo);
      };
      
     var borrarObjetivo = function(borrar) {        
        if(borrar != 'yes') {
            return;
        }       
        var rec = objetivosGrid.getSelectionModel().getSelected();
        if (!rec) return;
        var idObjetivo = rec.get("id");
        page.webflow({
            flow: 'politica/borrarObjetivo'
            ,params: {idObjetivo:idObjetivo}
            ,success: function(){
                cargarObjetivos(pSeleccionado);
            }
        });
    };

	var btnBorrar = new Ext.Button({
        text : '<s:message code="app.borrar" text="**Borrar" />'
        ,iconCls : 'icon_menos'
        ,handler: function() {
            verificarBorrarObjetivo('<s:message code="objetivo.confirmar.borrar.titulo" text="**Confirmar borrado" />',
                                    '<s:message code="objetivo.confirmar.borrar.mensaje" text="**Desea borrar el objetivo?" />');
        }
    });

    btnRechazar = new Ext.Button({
        text : '<s:message code="app.botones.rechazar" text="**Rechazar" />'
        ,iconCls : 'icon_menos'
        ,handler: function() {
            verificarBorrarObjetivo('<s:message code="objetivo.confirmar.rechazar.titulo" text="**Confirmar rechazo" />',
                                    '<s:message code="objetivo.confirmar.rechazar.mensaje" text="**Desea rechazar el objetivo?" />');
        }
    });

	var btnJustificar = new Ext.Button({
        text: '<s:message code="politica.objetivo.justificar" text="**Justificar" />'
        ,iconCls: 'icon_edit'
		,handler: function() {
				var rec = objetivosGrid.getSelectionModel().getSelected();
                if (!rec) return;
				var idObjetivo = rec.get("id");
				var w = app.openWindow({
					flow: 'politica/justificarObjetivo'
					,width: 900
					,title: '<s:message code="politica.objetivo.justificarObjetivo" text="**Justificar objetivo" />'
					,params: {idPersona:${persona.id},idObjetivo:idObjetivo,idEstadoItinerarioPolitica:idEstado,idPolitica:idPolitica}
				});
				w.on(app.event.DONE, function(){
					w.close();
   				    cargarObjetivos(pSeleccionado);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
    });
    
    btnProponerCumplimiento = new Ext.Button({
        text : '<s:message code="objetivo.botones.proponerCumplimiento" text="**Proponer Cumplimiento" />'
        ,iconCls : 'icon_ok'
        ,handler: function() {
				var rec = objetivosGrid.getSelectionModel().getSelected();
                if (!rec) return;
				var idObjetivo = rec.get("id");
				var w = app.openWindow({
					flow: 'politica/propuestaCumplimiento'
					,params: {idObjetivo:idObjetivo}
					,width: 750
					//,autoWidth:true
					,title: '<s:message code="objetivos.propuestaCumplimiento.titulo" text="**Propuesta Cumplimiento" />'
				});
				w.on(app.event.DONE, function(){
					w.close();
					cargarObjetivos(pSeleccionado);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
		   }
    });

    var objetivo = Ext.data.Record.create([
         {name : 'id'}
        ,{name : 'idPolitica'}
        <%-- ,{name : 'padreId'}--%>
        ,{name : 'resumen'}
        ,{name : 'observacion'}
        ,{name : 'tipo'}
		,{name : 'tipoAutomatico'}
        ,{name : 'estadoObjetivo'}
        ,{name : 'estadoCumplimiento'}
        ,{name : 'justificacion'}
        ,{name : 'fechaLimite'}
        ,{name : 'estadoObjetivo'}
        ,{name : 'estaPendiente'}
        ,{name : 'estaConfirmado'}
        ,{name : 'esRechazable'}
		,{name : 'estaIncumplido'}        
		,{name : 'estaPropuesto'}        
		,{name : 'estaPoliticaVigente'}      
		,{name : 'estaPoliticaPropuesta'}      		  
		,{name : 'estaPoliticaPropuestaSuperusuario'}      		  
    ]);


    objetivosStore = page.getStore({
        event:'listado'
        ,flow : 'politica/listadoObjetivos'
        ,reader : new Ext.data.JsonReader(
            {root:'objetivos'}
            , objetivo
        )
    });

    var objetivoCm  = new Ext.grid.ColumnModel([                                                                                                                         
        {header : '<s:message code="politica.codigo" text="**Código" />',dataIndex : 'id', width:75}
<%--          ,{header : '<s:message code="politica.padre" text="**Padre" />', dataIndex : 'padreId', hidden:true, width:75} --%>
        ,{header : '<s:message code="politica.objetivo" text="**Objetivo" />', dataIndex : 'resumen', width:250}
        ,{header : '<s:message code="politica.observaciones" text="**Observaciones" />', dataIndex : 'observacion', hidden:true, width:100}
        ,{header : '<s:message code="politica.tipo" text="**Tipo" />', dataIndex : 'tipo', width:150}
        ,{header : '<s:message code="politica.estadoObjetivo" text="**Estado Objetivo" />', dataIndex : 'estadoObjetivo', width:100}
        ,{header : '<s:message code="politica.estadoCumplimiento" text="**Estado cumplimiento" />', dataIndex : 'estadoCumplimiento', width:100}
        ,{header : '<s:message code="politica.justificaciones" text="**Justificaciones" />', dataIndex : 'justificacion', hidden:true, width:100}
        ,{header : '<s:message code="politica.fechaLimite" text="**Fecha límite"/>', dataIndex : 'fechaLimite', width:100}
    ]);    
    var toolbar = new Ext.Toolbar({
        items:[btnNuevo, btnModificar, btnBorrar, btnRechazar,btnProponerCumplimiento,btnJustificar]
		,disabled:true
    });

    var configObjetivos = {
        title: '<s:message code="politica.datosObjetivos" text="**Datos de los objetivos" />'
        ,style: 'padding-bottom:10px'
        ,autoHeight: false
        ,height:175
        ,bbar : toolbar}

    objetivosGrid = app.crearGrid(objetivosStore, objetivoCm, configObjetivos);
    objetivosGrid.getBottomToolbar().disable();

    objetivosGrid.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.getStore().getAt(rowIndex);
        var pendiente = rec.get('estaPendiente');
        var estaPropuesto = rec.get('estaPropuesto');
        var estaConfirmado = rec.get('estaConfirmado');
        var rechazable = rec.get('esRechazable');
        var automatico = rec.get('tipoAutomatico');
        var estaIncumplido = rec.get('estaIncumplido');
        var estaPoliticaVigente = rec.get('estaPoliticaVigente');
        var estaPoliticaPropuesta = rec.get('estaPoliticaPropuesta');
        var estaPoliticaPropuestaSuperusuario = rec.get('estaPoliticaPropuestaSuperusuario');
		
		//Por defecto todos apagados
		btnModificar.disable();
		btnBorrar.disable();
		btnRechazar.disable();
		btnProponerCumplimiento.disable();
		btnJustificar.disable();
		
		
		//Si está proponiendo política, se pueden activar los botones de modificación
		if ((estaPoliticaPropuesta && (esGestorExpediente || esSupervisorExpediente)) ||
			(estaPoliticaPropuestaSuperusuario && isSuperusuario))
		{
			if(estaPropuesto) btnModificar.enable();
			if(estaPropuesto && !rechazable) btnBorrar.enable();
			if(rechazable) btnRechazar.enable();
		
		}
		
		//Si la política ya está vigente, se puede modificar el cumplimiento o proponer
		else if (estaPoliticaVigente && (esGestorObjetivos || esSupervisorObjetivos))
		{
			if(estaPropuesto) btnModificar.enable();
			if(estaPropuesto) btnBorrar.enable();
        	if (pendiente && estaConfirmado && !automatico) btnProponerCumplimiento.enable();
        	if (estaIncumplido) btnJustificar.enable();
		}		
    });

    return objetivosGrid;
};