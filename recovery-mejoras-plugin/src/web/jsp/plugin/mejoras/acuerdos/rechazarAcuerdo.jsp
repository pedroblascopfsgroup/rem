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
	
	var idAcuerdo='${acuerdo.id}';
	<pfsforms:ddCombo name="motivoRechazo"
		labelKey="mejoras.plugin.acuerdos.motivoRechazo" 
 		label="**Motivo rechazo" value="" dd="${motivosRechazo}" 
		propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true"/>
	
	var observaciones = new Ext.form.HtmlEditor({
		id:'observaciones'
		,name:'observaciones'
		,fieldLabel:'<s:message code="mejoras.plugin.acuerdos.rechazar.observacion" text="**Observaciones" />'
		,readOnly:false
		,width: 400
		,height: 150
		,enableColors: true
       	,enableAlignments: true
       	,enableFont:true
       	,enableFontSize:true
       	,enableFormat:true
       	,enableLinks:true
       	,enableLists:true
       	,enableSourceEdit:true		
		,html:''});	

	var bottomBar = [];

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){	
				if(validarForm()){
					if("${esPropuesta}" == "true"){
						Ext.Ajax.request({
							url : page.resolveUrl('propuestas/rechazar'), 
							params : {idPropuesta:idAcuerdo,idMotivo:motivoRechazo.value,observaciones:observaciones.getValue()},
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
						});
					}else{
						Ext.Ajax.request({
							url : page.resolveUrl('mejacuerdo/rechazarAcuerdoMotivo'), 
							params : {idAcuerdo:idAcuerdo,idMotivo:motivoRechazo.value,observaciones:observaciones.getValue()},
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
						});
					}
				}else{
					Ext.Msg.alert('<s:message code="mejoras.plugin.acuerdos.rechazar.validacion.error" text="**Error" />'
					,'<s:message code="mejoras.plugin.acuerdos.rechazar.validacion.motivorechazo.obligatorio" text="**El campo motivo de rechazo es obligatorio" />');
				}

		}
	});
	
	var validarForm= function(){
		if (motivoRechazo.getValue()==''){
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
		,items : [motivoRechazo,observaciones]
		,bbar:bottomBar
	});
	
	page.add(panelEdicion);

</fwk:page>