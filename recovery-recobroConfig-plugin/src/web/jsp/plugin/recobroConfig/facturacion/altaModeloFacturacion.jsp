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
	
	<pfs:textfield name="nombre" labelKey="plugin.recobroConfig.modeloFacturacion.nombre"
		label="**Nombre" value="${modelo.nombre}" obligatory="true" />
		
	nombre.maxLength=250;	

	<pfs:textfield name="descripcion" labelKey="plugin.recobroConfig.modeloFacturacion.descripcion"
		label="**Descripcion" value="${modelo.descripcion}"  />
	
	descripcion.maxLength=250;	
		
	var validarForm= function(){
		if (nombre.getActiveError()!=''){
			return nombre.getActiveError();
		}
		if (descripcion.getActiveError()!=''){
			return descripcion.getActiveError();
		}
		return '';
	};	
	
	var btnGuardarValidacion = new Ext.Button({
		text : '<s:message code="pfs.tags.editform.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler :  function(){
			if (validarForm()==''){
    			var parms = {};
    			parms.id='${modelo.id}';
    			parms.idModFact='${modelo.id}'
    			parms.nombre=nombre.getValue();
    			parms.descripcion=descripcion.getValue();
    			
 				Ext.Ajax.request({
					url : page.resolveUrl('recobromodelofacturacion/guardaModeloFacturacion'), 
					params : parms,
					method: 'POST',
					success: function ( result, request ) {
					
						var r = Ext.util.JSON.decode(result.responseText);
						var param = {idModFact:r.modelo.id};
						app.closeTab({id:'modeloFacturacion'+r.modelo.id});
						page.fireEvent(app.event.DONE);
						app.openTab(r.modelo.nombre
							,'recobromodelofacturacion/openLauncher'
							,param
							,{id:'modeloFacturacion'+r.modelo.id ,iconCls : 'icon_facturacion'});
						page.fireEvent(app.event.DONE);
					}
				});

			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>'
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
				,layoutConfig:{columns:1}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype : 'fieldset',autoWidth : true, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
				,items:[{items: [nombre,descripcion]}]
			}
		]
		,bbar : [
			btnGuardarValidacion, btnCancelar
		]
	});		
	<%--
	btnGuardarValidacion.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_METAS">
		btnGuardarValidacion.show();
	</sec:authorize>	
	--%>
	page.add(panelEdicion);

</fwk:page>