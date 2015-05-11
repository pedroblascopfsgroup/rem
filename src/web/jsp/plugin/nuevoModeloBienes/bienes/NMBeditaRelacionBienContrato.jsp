<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	

	<pfs:hidden name="idBien" value="${idBien}"/>
	<pfs:hidden name="idContrato" value="${idContrato}"/>


	
	var contrato = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionContrato.contrato" text="**contrato" />','${idContrato}',{labelStyle:'width:130px'});
	

		
	var validarForm = function() {
		//if(NMBparticipacion.getValue() == null || NMBparticipacion.getValue()== '' ){
			//return false;
		//} 
		return true;
	}
		
	
	var getParametros = function() {
	 	var p = {};
	 	p.NMBBien='${idBien}';
	 	p.Contrato='${idContrato}';
	 	return p;
	}
	 
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
			if(validarForm()){
				if(validarPorcentaje()){
					var p = getParametros();
					Ext.Ajax.request({
						url : page.resolveUrl('editbien/saveBienContrato'), 
						params : p,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
				}
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionContrato.camposObligatorios"/>');
			}
	   }
	});
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,layout:'anchor'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 		 { xtype : 'errorList', id:'errL' }
					,{
						autoHeight:true
						,layout:'table'
						,layoutConfig:{columns:1}
						,border:false
						,bodyStyle:'padding:5px;cellspacing:20px;'
						,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
						,items:	[{
									layout:'form'
									,width:500
									,bodyStyle:'padding:5px;cellspacing:10px'
									,items:[contrato]
									,columnWidth:.5
								}]
				}]
		,bbar : [btnCancelar,btnGuardar]
	});

	page.add(panelEdicion);

</fwk:page>
