Ext.define('HreRem.view.activos.detalle.HistoricoCondicionesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicocondicioneslist',
	topBar: true,
	idPrincipal : 'activo.id',
	
    bind: {
        store: '{historicocondiciones}'
    },

    listeners: {
    	boxready: function() {
    		me = this;
    		me.evaluarEdicion();
    	}
    },
    
    initComponent: function () {
     	
     	var me = this;
		
	    
		me.columns = [
		        {
		        	
		            dataIndex: 'idActivo',
		            text: HreRem.i18n('title.publicaciones.condiciones.idactivo'),
		            flex: 0.5,
		            hidden: true
		        },
		        {
		            dataIndex: 'texto',
		            text: HreRem.i18n('title.publicaciones.condiciones.texto'),
		            flex: 1,
		       		editor: {
		       			xtype:'textarea'
		       		}
		        },
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechadesde'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechahasta'),
		            flex: 1,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'usuarioAlta',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'usuarioBaja',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuariobaja'),
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
		                store: '{historicocondiciones}'
		            }
		        }
		    ];
		    
		    
		    me.callParent();
   },
   
   //HREOS-846 Si NO esta dentro del perimetro, ocultamos los botones de agregar/quitar del grid
   evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('dentroPerimetro')=="false") {
			me.setTopBar(false);
		}
   }

});