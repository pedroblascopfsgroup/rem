<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	<c:if test="${data.emisor != null}">
		var emisor='${data.emisor}';
		//textfield que va a contener el emisor
		var txtEmisor = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.emisor" text="**Emisor" />',emisor);
	</c:if>
		<c:if test="${data.nombreAsunto != null}">
		var nombreAsunto='${data.nombreAsunto}';
		var txtNombreAsunto = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.nombreAsunto" text="**Nombre asunto" />',nombreAsunto);
	</c:if>
	<c:if test="${data.fechaVencimiento != null}">
		var fecha_vencimiento='${data.fechaVencimiento}';
		
		//textfield que va a contener la fecha vencimiento
		var txtFechaVencimiento = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.fechaVencimiento" text="**Fecha vencimiento" />',fecha_vencimiento);
	</c:if>
	
	var heightOriginal = 100;
	var heightExpandido = 170;	
	
	<c:if test="${data.respuesta != null}">
		var labeltareaRespuesta = new Ext.form.HtmlEditor({
			id:'htmlRespuesta'
			,fieldLabel : 'Texto de respuesta'
			,hideLabel:true
			,width:590
			,maxLength:3500
			,height : heightOriginal
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
        	,value:'${data.respuesta}'
		});
		
		var txtRespuesta = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.respuesta" text="**Texto de respuesta" />');
	</c:if>
		
	<c:if test="${data.destinatario != null}">
		var destinatario='${data.destinatario}';
		//textfield que va a contener el destinatario
		var txtDestinatario = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.destinatario" text="**Destinatario" />',destinatario);
	</c:if>
	
	var titulolabeltareaOriginal = new Ext.form.Label({
	    	text:'<s:message code="ext.comunicaciones.generarnotificacion.textoComunicacion" text="**Breve descripcion" />'
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
        	,value:'<s:message text="${data.descripcion}" javaScriptEscape="true" />'
	});
	
	var descEstado = '${data.situacion}';
	var fechaCrear = '${data.fecha}';
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${data.idAsunto}'}) ;
	var idTarea = new Ext.form.Hidden({name:'idTarea', value :'${data.idTarea}'}) ;
	
	
	var codUg = '${data.codUg}';
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
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />','${data.idAsunto}');

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaCrear);
	
	
			
	
	 var btnExportarPDF=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.pdf" text="**Exportar a PDF" />'
        ,iconCls:'icon_pdf'
        ,handler: function() {        
         	var flow = 'plugin/agendaMultifuncion/asuntos/plugin.agendaMultifuncion.asuntos.exportarDetalleAnotacionHistorico';         	
		var params = {
			emisor: '${data.emisor}'
			,destinatario:'${data.destinatario}'
			,fechaCreacion:'${data.fecha}'
			,nombreAsunto:'${data.nombreAsunto}'
			,numLitigio:'${data.numLitigio}'
			,situacion:'${data.situacion}'
			,idasunto:'${data.idAsunto}'
			,tipoentidad: strTipoEntidad	
			,idTraza:'${data.idTraza}'	
			,idTarea:'${data.idTarea}'			
		};
		app.openBrowserWindow(flow,params);
	}
    });
	
	var cfg ={
			layout:'column'
			//,layoutConfig:{columns:2}
			,title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
			,width:590
			,labelStyle:'font-weight:bolder'
			,collapsible:true
			,autoHeight:true
			,defaults: {
		        bodyStyle:'padding:1px'
		        ,border:false
		        ,layout:'form'
    			}
    		
    		,listeners: {
              beforeExpand:function(){
					
					
					<c:if test="${data.respuesta !=null}">
						labeltareaOriginal.setHeight(heightOriginal);
						labeltareaRespuesta.setHeight(heightOriginal);
					</c:if>
					<c:if test="${data.respuesta ==null}">
						labeltareaOriginal.setHeight(heightOriginal);
					</c:if>
					
              }
              ,beforeCollapse:function(){
              		<c:if test="${data.respuesta !=null}">
						labeltareaOriginal.setHeight(heightExpandido);
						labeltareaRespuesta.setHeight(heightExpandido);
					</c:if>
					<c:if test="${data.respuesta ==null}">
						labeltareaOriginal.setHeight(heightExpandido*2);
					</c:if>
						
              }
             }
          }
    cfg.items = [{columnWidth:0.5,items:[txtEntidad]}
    			<c:if test="${data.nombreAsunto != null}">
    			,{ columnWidth:1,items:[txtNombreAsunto]}	
    			</c:if>
				<c:if test="${data.numLitigio != null}">
				,{columnWidth:1,items:[txtNumLitigio]}
				</c:if>
				,{columnWidth:1,items:[txtSituacion]}
				<c:if test="${data.emisor != null}">
					<c:if test="${data.destinatario != null}">
						,{columnWidth:0.5,items:[txtEmisor,txtDestinatario]} 
					</c:if>
					<c:if test="${data.destinatario == null}">
						,{columnWidth:1,items:[txtEmisor]} 
					</c:if>
				</c:if>
				<c:if test="${data.fechaVencimiento != null}">
				,{columnWidth:0.5,items:[txtFechaCreacion,txtFechaVencimiento]}
				</c:if>
				<c:if test="${data.fechaVencimiento == null}">
				,{columnWidth:1,items:[txtFechaCreacion]}
				</c:if>

					]
		
	var panelDatosEntidad = new Ext.form.FieldSet(cfg);
	
			
	
<%-- 	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,width:590
		,items:app.creaFieldSet([txtEntidad
		<c:if test="${data.nombreAsunto != null}">,txtNombreAsunto </c:if>
		<c:if test="${data.numLitigio != null}">,txtNumLitigio </c:if>
		,txtSituacion
		<c:if test="${data.emisor != null}">,txtEmisor </c:if>
		<c:if test="${data.destinatario != null}">,txtDestinatario </c:if>
		,txtFechaCreacion
		<c:if test="${data.fechaVencimiento != null}">,txtFechaVencimiento </c:if>
		])
		,autoHeight:true
	});
--%>
	
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
				<c:if test="${data.respuesta != null}">,txtRespuesta,labeltareaRespuesta</c:if>
				
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
		height:490
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
			<%-- btnGuardar,--%> btnCancelar, btnExportarPDF
		]
	});
	page.add(panelEdicion);

</fwk:page>	