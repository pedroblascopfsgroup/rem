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

	var limit = 10000;	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
	};

//Store de Categorias	
	
	var categoriasRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'nombre'}
    ]);
       
    var categoriasStore = page.getStore({   
		flow : 'categorias/getListaCategorias'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,reader : new Ext.data.JsonReader({root:'categorias', totalProperty : 'total'}, categoriasRecord)
	});

	categoriasStore.webflow({idcategorizacion: '${idcategorizacion}'});
	
	




//Store de Tramites	
	
	var tramitesRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'codigo'}
        ,{name:'descripcion'}
    ]);
       
    var tramitesStore = page.getStore({
		flow : 'relacioncategorias/listaProcedimientosCategorizables'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'tiposProcedimiento', totalProperty : 'total'}, tramitesRecord)
	});
		
	tramitesStore.webflow({});		






//Store de Tareas	
	
	var tareasRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'descripcion'}
    ]);
    
     var tareasAsignadasStore = page.getStore({
		flow : 'relacioncategorias/listaTareasConRelacionCategorias'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'listadoTareas', totalProperty : 'total'}, tareasRecord)
	});
	   
    var tareasSinAsignarStore = page.getStore({
		flow : 'relacioncategorias/listaTareasSinRelacionCategorias'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'listadoTareas', totalProperty : 'total'}, tareasRecord)
	});





//Store de Tipo Resolucion	
	
	var tipoResolucionRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'descripcion'}
    ]);
    
     var tiposResolAsignadasStore = page.getStore({
		flow : 'relacioncategorias/listaTiposResolConRelacionCategorias'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'listadoTiposResol', totalProperty : 'total'}, tipoResolucionRecord)
	});
	   
    var tiposResolSinAsignarStore = page.getStore({
		flow : 'relacioncategorias/listaTiposResolSinRelacionCategorias'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'listadoTiposResol', totalProperty : 'total'}, tipoResolucionRecord)
	});






//Acciones selector Tareas

	tareasAsignadasStore.on("remove", function(cmp, nuevo, index){
		
		var ctgselector = Ext.getCmp("selectorCategorias");
		var idcategoria = ctgselector.getValue();
		if(!idcategoria){
			Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.texto" text="**Debe seleccionar una categor&iacute;a." />');
		}else{
		
			page.webflow({
      			flow:'relacioncategorias/borrarRelacionCategoria'
      			,params:{
    				idcategoria: idcategoria,
    				idtap: nuevo.id,
    				tipoRelacion: '${tipoRelacion}'
   				}
   				,failure: function(result, request){
   					//Recargamos las tareas
	      			var tramites = Ext.getCmp("comboTramites");
	 	 			var idtramite = tramites.getValue();	      		
           		   	recargarTareas(idcategoria,idtramite);
           		   	Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	
   				}  		
      		});
    	}
	});
	
	
	
	tareasAsignadasStore.on("add", function(cmp, nuevo, index){
	
		var ctgselector = Ext.getCmp("selectorCategorias");
		var idcategoria = ctgselector.getValue();
		
		if(!idcategoria){
			Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.texto" text="**Debe seleccionar una categor&iacute;a." />');
		}else{
				
			page.webflow({
      			flow:'relacioncategorias/guardarRelacionCategorias'
      			,params:{
      				   idcategoria: idcategoria,
      				   idtap: nuevo[0].data.id,
      				   tipoRelacion: '${tipoRelacion}'
   				}
   				,failure: function(result, request){
   					//Recargamos las tareas
	      			var tramites = Ext.getCmp("comboTramites");
	 	 			var idtramite = tramites.getValue();	      		
           		   	recargarTareas(idcategoria,idtramite);
           		   	Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	
   				}  				
      		});
    	}
	});




