Ext.define('HreRem.view.trabajos.detalle.ActivosTrabajo', {
    extend	 : 'Ext.panel.Panel',
    xtype	 : 'activostrabajo',
    reference: 'activostrabajoref',
    cls		 : 'panel-base shadow-panel',
	layout	 : 'fit',
	listeners: {
    	boxready: function() {
    		var me = this;
    		//Si el trabajo es de tipo PRECIOS y subtipo 'tramitar propuesta de precio' o 'tramitar propuesta de precios de descuento', se muestra el boton de generar propuesta.
    		if(me.lookupController().getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='44'
    			|| me.lookupController().getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='45') {
    			me.down("[itemId=generarPropuestaFromTrabajo]").show();
    			me.down("[itemId=msgActivoPropuestaFromTrabajo]").show();
    		}
    	}
    },

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.activos.simple'));

    	me.items= [
			{
			    xtype		: 'gridBaseEditableRowSinEdicion',
			    idPrincipal	: 'trabajo.id',
			    reference: 'listadoActivosTrabajo',
				cls	: 'panel-base shadow-panel',
				bind: {
					title: '{tituloActivosTrabajo}',
					store: '{activosTrabajo}'
				},
				tbar: {
					xtype: 'toolbar',
					dock: 'top',
					items: [
							{itemId: 'downloadButton', iconCls:'x-fa fa-download', handler: 'onExportListActivosTrabajo'}
					]
				},		
				//secFunToEdit: 'EDITAR_LIST_ACTIVOS_TRABAJO',
				features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
				}],
				listeners: {
			        afterrender: function() {
			            var mainMenu = this.headerCt.getMenu();
	
						mainMenu.on({
						    beforeshow: function(menu){
						        // Si se despliega el menú de la columna indicada, mostrar nuevas opciones.
						        if (menu.activeHeader.dataIndex == 'participacion'){
						            for (var i=0; i<menu.items.items.length; i++){
						                if (menu.items.items[i].itemId == 'participacionActivosMenuItem' || menu.items.items[i].itemId == 'participacionActivosMenuSeparatorItem'){
						                    menu.items.items[i].show();
						                }
						            }
						        // Para cualquier otra columna, ocultar las nuevas opciones.
						        } else {
						            for (var i=0; i<menu.items.items.length; i++){
						                if (menu.items.items[i].itemId == 'participacionActivosMenuItem' || menu.items.items[i].itemId == 'participacionActivosMenuSeparatorItem'){
						                    menu.items.items[i].hide();
						                }
						            }
						        }
						    }
						});
						
						// Añadir al menú de cabeceras un elemento personalizado.
				        mainMenu.insert(mainMenu.items.length-2, [
				        	{
				        		xtype: 'menuseparator',
				        		itemId: 'participacionActivosMenuSeparatorItem'
				        	},
				        	{
					            itemId: 'participacionActivosMenuItem',
					            text: HreRem.i18n('btn.actualizar.participacion.activos'),
					            iconCls: 'ico-refrescar',
				                handler: 'onClickRefrescarParticipacion'
				        	}
				        ]);         
			        }
			    },
				columns: [				    
					{
				        xtype: 'actioncolumn',
				        width: 30,
				        handler: 'onEnlaceActivosClick',
				        items: [{
				            tooltip: 'Ver Activo',
				            iconCls: 'app-list-ico ico-ver-activo'
				        }],
				        hideable: false
			    	} ,  	
				    {   text: HreRem.i18n('header.numero.activo'),
			        	dataIndex: 'numActivo',
			        	flex: 1
			        },	        
  					{  						
			            dataIndex: 'tipoActivoDescripcion',
			            text: HreRem.i18n('header.tipo'),
			            flex: 1
			        },
			        {
			            dataIndex: 'ultimoTrabajo',
			            text: HreRem.i18n('header.ultimo.trabajo'),
			            flex: 1
			        },
			        {
			            dataIndex: 'fecha',
			            text: HreRem.i18n('header.fecha'),
			            flex: 1
			        },
			        {
			            dataIndex: 'descripcionEstado',
			            text: HreRem.i18n('header.estado'),
			            flex: 1
			        }      
			    ],

			    dockedItems : [
					{
					    xtype: 'toolbar',
					    dock: 'top',
					    items: [
							{
								cls:'tbar-grid-button', 
								text: HreRem.i18n('title.generar.propuesta'), 
								itemId:'generarPropuestaFromTrabajo', 
								handler: 'onClickGenerarPropuesta', 
								reference: 'botonGenerarPropuesta',
								hidden: true,
								listeners:{
									beforerender: 'comprobarExistePropuestaTrabajo'
								} 
								
							},
							{
					        	itemId:'msgActivoPropuestaFromTrabajo',
					        	align: 'left',
					        	editor: 'textfield',
					        	hidden: true,
					        	reference: 'msgAdvertenciaActivosEnOtrasPropuestas',
					        	listeners:{
									afterrender: 'comprobarActivosEnOtrasPropuestas'
								} 
					            
							}
						]
					},
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{activosTrabajo}'
			            }
			        }
			    ]
			}
    	];

    	me.callParent();
    },
    
    
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		var listadoActivosTrabajo = me.down("[reference=listadoActivosTrabajo]");
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoActivosTrabajo.getStore().load();
    }
});