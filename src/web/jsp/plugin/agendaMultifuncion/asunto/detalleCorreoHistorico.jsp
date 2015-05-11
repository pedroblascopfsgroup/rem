<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	<c:if test="${from != null}">
		var emisor='${from}';
		//textfield que va a contener el emisor
		var txtEmisor = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.emisor" text="**Emisor" />',emisor);
	</c:if>
	

		
	<c:if test="${to != null}">
		var destinatario='${to}';
		//textfield que va a contener el destinatario
		var txtDestinatario = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.destinatario" text="**Destinatario" />',destinatario);
	</c:if>
	<c:if test="${cc != null}">
		var cc='${cc}';
		var txtCC = app.creaLabel('<s:message code="plugin.agendaMultifuncion.nuevaAnotacion.mail.cc" text="**CC" />',cc);
	</c:if>
	
		var asunto = '${asunto}';
		var txtAsunto = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.asunto" text="**Asunto email" />',asunto);
	
	var titulolabeltareaOriginal = new Ext.form.Label({
	    	text:'<s:message code="ext.comunicaciones.generarnotificacion.textoComunicacion" text="**Breve descripcion" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
	
	var heightOriginal = 200;
	var heightExpandido = 300;
	var labeltareaOriginal = new Ext.form.HtmlEditor({
			id:'htmlDescripcion'
			,readOnly:true
			,hideLabel:true
			,width:590
			,maxLength:3500
			,height : heightOriginal
			,hideParent:true
			,enableColors: false
        	,enableAlignments: false
        	,enableFont:false
        	,enableFontSize:false
        	,enableFormat:false
        	,enableLinks:false
        	,enableLists:false
        	,enableSourceEdit:false
        	,value:'<s:message text="${body}" javaScriptEscape="true" />'
	});
	
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${idAsunto}'}) ;
	
	
	var codUg = '${codUg}';
	var strTipoEntidad;
	//Tipo de entidad (Cliente | Expediente | Asunto )
	if(codUg == '3')
		strTipoEntidad="Asunto";
	if(codUg == '2')
		strTipoEntidad="Expediente";
	if(codUg == '1')
		strTipoEntidad="Cliente";
	if(codUg == '9')
		strTipoEntidad="Persona";
		
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />','${idAsunto}');

	
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,width:590
		,collapsible:true
		,items:app.creaFieldSet([txtEntidad
		,txtEmisor 
		,txtDestinatario
		<c:if test="${cc != null}"> ,txtCC </c:if>
		,txtAsunto
		])
		,autoHeight:true
		,listeners: {
              beforeExpand:function(){
					
					labeltareaOriginal.setHeight(heightOriginal);
					
              }
              ,beforeCollapse:function(){
					
					labeltareaOriginal.setHeight(heightExpandido);
              }
          }
	});


	var titulodescripcion = new Ext.form.Label({
    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Breve descripcion" />'
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
				]
				, style : 'margin-right:15px' }
		]
	}

	//var panelEdicion = app.crearABMWindowConsulta(page , items);
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});

	var panelEdicion = new Ext.form.FormPanel({
		 height:450
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
			<%-- btnGuardar,--%> btnCancelar
		]
		
	});
	
	page.add(panelEdicion);
	
</fwk:page>	