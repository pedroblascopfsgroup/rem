Ext.define('HreRem.view.configuracion.mantenimiento.tiposmantenimiento.MantenimientoPrincipalList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'mantenimientoprincipallist',
	reference: 'mantenimientoprincipallistref',
	topBar: true,
	idPrincipal : 'id',
	editOnSelect: true,
	disabledDeleteBtn: true,
	removeButton: false,
	disabledDeleteBtn: true,

    bind: {
        store: '{listaMantenimiento}'
    },

    
    initComponent: function () {
     	var me = this;
     	        
              
		me.setTitle(HreRem.i18n("title.mantenimiento.seguridad.ream.lista"));
		me.columns = [
		        {
		            dataIndex: 'id',
		            text: HreRem.i18n('header.evaluacion.mediadores.id'),
		            flex: 0.3,
		            hidden: true
		        },
		        {
		            dataIndex: 'codCartera',
		            text: HreRem.i18n('fieldlabel.entidad.propietaria'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'codSubCartera',
		            text: HreRem.i18n('fieldlabel.subcartera'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'nombrePropietario',
		            text: HreRem.i18n('fieldlabel.propietario'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'carteraMacc',
		            text: HreRem.i18n('fieldlabel.cartera.macc'),
		            flex: 0.3
		        },
		        {
		            dataIndex: 'fechaCrear',
		            text: HreRem.i18n('fieldlabel.fecha.creacion'),
		            flex: 0.3,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'usuarioCrear',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
		            flex: 0.3
		        },
		        {
                    flex : 0.3,
                    align: 'left',
                    xtype: 'actioncolumn',
                    items: [							
							{
                 				xtype: 'button',
                  				handler: 'onClickBorrarMantenimiento',
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'ico-delete-documento';					            
					            }
              		 		}
          		 	]			        
				}

		    ];

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'activosPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{listaMantenimiento}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   	onAddClick: function(btn){
		
		var me = this;
		me.mask(HreRem.i18n("msg.mask.loading"));
 		
 		var ventana = Ext.create("HreRem.view.mantenimiento.tiposmantenimiento.AnyadirMantenimiento");
 		me.up('mantenimientosmain').add(ventana);
		ventana.show();
		me.unmask();

   }

});