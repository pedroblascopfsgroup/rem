<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
	
	//DATOS REGISTRALES GRID de contratos
	
	var bienEmbargos = Ext.data.Record.create([
		 {name:'idEmbargo'}
		,{name:'idBien'}
		,{name:'idProcedimiento'}
		,{name:'actuacion'}
		,{name:'numProcJuz'}
		,{name:'despacho'}
		,{name:'estadoActuacion'}
		,{name:"fechaSolicitud"}
		,{name:"fechaDecreto"}
		,{name:"fechaRegistro"}
		,{name:"fechaAdjudicacion"}
		,{name:"nbProcedimiento"}
		,{name:"fechaDenegacion"}
    ]);

   	var bienEmbargosStore = page.getStore({
   		flow:'plugin/nuevoModeloBienes/bienes/NMBBienEmbargos'
       	,reader: new Ext.data.JsonReader({
        	root: 'embargosBien'
       	}, bienEmbargos)
   	});
    
   	bienEmbargosStore.webflow({idBien:${NMBbien.id}});    
 
 	var BienEmbargosCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idEmbargo" text="**idEmbargo"/>',width:52, sortable: true, dataIndex: 'idEmbargo', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien', hidden: true}
		,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.nbProcedimiento" text="**Nombre procedimiento"/>', sortable: true, dataIndex: 'nbProcedimiento', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idProcedimiento" text="**idProcedimiento"/>', sortable: true, dataIndex: 'idProcedimiento', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.actuacion" text="**actuacion"/>', sortable: true, dataIndex: 'actuacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.estadoActuacion" text="**estadoActuacion"/>', sortable: true, dataIndex: 'estadoActuacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.despacho" text="**despacho"/>', sortable: true, dataIndex: 'despacho'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.numProcJuz" text="**numProcJuz"/>', sortable: true, dataIndex: 'numProcJuz'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.fechaSolicitud" text="**fechaSolicitud"/>', sortable: true, dataIndex: 'fechaSolicitud', align:'right'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.fechaDecreto" text="**fechaDecreto"/>', sortable: true, dataIndex: 'fechaDecreto'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.fechaRegistro" text="**fechaRegistro"/>', sortable: true, dataIndex: 'fechaRegistro'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.fechaAdjudicacion" text="**fechaAdjudicacion"/>', sortable: true, dataIndex: 'fechaAdjudicacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.fechaDenegacion" text="**fechaDenegacion"/>', sortable: true, dataIndex: 'fechaDenegacion'}
    ]);
 
    var gridEmbargos = app.crearGrid(bienEmbargosStore, BienEmbargosCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.gridEmbargos.titulo" text="**Embargos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_procedimiento'
        ,height : 452
    });

	gridEmbargos.on('rowdblclick',function(grid, rowIndex, e){
		var rec = gridEmbargos.getStore().getAt(rowIndex);
    	if(rec.get('idProcedimiento')){
    		var id = rec.get('idProcedimiento');
			var nb = rec.get('nbProcedimiento');
    		app.abreProcedimiento(id, nb);
	  	}
	});
	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabEmbargos.titulo" text="**Anotación de Embargos"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [gridEmbargos]
		,nombreTab : 'tabRelacionesBien'
	});
	
	return panel;
})()