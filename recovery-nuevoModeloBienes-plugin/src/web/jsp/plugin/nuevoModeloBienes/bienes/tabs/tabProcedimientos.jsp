<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	
	var labelStyle = 'width:185px;font-weight:bolder",width:375';
	var labelStyleAjusteColumnas = 'width:185px;height:40px;font-weight:bolder",width:375';
	var labelStyleTextArea = 'font-weight:bolder",width:500';
	
	
	<%-- Procedimientos del bien --%>
	
	var procedimientosRecord = Ext.data.Record.create([
	{name:'id'}
	,{name:'idPrc'}
	,{name:'descPrc'}
    ,{name:'tipoProcedimiento'}
	,{name:'idBien'}
    ,{name:'solvenciaGarantia'}
    ,{name:'asuntoId'}
	,{name:'asuntoNombre'}	
	,{name:'juzgado'}
	,{name:'plazaJuzgado'}
	,{name:'principal'}
	,{name:'fechaInicio'}
	,{name:'despacho'}
    ]);

   	var procedimientosStore = page.getStore({
   		flow:'editbien/getProcedimientos'
       	,reader: new Ext.data.JsonReader({
        	root: 'procedimientos'
       	}, procedimientosRecord)
   	});
    
   procedimientosStore.webflow({idBien:${NMBbien.id}});    
   
 	var procedimientosCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.id" text="**id"/>',width:52, sortable: true, dataIndex: 'idPrc', hidden: true}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.tipoProcedimiento" text="**tipoProcedimiento"/>',width:52, sortable: true, dataIndex: 'tipoProcedimiento', hidden: false}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.idBien" text="**idBien"/>',width:52, sortable: true, dataIndex: 'idBien', hidden: true}
         ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.solvenciaGarantia" text="**solvenciaGarantia"/>',width:52, sortable: true, dataIndex: 'solvenciaGarantia', hidden: true}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.asuntoNombre" text="**asuntoNombre"/>',width:52, sortable: true, dataIndex: 'asuntoNombre', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.juzgado" text="**juzgado"/>',width:52, sortable: true, dataIndex: 'juzgado', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.plazaJuzgado" text="**plazaJuzgado"/>',width:52, sortable: true, dataIndex: 'plazaJuzgado', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.principal" text="**principal"/>',width:52, sortable: true, dataIndex: 'principal', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.fechaInicio" text="**fechaInicio"/>',width:52, sortable: true, dataIndex: 'fechaInicio', hidden: false}
    	 ,{header: '<s:message code="plugin.nuevoModeloBienes.procedimientos.despacho" text="**despacho"/>',width:52, sortable: true, dataIndex: 'despacho', hidden: false}
    ]);
    
    var procedimientosGrid = app.crearGrid(procedimientosStore, procedimientosCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabProcedimientos.procedimientosGrid.titulo" text="**Procedimientos del bien"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_contratos'
        ,height : 220 
		
    });
    
    procedimientosGrid.on('rowclick', function(grid, rowIndex, e) {
   		var rec = grid.getStore().getAt(rowIndex);
		var idProc = rec.get('idPrc');
		var descProc = rec.get('descPrc');
		app.abreProcedimientoTab(idProc,descProc);
	});


	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabProcedimientos.procedimientos.titulo" text="**Procedimientos"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [procedimientosGrid]
		,nombreTab : 'tabProcedimientosBien'
	});
	
	return panel;
})()