Ext.define('HreRem.view.activos.detalle.HistoricoCondicionesList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'historicocondicioneslist',
	topBar		: true,
	idPrincipal : 'activo.id',
	propagationButton: true,
	targetGrid	: 'condicionesespecificas',
	
    bind: {
        store: '{historicocondiciones}'
    },

    listeners: {
    	boxready: function() {
    		var me = this;
    		me.evaluarEdicion();
    	},
    	rowclick: 'onGridCondicionesEspecificasRowClick'
    },
    
    initComponent: function () {
     	
     	var me = this;
     	
     	me.deleteSuccessFn = function(){
    		this.getStore().load()
    		this.setSelection(0);
    	}
	    
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
		       			xtype:'textarea',
		       			maxLength: 4000
		       		}
		        },
		        {
		            dataIndex: 'fechaDesde',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechadesde'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'fechaHasta',
		            text: HreRem.i18n('title.publicaciones.condiciones.fechahasta'),
		            flex: 0.5,
		            formatter: 'date("d/m/Y")'
		        },
		        {
		            dataIndex: 'usuarioAlta',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'usuarioBaja',
		            text: HreRem.i18n('title.publicaciones.condiciones.usuariobaja'),
		            flex: 0.5
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

   evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			me.setTopBar(false);
		}

		if(!me.lookupController().getViewModel().get('activo').get('pertenceAgrupacionComercial') ||
				!me.lookupController().getViewModel().get('activo').get('pertenceAgrupacionRestringida') ||
				!me.lookupController().getViewModel().get('activo').get('pertenceAgrupacionAsistida') ||
				!me.lookupController().getViewModel().get('activo').get('pertenceAgrupacionObraNueva')) {
			me.down('toolbar').items.items[2].setHidden(true);
		} else {
			me.down('toolbar').items.items[2].setHidden(false);
		}
   }

});