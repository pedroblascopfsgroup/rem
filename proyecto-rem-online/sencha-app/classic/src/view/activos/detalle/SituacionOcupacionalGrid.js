Ext.define('HreRem.view.activos.detalle.SituacionOcupacionalGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'situacionOcupacionalGrid',
	requires	: ['HreRem.model.SituacionOcupacionalGridModel'],
	reference	: 'situacionOcupacionalGridref',
	bind: { 
		store: '{storeSituacionOcupacional}'
	},
	
    initComponent: function () {
        var me = this;
     	me.setTitle(HreRem.i18n('title.situacion.ocupacional'));
     	
		me.columns = [
				{ 
					text: 'Ocupado',
		    		dataIndex: 'ocupado',
		    		reference: 'ocupado',
					name: 'ocupado',
					flex: 1
	    		},
				{ 
					text: 'Con título',
		    		dataIndex: 'conTitulo',
		    		reference: 'conTitulo',
					name: 'conTitulo',
					flex: 1
	    		},
		        { 
					text: 'Fecha alta',
		    		dataIndex: 'fechaAlta',
		    		reference: 'fechaAlta',
					name: 'fechaAlta',
					formatter: 'date("d/m/Y")',
					flex: 1
	    		},
		        { 
					text: 'Hora alta',
		    		dataIndex: 'horaAlta',
		    		reference: 'horaAlta',
		    		name: 'horaAlta',
					flex: 1
                },
                { 
					text: 'Usuario alta',
		    		dataIndex: 'usuarioAlta',
		    		reference: 'usuarioAlta',
		    		name: 'usuarioAlta',
					flex: 1
                },
                { 
					text: 'Lugar modificación',
		    		dataIndex: 'lugarModificacion',
		    		reference: 'lugarModificacion',
		    		name: 'lugarModificacion',
					flex: 1
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
		                store: '{storeSituacionOcupacional}'
		            }
		        }
		    ];

			me.callParent();
			
	    
   }
});
