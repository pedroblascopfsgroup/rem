<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>

	<pfs:textfield name="nombre" labelKey="plugin.politicaAcuerdo.alta.nombre"
		label="**Nombre" value="${politica.nombre}" obligatory="true" readOnly="true"/>

	<pfs:textfield name="codigo" labelKey="plugin.politicaAcuerdo.alta.codigo"
		label="**Código" value="${politica.codigo}" obligatory="true" readOnly="true"/>
		
	<%-- 
	var recargar = function (){
		app.openTab('${politica.nombre}'
					,"recobropoliticadeacuerdos/abrirPoliticaAcuerdos"
    				,{idPolitica:rec.get('id')}
    				,{id:'Politica'+rec.get('id')
    				,iconCls:'icon_politicas'
				)
	};	
	
	--%>
	var btnEditar = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.politicaAcuerdos.editar" text="**Editar" />'
		<app:test id="btnEditar" addComa="true" />
		,iconCls : 'icon_edit'
		,disabled : false
		,handler :  function(){
		    	var w= app.openWindow({
								flow: 'recobropoliticadeacuerdos/editPoliticaAcuerdos'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.recobroConfig.esquemaAgencia.btnEditar" text="Editar política" />'
								,params: {idPolitica:${politica.id}}
							});
							w.on(app.event.DONE, function(){
								w.close();
							});
							w.on(app.event.CANCEL, function(){
								 w.close(); 
							});
		}
	});	
		
	<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btnEditar" tbar="">
		<pfs:items items="nombre"  />
		<pfs:items items="codigo" />
	</pfs:panel>
	<%-- 
	btEditar.hide();
	<sec:authorize ifAllGranted="ROLE_EDITCOMITE">
		btEditar.show();
	</sec:authorize>
	--%>
	
	<pfs:defineRecordType name="Palancas">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="tipoPalanca" />
			<pfs:defineTextColumn name="subtipoPalanca" />
			<pfs:defineTextColumn name="delegada" />
			<pfs:defineTextColumn name="prioridad" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="palancaCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.palancaPolitica.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="tipoPalanca"
			captionKey="plugin.recobroConfig.palancaPolitica.tipoPalanca" caption="**Tipo Palanca"
			sortable="true" />
		<pfs:defineHeader dataIndex="subtipoPalanca"
			captionKey="plugin.recobroConfig.palancaPolitica.tipoPalanca" caption="**Subtipo Palanca"
			sortable="true" />
		<pfs:defineHeader dataIndex="delegada"
			captionKey="plugin.recobroConfig.palancaPolitica.delegada" caption="**Delegada"
			sortable="true" />			
		<pfs:defineHeader dataIndex="prioridad"
			captionKey="plugin.recobroConfig.palancaPolitica.prioridad" caption="**Prioridad"
			sortable="true" />						
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="palancaStore" 
		resultRootVar="palancas" 
		recordType="Palancas" 
		dataFlow="recobropoliticadeacuerdos/buscaPalancasPolitica" />
		
	
	var cfgPalancas={
		title : '<s:message code="plugin.recobroConfig.palancasPolitica.gridPalanca.title" text="**Palancas asociadas con la política de acuerdos" />'
		,collapsible : true
		,collapsed: false
		,titleCollapse : true
		,stripeRows:true
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_acuerdos'
	};
	var palancasGrid=app.crearGrid(palancaStore,palancaCM,cfgPalancas);
	
	palancaStore.webflow({idPolitica:${politica.id}});
	
	
	var compuesto = new Ext.Panel({
	    items : [
	    		{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[palancasGrid],border:false,style:'margin-top: 7px; margin-left:5px'}
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);

</fwk:page>