<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createDecisionProcedimientoTab=function(){
	
	var decisiones = {decisiones :[
		{origen:'234324', tipo:'Ordinario',principal:'4.000',demandados:'4',procnuevo:'123456987',tiponuevo:'Monitorio',principalnuevo:'2.000',demandadosnuevo:'1'}
		,{procnuevo:'123456988',tiponuevo:'Subasata',principalnuevo:'1.000',demandadosnuevo:'2'}
		,{origen:'234324', tipo:'Ordinario',principal:'4.000',demandados:'4',procnuevo:'123456989',tiponuevo:'Monitorio',principalnuevo:'2.000',demandadosnuevo:'1'}
		,{procnuevo:'123456990',tiponuevo:'Embargo',principalnuevo:'500',demandadosnuevo:'1'}
		,{procnuevo:'123456991',tiponuevo:'Subasta',principalnuevo:'500',demandadosnuevo:'1'}
	]};
	var decisionesPropuestas = {decisionesPropuestas :[
		{origen:'234324', tipo:'Ordinario',principal:'4.000',demandados:'4',procnuevo:'123456987',tiponuevo:'Monitorio',principalnuevo:'2.000',demandadosnuevo:'1'}
		,{procnuevo:'123456988',tiponuevo:'Subasata',principalnuevo:'1.000',demandadosnuevo:'2'}
	]};
	
	var decisionesStore = new Ext.data.JsonStore({
		data : decisiones
		,root : 'decisiones'
		,fields : ['origen', 'tipo','principal','demandados','procnuevo','tiponuevo','principalnuevo','demandadosnuevo']
	});
	
	var decisionesCm=new Ext.grid.ColumnModel([
    	{header : '<s:message code="decisionprocedimiento.origen" text="**Procedimiento Origen"/>',dataIndex:'origen'}
    	,{header : '<s:message code="" text="**Principal"/>',dataIndex:'principal',align:'right'}
    	,{header : '<s:message code="" text="**Nro. Demandados"/>',dataIndex:'demandados',align:'right'}
    	,{header : '<s:message code="" text="**Procedimiento Nuevo"/>',dataIndex:'procnuevo' }
    	,{header : '<s:message code="" text="**Tipo"/>',dataIndex:'tiponuevo'}
    	,{header : '<s:message code="" text="**Principal"/>',dataIndex:'principalnuevo',align:'right'}
    	,{header : '<s:message code="" text="**Nro. Demandados"/>',dataIndex:'demandadosnuevo' ,align:'right'}
    ]);
	var decisionesPropuestasStore = new Ext.data.JsonStore({
		data : decisionesPropuestas
		,root : 'decisionesPropuestas'
		,fields : ['origen', 'tipo','principal','demandados','procnuevo','tiponuevo','principalnuevo','demandadosnuevo']
	});		
	var decisionesTomadasGrid=app.crearGrid(decisionesStore,decisionesCm,{
		title:'<s:message code="" text="**Decisiones ya tomadas para el procedimiento"/>'
		,style:'padding-right:10px;padding-bottom:10px'
		,height:150
	});
	var btnAceptarDecision=new Ext.Button({
	       text:  '<s:message code="" text="**Aceptar Decisión" />'
		   ,iconCls:'icon_ok'
	});
	var btnRechazarDecision=new Ext.Button({
		text:'<s:message code="" text="**Rechazar Decisión" />'
		,iconCls:'icon_asunto_rechazar'
	});
	var decisionesPropuestasGrid=app.crearGrid(decisionesPropuestasStore,decisionesCm,{
		title:'<s:message code="" text="**Decisiones propuestas para el procedimiento"/>'
		,style:'padding-right:10px'
		,height:150
		,bbar:[btnAceptarDecision,btnRechazarDecision]
	});
	var btnAgregar=new Ext.Button({
           text:  '<s:message code="" text="**Realizar Propuesta de derivacion" />'
           ,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
           ,handler:function(){
			var w = app.openWindow({
				flow : 'fase2/decision'
				,width : 900
				,title : '<s:message code="" text="**Decision" />' 
				//,params : config.params || {}
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			w.on(
				app.event.CANCEL, function(){ 
				w.close(); 
			});
			
           }
	});
	
	var panel = new Ext.Panel({
		title:'<s:message code="" text="**Decision"/>'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,items:[decisionesTomadasGrid,decisionesPropuestasGrid]
		,tbar:btnAgregar
	});
	
	return panel;
};
