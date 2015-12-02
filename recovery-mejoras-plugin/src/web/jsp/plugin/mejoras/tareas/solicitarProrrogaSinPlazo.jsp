<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	var labelStyle='font-weight:bolder;width:150';
	var tipoEntidad='${codigoTipoEntidad}';
	var situacion = '${situacion}';
	var fechaCrear = '${fechaCreacion}';
	var fechaVencimiento = '${fechaVencimiento}';
	var idEntidad = '${idEntidadInformacion}';
	var descripcion = '${descripcion}';
	var idTipoEntidad = '${idTipoEntidadInformacion}';
	var idTareaAsociada = new Ext.form.Hidden({name:'idTareaAsociada', value :'${idTareaAsociada}'}) ;	
	var idTipoEntidadInformacion = new Ext.form.Hidden({name:'idTipoEntidadInformacion', value :'${idTipoEntidadInformacion}'}) ;
	var idEntidadInformacion = new Ext.form.Hidden({name:'idEntidadInformacion', value :'${idEntidadInformacion}'}) ;

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
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />', idEntidad,{labelStyle:labelStyle});

	//textfield que va a contener la descripcion de la entidad
	var txtDescripcionEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.descripcionentidad" text="**Descripcion" />', descripcionEntidad,{labelStyle:labelStyle});

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,situacion,{labelStyle:labelStyle});
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaVenc = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechavencimiento" text="**fecha Vencimiento" />', fechaVencimiento,{labelStyle:labelStyle});
		
	
	 var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,autoHeight:true
		,border:true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false, style:'margin:4px;width:97%'}
		,items : [
		 	txtEntidad,txtDescripcionEntidad,txtSituacion,txtFechaVenc
		]
	});
	
	
	
	
	var label = new Ext.form.Label({
	   	text:'<s:message code="solicitarprorroga.descripcion" text="**Solicitar prorroga" />'
		,height:20
		,style:'padding:10px'
	});
	
	//combo 
	//var labelCombo='<s:message code="solicitarprorroga.motivo" text="**Seleccione el motivo" />';
	/**Combo Causa**/
	var combo = app.creaCombo({
		data : <app:dict value="${causas}" />
		,name : 'codigoCausa'
		//,allowBlank : false
		,fieldLabel : '<s:message code="solicitarprorroga.motivo" text="**Seleccione el motivo" />'
		,labelStyle:'font-weight:bolder'
	});
	
	var endDate;
	if(fechaVencimiento.length<10){
		endDate = new Date();
	}
	else {
		endDate = new Date(fechaVencimiento.substring(6),(fechaVencimiento.substring(3,5))-1,fechaVencimiento.substring(0,2));
	}
	var ahora = new Date();
	
	if (endDate < ahora){
	//	endDate  = ahora;
	}
	
	var maxDate = endDate;
	maxDate = maxDate.add(Date.DAY,${plazo});
	
	
	<%--var fueraRango = false;
	var today = new Date();
	if (today.getTime() > endDate.getTime()){		
		fueraRango = true;	
	} --%>
	

	//date chooser para solicitar prorroga
	var txtFecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="solicitarprorroga.fecha" text="**Nueva Fecha" />'
		,labelStyle:'font-weight:bolder'
		,minValue : endDate
		//dias maximo de prorroga
		//,maxValue : maxDate
		,name:'fechaPropuesta'	
		//,value:endDate   //TODO: Descomentar para activar que se abra el calendario por la primera fecha posible
	});
	
	var titulodescripcion = new Ext.form.Label({
		   	text:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
			
	var txtFechaError = new Ext.form.Label({
	   	text:'<s:message code="solicitarprorroga.errorFecha" text="**La tarea está vencida y no es posible solicitar una prorroga para ella" />'
		,style:'color:red;font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
		,hidden: true
	});

				
			
	var descripcion = new Ext.form.TextArea({
		width:550
		,height:150
		,bodyStyle:'padding-top:5px'
		,hideLabel: true
		,maxLength:3500
		,fieldLabel:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
		,labelStyle:"font-weight:bolder"
		,name:'descripcionCausa'
		
	});
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
	
	var validarForm = function (){
		if (combo.getValue()==null || combo.getValue()==''){
			return false;
		}
		if (txtFecha.getValue()==null || txtFecha.getValue()==''){
			return false;
		}
		if (descripcion.getValue()==null || descripcion.getValue()==''){
			return false;
		}
		return true;
		
	}
	
	var errorMessage = function(value){
		var fwk = value.fwk;
		var fwkException = fwk.fwkExceptions[0];
		
		var message = '<s:message code="fwk.constant.fwkGenericoError"/>';
		var charPosition = fwkException.indexOf(":");
		if(charPosition != -1 && (charPosition < fwkException.length -1)){
			message = fwkException.substring(charPosition + 1);			
		}
		
		Ext.Msg.minWidth = 200; 	
		Ext.Msg.alert('<s:message code="plugin.mejoras.autoprorroga.error"/>',message);							
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if ('${autoprorroga}'=='true'){
				var max = '${maximoAutoprorrogas}';
				var num = '${numeroAutoprorrogas}';
				if (max>num){
					if (validarForm()){
						page.submit({
							eventName : 'update'
							,formPanel : panelEdicion
							,success : function(){ page.fireEvent(app.event.DONE) }
						});
					}else{
						Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="errores.todosLosDatosObligatorios"/>')
					}
			
				}else{
					Ext.Msg.alert('<s:message code="plugin.mejoras.autoprorroga.error"/>','<s:message code="plugin.mejoras.autoprorroga.error.maxIntentos"/>')
				}
			
			}else{
				if (validarForm()){
						page.submit({
							eventName : 'update'
							,formPanel : panelEdicion
							,success : function(){ page.fireEvent(app.event.DONE) }
							,error: errorMessage
						});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="errores.todosLosDatosObligatorios"/>')
				}
			}
		}
	});

	if ('${autoprorroga}'=='true'){
			var plazo = '${plazoAutop.plazo}';
			var vencDate = new Date(fechaVencimiento.substring(6),(fechaVencimiento.substring(3,5))-1,fechaVencimiento.substring(0,2));	
			var maxDate = vencDate;
			maxDate = maxDate.add(Date.MILLI,plazo);
			var today = new Date();
			<%--if (today.getTime() > maxDate.getTime()){
				if ('${permitirVencidas}' != 'true'){
					txtFecha.setDisabled(true);
					combo.setDisabled(true);
					descripcion.setDisabled(true);
		
					txtFechaError.show();
					btnGuardar.setDisabled(true);
				}			
			}
			else{
				txtFecha.setMaxValue(maxDate);
			} --%>	 
			txtFecha.setMaxValue(maxDate);
			
	}
	<%--
	if (fueraRango) {
	
		txtFecha.setDisabled(true);
		combo.setDisabled(true);
		descripcion.setDisabled(true);
		
		txtFechaError.show();
		btnGuardar.setDisabled(true);
	
	} --%>
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,border : false
		,layoutConfig:{columns:2}
		,bodyStyle:'padding:5px'
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,autoHeight:true
				,xtype:'fieldset'
				,defaults :  {layout: 'form' }
				,items : [panelDatosEntidad
				,combo
				,txtFechaError
				,txtFecha
				,titulodescripcion
				,descripcion
				,idTipoEntidadInformacion,idTareaAsociada,idEntidadInformacion]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	page.add(panelEdicion);
	
	
</fwk:page>	