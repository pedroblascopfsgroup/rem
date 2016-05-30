<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
var idEntidad;	
var id;
var descripcion;
var emisor;
var descripcionEntidad;
var fechaInicio;
var codigoEntidadInformacion;

	<c:if test="${idEntidad != null}">
		idEntidad = ${idEntidad};
	</c:if>
	<c:if test="${id != null}">
		id = ${id};
	</c:if>
	<c:if test="${emisor != null}">
		emisor = "${emisor}";
	</c:if>
		<c:if test="${descripcionEntidad != null}">
		descripcionEntidad = "${descripcionEntidad}";
	</c:if>
	<c:if test="${fechaInicio != null}">
		fechaInicio = "${fechaInicio}";	
	</c:if>
	<c:if test="${codigoEntidadInformacion != null}">
		codigoEntidadInformacion = ${codigoEntidadInformacion};
	</c:if>
	<c:if test="${descripcion != null}">
		descripcion = "${descripcion}";
	</c:if>

	
	
	var heightOriginal = 100;
	var heightExpandido = 170;	
	
	
	
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
        	,value:'<s:message text="${descripcion}" javaScriptEscape="true" />'
	});
	

	
	
	var strTipoEntidad;
	//Tipo de entidad (Cliente | Persona )
	if(codigoEntidadInformacion == '1')
		strTipoEntidad="Cliente";
	if(codigoEntidadInformacion == '9')
		strTipoEntidad="Persona";
		
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />',idEntidad);

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,strTipoEntidad);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaInicio);
	
	//textfield que va a contener el emisor
	var txtEmisor = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.emisor" text="**Emisor" />',emisor);
	
			
	
	 var btnExportarPDF=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.pdf" text="**Exportar a PDF" />'
        ,iconCls:'icon_pdf'
        ,handler: function() {        
         	var flow = 'plugin/agendaMultifuncion/asuntos/plugin.agendaMultifuncion.asuntos.exportarDetalleAnotacionHistorico';         	
		var params = {
			emisor: emisor
			,destinatario:''
			,fechaCreacion:fechaInicio
			,nombreAsunto:''
			,numLitigio:''
			,situacion:strTipoEntidad
			,idasunto:idEntidad
			,tipoentidad: strTipoEntidad	
			,idTraza:id
			,idTarea:''			
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
			,cls:'titleHistoricoEventos'
			,collapsible:true
			,autoHeight:true
			,defaults: {
		        bodyStyle:'padding:1px'
		        ,border:false
		        ,layout:'form'
    			}
    		
    		
          }
    cfg.items = [{columnWidth:0.5,items:[txtEntidad]}
    			,{columnWidth:1,items:[txtSituacion]}
				<c:if test="${emisor != null}">
						,{columnWidth:1,items:[txtEmisor]} 
				</c:if>
				<c:if test="${fechaInicio != null}">
				,{columnWidth:1,items:[txtFechaCreacion]}
				</c:if>

					]
		
	var panelDatosEntidad = new Ext.form.FieldSet(cfg);
	
			

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
				]
				, style : 'margin-right:15px' }
		]
	}

	
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
			btnCancelar, btnExportarPDF
		]
	});
	page.add(panelEdicion);

</fwk:page>	