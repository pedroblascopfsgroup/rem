<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	<c:if test="${data.usuarioOrigenTarea != null}">
		var emisor='${data.usuarioOrigenTarea}';
		//textfield que va a contener el emisor
		var txtEmisor = app.creaLabel('<s:message code="plugin.calendario.usuarioOrigenTarea" text="**Emisor" />',emisor);
	</c:if>
	<c:if test="${data.fechaVencimientoDesde != null}">
		var fecha_vencimiento='${data.fechaVencimientoDesde}';
		
		//textfield que va a contener la fecha vencimiento
		var txtfechaVencimientoDesde = app.creaLabel('<s:message code="plugin.calendario.fechaVencimientoDesde" text="**Fecha vencimiento" />',fecha_vencimiento);
	</c:if>

	<c:if test="${data.tieneResponder == true}">
		var labeltareaRespuesta = new Ext.form.HtmlEditor({
			id:'htmlRespuesta'
			,fieldLabel : 'Texto de respuesta'
			,hideLabel:true
			,width:590
			,maxLength:3500
			,height : 100
			<%-- <c:if test="${data.respuesta != null}"> --%>
			,readOnly:true
			,hideParent:true
			,enableColors: false
        	,enableAlignments: false
        	,enableFont:false
        	,enableFontSize:false
        	,enableFormat:false
        	,enableLinks:false
        	,enableLists:false
        	,enableSourceEdit:false
			,html:'${data.respuesta}'
			<%-- </c:if> --%>
			});
		var txtRespuesta = app.creaLabel('<s:message code="plugin.calendario.respuesta" text="**Texto de respuesta" />');
	</c:if>
			
	<c:if test="${data.usuarioDestinoTarea != null}">
		var destinatario='${data.usuarioDestinoTarea}';
		//textfield que va a contener el destinatario
		var txtDestinatario = app.creaLabel('<s:message code="plugin.calendario.usuarioDestinoTarea" text="**Destinatario" />',destinatario);
	</c:if>
	
	var titulolabeltareaOriginal = new Ext.form.Label({
	    	text:'<s:message code="plugin.calendario.textoComunicacion" text="**Breve descripcion" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
	
	var labeltareaOriginal = new Ext.form.HtmlEditor({
			id:'htmlDescripcion'
			,readOnly:true
			,hideLabel:true
			,width:590
			,maxLength:3500
			,height : 100
			,hideParent:true
			,enableColors: false
        	,enableAlignments: false
        	,enableFont:false
        	,enableFontSize:false
        	,enableFormat:false
        	,enableLinks:false
        	,enableLists:false
        	,enableSourceEdit:false
			,html:'<s:message text="${data.descripcion}" javaScriptEscape="true" />'});
			
	var chkLeida=new Ext.form.Checkbox({
		name:'leida'
		,fieldLabel:'<s:message code="plugin.calendario.leida" text="**Leida" />'		
	});	
			
	var descEstado = '${data.situacion}';
	var fechaCrear = '${data.fechaInicioDesde}';
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${data.idAsunto}'}) ;
	var idTarea = new Ext.form.Hidden({name:'idTarea', value :'${data.id}'}) ;
		
	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="Asunto";
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="plugin.calendario.codigoentidad" text="**Codigo" />','${data.idAsunto}');

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="plugin.calendario.situacion" text="**Situacion" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="plugin.calendario.fechaInicioDesde" text="**Fecha creacion" />', fechaCrear);
	
	var btnEntidad = new Ext.Button({
		text : '<s:message code="plugin.calendario.verdetalle" text="**Ver detalle" />'
		,handler : function(){
			page.fireEvent(app.event.OPEN_ENTITY);
		}
	});
				
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="plugin.calendario.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,width:590
		,items:app.creaFieldSet([txtEntidad
		,txtSituacion
		<c:if test="${data.usuarioOrigenTarea != null}">,txtEmisor </c:if>
		<c:if test="${data.usuarioDestinoTarea != null}">,txtDestinatario </c:if>
		,txtFechaCreacion
		<c:if test="${data.fechaVencimientoDesde != null}">,txtfechaVencimientoDesde </c:if>
		<%-- ,btnEntidad --%>
		])
		,autoHeight:true
	});
	
	var titulodescripcion = new Ext.form.Label({
    	text:'<s:message code="plugin.calendario.descripcion" text="**Breve descripcion" />'
		,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
		});

	var items={
		border : false
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [
			{ items : [
				panelDatosEntidad
				,titulolabeltareaOriginal
				,labeltareaOriginal
				,idEntidad
				<c:if test="${data.tieneResponder == true}">,txtRespuesta,labeltareaRespuesta</c:if>
				<c:if test="${data.fechaVencimientoDesde == null}">,chkLeida</c:if>
				]
				, style : 'margin-right:15px' }
		]
	}

	//var panelEdicion = app.crearABMWindowConsulta(page , items);
	
	var btnCancelar= new Ext.Button({
		<%-- text : '<s:message code="plugin.calendario.cancelar" text="**Cancelar" />' --%>
		text : '<s:message code="plugin.calendario.volver" text="**Volver" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.calendario.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			<c:if test="${data.fechaVencimientoDesde != null}">
			if(labeltareaRespuesta.getValue() == null || labeltareaRespuesta.getValue() ==''){
				 Ext.MessageBox.show({
				   title: 'Aviso',
				   msg: 'Debe escribir una respuesta',
				   width:300,
				   buttons: Ext.MessageBox.OK
				 
			   });
			}else{	
				<%-- 
				Ext.Ajax.request({
					url: page.resolveUrl('recoveryagendamultifuncionanotacion/responderTarea')
					,params: {idTarea: idTarea.getValue(), respuesta:labeltareaRespuesta.getValue(), idAsunto:idEntidad.getValue(), leida:false}				
					,success: function(){ page.fireEvent(app.event.DONE) }
				});
				--%>
			}
			</c:if>
			<c:if test="${data.fechaVencimientoDesde == null}">
			<%--
			Ext.Ajax.request({
				url: page.resolveUrl('recoveryagendamultifuncionanotacion/marcarTareaLeida')
				,params: {idTarea: idTarea.getValue(),leida:chkLeida.getValue()}
				
				,success: function(){ page.fireEvent(app.event.DONE) }
			});
			 --%>
			</c:if>
		}
		<app:test id="btnGuardarABM" addComa="true"/>
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
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
			<%-- <c:if test="${data.tieneResponder == true}">btnGuardar, </c:if> --%>
			btnCancelar
		]
	});
	
	page.add(panelEdicion);
	
</fwk:page>	