<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	
	var codTipoContratoBien = '${codTipoContratoBien}';
	


	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarBien" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function() {
			 
			 Ext.getCmp('tipoRelacionDescripcion').setValue(tipoContratoBien.lastSelectionText);
			 Ext.getCmp('codigoTipoRelacion').setValue(tipoContratoBien.getValue());
			 
			
			 page.fireEvent(app.event.DONE);
		 
	   }
		
		
			
	});	
	
	var tipoContratoBien = app.creaCombo({
			data : <app:dict value="${DDContratoBien}" />
			<app:test id="codTipoContratoBien" addComa="true" />
			,name : 'tipoContratoBien'
			,valueField: 'codigo'
			,displayField: 'descripcion'
			,fieldLabel : '<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionContrato.tipoContratoBien" text="**tipoContratoBien" />'
			,value : codTipoContratoBien
			,labelStyle:labelStyle
			,width: 250
			
		});	
	
	var panelCompleto = new Ext.Panel({
		bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
	    ,items : [
            
			  {
				layout:'form'
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,items : [tipoContratoBien]	
				}
			
    	]
	    ,autoWidth: 800
		,autoHeight: true
	    ,border: false
	    ,bbar : [btnGuardar,btnCancelar]
    });
    
    
    
	page.add(panelCompleto);
	
</fwk:page>
