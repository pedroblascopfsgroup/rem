<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	<c:set var="TIP_REASIGNAR_ACTIVABLE" scope="session" value="${1003}"/>

	<c:if test="${data.emisor != null}">
		var emisor='${data.emisor}';
		//textfield que va a contener el emisor
		var txtEmisor = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.emisor" text="**Emisor" />',emisor);
	</c:if>
	<c:if test="${data.nombreAsunto != null}">
		var nombreAsunto='${data.nombreAsunto}';
		var txtNombreAsunto = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.nombreAsunto" text="**Nombre asunto" />',nombreAsunto);
	</c:if>

	<c:if test="${data.nombreDeudor != null}">
		var nombreDeudor='${data.nombreDeudor}';
		var txtNombreDeudor = app.creaLabel('<s:message code="plugin.ugas.asunto.tabcabecera.nombreDeudor" text="**Nombre Deudor" />',nombreDeudor);
	</c:if>

        var fecha_vencimiento='${data.fechaVencimiento}';
        
        <c:if test="${data.fechaVencimiento != null}">
		//textfield que va a contener la fecha vencimiento
		var txtFechaVencimiento = app.creaLabel('<s:message code="ext.comunicaciones.generarnotificacion.fechaVencimiento" text="**Fecha vencimiento" />',fecha_vencimiento);
	</c:if>
	var heightOriginal = 182;
	var heightExpandido = 182;
	var altoOriginalDos = 70;
	var altoExpandidoDos = 160;
	<c:if test="${data.tieneResponder == true}">
		var labeltareaRespuesta = new Ext.form.HtmlEditor({
			id:'htmlRespuesta'
			,fieldLabel : 'Texto de respuesta'
			,hideLabel:true
			,width:790
			,maxLength:3500
			,height : altoOriginalDos
			<c:if test="${data.respuesta != null}">
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
        	,value:'<s:message text="${data.respuesta}" javaScriptEscape="true" />'
			</c:if>
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
			
	var tituloLabelArchivoAdjunto = new Ext.form.Label({
	    	text:'<s:message code="ext.comunicaciones.generarnotificacion.ficheroAdjunto" text="**Fichero Adjunto" />'
			,style:'font-weight:bolder; font-size:11; margin-right:15px',bodyStyle:'padding:5px'
			});
			
	
	var labeltareaOriginal = new Ext.form.HtmlEditor({
			id:'htmlDescripcion'
			,readOnly:true
			,hideLabel:true
			,width:790
			,maxLength:3500
			<c:if test="${data.tieneResponder == true}">
			,height : altoOriginalDos
			</c:if>
			<c:if test="${data.tieneResponder == false}">
			,height : heightOriginal
			</c:if>
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
		name:'leida'
		,handler:function(){
			changeUpdate();
		}
		,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.leida" text="**Leida" />'			
	});	

        
	var submitLeido = function(){
            <c:if test="${data.fechaVencimiento != null}">
            if(labeltareaRespuesta.getValue() == null || labeltareaRespuesta.getValue() ==''){
                     Ext.MessageBox.show({
                       title: 'Aviso',
                       msg: 'Debe escribir una respuesta',
                       width:300,
                       buttons: Ext.MessageBox.OK

               });
            }else{	
            Ext.Ajax.request({
                    url: page.resolveUrl('recoveryagendamultifuncionanotacion/responderTarea')
                    ,params: {idTarea: idTarea.getValue(), respuesta:labeltareaRespuesta.getValue(), idUg:idEntidad.getValue(), leida:false, codUg:'${data.codUg}'}

                    ,success: function(){ page.fireEvent(app.event.DONE) }
            });
            }
            </c:if>
            <c:if test="${data.fechaVencimiento == null}">
            Ext.Ajax.request({
                    url: page.resolveUrl('recoveryagendamultifuncionanotacion/marcarTareaLeida')
                    ,params: {idTarea: idTarea.getValue(),leida:chkLeida.getValue()}

                    ,success: function(){ page.fireEvent(app.event.DONE) }
            });
            </c:if>
        }
	
	var submitNoLeido = function(){
            Ext.Ajax.request({
                    url: page.resolveUrl('recoveryagendamultifuncionanotacion/marcarTareaLeida')
                    ,params: {idTarea: idTarea.getValue(),leida:chkLeida.getValue()}

                    ,success: function(){ page.fireEvent(app.event.CANCEL) }
            });
	}
	
	var changeUpdate = function(){
        
            if (fecha_vencimiento == null || fecha_vencimiento == ''){
                if (chkLeida.getValue()){
                        btnGuardar.setHandler(submitLeido);
                }else{
                        btnGuardar.setHandler(submitNoLeido);
                }
            }else{
                btnGuardar.setHandler(submitLeido);
            }

        }
	
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
	
	var btnEntidad = new Ext.Button({
		text : '<s:message code="app.botones.verdetalle" text="**Ver detalle" />'
		,handler : function(){
			page.fireEvent(app.event.OPEN_ENTITY);
		}
	});
	
	var cfg ={
			layout:'table'
			,layoutConfig:{columns:2}
			,title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
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
					
					<c:if test="${data.tieneResponder == true}">
						labeltareaOriginal.setHeight(altoOriginalDos);
						labeltareaRespuesta.setHeight(altoOriginalDos);
					</c:if>
					<c:if test="${data.tieneResponder == false}">
						labeltareaOriginal.setHeight(heightOriginal);
					</c:if>
					
              }
              ,beforeCollapse:function(){
              		<c:if test="${data.tieneResponder == true}">
						labeltareaOriginal.setHeight(altoExpandidoDos);
						labeltareaRespuesta.setHeight(altoExpandidoDos);
					</c:if>
					<c:if test="${data.tieneResponder == false}">
						labeltareaOriginal.setHeight(heightExpandido*2);
					</c:if>
						
              }
             }
          }
    cfg.items = [{columnWidth:0.5,items:[txtEntidad]}
    			<c:if test="${data.nombreAsunto != null}">
    			,{ columnWidth:1,items:[txtNombreAsunto]}	
    			</c:if>
				
				<c:if test="${data.nombreDeudor != null}">
				,{columnWidth:1,items:[txtNombreDeudor]}
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
				<c:if test="${data.codUg != null}"> 
				,{columnWidth:1,items:[btnEntidad]}
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
				,idEntidad
				<c:if test="${data.tieneResponder == true}">,txtRespuesta,labeltareaRespuesta</c:if>
				<c:if test="${data.fechaVencimiento == null}">,chkLeida</c:if>
				<c:if test="${data.idArchivoAdjunto != null}">
					,tituloLabelArchivoAdjunto
					,{
					    xtype: 'component',
					    autoEl: {
					        tag: 'a',
					        href: '/pfs/procuradores/descargarAdjunto.htm?idResolucion=${data.idResolucion}',
					        html: '${data.nombreAdjunto}'
					    }
					}
				</c:if>
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
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
                    if (fecha_vencimiento == null || fecha_vencimiento == ''){
                        if (chkLeida.getValue()){
                                submitLeido;
                        }else{
                                submitNoLeido;
                        }
                    }else{
                        submitLeido;
                    }
                }
		<app:test id="btnGuardarABM" addComa="true"/>
	});
	
	<c:if test="${data.idTipoResolucion != null && data.idTipoResolucion == TIP_REASIGNAR_ACTIVABLE}">
		var btnReasignar=new Ext.Button({
			text:'<s:message code="app.botones.reasignar" text="**Reasignar" />'
			,iconCls:'icon_limpiar'
			,handler:function(){
					var titulo = "Reasignar categoria";
					var w = app.openWindow({
					  flow : 'categorias/abreVentanaReasignarCategoriasTarea'
					  //,width:320
					  ,autoWidth:true
					  ,closable:true
					  ,title : titulo
					  ,params:{idResolucion:'${data.idResolucion}'}
					
					});
					w.on(app.event.DONE, function(){      
					  w.close();
					  app.recargaResolucionesTree();
					});
					w.on(app.event.CANCEL, function(){
					  w.close();
					});
			}
		});
	</c:if>
	
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
			btnGuardar
			<c:if test="${data.idTipoResolucion != null && data.idTipoResolucion == TIP_REASIGNAR_ACTIVABLE}">
				,btnReasignar
			</c:if>
			,btnCancelar
		]
	});
	page.add(panelEdicion);

	Ext.onReady(function(){
                changeUpdate();
       	});
	
</fwk:page>	