<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	var limit=25;

	var nroSesion	=app.creaLabel('<s:message code="comite.sesion" text="**Sesion"/>',"${dtoSesionComite.sesion.id}")
	var comite		=app.creaLabel('<s:message code="comite.comite" text="**Comite"/>',"${dtoSesionComite.comite.nombre}")
	var fechaInicio	=app.creaLabel('<s:message code="comite.fechaini" text="**Fecha Inicio"/>',"<fwk:date value="${dtoSesionComite.sesion.fechaInicio}"/>")
	
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(mainPanel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
		}
		maskPanel.show();
		mainPanel.getTopToolbar().disable();
		
	};
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
		mainPanel.getTopToolbar().enable();
		
	};
    var Asistente = Ext.data.Record.create([
         {name:'id'}
         ,{name : 'nombre'}
         ,{name : 'apellidos'}
         ,{name : 'restrictivo'}
         ,{name : 'supervisor'}
         ,{name : 'asiste'}
      ]);

   var asistenteStore = page.getStore({
      eventName : 'listadoAsistentes'
      ,reader: new Ext.data.JsonReader({
        root : 'asistentesJSON'
      } , Asistente)
     });
   
   asistenteStore.webflow();

	var cmAsistentes = new Ext.grid.ColumnModel([
		{header : '<s:message code="actas.consulta.asistentes.nombre" text="**Nombre"/>', width: 125, dataIndex : 'nombre' }
		,{header : '<s:message code="actas.consulta.asistentes.apellido" text="**Apellidos"/>', width: 125, dataIndex : 'apellidos' }
		,{header : '<s:message code="actas.consulta.asistentes.restrictivo" text="**Restrictivo"/>', width:75, dataIndex : 'restrictivo' }
		,{header : '<s:message code="actas.consulta.asistentes.supervisor" text="**Supervisor"/>', width:75, dataIndex : 'supervisor' }
		
	]);
	
	var gridAsistentes = new Ext.grid.GridPanel({
		store : asistenteStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="actas.consulta.asistentes.titulo" text="**Asistentes" />'
		,cm : cmAsistentes
		,iconCls:'icon_usuario'
		,width:cmAsistentes.getTotalWidth()+30
		//,autoWidth:true
		,height : 100
	});
	
	
	var Expediente = Ext.data.Record.create([
		{name:'id'}
		,{name:'fechacrear',type:'date', dateFormat:'d/m/Y'}
        ,{name:'origen'}
        ,{name:'estadoExpediente'}
        ,{name:'estadoItinerario'}  
        ,{name:'volumenRiesgo', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'volumenRiesgoVencido', sortType:Ext.data.SortTypes.asFloat}
		,{name:'oficina'}
        ,{name:'fechaVencimiento',type:'date', dateFormat:'d/m/Y'}
        ,{name:'comite'}
        ,{name:'descripcionExpediente'}
        ,{name:'decidido'}
		,{name:'itinerario'}
	]);
 
	var expStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,remoteSort:true
		,flow:'expedientes/listadoExpedientesData'
		,reader: new Ext.data.JsonReader({
	    	root : 'expedientes'
	    	,totalProperty : 'total'
	    }, Expediente)
	});
	


	var expCm = new Ext.grid.ColumnModel([
			  {	hidden:true,sortable: false, dataIndex: 'id',fixed:true},
		    {	header: '<s:message code="expedientes.listado.codigo" text="**Codigo"/>', width: 60, sortable: true, dataIndex: 'id'},
		    {	header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', width: 140, sortable: true, dataIndex: 'descripcionExpediente'},
			{	header: '<s:message code="expedientes.listado.itinerario" text="**Itinerario"/>', width: 140, sortable: false, dataIndex: 'itinerario'},
		    {	header: '<s:message code="expedientes.listado.fechacreacion" text="**Fecha Creacion"/>',width: 120, sortable: true, dataIndex: 'fechacrear', renderer:app.format.dateRenderer},
		    {	header: '<s:message code="expedientes.listado.origen" text="**origen"/>', width: 60, sortable: false, dataIndex: 'origen'},
		    {	header: '<s:message code="expedientes.listado.estado" text="**Estado"/>',width: 80, sortable: true, dataIndex: 'estadoExpediente'},
		    {	header: '<s:message code="expedientes.listado.situacion" text="**Situacion"/>',width: 135, sortable: true, dataIndex: 'estadoItinerario'},
			{	header: '<s:message code="expedientes.listado.riesgosD" text="**Riesgos D."/>', width: 120, sortable: true, dataIndex: 'volumenRiesgo',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.riesgosI" text="**Riesgos I."/>', width: 120, sortable: true, dataIndex: 'volumenRiesgoVencido',renderer: app.format.moneyRenderer,align:'right'},
		    {	header: '<s:message code="expedientes.listado.oficina" text="**Oficina"/>', width: 120, sortable: true, dataIndex: 'oficina'},
		    {	header: '<s:message code="expedientes.listado.fvencimiento" text="**Fecha Vencimiento"/>', width: 120, sortable: true, dataIndex: 'fechaVencimiento', renderer:app.format.dateRenderer},
		    {	header: '<s:message code="expedientes.listado.comite" text="**Comité"/>',  width: 120, sortable: true, dataIndex: 'comite'},
		    {   header: '<s:message code="expedientes.listado.descripcion" text="**Comité"/>', dataIndex: 'descripcion' ,hidden:true, fixed:true}
			]
		); 
		
	var expedientesGrid = app.crearGrid(expStore,expCm,{
			title:'<s:message code="expedientes.consulta.titulo" text="**Expedientes"/>'
			,style : 'margin-bottom:10px'
			,iconCls : 'icon_expedientes'
			,cls:'cursor_pointer'
			,autoWidth:true
			,collapsible:true
			,height:175
			,bbar : [  fwk.ux.getPaging(expStore)  ]
			
		});
	var expedientesGridListener =	function(grid, rowIndex, e) {		
	    	var rec = grid.getStore().getAt(rowIndex);
	    	if(rec.get('id')){
	    		var id = rec.get('id');
	    		var desc = rec.get('descripcionExpediente');
	    		app.abreExpediente(id,desc);
		    	
	    	}
	    };
	    
	expedientesGrid.addListener('rowdblclick', expedientesGridListener);

    var Asunto = Ext.data.Record.create([
        {name:'codigo'}
        ,{name:'nombre'}
        ,{name:'fechacrear'}
        ,{name:'gestor'}
        ,{name:'despacho'}  
        ,{name:'supervisor'}
        ,{name:'estado'}
        ,{name:'saldototal'}    
        ,{name:'confirmado'}
    ]);
    
    var asuntosStore = page.getStore({
        flow:'asuntos/listadoAsuntosData'
        ,eventName : 'listado'
        ,limit:5
        ,reader: new Ext.data.JsonReader({
            root : 'asuntos'
            ,totalProperty : 'total'
        }, Asunto)
    });

    var asuntosCm = new Ext.grid.ColumnModel([
        {header: '<s:message code="asuntos.listado.codigo" text="**Codigo" />', dataIndex: 'codigo'},
        {header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre" />', dataIndex: 'nombre'},
        {header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion" />', dataIndex: 'fechacrear'},
        {header: '<s:message code="asuntos.listado.estado" text="**Estado" />', dataIndex: 'estado'}, 
        {header: '<s:message code="asuntos.listado.gestor" text="**Gestor" />', dataIndex: 'gestor'}, 
        {header: '<s:message code="asuntos.listado.despacho" text="**Despacho" />', dataIndex: 'despacho'},
        {header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor" />', dataIndex: 'supervisor'}, 
        {header: '<s:message code="asuntos.listado.saldototal" text="**Saldo Total" />', dataIndex: 'saldototal',align:'right',renderer: app.format.moneyRenderer}
    ]);
    
    var preasuntosGrid = app.crearGrid(asuntosStore, asuntosCm,{
            title:'<s:message code="preasuntos.grid.titulo" text="**Pre asuntos"/>'
            ,style : 'margin-bottom:10px'
			,height:125
			,collapsible:true
            ,iconCls : 'icon_asuntos'
            ,cls:'cursor_pointer'
            ,autoWidth:true
            ,bbar : [  fwk.ux.getPaging(asuntosStore)  ]
            
        });
    
    preasuntosGrid.on('rowdblclick', function(grid, rowIndex, e) {
        //TODO Verificar lo pagina que abre cuando este hecho la consulta de asuntos
        var rec = preasuntosGrid.getSelectionModel().getSelected();
        if(!rec) return;
        app.abreAsunto(rec.get('codigo'), rec.get('nombre'));

    });
	expedientesGrid.on('expand', function(){
			expedientesGrid.setHeight(340);				
				preasuntosGrid.collapse(true);
			});
	preasuntosGrid.on('expand', function(){
			preasuntosGrid.setHeight(340);				
				expedientesGrid.collapse(true);
			});
    var cerrar = new Ext.Button({
        text : '<s:message code="actas.consulta.cerrarsesion" text="**Cerrar sesi&oacute;n" />'
        ,iconCls:'icon_comite_cerrar'
        ,handler : function(){
            validarCerrarSesion();           
       }
    });   
    
    function validarCerrarSesion(){
		maskAll();
        page.webflow({
          flow: 'comite/cerrarSesionComite', 
          params: {idComite: ${idComite}, ignorarErrores: false},
          success: function(data, config) {
		  		unmaskAll();
              if(data.respuesta.respuesta!="Sesion cerrada") {
                  verificarCerrarSesion();
              } else {
                  alertSesionCerrada()
              }
          }
        });
      };

     function verificarCerrarSesion(){ 
  
		  Ext.Msg.show({
		   title: "<s:message code="actas.consulta.cerrarsesion.confirmar" text="**Confirmar cerrar sesi&oacute;n" />",
		   msg: "<s:message code="actas.consulta.cerrarsesion.confirmar.sesion" text="**Existe expedientes sin decision o preasuntos sin confirmar, seguro que quiere cerrar la sesion" />",
		   width: 300,
		   buttons: Ext.MessageBox.YESNO,
		   fn: evaluateAndSend,
		   animEl: 'addAddressBtn',
		   icon: Ext.MessageBox.INFO
		});

      };
      
     function evaluateAndSend(ignorar) {
           if(ignorar== 'yes') {            
             cerrarSesion();
           }
     };
     
     function alertSesionCerrada() {
        Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', '<s:message code="comite.sesion.cerrada" text="**Sesión cerrada con exito" />', reloadListadoComites);         
     }

     function reloadListadoComites() {
        var control = Ext.getCmp('listadoComitesUsuario');
        if (control){
			_cerrarTab();
           app.openTab("<s:message code="comite.listado.titulo" text="**Listado Comites"/>", "comites/listadoComitesUsuario",{},{id:'listadoComitesUsuario', iconCls:'icon_comite_celebrar'});
        }
     }
     var _cerrarTab = function(){
		app.contenido.remove(app.contenido.activeTab);
	}
      
    function cerrarSesion(){
		maskAll();
        page.webflow({
          flow: 'comite/cerrarSesionComite', 
          params: {idComite: ${idComite}, ignorarErrores: true}, 
          success: function() {
		  	 unmaskAll();
		  	 alertSesionCerrada();
			}
        });
      } 

	var mainPanel = new Ext.Panel({
	    items : [{
				layout:'column'
				,border:false
				,viewConfig:{
					columns:2
				}
				,defaults:{
					border:false
				}
				,items:[{
					xtype:'fieldset'
					,columnWidth:.4
					,border:false
					,autoHeight:true
					,items:[nroSesion,comite,fechaInicio]
				},{
					items:gridAsistentes
					,columnWidth:.6
					,border:false
					,autoHeight:true
					,style:'padding-bottom:10px'
				}]	
			},expedientesGrid, preasuntosGrid
		]
	    ,bodyStyle:'padding: 10px'
	    ,autoHeight : true
	    ,border: false
		,tbar:new Ext.Toolbar()
        ,id:'detalleSesion'
    });
	page.add(mainPanel);

	mainPanel.getTopToolbar().add(cerrar);
	mainPanel.getTopToolbar().add('->');
	mainPanel.getTopToolbar().add(app.crearBotonAyuda());
	
	
	//Hace la búsqueda inicial
	Ext.onReady(function()
	{
		expStore.webflow({
						codigoSituacion:'<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_DECISION_COMIT" />'
						,idComite:'${dtoSesionComite.comite.id}'
						,busqueda:true
					});
	    //Hace la búsqueda inicial
	    asuntosStore.webflow({idComite:'${dtoSesionComite.comite.id}',busqueda:true});
	});	
	
</fwk:page>