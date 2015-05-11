<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

var createAcuerdosTab=function(){
	
	
    var acuerdos = {acuerdos:[	
    	{procedimiento:'1',tipoprocedimiento:'Hipotecario',solicitante: 'Pepito', tipopago : 'Total',tipoacuerdo:'Dación en pago',periodicidad:'Único',importepago:'100.000',periodopago:'-',estado:'Propuesto',observaciones:'bla bla bla'}
    	,{procedimiento:'2',tipoprocedimiento:'Subasta',solicitante: 'Juanito', tipopago : 'Parcial',tipoacuerdo:'Efectivo',periodicidad:'Periódico',importepago:'10.000',periodopago:'60 dias',estado:'Aceptado',observaciones:'bla bla bla'}
    	,{procedimiento:'2',tipoprocedimiento:'Monitorio',solicitante: 'Pedrito', tipopago : 'Total',tipoacuerdo:'Refinanciación',periodicidad:'Periódico',importepago:'1.000',periodopago:'30 dias',estado:'Aceptado',observaciones:'bla bla bla'}
    	]};
    var acuerdosStore = new Ext.data.JsonStore({
    	data : acuerdos
    	,root : 'acuerdos'
    	,fields : ['procedimiento','tipoprocedimiento','solicitante', 'tipopago','tipoacuerdo','periodicidad','importepago','periodopago','estado','observaciones']
    });
    var acuerdosCm = new Ext.grid.ColumnModel([
    	{header : '<s:message code="acuerdos.procedimiento" text="**Procedimiento"/>', dataIndex : 'procedimiento' }
    	,{header : '<s:message code="acuerdos.tipoprocedimiento" text="**Tipo Procedimiento"/>', dataIndex : 'tipoprocedimiento' }
    	,{header : '<s:message code="acuerdos.solicitante" text="**Solicitante"/>', dataIndex : 'solicitante' }
    	,{header : '<s:message code="acuerdos.tipopago" text="**Tipo Pago"/>', dataIndex : 'tipopago' }
    	,{header : '<s:message code="acuerdos.tipoacuerdo" text="**Tipo Acuerdo"/>', dataIndex : 'tipoacuerdo' }
    	,{header : '<s:message code="acuerdos.periodicidad" text="**Periodicidad"/>', dataIndex : 'periodicidad' }
    	,{header : '<s:message code="acuerdos.importepago" text="**Importe Pago"/>', dataIndex : 'importepago' }
    	,{header : '<s:message code="acuerdos.periodopago" text="**Periodo Pago"/>', dataIndex : 'periodopago' }
    	,{header : '<s:message code="acuerdos.estado" text="**Estado"/>', dataIndex : 'estado' }
    	,{header : '<s:message code="acuerdos.observaciones" text="**Observaciones"/>', dataIndex : 'observaciones' }
    ]);
    var btnNuevoAcuerdo = app.crearBotonAgregar({
    	text:'<s:message code="app.agregar" text="**Agregar" />'
		,flow : 'fase2/acuerdos'
		,width:850
		,title : '<s:message code="acuerdos.alta" text="**Alta Acuerdo" />' 
		//,params:
		//,success:
    });
    
    var btnEditarAcuerdo= app.crearBotonEditar({
        text:'<s:message code="app.editar" text="**Editar" />'
		,flow : 'fase2/acuerdos'
		,width:850
		,title : '<s:message code="acuerdos.edicion" text="**Editar Acuerdo" />' 
		//,params : 
		//,success:
	});
    var acuerdosGrid = app.crearGrid(acuerdosStore,acuerdosCm,{
   		title:'<s:message code="acuerdos.grid.title" text="**acuerdos ya existentes en el procedimiento" />'
    	,height : 200
    	,style:'padding-right:10px'
    	,bbar:[btnNuevoAcuerdo,btnEditarAcuerdo]
    });
    var panel = new Ext.Panel({
    	autoHeight : true
    	,title:'<s:message code="" text="**Acuerdos" />'
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : acuerdosGrid
    });
    return panel;

}