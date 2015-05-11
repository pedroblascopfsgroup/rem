<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	//var labelStyleDescripcion = 'width:185x;height:60px;font-weight:bolder",width:700';
	var labelStyleTextArea = 'font-weight:bolder",width:500';

	
	<%-- REVISION DE CARGAS --%>

	var fechaRevision =new Ext.ux.form.XDateField({
			fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.fechaRevision" text="**fechaRevision" />'
			,labelStyle: labelStyle
			,name:'bien.fechaRevision'
			,value:	'<fwk:date value="${NMBbien.adicional.fechaRevision}"/>'
			,style:'margin:0px'		
	});

	var sinCargas = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.sinCargas" text="**Sin Cargas"/>'
		,name:'sinCargas'
		,labelStyle:labelStyle
		,disabled: false
	});
	
	if('${NMBbien.adicional.sinCargas}' == 'true'){
		sinCargas.checked = true;
	}
	else{
		sinCargas.checked = false;
	}
	

	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.observaciones" text="**Observaciones" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.observaciones}" />'
		,name:'observaciones'
		,hideLabel: true
		,width:745
		,height: 150
		,readOnly: false
	});
	
	var getParametros = function() {
		
	 	var parametros = {};
	 	parametros.id='${NMBbien.id}';
		 
		parametros.fechaRevision = fechaRevision.getValue() ? fechaRevision.getValue().format('d/m/Y') : '';
		parametros.sinCargas = sinCargas.getValue();
	    parametros.observaciones = observaciones.getValue();
	 	
	 	return parametros;
	 }
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		var btnEditar = new Ext.Button({
		    text: '<s:message code="app.guardar" text="**Guardar" />'
			<app:test id="btnEditarSolvencia" addComa="true" />
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		    	var p = getParametros();
		    	Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveRevisionCargas'), 
						params : p ,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
	        }
		});
	</sec:authorize>
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
		
	var panelRevision = new Ext.form.FieldSet({
		autoHeight:true
		,width:770
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.revisionCargas.titulo" text="**Revision de cargas"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
	    ,items : [{items:[fechaRevision,sinCargas,observaciones]}]
	});
	
	//Panel propiamente dicho...
	var panel=new Ext.Panel({
		autoScroll:true
		,width:775
		,autoHeight:true
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items : [panelRevision]
		,nombreTab : 'editRevisionCargas'
		,bbar:new Ext.Toolbar()
	});
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		panel.getBottomToolbar().addButton([btnEditar]);
	</sec:authorize>
	
	panel.getBottomToolbar().addButton([btnCancelar]);
		
	page.add(panel);
	
</fwk:page>