//Acciones selector Tips Resol

	tiposResolAsignadasStore.on("remove", function(cmp, nuevo, index){
		
		var ctgselector = Ext.getCmp("selectorCategorias");
		var idcategoria = ctgselector.getValue();
		if(!idcategoria){
			Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.texto" text="**Debe seleccionar una categor&iacute;a." />');
		}else{
		
			page.webflow({
      			flow:'relacioncategorias/borrarRelacionCategoria'
      			,params:{
    				idcategoria: idcategoria,
    				idtiporesolucion: nuevo.id,
    				tipoRelacion: '${tipoRelacion}'
   				}
   				,failure: function(result, request){
   					//Recargamos las tareas
	      			var tramites = Ext.getCmp("comboTramites");
	 	 			var idtramite = tramites.getValue();	      		
           		   	recargarTareas(idcategoria,idtramite);
           		   	Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	
   				}  		
      		});
    	}
	});
	
	
	
	tiposResolAsignadasStore.on("add", function(cmp, nuevo, index){
	
		var ctgselector = Ext.getCmp("selectorCategorias");
		var idcategoria = ctgselector.getValue();
		
		if(!idcategoria){
			Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.sinSeleccionCategoria.texto" text="**Debe seleccionar una categor&iacute;a." />');
		}else{
				
			page.webflow({
      			flow:'relacioncategorias/guardarRelacionCategorias'
      			,params:{
      				   idcategoria: idcategoria,
      				   idtiporesolucion: nuevo[0].data.id,
      				   tipoRelacion: '${tipoRelacion}'
   				}
   				,failure: function(result, request){
   					//Recargamos las tareas
	      			var tramites = Ext.getCmp("comboTramites");
	 	 			var idtramite = tramites.getValue();	      		
           		   	recargarTareas(idcategoria,idtramite);
           		   	Ext.Msg.alert('<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.relacionCategorias.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');		            	           	
   				}  		  				
      		});
    	}
	});
	
	
	
	
	var resuelveTipoRelacion = function(){
		if('${tipoRelacion}' == 1){
			selectorTareas_3_4.show();			
		}else{
			selectorTipoResolucion_3_4.show();					
		}
	};


	var recargarTareas = function(idcategoria, idtramite){
		
		//Se realiza la busqueda si lo si se ha seleccionado un tramite
		if(idtramite && idtramite != "" && idcategoria  && idcategoria != ""){
			
			if('${tipoRelacion}' == 1){				
				//Realizamos la búsqueda	
				tareasSinAsignarStore.webflow({tipoRelacion: '${tipoRelacion}', idtramite: idtramite, idcategorizacion: '${idcategorizacion}'});		
				tareasAsignadasStore.webflow({tipoRelacion: '${tipoRelacion}', idtramite: idtramite, idcategoria: idcategoria});
			
			}else{			
				//Realizamos la búsqueda	
				tiposResolSinAsignarStore.webflow({tipoRelacion: '${tipoRelacion}', idtramite: idtramite, idcategorizacion: '${idcategorizacion}'});		
				tiposResolAsignadasStore.webflow({tipoRelacion: '${tipoRelacion}', idtramite: idtramite, idcategoria: idcategoria});
			
			}			
		}
	};



	
