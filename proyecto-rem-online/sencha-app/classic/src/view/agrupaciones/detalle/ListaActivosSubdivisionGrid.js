Ext.define('HreRem.view.trabajos.detalle.ListaActivosSubdivisionGrid', {
	extend : 'HreRem.view.common.GridBase',
	xtype : 'listaActivosSubdivisionGrid',
	requires : [ 'HreRem.view.common.CheckBoxModelBase',
			'HreRem.ux.plugin.PagingSelectionPersistence' ],
    reference: 'listaActivosSubdivisionGrid',
	cls	: 'panel-base shadow-panel',
	bind: {
			store: '{storeActivosSubdivision}',
			title:'{subdivision.descripcion}',
			hidden: '{!listadoSubdivisionesAgrupacion.selection}'
			},
	tbar: {
		defaultButtonUI: 'default',
	    items: [
	        {
	            xtype: 'button',
	            text: 'Aprobar informe comercial',
	            //secFunPermToShow: 'ROLE_PUEDE_VER_BOTON_APROBAR_INFORME',
	            listeners: {
	        		click: 'aprobarInformeComercialMSV'
	        	
	        	}
	        }
	    ]
			},
	plugins : 'pagingselectpersist',

	initComponent : function() {
		
		var me = this;

		var estadoRenderer =  function(condicionado) {
        	var src = '',
        	alt = '';
        	if (condicionado != '0') {
        		src = 'icono_KO.svg';
        		alt = 'KO';
        	} else { 
        		src = 'icono_OK.svg';
        		alt = 'OK';
        	}  

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        }; 

	
		var subdivisionDescripcion = me.getTitle;
		me.title=HreRem.i18n('title.activos.del.tipo') + ' ' + subdivisionDescripcion;
		me.columns = [
			
		    {   
				text: HreRem.i18n('header.numero.activo.haya'),
	        	dataIndex: 'numActivo',
	        	flex: 1
	        },
	        {
				text: HreRem.i18n('header.finca.registral'),
	        	dataIndex: 'numFinca',
	        	flex: 0.5
	        },
	        {
				text: HreRem.i18n('header.tipo'),
	        	dataIndex: 'tipoActivo',
	        	flex: 0.5
	        },
	        {
				text: HreRem.i18n('header.subtipo'),
	        	dataIndex: 'subtipoActivo',
	        	flex: 0.5
	        },
	        {
				text: HreRem.i18n('header.dispone.informe.comercial'),
	        	dataIndex: 'estadoDisposicionInforme',
	        	flex: 0.3,
	        	align: 'center',
	        	renderer: function(value){
	        		return (Ext.isEmpty(value) || value == 'Rechazado')? "No" : value;
	        	}
	        },
	        {
	            dataIndex: 'estadoPublicacionS',
	            text: HreRem.i18n('header.estado.publicacion'),
	            flex: 1,
	            bind:{
	            	hidden: '{!esAgrupacionObraNuevaOrAsistida}'
	            },
	            renderer: estadoRenderer
	            
	        }
	        
	       	        
	    ];

		me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            displayInfo: true,
	            bind: {
	                store: '{storeActivosSubdivision}'
	            },
	            items:[
	            	{
	            		xtype: 'tbfill'
	            	},
	                {
	                	xtype: 'displayfieldbase',
	                	itemId: 'displaySelection',
	                	fieldStyle: 'color:#0c364b; padding-top: 4px'
	                }
	            ]
	        }
	    ];
    	
		me.selModel = Ext.create('HreRem.view.common.CheckBoxModelBase');

    	me.callParent();

    	me.getSelectionModel().on({
        	'selectionchange': function(sm,record,e) {
        		var displaySelection = me.down('displayfield[itemId=displaySelection]');
    			var persistedSelection = me.getPersistedSelection();
    			var disabled = Ext.isEmpty(persistedSelection);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    				me.disableRemoveButton(true);
    			} else if (persistedSelection.length > 1) {
    				displaySelection.setValue(persistedSelection.length +  " elementos seleccionados");
    				me.disableRemoveButton(true); // Solo permitir eliminar un único elemento a la vez.
    			} else {
    				displaySelection.setValue("1 elemento seleccionado"); 
    			}
        	},

        	'selectall': function(sm) {
        		me.getPlugin('pagingselectpersist').selectAll();
        	},

        	'deselectall': function(sm) {
        		me.getPlugin('pagingselectpersist').deselectAll();
        	}
        });
    },

    getPersistedSelection: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').getPersistedSelection();     	
    },

    deselectAll: function() {
    	var me = this;
    	return me.getPlugin('pagingselectpersist').deselectAll();     		
    },
    
    getActivoIDPersistedSelection: function() {
    	var me = this;
    	var arraySelection = me.getPlugin('pagingselectpersist').getPersistedSelection();
		var activoSelection = [];

		Ext.Array.each(arraySelection, function(rec) {
			activoSelection.push(rec.getData().idActivo);
        });

    	return activoSelection;
    }
    

});