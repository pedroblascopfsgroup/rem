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
    	me.setTitle(HreRem.i18n('title.activos'));

    	me.items= [
			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal	: 'trabajo.id',
			    reference: 'listadoActivosTrabajo',
				cls	: 'panel-base shadow-panel',
				bind: {
					title: '{tituloActivosTrabajo}',
					store: '{activosTrabajo}'
				},
				secFunToEdit: 'EDITAR_LIST_ACTIVOS_TRABAJO',
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
			        	dataIndex: 'direccion',
			        	text: HreRem.i18n('header.direccion'),
			        	flex:1,
			        	hidden: true
			        },
			        {   
			        	dataIndex: 'localidadDescripcion',
			        	text: HreRem.i18n('header.municipio'),
			        	flex:1,
			        	hidden: true
			        },
			        {   
			        	dataIndex: 'provinciaDescripcion',
			        	text: HreRem.i18n('header.provincia'),
			        	flex:1,
			        	hidden: true
			        },
			        {
			            dataIndex: 'entidadPropietariaDescripcion',
			            text: HreRem.i18n('header.propietario'),
			            flex: 1
			        },		        
  					{  						
			            dataIndex: 'tipoActivoDescripcion',
			            text: HreRem.i18n('header.tipo'),
			            flex: 1
			        },
			        {
			            dataIndex: 'subtipoActivoDescripcion',
			            text: HreRem.i18n('header.subtipo'),
			            flex: 1
			        },
			        {
			            dataIndex: 'situacionComercial',
			            text: HreRem.i18n('header.estado.comercial'),
			            flex: 1
			        },
			        			        {
			            dataIndex: 'situacionPosesoria',
			            text: HreRem.i18n('header.situacion.posesoria'),
			            flex: 1
			            
			        },
			        			        {
			            dataIndex: 'saldoDisponible',
			            text: HreRem.i18n('header.saldo.disponible'),
			            flex: 1,
			            renderer: function(value) {
			            	return Ext.util.Format.currency(value);
			            }
			        },
			        {
			        	dataIndex: 'participacion',
			        	text: HreRem.i18n('header.porcentaje.participacion'),
			        	flex:1,
			        	editor: 'textfield',
			        	renderer: function(value) {
			            	return Ext.util.Format.number(value, '0.00%');
			            },
			            summaryType: function(){
			            	var store = this;
		                    var value = store.sumaParticipacion;
		                    return value;		                    
			            },
			            summaryRenderer: function(value, summaryData, dataIndex) {
			            	var value2=Ext.util.Format.number(value, '0.00');
			            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value2 + "%";
			            	var style = "style= 'color: black'";
			            	if(parseFloat(value2) != parseFloat('100')) {
			            		//msg = HreRem.i18n("fieldlabel.participacion.total.error")	
			            		style = "style= 'color: red'";
			            	}			            	
			            	return "<span "+style+ ">"+msg+"</span>"
			            }
			        },
			        {
			        	dataIndex: 'importeParticipa',
			            text: HreRem.i18n('header.importe.participa'),
			            flex: 1,
			            renderer: function(value) {
			            	return Ext.util.Format.currency(value);
			            }
			        },
			        {
			        	dataIndex: 'saldoNecesario',
			        	text: HreRem.i18n('header.importe.solicitar'),
			            flex: 1,
			            renderer: function(value) {
			            	return Ext.util.Format.currency(value);
			            }
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