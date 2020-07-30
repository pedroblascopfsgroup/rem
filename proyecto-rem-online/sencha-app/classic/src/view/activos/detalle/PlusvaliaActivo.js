Ext.define('HreRem.view.activos.detalle.PlusvaliaActivo', {
    extend : 'HreRem.view.common.FormBase',
    xtype : 'plusvaliaactivo',
    cls : 'panel-base shadow-panel',
    collapsed : false,
    refreshAfterSave : true,
    reference : 'plusvaliaactivoref',
    scrollable : 'y',

    listeners : {
	    boxready : function() {
		    var me = this;
		    me.lookupController().cargarTabData(me);
	    }
    },
    
    recordName : 'plusvalia',

    recordClass : 'HreRem.model.PlusvaliaActivoModel',

    requires : [ 'HreRem.model.PlusvaliaActivoModel' , 'HreRem.model.ActivoTributos', 'HreRem.model.ActivoAdministracion'],

    initComponent : function() {
	    var me = this;

	    me.setTitle(HreRem.i18n('title.plusvalia.activo'));

	    var items = [

	    {
	        xtype : 'fieldsettable',
	        defaultType : 'textfieldbase',
	        title : HreRem.i18n('title.plusvalia.activo'),
	        collapsible : false,
	        items : [ {
	            xtype : 'datefieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.fecha.recepcion.plusvalia'),
	            bind : {
		            value : '{plusvalia.dateRecepcionPlus}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'datefieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.fecha.pago.plusvalia'),
	            bind : {
		            value : '{plusvalia.datePresentacionPlus}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'datefieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.fecha.presentacion.recurso'),
	            bind : {
		            value : '{plusvalia.datePresentacionRecu}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'datefieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.fecha.respuesta.recurso'),
	            bind : {
		            value : '{plusvalia.dateRespuestaRecu}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'comboboxfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.apertura.expediente'),
	            bind : {
	                store : '{comboSiNoPlusvalia}',
	                value : '{plusvalia.aperturaSeguimientoExp}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'numberfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.importe.plusvalia'),
	            bind : {
		            value : '{plusvalia.importePagado}'
	            },
	            allowBlank: false
	        }, {
	            xtype : 'numberfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.gasto'),
	            bind : {
		            value : '{plusvalia.numGastoHaya}'
	            }
	        }, {
	            xtype : 'comboboxfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.minusvalia'),
	            bind : {
	                store : '{comboSiNoPlusvalia}',
	                value : '{plusvalia.minusvalia}'
	            },
	            allowBlank: false
	        }, {
	        	xtype : 'comboboxfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.exento'),
	            bind : {
	                store : '{comboSiNoPlusvalia}',
	                value : '{plusvalia.exento}'
	            },
	            allowBlank: false
	        }, {
	        	xtype : 'comboboxfieldbase',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.autoliquidacion'),
	            bind : {
	                store : '{comboSiNoPlusvalia}',
	                value : '{plusvalia.autoliquidacion}'
	            },
	            allowBlank: false
	        }, {
	        	xtype : 'comboboxfieldbase',
	        	name :'comboEstadoGestPlusv',
	        	referende:'comboEstadoGestPlusv',
	            fieldLabel : HreRem.i18n('fieldlabel.plusvalia.estado.estion'),
	            bind : {
	                store : '{comboEstadoGestionPlusvalia}',
	                value : '{plusvalia.estadoGestion}',
	                readOnly: '{checkEditEstadoGestionPlusvalia}'
	            },
	            listeners: {
	            	expand: function(){
	            	var me = this;
	            		me.lookupController().doFilterEstadoGestionByUserRol(me);
	            	},
	            	change: 'onChangeComboGestPlusv'
	            }
	        }, {
	        	xtype: 'textareafieldbase',
	        	reference:'plusvObservacionesGestion',
            	labelWidth: 200,
            	disabled: true,
            	rowspan: 5,
            	height: 130,
            	labelAlign: 'top',
            	fieldLabel: HreRem.i18n('fieldlabel.plusvalia.observaciones'),
            	bind:{
            		value: '{plusvalia.observaciones}'
            	},
            	allowBlank: false
	        } ]
	    },{
	    	
	    xtype : 'fieldsettable',
        defaultType : 'textfieldbase',
        title : HreRem.i18n('title.documentacion.plusvalia.activo'),
        collapsible : true,
        items : [ 
        		{
        			title: 'Documentación de plusvalía',
	        		xtype:'adjuntosplusvalias',
	        		reference: 'listadoadjuntosplusvalias',
					colspan: 3
        		}
        	]
    	},
    	{
	    	xtype : 'fieldsettable',
	        defaultType : 'textfieldbase',
	        title : HreRem.i18n('title.administracion.activo.tributos'),
	        collapsible : true,
	        items : [ 
        		{
        			title: 'Tributos',
					xtype:'tributosgrid',
					colspan: 3
        		},
        		{
        			title: 'Documentos de tributos',
					xtype:'documentostributosgrid',
					colspan: 3
        		}
	        ]
    	}
	    ];

	    me.addPlugin({
	        ptype : 'lazyitems',
	        items : items
	    });
	    me.callParent();
    },

    funcionRecargar : function() {
	    var me = this;
	    me.recargar = false;
	    Ext.Array.each(me.query('grid'), function(grid) {
		    grid.getStore().load();
	    });
	    me.lookupController().cargarTabData(me);
    }

});