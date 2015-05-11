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
	
	<pfs:hidden name="codEstado" value="${simulacion.estado.codigo}"/>
	
	<pfsforms:textfield name="estado" labelKey="plugin.recobroConfig.esquemaAgencia.simulacion.estado" 
		label="**Estado" value="${simulacion.estado.descripcion}" readOnly="true" />
		
	<pfsforms:textfield name="fechaPeticion" labelKey="plugin.recobroConfig.esquemaAgencia.simulacion.fechaPeticion" 
		label="**Fecha Peticion" value="${fechaPeticionFormat}" readOnly="true" />
	
	<pfsforms:textfield name="fechaResultado" labelKey="plugin.recobroConfig.esquemaAgencia.simulacion.fechaResultado" 
		label="**Fecha Resultado" value="${fechaResultadoFormat}" readOnly="true" />
		
	<pfsforms:textfield name="horaPeticion" labelKey="plugin.recobroConfig.esquemaAgencia.simulacion.horaPeticion" 
		label="**Hora Petición" value="${horaPeticionFormat}" readOnly="true"/>
	
	<pfsforms:textfield name="horaResultado" labelKey="plugin.recobroConfig.esquemaAgencia.simulacion.horaResultado"
		label="**Hora Resultado" value="${horaResultadoFormat}" readOnly="true" />
		
	estado.id ='txtEstadoSimulacion';
	fechaPeticion.id ='txtFechaPeticionSimulacion';
	fechaResultado.id = 'txtFechaResultadoSimulacion';
	horaPeticion.id = 'txtHoraPeticionSimulacion';
	horaResultado.id = 'txtHoraResultadoSimulacion';
	
	var datos = new Ext.form.FieldSet({
		style:'padding:0px'
 		,border:true
		,layout : 'table'
		,layoutConfig:{
			columns:2
		}
		,autoWidth:true
		,title:'<s:message code="plugin.recobroConfig.esquemaAgencia.simulacion.datos" text="**Datos generales"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
		,items :[{items:[estado,fechaPeticion,horaPeticion]} ,{items : [fechaResultado,horaResultado]} ]
	});
	
	
	var btnDescargarResumen= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.esquemaAgencia.simulacion.descargarResumen" text="**Descargar resumen" />'
		,iconCls : 'icon_download'
		,id: 'btnDescargarResumenSimulacion'
		,disabled: ${simulacion.fichResumen == null}
		,handler : function(){
			var params = {idEsquema : ${idEsquema},
						  tipoFichero : 'RES'};		
			var flow = '/pfs/recobroesquema/descargarFichero';
			app.openBrowserWindow(flow,params);
		}
	});
	
	var btnDescargarDetalle= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.esquemaAgencia.simulacion.descargarDetalle" text="**Descargar detalle" />'
		,iconCls : 'icon_download'
		,id:'btnDescargarDetalleSimulacion'
		,disabled: ${simulacion.fichDetalle == null}
		,handler : function(){
			var params = {idEsquema : ${idEsquema},
						  tipoFichero : 'DET'};		
			var flow = '/pfs/recobroesquema/descargarFichero';
			app.openBrowserWindow(flow,params);
		}
	});
	
	var panel = new Ext.Panel({
		height:700
		,autoWidth:true
		,bodyStyle:'padding: 10px'
		,items:[datos				
			]
		,bbar: [btnDescargarResumen,
				btnDescargarDetalle]
	});
				
	page.add(panel);
			
	
</fwk:page>	