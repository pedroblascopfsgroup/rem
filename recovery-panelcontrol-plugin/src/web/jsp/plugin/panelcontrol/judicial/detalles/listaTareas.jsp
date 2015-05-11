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
var thousandSeparator = function add_thousands_separator(input) {
								var s = input.toString(), l = s.length, o = '';
								while (l > 3) {
									var c = s.substr(l - 3, 3);
									o = '.' + c + o;
									s = s.replace(c, '');
									l -= 3;
								}
								o = s + o;
								return o;
							}
	 var millonSeparator = function(num){
								if (num==null){
									num=0;
								}
								if (num=="---"){
									return "";
								}
								if (isNaN(num)) {
									return '##ERROR: CAMPO NO NUMERICO##'
								}
								num = num.toString().replace(/\$|\,/g,'');
								//sign = (num == (num = Math.abs(num)));
								num = Math.floor(num*100+0.50000000001);
								num = Math.floor(num/100).toString();
								
								if(num.length <= 6){
									for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) {
										num = num.substring(0,num.length-(4*i+3))+ app.format.THOUSANDS_SEPARATOR 
											+ num.substring(num.length-(4*i+3));
									}
								}
								else{
									var mi = num.substring(0,num.length - 6);
									var resto = num.substring(num.length - 6);
									
									
									num = mi +','+resto.substring(0,2) +' MM';
								}
									
									
								return (num+' '+ app.EURO);
							
							};
	
	var tareaRecord = Ext.data.Record.create([
        {name:'id'}
        ,{name:'tarea'}
        ,{name:'unidadGestion'}
        ,{name:'descripcion'}
        ,{name:'gestion'}
        ,{name:'fechaInicio',type:'date', dateFormat:'d/m/Y'}
        ,{name:'fechaVencimiento',type:'date', dateFormat:'d/m/Y'}
        ,{name:'fechaVencimientoOriginal',type:'date', dateFormat:'d/m/Y'}
        ,{name:'tipoSolicitud'}
        ,{name:'diasVencida'}
        ,{name:'gestor'}
        ,{name:'supervisor'}
        ,{name:'vre'}
        ,{name:'vreVencidos'}
        ,{name:'fechaRevisionTarea',type:'date', dateFormat:'d/m/Y'}
        
    ]);
	
	 
	 var tareaStore = page.getStore({
		id:'tareaStore'
		,eventName:'listado'
		,limit:25
		,remoteSort : true
		,storeId : 'tareaStore'
		,flow : 'plugin.panelControl.tareasPendientesData'
		,reader : new Ext.data.JsonReader({root:'tarea',totalProperty : 'total'}, tareaRecord)
	});
	 
	var tareaCm = new Ext.grid.ColumnModel([
			{dataIndex: 'id', hidden:true, fixed:true },
            {header: '<s:message code="plugin.panelControl.tareas.tarea" text="**Tarea" />',   	dataIndex: 'tarea'},
            {header: '<s:message code="plugin.panelControl.tareas.unidadGestion" text="**Unidad gestión" />',   	dataIndex: 'unidadGestion', hidden:true},
            {header: '<s:message code="plugin.panelControl.tareas.descripcion" text="**Descripción" />',   	dataIndex: 'descripcion'},
            {header: '<s:message code="plugin.panelControl.tareas.gestion" text="**Gestión" />',  	dataIndex: 'gestion'},
            {header: '<s:message code="plugin.panelControl.tareas.fechaInicio" text="**Fecha inicio" />',   			dataIndex: 'fechaInicio', hidden:true, renderer:app.format.dateRenderer},
            {header: '<s:message code="plugin.panelControl.tareas.fechaV" text="**Fecha Vto." />',   			dataIndex: 'fechaVencimiento', renderer:app.format.dateRenderer},
            {header: '<s:message code="plugin.panelControl.tareas.fechaVO" text="**Fecha Vto. original" />',   		dataIndex: 'fechaVencimientoOriginal', renderer:app.format.dateRenderer},
            {header: '<s:message code="plugin.panelControl.tareas.tipoSolicitud" text="**Tipo solicitud" />',   		dataIndex: 'tipoSolicitud'},
            {header: '<s:message code="plugin.panelControl.tareas.dias" text="**Días vencida" />',   		dataIndex: 'diasVencida',renderer:thousandSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.tareas.gestor" text="**Gestor" />',   			dataIndex: 'gestor', hidden:true},
            {header: '<s:message code="plugin.panelControl.tareas.supervisor" text="**Supervisor" />',   		dataIndex: 'supervisor', hidden:true},
            {header: '<s:message code="plugin.panelControl.tareas.vre" text="**VRE" />',   		dataIndex: 'vre'},
            {header: '<s:message code="plugin.panelControl.tareas.vreV" text="**VRE vencidos" />',   		dataIndex: 'vreVencidos', hidden:true},
            {header: '<s:message code="plugin.panelControl.tareas.fechaRevision" text="**Fecha revisión" />',   		dataIndex: 'fechaRevisionTarea', hidden:true, renderer:app.format.dateRenderer}
            
	]); 
	var pagingBar=fwk.ux.getPaging(tareaStore);
	 var tareaGrid=app.crearGrid(tareaStore,tareaCm,{
        title:'Listado tareas'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500
        ,id:'gridTareas'
        ,bbar : [  pagingBar ]
        
    });
	
	
	
	var panelTarea = new Ext.Panel({
		id:'panelTarea',
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
    	//height:900,
        bodyStyle: 'padding:5px;',
        layout: 'column',
        items: [{
        			border:false,
    				items: [tareaGrid]
   				}
   			   ]
    });
    
    
    
    
	page.add(panelTarea);
	
	Ext.onReady(function(){
		 tareaStore.webflow({nivel:${nivel}, idNivel:${idNivel}, cod:'${cod}',detalle:${detalle} });
	});
	
</fwk:page>



