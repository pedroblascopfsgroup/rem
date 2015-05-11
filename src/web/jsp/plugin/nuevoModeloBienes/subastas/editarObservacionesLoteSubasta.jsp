<%@page import="es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta"%>
<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>

	var maxWidth = 700;
	var estadoLotesSupendido = 	'<c:out value="${codEstado}"/>' == 'SUSPENDIDA';
	
	var observaciones = app.crearTextArea('<s:message code="subastas.instruccionesLoteSubasta.observacionesComite" text="**Observaciones Comité" />', '', false, null, 'observaciones', {width:'440px'})
	
	var diccionarioRecord = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'codigo'}
		,{name : 'descripcion'}
	]);
	
	var motivoSuspSubastaStore = page.getStore({
		flow : 'editbien/getDiccionario'
		,storeId : 'sinoStore'
		,reader : new Ext.data.JsonReader({
			root : 'diccionario'
		},diccionarioRecord)
	});
	motivoSuspSubastaStore.webflow({diccionario: 'es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDMotivoSuspSubasta' });
	
    //Combo de usuarios
    var cmbMotivoSuspSubasta = new Ext.form.ComboBox({
		store: motivoSuspSubastaStore
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,fieldLabel: '<s:message code="subastas.instruccionesLoteSubasta.riesgoConsignacion" text="**Riesgo Consignación"/>'
		,mode:'local'
		,resizable: false
		,triggerAction : 'all'
		,name : 'cmbMotivoSuspSubasta'
		,value : ''
		,width:400
    });

	var panelInterior = new Ext.FormPanel({	
	    bodyStyle:'margin:10px;'
	    ,autoHeight : true
	    ,autoWidth : false
	    ,width: maxWidth-10
	    ,border: false
	    ,items:[cmbMotivoSuspSubasta,observaciones]
	});
	
	var getParams = function(){
		var parametros = {
			idLotes : []
			,codEstado : '${codEstado}'
			,observaciones: observaciones.getValue()
			,codMotivoSuspSubasta: cmbMotivoSuspSubasta.getValue()
		}
		<c:forEach var="id" items="${idLotes}"> 
		    parametros.idLotes.push(<c:out value="${id}"/>);
		</c:forEach>		
		return parametros;
	};
	
	var validarForm = function() {
		if (estadoLotesSupendido && cmbMotivoSuspSubasta.getValue()=='') {
			return false;
		}
		if (observaciones.getValue()=='') {
			return false;
		}
		return true;
	}
	
	var btnAceptar = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
		   ,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	       		if (validarForm()) {
	      			page.webflow({
		      			flow:'subasta/guardarEstadoLotesSubasta'
		      			,params: getParams()
		      			,success: function(){
	            		   page.fireEvent(app.event.DONE);
	            		}	
		      		});
	      		} else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message text="**Debe completar todos los campos" code="subastas.instruccionesLoteSubasta.editarObservaciones.camposObligatorios"/>');
				}
	     	}
	});
		
	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});

	var panel = new Ext.Panel({	
	    autoHeight : true
	    ,height : 500
	    ,autoWidth : false
	    ,width: maxWidth
	    ,border: false
	    ,items:[panelInterior]
	    ,bbar : [btnAceptar, btnCancelar]	    
	});
	
	if (!estadoLotesSupendido) {
		cmbMotivoSuspSubasta.hide();
	}
	
	page.add(panel);

</fwk:page>
