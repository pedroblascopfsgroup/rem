<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


<fwk:page>	

        var estado = new Ext.form.TextArea({
                 fieldLabel: 'Estado'
                ,height : 60
                ,width : 300
                ,value : '${documento.estado}'
        });
	
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		bodyStyle : 'padding:10px'
		,autoHeight : true
		,items : [{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:3}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[estado,estado, estado]
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[estado, estado, estado]
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[estado, estado]
					}
				]
			}
		]
		,bbar : [btnGuardar, btnCancelar]
	});

	page.add(panelEdicion);
	
</fwk:page>