<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

		var labelStyle='font-weight:bolder;';

		var importeUmbralField = new Ext.form.NumberField({
			fieldLabel:'<s:message code="clientes.umbral.importe" text="**Importe" />'
			,allowNegative:false
			,allowDecimals:true
			,value: <c:if test="${persona.importeUmbral==null}">0</c:if><c:if test="${persona.importeUmbral!=null}">'${persona.importeUmbral}'</c:if>
			,name:'persona.importeUmbral'
			,labelStyle:labelStyle
		});

		var fechaUmbralField = new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="clientes.umbral.fecha" text="**Fecha" />'
			,value:'<fwk:date value="${persona.fechaUmbral}" />'
			,name:'persona.fechaUmbral'
			,minValue:new Date()
			,style:'margin:0px'
			,labelStyle:labelStyle
		});
		var tituloobservaciones = new Ext.form.Label({
				   	text:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
					,style:'font-weight:bolder; font-size:11'  
					}); 
		var observaciones = new Ext.form.TextArea({
				fieldLabel:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
				,value:'${persona.comentarioUmbral}'
				,name:'persona.comentarioUmbral'
				,hideLabel: true
				,width:580
				,height: 200
				,maxLength: 1024
				,labelStyle:labelStyle
		});
	
		var btnGuardar = new Ext.Button({
			text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
			,handler : function(){
				page.submit({
					eventName : 'update'
					,formPanel : panelEdicion
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			}
		});
	
		var btnCancelar = new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls:'icon_cancel'
			,handler : function(){
				page.fireEvent(app.event.CANCEL);
			}
		});

		var panelEdicion = new Ext.form.FormPanel({
			autoHeight : true
			//,autoWidth:true
			,bodyStyle : 'padding:10px'
			,border : false
			,items : [
			
				 { xtype : 'errorList', id:'errL' }
				,{ 
					border : false
					,layout:'table'
					,layoutConfig:{columns:2}
					,autoHeight : true 
					,defaults:{xtype:'fieldset', border:false}
					,items : [ 
						{ items : importeUmbralField }
						,{ items : fechaUmbralField }
						,{items:tituloobservaciones,colspan:2}
						,{items:observaciones,colspan:2}
						
						
					]
										
				}
			]
			,bbar : [ btnGuardar,btnCancelar ]
		});

		page.add(panelEdicion);

		<c:if test="${expedienteTitular!=null}">
			Ext.Msg.show({
			   title: fwk.constant.alert
			   ,msg: '<s:message code="cliente.umbral.editar.mensajeExpediente"
			             text="**El cliente seleccionado es titular de un contrato que generó el expediente {0}, código {1}, y no se verá afectado por el umbral"
			             argumentSeparator=";"
			             arguments="${expedienteTitular.descripcionExpediente};${expedienteTitular.id}" />'
			   ,buttons: Ext.Msg.OK
			   ,animEl: 'elId'
			   ,icon: Ext.MessageBox.WARNING
			});
		</c:if>

</fwk:page>
