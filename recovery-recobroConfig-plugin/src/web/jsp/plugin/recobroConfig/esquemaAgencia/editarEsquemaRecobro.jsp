<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
		
	if (${esVersionDelEsquemaliberado}){
		<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.fichaEsquema.nombre" 
		label="**Nombre" value="${esquema.nombre}" obligatory="true" readOnly="true"/>
	} else {
		<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.fichaEsquema.nombre" 
		label="**Nombre" value="${esquema.nombre}" obligatory="true" />
	}	
	
	nombre.maxLength=200;
	
	<pfs:textfield name="descripcion" labelKey="plugin.recobroConfig.fichaEsquema.descripcion" 
		label="**Descripción" value="${esquema.descripcion}" obligatory="true"/>
		
	descripcion.maxLength=250;		
	
<%--	<pfsforms:ddCombo name="estado"
		labelKey="plugin.recobroConfig.fichaEsquema.estado" label="**Estado"
		value="" dd="${ddEstadosEsquema}" propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true"/>
		
	estado.setValue(${esquema.estadoEsquema.id}); --%>
	
	<pfs:numberfield name="plazo" labelKey="plugin.recobroConfig.fichaEsquema.plazoActivacion" 
		label="**Plazo de días para activación" value="${esquema.plazo}" obligatory="true" allowNegative="false" allowDecimals="false"/>
		
	plazo.maxLength=9;	
		
	<pfsforms:ddCombo name="modeloTransicion"
		labelKey="plugin.recobroConfig.fichaEsquema.modeloTransicion" label="**Modelo de Transición"
		value="" dd="${ddModeloTransicion}" propertyCodigo="id" propertyDescripcion="descripcion" obligatory="true" />
		
	modeloTransicion.setValue(${esquema.modeloTransicion.id});	
	
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return nombre.getActiveError();
		}
		if (descripcion.getActiveError()!=''){
			return descripcion.getActiveError();
		}
		if (plazo.getActiveError()!=''){
			return plazo.getActiveError();
		}
<%--	if ( estado.getValue()== '' || modeloTransicion.getValue()== ''){
			return "Este campo es obligatorio";
		} --%>
		return '';
	};
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.id='${esquema.id}';
    			parms.nombre=nombre.getValue();
    			parms.descripcion=descripcion.getValue();
    			<%--parms.estado=estado.getValue();--%>
    			parms.plazoActivacion=plazo.getValue();
    			parms.modeloTransicion=modeloTransicion.getValue();
    			page.webflow({
						flow: 'recobroesquema/guardarRecobroEsquema'
						,params: parms
						,success : function(){ 
							page.fireEvent(app.event.DONE); 
						}
					});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.agencia.alta.error" text="**Error" />'
				,validarForm());
			}
		}
	});		
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="pfs.tags.editform.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});
	
	var panelEdicion = new Ext.Panel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{   autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [nombre, descripcion<%--, estado--%>]}
						,{items: [plazo, modeloTransicion]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});			
	
	page.add(panelEdicion);			
	
</fwk:page>	