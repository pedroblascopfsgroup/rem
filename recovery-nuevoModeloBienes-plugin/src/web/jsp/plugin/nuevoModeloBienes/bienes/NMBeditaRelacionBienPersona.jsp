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
	
	<pfs:hidden name="porce" value="${porce}"/>
	<pfs:hidden name="tPorce" value="${tPorce}"/>
	<pfs:hidden name="idBien" value="${idBien}"/>
	<pfs:hidden name="idPersona" value="${idPersona}"/>
	<pfs:hidden name="nomPersona" value="${nomPersona}"/>

	
	var cliente = app.creaLabel('<s:message code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.cliente" text="**Cliente" />','${nomPersona}',{labelStyle:'width:130px'});
	
	var NMBparticipacion = app.creaInteger(
		'bien.participacion'
		, '<s:message code="plugin.mejoras.bienesNMB.participacion" text="**Participacion" />' + ' (' + tPorce.getValue() + ')' 
		, '${porce}'
		, {	autoCreate : {
				tag: "input"
				, type: "text",maxLength:"3"
				, autocomplete: "off"				
		 	}
			, maxLength:3
			, maxengthText:'<s:message code="error.maxdigitos" text="**El valor no puede tener más de 3 dígitos" arguments="3" />'
			, labelStyle:'width:130px'
			, allowBlank: false			
		}
	);
		
	var validarForm = function() {
		if(NMBparticipacion.getValue() == null || NMBparticipacion.getValue()== '' ){
			return false;
		} 
		return true;
	}
	
	var validarPorcentaje = function() {
		if (eval(NMBparticipacion.getValue()) + eval(tPorce.getValue()-porce.getValue()) > 100) {
			return false;
		}
		return true;
	}
	
	
	var getParametros = function() {
	 	var p = {};
	 	p.NMBparticipacion=NMBparticipacion.getValue();
	 	p.NMBBien='${idBien}';
	 	p.persona='${idPersona}';
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
						url : page.resolveUrl('editbien/saveParticipacionBien'), 
						params : p,
						method: 'POST',
						success: function ( result, request ) {
							page.fireEvent(app.event.DONE);
						}
					});
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**La suma de los porcentaje excede el 100%." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.porcentajeExcedido"/>');
				}
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos obligatorios." code="plugin.nuevoModeloBienes.fichaBien.nuevaRelacionPersona.camposObligatorios"/>');
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
									,items:[cliente, NMBparticipacion]
									,columnWidth:.5
								}]
				}]
		,bbar : [btnCancelar,btnGuardar]
	});

	page.add(panelEdicion);

</fwk:page>
