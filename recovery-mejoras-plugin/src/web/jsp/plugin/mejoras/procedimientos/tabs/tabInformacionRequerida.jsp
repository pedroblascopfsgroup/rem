<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(page,entidad){

	var labelStyle='font-weight:bolder;width:150px';
	var labelStyle2='font-weight:bolder;width:100px';
  
	function label(id,text){
		return app.creaLabel(text,"",  {id:'entidad-procedimiento-'+id, labelStyle:labelStyle2});
	}
	
	function fieldset(title, items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:760
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{ columns:2 }
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:380}
			,items : items
		});
	}

	var  txtImporteAPagar = label('importeAPagar', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.imppagar" text="**importeAPagar"/>');
	var  txtImporteVencido = label('importeVencido', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.impvencido" text="**importeVencido"/>');
	var  txtImporteInteresesMoratorios = label('importeIntMoratorios', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.impintmoratorios" text="**importeInteresesMoratorios"/>');
	var  txtComisiones = label('comisiones', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.comisiones" text="**comisiones"/>');
	var  txtQuita = label('quita', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.quita" text="**quita"/>');
	var  txtImporteNoVencido = label('importeNoVencido', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.impnovencido" text="**importeNoVencido"/>');
	var  txtImporteInteresesOrdinarios = label('importeIntOrdinarios', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.impintordinarios" text="**impInteresesOrdinarios"/>');
	var  txtGastos = label('gastos', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.gastos" text="**gastos"/>');

	//PANEL DATOS DETALLE SOLUCION
	var panelDatosDetalleSolucion = fieldset('<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.datosdetallesolucion" text="**datosDetallePorSolucion"/>',
		 [{items:[txtImporteAPagar,txtImporteVencido,txtImporteInteresesMoratorios,txtComisiones]},
                  {items:[txtQuita,txtImporteNoVencido,txtImporteInteresesOrdinarios,txtGastos]}]);
	
	var  fechaPBCYFT = label('fPBCYFT', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fresolucionPBCYFT" text="**fechaResolucionPBCYFT"/>');
	var  conflictoInt = label('conflictoInt', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.conflictoint" text="**conflictoDeInteres"/>');
	var  riesgoReputacion = label('riesgoReputacion', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.riesgorep" text="**riesgoReputacional"/>');
	var  resolPBCYFT = label('resolPBCYFT', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.resolPBCYFT" text="**resolucionPBCYFT"/>');
	var  resolConflictoInt = label('resolConflitoInt', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.resolconflictoint" text="**resolucionConflictoIntereses"/>');
	var  resolRiesgoRep = label('resolRiesgoRep', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.resolriesgorep" text="**resolucionRiesgoReputacion"/>');
	
	//PANEL DATOS CUMPLIMIENTO NORMATIVO
	var panelDatosCumplimientoNormativo = fieldset('<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.datoscumplimientonormativo" text="**datosCumplimientoNormativo"/>',
		 [{items:[fechaPBCYFT,conflictoInt,riesgoReputacion]},
                  {items:[resolPBCYFT,resolConflictoInt,resolRiesgoRep]}]);
	
	
	var  fechaAnalisisInternoBCapitales = label('fAnalisisIntBCap', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fanalisisinternobcapitales" text="**fechaAnalisisInternoBCapitales"/>');
	var  resultadoAnalisisInterno = label('resulAnalisisInt', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.resulanalisisinterno" text="**resultadoAnalisisInterno"/>');
	var  fechaCartaCertificacion = label('fCartaCert', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fcartacert" text="**fechaCartaCertificion"/>');
	var  fechaEnvioSareb = label('fEnvioSareb', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fenvsareb" text="**fechaEnvioSareb"/>');
	var  numeroPropuesta = label('numPropuesta', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.numpropuesta" text="**numeroPropuesta"/>');
	var  fechaRespuestaSareb = label('fRespuestaSareb', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.frespuestasareb" text="**fechaRespuestaSareb"/>');
	var  resolucionSareb = label('resolSareb', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.resolsareb" text="**resolucionSareb"/>');
	var  fechaPrevistaFirmaForm = label('fPrevistaFirmaForm', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fprevistafirmaform" text="**fechaPrevistaFirmaForm"/>');
	var  fechaFirmaForm = label('fFirmaForm', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.ffirmaform" text="**fechaFirmaForm"/>');
	var  notario = label('notario', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.notario" text="**notario"/>');
	var  fechaFormNotaria = label('fFormNotaria', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fformnotaria" text="**fechaFormNotaria"/>');
	var  fechaContabilizacion = label('fContabilizacion', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fcontabilizacion" text="**fechaContabilizacion"/>');
	var  fechaCierreSareb = label('fCierreSareb', '<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.fcierresareb" text="**fechaCierreSareb"/>');
	
	//PANEL DATOS FORMALIZACION
	var panelDatosFormalizacion = fieldset('<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.datosformalizacion" text="**datosFormalizacion"/>',
		 [{items:[fechaAnalisisInternoBCapitales,resultadoAnalisisInterno,fechaCartaCertificacion,fechaEnvioSareb,numeroPropuesta,fechaRespuestaSareb,resolucionSareb]},
                  {items:[fechaPrevistaFirmaForm,fechaFirmaForm,notario,fechaFormNotaria,fechaContabilizacion,fechaCierreSareb]}]);
	
	//PANEL PRINCIPAL
	var panel=new Ext.Panel({
		title:'<s:message code="plugin.mejoras.procedimiento.tabinformacionrequerida.titulo" text="**Información Requerida"/>'
		,autoScroll:true
		,width:775
		,autoHeight:true
		//,autoWidth : true
		,layout:'table'
		,bodyStyle:'padding:5px;margin:5px'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
		,items:[panelDatosDetalleSolucion,panelDatosCumplimientoNormativo,panelDatosFormalizacion]
		,nombreTab : 'tabInformacionRequerida'
		,bbar:new Ext.Toolbar()
	});

	panel.getValue = function(){
	}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		var d = data.acuerdo;
	}
	
return panel;
})