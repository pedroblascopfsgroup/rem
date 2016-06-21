<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<fwk:page>
	
	var idAcuerdo='${idAcuerdo}';
	<pfsforms:ddCombo name="despachoProponente"
		labelKey="mejoras.plugin.acuerdos.despachoProponente" 
 		label="**Despacho proponente" value="" dd="${listadoDespachos}" 
		propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true"/>

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){	
				if(validarForm()){
			      	    page.webflow({
			      			flow:"plugin/mejoras/acuerdos/plugin.mejoras.acuerdos.proponerAcuerdo"
			      			,params:{
			      				idAcuerdo:idAcuerdo, idDespacho:despachoProponente.value
			   				}
			      			,success: function(){
								page.fireEvent(app.event.DONE);
			           		}
			           		,error: function(){

							}	
				      	});
				}else{
					Ext.Msg.alert('<s:message code="mejoras.plugin.acuerdos.rechazar.validacion.error" text="**Error" />'
					,'<s:message code="mejoras.plugin.acuerdos.proponer.despacho.obligatorio" text="**Debe indicar el tipo de rol con el que propone el acuerdo" />');
				}

		}
	});
	
	var validarForm= function(){
		if (despachoProponente.getValue()==''){
			return false;
		}else{
			return true;
		}
	};	
	

	
	var btnCancelar = new Ext.Button({
       text:  '<s:message code="app.cancelar" text="**Cancelar" />'
       ,iconCls : 'icon_cancel'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){
      		page.fireEvent(app.event.CANCEL);
     	}
    });
	
	bottomBar.push(btnGuardar);
	bottomBar.push(btnCancelar);
	
	var panelEdicion=new Ext.form.FormPanel({
		autoHeight:true
		,width:700
		,bodyStyle:'padding:10px;cellspacing:20px'
		,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
		,items : [despachoProponente]
		,bbar:bottomBar
	});
	
	page.add(panelEdicion);

</fwk:page>