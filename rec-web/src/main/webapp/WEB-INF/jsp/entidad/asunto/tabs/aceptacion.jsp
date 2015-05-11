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
	var labelStyle='font-weight:bolder;width:300'
	//Opciones para los combos Conflicto, Aceptación y Decomentación Recibida.
	var dictCombos = 
		{'diccionario':[
			{'codigo':'Si','descripcion':'<s:message code="label.si" text="**Si" />'},
			{'codigo':'No','descripcion':'<s:message code="label.no" text="**No" />'}]}

    var combo = function(name, label){
		return app.creaCombo({
			data : dictCombos
			,name : name
			,allowBlank : false
			,fieldLabel : label
			,value : ''
			,labelStyle:labelStyle
			,disabled:true
			,'width':'50px'
	    });
    }
	
	var conflicto = combo('aceptada', '<s:message code="asunto.tabaceptacion.conflicto" text="**Conflicto"/>');
	var aceptacion = combo('aceptada', '<s:message code="asunto.tabaceptacion.aceptacion" text="**Aceptacion"/>');
	var documentacionRecibida = combo('aceptada', '<s:message code="asunto.tabaceptacion.documentacionRecibida" text="**Documentación recibida"/>');

	var fechaRecepcionDocumentacion = new Ext.ux.form.XDateField({
		name : 'usuario.alta'
		,fieldLabel : '<s:message code="asunto.tabaceptacion.fechaRecepcionDocumentacion" />'
 		,value : ''
		,allowBlank : true
		,style:'margin:0px'
		,labelStyle:labelStyle
		,disabled:true
	});

	/* Grid historial de aceptacion asunto */
	
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="procedimiento.documentacion.observaciones" text="**Observaciones" />'
	,style:'font-weight:bolder; font-size:11'
	}); 

	var observaciones=new Ext.form.TextArea({
		fieldLabel:'<s:message code="asunto.tabaceptacion.observaciones" text="**Observaciones"/>'
		,labelStyle:'font-weight:bolder'
		,hideLabel:true
		,readOnly:true
		,width:720
		,height : 200
	});
	
	var btnVerHistorial=new Ext.Button({
		text:'<s:message code="asunto.tabaceptacion.verHistorial" text="**Ver Historial"/>'
		,iconCls:'icon_historial'
		,handler:function(){
			var w = app.openWindow({
				flow:'asuntos/historiaAceptacion'
				,width:870
				,closable:true
				,title : '<s:message code="asunto.tabaceptacion.historial" text="**Historial de Aceptacion del asunto" />'
				,params:{idAsunto:panel.getAsuntoId()}
			});
			w.on(app.event.DONE, function(){
					w.close();
			});
			w.on(app.event.CANCEL, function(){ 
					w.close(); 
			});
        }
	});
	
	var formObservaciones=new Ext.form.FormPanel({
		items:[ tituloobservaciones ,observaciones ]
		,border:false
	});
	
	var fieldSetObservaciones=new Ext.form.FieldSet({
		items:formObservaciones
		,border:false
		,bodyStyle:'padding:5px'
		,width:750
		,autoHeight:true
	});
	
	/*BOTONES DE DEVOLUCION*/
	
	var buttonEditarAceptacionAsunto=new Ext.Button({
		text:'<s:message code="app.editar" text="**Editar" />'
		,iconCls:'icon_edit'
		,handler:function(){ editarAceptarAsunto(); }
	});

	var buttonAceptarAsunto=new Ext.Button({
		text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
		,iconCls:'icon_ok'
		,handler:function(){ aceptarDevolverAsunto('aceptar'); }
	});
	
	//Funcion encargada de abrir el popup para editar los datos del asunto.
	var editarAceptarAsunto=function(){
		var idAsunto=panel.getAsuntoId();
			win = app.openWindow(
				{
					flow:'asuntos/editarFichaAceptacionAsunto', 
					title : '<s:message code="asunto.tabaceptacion.fichaAceptacion" text="**Editar Ficha" />',
					params: {id:panel.getAsuntoId(),accion:4},
					width: 820
				}
			);
			win.on(app.event.CANCEL, function(){ win.close(); });
			win.on(app.event.DONE, function(){ win.close(); _recargar(); }
			);
	};
	var _cerrarTab = function(){
		//app.contenido.remove(tab)
		//entidad.cierraTab();
		//app.contenido.remove(app.contenido.activeTab); de esta forma da error despues de haberla ejecutado
		app.contenido.remove(app.contenido.getActiveTab());
		entidad.cierraTab();
	}
	var aceptarDevolverAsunto=function( accion){
		var idAsunto=panel.getAsuntoId();
		var msg;
		if (accion == 'aceptar' && !(conflicto.getValue()=='No' && aceptacion.getValue()=='Si' && documentacionRecibida.getValue()=='Si')) {
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.observacion.aceptarConflicto"/>');
			return;
		} else {
            var fechaRecepDocStr = '';
            if(fechaRecepcionDocumentacion.getValue()!= '') {
                fechaRecepDocStr = fechaRecepcionDocumentacion.getValue().format('d/m/Y');
            }
	    if (documentacionRecibida.getValue()=='Si' && fechaRecepcionDocumentacion.getValue()=='') {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.fechaRec.nula" text="**Si la documentación está recibida debe ingresar la fecha." />');
	    } else {
				var flow = '';
				if (accion == 'aceptar')
				{
					flow = 'asuntos/aceptarAsunto';
					msg='<s:message code="asunto.aceptacion.asuntoAceptado" text="**Asunto Aceptado" />';
					accion = 1;
				}
				else if (accion == 'devolver')
				{
					flow = 'asuntos/devolverAsunto';
					msg='<s:message code="asunto.devolucion.asuntoDevuelto" text="**Asunto Devuelto" />';
					accion = 2;
				}
				else if (accion == 'elevar')
				{
					flow = 'asuntos/aceptarAsunto';
					msg='<s:message code="asunto.elevarComite.asuntoElevado" text="**Asunto Elevado" />';
					accion = 3;
				}

				var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
				mask.show();
				page.webflow({
					'flow':flow 						
					,params: {
						idAsunto:panel.getAsuntoId()
						,conflicto:conflicto.getValue()
						,aceptacion:aceptacion.getValue()
						,documentacionRecibida:documentacionRecibida.getValue()
						,observaciones:observaciones.getValue()
						,fechaRecepDoc:fechaRecepDocStr
						,'accion':accion
					},success:  function() { 
						//entidad.refrescar();
						//page.fireEvent(app.event.DONE);
						//en Vez de recargarse el tab ahora se mostrará un mensaje y se cerrará
						mask.hide();
						Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _recargar());							
					},error:function(){
						mask.hide();
					}
				});
			}
		}
	};


	var elevarComiteAsunto=function(idAsunto){
			win = app.openWindow(
				{
					flow:'asuntos/editarFichaAceptacionAsunto', 
					title : '<s:message code="asunto.tabaceptacion.fichaAceptacion" text="**Editar Ficha" />',
					params: {id:panel.getAsuntoId(),accion:3},
					width: 350
				}
			);
			win.on(app.event.CANCEL,
					function(){
						win.close();
					}
			);
			win.on(app.event.DONE,
					function(){
						win.close();
						_recargar();
						
					}
			);
	};
	

	
	var recargarTab = function(msg){
		if(msg){
			Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _recargar);
		}else{
			_recargar();
		}	
	}
	
	var _recargar = function(){
		app.abreAsuntoTab(panel.getAsuntoId(), '<s:message text="${asunto.nombre}" javaScriptEscape="true" />', 'aceptacionAsunto');
	}
	
	var buttonElevarAsunto=new Ext.Button({
		text:'<s:message code="expedientes.menu.elevarcomite" text="**Elevar a Comite" />'
		,iconCls:'icon_ok'
		,handler:function(){
			aceptarDevolverAsunto('elevar');
		}
	});

	var buttonDevolverAsunto=new Ext.Button({
		text:'<s:message code="asunto.tabaceptacion.devolver" text="**Devolver" />'
		,iconCls:'icon_devolver'
		,handler:function(){
			aceptarDevolverAsunto('devolver');
		}
	});


	var parametrosAceptacion = {
			layout : 'table'
			,border : false
			,layoutConfig:{
				columns:2
				,rows:1
			}
			,items : [buttonAceptarAsunto,buttonDevolverAsunto,buttonElevarAsunto]
		};

	var parametrosEdicion = {
			layout : 'table'
			,border : false
			,layoutConfig:{
				columns:1
				,rows:1
			}
			,items : [buttonEditarAceptacionAsunto]
		};


	/*FIN BOTONES DEVOLUCION*/
	
	//Lisandro
	//cantidad variable de columnas que voy a usar para el panel de botones
	//el '1' es por el boton historial (va siempre)
	var cantTotalBotones=5; //ANGEL: ahora se calcula el numero de botones a posteriori
	
	
	var panel = new Ext.Panel({
		title:'<s:message code="asunto.tabaceptacion.titulo" text="**Aceptacion"/>'
		,autoHeight:true
		,bodyStyle:'padding:10px'
		,items:[{
					border : false
					,autoWidth:true
					,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
					,items:[
						{ items:[ conflicto,aceptacion,documentacionRecibida,fechaRecepcionDocumentacion]}
						
					]
				}
				,{
					layout : 'table'
					,border : false
					,layoutConfig:{
						columns:2
					}
					,items:[fieldSetObservaciones]
				}
				,{
					layout: 'table'
					,layoutConfig:{columns:cantTotalBotones}
					,bodyStyle:'padding-left:15px'
					,border:false
					,items: [btnVerHistorial,parametrosAceptacion,parametrosEdicion]
				}
			]
			,nombreTab : 'aceptacionAsunto'
	});
	
	panel.getValue = function(){
		return {
			esVisible : {}
		}	
    }
	
    panel.setValue = function(){
		
		var data = entidad.get("data");
		var d = data.aceptacion;
	

		if (d.conflicto!='') conflicto.setValue(d.conflicto);
		aceptacion.setValue(d.aceptacion);
		documentacionRecibida.setValue(d.documentacionRecibida);

		fechaRecepcionDocumentacion.setValue(d.fechaRecepDoc);
		observaciones.setValue(d.observaciones);

		var userid=app.usuarioLogado.id;
        var confirmadoPuedeDevolver = d.estaConfirmado && d.puedoDevolver;

        var esVisible = [
           [buttonEditarAceptacionAsunto, confirmadoPuedeDevolver && ((userid == d.gestor) || (userid == d.supervisor))]
           ,[buttonAceptarAsunto, confirmadoPuedeDevolver && userid==d.gestor]
           ,[buttonDevolverAsunto, confirmadoPuedeDevolver && ((userid == d.gestor) || (userid == d.supervisor))]
           ,[buttonElevarAsunto, (confirmadoPuedeDevolver || d.estaAceptado ) && userid==d.supervisor]
         ];

		entidad.setVisible(esVisible);
    }
	
    panel.getAsuntoId = function(){
		return entidad.get("data").id;
    }
			
	return panel;
})
