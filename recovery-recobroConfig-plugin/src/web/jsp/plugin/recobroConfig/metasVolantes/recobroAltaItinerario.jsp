<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.itinerario.nombre"
		label="**Nombre" value="${itinerario.nombre}" obligatory="true" />
		
	nombre.maxLength=50;	

	<pfs:numberfield name="plazoMaxGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoMaxGestion"
		label="**Plazo máximo de gestión" value="${itinerario.plazoMaxGestion}" obligatory="true" />
		
	plazoMaxGestion.maxLength=8;		
	
	<pfs:numberfield name="plazoSinGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoGestionSin" 
		label="**Plazo sin gestión" value="${itinerario.plazoSinGestion}" obligatory="true" />

	plazoSinGestion.maxLength=8;		

	<pfs:numberfield name="porcentajeCobroParcial" labelKey="plugin.recobroConfig.itinerario.columna.porcentajeCobroParcial" 
		label="**Porcentaje cobro parcial" value="${itinerario.porcentajeCobroParcial}" obligatory="true" />
	
	porcentajeCobroParcial.maxLength=8;
	porcentajeCobroParcial.maxValue=100;

				
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.errorNombre" text="**El campo Nombre es obligatorio" />';
		}
		if ( plazoMaxGestion.getActiveError()!=''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.errorPlazoMaxGestion" text="**El campo Plazo máximo gestión es obligatorio" />';
		}
		if ( plazoSinGestion.getActiveError()!= ''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.errorPlazoSinGestion" text="**El campo Plazo sin gestión es obligatorio" />';
		}
		if ( porcentajeCobroParcial.getActiveError()!= ''){
			return '<s:message code="plugin.recobroConfig.agencia.alta.errorPorcentajeCobroParcial" text="**El campo Porcentaje cobro parcial es obligatorio" />';
		}
		return '';
	};	
	
	var nombreTab = nombre.getValue();
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.id='${itinerario.id}';
    			parms.nombre=nombre.getValue();
    			parms.plazoMaxGestion=plazoMaxGestion.getValue();
    			parms.plazoSinGestion=plazoSinGestion.getValue();
 				parms.porcentajeCobroParcial=porcentajeCobroParcial.getValue();
 				Ext.Ajax.request({
					url : page.resolveUrl('recobroitinerario/guardaItinerarioRecobro'), 
					params : parms,
					method: 'POST',
					success: function ( result, request ) {
						var r = Ext.util.JSON.decode(result.responseText);
						var param = {id:r.itinerario.id, nombre:r.itinerario.nombre};
						app.closeTab({id:'recobroItinerario'+r.itinerario.id});
						page.fireEvent(app.event.DONE);
						app.openTab('Itinerario '+r.itinerario.nombre
							,'recobroitinerario/openItinerarioRecobro'
							,param
							,{id:'recobroItinerario'+r.itinerario.id ,iconCls:'icon_metas'});
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
				,items:[{items: [nombre,porcentajeCobroParcial]},{items: [plazoMaxGestion,plazoSinGestion]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_METAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	
	page.add(panelEdicion);

</fwk:page>