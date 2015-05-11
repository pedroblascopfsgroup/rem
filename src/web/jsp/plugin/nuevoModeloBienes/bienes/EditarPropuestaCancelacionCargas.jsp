<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<fwk:page>

	<%-- PROPUESTA DE CANCELACION DE CARGAS --%>	

	var resumen = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.resumen" text="**Resumen" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.cancelacionResumen}" />'
		,name:'resumen'
		,width:440
		,height:105
	});

	var propuesta = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.cargas.propuesta" text="**Propuesta" />'
		,value:'<s:message javaScriptEscape="true" text="${NMBbien.adicional.cancelacionPropuesta}" />'
		,name:'propuesta'
		,width:440
		,height:105
	});

	var panelPropuestaCancelacion = new Ext.form.FieldSet({
		autoHeight:true
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabCargas.cargas.propuestaCancelacion.titulo" text="**Propuesta de cancelacion de cargas" />'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop'}
	    ,items : [{items:[resumen, propuesta]}]
	});

	var panel = new Ext.Panel({
		autoScroll:true
		//,width:580
		,autoHeight:true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items : [panelPropuestaCancelacion]
		,nombreTab : 'editPropuestaCancelacionCargas'
		,bbar:new Ext.Toolbar()
	});

	var getParametros = function() {
	 	var parametros = {};

	 	parametros.id='${NMBbien.id}';
		parametros.resumen = resumen.getValue();
	    parametros.propuesta = propuesta.getValue();

	 	return parametros;
	}

	var btnEditar = new Ext.Button({
	    text: '<s:message code="app.guardar" text="**Guardar" />' <app:test id="btnEditar" addComa="true" />
	    ,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,style:'padding-top:0px'
	    ,handler:function(){
	    	var p = getParametros();
	    	Ext.Ajax.request({
				url : page.resolveUrl('editbien/savePropuestaCancelacionCargas'), 
				params : p ,
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
				}
			});
        }
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});

	panel.getBottomToolbar().addButton([btnEditar]);
	panel.getBottomToolbar().addButton([btnCancelar]);
	page.add(panel);

</fwk:page>