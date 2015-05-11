﻿<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>

function(entidad,page){

	var toolbar=new Ext.Toolbar();

    var botonComunicacion = new Ext.Button({
		text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
		,iconCls : 'icon_comunicacion'
		,handler:function(){
			var w = app.openWindow({
			flow : 'tareas/generarTarea'
			,title : '<s:message code="" text="Comunicacion" />'
			,width:650
			,params : {
				idEntidad:toolbar.getProcedimientoId()
				,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
				,tienePerfilGestor: toolbar.getData().esGestor
				,tienePerfilSupervisor: toolbar.getData().esSupervisor    
			}
		});
        w.on(app.event.DONE, function(){w.close();});
        w.on(app.event.CANCEL, function(){w.close(); });
        }
    });

    var botonResponder = new Ext.Button({
        text:'Responder'
        ,iconCls : 'icon_responder_comunicacion'
        ,disabled: false
        ,handler:function(){
            var w = app.openWindow({
            flow : 'tareas/generarNotificacion'
            ,title : '<s:message code="" text="Notificacion" />'
            ,width:400
            ,params : {
                  idEntidad:toolbar.getProcedimientoId()
                  ,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
                  ,descripcion:toolbar.getData().toolbar.descripcionTarea
                  ,fecha: toolbar.getData().toolbar.fechaCreacionFormateada
                  ,situacion: toolbar.getData().toolbar.estadoItinerario
                  ,idTareaAsociada:toolbar.getData().toolbar.tareaPendienteId
                  ,tienePerfilGestor: toolbar.getData().esGestor
                  ,tienePerfilSupervisor: toolbar.getData().esSupervisor    
                }
            });
            w.on(app.event.DONE, function(){
              w.close();
              app.contenido.activeTab.doAutoLoad();
            });
            w.on(app.event.CANCEL, function(){w.close(); });
        }
    });
	<sec:authorize ifAllGranted="COMUNICACION_boton">
	toolbar.add(botonComunicacion);
	</sec:authorize>
	toolbar.add(botonResponder);

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			entidad.refrescar();
		}
	});

	toolbar.add(buttonsL_procedimiento);
	toolbar.add('->');
	toolbar.add(buttonsR_procedimiento);
	toolbar.add(botonRefrezcar);
	toolbar.add(app.crearBotonAyuda());

	toolbar.setValue = function(){
		
		var data = entidad.get("data");
		
		var visible = [
			<sec:authorize ifAllGranted="COMUNICACION_boton">
			[ botonComunicacion, data.esGestor || data.esSupervisor],
			</sec:authorize>
			[ botonResponder, (data.esGestor || data.esSupervisor) && data.toolbar.tareaPendiente]
		]

		var condition = '';
		for (i=0; i < buttonsL_procedimiento.length; i++){
			if (buttonsL_procedimiento[i].condition!=null && buttonsL_procedimiento[i].condition!=''){
				condition = eval(buttonsL_procedimiento[i].condition);
				visible.push([buttonsL_procedimiento[i], condition]);
			}
		}
		for (i=0; i < buttonsR_procedimiento.length; i++){
			if (buttonsR_procedimiento[i].condition!=null && buttonsR_procedimiento[i].condition!=''){
				condition = eval(buttonsR_procedimiento[i].condition);
				visible.push([buttonsR_procedimiento[i], condition]);
			}
		}
		
		entidad.setVisible(visible);
	}
  
	toolbar.getValue = function(){}
	toolbar.getProcedimientoId = function(){
		return entidad.get("data").id;
	}
  
	toolbar.getData = function(){
		return entidad.get("data");
	}
	
	return toolbar;
};