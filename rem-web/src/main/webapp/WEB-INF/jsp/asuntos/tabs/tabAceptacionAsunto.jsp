<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

(function(){
	var labelStyle='font-weight:bolder;width:300'
	//Opciones para los combos Conflicto, Aceptación y Decomentación Recibida.
	var dictCombos = 
		{'diccionario':[
			{'codigo':'true','descripcion':'<s:message code="label.si" text="**Si" />'},
			{'codigo':'false','descripcion':'<s:message code="label.no" text="**No" />'}]}

	conflicto = app.creaCombo({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,fieldLabel : '<s:message code="asunto.tabaceptacion.conflicto" text="**Conflicto"/>'
		,value : '${asunto.fichaAceptacion.conflicto}'
		,labelStyle:labelStyle
		,disabled:true
		,'width':'50px'
	});
	
	aceptacion = app.creaCombo({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="asunto.tabaceptacion.aceptacion" text="**Aceptacion"/>'
		,value : '${asunto.fichaAceptacion.aceptacion}'
		,disabled:true
		,'width':'50px'
	});

	documentacionRecibida = app.creaCombo({
		data : dictCombos
		,name : 'aceptada'
		,allowBlank : false
		,labelStyle:labelStyle
		,fieldLabel : '<s:message code="asunto.tabaceptacion.documentacionRecibida" text="**Documentación recibida"/>'
		,value : '${asunto.fichaAceptacion.documentacionRecibida}'
		,disabled:true
		,'width':'50px'
	});

	var fechaRecepcionDocumentacion = new Ext.ux.form.XDateField({
		name : 'usuario.alta'
		,fieldLabel : '<s:message code="asunto.tabaceptacion.fechaRecepcionDocumentacion" />'
 		,value : '<fwk:date value="${asunto.fechaRecepDoc}" />'
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
		<c:if test="${fn:length(asunto.fichaAceptacion.observaciones)>0}">
			,value:"<s:message text="${asunto.fichaAceptacion.observaciones[0].detalle}" javaScriptEscape="true" />"
		</c:if>
		<app:test id="observacionAceptacion" addComa="true"/>
		
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
				,params:{idAsunto:'${asunto.id}'}
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
		items:[
		tituloobservaciones
			,observaciones
		]
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
		,handler:function(){
			editarAceptarAsunto('${asunto.id}');
		}
	});

	var buttonAceptarAsunto=new Ext.Button({
		text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
		,iconCls:'icon_ok'
		,handler:function(){
			aceptarDevolverAsunto('${asunto.id}', 'aceptar');
		}
	});
	
	//Funcion encargada de abrir el popup para editar los datos del asunto.
	var editarAceptarAsunto=function(idAsunto){
			win = app.openWindow(
				{
					flow:'asuntos/editarFichaAceptacionAsunto', 
					title : '<s:message code="asunto.tabaceptacion.fichaAceptacion" text="**Editar Ficha" />',
					params: {id:${asunto.id},accion:4},
					width: 820
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
	var _cerrarTab = function(){
		app.contenido.remove(app.contenido.activeTab);
	}
	var aceptarDevolverAsunto=function(idAsunto, accion)
	{
		var msg;
		if (accion == 'aceptar' && !(conflicto.getValue()=='false' && aceptacion.getValue()=='true' && documentacionRecibida.getValue()=='true'))
		{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.observacion.aceptarConflicto"/>');
			return;
		}
		else
		{
            var fechaRecepDocStr = '';
            if(fechaRecepcionDocumentacion.getValue()!= '') 
			{
                fechaRecepDocStr = fechaRecepcionDocumentacion.getValue().format('d/m/Y');
            }
			if (documentacionRecibida.getValue()=='true' && fechaRecepcionDocumentacion.getValue()=='') 
			{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ficha.fechaRec.nula" text="**Si la documentación está recibida debe ingresar la fecha." />');
			} 
			else
			{
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
					,params: 
					{
						idAsunto:${asunto.id}
						,conflicto:conflicto.getValue()
						,aceptacion:aceptacion.getValue()
						,documentacionRecibida:documentacionRecibida.getValue()
						,observaciones:observaciones.getValue()
						,fechaRecepDoc:fechaRecepDocStr
						,'accion':accion
					}
					,success:  function()
					{ 
             			page.fireEvent(app.event.DONE);
						//_recargar();
						//en Vez de recargarse el tab ahora se mostrará un mensaje y se cerrará
						mask.hide();
						Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _cerrarTab);							
             		}
					,error:function(){
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
					params: {id:${asunto.id},accion:3},
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
		app.abreAsuntoTab('${asunto.id}', '<s:message text="${asunto.nombre}" javaScriptEscape="true" />', 'aceptacionAsunto');
	}
	
	var buttonElevarAsunto=new Ext.Button({
		text:'<s:message code="expedientes.menu.elevarcomite" text="**Elevar a Comite" />'
		,iconCls:'icon_ok'
		,handler:function(){
			aceptarDevolverAsunto('${asunto.id}', 'elevar');
		}
	});

	var buttonDevolverAsunto=new Ext.Button({
		text:'<s:message code="asunto.tabaceptacion.devolver" text="**Devolver" />'
		,iconCls:'icon_devolver'
		,handler:function(){
			aceptarDevolverAsunto('${asunto.id}', 'devolver');
		}
	});

	var botonesEdicion = new Array();
	var botonesAceptacion = new Array();

	<c:if test="${(asunto.estaConfirmado && puedoDevolver )}">	

		if( ((app.usuarioLogado.id == ${asunto.gestor.usuario.id}) || (app.usuarioLogado.id == ${asunto.supervisor.usuario.id})) ){
			botonesEdicion[botonesEdicion.length] = buttonEditarAceptacionAsunto;			

			if( (app.usuarioLogado.id == ${asunto.gestor.usuario.id})){
				botonesAceptacion[botonesAceptacion.length] = buttonAceptarAsunto;
				botonesAceptacion[botonesAceptacion.length] = buttonDevolverAsunto;
			}
			else if(  (app.usuarioLogado.id == ${asunto.supervisor.usuario.id})){
				botonesAceptacion[botonesAceptacion.length] = buttonDevolverAsunto;
				botonesAceptacion[botonesAceptacion.length] = buttonElevarAsunto;
			}
		}
	</c:if>

	<c:if test="${(asunto.estaAceptado)}">
		if(app.usuarioLogado.id == ${asunto.supervisor.usuario.id})
		{			
			botonesAceptacion[botonesAceptacion.length] = buttonElevarAsunto;
		}	
	</c:if>

	var parametrosAceptacion = {
			layout : 'table'
			,border : false
			,layoutConfig:{
				columns:2
				,rows:1
			}
		};

	var parametrosEdicion = {
			layout : 'table'
			,border : false
			,layoutConfig:{
				columns:1
				,rows:1
			}
		};

	if (botonesAceptacion.length > 0)
	{
		parametrosAceptacion.items = botonesAceptacion;
	}

	if (botonesEdicion.length > 0)
	{
		parametrosEdicion.items = botonesEdicion;
	}


	/*FIN BOTONES DEVOLUCION*/
	
	//Lisandro
	//cantidad variable de columnas que voy a usar para el panel de botones
	//el '1' es por el boton historial (va siempre)
	var cantTotalBotones=1+parametrosAceptacion.length+parametrosEdicion.length;
	
	
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
	
	
		
	return panel;
})()
