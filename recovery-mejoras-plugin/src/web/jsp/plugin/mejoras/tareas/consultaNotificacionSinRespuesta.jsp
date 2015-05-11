<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>


	var label = new Ext.form.Label({
	    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Breve descripcion" />'
			,style:'padding-bottom:5px'
	});

	var tipoEntidad='${data.codigoTipoEntidad}';
	var descEstado = '${data.situacion}';
	var fechaCrear = '${data.fecha}';
	
	//Variable para hacer la notificacion solo de consulta
	
	var readOnly=false;
	<c:if test="${data.readOnly != null && data.readOnly}">
		readOnly = true;
	</c:if>
	var codigoTipoEntidad = new Ext.form.Hidden({name:'codigoTipoEntidad', value :'${data.codigoTipoEntidad}'}) ;
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${data.idEntidad}'}) ;
	var subtipoTarea = new Ext.form.Hidden({name:'subtipoTarea', value :'<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR" />'}) ;
	

	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'){
		strTipoEntidad="Cliente";
	}
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'){
		strTipoEntidad="Asunto";
	}
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'){
		strTipoEntidad="Expediente";
	}
	if(tipoEntidad=='<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'){
		strTipoEntidad="Procedimiento";
	}
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />','${data.idEntidad}');

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="plugin.mejoras.notificaciones.estado" text="**Estado" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaCrear);
	
	var btnEntidad = new Ext.Button({
		text : '<s:message code="app.botones.verdetalle" text="**Ver detalle" />'
		,handler : function(){
			page.fireEvent(app.event.OPEN_ENTITY);
		}
	});
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,items:app.creaFieldSet([txtEntidad,txtSituacion,txtFechaCreacion, btnEntidad])
		,autoHeight:true
	});
	
	var chkLeida=new Ext.form.Checkbox({
		name:'leida'
		,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.leida" text="**Leida" />'
		,handler:function(){
			changeUpdate();
		}
		,hidden:readOnly
		,hideLabel:readOnly
	});


	//Text Area
	var descripcion = new Ext.form.TextArea({
		width:250
		,labelStyle:'font-weight:bolder'
		,readOnly:true
		,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.notificacion" text="**Notificaci�n" />'
		,labelStyle:"font-weight:bolder"
		,name : 'descripcion'
		,value:'<s:message text="${data.textoComunicacion}" javaScriptEscape="true" />'		
	});
	

	var items=[{
		anchor:'100%'
		,style: 'margin-top:5;margin-bottom:5'
		,items:label
	},{
		anchor:'100%'
		,items:panelDatosEntidad
	},{
		anchor:'100%'
		,items:app.creaFieldSet([descripcion])
	}];
	



       if('${data.tipoTarea }' == app.tipoTarea.TIPO_TAREA) {
           var itemsConsulta = { items : [
                       panelDatosEntidad
                       ,descripcion
                       ,idEntidad
                       ,codigoTipoEntidad
                       ,subtipoTarea
                       ]
                       , style : 'margin-right:10px' };
       } else {
   		var itemsConsulta = { items : [
   					panelDatosEntidad
   					,descripcion
   					,chkLeida
   					,idEntidad
   					,codigoTipoEntidad
   					,subtipoTarea
   					]
   					, style : 'margin-right:10px' };
       }
				
			
	
		var items={ 
			border : false
			,layout : 'column'
			,viewConfig : { columns : 1 }
			,defaults :  {layout:'form', autoHeight : true, border : false }
			,items : itemsConsulta
		}

	
	//var panelEdicion = app.crearABMWindowConsulta(page , items);
	/*var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			submitNoLeido();
		}
	});*/
	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if(readOnly)
				submitLeido();
			else
				submitNoLeido();
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'anchor'
				,defaults :  {autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
			btnAceptar
		]
	});	
	
	var submitLeido = function(){
		Ext.Ajax.request({
				url: page.resolveUrl('tareanotificacion/finalizarNotificacion')
				,params: {idTarea: '${data.idTarea}' }				
				,success: function(data){ page.fireEvent(app.event.CANCEL)}
				,failure: function(data){Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.tareas.error.consultaNotificacion"/>')}
			});
	}
	
	var submitNoLeido = function(){
		page.fireEvent(app.event.CANCEL);
	}
	
	var changeUpdate = function(){
		if (chkLeida.getValue()){
				btnAceptar.setHandler(submitLeido);
			}else{
				btnAceptar.setHandler(submitNoLeido);
			}
	}
	page.add(panelEdicion);
	
	
</fwk:page>	