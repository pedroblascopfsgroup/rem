<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<fwk:page>
	var width=250;
	var style='text-align:left;font-weight:bolder;width:140';
	
	var validarForm = function() {

		if(comboCausasImpago.getValue() == null || comboCausasImpago.getValue()== '' ){
			return false;
		}
		if(comboTipoAyuda.getValue() == null || comboTipoAyuda.getValue()== '') {
			return false;
		}
		return true;
	}
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if(validarForm()){
				page.submit({
				 eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){page.fireEvent(app.event.DONE) }
			});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="bienesCliente.form.camposIncompletos"/>');
			}
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	
	var codigoAAA = new Ext.form.Hidden({name:'aaa.id', value :'${aaa.id}'}) ;
	
	var comboCausasImpago = app.creaCombo({
		data : <app:dict value="${causasImpago}"/>
		,name : 'aaa.causaImpago'
		,fieldLabel : '<s:message code="expedientes.consulta.tabgestion.causasimpago" text="**Causa Impago" />'
		,labelStyle:style
		,value : '${aaa.causaImpago.codigo}'
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true
        ,width:410
        <app:test id="idComboCausaImpago" addComa="true"/>       
	});
	
	var comboTipoAyuda = app.creaCombo({
		data : <app:dict value="${tiposAyuda}"/>
		//,allowBlank:false
		,name : 'aaa.tipoAyudaActuacion'
		,fieldLabel : '<s:message code="expedientes.consulta.tabgestion.tipoayuda" text="**Tipo Ayuda" />'
		,labelStyle:style
		,value : '${aaa.tipoAyudaActuacion.codigo}'
		,typeAhead: false
        ,mode: 'local'
        ,triggerAction: 'all'
        ,editable: false
        ,selectOnFocus:true 
         <app:test id="idComboTipoAyuda" addComa="true"/>       
        ,width:410
	});
	
	var titulocomentarios = new Ext.form.Label({
   	text:'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
	,style:'font-weight:bolder; font-size:11; margin:10px 10px 10px 10px;'
	}); 
	
	var comentarios=new Ext.form.TextArea({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.comentarios" text="**Comentarios"/>'
		,width:550
		,hideLabel:true
		,labelStyle:style
		,name:'aaa.comentariosSituacion'
		,maxLength: 1024
		,value : '<s:message text="${aaa.comentariosSituacion}" javaScriptEscape="true" />'
		 <app:test id="campoComentario" addComa="true"/> 
	});
	 
	var titulotipoAyuda = new Ext.form.Label({ 
   	text:'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descripcion Ayuda"/>'
	,style:'font-weight:bolder; font-size:11;margin:10px 10px 10px 10px;'
	});
	var tipoAyuda=new Ext.form.TextArea({
		fieldLabel:'<s:message code="expedientes.consulta.tabgestion.descayuda" text="**Descripcion Ayuda"/>'
		,width:550
		,hideLabel:true
		,labelStyle:style
		,maxLength: 1024
		,name:'aaa.descripcionTipoAyudaActuacion'
		, blankText: 'Campo requerido'
		,value : '<s:message text="${aaa.descripcionTipoAyudaActuacion}" javaScriptEscape="true" />'
		<app:test id="campoDescripcion" addComa="true"/> 
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		layout:'form'
		,autoHeight:true
		,width:580
		,bodyStyle : 'padding:10px 10px'
		,cls : 'separaFields'
		,items:[
			{ xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				,viewConfig : { columns : 1 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false ,width:610,height:800}
				,items : [
					{ items : [
						comboTipoAyuda
						,titulotipoAyuda 
						,tipoAyuda
						,comboCausasImpago
						,titulocomentarios
						,comentarios
					], style : 'margin-right:10px' }
				]
			}
		]
		,bbar:[btnGuardar,btnCancelar]
	});	
	page.add(panelEdicion);

</fwk:page>
