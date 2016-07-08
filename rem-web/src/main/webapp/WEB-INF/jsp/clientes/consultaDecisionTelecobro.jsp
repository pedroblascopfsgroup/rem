<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<fwk:page>
	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="" text="**Situacion" />'	,'${cliente.persona.situacion}');
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="" text="**fecha Creacion" />','<fwk:date value="${cliente.fechaCreacion}" />');
	
	var strTipoEntidad="Cliente";
	var btnEntidad = new Ext.Button({
		text : '<s:message code="app.botones.verdetalle" text="**Ver Detalle" />'
		,handler : function(){
			page.fireEvent(app.event.OPEN_ENTITY);
		}
	});	
	//textfield con la causa de la solicitud de exclusion
	var txtEntidad = app.creaLabel('<s:message code="" text="**Causa" />','${solicitud.motivoExclusion.descripcion}');
	
	//textArea con las observaciones
	var obsSolicitud = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.telecobro.observaciones" text="**Observaciones" />'
		,value:'<s:message text="${solicitud.observaciones}" javaScriptEscape="true" />'
		,width:200
		,readOnly:true
	});

	var obsRespuesta= new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.menu.respuesta" text="**Respuesta" />'
		,value:'<s:message text="${solicitud.respuesta}" javaScriptEscape="true" />'
		,width:200
        ,readOnly:true
	});

	var decision = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="clientes.menu.aceptaExclusion" text="**Acepta Exclusion" />'
		,name:'aceptada'
        ,checked:${solicitud.aceptada}
        ,readOnly:true
	});   

    var chkLeida=new Ext.form.Checkbox({
        name:'leida'
        ,fieldLabel:'<s:message code="comunicaciones.generarnotificacion.leida" text="**Leida" />'
        ,handler:function(){
            changeUpdate();
        }
    });

	var items={
		layout:'form'
		,defaults:{xtype:'fieldset',autoHeight:true}
		,items:[{ xtype : 'errorList', id:'errL' }
		,{
			title:'<s:message code="clientes.menu.datosDel" text="**Datos del" />'+" "+ strTipoEntidad
			,items:[txtEntidad,txtSituacion,txtFechaCreacion, btnEntidad]
		},{
			title:'<s:message code="clientes.menu.solicitud" text="**Solicitud" />'
			,items:[txtEntidad,obsSolicitud]
		},{
			title:'<s:message code="clientes.menu.solicitud" text="**Decision" />'
			,items:[obsRespuesta,decision]
		}, {items:chkLeida}
		]
	}

    var btnCancelar= new Ext.Button({
        text : '<s:message code="app.cancelar" text="**Cancelar" />'
        ,iconCls : 'icon_cancel'
        ,handler : function(){
            submitNoLeido();
        }
    });
    var btnAceptar = new Ext.Button({
        text : '<s:message code="app.aceptar" text="**Aceptar" />'
        ,iconCls : 'icon_ok'
        ,handler : function(){
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
                ,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
                ,items : items
            }
        ]
        ,bbar : [
            btnAceptar, btnCancelar
        ]
    }); 
    
    var submitLeido = function(){
        page.submit({
                eventName : 'update'
                ,formPanel : panelEdicion
                ,success : function(){ page.fireEvent(app.event.DONE) }
            });
    }
    
    var submitNoLeido = function(){
        page.submit({
                eventName : 'cancel'
                ,formPanel : panelEdicion
                ,success : function(){ page.fireEvent(app.event.CANCEL) }
            });
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