//Botones

    
    var btnCancelar= new Ext.Button({
		text : '<s:message code="plugin.procuradores.relacionCategorias.boton.cerrar" text="**Cerrar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});




//Selector de Tipo de Resolucion
	
	var selectorTipoResolucion_3_4	 = new Ext.ux.form.ItemSelector({
		fieldLabel: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tipoResolucion" text="**Tipos de resoluci&oacute;n" />'
		, imagePath: "/${appProperties.appName}/js/plugin/procuradores/images/"	
		, hidden : true
		, multiselects: [{
				legend: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tipoResolucion.disponibles" text="**Disponibles" />'
                , width: 300                
                , height: 200
                , id: 'tiposResolDisponibles'
                , store: tiposResolSinAsignarStore
                , displayField: 'descripcion'
                , valueField: 'id'               
            },{
            	legend: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tipoResolucion.asignadas" text="**Asignadas" />'
                , width: 300
                , height: 200
                , id: 'tiposResolSeleccionadas'
                , store: tiposResolAsignadasStore
                , displayField: 'descripcion'
                , valueField: 'id'                       
          }]     
	});




//Selector de Tareas
	
	var selectorTareas_3_4	 = new Ext.ux.form.ItemSelector({
		fieldLabel: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tareas" text="**Tareas" />'
		, imagePath: "/${appProperties.appName}/js/plugin/procuradores/images/"	
		, hidden : true
		, multiselects: [{
				legend: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tareas.disponibles" text="**Disponibles" />'
                , width: 300                
                , height: 200
                , id: 'tareasDisponibles'
                , store: tareasSinAsignarStore
                , displayField: 'descripcion'
                , valueField: 'id'               
            },{
            	legend: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tareas.asignadas" text="**Asignadas" />'
                , width: 300
                , height: 200
                , id: 'tareasSeleccionadas'
                , store: tareasAsignadasStore
                , displayField: 'descripcion'
                , valueField: 'id'                       
          }]     
	});



	
//Combo Tramites	
	
	var comboTramites = new Ext.form.ComboBox({
		name: 'comboTramites'
    	,store: tramitesStore
    	,id: 'comboTramites'
    	,displayField: 'descripcion'
    	,valueField: 'id'
    	,mode: 'local'
    	,triggerAction: 'all'
    	,editable: false
    	,emptyText: 'Seleccionar...'
   		,fieldLabel: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.tramites" text="**Tr&aacute;mites" />'
		,width: 420
		,forceSelection: true
		,listeners: {
 	 		select: function(combo,  record,  index ) {	 		
 	 			var ctgselector = Ext.getCmp("selectorCategorias");
 	 			var idcategoria = ctgselector.getValue(); 	 			
 	 			recargarTareas(idcategoria,record.data.id);	
			}  
    	} 
	});

	
	
	
//Selector de Categorias	

  	var selectorCategorias_3_4	 = new Ext.ux.form.MultiSelect({
		fieldLabel: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.categorias" text="**Categor&iacute;as" />'
		, store: categoriasStore
		, autoScroll: true  
		, id: 'selectorCategorias'
		, minSelections:1
		, maxSelections:1
		, maxSelectionsText: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.categorias.maxselections" text="**S&oacute;lo se puede seleccionar 1 elemento." />'
		, displayField:'nombre'
		, valueField:'id'
		, blankText: '<s:message code="plugin.procuradores.relacionCategorias.form.seleccionable.categorias.selectone" text="**Debe seleccionar un elemento." />'		
		, width:200
		, height:220
		, listeners:{
              change: function(combo,  value,  codigo ) {		
				if(value && value != ""){				
					//Para permitir la selección de un único elemento
           	    	combo.setValue(value.substring(value.lastIndexOf(',')+1,value.length));
           	    	
	 	 			var tramites = Ext.getCmp("comboTramites");
	 	 			var idtramite = tramites.getValue();	 	 			
	 	 			recargarTareas(value, idtramite);	
         	    }
			}
		}
	});
		

    
    
    var mainPanel = new Ext.form.FormPanel({
    	labelWidth: 60
    	,autoWidth: true
    	,autoHeight: true
    	,border: true
        ,bodyStyle: 'padding:5px;'
        ,layout:'table'
		,layoutConfig : {
			columns: 2
		}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}		
		,items:[{
					layout:'form'
					,bodyStyle:'padding: 5px'
					,items: [selectorCategorias_3_4]
				},{
					layout:'form'
					,bodyStyle:'padding: 0px'
					,items: [comboTramites, selectorTareas_3_4, selectorTipoResolucion_3_4]
				}]
   		,bbar:[btnCancelar]
    });
    
    
	page.add(mainPanel);

	
	Ext.onReady(function(){
		resuelveTipoRelacion();
		
	});
	
</fwk:page>



