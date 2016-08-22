<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

var tareas={};
tareas.GENERAR_TAREA		= 0; //Comunicacion
tareas.GENERAR_NOTIFICACION	= 1; //Respuesta Comunicacion
tareas.SOLICITAR_PRORROGA	= 2;
tareas.DECISION_PRORROGA	= 3;
tareas.CONSULTA				= 4; 

var comunicacionesWindow=function(tipoVentana,tipoEntidad,idEntidad, idTarea,descTareaPendiente,descEstado, fechaCrear){
	
	//variables comunes a todas las ventanas
	//tipo de entidad
	var ein_id;
	//id de entidad
	var id;
	//descripcion, no va..
	var descripcion;
	//subtipo de tarea
	var sta_id;
	
	//ventana principal
	var title;
	
	var creaBaseWin=function(title,contenido){
		var win = new Ext.Window({
			title:title
			,modal:true
			,autoWidth:true
			,autoHeight:true
			,resizable:false
			,bodyBorder:false
			,items:[contenido]
		});
		return win;
	};
	
	
	//rellenar con diccionarios
	var optionsSolProrroga = {diccionario:[{codigo:'1',descripcion:'Ausente'},{codigo:'2',descripcion:'Defuncion'}]};
	//rellenar con diccionarios	
	var optionsAceptarProrroga = {diccionario:[{codigo:'1',descripcion:'Denegado, falta documentacion'},{codigo:'2',descripcion:'Reincidente'}]};
	
	
	//store generico de combo diccionario
	var optionsStore = new Ext.data.JsonStore({
	        fields: ['codigo', 'descripcion']
	        ,root: 'diccionario'
	        ,data : this.optionsSolProrroga
	    });
		
	
	//label descripcion
    var label;
	//label tarea original
	var labeltareaOriginal;
	//handler de botones, por ahora siempre el mismo
	var handler=function(){
		win.close();
	}
	//botonOk
	
			
	
    var btnOk = new Ext.Button({
		text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
		,handler:function(){
			switch(tipoVentana){
				case tareas.GENERAR_TAREA:
				var codigoTipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
					if(reqRes.getValue() == true){
						codigoTipoTarea = app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR;
					}
				var fechaFin;
				if(txtFecha.disabled == false){
					fechaFin = txtFecha.getValue().format('Y-m-d');
				}	
					var newPage = page.webflow({
  					flow : 'tareas/updateTarea'
  							,params : {idEntidadInformacion:idEntidad,
           					idTipoEntidadInformacion:tipoEntidad,
           					codigoSubtipoTarea: codigoTipoTarea,
           					enEspera: true,
           					esAlerta: false,
           					descripcion:descripcion.getValue(),
           					fechaFinComunicacion:fechaFin 
           					}
          				})
          		break;		
				case tareas.GENERAR_NOTIFICACION:
					var newPage = page.webflow({
  					flow : 'tareas/updateTarea'
  					,params : {id:idTarea,
  					idEntidadInformacion:idEntidad,
           			idTipoEntidadInformacion:tipoEntidad,
          			 codigoSubtipoTarea: app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
          			 enEspera: false,
          			 esAlerta: false,
           			 descripcion:descripcion.getValue()
           			}
         		 })
         		break;	 
				}
			handler();
		}
	});
	//Boton Cancel
	var btnCancel= new Ext.Button({
		text:'<s:message code="app.botones.cancelar" text="**Cancelar" />'
		,handler:function(){
			handler();
		}
	});
	//boton rechazar
	var btnRechazar= new Ext.Button({
		text:'<s:message code="app.botones.rechazar" text="**Rechazar" />'
		,handler:function(){
			handler();
		}
	});
	//Botonera
	var buttonPanel = new Ext.Panel({
			layout:'column'
			,autoHeight:true
			,autoWidth:true
			,border:false
			,style:'margin-left: 20%'
			,defaults:{
				border:false
			}
			,items:[{
				columnWidth:.5
				,items:btnOk
			},{
				columnWidth:.5
				,items:btnCancel
			}]
	});
	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";
	if(tipoEntidad==<%= DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE %>){
		strTipoEntidad="Cliente";
	}
	if(tipoEntidad==<%= DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO%>){
		strTipoEntidad="Asunto";
	}
	if(tipoEntidad==<%= DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE %>){
		strTipoEntidad="Expediente";
	}
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />',idEntidad);

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,descEstado);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechacreacion" text="**fecha Creacion" />', fechaCrear);
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,items:app.creaFieldSet([txtEntidad,txtSituacion,txtFechaCreacion])
		,autoHeight:true
	});
	
	//Text Area
	var descripcion = new Ext.form.TextArea({
		width:250
		,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.respuesta" text="**Respuesta" />'
		,labelStyle:"font-weight:bolder"
		
	});
		
	//combo generico
	var createCombo=function(title,store){
		var combo = new Ext.form.ComboBox({
			store:optionsStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:'font-weight:bolder'
			,fieldLabel : title
		});	
	};
	
	
	
	var items=[];
	
	
	
	//en base al tipo de pantalla voy agregando items
	//este es generico
	switch(tipoVentana){
		case tareas.GENERAR_TAREA://Generar Tarea
			title='<s:message code="message" text="**Generar Tarea" />';
		    
			label = new Ext.form.Label({
			   	text:'<s:message code="message" text="**Introduzca el texto de la comunicacion" />'
			});
			var reqRes = new Ext.form.Checkbox({
				fieldLabel:'<s:message code="message" text="**¿Requiere Respuesta?" />'
				<app:test id="checkRespuesta" addComa="true"/>
				,handler:function(){
					if(txtFecha.disabled == true){
						txtFecha.enable();
					}else{
						txtFecha.disable();
					}
				}
			})
			//date chooser 
			var txtFecha = new Ext.form.DateField({
				fieldLabel:'<s:message code="message" text="**Fecha" />'
				<app:test id="fechaRespuesta" addComa="true"/>
				,labelStyle:'font-weight:bolder'
				,minValue : new Date()
				,disabled :true
			});
			items=[{
				anchor:'100%'
				,items:label
			},{
				anchor:'100%'
				,items:descripcion
			},{
				anchor:'100%'
				,items:app.creaFieldSet(reqRes)
			},{
				anchor:'100%'
				,items:app.creaFieldSet(txtFecha)
			},{
				anchor:'100%'
				,items:buttonPanel
			}];
			break;
		case tareas.GENERAR_NOTIFICACION://Generar Notificacion
			title='<s:message code="comunicaciones.generarnotificacion.titulo" text="**Generar Notificacion" />';
			label = new Ext.form.Label({
			    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Breve descripcion" />'
			});
			labeltareaOriginal=new Ext.form.TextArea({
				fieldLabel:'<s:message code="comunicaciones.generarnotificacion.preguntaorigen" text="**Pregunta Origen" />'
				,labelStyle:'font-weight:bolder'
				,width:250
				,readOnly:true
				,disabled:true				
				,value:descTareaPendiente
			});
			items=[{
				anchor:'100%'
				,style: 'margin-top:5;margin-bottom:5'
				,items:label
			},{
				anchor:'100%'
				,items:panelDatosEntidad
			},{
				anchor:'100%'
				,items:app.creaFieldSet([labeltareaOriginal])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([descripcion])
			},{
				anchor:'100%'
				,items:buttonPanel
			}];
			break;
		case tareas.SOLICITAR_PRORROGA://solicitar Prorroga
			title='<s:message code="message" text="**Solicitar Prorroga" />';
			label = new Ext.form.Label({
			   	text:'<s:message code="message" text="**Solicitar prorroga" />'
			});
			//combo 
			var labelCombo='<s:message code="" text="**Seleccione el motivo" />';
			var optionsStore = new Ext.data.JsonStore({
		        fields: ['codigo', 'descripcion']
		        ,root: 'diccionario'
		        ,data : optionsSolProrroga
		    });
			
			//var combo=createCombo(labelCombo,optionsStore);
			var combo = new Ext.form.ComboBox({
				store:optionsStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:'font-weight:bolder'
				,fieldLabel : labelCombo
			});	
			
			//date chooser para solicitar prorroga
			var txtFecha = new Ext.form.DateField({
				fieldLabel:'<s:message code="message" text="**Nueva Fecha" />'
				,labelStyle:'font-weight:bolder'
				,minValue : new Date()
				//dias maximo de prorroga
				,maxValue : new Date().add(Date.DAY,10)
			});
			var descripcion = new Ext.form.TextArea({
				width:250
				,fieldLabel:'<s:message code="comunicaciones.solprorroga.descripcion" text="**Descripcion" />'
				,labelStyle:"font-weight:bolder"
				
			});
			items=[{
				anchor:'100%'
				,items:label
			},{
				anchor:'100%'
				,items:panelDatosEntidad
			},{
				anchor:'100%'
				,items:app.creaFieldSet([combo])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([txtFecha])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([descripcion])
			},{
				anchor:'100%'
				,items:buttonPanel
			}];
			break;
		case tareas.DECISION_PRORROGA://Decision Prorroga
			title='<s:message code="message" text="**Decision Prorroga" />';
			var label = new Ext.form.Label({
			   	text:'<s:message code="message" text="**Decision prorroga" />'
			});
			var motivoSolicitud=app.creaLabel('<s:message code="" text="**motivo  prorroga" />','MOTIVO');
			var fechaPropuesta=app.creaLabel('<s:message code="" text="**Nueva Fecha propuesta" />','28/08/2008');
			
			var descrTareaOriginal = new Ext.form.TextArea({
				width:250
				,fieldLabel:'<s:message code="comunicaciones.solprorroga.descripcion" text="**Descripcion" />'
				,labelStyle:"font-weight:bolder"
				,value:descTareaPendiente
			});
			var panelDatosProrroga = new Ext.form.FieldSet({
				title:'<s:message code="" text="**Solicitud de prorroga" />'
				,items:app.creaFieldSet([motivoSolicitud,fechaPropuesta,descrTareaOriginal])
				,autoHeight:true
			});
			//combo 
			var labelCombo='<s:message code="" text="**Seleccione el motivo" />';
			var optionsStore = new Ext.data.JsonStore({
		        fields: ['codigo', 'descripcion']
		        ,root: 'diccionario'
		        ,data : optionsAceptarProrroga
		    });
			
			var combo = new Ext.form.ComboBox({
				store:optionsStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,triggerAction: 'all'
				,labelStyle:'font-weight:bolder'
				,fieldLabel : labelCombo
			});
			var decision = new Ext.form.Checkbox({
				fieldLabel:'¿Acepta Prorroga?'
				,labelStyle:'font-weight:bolder'
			});
			items=[{
				anchor:'100%'
				,items:label
			},{
				anchor:'100%'
				,items:panelDatosEntidad
			},{
				anchor:'100%'
				,items:panelDatosProrroga
			},{
				anchor:'100%'
				,items:app.creaFieldSet([combo])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([descripcion])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([decision])
			},{
				anchor:'100%'
				,items:buttonPanel
			}];
			break;
		case tareas.CONSULTA://Consulta
			title='<s:message code="comunicaciones.consulta.titulo" text="**Consulta Comunicación" />';
			label = new Ext.form.Label({
			    	text:'<s:message code="comunicaciones.generarnotificacion.descripcion" text="**Breve descripcion" />'
			});
			labeltareaOriginal=new Ext.form.TextArea({
				fieldLabel:'<s:message code="comunicaciones.generarnotificacion.preguntaorigen" text="**Pregunta Origen" />'
				,labelStyle:'font-weight:bolder'
				,width:250
				,readOnly:true
				,disabled:true				
				,value:descTareaPendiente
			});
			var labelRespuesta=new Ext.form.TextArea({
				fieldLabel:'<s:message code="comunicaciones.generarnotificacion.respuesta" text="**Respuesta" />'
				,labelStyle:'font-weight:bolder'
				,width:250
				,readOnly:true
				,disabled:true				
				,value:'respuesta'
			});
			items=[{
				anchor:'100%'
				,style: 'margin-top:5;margin-bottom:5'
				,items:label
			},{
				anchor:'100%'
				,items:panelDatosEntidad
			},{
				anchor:'100%'
				,items:app.creaFieldSet([labeltareaOriginal])
			},{
				anchor:'100%'
				,items:app.creaFieldSet([labelRespuesta])
			},{
				anchor:'100%'
				,items:buttonPanel
			}];
			break;
	}
	var contenido2 = new Ext.Panel({
		bodyStyle : 'padding:5px'
		,bodyBorder:false
		,layout:'anchor'
		,autoHeight:true
		,autoWidth:true
		,defaults:{
			border:false
		}
		,items : items
	});	
	var win = creaBaseWin(
		title
		,contenido2
	);
	win.show();
	
}