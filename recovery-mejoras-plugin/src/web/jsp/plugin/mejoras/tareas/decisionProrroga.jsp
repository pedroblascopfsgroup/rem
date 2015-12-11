<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:130';
	var estiloTitulo = 'vertical-align:center';
	var idTipoEntidad='${idTipoEntidadInformacion}';
	var situacion = '${situacion}';
	var fechaCrear = '${fechaCreacion}';
	var fechaVencimiento = '${fechaVencimiento}';
	var idEntidad = '${idEntidadInformacion}';
	var fechaPropuesta = '${fechaPropuesta}';
	var idTareaOriginal = '${idTareaOriginal}';
	var descripcion = '${descripcion}';
	var motivo = '${motivo}';
	<c:if test="${!isConsulta}">
		var idTipoEntidadInformacion = new Ext.form.Hidden({name:'idTipoEntidadInformacion', value :'${idTipoEntidadInformacion}'}) ;
		var idEntidadInformacion = new Ext.form.Hidden({name:'idEntidadInformacion', value :'${idEntidadInformacion}'}) ;
		var idTareaOriginalH = new Ext.form.Hidden({name:'idTareaOriginal', value :'${idTareaOriginal}'}) ;
	</c:if>

	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";
	var descripcionEntidad="";
	if(idTipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'){
		strTipoEntidad="Cliente";
		//Nombre y apellidos del cliente
		descripcionEntidad=descripcion;
	}
	if(idTipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'){
		strTipoEntidad="Asunto";
		//Nombre del asunto
		descripcionEntidad=descripcion;
	}
	if(idTipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'){
		strTipoEntidad="Expediente";
		//Nombre y Apellidos del 1er titular del Contrato de pase del expediente
		descripcionEntidad=descripcion;
	}
	if(idTipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'){
		strTipoEntidad="Procedimiento";
		descripcionEntidad=descripcion;
	}
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />',idEntidad);

	//textfield que va a contener la descripcion de la entidad
	var txtDescripcionEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.descripcionentidad" text="**Descripcion" />', descripcionEntidad);

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,situacion);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaVencimiento = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechavencimiento" text="**fecha Vencimiento" />', fechaVencimiento);
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,items:[txtEntidad,txtDescripcionEntidad,txtSituacion,txtFechaVencimiento]
		,autoHeight:true
		,autoWidth:true
	});
	
	<c:if test="${!isConsulta}">
		//Text Area
		var descripcion = new Ext.form.TextArea({
			width:250
			,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.respuesta" text="**Respuesta" />'
			,labelStyle:labelStyle
			,name : 'descripcionCausa'
		});
		var label = new Ext.form.Label({
		   	text:'<s:message code="decisionprorroga.descripcion" text="**Decisión prorroga" />'
			,labelStyle:estiloTitulo
		});
	</c:if>

	var motivoSolicitud=app.creaLabel('<s:message code="decisionprorroga.motivo" text="**motivo  prorroga" />',motivo);
	var fechaPropuesta=app.creaLabel('<s:message code="decisionprorroga.fecha" text="**Nueva Fecha propuesta" />',fechaPropuesta);
	
	var descrTareaOriginal = new Ext.form.TextArea({
		width:300
		,fieldLabel:'<s:message code="decisionprorroga.detalle" text="**detalle" />'
		,labelStyle:"font-weight:bolder"
		,readOnly:true
		,value: '<s:message text="${destareaOri}" javaScriptEscape="true" />'
	});
	var panelDatosProrroga = new Ext.form.FieldSet({
		title:'<s:message code="decisionprorroga.datosprorroga" text="**Solicitud de prorroga" />'
		,items:[motivoSolicitud,fechaPropuesta,descrTareaOriginal]
		,autoHeight:true
		,autoWidth:true
	});
	<c:if test="${!isConsulta}">
		//combo 
		/**Combo Respuestas**/
		var combo = app.creaCombo({
			data : <app:dict value="${respuestas}" />
			,name : 'codigoRespuesta'
			//,allowBlank : false
			,fieldLabel : '<s:message code="decisionprorroga.motivo" text="**Seleccione el motivo" />'
			,labelStyle:labelStyle
		});
		var decision = new Ext.form.Checkbox({
			fieldLabel:'<s:message code="decisionprorroga.acepta" text="**Acepta Prorroga" />'
			,labelStyle:labelStyle
			,name:'aceptada'
			
		});
	</c:if>
	<c:if test="${isConsulta}">
		
		var aprobada=app.creaLabel('<s:message code="decisionprorroga.resolucion" text="**Resolucion" />','${decisionProrroga.respuestaProrroga.descripcion}' || '<s:message code="decisionprorroga.decisionpendiente" text="**Pendiente" />');		
		var fieldSetResolucion = new Ext.form.FieldSet({
			title:'<s:message code="decisionprorroga.respuesta" text="**Respuesta" />'
			,items:[aprobada]
			,autoHeight:true
			,autoWidth:true
		});
	</c:if>
	var items = { 
		border : false
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,defaults :  { layout:'form',autoHeight : true, border : false,width:450 }
		,items : [
			{ items : [
				<c:if test="${!isConsulta}">
					label,
				</c:if>
				panelDatosEntidad
				,panelDatosProrroga
				<c:if test="${!isConsulta}">
					//,decision 
					,combo
					,descripcion
					,idTareaOriginalH
					,idEntidadInformacion
					,idTipoEntidadInformacion
				</c:if>
				<c:if test="${isConsulta}">
					,fieldSetResolucion
				</c:if>
				
				] 
			}
		]
	};

				
	
	
	<c:if test="${!isConsulta}">
		var validarForm = function (){
		if (combo.getValue()==null || combo.getValue()==''){
			return false;
		}
		if (descripcion.getValue()==null || descripcion.getValue()==''){
			return false;
		}
		return true;	
	}
		
		var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){
				page.submit({
					eventName : 'cancel'
					,formPanel : panelEdicion
					,success : function(){ page.fireEvent(app.event.CANCEL); } 	
				});
			}
		});
		var btnGuardar = new Ext.Button({
			text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
			,handler : function(){
				if (validarForm()){
					page.submit({
						eventName : 'update'
						,formPanel : panelEdicion
						,success : function(){ page.fireEvent(app.event.DONE) }
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="errores.todosLosDatosObligatorios"/>')
				}
			}		
		});
	</c:if>

	<c:if test="${isConsulta}">
		var btnCerrar = new Ext.Button({
			text : '<s:message code="app.botones.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){
				page.submit({
					eventName : 'ok'
					,formPanel : panelEdicion
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			}
		});
	</c:if>
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'anchor'
				//,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
			<c:if test="${isConsulta}">
				btnCerrar
			</c:if>
			<c:if test="${!isConsulta}">
				btnGuardar, btnCancelar
			</c:if>
		]
	});	
	//var panelEdicion = app.crearABMWindow(page,contenedor);
	page.add(panelEdicion);
	
	
</fwk:page>
