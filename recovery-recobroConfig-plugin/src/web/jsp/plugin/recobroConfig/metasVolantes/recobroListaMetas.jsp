<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>


<fwk:page>

	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfsforms:textfield name="nombre" labelKey="plugin.recobroConfig.itinerario.columna.nombre" 
		label="**Nombre" value="${itinerario.nombre}" readOnly="true" />
		
	<pfsforms:textfield name="fechaAlta" labelKey="plugin.recobroConfig.itinerario.columna.fechaAlta" 
		label="**Fecha de Alta" value="${fechaAltaFormateada}" readOnly="true" width="300"/>
	
	<pfsforms:textfield name="plazoMaxGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoMaxGestion" 
		label="**Plazo máximo gestion" value="${itinerario.plazoMaxGestion}" readOnly="true" width="300"/>
	
	<pfsforms:textfield name="plazoSinGestion" labelKey="plugin.recobroConfig.itinerario.columna.plazoGestionSin" 
		label="**Plazo sin gestión" value="${itinerario.plazoSinGestion}" readOnly="true"/>	
		
	<pfsforms:textfield name="estado" labelKey="plugin.recobroConfig.itinerario.columna.estado" 
		label="**Estado" value="${itinerario.estado.descripcion}" readOnly="true" />	
		
	<pfsforms:textfield name="propietario" labelKey="plugin.recobroConfig.itinerario.columna.propietario" 
		label="**Propietario" value="${itinerario.propietario.username}" readOnly="true" />		

	<pfsforms:textfield name="porcentajeCobroParcial" labelKey="plugin.recobroConfig.itinerario.columna.porcentajeCobroParcial" 
		label="**Porcentaje cobro parcial" value="${itinerario.porcentajeCobroParcial}" readOnly="true"/>	
			
	<pfs:defineParameters name="parametros" paramId="${itinerario.id}" />
	

	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'recobroitinerario/openItinerarioRecobro'
					,{id:${itinerario.id}}
					,{id:'recobroItinerario'+${itinerario.id}}
				)
	};
	
	<pfs:buttonedit flow="recobroitinerario/editaItinerarioRecobro" name="btEditar" 
		windowTitleKey="plugin.itinerarios.consulta.modificar" parameters="parametros" windowTitle="**Modificar"
		on_success="recargar"/>
		
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarRecobroListaMetas'
		,handler : function(){
    			var parms = {};
    			parms.id = ${itinerario.id};
    			page.webflow({
					flow: 'recobroitinerario/liberarItinerarioMetasVolantes'
					,params: parms
					,success : function(){ 
						recargar();
					}
				});
		}
	});		
	
	<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btEditar, btLiberar" tbar="">
		<pfs:items items="estado, nombre, fechaAlta, propietario" width="300" />
		<pfs:items items="porcentajeCobroParcial, plazoMaxGestion, plazoSinGestion" width="600"/>
	</pfs:panel>
	
	<pfs:defineRecordType name="MetasItiRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="orden"/>
		<pfs:defineTextColumn name="codigo"/>
		<pfs:defineTextColumn name="descripcion"/>
		<pfs:defineTextColumn name="diasDesdeEntrega"/>
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="metasDS"
			dataFlow="recobroitinerario/getMetasItinerario"
			resultRootVar="metas" 
			recordType="MetasItiRT" 
			autoload="true"
			parameters="parametros"
			/>

	<pfs:defineColumnModel name="metasItinerarioCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.metasVolantes.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
			<pfs:defineHeader dataIndex="orden"
			captionKey="plugin.recobroConfig.metasVolantes.orden" caption="**Orden"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigo"
			captionKey="plugin.recobroConfig.metasVolantes.codigo" caption="**Código"
			sortable="true" />
		<pfs:defineHeader dataIndex="descripcion"
			captionKey="plugin.recobroConfig.metasVolantes.descripcion" caption="**Descripción"
			sortable="true" />
		<pfs:defineHeader dataIndex="diasDesdeEntrega"
			captionKey="plugin.recobroConfig.metasVolantes.diasEntrega" caption="**Días desde entrega"
			sortable="true" />	
		</pfs:defineColumnModel>
	
	<pfs:buttonedit name="btModificarMetas" 
			flow="plugin/recobroConfig/metasVolantes/modificarMetasItinerarioRecobro" 
			parameters="parametros" 
			windowTitle="**Variables de Gestión de la cartera" 
			windowTitleKey="plugin.recobroConfig.metasVolantes.varialesGestion"
			store_ref="metasDS"
	/>
	
	btModificarMetas.id='btModificarMetasRecobroListaMetas';
	
	<pfs:grid name="gridMetasItinerario" 
		dataStore="metasDS"  
		columnModel="metasItinerarioCM" 
		titleKey="plugin.recobroConfig.metasVolantes.titulo" 
		title="**Metas del itinerario" 
		collapsible="false" 
		bbar="btModificarMetas"
		 />
		
	if ( '${itinerario.estado.codigo}'==ESTADO_DEFINICION.getValue() && '${itinerario.propietario.id}' == usuarioLogado.getValue()){
		btLiberar.setDisabled(false);
	} else {
		btLiberar.setDisabled(true);
	}
	
	if ('${itinerario.estado.codigo}'==ESTADO_BLOQUEADO.getValue() || '${itinerario.propietario.id}' != usuarioLogado.getValue()){
		btEditar.setDisabled(true);
		btModificarMetas.setDisabled(true);
	} else {
		btEditar.setDisabled(false);
		btModificarMetas.setDisabled(false);
	}
	
	var compuesto = new Ext.Panel({
	    items : [{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[gridMetasItinerario],border:false,style:'margin-top: 7px; margin-left:5px'}]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
    
	page.add(compuesto);
	
	
</fwk:page>