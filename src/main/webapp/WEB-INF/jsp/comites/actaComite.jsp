<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>

	var comite = app.creaLabel('<s:message code="actas.consulta.comite" text="**Comite" />',"${dtoSesionComite.comite.nombre}");
	var fechaini = app.creaLabel('<s:message code="actas.consulta.fechaini" text="**Fecha inicio" />',"<fwk:date value="${dtoSesionComite.sesion.fechaInicio}" />");	
	var fechafin = app.creaLabel('<s:message code="actas.consulta.fechafin" text="**Fecha fin" />',"<fwk:date value="${dtoSesionComite.sesion.fechaFin}" />");

	var verPDF = new Ext.Button({
		text : '<s:message code="actas.consulta.verpdf" text="**Ver acta en PDF" />'
		,iconCls:'icon_pdf'
		,handler: function() {
						var flow='comites/acta';
						var tipo='generaPDF';
						var params='id='+ '${idSesion}'+'&REPORT_NAME=actacomite_'+'${idSesion}'+'_'+'${dtoSesionComite.comite.nombre}'+'_'+'${dtoSesionComite.sesion.fechaFin}'+'.pdf';
						app.openPDF(flow,tipo,params);
			        }
			}
	);
	
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
      ,flow:'comites/actaComite'
      ,reader: new Ext.data.JsonReader({
        root : 'asistentesJSON'
      } , Asistente)
     });
   
   asistenteStore.webflow();

	var cmAsistentes = new Ext.grid.ColumnModel([
		{header : '<s:message code="actas.consulta.asistentes.nombre" text="**Nombre" />', dataIndex : 'nombre' }
		,{header : '<s:message code="actas.consulta.asistentes.apellido" text="**Apellidos" />', dataIndex : 'apellidos' }
		,{header : '<s:message code="actas.consulta.asistentes.restrictivo" text="**Restrictivo" />', dataIndex : 'restrictivo' }
		,{header : '<s:message code="actas.consulta.asistentes.supervisor" text="**Supervisor" />', dataIndex : 'supervisor' }
		
	]);
	
	var gridAsistentes = new Ext.grid.GridPanel({
		store : asistenteStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,title:'<s:message code="actas.consulta.asistentes.titulo" text="**Asistentes" />'
		,cm : cmAsistentes
		,iconCls:'icon_usuario'
		 ,width:cmAsistentes.getTotalWidth()+30
		//,autoWidth:true
		,height : 150
	});

    var Expediente = Ext.data.Record.create([
        {name:'id'}
        ,{name:'fcreacion',type:'date', dateFormat:'d/m/Y'}
        ,{name:'estadoExpediente'}
        ,{name:'volumenRiesgo', type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'oficina'}
        ,{name:'cantAsuntos', type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'cantContratos', type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'origen'}
        ,{name:'estadoItinerario'}  
        ,{name:'volumenRiesgoVencido', type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'fcomite',type:'date', dateFormat:'d/m/Y'}
        ,{name:'comite'}
        ,{name:'descripcionExpediente'}
        ,{name:'decidido'}
      ]);

    var expStore = page.getStore({
        eventName : 'listado'
        ,limit:5
        ,flow:'expedientes/listadoExpedientesData'
        ,reader: new Ext.data.JsonReader({
            root : 'expedientes'
            ,totalProperty : 'total'
        }, Expediente)
    });
    expStore.webflow({
                    idComite:'${dtoSesionComite.comite.id}'
                    ,idSesion:'${dtoSesionComite.sesion.id}'
                    ,busqueda:true
    });    

	var expCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="actas.consulta.expedientes.codigo" text="**C&oacute;digo" />', dataIndex : 'id' , sortable:true}
		,{header: '<s:message code="expedientes.listado.descripcion" text="**Descripcion"/>', width: 132, sortable: true, dataIndex: 'descripcionExpediente'}
		,{header : '<s:message code="actas.consulta.expedientes.fecha" text="**Fecha" />', dataIndex : 'fcreacion', renderer:app.format.dateRenderer, sortable:true }
		,{header : '<s:message code="actas.consulta.expedientes.estado" text="**Estado" />', dataIndex : 'estadoExpediente' , sortable: true}
		,{header : '<s:message code="actas.consulta.expedientes.vre" text="**VRE" />', dataIndex : 'volumenRiesgo',  renderer: app.format.moneyRenderer, sortable:true }
		,{header : '<s:message code="actas.consulta.expedientes.oficina" text="**Oficina" />', dataIndex : 'oficina', sortable:true }
		,{header : '<s:message code="actas.consulta.expedientes.asuntos" text="**Cant Asuntos" />', dataIndex : 'cantAsuntos', sortable:true }
		,{header : '<s:message code="actas.consulta.expedientes.contratos" text="**Contratos" />', dataIndex : 'cantContratos', sortable:true }
		
	]);

	// Generar PDF para el expediente seleccionado
	var btnVerPdfExpediente = new Ext.Button({
		text : '<s:message code="actas.consulta.expedientes.ver" text="**ver" />'
		,iconCls:'icon_pdf'
		,handler : function(){
			var rec = expedientesGrid.getSelectionModel().getSelected();
			if(!rec) return;
   			var idExp = rec.get('id');
	        var flow='expedientes/reporteExpediente';
	        var tipo='generaPDF';
	        var params='id='+idExp+'&REPORT_NAME=reporteExpediente'+idExp+'.pdf';
	        app.openPDF(flow,tipo,params);
     }
	});

    var expedientesGrid = app.crearGrid(expStore,expCm,{
            title:'<s:message code="actas.consulta.expedientes.titulo" text="**Expedientes" />'
            ,style : 'margin-bottom:10px'
            ,iconCls : 'icon_expedientes'
            ,cls:'cursor_pointer'
            ,autoWidth:true
            ,height : 200
            ,bbar : [ btnVerPdfExpediente, fwk.ux.getPaging(expStore)  ]
            
        });

    var expedientesGridListener =   function(grid, rowIndex, e) {       
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
        ,{name:'fcreacion'}
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

    //Hace la búsqueda inicial
    asuntosStore.webflow({
                    idSesionComite:'${idSesion}'
                    ,busqueda:true
                });

    var asuntosCm = new Ext.grid.ColumnModel([
        {header: '<s:message code="asuntos.listado.codigo" text="**Codigo" />', dataIndex: 'codigo'},
        {header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre" />', dataIndex: 'nombre'},
        {header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion" />', dataIndex: 'fcreacion'},
        {header: '<s:message code="asuntos.listado.estado" text="**Estado" />', dataIndex: 'estado'}, 
        {header: '<s:message code="asuntos.listado.gestor" text="**Gestor" />', dataIndex: 'gestor'}, 
        {header: '<s:message code="asuntos.listado.despacho" text="**Despacho" />', dataIndex: 'despacho'},
        {header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor" />', dataIndex: 'supervisor'}, 
        {header: '<s:message code="asuntos.listado.saldototal" text="**Saldo Total" />', dataIndex: 'saldototal'}
    ]);
    
    var preasuntosGrid = app.crearGrid(asuntosStore, asuntosCm,{
            title:'<s:message code="preasuntos.grid.titulo" text="**Pre asuntos" />'
            ,style : 'margin-bottom:10px'
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


	var panel = new Ext.form.FormPanel({
	    items : [{
				layout:'column'
				,border:false
				,autoHeight:true
				,autoWidth:true
				,bodyStyle:'padding:5px'
				,viewConfig:{
					columns:2
				}
				,items:[{
				    items:app.creaFieldSet([comite, fechaini, fechafin])
				    ,border:false
					,columnWidth:.8
					,style:'margin-right:10px'
				    },gridAsistentes ]
			}
			,expedientesGrid
            ,preasuntosGrid 
	
	    ]
	    ,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight :true
	    ,tbar:new Ext.Toolbar()
    });
	//Agregamos los botones
 	panel.getTopToolbar().add(verPDF);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
        page.add(panel);

</fwk:page>
