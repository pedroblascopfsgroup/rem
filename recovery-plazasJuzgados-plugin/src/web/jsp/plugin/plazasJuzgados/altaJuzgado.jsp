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

	<pfsforms:textfield name="descripcion"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcion" label="**Descripción"
			value="${juzgado.descripcion}" obligatory="true" width="350"/>
	
	<pfsforms:textfield name="descripcionLarga"
			labelKey="plugin.plazasJuzgados.altaPlaza.descripcionLarga" label="**Descripción larga"
			value="${juzgado.descripcionLarga}" width="350" />
			
	<pfsforms:check name="existePlaza" labelKey="plugin.plazasJuzgados.altaPlaza.existe" 
		label="**Existe Plaza"  value="true"/>
		
	
	var codPlaza = '';
	
	var decenaInicio = 0;
	var dsplazas = new Ext.data.Store({
		autoLoad: false,
		baseParams: {limit:10, start:0},
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/plazosExterna/plugin.plazasJuzgados.plazasPorDescripcion')
		}),
		reader: new Ext.data.JsonReader({
			root: 'plazas'
			,totalProperty: 'total'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	
	var idTipoPlaza = new Ext.form.ComboBox ({
		store:  dsplazas,
		allowBlank: true,
		blankElementText: '--',
		disabled: false,
		displayField: 'descripcion', 	// descripcion
		valueField: 'codigo', 		// codigo
		hiddenName:'${plazo.tipoPlaza.codigo}',
		fieldLabel: '<s:message code="plugin.plazasJuagados.alta.plazas" text="**Plaza de Juzgado" />',		// Pla de juzgado
		loadingText: 'Searching...',
		width: 350,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});	
	
	
	<c:if test="${juzgado!=null}">
		codPlaza='${juzgado.plaza.codigo}';
	</c:if>	
	
		
	Ext.onReady(function() {
		decenaInicio = 0;
		if (codPlaza!=''){
			Ext.Ajax.request({
					url: page.resolveUrl('plugin/plazasJuzgados/plugin.plazasJuzgados.plazasPorCod')
					,params: {codigo: codPlaza}
					,method: 'POST'
					,success: function (result, request){
						var r = Ext.util.JSON.decode(result.responseText)
						decenaInicio = (r.paginaParaPlaza);
						dsplazas.baseParams.start = decenaInicio;	
						idTipoPlaza.store.reload();
						dsplazas.on('load', function(){  
							idTipoPlaza.setValue(codPlaza);
							dsplazas.events['load'].clearListeners();
						});
					}				
			});
		}
	});
	
	
	idTipoPlaza.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	
	<pfsforms:fieldset caption="**Nuevo Juzgado" name="nuevoJuzgado" 
		captioneKey="plugin.plazasJuzgados.busqueda.altaJuzgado" 
		items="descripcion,descripcionLarga,existePlaza,idTipoPlaza" width="500"/>
	
	<pfsforms:textfield name="descripcionPlaza" label="**Descripción de la Plaza" 
		labelKey="plugin.plazasJuagados.alta.descripcionPlaza" value="" width="350"/>
		
	<pfsforms:textfield name="descripcionLargaPlaza" label="**Descripción larga de la Plaza" 
		labelKey="plugin.plazasJuagados.alta.descripcionLargaPlaza" value="" width="350"/>
	
	<pfsforms:fieldset caption="**Nueva plaza" name="nuevaPlaza" 
		captioneKey="plugin.plazasJuzgados.busqueda.altaPlaza"  
		items="descripcionPlaza,descripcionLargaPlaza" width="500"/>
		
	
	nuevaPlaza.setDisabled(true);
	
	existePlaza.on('check',function(){
		if (existePlaza.getValue() == true){
			idTipoPlaza.setDisabled(false);
			nuevaPlaza.setDisabled(true)
			
		}else{
			idTipoPlaza.setDisabled(true);
			nuevaPlaza.setDisabled(false)
			
		}
	});	
	
	
	<pfs:defineParameters name="getParametros" paramId="${juzgado.id}" 
		 descripcion="descripcion"
		 descripcionLarga="descripcionLarga"
		 plaza="idTipoPlaza" 
		 existePlaza="existePlaza"
		 descripcionPlaza="descripcionPlaza"
		 descripcionLargaPlaza="descripcionLargaPlaza"
		 />
	
	<c:if test="${juzgado==null}">	
	<pfs:editForm saveOrUpdateFlow="plugin/plazasJuzgados/plugin.plazasJuzgados.guardaJuzgado"
		leftColumFields="nuevoJuzgado,nuevaPlaza"
		parameters="getParametros" />
	</c:if>
	<c:if test="${juzgado!=null}">	
	<pfs:editForm saveOrUpdateFlow="plugin/plazasJuzgados/plugin.plazasJuzgados.guardaJuzgado"
		leftColumFields="descripcion, descripcionLarga"
		parameters="getParametros" />
	</c:if>

</fwk:page>	