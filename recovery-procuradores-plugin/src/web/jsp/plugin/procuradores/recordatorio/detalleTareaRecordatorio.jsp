<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

var fechaSeny = app.format.dateRenderer('${data.recordatorio.fecha}'.substring(0, 10));

var txtFechaseny = app.creaLabel('<s:message code="ext.comunicaciones.recordatorios.fechaseny" text="**Fecha señalamiento" />',fechaSeny);
var txtTitulo = app.creaLabel('<s:message code="ext.comunicaciones.recordatorios.titulo" text="**Título" />','${data.recordatorio.titulo}');


	var heightOriginal = 182;
	var heightExpandido = 182;
	var altoOriginalDos = 70;
	var altoExpandidoDos = 160;

<%--	var labeltareaRespuesta = new Ext.form.HtmlEditor({ --%>
<%--		id:'htmlRespuesta' --%>
<%--		,fieldLabel : 'Texto de respuesta' --%>
<%--		,hideLabel:true --%>
<%--		,width:790 --%>
<%--		,maxLength:3500 --%>
<%--		,height : altoOriginalDos --%>
<%--		,readOnly:false --%>
<%--		,hideParent:true --%>
<%--		,enableColors: false --%>
<%--       	,enableAlignments: false --%>
<%--       	,enableFont:false --%>
<%--       	,enableFontSize:false --%>
<%--       	,enableFormat:false --%>
<%--       	,enableLinks:false --%>
<%--       	,enableLists:false --%>
<%--       	,enableSourceEdit:false --%>
<%--        	,value:'<s:message text="${data.respuesta}" javaScriptEscape="true" />' --%>
<%--		}); --%>
		
<%-- 	var txtRespuesta = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.respuesta" text="**Texto de respuesta" />'); --%>
			
	
	var titulolabeltareaOriginal = new Ext.form.Label({
	    	text:'<s:message code="ext.comunicaciones.generarnotificacion.textoComunicacion" text="**Breve descripcion" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});
			
			
	
	var labeltareaOriginal = new Ext.form.HtmlEditor({
			id:'htmlDescripcion'
			,readOnly:true
			,hideLabel:true
			,width:790
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
        	,value:'<s:message text="${data.descripcion}" javaScriptEscape="true" />'
	});

	var chkLeida=new Ext.form.Checkbox({
		name:'tareaCerrada'
		,handler:function(){
			btnGuardar.setDisabled(false);
		}
		,fieldLabel:'<s:message code="comunicaciones.recordatorio.tarea.cerrado" text="**Cerrado" />'			
	});	
	
	
	var descEstado = '${data.situacion}';
	var fechaRecordatorio = '${data.fechaVencimiento}';
	var idEntidad = new Ext.form.Hidden({name:'idEntidad', value :'${data.idAsunto}'}) ;
	var idTarea = new Ext.form.Hidden({name:'idTarea', value :'${data.idTarea}'}) ;
	var codUg = '${data.codUg}';
		
	
		//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaRecordatorio = app.creaLabel('<s:message code="plugin.procuradores.recordatorio.detallerecordatorio.fechaRecordatorio" text="**Fecha recordatorio" />', fechaRecordatorio);
	
	
	var btnEntidad = new Ext.Button({
		text : '<s:message code="app.botones.verdetalle" text="**Ver detalle" />'
		,handler : function(){
			page.fireEvent(app.event.OPEN_ENTITY);
		}
	});
	
	var cfg ={
			layout:'table'
			,layoutConfig:{columns:2}
			,title:'<s:message code="comunicaciones.recordatorios.generarnotificacion.datosentidadRecordatorio" text="**Datos del recordatorio" />'
			,width:790
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
					labeltareaOriginal.setHeight(altoOriginalDos);
<%--					labeltareaRespuesta.setHeight(altoOriginalDos); --%>
					
              }
              ,beforeCollapse:function(){
              		labeltareaOriginal.setHeight(altoExpandidoDos);
<%--					labeltareaRespuesta.setHeight(altoExpandidoDos);	 --%>
              }
             }
          }
    cfg.items = [
    			
    			{ columnWidth:1,items:[txtFechaseny]}	
				,{columnWidth:1,items:[txtTitulo]}
				
				]
		
	var panelDatosEntidad = new Ext.form.FieldSet(cfg);

	
	var titulodescripcion = new Ext.form.Label({
    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Descripcion" />'
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
				,txtFechaRecordatorio
				,titulolabeltareaOriginal
				,labeltareaOriginal
				,idEntidad
<%--				,txtRespuesta --%>
<%--				,labeltareaRespuesta --%>
				,chkLeida
				]
				, style : 'margin-right:15px' 
			}
		]
	}

	//var panelEdicion = app.crearABMWindowConsulta(page , items);
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		
				panelEdicion.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
				panelEdicion.getForm().submit(
				{	
				    clientValidation: true,
					url: '/'+app.getAppName()+'/recrecordatorio/resolverTareaRecRecordatorio.htm',
					params : {
								idTarea:${data.idTarea}
							 },
					 success: function(form, action) {
				       panelEdicion.container.unmask();
				       page.fireEvent(app.event.DONE);
				    },
				    failure: function(form, action) {
				    	panelEdicion.container.unmask();
						Ext.Msg.alert('<s:message code="plugin.procuradores.recordatorio.formalta.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.recordatorio.formalta.validacion.cerra.tarea.texto" text="**No se ha podido actualizar el estado de la tarea" />');
				    }
				});
		}
		<app:test id="btnGuardarABM" addComa="true"/>
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
			btnGuardar,btnCancelar
		]
	});
	page.add(panelEdicion);

	Ext.onReady(function(){
                btnGuardar.setDisabled(true);
       	});
	
</fwk:page>	