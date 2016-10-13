Ext.define('HreRem.view.trabajos.detalle.ActivosTrabajo', {
    extend: 'Ext.panel.Panel',
    xtype: 'activostrabajo',    
    cls	: 'panel-base shadow-panel',
	layout: 'fit',
	
	listeners: {
    	boxready: function() {
    		me = this;
    		//Si el trabajo no es de tipo PRECIOS, se oculta el boton de generar propuesta
    		if(me.lookupController().getViewModel().get('trabajo').get('tipoTrabajoCodigo')!='04') {
    			me.down("[itemId=generarPropuestaFromTrabajo]").hide();
    		}
    	}
    },
	
    initComponent: function () {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('title.activos'));
    	
    	var items= [
    	   	
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
			            summaryType: 'sum',
			            summaryRenderer: function(value, summaryData, dataIndex) {
			            	var msg = HreRem.i18n("fieldlabel.participacion.total") + " " + value + "%";
			            	var style = "" 
			            	if(value != 100) {
			            		msg = HreRem.i18n("fieldlabel.participacion.total.error")	
			            		style = "style= 'color: red'" 
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
							{cls:'tbar-grid-button', text: HreRem.i18n('title.generar.propuesta'), itemId:'generarPropuestaFromTrabajo', handler: 'onClickGenerarPropuesta'}
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
    	
    	
    	]
    	
    	me.addPlugin({ptype: 'lazyitems', items: items });
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