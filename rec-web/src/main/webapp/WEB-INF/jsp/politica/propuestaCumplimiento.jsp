<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>
	
	var labelStyle = 'font-weight:bolder;width:100px';
	
	 var resumenObjetivo = new Ext.form.TextArea({
		fieldLabel: '<s:message code="objetivo.propuestaCumplimiento.resumenObjetivo" text="**Resumen del objetivo" />'
		,value:'<s:message text="${objetivo.resumen}" javaScriptEscape="true" />'
		,labelStyle: labelStyle
		,style:'font-weight:bolder;margin-bottom:10px;'
		,width: 570
		,height: 100
		,maxLength: 250
		,labelStyle: labelStyle
		,readOnly: true
	});
	
	var propuestaCumplimiento = new Ext.form.TextArea({
		fieldLabel: '<s:message code="objetivo.propuestaCumplimiento.propuestaCumplimiento" text="**Propuesta cumplimiento" />'
		,labelStyle: labelStyle
		,style:'font-weight:bolder;margin-bottom:10px;'
		,width: 570
		,height: 100
		,maxLength: 250
		,labelStyle: labelStyle
        ,name:'propuesta'
        ,value:'${objetivo.propuestaCumplimiento}'
	});

    var btnGuardarAceptar = new Ext.Button({
            text: '<s:message code="app.guardar" text="**Guardar" />'
            ,iconCls: 'icon_ok'
            ,handler: function() {
                var params = { idObjetivo:${idObjetivo}};
                page.submit({
                    eventName: 'update'
                    ,formPanel: mainPanel
                    ,success: function() { page.fireEvent(app.event.DONE) }
                    ,params: params
                  });
            }
        });

    var btnCancelar = new Ext.Button({
        text: '<s:message code="app.cancelar" text="**Cancelar" />'
        ,iconCls: 'icon_cancel'
        ,handler: function(){
            page.fireEvent(app.event.CANCEL);
          }
    });

    <c:if test="${aceptarTarea}">
        var respuestaCumplimiento = new Ext.form.TextArea({
            fieldLabel: '<s:message code="objetivo.propuestaCumplimiento.respuestaCumplimiento" text="**Respuesta cumplimiento" />'
            ,labelStyle: labelStyle
            ,style:'font-weight:bolder;margin-bottom:10px;'
            ,width: 570
            ,height: 100
            ,maxLength: 250
            ,labelStyle: labelStyle
            ,name:'respuesta'
        });    

        var chkBoxAceptar = new Ext.form.Checkbox({
            fieldLabel:'<s:message code="objetivo.propuestaCumplimiento.aceptar.cumplimiento" text="**Aceptar el cumplimiento" />'
            ,labelStyle: labelStyle
            ,name:'aceptada'
            ,handler:function(){
                changeUpdate();
            }
        });  
    
        var submitAcepto = function(){
            var params = { idObjetivo:${idObjetivo}};
            page.submit({
                    eventName : 'aceptar'
                    ,formPanel : mainPanel
                    ,success : function(){ page.fireEvent(app.event.DONE) }
                    ,params: params
                });
        }
        
        var submitNoAcepto = function(){
            var params = { idObjetivo:${idObjetivo}};
            page.submit({
                    eventName : 'rechazar'
                    ,formPanel : mainPanel
                    ,success : function(){ page.fireEvent(app.event.DONE) }
                    ,params: params
                });
        }
        
        var changeUpdate = function(){
            if (chkBoxAceptar.getValue()){
                    btnGuardarAceptar.setHandler(submitAcepto);
                }else{
                    btnGuardarAceptar.setHandler(submitNoAcepto);
                }
        }
        btnGuardarAceptar.setHandler(submitNoAcepto);
    </c:if>

	var mainPanel = new Ext.form.FormPanel({
		autoHeight: true
		,autoWidth: true
		,bodyStyle: 'padding:10px'
		,border: false
		,items: [
			 {
				border : false
				,layout : 'column'
				,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : [
					{ items : [resumenObjetivo , propuestaCumplimiento  <c:if test="${aceptarTarea}">,respuestaCumplimiento,chkBoxAceptar</c:if>] }
				]
			}
		]
		,bbar: [btnGuardarAceptar ,btnCancelar	]
	});

	page.add(mainPanel);

</fwk:page>